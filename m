Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A2A1CE717;
	Tue, 27 Aug 2024 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724777213; cv=fail; b=HSoKhZydEb9eowpMi9Q8wYggL1szPEuxT54TXnH7BN/uKyrtRsOja+LLIiJiXPTps4tAS+rkg+eBcDCP5dRWke8Bb6ApJQaDrCeMVfoVVEr7bqnvDlNWPshENl8ROmzkWdzHB7JSJWcAD7z6HhfNlRLpn0z74WY4Z/5D7AhZpbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724777213; c=relaxed/simple;
	bh=GwyM5OUxGDvjfoajBsDJO6CQzVtku6s9Fr4MziX4TiA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=m7df1MYGfrd+uxEsuyOpUK39yRu4+vDvqvWxG/5VCe0uEzKje5xVnCqLmNldnAjNBc1m/ViDBMuaWxVudo2drCwN0kvR86p1OhA37mlajdlNtO3u/E5R5NiTlQJysbgnW8Y/eSbJwZN6Cb2ZHV/NMfWuyyL8FShrbaVdtou4dMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GClE//aq; arc=fail smtp.client-ip=40.107.95.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GClE//aq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ma+pBJQOmx9czTo03Smc+tUkZO7t9QhNTMAVFzqwtmCUqHJvOa1rBY48qQM5H7M7NMu+A78W9WsQ6t3MyAzsCNbhiX9apQimgEkWql27UM9DI+QoUn6BBiLh88t5vOmxrx64QlYxMVxpYKK+wrwzTNgUTPbrn8CzL5gUO0uQaran/DI+31zZu5tPNC/pID5SAz19E8z4kBLT9rnVDffZnYN9zRuHaXazHN+cBdTgT1WVFioJZQ9WKi+t+lH8P/lvXw5yaOtbEp7DiZP92iXCUNdTerOEaMps85DVqzLWfkz/XrLQOXTJdHgbOvUmzEz9fEGaXRlZJmJoADEUYYCXBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jou9JNFyTiOaBeq/xdo+EQrNuGCkKvYmdm6QTdyxgaE=;
 b=gfJqG6G84Wi+Mmu9mKzIsQpyAhMa+ibiwUu9cPZkozXS95ZEanq3b8U8kREeAJHOnUMx8jmOnDo+nsMNC4743NJ825rnxukwVfxWLBrgnWPD2LaEGJWhO4iAjnt4beCCVPB0UYw22PIvdvrOUR79gc6NiloYjcACiZ1KdrL3EkgSBZ2NwABt2kvIN5dUmwheYyPxeHXRY/KOqi5TeEt34iCU/pgfRoTimp+dgdIJnWRlJye2iLjGZ6G5zk39eCKGPC0h4pIE3+pfmzfixPQRW59paZF6bcQnxlRJnQHWgu6Ab98gDmPX2ccEtAJjhrZqVR+nbxVgBbse0VA2KFf+sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jou9JNFyTiOaBeq/xdo+EQrNuGCkKvYmdm6QTdyxgaE=;
 b=GClE//aq/KwG/yANCiih4gmmjGuPH5YBcDNGUJvMQS5czZdhYtA/jcp3oyS/o+WSHc8MVW3/im6hokaLGk8V7Diif0p3USOZD0kGbetLrwID+rYonM74Qv8PDTUvARwpeaPzXCcA6WVH6xw4VrAPax4OoG9CxK/pAs8qECe6lWaZs1SC3nC6Z47GWXx8qo5BFtYevCisbf15/UxW6LWNTjbPjGL846d7XpApBGzMFaXpq8lKscSPzqPeZJ6TXaxqQfeHQ7U24rXpKu5re2+0UIUaOniIqpHnJyafuxerlQd7Z9HHOuBi/WsI0U0ClEmLW7aOH2PQxmULGhcG0xDuNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SJ2PR12MB8977.namprd12.prod.outlook.com (2603:10b6:a03:539::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 16:46:47 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 16:46:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	syzbot+16073ebbc4c64b819b47@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH] iommufd: Protect against overflow of ALIGN() during iova allocation
Date: Tue, 27 Aug 2024 13:46:45 -0300
Message-ID: <0-v1-8009738b9891+1f7-iommufd_align_overflow_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0601.namprd03.prod.outlook.com
 (2603:10b6:408:106::6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SJ2PR12MB8977:EE_
X-MS-Office365-Filtering-Correlation-Id: a7664690-e2eb-4c84-17e1-08dcc6b7d73d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TFJ/yuFOwqWUYZoKdleEc08K9d0Rd5QiECOZswvYWB+bdmJXj815lMz58ivv?=
 =?us-ascii?Q?YDqmHJylSS8qHS2L45AJ/lf35SUWy+VQJmfjdou8qt5y3U9zeB0XXjjp0P3U?=
 =?us-ascii?Q?oajAgzcjNRqcHagsG1pioWmTMCZ41PkHycUl1wM3Tu2B+RK8q9gB/6zvO17l?=
 =?us-ascii?Q?yIjI0kITnPJP4yicBZjiDbxjtEO1J6CqMFf5VzNWbXFJuz7jdSdJDZnF+fc6?=
 =?us-ascii?Q?2tWb1Y877AbWSKZ3KZKpR/AI9kPc1zFhxCiU9Q0DORZAF3O9TC9kv0NhPKr1?=
 =?us-ascii?Q?JE52foaJ8wuaPT15rtf3LHQL6bgNPnhT8PMWRSO4MZ+qWhNyroWAgaI8Fhpc?=
 =?us-ascii?Q?Mh1LdFQ8/c/b1sNvE67/OEUBDa5f4IRqbSTa/kGEEuYbCu2mNg5FA+kFvxAb?=
 =?us-ascii?Q?xXNrGFiaorKrv4fE5DXeO7pw8Zc3g2zlHGNGjndYEw7FkUf0IC3IU1pnnKuu?=
 =?us-ascii?Q?/8TUo15Z949v9aBCzz0w2B3u0zWmuvdtFuqevbQ5eoo7t1L2o08aBew4pCHh?=
 =?us-ascii?Q?70qBgNTLEIpkesBB9YnqHvn0+TaoLm5fow7jGZuqs/Gi18RZUB1wyEQZxsS8?=
 =?us-ascii?Q?2j3NcdbaG7XQGufwqqDTxwsussnairVFzqlf5MJjPaDIyhbHCzYRMueK+AoJ?=
 =?us-ascii?Q?Tsie/5PkxEvfBIGLqrCOIBTO/wj5u/MreQHu8E41dIAZ4KAjGj0L3llU26uu?=
 =?us-ascii?Q?JIP4lLsnHSvF6lqfCEk58n1KhzqJyWAN3Ax1GVf6puSyDePC9yXEZs1Xi483?=
 =?us-ascii?Q?s+9TJjyKAgS6gfQbuLEsL5wRpF/KW2noPz0YvB03xgzc3FyQpz3hbfx7CSbw?=
 =?us-ascii?Q?0BOxDJtGnkVBdia5m1F0JCcWz5JVSBmiAxStx1ti8zpmWfUmhubShwK0IVIr?=
 =?us-ascii?Q?ldLTZJLKV37N8UW4JglZTkKr+9WLnNBPJQ0+Y5ToOaWVja7vtmBjUHNozKZb?=
 =?us-ascii?Q?wUJslQZ7z1JFN2w68cZcCA49dhIcrdq2r4a9BzKDkXAvbyF95aZVaR7raOut?=
 =?us-ascii?Q?MGvxxNKNGvIeEAwLMbYnndmSX0ntLc02rlxgM8JvpW8qOUCcba2sbZQHoSFm?=
 =?us-ascii?Q?jWU03gl9oFNWk5S1SzYB0feCzMspVNiO7Ko31tDJbjEEY5L4jA7sJti2Oq5I?=
 =?us-ascii?Q?Yrm2FHvDFsaEkKnfJh0PjrmFUfuLNX1GSzFSRyZu+wzOe5419QQyXGPhB56U?=
 =?us-ascii?Q?1uIl8NEKu8xRCY85mf0IivrteCmvJj+taVyDbKjpUIKwHkv4aRbXRVXbfvdA?=
 =?us-ascii?Q?mjIS+pFPz6j7UAGWk1wJkzfgKL/At/S0cdCkyPbYB/aPnUs/mV/pbsSEe786?=
 =?us-ascii?Q?cL8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HWKZO4+02KOkcBTwwEIIvGV7QKzh35HKoMx2ZX/VJoMrYpw/S2zgvU3BkkOl?=
 =?us-ascii?Q?obD1GznoWHPkwj2kLwQiK4C8O4d2JPj4hOfy6AH2/Y/CkUFbEyplYWc/viJm?=
 =?us-ascii?Q?RHUsjQv9dEIt8+fn1ahL1C5Ift1HNm+W4t3I0+KJ6+EAx/eHRjU5D5M7y3lR?=
 =?us-ascii?Q?5XvZHGtB+eVkqtI8+CTQRmdSvblm2EuEV9goDbL7oNWeepBv6aaWLlMlU/3I?=
 =?us-ascii?Q?XbGYCQOMOgYN6SooEoHWkzZwYMd5BNTkxSdNhHZDyDa8lQKvnkV/if1HUj3d?=
 =?us-ascii?Q?PgYAs3froFESREpHkXCWfb3raRtClljgDkr9try61/R/CsR+XAZ2uAxpYZDM?=
 =?us-ascii?Q?O+Pw8AFEt2eBxa8zzxEJ10BQgnOjcUicT5bfHS0ZfGO6FiJN1agaoRnG+KDv?=
 =?us-ascii?Q?3DbjLAqMx6SWiZAGpcJxxg74iaKogctQKJ1KdSQEJjk/ehFUgW/iJg5PYkX3?=
 =?us-ascii?Q?BvSWvrPdLdObZS5gtBkGYXgTDn87gefGoDclgIpd1yR7J8YaTBWWuaWS/eRR?=
 =?us-ascii?Q?cUxC/OBshMticnCq14WQ8macHbJTA316CW8ZtnCalsxFn9MAqvUS03+55dfB?=
 =?us-ascii?Q?+AsSLdo2D5QltSJ5wxR01fmtsuAej2ubPAKix1yr3A8ojzTJ1hK6EqIyzfXW?=
 =?us-ascii?Q?harHhWAZt8+D6bJDoJTxS5S8NsNcC2rHFcBckGmI8APxW2F3kwfm+efRPf4n?=
 =?us-ascii?Q?NP7dGVYR8OQRg75cY7Gsnw2krLd6bwK3sEH41B2hMXiIMSdFpA7x3JxhtK3/?=
 =?us-ascii?Q?Nda/4KAD96vKj0XNYDwdnlzqvKIf/C/uNOWjY47TZtPCxFSkwgA26yGmVDo5?=
 =?us-ascii?Q?yCeB0mLmfTKoKGMCTW5kMh+u65CqWdP+vzF2x1LruMBLeTTGQQspLswZXMWw?=
 =?us-ascii?Q?qbUfz+ikQuucH4yJUdKnsJLa207TWld6i873BR5F4z1PZuYIvYiDbIZxm0no?=
 =?us-ascii?Q?i9W/UqD5piNxc9foOBdu6akF/cvJitqgh+OY+jS6/5UdjEeU8+X4omWkc57D?=
 =?us-ascii?Q?VmDFk/qmw3m1bMZmhmfhqA2ulhqY/Cl2dmBTT5w4eq9BTJSoVQBSeYa6rxSN?=
 =?us-ascii?Q?QGRXRv9bGfb8SF1jSJJPOn82CcHsqWO5uSWxp/h1kQCh2D7wjSXqAtObdG/w?=
 =?us-ascii?Q?BkFRh2RcNpKDSXSOVwRqiOIPjPHERM+P1euFaQyzVpwkHVDNyU10CgKzs3mB?=
 =?us-ascii?Q?7rvXion2nrjIYDQ5iZJaFfHfE/b9VMoPAHepMcfIW3K9yX/bOgUBe14XPAaN?=
 =?us-ascii?Q?0WAHAMeuHFqxEzN9+N/sbcgArgC4mUoUuLvBVmd6YW7t4C0zAC/SUlxuUuDw?=
 =?us-ascii?Q?ty+6vhoYxwbeOAZJZZPtFJ2qvXo2wqQd69/0U/fMcw31nUt63l2UpwZdlTGj?=
 =?us-ascii?Q?vQHEXQEP6LYnnfq1PyJ27BMlQxxVyws0Dq7TT7g07Jxne8FqoSEeFmk9obP6?=
 =?us-ascii?Q?DxxfhDCHR30Mbh+GBKCSoz/FzcY7qOWiiZIWnvR12ZWYIje97KwBfNNtusot?=
 =?us-ascii?Q?2WeTfURhZJ3LvnivmiQJ2ZjjAqNLWWMLOzU8E/OSyzt8zddZOfZ1qiXXGJQc?=
 =?us-ascii?Q?uu8rZTKvRVJliSvn/ssM6y7eesRrfwzLAnEsDfSH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7664690-e2eb-4c84-17e1-08dcc6b7d73d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 16:46:47.4133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20E0snE5XL7iS18TJSWqHeLJc7NEvFoFaWsfKWXpDGlWR3snUZdeIx+8R03ZNuLJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8977

Userspace can supply an iova and uptr such that the target iova alignment
becomes really big and ALIGN() overflows which corrupts the selected area
range during allocation. CONFIG_IOMMUFD_TEST can detect this:

   WARNING: CPU: 1 PID: 5092 at drivers/iommu/iommufd/io_pagetable.c:268 iopt_alloc_area_pages drivers/iommu/iommufd/io_pagetable.c:268 [inline]
   WARNING: CPU: 1 PID: 5092 at drivers/iommu/iommufd/io_pagetable.c:268 iopt_map_pages+0xf95/0x1050 drivers/iommu/iommufd/io_pagetable.c:352
   Modules linked in:
   CPU: 1 PID: 5092 Comm: syz-executor294 Not tainted 6.10.0-rc5-syzkaller-00294-g3ffea9a7a6f7 #0
   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
   RIP: 0010:iopt_alloc_area_pages drivers/iommu/iommufd/io_pagetable.c:268 [inline]
   RIP: 0010:iopt_map_pages+0xf95/0x1050 drivers/iommu/iommufd/io_pagetable.c:352
   Code: fc e9 a4 f3 ff ff e8 1a 8b 4c fc 41 be e4 ff ff ff e9 8a f3 ff ff e8 0a 8b 4c fc 90 0f 0b 90 e9 37 f5 ff ff e8 fc 8a 4c fc 90 <0f> 0b 90 e9 68 f3 ff ff 48 c7 c1 ec 82 ad 8f 80 e1 07 80 c1 03 38
   RSP: 0018:ffffc90003ebf9e0 EFLAGS: 00010293
   RAX: ffffffff85499fa4 RBX: 00000000ffffffef RCX: ffff888079b49e00
   RDX: 0000000000000000 RSI: 00000000ffffffef RDI: 0000000000000000
   RBP: ffffc90003ebfc50 R08: ffffffff85499b30 R09: ffffffff85499942
   R10: 0000000000000002 R11: ffff888079b49e00 R12: ffff8880228e0010
   R13: 0000000000000000 R14: 1ffff920007d7f68 R15: ffffc90003ebfd00
   FS:  000055557d760380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00000000005fdeb8 CR3: 000000007404a000 CR4: 00000000003506f0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   Call Trace:
    <TASK>
    iommufd_ioas_copy+0x610/0x7b0 drivers/iommu/iommufd/ioas.c:274
    iommufd_fops_ioctl+0x4d9/0x5a0 drivers/iommu/iommufd/main.c:421
    vfs_ioctl fs/ioctl.c:51 [inline]
    __do_sys_ioctl fs/ioctl.c:907 [inline]
    __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
    do_syscall_x64 arch/x86/entry/common.c:52 [inline]
    do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Cap the automatic alignment to the huge page size, which is probably a
better idea overall. Huge automatic alignments can fragment and chew up
the available IOVA space without any reason.

Cc: stable@vger.kernel.org
Fixes: 51fe6141f0f6 ("iommufd: Data structure to provide IOVA to PFN mapping")
Reported-by: syzbot+16073ebbc4c64b819b47@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/000000000000388410061a74f014@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/io_pagetable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index bbbc8a044bcf7f..4bf7ccd39d465c 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -112,6 +112,7 @@ static int iopt_alloc_iova(struct io_pagetable *iopt, unsigned long *iova,
 	unsigned long page_offset = uptr % PAGE_SIZE;
 	struct interval_tree_double_span_iter used_span;
 	struct interval_tree_span_iter allowed_span;
+	unsigned long max_alignment = PAGE_SIZE;
 	unsigned long iova_alignment;
 
 	lockdep_assert_held(&iopt->iova_rwsem);
@@ -131,6 +132,13 @@ static int iopt_alloc_iova(struct io_pagetable *iopt, unsigned long *iova,
 				       roundup_pow_of_two(length),
 				       1UL << __ffs64(uptr));
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	max_alignment = HPAGE_SIZE;
+#endif
+	/* Protect against ALIGN() overflow */
+	if (iova_alignment >= max_alignment)
+		iova_alignment = max_alignment;
+
 	if (iova_alignment < iopt->iova_alignment)
 		return -EINVAL;
 

base-commit: 76889bbaabf5cab981a74ed69cb3816921edc5d4
-- 
2.46.0

