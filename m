Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010029.outbound.protection.outlook.com [52.101.193.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF8113777E;
	Sat, 24 Jan 2026 21:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769288431; cv=fail; b=ApDQX+CKsI8KGKISyKtuJ6awFYd19cm6+8xENXF3wPFeVcnOaz3+hxwldt9xnF8hrPEUVln5DbbTxg8ARdo7Pj7d8qnXuTJg8r9rbqbSAOqLSKtz8mbmIdv00gUsrN6Csp+f+un6xzO+4QiO6uSFGS6zn8iqtHnSP0TJXUnmhJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769288431; c=relaxed/simple;
	bh=2KhQdsxOT4yqDkuiy/rpltWWO+pSZJcLztc6kWbxFkg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uxwU8T/3RotSxou3ADrVDW/vUd0lNWxcPL0unQbqshnV4t6FMVae/pJkiI6sZQ6MXK7kN5N6gb5l2gNXybHvSWaeooNA1ZKPUDPcBy27S3jOs7DMRbScod5IZPqZG9J33hwhptIzzNrcDjHr5qd8Y9UkRefXMyIjSBuf415sY/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qyt0XM2d; arc=fail smtp.client-ip=52.101.193.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qyt0XM2d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CktNpLA93fSdDJ1OAeVH3tfT1ZrX0W3+LDwKP4hXN4BTw3vizun3IhnVelugoO0ETDf06EXfh1ZSSs7pXNYo0lvaHp/3y76M5U/NvhNH09Z4zKQYkvWDP/6GnrwC7QMi8vqIJM+tJPDDY/dLIBYiuMsOP/rhqJYWnl/J19erlVo5RsKCFTSagMOJB/ayvwj0XJstihlLZrF6Ok7hvNB0fGj6cYpMBLGVB1xCqfc1HUgqDEz8LeGgWj0VLtH20N+496lva6WbpIlH6adNXuj4MratCcTnqjA6cDShMyeNO1DyY08YoUKLNXZszb/J3udVq8MqKoZYi2QeT9llydt7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/E0iMImxsAuXFv2JACJEDqmyzAbQW8m7hsFr0W5iMa8=;
 b=ymM5PVdrvin0Bdh69HOMrKUOgYd80tbxN0tIJ4dAtp4SfnT0u9aYhrNXk2YBMOl21Y58viJ0ulcPkNknt3z8raHgUvVUwanTavUhAnG22JWEzl15/EhLr952vtv5QxlEGrRPaaEpvW5lwG7apR6wc2NkVe9x0iEwfOkm9p4SPBmzxGH1xToODssPyBm2+/eTP8TNSzr0AakPKgWm0zrbjF3nDWhm8xJDbpiiye6mN9sGgX2pn0yJElHmIZgZxqvcpec90zRKuMSfuvM6sDmRy2GwBK9+PojqZIJnmxnAFiuRB3oksacg3N0qmFJJ53d4MOO9gEKNEKt3meFCi4+IoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/E0iMImxsAuXFv2JACJEDqmyzAbQW8m7hsFr0W5iMa8=;
 b=qyt0XM2dbZP/qHF/G0UQJCH2DGQW17Y6Pm4tRAWWAGsJMcD3vLeo0lTmp9oYkXWIG8X7eY0wQRZUEl32pfLBtJXD2fiSvTXRChEnjYF2kFtYfLskzTfUurt+kRlFwn55dgzuGUuZU3uKFAIkxBMt8ZLusBGA5926WLVkOKdlmvmbnwF9V9twZjuujbdKXwA7p9dYRjwMqfiH/rA61Y4wZISoQfUK0KBUbBiR6RnVfTOMOPPj/kJLwddeTiK5NEkXs7cG2DAecxvtGUurUnFzvG49lU6a7+sZgKOGQS3qQ6c1k3klW3xCbJ1c96hTUpe7tSIIyBOIWH6OTqOy7uiBog==
Received: from SA1PR12MB8642.namprd12.prod.outlook.com (2603:10b6:806:383::11)
 by SN7PR12MB8435.namprd12.prod.outlook.com (2603:10b6:806:2e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 21:00:24 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8642.namprd12.prod.outlook.com (2603:10b6:806:383::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Sat, 24 Jan
 2026 21:00:23 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 21:00:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Francois Dugast <francois.dugast@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev
Subject: [PATCH rc] iommupt: Only cache flush memory changed by unmap
Date: Sat, 24 Jan 2026 17:00:21 -0400
Message-ID: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0358.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|SA1PR12MB8642:EE_|SN7PR12MB8435:EE_
X-MS-Office365-Filtering-Correlation-Id: 66204e21-2405-4be9-20f5-08de5b8b9736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9JyJnLUhZN7+98xEXAmtocy/Y9ZtWcR8lvtzkCIZG14t6+86/NCKG2tHFUEv?=
 =?us-ascii?Q?BZ18ycjbwNkIrDiOhemELfcFYx+sUN0bhuMa5IJ6Rhh6xki+n+rOWEJvJ97e?=
 =?us-ascii?Q?Osv1IpxKeecZMFM3SqXD3jiEoGuXYY+ylyEju7ZtOenmWQCl8LPf4LMTScE/?=
 =?us-ascii?Q?/3Z24TS/mZRV9FtmtZPWKOiXIBLoqJOCPMveiVmOZXjS7XP/tkZj6DyHPa71?=
 =?us-ascii?Q?ATSuKVSXKx9zamuByO21Wb1WhuEHNsCxLGo1oBDfOxvNvvM9IKt3saOANAAO?=
 =?us-ascii?Q?kWe+58wMRDgTdRII4oz5pbfS0+fWk4XEuHahlFrHgewQEjZV72P2lEnuutUJ?=
 =?us-ascii?Q?ZCfHsu+REQGid0zSsdHskMYtK6r9B6WRlU8uug4ZLSw26VRQV0QDPmyvtVIL?=
 =?us-ascii?Q?fo9SL+rLuylY1Uxi6nBxnrWwGwkF1Ji7RHneh12MDP/VvalGXATPNYx6GODj?=
 =?us-ascii?Q?NbRkxannpGOtq1jrHeDySmk6GTqgm/ZJZtfvgRY2lA/7nQmtklxbYEV6zp/q?=
 =?us-ascii?Q?G5vsSRbwYyJ24V+dAhAIYG1E9AvoZGEPkQEsQ2ovN2DhlG0ZFJNEI51WCl0Z?=
 =?us-ascii?Q?YrzeyvGitCua1KGlZzJ29lKCyn4fRvnjGaxt3I65Vwl1auUETdn++NYq+lmt?=
 =?us-ascii?Q?74347TetGbxgmcdY+q86rRAYDDljsOiFsv/N6kL0+HZ42PWutJI+QRKhaiNa?=
 =?us-ascii?Q?znod7nH97n27xLjKzDsnIv6gnh/jZurgzbHyinkfsvcFZv3iYOWQ1I7spR4+?=
 =?us-ascii?Q?TSuggTbdB9/v/T9u0M2maMO7fJUCEwCbux7oGNBm2HpYPtB9otVfThXD/qHi?=
 =?us-ascii?Q?JJUJK0N4Tg7TVTYbrQz8oJcKcYYd141bFwyNL9GiP10R2cTGzQZgUNk6gOdG?=
 =?us-ascii?Q?CdbkJYEjfCx0oekk/SfrqgSwje+V+ROZkMqLsbTMTrMABb8mBSpg7gtMKYLI?=
 =?us-ascii?Q?4cflE7C8JN3niq+f/Bt29ZPHsAVquz/Lhkunwo/9CgKzHhcF22+l6VQepeF1?=
 =?us-ascii?Q?nUJKyuc0xPBIGaqeagsF4GjERSnFuhGYnl22zjX6ftXZq6cBm/dn2s+2C6hm?=
 =?us-ascii?Q?jQikrlUooILoRWF36MA6F4GAvVdyP45Rbe6bKhkREfKeIzyU3ztWxEkXSyYG?=
 =?us-ascii?Q?zI24M4sBmqGRCvZes2+VNyIjAb/Ptp5Ovp8attQ1QSiBDP0aetU4PRYOuZak?=
 =?us-ascii?Q?F6wAHDwnqZ0dPgv19KYjsA4PrQ0XHHHa/QFgn0YmAyifri/EYaiQV0+bByWs?=
 =?us-ascii?Q?L1V3f8+JKz9TnVerPk48mh56y1flrQSrlIQhjvEBkrqNtM+Rd3nJpQBNkXbz?=
 =?us-ascii?Q?3TvTeM4UWKu85onhh1TnTOWemAtaXHvkrONLyoxgBA46p+227xAuNcP9LgEC?=
 =?us-ascii?Q?KwxslFoKWFOkAaRQvoRDvEFexaIq8PMDLugp3E+KuQKRjOosa5VZmfRp4DNS?=
 =?us-ascii?Q?rJPBfeHhRaNH0ksyPuKtLuZZSYpt/y6uFL5bx3vN6AsHaedPxNJCmPooC/GN?=
 =?us-ascii?Q?w6TPOB8nK3MbsQUXIzsHGtUcvDk8E4iW86dK9H3J5GeWG3VlQYo5I1t79kW4?=
 =?us-ascii?Q?XctY8CX7RbKKOG4rxsQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8642.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fZJs/qhLGiV+o2dlO7PyEac4EVg3fFD1NGM0EGud3tsx/pJ+xHqgPRlirgn+?=
 =?us-ascii?Q?pa+diI3sGYz+JrGONkRGlxHIa2xLFhC2kDSctPlHDPzRJ+bTQZEQ5GmZGm0Q?=
 =?us-ascii?Q?BpKfUDqWaBrCTMHX7KDUpjiDsAAfflFCGV9xJq6ygbA/7PlMv6lxyNarSi49?=
 =?us-ascii?Q?UdDl0hL1TG8F/k2dc56R+3UvI9C6oHNhfeKhvEat9mquUF5OVJtCMSzcaqW/?=
 =?us-ascii?Q?BalR4tfTK0SLVWrhTODKPOxSgzAyJyNpHgGo+cGXKxCdcpSZTFdj04AC12Uf?=
 =?us-ascii?Q?nLxoRofDyNfJxRpixePOk3PTHu34PyDjzpj/OOyoVOKKFmyr5JVG57DMRJri?=
 =?us-ascii?Q?vUbhun4URpFkMwaMVbDH7RVTgREQA9Kx1UTa0KOPETBL6sNho/JcydU5v8Mx?=
 =?us-ascii?Q?F0TlDPEC8AhrGLEmYWzrm0a3qDCyXChs/0Ykk8+3jed5us30wjcB3um6BNgM?=
 =?us-ascii?Q?Z1X8XcZeIuuAo/ruqlOA1HKtK/Lj5JN/vd9B7EPwguM+4vJi6XR0T3p6xZIG?=
 =?us-ascii?Q?QoHssXxl909XKgiMtTQQbJFBGrmV/mZ9MqTTG+VOgWDsA3ESn+I9BOFHio21?=
 =?us-ascii?Q?sEmD+gu8lrN576idGMbtAt+ulRoj+oTp7iHCrV7vYutd3Obp3PLxM4yr5Cbj?=
 =?us-ascii?Q?xp3VEYW+YPga0ohTTSZwUfcD98d/sgTNm/+XyFJFt5tt4x29BUu0NPdFn8Y+?=
 =?us-ascii?Q?pcNBuM3LPW/TTq6N9i9x4jMjTBrPQfM2N6wNt8vxKdGXCePeJZfme8owQeIB?=
 =?us-ascii?Q?v7Yl2h45GQBbp8hg9uL18C6Xrw+d5UGZgfHU+kFrhK1zWibMk8Lqx6tGWyc5?=
 =?us-ascii?Q?ucfUl7AWFJCyzv8SavXjzibPf56qdyScCfLdFNH9NVlzAA7GLu2kNzjB+Eva?=
 =?us-ascii?Q?v9OBt+nv8HRqS3gMGBSMujrPL1nXs/qYmnkeLoq8FMIY5fh5b7hsIR/TdlgE?=
 =?us-ascii?Q?/+KINQNW30Q+4CgGk5oKdk5tYbnIqCB1jpx9/AqwCgJxy34FdTOTz5yx8V8P?=
 =?us-ascii?Q?xRmSbY6DZE/8vDe2qmk8U9s87iva6843b8BWFuFwGP2ZXawXX96ZQWvzcFAQ?=
 =?us-ascii?Q?Chm5cEvL+ZL8QOWTF4Vp74SxpZEIWTY/AGe/hEYVa5YcNtgWcnYmWJ4BpeK3?=
 =?us-ascii?Q?Y3ZwWWgRef/lOYSv+EPsjD+ZLjHSbgV/M5MO72kcG+DTb1iaIbpR0GMj2h3b?=
 =?us-ascii?Q?lmQxjTVk2V1kwExJgibb521SlncRAxKOoRlf6dfr4HhYyl9r1EH7d+Q37zLC?=
 =?us-ascii?Q?9oZKB9cvhllGGOPH9YOWXPWg3vi5xlir5+c8MtNEkTtY1nRLyZRLxlh53hnM?=
 =?us-ascii?Q?+K/EgVDafZaYR1UIln1AYxX9oWx6f5nhAy4bcdtppcXnNPgbJkJE4JrkZ0SO?=
 =?us-ascii?Q?CLyWNp5S7lip7aJ8b9mJeX/I6J0jt3QaVVS+DMu4DGgSg+6f57ZvbZXmIm2U?=
 =?us-ascii?Q?ZudK2nFK1gBmeoQ/byD0O6e2rThU35g+rT8I4Fd0zv1q2rpQfHMMrfhklPLT?=
 =?us-ascii?Q?UcuzagI9PHodbH3WjFa0gEU8k+HcU7J7XPjXaFaI/tz6Fai3oSnWXACObVFJ?=
 =?us-ascii?Q?yJBNSy0Obz7jqyEya7gStyn6FIeHbk1g1/Zh/kzSkRdy/UvkGKU5gucF6m4Y?=
 =?us-ascii?Q?T9z3tBiag148VgZ4vqBEYxN4ublNIvSxtUx2cIfaEUagQu5VBwfGM5UaSHNf?=
 =?us-ascii?Q?FldWIpSWQvYNaprcOu8Dx6cdonHwftlFdkyLRwHIugUwc6Sg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66204e21-2405-4be9-20f5-08de5b8b9736
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 21:00:23.3400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6G5oN/nyWHBl3Dx5KEneFgKkt3I/vj69NvaoR9gmrbyZFag8uf1IiYmlQ7mF2pc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8435

The cache flush was happening on every level across the whole range of
iteration, even if no leafs or tables were cleared. Instead flush only the
sub range that was actually written.

Overflushing isn't a correctness problem but it does impact the
performance of unmap.

After this series the performance compared to the original VT-d
implementation with cache flushing turned on is:

map_pages
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,    253,266   ,     213,227     ,   6.06
     2^21,    246,244   ,     221,219     ,   0.00
     2^30,    231,240   ,     209,217     ,   3.03
 256*2^12,   2604,2668  ,    2415,2540    ,   4.04
 256*2^21,   2495,2824  ,    2390,2734    ,  12.12
 256*2^30,   2542,2845  ,    2380,2718    ,  12.12

unmap_pages
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,    259,292   ,     222,251     ,  11.11
     2^21,    255,259   ,     227,236     ,   3.03
     2^30,    238,254   ,     217,230     ,   5.05
 256*2^12,   2751,2620  ,    2417,2437    ,   0.00
 256*2^21,   2461,2526  ,    2377,2423    ,   1.01
 256*2^30,   2498,2543  ,    2370,2404    ,   1.01

Fixes: efa03dab7ce4 ("iommupt: Flush the CPU cache after any writes to the page table")
Reported-by: Francois Dugast <francois.dugast@intel.com>
Closes: https://lore.kernel.org/all/20260121130233.257428-1-francois.dugast@intel.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 3327116a441cac..687bb4e3d8ca5a 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -931,6 +931,8 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 					struct pt_table_p *table)
 {
 	struct pt_state pts = pt_init(range, level, table);
+	unsigned int flush_start_index = UINT_MAX;
+	unsigned int flush_end_index = UINT_MAX;
 	struct pt_unmap_args *unmap = arg;
 	unsigned int num_oas = 0;
 	unsigned int start_index;
@@ -986,6 +988,9 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 				iommu_pages_list_add(&unmap->free_list,
 						     pts.table_lower);
 				pt_clear_entries(&pts, ilog2(1));
+				if (pts.index < flush_start_index)
+					flush_start_index = pts.index;
+				flush_end_index = pts.index + 1;
 			}
 			pts.index++;
 		} else {
@@ -999,7 +1004,10 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 			num_contig_lg2 = pt_entry_num_contig_lg2(&pts);
 			pt_clear_entries(&pts, num_contig_lg2);
 			num_oas += log2_to_int(num_contig_lg2);
+			if (pts.index < flush_start_index)
+				flush_start_index = pts.index;
 			pts.index += log2_to_int(num_contig_lg2);
+			flush_end_index = pts.index;
 		}
 		if (pts.index >= pts.end_index)
 			break;
@@ -1007,7 +1015,8 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 	} while (true);
 
 	unmap->unmapped += log2_mul(num_oas, pt_table_item_lg2sz(&pts));
-	flush_writes_range(&pts, start_index, pts.index);
+	if (flush_start_index != flush_end_index)
+		flush_writes_range(&pts, flush_start_index, flush_end_index);
 
 	return ret;
 }

base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
-- 
2.43.0

