Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8319314294
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435853; cv=fail; b=kRtJ4VMK9vKFkoYSc2pEwkLECh9H4BL4q9j3BjTpJflp1Zdb2FCdkxf26C53EtqTSUBtAkAKvS+ynM2N0Q8cF/sKbOjd6tMZzpn0nGRwQ67sKMZgig3KdWzaqlcLH1sVar6k44vx0Url5x0emSusoz0+w4TB047vUbam4FUZfGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435853; c=relaxed/simple;
	bh=lSEMEvqfj6TA8Z7AFN33vJd04hrpuean2xSsWzNk2Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ij15NOP3Sh1WJ59NW2cHxv2WMCXfGB3idyb9ne+7IpsSv1F29iaSoM2oQtuS/JhGO9t8P2y9SPmWVoAE+0wAl5umvaM/eaYEsrQFjbmq+4a0HdgUpE6mfR7OhEzd5vvUBn0b2a07CShwQN0prSBTpt/DzBUFJS+Yq6omqdOwUAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rLYv1Oj4; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rLYv1Oj4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDpG8G+yL/T/NOv9JVnNo1/6+Bgn0oc9k46Wz1CVr0WSgvlQWlDLG8l3A5OdUuKq3E/XXMNHp5MNzyWjd/DcCdxeldXcUEUJI3zqpEZgbz3xazbIpmg6y14Yw8Joe/ZNW+SSlPvUPBZzjAEHHp+2jqGCYGKkUHv1fq7e7DQ9o/zKeDl2IP28FDeQjDPn6o9ebjJ7tlk+vEGVNJZbYh+H0Y088U+1+k8MwvJdaYw/O792+CNaVq+cBszLkabKpaMZELox3TIflW8Lzz/uX5Jh6qpkffDGCuN0m47fIIJ9JyqthCyAEHJO6Jouxj9a8BPjqsvFluPBSVinhtdjTbZBPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3xn7fYNYS4Jtm6bZr51fqoA40jZaUxKzpyvaUfgYI0=;
 b=BtP875vPrKshJSpZvuvk9+w7uDPplT5cgHvRJ1UhDiwVmw5a5NUZErwhqeaFISFtbbPMUwg5n5JDASAvz31NjfSfh4qvJoc7o29mRltJdDnI+ys7niNNpRz8TMLRazTMou9++SxKMtbMYp57h/XnAtqHw6Wx9KJEjhiuPjzuqiwwivRKk89UCZ9vVyUrSUse+l0f0zRbQx2JuYZqvUQKKb//H+ZWR5WEGrwyq1pcSGRw7mk0rk3dAiJJEbBdGdUx7rpRxGcmUJj442emOGOwGSicZouwg/Phyc5oJg/ScCPC/DwLoNFWwzvo/pjFuCkltIFZTFS/eSMR18+EunTqPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3xn7fYNYS4Jtm6bZr51fqoA40jZaUxKzpyvaUfgYI0=;
 b=rLYv1Oj495G5AtX46786DfEcWBHJs4AI1mfuR0Ijl0Vl548dE6+31lJkz/KkNhFcJnS5R/BpoQmLoT+8387WSpyrvOM364pRRdIieoj9DHien5lIM+1wmKjVWCueIkAKcEN7Hsb2JJNIRutvBqtUE1kqTuY0lIWe9Xg4QaTXtCiQTZ2QzBXIbGHlFIStEV/4iBy/AY+vfkCzV8eSSv21W/Z9VZbHnZI/UR584fDUUysLrlYkEGVNvmByDaECO0WumkGycDaZd0jhIVayG/PxjFVSHahX3VJTC42FV1tulZ6w3RcdFflfcA8D63D7s7RNfwHjo1jN0jpubHnxWDqBYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV8PR12MB9153.namprd12.prod.outlook.com (2603:10b6:408:185::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Mon, 3 Jun
 2024 17:30:47 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 17:30:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH] sysfs: Add stub sysfs_bin_attr_simple_read() for !CONFIG_SYSFS
Date: Mon,  3 Jun 2024 14:30:45 -0300
Message-ID: <0-v1-44baae71b833+ab-sysfs_simple_read_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0473.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV8PR12MB9153:EE_
X-MS-Office365-Filtering-Correlation-Id: d96bd659-69d1-4d94-8f4b-08dc83f2e771
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZGsGUgM5Dejs+kalWgLWVHKsOa1dkq41+TXF41CQPvsAn2CCrE5bv2Bw5JBC?=
 =?us-ascii?Q?D2eGkTIEIUrm3rxl3tGmTG7VOik6WqmSHS8tPDy7bOBnmlJE9WJ5UPdTRrR7?=
 =?us-ascii?Q?UsSaQiS75sT+HF37kJtFVvcOsu+9Jm3u3BVgZCNWr3gqTBT2nTyzVRuy9EtJ?=
 =?us-ascii?Q?DRQ/yQjAEk+zy1O4gnnOhP9JSNir3sb7CPpXt9CcW6yuAlKLRecd1up6EL/p?=
 =?us-ascii?Q?Ad6g4o45eXrvgd9JFhZj+6aG1Sqp73DJU2CEZz03Hyi6vnaR3rESeOJiVVyW?=
 =?us-ascii?Q?CBieH+lSBbqZYCM6VHnj110sJa5FQqUl6HDaVVKl6qvAh8cDYvDMTdLmUppN?=
 =?us-ascii?Q?YqrYX9X3Av1S2lXgflN7S0ozjUVrBg5cwYicQDtti+uQc4IKFRud3qaZzMtE?=
 =?us-ascii?Q?l48++wWavNEy6LHID5ORfBXv1LNFQWL1UaDWuW9P/SRrXveVRU1A8Ix+ZEzc?=
 =?us-ascii?Q?w7I7hbYSgMObXxSoCSPnuJ/5OD1apj1eOyKJwlJKHlO4seLc3QmXILdu8L+o?=
 =?us-ascii?Q?4jz0tL2dOpjnb9qqZCf92UvhP0XebKPr6/mQPG3qC26jeOjgYXL0/026TdU0?=
 =?us-ascii?Q?URhK6IbK+Qh28DrcstnBUfLPQqdS/TTLaXDkQuAxbF/MuPwwbUJ95sdw6Qo/?=
 =?us-ascii?Q?S78yqxrWA7D5yf5xocdaqo2//2id1XACUh4AvUfEMaf0EEnw/nhnijalj8ah?=
 =?us-ascii?Q?HSpu+jNL7BLbaaZzoW3898ZG5UKgB/Bk1Gg82aM847NUcpi+CqbONF5SS7v5?=
 =?us-ascii?Q?F4opDKOzhcbeZGElGxfkEuO2/Sd0xBCUzDLad0S9HZeivceeaqYx8s61ccf8?=
 =?us-ascii?Q?WUX4/NPepgLUiPU2/9pZog/nNCeftGB2HR/AYk6VaxZSXJXnX8J+LmzpAayH?=
 =?us-ascii?Q?Eu5P8DZXjpc5e6YmIcKtccTl2lBeuy9a+BsF6iyTRzUdhHsFUmazkBvkY1Jl?=
 =?us-ascii?Q?KhirLW3XegcztKQcsAqEccggxHPaIFWnzPpXou7bcMvm542ZkkM1P3Hwlh7M?=
 =?us-ascii?Q?7DiUXHrZHgFyMAfmkg6STAbbBORzfLfphrVRM5EafLzBGseCxfLGq6RCtt05?=
 =?us-ascii?Q?SqIlWF7qdmLXJt8KPj0H9hPJsJWXsoP+0ARheS7FPbwoI8jepEgokP6AO29F?=
 =?us-ascii?Q?b6AFHF8IZ7R8pS2xmFNHVW7ZpAxZgcv9xw+Y4okm+HqfIln/7bXhhovjd3aJ?=
 =?us-ascii?Q?+pYlelUITtr4OlSRrFVeCAYQjKSS0kGnIPxK20sXXDT4WdoNV2Fda8+9TzM9?=
 =?us-ascii?Q?KgXtMa6Ba2EAhAT127YpNEYWNurtYuVzFa9SZKmP7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RIFn/ufITVfWoO7AeiPMWIMPIUI7hGml5+0i79CceikT2GypO0+fU+95Ioiz?=
 =?us-ascii?Q?3JLm7QxexdOlwTRPLhsdKe9yNMpXXKMhLY+cBNtWKspH0gFdFOLD/WI2gsVU?=
 =?us-ascii?Q?MaGb1crs72dmQNnFgZ+zMiW9e+pBQOltg5Siq55tvhzkWS3JATmCRBN9cJBt?=
 =?us-ascii?Q?3TYAG2VJY+zLKTsvL0W4leY3njnprpD6gGmUyW5LJMNRhmGmWhpYL1KXLbtc?=
 =?us-ascii?Q?IyEiOPdB8PIpohrGfk0NoqDN26jQOiweWXVXbALShjx8FXNRrXr+hdV+nHgh?=
 =?us-ascii?Q?e1UUkiNLsMOwJlgtn/wFhXLFscFxLO2nTaA7Je61yC/hr1CGumgXOrj1aiIs?=
 =?us-ascii?Q?wTWXENsuPeuVv13Buw/cfrLGPg/Yp95CGxbBPGTaafVoTRDSnVkwRVqBLaoz?=
 =?us-ascii?Q?kbH3FKnoT3hC6SIZeXnXfkeapbs73KogLYQVcl/LV2PGXXb5WeyPUvLIRv92?=
 =?us-ascii?Q?GV5abmN3N1c6uw+idAppfc0CxVT6TZE4KxsrTcD4NKY6/ACJj+ffyvOzJ/M8?=
 =?us-ascii?Q?tOiIRAaqS/o306DP9XcAKWKIOrs4Sw2Abo9WvjLiTUFfG0FQloev99Filnp4?=
 =?us-ascii?Q?xf/0hLIbALHm2dYrClA8wkTI7FnVpv425B8uRWfGQV08ZUKHy/TofxZDV2jN?=
 =?us-ascii?Q?AZ6aHRs0NlnHMUb+cGTBSrUJznptHgy8iHJvAxrdeF1nTadqqbG/xoUsMdA3?=
 =?us-ascii?Q?laHJkDVEQeRavX+O+uMNOKCmBGz0OeMN+RhV9EgZhGUjqGEsP6cOjPGp5zYm?=
 =?us-ascii?Q?ii7x0Q3wIFegoTwn25/81I+E8lKgSDNDyHytUxOWRXOpn1gKn6NQsInvezP4?=
 =?us-ascii?Q?6MLzgBY8nV8OsR9/7t/B8s3Yug8NVvzgyaOlBYBEqiHFrSJmcK758K1dGjnO?=
 =?us-ascii?Q?UUyVBI9HD6159YNSpgJe7pY69GMmZLKXIrBdZCe+Rb5/Eg7tHdGdQD1IDsE8?=
 =?us-ascii?Q?b+VNiiO70/6BYJOnE7BP13f011VEXUB4MfEvuxScUH5MQD91ops/1SaQ7SbK?=
 =?us-ascii?Q?JUw9EDOLcm4YwzOMzVKpkbU9ZApnMqHRWY4PQAr6Wws1ChwdJPpsqHs4aWVp?=
 =?us-ascii?Q?NQZWg9NETthEoA3OOvgi82ATtBFxNRPxhHiEsQGH6Ar3dxLzQLMy64xo9TKO?=
 =?us-ascii?Q?Ifs/fdzmw7zWiwSTDwoaofc5wj9oXZUPpG2Ucou4wi+Jjcr9FXndOEFPAN/e?=
 =?us-ascii?Q?pD3UFp2kYh7Kp7Jnht7f8AJKS/pq+SiNi4rLbrGm2cXsvbT9tTMXJ0pPIXjP?=
 =?us-ascii?Q?CkGYiWXDVxs1JNCWCYIBi3j4kzYdT4VBWu15ddM2A3RnssszW3j/VNu09448?=
 =?us-ascii?Q?yZ4T4ZN/qycDYw0ms7+WgRfi72+fEv8UzIUs0VdLR9voEz0MCTtIzH2xlPLT?=
 =?us-ascii?Q?SMODUEDQetvmbO4gEXEJr/RN47vYMsCQm7I109ZbEmWu2VFihelMdTFFm5fP?=
 =?us-ascii?Q?sOEr4ypbKaoNMUfB9g/vPUwSA81IZrrE+aQTQnBNDnDdNJB5HeHv67c+m3T8?=
 =?us-ascii?Q?Bsyuhnr49vDsK2KcFQv6DdQzFrYPP8J5UgRhceQIob4BPF4PK/3HWTMcQPGQ?=
 =?us-ascii?Q?LwjW2J0Wjs2+QY/Hwh1phrcNtwahJTHPLHfG88dB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d96bd659-69d1-4d94-8f4b-08dc83f2e771
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 17:30:46.9067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/xFeBFZgkf7HTK9TlV7EfzsIz0SClUbNtKjm6++SCUHsL+gCoytGGYYMEKjPTP8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9153

At least dmi_scan.c fails to compile:

../drivers/firmware/dmi_scan.c:764:8: error: use of undeclared identifier 'sysfs_bin_attr_simple_read'
  764 | static BIN_ATTR_SIMPLE_ADMIN_RO(smbios_entry_point);
      |        ^
../include/linux/sysfs.h:383:41: note: expanded from macro 'BIN_ATTR_SIMPLE_ADMIN_RO'
  383 | struct bin_attribute bin_attr_##_name = __BIN_ATTR_SIMPLE_RO(_name, 0400)
      |                                         ^
../include/linux/sysfs.h:376:10: note: expanded from macro '__BIN_ATTR_SIMPLE_RO'
  376 |         .read   = sysfs_bin_attr_simple_read,                           \
      |                   ^
../drivers/firmware/dmi_scan.c:765:8: error: use of undeclared identifier 'sysfs_bin_attr_simple_read'
  765 | static BIN_ATTR_SIMPLE_ADMIN_RO(DMI);
      |        ^
../include/linux/sysfs.h:383:41: note: expanded from macro 'BIN_ATTR_SIMPLE_ADMIN_RO'
  383 | struct bin_attribute bin_attr_##_name = __BIN_ATTR_SIMPLE_RO(_name, 0400)
      |                                         ^
../include/linux/sysfs.h:376:10: note: expanded from macro '__BIN_ATTR_SIMPLE_RO'
  376 |         .read   = sysfs_bin_attr_simple_read,                           \
      |                   ^

Since the only declaration for sysfs_bin_attr_simple_read() is inside the
"#ifdef CONFIG_SYSFS". Add a stub to the #else section too.

Fixes: d48c03198a92 ("sysfs: Add sysfs_bin_attr_simple_read() helper")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/sysfs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

I don't see a patch for this yet, but I did find a 0-day robot complaint:

https://lore.kernel.org/all/202404200345.eGdn5uxW-lkp@intel.com/

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index a7d725fbf73937..e672a927d650a3 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -750,6 +750,15 @@ static inline int sysfs_emit_at(char *buf, int at, const char *fmt, ...)
 {
 	return 0;
 }
+
+static inline ssize_t sysfs_bin_attr_simple_read(struct file *file,
+						 struct kobject *kobj,
+						 struct bin_attribute *attr,
+						 char *buf, loff_t off,
+						 size_t count)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_SYSFS */
 
 static inline int __must_check sysfs_create_file(struct kobject *kobj,

base-commit: c58a77fe0ba1b708759338ad8bd3828b75a26035
-- 
2.45.2

