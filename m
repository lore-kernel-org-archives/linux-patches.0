Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25EF2E62C0;
	Mon,  2 Mar 2026 22:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772490185; cv=fail; b=XmWWcTXmqR29DCmGbl68bnd7EFhATbcn+/sANDjIPRaiPuZ2RIS0waSqTwmSOCTdnOY40QVwMwPZj4ZUqXIqWqalpMcQEOYXv0HEwkfkJNfZzVCFNXYhCBqLYLb7xaPEPvzmuy/dozPh9mjyCuvc6qaCzuHhlYbSRr3xUE3XMUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772490185; c=relaxed/simple;
	bh=409Fh3QbT0RDmTrnK0jOSk/GJzvf8BIZA9FVCV0ykW0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jxAAAb1Soik4uNxvlILqNREUes0fZpI+XqcLZzHp0EiSYfNs74L8JMchnC8JCzg2ltvgKpA5xC5j4YU8RRGVRk5DM+CA29MOSVt7wD4szS/jaHkGpmv6xuJpTR1kvd7jKW/BiwltbrkXEBn0JzjeUMr2WOzb5XPlsfHyO1e2UYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kwqY+CZS; arc=fail smtp.client-ip=52.101.53.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kwqY+CZS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+dT8csIqQJORoD5BKORiwbUrKsy6+w9PvGMv0MOeqCiKpgJQV4i/AtRLKPHgWCRbHRYejthQhMJWzjrlHRR5dRAgyos11zHL2jXuA3Kg/wkht9hUmrBX6OF9AscTMVO/m0NOmjA8UUfB+1a0c06m1YWnQklIudRhXCxvADUZ4V6kCnhW4uOsT9NDAdAdLlW1oFlyDbApb69fjAVEumIDDM2NfG+UfBCLJqH09X0HNC25qy6VlsY6HgIClgJUfUxASW2wnd/bRXGnm2RxrMN6SaH8mpGIVVYSiS9QCTbMRZtlnlP7xOG5DTcssbsKCAyNyeZKZd8PP3rXgKuSrgtVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIhS/6wOkjx1p0qY4H/7hwWN2hbWmpd0iDDiTYRUoI8=;
 b=G75EeXtXpcj570EHZs2fbK4j5w0t7PfZAX4cqHKi3qizacueT/UdTDMHxwl+fgvrMQf5YaleW8+Wv4buZDB6s9AjzId1S8pY51SicU4boqDNP9fAL7jRpEaLJ1CYrw1svhyW5PM6c94f/RZFzBjH3sXzEJfyh/ON8F3Q9xdu8F88b7bDe+a5+V5SiIKVSPdvy6csEp6Z8aoIuo2fpYsFRv/3QHsyrcpGwl0UfpntA21P0wqpxxXTe49XHZ4RmlWM5fE2dsOqVa6MXePA9mGL6H4pmtMDF2ZCkBKRAJAyfPX3Wq2s2P5IIQ6uzgAtCDmhZJmbAN4Pcb5IlhFvvSPaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIhS/6wOkjx1p0qY4H/7hwWN2hbWmpd0iDDiTYRUoI8=;
 b=kwqY+CZSy9NHUGB7/NZvTZ4ihJ04MhivO69BWECIlC+Uwqd83pKR4ZlNXbCfM3GixdqnNKbtZoJZVYXVI5mXbyFN+70ViqXIgdfkwDYRRsr8SG3ql60vqEEjIWdCV17rbBVSih3tJgKyI0VWGH8bKJzLstHGjZQDt5GRnzbThLXp0S2Vj4uWREP7dspVe8jpW2zfuplgRZfxBBcZ+6wGMlF73QczDPCvoGjliIoSKSWDa7qG6tP8xWUvU94Wd+ICl2M4Leq4yg38T32UYoG0sy0v+PKJ3FiDfegjQHGP8eGlwRY0NdpzxTV8/OxhKPwDqaHO9jAjC94wgN9Er7ZD5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 22:22:59 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Mon, 2 Mar 2026
 22:22:58 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	stable@vger.kernel.org
Subject: [PATCH rc 0/2] Fix two bugs in iommu gather processing
Date: Mon,  2 Mar 2026 18:22:51 -0400
Message-ID: <0-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:208:236::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BL3PR12MB6473:EE_
X-MS-Office365-Filtering-Correlation-Id: a7941fff-ec24-46cd-fb9e-08de78aa3ff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	3K6xShan624N12/n4lMjXvV6hRzA7U4X6ruKwYrCpnOri0jOjgBscLPhNM9jNW7jYHHGtMsJB3VqW8AX4QXIecyyxknKmnM31A9mne3sfeRvpQXS+KkzYYxpuFTu0SPz8AI3mM6Trwbea9eY0NDc3C6CWjDzogg+k+67olVz5l5NB6fDPcKk5hrL7hMy3Pd4yrkqZKZV1oZk/XZzYZqPbMrOsFeYACoB96YHqN+b2tWNZ4Gg2ANUuZ9ZOZFNk43s3wVHn9sWnAQMEjGIyCTYp1jkJX110mxWeq82yJzVmo48h14oknDZVkP9ev5q5+H2iJHd+ZBhCO+Wa4RHg8SVA0Grl1S7MfI2zH+XqVwmJPcpKAk/o+mNaIHzZd8AocH9+oz54C3fh6c9bzK5gpm8e+WB80N78ldfjC0gg9KUniAk7H3nV4CDp0r1vP2SHonUhR7cH2jsB7PcoNtr7hsWXX14uOsxkf1v5GQMFq3Dqtvw6+o2Ng7s7+004OX/r8M3MOS3tT+eRuxuCN7LaUUfNRKbacZNbnGJol47VMyjPPwjxbmQ0FmCoiwVcObdwixxr72BSqb8UteILU0A6ooWtoj/hURzxJRAk5FLWCz5ANrZsiWFxH8BLR/hIufl0/KrlHT0PtHr2dpRpCGmMi80toc/nhlYdB6FjR06JIjYLMFvL6T6uekti69gZI18X9e5Ta9trUBD4y2ajHLAk4VWhNiNAaf34Zt9nhVPThkHsi8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8KR4QIZESQSHVaa4AM1RKNlQCdYnfyvuGErT+4vxAxhb2xuYCYHHXlFF21ba?=
 =?us-ascii?Q?1PD5kY2OM4qnLAwSyIfhDo/WKe3Pnvwxu3EBcImHNo7ZWMxfrMSLCZwyFmfe?=
 =?us-ascii?Q?askrfvu0gJWSnzabvEjKJkE1VHOLMFy8ufIneSExnRaUKwf9jboOiYC0cz7H?=
 =?us-ascii?Q?uYKZelvK6fOjT5WgbB+83voSGu4MwFn7mF+W9DPhDT0vidBIO5fZaLGm66CN?=
 =?us-ascii?Q?vH3byJq9vv/niDSl5PjcTOxvgQqfqA/2LzCi1W69m0aEsCFwpvUrz2KWoLVq?=
 =?us-ascii?Q?1/DKF2wUnKgRO9Vqlh9dAEc2Pf6Bfwp96IbbGzRNG5DFzdLn080SutWn7WAY?=
 =?us-ascii?Q?B4XI32zV8pXDxiRbNDNvcOU0U2yldFs5cfk7Q9qgpwOVRovPsza0L75CdtVp?=
 =?us-ascii?Q?aqWbeNyP4R47yycf2THr0NmMtq6a4bqq5hff3IziAdJsg8U4bBbs6ZEJDiaA?=
 =?us-ascii?Q?/xLIDNOHUesHL3O8zL2CjKX5kUiHZvJAa3K7M1GGZlbe/Mtn8Ad/4osdNRcA?=
 =?us-ascii?Q?0u9MbKv4CqLSqh/VO743GPDRDFgq/LanaBnry2SZDwG7Wdx3rTIPJoJCSJVd?=
 =?us-ascii?Q?y/vmSiowWVVKwDrXnM8TDYaW8oowltq+jBF+pm+NcGJOjAhLwjDM9w8K45G6?=
 =?us-ascii?Q?YnJdPVNjd3nrcNLLe9KhdbZ1YhlTyffEr0Q0JP5kaSPcmfc0ZKQn8VExD0Hu?=
 =?us-ascii?Q?HhLYsykwZNm31qjOP1u6EE+o5tPAj2Az8iuGyxDpWL65OgrjK1F/YFL6FkNY?=
 =?us-ascii?Q?c/djvXMGK2nXF+gE/OWyT77vjroBDtRotay5hvo6TQF/CB1wHQXw/M279sEB?=
 =?us-ascii?Q?fXMLRokHN/pOJCY28wbAOeSyY/Jram9IQu16wQY9muJapRmsAhDMPUFTkCGW?=
 =?us-ascii?Q?DNgB3FbvctQxOofTBNMDCYTFkivftvTd5G+agTyOHhCoKIWDRZwpvb/ccAev?=
 =?us-ascii?Q?w1RJ731Jl9FunjuaDof1IIK4qP6WSgXO7eIVU8BRHQFefaXC/Jf4/oaCpAR5?=
 =?us-ascii?Q?Sf2RH1A1SkQhgVVVy1VzSx2f0pg+WZ+XCXJwz5Y8wDBwk0tULUutQOMipeJE?=
 =?us-ascii?Q?SFJV4ZHYP+XdkEfqK2y8CJwKKy6Mmqfv4Pz4pcLqBH4cxCSJnCLKfDnT+oYW?=
 =?us-ascii?Q?evscWqVugDH3odsGydlcJPToiuLlEFkgHMI0IRWCr8csjhF9aXs0iFmQN9Uu?=
 =?us-ascii?Q?hsyzY6G7hUwSkoRkCszuIUFYHww267h9gxfy9FUqur47o/r5DEEujtTS3fkd?=
 =?us-ascii?Q?f5cszfhHn/r0AnqpkAGXcuLr0o6YoAvH30rbstwEIvwse57KDSLfNQdNEVqr?=
 =?us-ascii?Q?L3Fl8s5DBzvwAyYKMvWpjzsL9LTuCdK79NvonH3StBi6aCT/Gw+vs896pW1y?=
 =?us-ascii?Q?MLK0bF/WqYV4+IFRzGt/0iAF5hjzITYA2nFz7noyeQxT6nKjv0f9J0vcKGiq?=
 =?us-ascii?Q?WLEUl+tJcx3q4PPWTY/e8mL5oDhxKpHCEPs/si2ovfZraEkd7LKlILROHwIA?=
 =?us-ascii?Q?a/8/RbqHerVu+TRTRfLz4KCsaN+ux+kPOuZ0fpd+Liy6NJirnD5rHX096t52?=
 =?us-ascii?Q?8bYW9pK481xXNDFSIop7MfoZm4WWUFErjAq7e+MG/lwhheUXqN1i7ATBv2Rt?=
 =?us-ascii?Q?ru1X77PrByuCbHBldnbmh/aTPunaX+Om8XxCyVBzhZPiOAzZcSVGp5tR30Ur?=
 =?us-ascii?Q?Codka6ZRVkD2OIOsZpKhoVj4oj6+aIj79ltAqn97h+EnDClPrebJEA+RO+nU?=
 =?us-ascii?Q?cAT9XaZjTg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7941fff-ec24-46cd-fb9e-08de78aa3ff3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 22:22:55.0749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZXAzLsAXbHzuW7y4qW2m4XWOjowlK/+QXWXo3KvClWB+Z4kDhsfGUD0VzV54uTV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6473

I've been working on an invalidation kunit test and found two issues worth
fixing right away.

Jason Gunthorpe (2):
  iommu: Do not call drivers for empty gathers
  iommupt: Fix short gather if the unmap goes into a large mapping

 drivers/iommu/generic_pt/iommu_pt.h | 2 +-
 include/linux/iommu.h               | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


base-commit: 10595d49f542df65ad4107713017075d5b9b529c
-- 
2.43.0

