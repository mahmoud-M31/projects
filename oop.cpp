#include<iostream>
#include<vector>
using namespace std
struct MyStruct
{
	int x;
};
int main()
{
	vector<int>arr = { 1,2,3,4,5,6 };
	cout<<arr.at(2);
	
	return 0
}