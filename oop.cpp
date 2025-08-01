#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cmath>
#include <map>
#include <set>
#include <unordered_map>
#include <unordered_set>
#include <queue>
#include <stack>
#include <deque>
#include <bitset>
#include <utility>
#include <limits>
#include <iomanip>
#include <sstream>
#include <tuple>
#include <numeric>
#include <functional>
#include <array>
#include <fstream>
using namespace std;
#define _ ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);
typedef long long ll;
class machine {
protected:
    string  color, model, pallet, type;
public:
    machine(string t, string m, string p, string c)
    {
        color = c;
        model = m;
        pallet = p;
        type = t;
    }
    void pintmach() {
        cout << "Type: " << type << endl
            << "Model: " << model << endl
            << "Pallet: " << pallet << endl
            << "Color: " << color << endl;

    }
};
class person {
protected:
    string NAME;
    int AGE, ID;
public:
    virtual void set_INFO_PERSON(string NA, string oth, int AG, int id) = 0;
    virtual void PR() = 0;

};

class Employee :public person {
private:
    string joptittle;

public:

    void set_INFO_PERSON(string NA, string oth, int AG, int id)override
    {
        joptittle = oth;
        NAME = NA;
        AGE = AG;
        ID = id;

    }
    void PR()override {
        cout << "Name: " << NAME << endl
            << "Age: " << AGE << endl
            << "ID: " << ID << endl
            << "Joptitle: " << joptittle << endl;
    }
};
class normal_person :public person {
private:
    string  statueofparking;
public:
    void set_INFO_PERSON(string NA, string oth, int AG, int id)override
    {

        NAME = NA;
        AGE = AG;
        ID = id;
        statueofparking = oth;
    }
    void PR()override {
        cout << "Name: " << NAME << endl
            << "Age: " << AGE << endl
            << "ID: " << ID << endl
            << "statueofparking: " << statueofparking << endl;
    }
};
enum STATOFPARK
{
    Vip = 1,
    Normal = 2,
    Persons_with_disabilities = 3
};
enum EORU
{
    employee = 1,
    User = 2
};
enum MACHINE
{
    CAR = 1,
    MOTORCYCLE = 2,
    BUS = 3
};
int main() {
    cout << "Chosee 1-Employee\n2-User" << endl;
    int chosse;
    try {
        cin >> chosse;
        if (chosse < 1 || chosse > 2)
        {
            throw chosse;
        }person* p = NULL;
        if (chosse == 1)
        {
            cout << "Enter name, joptitle,age,ID \n";
            string n, o;
            int ag, i; cin.ignore();
            getline(cin, n);
            cin >> o >> ag >> i;
            p = new Employee();
            p->set_INFO_PERSON(n, o, ag, i);
            int c;string h;
            cout << "Chosse your Machine\n 1-car 2-motorcycle 3-bus\n";
            try {
                cin >> c;
                if (c < 1 || c>3)
                    throw c;

                MACHINE ma = static_cast<MACHINE>(c);
                switch (ma) {
                case MOTORCYCLE:h = "Motorcycle";break;
                case BUS:h = "Bus";break;
                default:h = "Car";
                }
                string M, P, C;
                cout << "Enter model,pallet,color\n";
                cin >> M >> P >> C;
                machine ca(h, M, P, C);
                p->PR();
                ca.pintmach();

            }
            catch (int r)
            {
                cout << "Your chossen " << r << " is invalid";
            }

        }
        else if (chosse == 2)
        {
            cout << "Enter name, age,ID \n";
            string n, Type;
            int typ, ag, i;
            cin.ignore();
            getline(cin, n);
            cin >> ag >> i;
            cout << "Chosse type of parking\n1-vip 2-normal 3-The disabilities\n";
            try {
                cin >> typ;
                if (typ < 1 || typ>3)
                    throw typ;
                STATOFPARK ST = static_cast<STATOFPARK>(typ);
                switch (ST) {
                case Persons_with_disabilities:Type = "The distinguished individuals";break;
                case Vip:Type = "Vip";break;
                default:Type = "Normal";
                }

            }
            catch (int s)
            {
                cout << "Your chossen " << s << " is invalid";return 0;
            }

            p = new normal_person();
            p->set_INFO_PERSON(n, Type, ag, i);

            string M, P, C;
            cout << "Enter model,pallet,color\n";
            cin >> M >> P >> C;
            machine ca(Type, M, P, C);
            p->PR();
            ca.pintmach();

        }
        delete p;
    }


    catch (int u)
    {
        cout << "try again and chosse the correct answer\n";
    }




    return 0;
}
