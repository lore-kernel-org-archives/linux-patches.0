Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D0422172D
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 20:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744056790; cv=fail; b=SOAD3WzmFBmxqncvKj4gSp2yBcW4f4F3i81QF8JKj5cU2zV760/43NsqgZa+vG5kIP3zhfbN0hqoDGvBGle598wvxbBtoU8qYu9CjZaMtXZh29CE783rSC2zaychXR1YdqDGe1KopOdQPlJzRANv7eqdfe9SwW3LkeKawa0NdiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744056790; c=relaxed/simple;
	bh=A/O8hE/dqD0ZQU0rbpJixFhLoPMXvgUCR6KaysWBDSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YvQcCo0Ko6GPHyGxqTlb0fqe/kQ/If/IhL2vYB2qkdBTPWVaRvnbFZb54Hggc0Ic2KpjbWwVrm3U6iwq17WHMm6i3rPyeww9imINwBG4nPhCCo1floCqt9fI+kpD3XYC5xcLLNQ1MHGuaKKfUmAsg4VO8p/+tNOQfAZsI3Cfqdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M8Wv76T6; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M8Wv76T6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFa56606jLGTUeQdt1zlVu1BFFZ77bctWgymINOYQcLdIESm7IGcv4rT+x/juYxCGn2wFJnPHlXYjhYDus4ZLQVT8kJSeWh+ITjMX75uz4JDf3X1rEQBjRugRwriSLyspnptA+KqKvnShQbOklPoznxCQyFjoFsL+I3ZqLMFwvE6zekt4I6XLEpkfcPKNXh5G7W2ZKL5oQNPUapcoUqvrmvey9RhOgwzTf9TeX4QBvuezFG4xtI2K0pb2sey1cnSh6eXu9qgBbOjghWwijMVF8bWPuvQXNdGyl6edJzVTs2B1cHR/B1jKFNJpmKC3R0rMRlADcCBq4CrmZIZoyRD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTFGT1A6QqqAhq7m1vPZL0iOEhyx1C7Xtcl5MUvgf3Y=;
 b=VGRi6pAmw0ey9s42EZeGEzVBdcHiFAxMkEqb5eTb0RYn+DYz8O9bzCiVxkDuZq4uNhSs09vhus1h6QuhtqHKvVjLwP1zWh2eX40rObAusFG9VIIwxKSjLF6vd0Qd+wHJznhOVZv/kJfhrcRyIVTe8zF0Kf6BX3iVx0RC1TvOH0HjNUVn8Kkbe3J+A8o33IlOP0QxuTzumcnFFReMq0vD4c+j2g/LNS1tyKa9WGPXP/rHpO5ATFjQjbSWXn5erOJL5vsEwISGjll/xbHX4RlBUyk9JVSClOZ9SHDK1F1kWQrQncE+kVNkUdbjsEY9HAPqhE6hLqAjx4B2TFvvgQyVfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTFGT1A6QqqAhq7m1vPZL0iOEhyx1C7Xtcl5MUvgf3Y=;
 b=M8Wv76T6D19Ym51IhEuiQ02IXdzN3PYTM5tOyV/+CvSWFB53KRwXeHakgLMWwUz1+10BgO9S9iv931n4voS4MObqLBgB6T+xWsLX64+yMCxlp9HhE/3GVLf6Q/sqEoJrBCZa4eSXHNgVJIqkS1u31rqKGcBSh/1GChacaJXbKot+H8jSycLHmyaVp2S139AwvvHTC2GrDkCiXtj8Z7LgA418V3fB3GNa25lDwiwbZxCbDGlrm3PDhlYH0QnqYMQB2DqLSABcpULB3wBk3xKvi1+RQ8UuiULtThO46qete+thkIyWyDS0TvYoKWYCOhecBd4NBdfgkybMk9cJcMPNyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6294.namprd12.prod.outlook.com (2603:10b6:208:3c1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.31; Mon, 7 Apr 2025 20:13:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.8583.041; Mon, 7 Apr 2025
 20:13:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Mel Gorman <mgorman@techsingularity.net>,
 Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <jackmanb@google.com>, Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 2/2] MAINTAINERS: add MM subsection for the page
 allocator
Date: Mon, 07 Apr 2025 16:12:59 -0400
X-Mailer: MailMate (2.0r6241)
Message-ID: <E7917C18-F3FC-41DC-AABD-1C0DF2367EAB@nvidia.com>
In-Reply-To: <20250407200508.121357-4-vbabka@suse.cz>
References: <20250407200508.121357-3-vbabka@suse.cz>
 <20250407200508.121357-4-vbabka@suse.cz>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0199.namprd04.prod.outlook.com
 (2603:10b6:408:e9::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6294:EE_
X-MS-Office365-Filtering-Correlation-Id: d7ebef9e-e8d2-401e-9349-08dd76109915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sNjwoGzfHRkTHU1OD5GfsKES1P5jQnrJLvZSPD3PMRn5n1BgKRUBpPUZjlXp?=
 =?us-ascii?Q?A15m39tyEo4U4fz1CDEB93KTKpPOf0+6Exutr7vt1e9cxYhmtFfdPf28Hzvq?=
 =?us-ascii?Q?Vujoqaqc/FsbrUSeIZzyHBeQT1VNP1xc+s1cGrR1iu0sj6ahkpg23BX9AE3F?=
 =?us-ascii?Q?eSdbjIvjZKrTS5kqIhL3+DjVprzvGbSjhvfuM/o683jVuMxkO4hJjLVDJdU/?=
 =?us-ascii?Q?uMEZvIPAykePs4oTcPxuV4NmZTpC5XyH5DoK1oiL9gE1ORuQKfAF8zekAhnV?=
 =?us-ascii?Q?ca6F9lSf1eKp2GyWrUBbz0AI3t6jwptv9LEnVQkLTy/CHz4yTiuBXT1SuV4o?=
 =?us-ascii?Q?0zu8SeZjmdp1hYaJaTkRT/6/M1er9O5Hwto4IMhIDqOP0GkiOxo7fbHjLGln?=
 =?us-ascii?Q?Dcz2oPQRyaxC8CNVMpZfY39aWJJxgOEue4ujRrDzK26E2kyDC/VMiY51NGXM?=
 =?us-ascii?Q?eVh8Foad7Cdd2UtnV0yagL7tVCiQWpXqkb4FT+X+nqPuRojuyS7t8wlY0ESM?=
 =?us-ascii?Q?w6OyjRgvLqHOtYTOGMd2U7c/1xs2qFR1Fp8ucKsULSD/4c+ea1z20ihVIMwr?=
 =?us-ascii?Q?o3nKtrh/7M5trwfbzuDGvRvE/u1AeVrfAEDN6OOcGGIlrGgUsQrXmQWEk3m9?=
 =?us-ascii?Q?+mZdLChHUoiZ8Bv//pQZGuKqqTCMVPxlltV6BQ9FZxvV3VfoNxee3p5PtBbV?=
 =?us-ascii?Q?ck0ic1j+TeQkgdsGTrrAhxTbQR2fc41qVwS8tEbGoZWv9TMOMh6sL64ovKxY?=
 =?us-ascii?Q?No0ikCNe/b9OaCZUsn2xGvtvhDGX5BLMI7hll6J78Ku1pf/oiv416+e30hNR?=
 =?us-ascii?Q?Dmb/hcdZGG4aAcQ8S1eDLLsLAkLk3/KLClTdn78yQlktJ3vji/XaLlfy8F79?=
 =?us-ascii?Q?U/eBEG150ks/NdFboZpwSctdptBVhaOLhBf8ZBCmgp3th/FDnIPvGZgtcKFP?=
 =?us-ascii?Q?5vm/JUQ3tlYPqIYlTOSQEILfSF2NksZIIHE+eKWMVx7RwnnrhNMQDP4eT1Lt?=
 =?us-ascii?Q?HICOUl7clFskmtxw6ScdXFlKd3MilQt5qJ2rQPLUiPamR3eItyDH42zTE9Kb?=
 =?us-ascii?Q?xAma/BtHr66fB2lvgW/lHbi4n6Rzz8+qTcBAPVlUZr3OMf20XDJV248+Jh57?=
 =?us-ascii?Q?ia+o5dD7OrnTPGVKxBSs5nFYCLwDYYENsK3ZE+JFusPhqcXqPHzOULQlJgyQ?=
 =?us-ascii?Q?LItMcYEZzsxS3kCA24tfd4WadrQICLbnASkJfvEMyefuQzOjS2pGkVWUv3pp?=
 =?us-ascii?Q?yM5Car2M/8BkgDIFQPvjD4lv4reAF/xzLSQ0wPb3DfOjZOjHX4eFeYlXrwT8?=
 =?us-ascii?Q?+UuwEQMd4BQJEvkKDASJ/rM6HRfToSi8DQZkL6pTevb7qUaYGsy5ahHvp3tC?=
 =?us-ascii?Q?GA/LX6xxiT8HCuY0uxrnMLZItc8PwCCFLp30YceKmWc+L3QX2ml2WQrTaNT1?=
 =?us-ascii?Q?Bdc9gr7i0IQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bf8oCcjzoAVkhXjnyScEicML3GxHjynKsoEfyOVvro6n2gltw6J1U51gFuB7?=
 =?us-ascii?Q?TBpCPic0vICT5yVjbQq+9Bd1IPuYCU4xzGe6r81eUDOw9q7HzkoUVC42T/Le?=
 =?us-ascii?Q?T2uxUd8pmB8KadeC5IqoCKsdJyfvt9e4uHRdM3E2zghIb+6xKPTgIQ/fARY5?=
 =?us-ascii?Q?YQm2ljWkCYhZEV/5D7RTcmYbIODjWOf6goFLR+xiorArse2fhEMPkOp604Ej?=
 =?us-ascii?Q?miEqp7trwnCy/NJqe4bnTBRCywhXetYSNxdsP1nOOngQ0mj8cSf+aamUFxaF?=
 =?us-ascii?Q?6icCu5e3+8DdH7U+WW/63zE0fWrpDJROSgPgkrNgHcjsBukxw+m+J67ZI5qb?=
 =?us-ascii?Q?hlRmJ1Ps0VnWKw8s4WdLH3Wl++8LhLxw3tPfwDPziv3sumbqyt98AMDoffs4?=
 =?us-ascii?Q?Hz2SzTf6jNcio3RnJGYOwhN8N0kBbdQraTFdOShehxq0jTfZ2APrb5/AZldx?=
 =?us-ascii?Q?RUfJputRxonpu9+NIjO89BpY0mzaJd93lx/RrNMoKiyJ0zXxx/nA8eFuzIdN?=
 =?us-ascii?Q?dEjXn2jBzpzPT5t7qXKSC3lC3+R01nJJy5Mvsd/5Xp6uIBPA079YQgPzj8/Y?=
 =?us-ascii?Q?3i53/oWs/viQbzSxY5kLiqvuhnhyMVV3YzTX5wd2MyJLPdq3LOJKkSAwHdD7?=
 =?us-ascii?Q?BSpkbIJrRNjFa7Gspfe2fTwTJffIPzxCkKPEad79VQgRDKHcpCvJqWqvVray?=
 =?us-ascii?Q?PvtBjbg17cKKCDasle4+PvTr741Rf3YMy74dnfXamP6+SkIL2M4LnMIqhxLk?=
 =?us-ascii?Q?NU+IUQIwKR5LK680wZkKSapSY55XVgek3uxkia2T0sfOa+cchSNjNE5obqLN?=
 =?us-ascii?Q?qhJzR+C5ztD0H+anOjr6Gv3s3l9BYl5gTDowiPW5sEklVjfTciyiJjUvoKNc?=
 =?us-ascii?Q?HkKar88REp93upp7sxzHV0HG79sPOrQNo5krL7YdYxtp+WCPd/S1XsE5naGY?=
 =?us-ascii?Q?D4qofZfTPwX8Nd3RIhOvmbvf0dA0pJ4WoATkgIuKoygLAlqbDB94JMJSGq4C?=
 =?us-ascii?Q?lzfrwu/8ewrslQ5AYMyXBdC4ajardMj6SSf5G0vgywR1U9DlbJJ+Fk6EPlrT?=
 =?us-ascii?Q?ngP8WVC5aiSpfibrbPMhkovYRYXmJvlcx7Zy1S2aX6bR5e9zucdCp4s3aS3D?=
 =?us-ascii?Q?bXf323GV3zxgC0k31+JS2Q/0SDFA62trYechuDMC6UvPN0vvVLxynxBhqZGC?=
 =?us-ascii?Q?OW2aC56cYgeqLAMTO6tzb4jZ8kKF67Sb/Xu1KcTYt6bf2L3k7ffRGCJYJbek?=
 =?us-ascii?Q?/egXHGA6JRiyGNwxOzOeMFrfDulFAmiMQrNtsx47mYWmY4EpJXQBZJ3tVVbO?=
 =?us-ascii?Q?ZEvMum9Xcy7nEwSyTZfXkyJfhwf6o20imoyo/dlaGzlPRsT5D992GlJYC9j9?=
 =?us-ascii?Q?vlJ3NrgGsELTv1Dqym6LX0qa5A62oSXEjT0v5MjyNgWjXh4EkBTv/VHkRu9X?=
 =?us-ascii?Q?P4eYfVFeO1z46bG7C4ko8WNoPw3XOzRd7ot8XZ3ZdbAYLiX3DQCO9K30Xcdc?=
 =?us-ascii?Q?51KDyj9yCMK1c5JiiYQ8gLJ4pBImLV7p56JI15wNoY4DAB41HQjciZMBhuML?=
 =?us-ascii?Q?I5mmCkL5nmsZc/RUTEP6iP3G4ip/JHvTutvRkoI8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ebef9e-e8d2-401e-9349-08dd76109915
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 20:13:01.7751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNGVJGZdcI7/HvXCQM793Gy8a3VRyUcmLBVb7z4MHs2AplPP/wzWe23NYrRTkYFM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6294

On 7 Apr 2025, at 16:05, Vlastimil Babka wrote:

> Add a subsection for the page allocator, including compaction as it's
> crucial for high-order allocations and works together with the
> anti-fragmentation features. Volunteer myself as a reviewer.
>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> Extra reviewers would be welcome, including/not limited the people I
> Cc'd based on my recollection and get_maintainers --git
> Also if I missed any related file please lmk. Thanks.
>
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Acked-by: Zi Yan <ziy@nvidia.com>

I am happy to help review patches for page allocator and
compaction too. Should I send a separate patch to add myself?
Or you can add

R:    Zi Yan <ziy@nvidia.com>

in your next version?

>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4fe7cf5fc4ea..610636f622b1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15511,6 +15511,16 @@ F:	mm/numa.c
>  F:	mm/numa_emulation.c
>  F:	mm/numa_memblks.c
>
> +MEMORY MANAGEMENT - PAGE ALLOCATOR
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +R:	Vlastimil Babka <vbabka@suse.cz>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +F:	mm/compaction.c
> +F:	mm/page_alloc.c
> +F:	include/linux/gfp.h
> +F:	include/linux/compaction.h
> +
>  MEMORY MANAGEMENT - SECRETMEM
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Mike Rapoport <rppt@kernel.org>
> -- =

> 2.49.0


Best Regards,
Yan, Zi
