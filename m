Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785453;
	b=3CXDUITTDHsNfZKKAfahf4zMv0i0O+vZ464cbJwVBR+fnsyUoX9/yXCWCK/Mvxp237Tn
	 PhkzekbS6hd0AtdVDzQLw3yD3T/9DQPJtgiXuqom2L5SLzO+zsAXQ4Pof2TxpSqqV7B1V
	 7r3/2syxho2eCh3tshNTteNl3JDqVtGpMY7LBm3KEn7QsNiFG+r3m731wWayUZIqzp9XU
	 HzPBsiHT7NvylHhHSh6bvS17xhFrJzfb5b2G2EsWM5ImSZ+yOswjnSnAJWgYT6VjYqVPM
	 d0ywW3wKMODEPACA5wADclaJvQLCKnlr9hmseTt4PdmtgZ+jWRlC3VffEcD3VhY90rA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785453;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ziEXjdg+riUqmbEGaDexX/ubm1fAtX6hoj9T+Na3T2U=;
	b=wDJHdmQ4Ho22vk/NujoBwgHm1Nq/3QHw5/nMWV4TAG7ISEZnYu0aiNJAHLx9VimlM7wm
	 hxLuTZiaqmmcqyOfTEtoEhl8lciGNACmk6gycPhyYbmXF0RVEkC/NUDYFb1gX7kPy2VIO
	 Zp04YipazNIepJlVKvPy/FIc3v5c1f7wuplKiXocA0p1SaZGsqajXn4iXN/FYjs6fziPm
	 gHrlQFBbSWt3Lk3bcMFmCXXpbaH51XzUN0pLIL7/E+TwZafVl6uCdtFPkjzbj8UBh+6j0
	 2xCi+hy9Hy84KzXH0BNC1sTDkHlOv1j5dIltOoVouCw7Y346PNs2hKrpvhGp0/otzNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VRD9eN2j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89459606A338;
	Sun, 15 Nov 2026 23:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89459606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VRD9eN2j
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m68ae4hWBWcWo8/rPJKFkORqKPLQ9hmxxQNK1fu2zUoxQyk0LcsNcFF4Xi7PGEaYCEZsLgaPRpFl+KFVCB5uHEH1TTfGrkBjZpi2+q47GSKVe5p0LO8ZzFsIVfEebcoiAo7cYfbj1B6dHQIFd3KxSDRYtZRlaj5GZ76gSp4bZLi3SSZ9zz6+OWYtT5Ge90kN+iEy1LS+xXMrHRZTg7tgNUu6U2alVlH91L2rrFtGrI2xjsnDlJhdEIcUBD4BIxdBJuP4Z4QZPVDZKdQTIaYiHq1rTrC4zkARjlR5wZmnDmLJOPQM3aYoNgdtgc9lbApKFGwsA13Sr3tDjM2cl5RicQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ziEXjdg+riUqmbEGaDexX/ubm1fAtX6hoj9T+Na3T2U=;
 b=zEMtSnCGPXOBo2TZVnivtEw3GXWPNv2nqVVLqrQoxAGW47MyHxwB31S3z4S6x2vLQ8HaP+BMq5WEn2mCxfy6sxqCAlVKVM93ZpZ6lchdhwLlb+U7OyMsgnfq1Yx18hdI+6qvZaUsTkdL8rIcHo9Huc9Jtw/Ac6tHgXxmoj8bUY9m9fc8TeA/4z9R3+ZhEDndlY94WpnhfMHGW+uXBLZ9GmRrYrCz8OfDgEjfU7KLIS1KuAIaUukus8Sc1kbZpuG79tlgIKlhuoNWKEySyZVwL2vNRTEahZf5g+gNQDrPjJnnqoPqCZ2gSFUPoDs+zWnBdprUfpv+wT6vwYjGRJSe7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ziEXjdg+riUqmbEGaDexX/ubm1fAtX6hoj9T+Na3T2U=;
 b=VRD9eN2jiC0Xn/33Le04McfD3uY8uUzTk4izkhjh/HHIdWD5bIfutDjREaB8eEWiNOr1t5u2wnobYKvUo/TpCAPFIi5EtVWR5tmutenQFaY1MktasdcKPwnuq0oOMoOK4uZQG+G49YlBSWBITsYDy/Vl9W8SNtdo01mV/PvcQyhHwv5Yy4hEQ2Sy4EjdPqetKMR5oWSLsg0tqBtqlqoF4F4bXlyIkeHqXV4IJzzL0AFaSpPzhQzzsK/yQJRIjtufGN0tM4XsJFZwlMQwLgApOglK8BBCXCKabFlg8geaOGIlPswLlb726FY6XyyQT694fBd2q99AI9W9oL2vqt28Xg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 01/13] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Sun, 15 Nov 2026 19:30:31 -0400
Message-ID: <1-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::15) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: 12599be4-f738-4f44-ba4a-08df4370786c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261021135927099003|261022115727099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	+ZZEX3gPVENlRzisuhgfd3N0PkwojCCMJdG1ncHLUavjg6lXsscTUaHfXtzFj11Z3anzAbQQxIeb7RNXue4CtiSri9FgnMc1GGSbpSy2zkg4GIYGk/mavF7fEeyDB7Rij641Mb0vQ9h/+MrnzoifOgyzwRK2mBICfabqv5N4AtoJA8fgvURSUzqLAcebKvn8F2porLKuYzcZcR61plLVl3DC7aSBaBD3VCf9h7Rn4QIfUIKjS6QkzfrVOL1crOldKYvwiYkCvZOl6/ClO4LrevEXEwkl3/lwuMA51mVp01P6aQnrh1xZXTLFp6/vxERdn3K+v0Vf0bm6V0hRpUte5jXlC+90UiGenuBwz0HRnIvd438JgtvjIKtL0TnoWltYaVvCRtLMTFC+6OrTHwBf7nK5wI7oXdo9Sg+7Zwnfk55A3Rcw7kT2Wex6c6YLyHwiGOTulYlYyluc4ip70ef9dY9EtQAfFQgUCtSKIKb64eJcH28iIUbacv3q0NGX6snY7XHUO9rTf8Mmij5HzR7u0mc0JyVeYuVx7NREvRFoDivdNSBlbzgVw8CA1l57HxcDrGEa7bY+R/c7m0Qa+o1V7pCy5QARYn5DaeakkuKZcl5rxuywceekXMXPanZXWokQ5jFVMCFJbTQpMBlEmaR1YfDiki8udq4W4dSeeWHXp78=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261021135927099003)(261022115727099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3nryVyIP3CkYfwtBzJTvYgUktSEJ3OeFEtE7bjvfk9jdpAxvsw1SCpo1gdQC?=
 =?us-ascii?Q?995gUmMYjmXnUw84O7NG0xPpMs6hgYaUc9CVGVU6duZeOIIq+ooUMV1ebyVf?=
 =?us-ascii?Q?KxK+3UPVpcxI9hn/yP9n1zWou0LYQcRXUtzGgm/4ogBCNakq/IH9QL7MhNPi?=
 =?us-ascii?Q?66E/5PCYTr61gEVTHe1tFkNLbD9HwvKcCB2oBB0IDSXZVVEZf6/Hp4pv9vta?=
 =?us-ascii?Q?UjrCLelxMBdya8wKuvhCAf6st3KshmoVVBjKj1uNV2+XjXKc7k4Gh9qUTS8J?=
 =?us-ascii?Q?ThsAMGZ9CUe0JSj9gDJOXmMOoipr8hFIu84s2aBXcizaZPO7y0X5Iw4Qqc9B?=
 =?us-ascii?Q?w26KmCKf+04ARNihtHbfJ6oQ92zkVX2gb8bW2sMC0QMhRB9MrlGu2i+Dii/2?=
 =?us-ascii?Q?NdYbsbd1obSgGwaJ3zM3m34Z4d3KcK1JGnDIh3qg0lD4EcM8gtcQvjD59+Yx?=
 =?us-ascii?Q?Xud30pkVoOw9Il/WP+wCSsAd7Xw6Jwe8c5JNXHCFL1blaaZqTRb/X9Iqj7gO?=
 =?us-ascii?Q?Nn99WKDKyzm/v4RzFr78ycpV2GRw19dr3XJI+wrGjLGOHe3Ji8jiuz4VXhma?=
 =?us-ascii?Q?KGt5cx3rPJVqpxrvmHmgMAJetrhixjfpuvWL6UOAKhyYKmiiPQuiYsp8h3Mx?=
 =?us-ascii?Q?1u/O3cE3J7HhNqM4SZeIhwHB8yN5ng/85/te3gqyHJgFx2UHOu0qU6DQs+30?=
 =?us-ascii?Q?/bTI8Jytk9KRJu/W1PQQgezM/wRTgHGrHCGnH401j3+B+qbGb+vKcq4k85kX?=
 =?us-ascii?Q?E6+UCp15T25SxgNZkApIMqz/RBXv81NXTzFfxcPZi1H3k/GbEQyu4Xy1AXl5?=
 =?us-ascii?Q?xtZXKPE519ZkyGftDk12m6ytVAApFUCSCjtJZ5Yn0pthgI9+FCHNNv3JqbiK?=
 =?us-ascii?Q?o3WkHwqyjWfp5JogaqVazVjhGgOwSS0KD/Bur73PQZA2/rxmV0wVdQSoBIQv?=
 =?us-ascii?Q?EaM+iXn3PVH0miac8x32SVnBIEvbC8rAKUCXL9o4LoYB2A3giuhtY93zgID/?=
 =?us-ascii?Q?2RnNgRlVTY6tZ3ReELX7qiK8G2ZJS/PTG3mnz8S9Cv03R7H7hzCU45lf3unL?=
 =?us-ascii?Q?Nej3SkFTrU4xLuFueoUwC7sALLv8Tfv52Y4CI68BgqWJ91mEWsM2Mfp5dx+K?=
 =?us-ascii?Q?R0Kmw4djQfcJq/IrN4LWkQCslC4UNd+O+IHPg9maI2fqYC6cQGdGBJjyS3P+?=
 =?us-ascii?Q?VoR41OD4kaDieaOlKKxQYZ1Tc7l8lCCNklEWCUBknX8m9BPdRtWCwWDef/yq?=
 =?us-ascii?Q?apeHFki7vl6VrOgZDPKRXLTEhfEMjpyrdB/Kaz3vini7VBAGauEJvLt9Ja7I?=
 =?us-ascii?Q?cH0LRHfgbDgz8pBUsg7lPepLj15trP3+nlJYSaeQj9bIIGQbsIIigguyNfFt?=
 =?us-ascii?Q?iHOvx7cQ9VDtpOs0A/ZdGuPwTnJXf+4GHtu0UnBn0A1cSErS3bqp2UhcGi1N?=
 =?us-ascii?Q?Y+v6wJCaR/WWUJE/a8zUkceFRnazILCpZvj5z088hYaufaSgpIS1hPEA2ie4?=
 =?us-ascii?Q?spFLbeZNpWUMYNjl2kBuNbK1ibtVZncXayVfyXuZbyRuE0yHA2kbb37xkaO5?=
 =?us-ascii?Q?g81VcPxlDFbWczKqUqWJGCrVhPZM61HyLEMcawgVu/HRZok0TcuVzLraFD8W?=
 =?us-ascii?Q?Khox09hFoASdnAPpOzMQdZTG5LIIpbQTryu/jtciN95jzDHpxIbNuo6jY0hm?=
 =?us-ascii?Q?EZ7nO+ajpFEyqHRTvv66zQrZ7gpSWYEkOrJ35S7dFwaT+ASf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12599be4-f738-4f44-ba4a-08df4370786c
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:44.7627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DNrmDAJk8vN1w/yYqcoKje/g55uqBV6rRNiSC/KgeUKPvwVsTwKlde9JMQd+/EnH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

The range-invalidation logic has long had a FIXME that there is not enough
information to properly compute the range invalidation. There is also
subtly not enough information to properly compute the single stride
either.

Change tlbi to use the information format that iommupt is going to use for
ARM. This prepares the invalidation code to support iommupt and fixes two
small limitations with the current code.

iommupt is designed to accumulate all invalidation into a single gather,
then the iommu driver should issue a small number of commands to execute
the gather to control invalidation latency. This is in contrast to
io-pgtable-arm.c which generates many gather flushes and direct walk cache
flushes as it progresses.

To accommodate this the gather will accumulate "damage" in bitmaps, one
for leaf changes and one for table changes. This is enough information for
SMMUv3 to compute the proper stride for single invalidation and to
generate ideal hints for range invalidation.

Change the inner workings of the tlbi process to directly use this
new-style gather description with the idea that the iommupt conversion
will just direct assign the gather fields to the tlbi.

Rework the three places creating the tlbi to express their needs in
terms of the new bitmaps.

1) Simple iotlb invalidation always gets a single range of leaf
   levels, so it can set a single leaf bit

2) Walk invalidation is expected to clear the table, child tables, and all
   the leaves it could contain. Set a range of table bits and all the leaf
   bits.

   There is a weakness in the existing io-pgtable where it double
   invalidates the leaves, once through the arm_smmu_tlb_inv_walk() then
   again through the gather. Since these are separate operations they are
   not capped by the invalidation count limits and a single unmap may end
   up doing thousands of tlbi commands. Eventually converting to iommupt's
   gather only approach will correct this.

3) SVA invalidation has no idea what the MM did, so it will set all
   the bits in the bitmaps.

   This corrects another weakness where the range-invalidation logic
   was generating hints assuming the #2 rules which isn't correct
   for SVA.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  29 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 193 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  25 ++-
 3 files changed, 188 insertions(+), 59 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index faeec656da9e7f..fdc6cb7a128037 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,17 +140,34 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = start,
+		.start = start,
+		.last = end - 1,
 		/*
-		 * The mm_types defines vm_end as the first byte after the end
-		 * address, different from IOMMU subsystem using the last
-		 * address of an address range.
+		 * No information comes from the mm, assume the worst case that
+		 * it changed every table level. The way this is hooked into the
+		 * mm is tricky, the range won't be expanded to include an
+		 * entire table level if one was removed like the iommu gather
+		 * does. Thus even if this is a 4k invalidation it may be
+		 * including any table level too.
 		 */
-		.size = end - start,
-		.iopte_size = PAGE_SIZE,
+		.table_levels_bitmap = 0xfe,
 	};
+	u8 pmd_lg2sz = arm_smmu_pt_level_to_lg2sz(tgsz_lg2, 1);
+
+	/*
+	 * If the size is small then we can infer the invalidation is PTE only
+	 * and set the PTE level only. Otherwise it could be some other
+	 * combination so just set them all. This allows range invalidation to
+	 * use TTL=3 in cases of PTE only changes. The mm must not try to
+	 * partially invalidate pmd/etc.
+	 */
+	if (end - start < BIT_U64(pmd_lg2sz))
+		tlbi.leaf_levels_bitmap = 1;
+	else
+		tlbi.leaf_levels_bitmap = 0xff;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 100b34f070328f..54178af99c9407 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2418,8 +2418,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2545,16 +2545,11 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 			    u8 tg_enc)
 {
 	struct arm_smmu_cmd *cmd = &tlbi->range.cmds[tlbi->range.num_cmds++];
-	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
-	u64 iova = range_inv->start_tg << tgsz_lg2;
+	u64 iova = range_inv->start_tg << tlbi->tgsz_lg2;
 	unsigned int num = range_inv->num - 1;
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
-	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
+	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tlbi->tgsz_lg2, ttl))
 		ttl = 0;
 
 	/*
@@ -2562,9 +2557,8 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
 	 * to target only the exact leaf entry.
 	 *
-	 * For a single tg invalidation a 0 TTL can come from places like the
-	 * SVA path that don't have enough information to get a TTL, or as a
-	 * side of effect of the splitting.
+	 * For a single tg invalidation a 0 TTL can come as a side of effect of
+	 * the splitting.
 	 *
 	 * A single-TG invalidation cannot reach this point if it is part of a
 	 * CONT group, so it is safe to transform it into a single invalidation.
@@ -2575,14 +2569,84 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 
 	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
 		       FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+	cmd->data[1] =
+		FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
+		FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+}
+
+static int arm_smmu_bitmap_to_level(u8 bitmap)
+{
+	return 3 - (int)__ffs(bitmap);
 }
 
 /*
- * Generate up to two range TLBI command payloads covering [iova, iova+size).
- * Sets use_full_inv if the range is too large to represent.
+ * Compute the TTL hint from leaf/table level bitmaps. 0 ttl means no hint
+ * invalidate all levels.
+ */
+static unsigned int arm_smmu_compute_range_ttl(u8 leaf_bitmap, u8 table_bitmap,
+					       u8 tgsz_lg2)
+{
+	int ttl;
+
+	if (leaf_bitmap) {
+		/* If TTL is used then only leaves at the TTL are invalidated */
+		if (!is_power_of_2(leaf_bitmap))
+			return 0;
+
+		ttl = arm_smmu_bitmap_to_level(leaf_bitmap);
+		if (table_bitmap) {
+			int table_ttl =
+				arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+			/*
+			 * A range invalidation with !leaf_only clears out all
+			 * table levels above the leaf level ttl only.
+			 */
+			if (table_ttl > ttl)
+				return 0;
+		}
+	} else if (table_bitmap) {
+		/*
+		 * Table-only invalidation. Spec says:
+		 *  For operations with Leaf=0, invalidation of cached Table
+		 *  descriptors for the address and scope additionally occurs at
+		 *  levels between the start of the walk and the level before
+		 *  the last level given by TTL.
+		 * Choose a TTL hint that covers the only target table
+		 * descriptor levels.
+		 */
+		ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+		/*
+		 * 16K granule, ARM TTL=1 is reserved (SMMUv3 H.a Section
+		 * 4.4.1.1) if DS=0, avoid it always for table invalidations
+		 * since we don't know what instance this will be applied to
+		 * yet.
+		 */
+		if (tgsz_lg2 == 14 && ttl == 1)
+			return 0;
+	} else {
+		/* Both bitmaps zero is not allowed */
+		WARN_ON(true);
+		return 0;
+	}
+
+	/*
+	 * Assumes the page table is formed properly and does not trigger the
+	 * 16k TTL=1 condition for leaf-only unless DS is enabled.
+	 *
+	 * ARM level -1 never has a leaf so something has gone wrong. ARM Level
+	 * 0 cannot be hinted because ttl=0 means no-hint.
+	 */
+	if (WARN_ON(ttl < 0))
+		return 0;
+	return ttl;
+}
+
+/*
+ * Generate up to two range TLBI command payloads covering [start, last]. Sets
+ * use_full_inv if the range is too large to represent.
  *
  * Normally the first range invalidation is the largest representable span which
  * does not exceed the requested range. If necessary, the second range
@@ -2591,28 +2655,21 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
  * invalidation overlaps the first instead of exceeding the requested range.
  *
  * For SVA on an invs containing an SMMU with ARM_SMMU_OPT_FULL_CONT_RANGE_INV,
- * produce only a single range invalidation and overinvalidate so any potential CONT is
- * covered by one command.
+ * produce only a single range invalidation and overinvalidate so any potential
+ * CONT is covered by one command.
  */
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 				     bool single_range_inv)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
-	struct arm_smmu_range_inv first = { .start_tg = tlbi->iova >>
+	unsigned int ttl = arm_smmu_compute_range_ttl(
+		tlbi->leaf_levels_bitmap, tlbi->table_levels_bitmap, tgsz_lg2);
+	struct arm_smmu_range_inv first = { .start_tg = tlbi->start >>
 							tgsz_lg2 };
-	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 last_tg = tlbi->last >> tgsz_lg2;
 	u64 num_tg = last_tg - first.start_tg + 1;
 	u8 tg_enc = (tgsz_lg2 - 10) / 2;
 	struct arm_smmu_range_inv trail;
-	u8 ttl = 0;
-
-	/*
-	 * Determine what level the granule is at. For non-leaf, both io-pgtable
-	 * and SVA pass a nominal last-level granule because they don't know
-	 * what level(s) actually apply, so leave TTL=0.
-	 */
-	if (tlbi->leaf_only)
-		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
 
 	/*
 	 * The spec defines the invalidated range as:
@@ -2653,20 +2710,43 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 }
 
 /*
- * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Sets use_full_inv if too many commands would be needed
- * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
- * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * Compute the stride for single-page invalidation without range invalidation.
+ * Returns the log2 stride of the lowest affected level. Single invalidation
+ * removes all IOPTEs that contain the IOVA invalidated, and we can reliably
+ * assume that the architected page size and table sizes (not contiguous!) are
+ * reflected in the IOTLB. Thus if there is a 2M leaf entry we only need to
+ * issue a single IOTLB invalidation within that 2M IOVA.
+ */
+static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
+{
+	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
+
+	if (WARN_ON(!combined))
+		return U8_MAX;
+	return arm_smmu_pt_level_to_lg2sz(tlbi->tgsz_lg2, __ffs(combined));
+}
+
+/*
+ * One TLBI command per stride-sized entry. Sets use_full_inv if too many
+ * commands would be needed. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h.
  */
 static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
-	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
+	u8 stride_lg2 = arm_smmu_tlbi_calc_stride(tlbi);
+	unsigned long num_ops;
 
+	if (stride_lg2 == U8_MAX) {
+		tlbi->single.use_full_inv = true;
+		return;
+	}
+	num_ops = (tlbi->last - tlbi->start + 1) >> stride_lg2;
 	if (!num_ops || num_ops > 512) {
 		tlbi->single.use_full_inv = true;
 		return;
 	}
 	tlbi->single.num = num_ops;
+	tlbi->single.stride_lg2 = stride_lg2;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2686,7 +2766,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2711,9 +2791,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	}
 
 	for (i = 0; i < tlbi->single.num; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+					  !tlbi->table_levels_bitmap) |
 			       (iova & ~GENMASK_U64(11, 0));
-		iova += tlbi->iopte_size;
+		iova += BIT_U64(tlbi->single.stride_lg2);
 		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
 	}
 	return false;
@@ -2908,20 +2989,26 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 }
 
 /*
- * Called by io-pgtable-arm.c for each single table level it wants to remove.
- * size is the size of the table level and granule is the tg in bytes. This must
+ * Called by io-pgtable-arm.c for a table level it wants to remove. This
+ * implicitly includes any table levels below it as well, there is no seperate
+ * invalidation for child tables if their parent's range is fully covered. size
+ * is the size of the table level and granule is the tg in bytes. This must
  * clear the walk cache and any leaves within the range.
  */
 static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = 1 << smmu_domain->tgsz_lg2,
+		.start = iova,
+		.last = iova + size - 1,
 	};
+	u8 level = arm_smmu_pt_lg2sz_to_level(tgsz_lg2, ilog2(size));
+
+	tlbi.table_levels_bitmap = GENMASK(level, 1);
+	tlbi.leaf_levels_bitmap = BIT(level) - 1;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
@@ -4214,21 +4301,31 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 		arm_smmu_tlb_inv_context(smmu_domain);
 }
 
+/*
+ * io-pgtable-arm.c calls this function either under
+ * arm_smmu_tlb_inv_page_nosync() or via the normal iommu code to flush the
+ * gather. Due to how iommu_iotlb_gather_add_page() works the gather will end up
+ * with a single uniform pgsize leaf. If it has to change to a different leaf
+ * level then it flushes the gather and starts a fresh one. Thus this always
+ * targets only a single leaf level.
+ */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	unsigned int tg = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = gather->start,
-		.size = gather->end - gather->start + 1,
-		.iopte_size = gather->pgsize,
-		.leaf_only = true,
+		.start = gather->start,
+		.last = gather->end,
 	};
 
-	if (!gather->pgsize)
+	if (WARN_ON(gather->pgsize < BIT(tg)))
 		return;
 
+	tlbi.leaf_levels_bitmap =
+		BIT(arm_smmu_pt_lg2sz_to_level(tg, ilog2(gather->pgsize)));
+
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bb048e08d613d3..b08c112875d3b6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -830,17 +830,30 @@ static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
 }
 
 struct arm_smmu_tlbi {
-	unsigned long iova;
-	size_t size;
-	/* page or block size of the leaf iopte */
-	unsigned int iopte_size;
+	unsigned long start;
+	unsigned long last;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
-	bool leaf_only;
+	/*
+	 * Level bitmaps use iommupt numbering: bit 0 is the leaf-only level
+	 * (ARM level 3), bit 1 is the next level up (ARM level 2), etc. These
+	 * match the iommu_iotlb_gather.pt fields. Each set bit indicates a
+	 * change at that level. The contiguous hint has no effect on
+	 * invalidation processing because HW can ignore the hint.
+	 *
+	 * The pair selects the invalidation scope:
+	 *   table!=0, leaf==0 : walk cache only
+	 *   table==0, leaf!=0 : leaves only
+	 *   table!=0, leaf!=0 : walk cache + all leaves
+	 *   table==0, leaf==0 : illegal
+	 */
+	u8 leaf_levels_bitmap;
+	u8 table_levels_bitmap;
 
 	struct {
 		bool use_full_inv;
 		u16 num;
+		u8 stride_lg2;
 	} single;
 
 	struct {
@@ -1213,6 +1226,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
 	/* Prefilled for invalidate all */
 	struct arm_smmu_tlbi tlbi = {
+		.start = 0,
+		.last = ULONG_MAX,
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.single.use_full_inv = true,
 		.range.use_full_inv = true,
-- 
2.43.0

