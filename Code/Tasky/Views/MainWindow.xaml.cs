using System.Windows;

using Tasky.Views.ContentViews;

namespace Tasky.Views
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            ContentSite.Content = new HomePage();
        }
    }
}
