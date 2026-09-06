using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace GRUP26_GÖREV8
{
    public partial class FormFirmaAracListele : Form
    {
        SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog = Grup26; Integrated Security= True");
        public FormFirmaAracListele()
        {
            InitializeComponent();
        }

        private void FormFirmaAracListele_Load(object sender, EventArgs e)
        {
            baglanti.Open();
            SqlDataAdapter liste = new SqlDataAdapter("select * from TabloFirmaArac", baglanti);
            DataTable table = new DataTable();
            liste.Fill(table);
            dataGridView1.DataSource = table;
            baglanti.Close();
        }
    }
}
