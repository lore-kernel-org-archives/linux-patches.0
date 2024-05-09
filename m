Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC94874E11;
	Thu,  9 May 2024 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715276762; cv=fail; b=AxjWSgogrDK/VYH7AHLsYA6X+cmIPQkt0foY1I+jAg/nusx9wn3/wg3P4aByuOAnENrnkbxsEqNedSeZP7czsYizREiN2n9Def1J1ONxcSaTDy3flH8Mv/RrSLwucYBg+yN9EfrupFqyzsD9CE2EAT1ecgZtLonkouzU62nUg9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715276762; c=relaxed/simple;
	bh=9ii0/hKqsah2m72keZdd5l1QvxamzPlFYTdy1/6j/U8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GjmITm01I/3CPC48ICCkIXRqD1ubdjMmVp+id4hbgTOclDjOvECOpKwcnpJMSctdePOiYXmZJJSzw/ogs/BmNncL8vUbGWaB7L4dGJFfTz6h5N+0TykOpAlDQ3KQWAPMxopRZ+RMvHojti7rMg8rALs7zp40l6X5EPM9uClhzsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lSeSirkW; arc=fail smtp.client-ip=40.107.93.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lSeSirkW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtOrJ/VpfPp6NwSpdV3xOjbzTnTkvfkTZH14qD77qs1dQlGAtMrj3uIXK0vHJN6irho3sU8l26E5Pe2UEc7Giv+36IozjlaO4VvS+eFQOO5jjNJ2hgX3KP/jkL+NPWYz5GbwUv1evPQe/NNTMwSzCJkwUBJwLefkJVC7DzhvqOg6xzE5dKeEajckw3QF8hLsbObhl4V7GUjESm0+LgFSDtl3gA09MHuyVO0JQNw1f3TSrToPIDvKD+hBIwyBbUuKS4OWQ8Ya/n3FbRxwkTG5g+Gv1dkekF8aYW5dP1cfVTrtliJfjK0jiLEVd7NbRaRD3UkEKyejef1TutgFVi/wRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXlcxeUYxxtK56rKrWseS6G2HW+H8SKknCCRyUpB+AE=;
 b=ngc/G0eiMtBmcrgM8YY5v5vC3gb2yuZ/AuMf+MH9fDxBd7V8NXGikJYEgYdRjGnN8lPR5RYO5MDGCFZLx9jmIYNQaiiys5YxuaXbxUOl80u0TiLTxRgOSFCkGh/frRu0Syzfk91C1BUzVUk/ixipNZLARF7pN7cfnjveC1fqvDe5WLv9oj+aqT0Gto3zPJgTIO+iMH1rImwOO0PrrvfDOA/14ipiq9Xr5uQ9ycjO3Xa+uEXOCmT7ys7dquN0A48Y2BjH3Vd1dY4tUMU2Grt/24hi8RnFTDapMwf6x7EFL4vQY36YEbhN9IkVTnyhq0EUdpHS7a8J6eweKMExkO3FAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXlcxeUYxxtK56rKrWseS6G2HW+H8SKknCCRyUpB+AE=;
 b=lSeSirkWe0Xi2bIUMSSEtHSRFMvr5LUBxbhq+Ie3gPJhNgVOZ7HVX/4s4n0ukACbNJTU5AGL687semQVi59isQaxdYlz0iEQ1DibJqdAYpDjhNvFoOdrd154Rhw9QymzUY6M3Dw8M1/3Uyg2edVCCb/q7PiAuVzxyC0hYRf/zZ2oSq5yFBU88Be9Om62rXrE2+MZSaBXmMQsQ0p2ccPdsibnxK1P7I13D3wYyh+mp4WoY1oqwjsfuQkqMYiN1Tug7miWcqfr4pUz4OxrsOXJEJSOeVCD5RVrlE9/hQdLiexpOHc5nML8b30zLC3LGvZ7b+FYb9yh5n4TlBtTNGLGIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB5819.namprd12.prod.outlook.com (2603:10b6:8:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Thu, 9 May
 2024 17:45:55 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 17:45:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Krishna Reddy <vdumpa@nvidia.com>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH rc] iommu/arm-smmu: Use the correct type in nvidia_smmu_context_fault()
Date: Thu,  9 May 2024 14:45:51 -0300
Message-ID: <0-v1-24ce064de41f+4ac-nvidia_smmu_fault_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0048.namprd16.prod.outlook.com
 (2603:10b6:208:234::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB5819:EE_
X-MS-Office365-Filtering-Correlation-Id: cbc1f2bc-3f50-4726-c674-08dc704fdf2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UJ0FaNr3fWpucdJRu9TVqK0eVzMjUwwIywESrRImVVKyWBvIKaS1X3hEwTXV?=
 =?us-ascii?Q?XEzcA0JlL6LBTV221LGDPCMGl/6r8GsZJzgcl9BOTW9qDu04EXhTXfRaz4pz?=
 =?us-ascii?Q?xGXsVKMDxX+N5T05+8N52XEngF++OCJ/2Z1vs686W+v+U2ClouemVZPDyC9P?=
 =?us-ascii?Q?jNlXmHLGrswzSJXmWG8iBtHMooyg++2OJQ1RZNVz995dVKI8JxB7sr17o/ie?=
 =?us-ascii?Q?0ATEYdd+2Mp1KlsZvSBBDIGFd1gXTF8QrrS1RKZiC3EL/zSscs4DHOS/JPTI?=
 =?us-ascii?Q?tJ6QuuBkWpbb9ivWyeH4we1A1Z2lZxdWl+zzhLF75SeyHmXKsrdbIKo+tK6g?=
 =?us-ascii?Q?54WnskPE+gtNt0Ve3HD5uxhc9sUAkt4fvA3dTrOp+WiVLqdBSgIhWd8DSJ03?=
 =?us-ascii?Q?Ud2A9i0GBvN75J9EvckfUbWUp8OvGb7Grh5T5fYGZf9cEKMhx0FNKO8c/g52?=
 =?us-ascii?Q?+Q/lubTR51TDoCOeSM0hJiO9XFQVcNZ0/Sp2G6EXJ8KuBivZfkd0DRQqjiqR?=
 =?us-ascii?Q?bAnwumrs4rtpA5jY65/Ed53Ny4TjdxUwACrd94/upbyC0nbnkexjTt/cRGld?=
 =?us-ascii?Q?pOUbf7GpTMvFWQNuFrHnI0/vSj1GHUyforiV1rukfz9Hq3UXzT3PXqEg5PFx?=
 =?us-ascii?Q?/N/yuYyvVn9ZO7nSkodcom70KfplRx4h1GshhlHy7fPaB8QEk/QpzVN65Qgg?=
 =?us-ascii?Q?CreSDQ99rn02IiT4zF+Xsd6WNBEHX9sGpJ/RK35EnzkegiKDipdknOvPfNVR?=
 =?us-ascii?Q?V4GByFXyJPvaU2ewoxYweAaujiXCHIhNeKvV/HPHuncD1yYxPWBfFxuRQQAc?=
 =?us-ascii?Q?N+UTWaKUYogkw3Okbe7Vm9f8oHoYL1DhWjsvvhofE9TN+/TwDzWSJShr6L1h?=
 =?us-ascii?Q?fkUBqNI9KJThA+aWveeCQKKaRqTq/A6b59g8YoHgNZsZD3qu//DInyWTlW1y?=
 =?us-ascii?Q?ub0Qne2179Meqc07dGZuc9/KN1igQ8+m6AQ2ZIwgbVAhPw9Y4SMO6MwksO7h?=
 =?us-ascii?Q?1RlPeEGepxLXnIDqoe11+EJHAXJAfhICNFE2e19tii8PxE+8ER+FxLBjzWSV?=
 =?us-ascii?Q?5m2bICaj/BWDnLyfW+6LcHeLa5VAOfaeaINhHIo4EYz6clQDia8w/hcFrkxD?=
 =?us-ascii?Q?wwH++Qq0++zIHyO2qGeQmMo4xPFxO1ljo+nGcC1WsX5wu4I05xS9VgZutTj0?=
 =?us-ascii?Q?idl2RitBGtOXS5Hg3iw55nquMm8QoFploFdJLfJOd0gF2CVqp/ZE+Pn06h08?=
 =?us-ascii?Q?o4QQM+ZPO3qES/1WayCbDX9RyRD3fajaNso+0GV1qA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KN8+Phu+u/O1xwEMPybW2coPpu4ucPFdIzbL1lhgabiEUIugOInQ7kk2pfpK?=
 =?us-ascii?Q?CJDI1PGWHV5e9z+mhptBHblXSrkg3Tig2AsDNaXPRgPF28VVfU0e7jBBqCE4?=
 =?us-ascii?Q?d11yKmxdBRJ7Duo4XXEVkwOfnnple6YkvQeh0p1orMhxGXJFM/sdfUmtf2zV?=
 =?us-ascii?Q?ZS9JkspkgsiA6oEnHnwXcTEHakchAddkcPN/GPfm6UHc9jKiFYl1+Lg+wLMN?=
 =?us-ascii?Q?m0scPpUNQWC4mSgW9OqamCmR/yXxluK2htK+nRVzsUToCUc4OoeGrjZmaBgD?=
 =?us-ascii?Q?EdfJMX23ckUADaoY/GAJlnA2YEUsGzMLdY35xliCd6IqGX6VUh0e3eqnxB7i?=
 =?us-ascii?Q?SKBXwL8QKYUceEPxU5PLF6Hl1JirTKSBVUjLokCc5hys1TtnpINiA45BC4rI?=
 =?us-ascii?Q?0qbUXwbgkBikzDspHIjIYL3pV2ISSyQSvWawAYc7LPQK1BuK7fTdrYoB4pWC?=
 =?us-ascii?Q?kvaa6YeDxunNspv/+2S5Ty1QkESte68X4nunD36KI2fXcSMYum18gmquW+Gz?=
 =?us-ascii?Q?4UN22d0AO7+MFlsRTfr3Qk7To/nwKGnOo3Zce6gjwhDo50YnvroHu0Z1K2q1?=
 =?us-ascii?Q?pu3vcI3Q2OyBsTu38PqpHTS1oTPfSYlGlzhGfqsYhgA9Z3bSlArBdiCibxUN?=
 =?us-ascii?Q?5aeae0Rt4ABSFqzfOh0AaPeG9FvN6/E+aivfVS4k9aVafiTNoJpmSx8qqFFN?=
 =?us-ascii?Q?TRLJmV4KxRP1/RJIPfzwLbqvDVBMOnKhq2ovheuNhWleQSe502wJ6rIKRnq9?=
 =?us-ascii?Q?ndVYwr8eFJxsoFnURzd15F5KNXGlrvffFtzs5yzEnU1hvG0/3NCIeAbr+Ork?=
 =?us-ascii?Q?4QKoSa6lroSEIZdC2285W44oPmoVT01kDTZqF++zcaH1s8iZcwrrI2C4XXrQ?=
 =?us-ascii?Q?gALpL3Vtov6HQAXLaDZipL0qJ+VpnAk7XUOk4Tuh7WaOoOxgx8sD2Xa+EkZz?=
 =?us-ascii?Q?8CtN2o/Af5/xdPp1tlTZ6umDoYAQo1g7YVXMW2Z5mjfgJh+P3nUNGfUvLHw9?=
 =?us-ascii?Q?gqldT8ScCTEqXUIz55LrPKy+2tdWd5v2qqgtGVbaXs8y7V/GuM30422oFJ9Z?=
 =?us-ascii?Q?cy07SkoKLfS/HhEoQdAZYAxBlKmzCm8sIHPDERhOqIiQ6Qs5R39OmpefY662?=
 =?us-ascii?Q?hobbX5crzsdbfqNacb84KuGbgTW0tWI1DP7s5J5yynRq3kw0CyjkuRZ27sf7?=
 =?us-ascii?Q?mMT5Q6OLidXc+oO8RrTWU29W4Cuh2xx/XVRdlnnkA94UAHRyv7SZ0gwzPwff?=
 =?us-ascii?Q?63pFo1OSvOxyiNblNDuq3XwUmivB9nTfEos4Sv9ecX+N6f7zF3GHja+6M6OE?=
 =?us-ascii?Q?trvnNwVhsGu9hIITidWQti1wtFKSasIqZEDb7kf67cOmynATBaSS2ySacafG?=
 =?us-ascii?Q?MaYs85xPC1ogdFD8g2qMhbxGwxwB3w0nsPSiMuWFu08dQGGuQzKdRXSk0ZlA?=
 =?us-ascii?Q?4veeEcswJwwHolxnLNrefr1vG0+ifExNu9bDCErVs/NDQM8W219MEblOz7Di?=
 =?us-ascii?Q?GHpfUxutkutsxXAt6G1MrJbsAvWP3VDm3iwuNsj/K/NXNCkVVb+3YkZZdfRC?=
 =?us-ascii?Q?yYGkqJeTI4wHdVCR64HoHw3ScAEir4yM88URyB7m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc1f2bc-3f50-4726-c674-08dc704fdf2b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 17:45:52.9877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0L98A8FH4y1jbH8PzV7RDdX+Z942dGup7JikSxaoOgG3bQzNG6W9AHIMWoTCllot
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5819

This was missed because of the function pointer indirection.

nvidia_smmu_context_fault() is also installed as a irq function, and the
'void *' was changed to a struct arm_smmu_domain. Since the iommu_domain
is embedded at a non-zero offset this causes nvidia_smmu_context_fault()
to miscompute the offset. Fixup the types.

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000120
  Mem abort info:
    ESR = 0x0000000096000004
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x04: level 0 translation fault
  Data abort info:
    ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
    CM = 0, WnR = 0, TnD = 0, TagAccess = 0
    GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  user pgtable: 4k pages, 48-bit VAs, pgdp=0000000107c9f000
  [0000000000000120] pgd=0000000000000000, p4d=0000000000000000
  Internal error: Oops: 0000000096000004 [#1] SMP
  Modules linked in:
  CPU: 1 PID: 47 Comm: kworker/u25:0 Not tainted 6.9.0-0.rc7.58.eln136.aarch64 #1
  Hardware name: Unknown NVIDIA Jetson Orin NX/NVIDIA Jetson Orin NX, BIOS 3.1-32827747 03/19/2023
  Workqueue: events_unbound deferred_probe_work_func
  pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : nvidia_smmu_context_fault+0x1c/0x158
  lr : __free_irq+0x1d4/0x2e8
  sp : ffff80008044b6f0
  x29: ffff80008044b6f0 x28: ffff000080a60b18 x27: ffffd32b5172e970
  x26: 0000000000000000 x25: ffff0000802f5aac x24: ffff0000802f5a30
  x23: ffff0000802f5b60 x22: 0000000000000057 x21: 0000000000000000
  x20: ffff0000802f5a00 x19: ffff000087d4cd80 x18: ffffffffffffffff
  x17: 6234362066666666 x16: 6630303078302d30 x15: ffff00008156d888
  x14: 0000000000000000 x13: ffff0000801db910 x12: ffff00008156d6d0
  x11: 0000000000000003 x10: ffff0000801db918 x9 : ffffd32b50f94d9c
  x8 : 1fffe0001032fda1 x7 : ffff00008197ed00 x6 : 000000000000000f
  x5 : 000000000000010e x4 : 000000000000010e x3 : 0000000000000000
  x2 : ffffd32b51720cd8 x1 : ffff000087e6f700 x0 : 0000000000000057
  Call trace:
   nvidia_smmu_context_fault+0x1c/0x158
   __free_irq+0x1d4/0x2e8
   free_irq+0x3c/0x80
   devm_free_irq+0x64/0xa8
   arm_smmu_domain_free+0xc4/0x158
   iommu_domain_free+0x44/0xa0
   iommu_deinit_device+0xd0/0xf8
   __iommu_group_remove_device+0xcc/0xe0
   iommu_bus_notifier+0x64/0xa8
   notifier_call_chain+0x78/0x148
   blocking_notifier_call_chain+0x4c/0x90
   bus_notify+0x44/0x70
   device_del+0x264/0x3e8
   pci_remove_bus_device+0x84/0x120
   pci_remove_root_bus+0x5c/0xc0
   dw_pcie_host_deinit+0x38/0xe0
   tegra_pcie_config_rp+0xc0/0x1f0
   tegra_pcie_dw_probe+0x34c/0x700
   platform_probe+0x70/0xe8
   really_probe+0xc8/0x3a0
   __driver_probe_device+0x84/0x160
   driver_probe_device+0x44/0x130
   __device_attach_driver+0xc4/0x170
   bus_for_each_drv+0x90/0x100
   __device_attach+0xa8/0x1c8
   device_initial_probe+0x1c/0x30
   bus_probe_device+0xb0/0xc0
   deferred_probe_work_func+0xbc/0x120
   process_one_work+0x194/0x490
   worker_thread+0x284/0x3b0
   kthread+0xf4/0x108
   ret_from_fork+0x10/0x20
  Code: a9b97bfd 910003fd a9025bf5 f85a0035 (b94122a1)

Cc: stable@vger.kernel.org
Fixes: e0976331ad11 ("iommu/arm-smmu: Pass arm_smmu_domain to internal functions")
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Closes: https://lore.kernel.org/all/jto5e3ili4auk6sbzpnojdvhppgwuegir7mpd755anfhwcbkfz@2u5gh7bxb4iv
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Joerg, once Jerry ack's this you should grab it for this cycle.

Thanks,
Jason

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
index 87bf522b9d2eec..957d988b6d832f 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
@@ -221,11 +221,9 @@ static irqreturn_t nvidia_smmu_context_fault(int irq, void *dev)
 	unsigned int inst;
 	irqreturn_t ret = IRQ_NONE;
 	struct arm_smmu_device *smmu;
-	struct iommu_domain *domain = dev;
-	struct arm_smmu_domain *smmu_domain;
+	struct arm_smmu_domain *smmu_domain = dev;
 	struct nvidia_smmu *nvidia;
 
-	smmu_domain = container_of(domain, struct arm_smmu_domain, domain);
 	smmu = smmu_domain->smmu;
 	nvidia = to_nvidia_smmu(smmu);
 

base-commit: dff9180946cc45d90a77e1c8645989cdcfd31437
-- 
2.43.2

