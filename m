Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7716D2BCF53;
	Wed, 16 Jul 2025 19:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695887; cv=fail; b=pY3lllsQl33bKTjpLLQAuvv99wKZlrxpno6t8CMrmkWw4MVNJyzrRyxlZd2Hgrp4xI4mF796O6u0nPd1BUx58tdtp66uW56uq6880dvLOEUqHWThCDHsTK2nm9LW8vtNG1ZHtdGW6HL/8FJT67FgCpPlYj+hKsi63KtpTl/0X7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695887; c=relaxed/simple;
	bh=9aZtWsBSDWfbGnj1wEzB8FTzmHUw1VqoVvdR2tKEga0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tld/YwzGa9FDVqdB+T47VRUKX+CYCsvssh7rY4KvWX4GRnp/LLQCEZe/N8LX/+dhAlKMWShGiGC+XmNoyjjuZOVr/GfDtbkKjKOcyYJ7Xk5E31aHfJ5bLAC/h0Zv06f4G6fca7mHboVDmcaFwZYhFeEWE23QqpbkRh7ha3pWtTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R+C3lxt+; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R+C3lxt+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKPF/szpiKY+v4fmuPa/Rlw/6S3X2XXeCKWlrsiqzhmeTU3Uhs7Xu5152w6OAmoZ6jTBOq06abvgXKGxPsjtaHdeG86me8QwrvitCOjvE6t46NpFA0iESv4ueKCTHlqQAvsSZe64aaZKb+82R+P/iw/+nUnu5kDDLZ3Mkqgc8R6w8n96f3D0JxDKfwWmPlx3CZdU6TCtzOC0Kl+VKEdqbp+uo2MnnvZVYLg7kAP68qdeSec+/f5jCBm3fzxPfCMfrkZIw+lLD0dyX5wtDr0fO9D/1oDfokJ92SPJr9aVWeQgXJyad60mea7ab9wYex6SPrdn6UdguLbOVRwsX31fZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqaC16OFHqPy88k4v6HAPc11cIbemKEeZ9f2ZWGJTGY=;
 b=QWzBa8zPxiK6hl/WF+akM2Fom+xXjs8zNouWscbJ9blU9wc8A10UcMIdWFT+VsQOo7Ct703jrTxmzPeHfRqB49GQjdpZu4x0cPa/kzcTrZEibAKfLvqnOam3vsQVkQTSj60fvKG9SvfIUbyan+ti8t/b9m1BNj10gObZ/D2lPtuk9Ku1rNZYwl6dPVdksqRDLMBd+4/4zHFkIwTRTxZLVIqMHtQL5+XVOgjA8Y3jUwQg1rDlSP++0sBKbXcje8lsFUaVR4VKckWVmA8MmxyT0oL7FcK/1Y36XiPqanz49tZ4gv4/uDhbkEJTxjpVpnhkv3OSNQAwCiGMXlaSbpIH7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqaC16OFHqPy88k4v6HAPc11cIbemKEeZ9f2ZWGJTGY=;
 b=R+C3lxt+IRWgQjaARMa+bPdA0oMEduSKk6ASjLWWXkP7JqOdrgAO41u2pIscEBibC5H4Ba1NaciKpQKiubdbiEw3DQ+FBliAjapbuVIzB7kdzvlBmdTTXCrWB6p9NKmhaFkbHf8pFphF36xUB56zZlqztWGOoNktgeURee1PNWNkP8Hd85M2fCzh9uupnZjIIO2GcOU7p20U9axG5YufkJFjevmULL7dT11a3e9neegdeYUX9IPOs7R8eJ6PgpcL/Sun6706eqy4jnKdPrdr8lw4pkiXm3mxVdS6hTTwG2uCN0DAk9Fs9SIKjtXOzDmDSWjK6ie9H/4ZHhPwmA+dug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 19:57:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 5/9] iommupt: Add the Intel VT-D second stage page table format
Date: Wed, 16 Jul 2025 16:57:41 -0300
Message-ID: <5-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0429.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e913715-0104-4746-1f3d-08ddc4a30b15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R87RcXl+6CQGJ1aGZghSVUrkgWRoNKuM+B4feroT86xAAjhx3jFm/c57aV/B?=
 =?us-ascii?Q?UWHXypCPsfUt17kZ84ymY6m8aT6wAQ+Xfp0RANjEoVWIUbb3QW1d2MbY1XnH?=
 =?us-ascii?Q?h4iRmxeAIL0ldQoqzB5hXsSQhe+ygc/1JwxvIoAPg3Avo1Y4irY2oPAMFneI?=
 =?us-ascii?Q?koZhranew9fbrSr0ABRQAkvOiWRLHqRDaBJMMjuH7PwwBVDtnR5sdakE2Wlo?=
 =?us-ascii?Q?NNCvbcqg92VUWhyUMaJsBdIMXNcpsokP5ld7nIXDBIoI1rGxJclE4lcBGSVy?=
 =?us-ascii?Q?N9Cs/LLAieGTTg0A2d9ZL7iACNh4YBXYN6kzVT0lE6meYz7Q6eQRchQ5gIM0?=
 =?us-ascii?Q?54xELipFTBhlWrCexr33Txh8D4WPaew8XM8xy6gJ9/kEF44badDJ3fvXhN4q?=
 =?us-ascii?Q?4+QcoE/QlW6hU9qF8HcDyOVT2tlekhayiTusg/uXSPNeZnJq/sIserYS3iAd?=
 =?us-ascii?Q?ji8NVPP7X/2G7OqjQDXGztnwskZqlDYhZTF9NpsJf/Jgaps5RBuDBo93bOOF?=
 =?us-ascii?Q?9oHMr9+/dQwf0cbeO6C1gU38TdWeqZ3jcB9A+/nykQUt9lafRR+EFnnQwqbt?=
 =?us-ascii?Q?Nse1ZcFge68CYWclfpeAS3sDCz0Zj+kxB3LgCIixY50PiiYVyauNp5CIWCme?=
 =?us-ascii?Q?cNaDfy3+DYPfhIqO5JPUNo3qh8ovBv4mHXrC7xoc0/rLb1RP7czixY7Lwvxl?=
 =?us-ascii?Q?Ww0CzzJZacd3/phzRW2fIurmEdRNWypqShdE1M7HZm8yyb7Iyu0d+SpZ8zvt?=
 =?us-ascii?Q?EDOSl8Y419N/zy3NZnp1/xXhBW+0w1ZyWesf7agoeVVhRQsxzaSRg288zux/?=
 =?us-ascii?Q?ChNNhgpTcuzs70LiqvD3Y2VkywrvZRFGkKyWnlcc5qu0IuvEPXYjjBeeaJpW?=
 =?us-ascii?Q?Gq+0B6PhPrjhL2MZByQmCbfEWJ7CnMckZF6o0AE90MdyjHh26xI7l9E1uBR9?=
 =?us-ascii?Q?ZMz6c4kJ6Y0jb73REoffF4HXCPux0qOTY9teS0KOL7/uQIPj9jf9jthJFXNm?=
 =?us-ascii?Q?+3nOLjOuYgDPjsno46DPQD0C56Je/HCLWk5O5MpTonPyQYfE23yPDdoGeGcZ?=
 =?us-ascii?Q?6rlIfuZ/XgyEsgbptLj43j0mS5UVAViCIkhcL1HwGTuvFQ375N+xM53COZRn?=
 =?us-ascii?Q?Id6ou2ZsQC3R9JjCqPUecde5KzNJyfoO/Ox3A7OiOhsHOLc6uXcxcxMzQPn2?=
 =?us-ascii?Q?xUO5tQYR/CuT0hBn4qjuyyKL42g7KTgUXCWjPlGjNmYrTpgoQO6SQc97A+83?=
 =?us-ascii?Q?3jdwQIRE9q5cAyX1FO+W0qlZDVHl7e46L+ZFlcFLnPRVS5apB+AxAiBW+jN8?=
 =?us-ascii?Q?HlZ6Vpql1/qMN1ZY+39wzsvm45FZmm9r0yMSfy4aadteqi0oyvF7LPnEVrZm?=
 =?us-ascii?Q?4DlQFBZCR54etWIJ32yVpWx2tdrlo7Mc+t8BDfb402GRc8FI8U0wLdBuZs1r?=
 =?us-ascii?Q?EnWJlWBnPGs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5wrsrs2SVAozPTnuk24j7WwPgo0c8CWyJKDrdLM0ntRU7vDvSd3WWgVLm6jY?=
 =?us-ascii?Q?b1pzNNGYvhQkqkETtFg0LwhDa77pab6F172tpWHbfDuM+L6mhmpqmsgFCPAM?=
 =?us-ascii?Q?eYPgxqgkw/JDrAopB+3/b4kNcvQfXeItZVtb1WTRE1EFar0k/CmcQztw/wyY?=
 =?us-ascii?Q?dn9BUBtVLUVSwMyeFTqSl27UMQgOuHm9+e0eCClKncXdaAm2yCA541qqbg6Y?=
 =?us-ascii?Q?rOIzwrOBZA+/H5d0/seWSJhx/7DksaGh8uk4D9BEXZSPpb+qTOoZ1yv3y6ZA?=
 =?us-ascii?Q?wKhLUiHxHVt9+rHN/vVV9RS8EOg960qpM1c4DCWPq9nKK2HaxTQfZfzLqBRs?=
 =?us-ascii?Q?E0dopX4UWoVXRbqufuA6FP2VHoIKvll2PfnUZkcnAgSnfmXL+bx+EYtxZBa5?=
 =?us-ascii?Q?wgibkbz8IcI+Oz2Tz5VjlBiq0Zv1+U+La21jk/dXJ3J1gmhowkk1z5/XJmdu?=
 =?us-ascii?Q?9fhlHa29SyWjMozvIaG5R6svlI8E2ZPA07QVauwiUD5jOgSxskfEKhlAuR3L?=
 =?us-ascii?Q?Vic7ZxdukgGVPmbrrRfZLCeU64WsQqoSFR4r/knxmdh+nn3jfGGZuDvuj7gG?=
 =?us-ascii?Q?4IwSKzwp8Z7nYY32oisedGQRJfkfGUUmI3e9YHmEmjggGRyb9s1ENspFG0p8?=
 =?us-ascii?Q?eLWSTQnTTyDlTNhsINhd8+oE01ldLfWltYwbFGNTtQtFtArfxvOANNYHOYuL?=
 =?us-ascii?Q?yA+zQYLmQjDzKJAl7QgKQOLISVYLlCR5oaLGp/drigibg8TKQwpwNOrzLWSM?=
 =?us-ascii?Q?lafBOVKQPqUqbEcGIAGyH+Sr4Q8VpZoJqD8nZ8WTKlh8o4bxkMopF7mzllTZ?=
 =?us-ascii?Q?ZLVRuE+diUzmSzIbkO7XvaDwCWR8MRy90ASTXC1CUjV4hvsRlJZXJI16vA34?=
 =?us-ascii?Q?k43aSLjZ/6BiJDfrkuGThhNM7mwDOLLREH0dH7ICmDDt4R3MMWHH6zCY06e1?=
 =?us-ascii?Q?bXRP4xC1xpANKWAG5MtfrF5qeD2Ij0Uwt8+TTk4bPjNOV2NVmhDAZ33UpNgs?=
 =?us-ascii?Q?2i5749OLi4tL53rCp6rRyjzKs/3uQ206eyYK/j+XY9IpOVZut1Fa70dpztsT?=
 =?us-ascii?Q?nzx9ZuzJjRzpWv4BkHCqTbbrhZOTkB97T+li3uF59yMHH0ctXBhhWcU3E+VE?=
 =?us-ascii?Q?etmzQkms7NlnOelzO/sZN1z3OW/rFJO1eBJP3Im6++wJqg7cHsGLLVX13hEw?=
 =?us-ascii?Q?EbugYrFlgmbBax/A+VfXqtb0k5LYgRnRBX6YB6M9DXi6XXlZ2TulA+SoX6iT?=
 =?us-ascii?Q?272CXwh3Ef9GMdxPacCFk1EvG1TNZT81M4Hduov0PTx2Yp+JgaKxgazgHdxE?=
 =?us-ascii?Q?QEUtnJnYbH1eymDLh0cv2Pom+MPRztzHTZ08jJO5gV4IG/OM0/qTkxb0/6go?=
 =?us-ascii?Q?Fa2XpeYxDhi4OKbeTN5p93+usgD7LVfOMPbrkOk3wQO7EeUA/kkZt/k52021?=
 =?us-ascii?Q?bHHdW4XljMxzTUVD+TiF2/ADL2JUp6Dmot9gdJi0wG1qsboi0qqqBgX7ekub?=
 =?us-ascii?Q?/aaybJ+OL05m5XdBMjeryDZSCyw93kdTX7ppRNIV9i/isXR+rZ11xGafEG47?=
 =?us-ascii?Q?THDZQ/gxghLMTQKBMtttxLIl8Q10iaW5rOOrPpVM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e913715-0104-4746-1f3d-08ddc4a30b15
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:50.4703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hPJQluiiJYYT0vUUY3LnKgFE00svNp3F9Ted54sA1LI1Im32DMopDWrOaGnjmaM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560

The VT-D second stage format is almost the same as the x86 PAE format,
except the bit encodings in the PTE are different and a few new PTE
features, like force coherency are present.

Among all the formats it is unique in not having a designated present bit.

Comparing the performance of several operations to the existing version:

iommu_map()
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,     53,66    ,      50,64      ,  21.21
     2^21,     59,70    ,      56,67      ,  16.16
     2^30,     54,66    ,      52,63      ,  17.17
 256*2^12,    384,524   ,     337,516     ,  34.34
 256*2^21,    387,632   ,     336,626     ,  46.46
 256*2^30,    376,629   ,     323,623     ,  48.48

iommu_unmap()
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,     67,86    ,      63,84      ,  25.25
     2^21,     64,84    ,      59,80      ,  26.26
     2^30,     59,78    ,      56,74      ,  24.24
 256*2^12,    216,335   ,     198,317     ,  37.37
 256*2^21,    245,350   ,     232,344     ,  32.32
 256*2^30,    248,345   ,     226,339     ,  33.33

Cc: Tina Zhang <tina.zhang@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig      |   1 +
 drivers/iommu/generic_pt/Kconfig           |  12 +
 drivers/iommu/generic_pt/fmt/Makefile      |   2 +
 drivers/iommu/generic_pt/fmt/defs_vtdss.h  |  21 ++
 drivers/iommu/generic_pt/fmt/iommu_vtdss.c |  10 +
 drivers/iommu/generic_pt/fmt/vtdss.h       | 289 +++++++++++++++++++++
 include/linux/generic_pt/common.h          |  18 ++
 include/linux/generic_pt/iommu.h           |  11 +
 8 files changed, 364 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
 create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 5265d884e79cea..2f9b6060e3b983 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -4,6 +4,7 @@ CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
 CONFIG_IOMMU_PT_RISCV64=y
+CONFIG_IOMMU_PT_VTDSS=y
 CONFIG_IOMMU_PT_X86_64=y
 CONFIG_IOMMU_PT_KUNIT_TEST=y
 
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 953856e4b48369..b631cf00eba559 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -56,6 +56,17 @@ config IOMMU_PT_RISCV64
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_VTDSS
+       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	default n
+	help
+	  iommu_domain implementation for the Intel VT-D IOMMU's 64 bit 3/4/5
+	  level Second Stage page table. It is similar to the X86_64 format with
+	  4M/2M/1G page sizes.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_X86_64
        tristate "IOMMU page table for x86 64 bit, 4/5 levels"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -72,6 +83,7 @@ config IOMMU_PT_KUNIT_TEST
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
 	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
+	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	default KUNIT_ALL_TESTS
 	help
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 9c0edc4d5396b3..6fe95fc8466523 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -5,6 +5,8 @@ iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86_64) += x86_64
 
 IOMMU_PT_KUNIT_TEST :=
diff --git a/drivers/iommu/generic_pt/fmt/defs_vtdss.h b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
new file mode 100644
index 00000000000000..4a239bcaae2a90
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_VTDSS_H
+#define __GENERIC_PT_FMT_DEFS_VTDSS_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct vtdss_pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs vtdss_pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_vtdss.c b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
new file mode 100644
index 00000000000000..f551711e2a336d
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT vtdss
+#define PT_SUPPORTED_FEATURES                                            \
+	(BIT(PT_FEAT_FLUSH_RANGE) | BIT(PT_FEAT_VTDSS_FORCE_COHERENCE) | \
+	 BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE) | BIT(PT_FEAT_DMA_INCOHERENT))
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/vtdss.h b/drivers/iommu/generic_pt/fmt/vtdss.h
new file mode 100644
index 00000000000000..262fe3538c4c4b
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/vtdss.h
@@ -0,0 +1,289 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Intel VT-D Second Stange 5/4 level page table
+ *
+ * This is described in
+ *   Section "3.7 Second-Stage Translation"
+ *   Section "9.8 Second-Stage Paging Entries"
+ *
+ * Of the "Intel Virtualization Technology for Directed I/O Architecture
+ * Specification".
+ *
+ * The named levels in the spec map to the pts->level as:
+ *   Table/SS-PTE - 0
+ *   Directory/SS-PDE - 1
+ *   Directory Ptr/SS-PDPTE - 2
+ *   PML4/SS-PML4E - 3
+ *   PML5/SS-PML5E - 4
+ */
+#ifndef __GENERIC_PT_FMT_VTDSS_H
+#define __GENERIC_PT_FMT_VTDSS_H
+
+#include "defs_vtdss.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
+	PT_MAX_VA_ADDRESS_LG2 = 57,
+	PT_ITEM_WORD_SIZE = sizeof(u64),
+	PT_MAX_TOP_LEVEL = 4,
+	PT_GRANULE_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+
+	/* SSPTPTR is 4k aligned and limited by HAW */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(63, 12),
+};
+
+/* Shared descriptor bits */
+enum {
+	VTDSS_FMT_R = BIT(0),
+	VTDSS_FMT_W = BIT(1),
+	VTDSS_FMT_A = BIT(8),
+	VTDSS_FMT_D = BIT(9),
+	VTDSS_FMT_SNP = BIT(11),
+	VTDSS_FMT_OA = GENMASK_ULL(51, 12),
+};
+
+/* PDPTE/PDE */
+enum {
+	VTDSS_FMT_PS = BIT(7),
+};
+
+#define common_to_vtdss_pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_vtdss, common)
+#define to_vtdss_pt(pts) common_to_vtdss_pt((pts)->range->common)
+
+static inline pt_oaddr_t vtdss_pt_table_pa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry),
+			  PT_TABLEMEM_LG2SZ);
+}
+#define pt_table_pa vtdss_pt_table_pa
+
+static inline pt_oaddr_t vtdss_pt_entry_oa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry),
+			  PT_GRANULE_LG2SZ);
+}
+#define pt_entry_oa vtdss_pt_entry_oa
+
+static inline bool vtdss_pt_can_have_leaf(const struct pt_state *pts)
+{
+	return pts->level <= 2;
+}
+#define pt_can_have_leaf vtdss_pt_can_have_leaf
+
+static inline unsigned int vtdss_pt_num_items_lg2(const struct pt_state *pts)
+{
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 vtdss_pt_num_items_lg2
+
+static inline enum pt_entry_type vtdss_pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!entry)
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0 ||
+	    (vtdss_pt_can_have_leaf(pts) && (pts->entry & VTDSS_FMT_PS)))
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw vtdss_pt_load_entry_raw
+
+static inline void
+vtdss_pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			    unsigned int oasz_lg2,
+			    const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	entry = FIELD_PREP(VTDSS_FMT_OA, log2_div(oa, PT_GRANULE_LG2SZ)) |
+		attrs->descriptor_bits;
+	if (pts->level != 0)
+		entry |= VTDSS_FMT_PS;
+
+	WRITE_ONCE(tablep[pts->index], entry);
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry vtdss_pt_install_leaf_entry
+
+static inline bool vtdss_pt_install_table(struct pt_state *pts,
+					  pt_oaddr_t table_pa,
+					  const struct pt_write_attrs *attrs)
+{
+	u64 entry;
+
+	entry = VTDSS_FMT_R | VTDSS_FMT_W |
+		FIELD_PREP(VTDSS_FMT_OA, log2_div(table_pa, PT_GRANULE_LG2SZ));
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table vtdss_pt_install_table
+
+static inline void vtdss_pt_attr_from_entry(const struct pt_state *pts,
+					    struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits = pts->entry &
+				 (VTDSS_FMT_R | VTDSS_FMT_W | VTDSS_FMT_SNP);
+}
+#define pt_attr_from_entry vtdss_pt_attr_from_entry
+
+static inline bool vtdss_pt_entry_write_is_dirty(const struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+
+	return READ_ONCE(*tablep) & VTDSS_FMT_D;
+}
+#define pt_entry_write_is_dirty vtdss_pt_entry_write_is_dirty
+
+static inline void vtdss_pt_entry_set_write_clean(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+
+	WRITE_ONCE(*tablep, READ_ONCE(*tablep) & ~(u64)VTDSS_FMT_D);
+}
+#define pt_entry_set_write_clean vtdss_pt_entry_set_write_clean
+
+static inline bool vtdss_pt_entry_make_write_dirty(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 new = pts->entry | VTDSS_FMT_D;
+
+	return try_cmpxchg64(tablep, &pts->entry, new);
+}
+#define pt_entry_make_write_dirty vtdss_pt_entry_make_write_dirty
+
+static inline unsigned int vtdss_pt_max_sw_bit(struct pt_common *common)
+{
+	return 11;
+}
+#define pt_max_sw_bit vtdss_pt_max_sw_bit
+
+static inline u64 vtdss_pt_sw_bit(unsigned int bitnr)
+{
+	/* Bits marked Ignored in the specification */
+	switch (bitnr) {
+	case 0:
+		return BIT(10);
+	case 1 ... 10:
+		return BIT_ULL((bitnr - 1) + 52);
+	case 11:
+		return BIT_ULL(63);
+	/* Remaing bits 9-3  are only available in some entries */
+	default:
+		if (__builtin_constant_p(bitnr))
+			BUILD_BUG();
+		else
+			PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit vtdss_pt_sw_bit
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_vtdss
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->vtdss_pt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, vtdss_pt.common)
+			->iommu;
+}
+
+static inline int vtdss_pt_iommu_set_prot(struct pt_common *common,
+					  struct pt_write_attrs *attrs,
+					  unsigned int iommu_prot)
+{
+	u64 pte = 0;
+
+	/*
+	 * VTDSS does not have a present bit, so we tell if any entry is present
+	 * by checking for R or W.
+	 */
+	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
+		return -EINVAL;
+
+	if (iommu_prot & IOMMU_READ)
+		pte |= VTDSS_FMT_R;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= VTDSS_FMT_W;
+	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_COHERENCE))
+		pte |= VTDSS_FMT_SNP;
+
+	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_WRITEABLE) &&
+	    !(iommu_prot & IOMMU_READ)) {
+		pr_err_ratelimited(
+			"Read-only mapping is disallowed on the domain which serves as the parent in a nested configuration, due to HW errata (ERRATA_772415_SPR17)\n");
+		return -EINVAL;
+	}
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot vtdss_pt_iommu_set_prot
+
+static inline int vtdss_pt_iommu_fmt_init(struct pt_iommu_vtdss *iommu_table,
+					  const struct pt_iommu_vtdss_cfg *cfg)
+{
+	struct pt_vtdss *table = &iommu_table->vtdss_pt;
+	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
+
+	if (vasz_lg2 > PT_MAX_VA_ADDRESS_LG2)
+		return -EOPNOTSUPP;
+	else if (vasz_lg2 > 48)
+		pt_top_set_level(&table->common, 4);
+	else if (vasz_lg2 > 39)
+		pt_top_set_level(&table->common, 3);
+	else if (vasz_lg2 > 30)
+		pt_top_set_level(&table->common, 2);
+	else
+		return -EOPNOTSUPP;
+	return 0;
+}
+#define pt_iommu_fmt_init vtdss_pt_iommu_fmt_init
+
+static inline void
+vtdss_pt_iommu_fmt_hw_info(struct pt_iommu_vtdss *table,
+			   const struct pt_range *top_range,
+			   struct pt_iommu_vtdss_hw_info *info)
+{
+	info->ssptptr = virt_to_phys(top_range->top_table);
+	PT_WARN_ON(info->ssptptr & ~PT_TOP_PHYS_MASK);
+	/*
+	 * top_level = 2 = 3 level table aw=1
+	 * top_level = 3 = 4 level table aw=2
+	 * top_level = 4 = 5 level table aw=3
+	 */
+	info->aw = top_range->top_level - 1;
+}
+#define pt_iommu_fmt_hw_info vtdss_pt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_vtdss_cfg vtdss_kunit_fmt_cfgs[] = {
+	[0] = { .common.hw_max_vasz_lg2 = 39 },
+	[1] = { .common.hw_max_vasz_lg2 = 48 },
+	[2] = { .common.hw_max_vasz_lg2 = 57 },
+};
+#define kunit_fmt_cfgs vtdss_kunit_fmt_cfgs
+enum { KUNIT_FMT_FEATURES = 0 };
+#endif
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 1b97bbfaa4f90a..fa6e36e0b9efa3 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -171,6 +171,24 @@ enum {
 	PT_FEAT_RSICV_SVNAPOT_64K = PT_FEAT_FMT_START,
 };
 
+struct pt_vtdss {
+	struct pt_common common;
+};
+
+enum {
+	/*
+	 * The PTEs are set to prevent cache incoherent traffic, such as PCI no
+	 * snoop. This is set either at creation time or before the first map
+	 * operation.
+	 */
+	PT_FEAT_VTDSS_FORCE_COHERENCE = PT_FEAT_FMT_START,
+	/*
+	 * Prevent creating read-only PTEs. Used to work around HW errata
+	 * ERRATA_772415_SPR17.
+	 */
+	PT_FEAT_VTDSS_FORCE_WRITEABLE,
+};
+
 struct pt_x86_64 {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 7cec42a8efbb04..8f4a58d8c48899 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -271,6 +271,17 @@ struct pt_iommu_riscv_64_hw_info {
 
 IOMMU_FORMAT(riscv_64, riscv_64pt);
 
+struct pt_iommu_vtdss_cfg {
+	struct pt_iommu_cfg common;
+};
+
+struct pt_iommu_vtdss_hw_info {
+	u64 ssptptr;
+	u8 aw;
+};
+
+IOMMU_FORMAT(vtdss, vtdss_pt);
+
 struct pt_iommu_x86_64_cfg {
 	struct pt_iommu_cfg common;
 };
-- 
2.43.0

