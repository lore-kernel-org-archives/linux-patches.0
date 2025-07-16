Received: from mx0b-001ae601.pphosted.com (mx0a-001ae601.pphosted.com [67.231.149.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAD0256C6D;
	Wed, 16 Jul 2025 08:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.149.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752654354; cv=fail; b=TUDd6K73sulmhT2YX3gjOT5LVekawAsUdWaw2qobp1RNmYIgoSa3f/8qF8BayKcsQYOUsuS7Y5DyfmIrFUCvL2/Dh30dor/O6fwb3UvIXTyd7Yhud2l0srBl9AeXXcXxAIaEV86+9RxsPwc8iHGT75Op7vSLfNp9dzwlgXkCljw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752654354; c=relaxed/simple;
	bh=GheywaqvxyCZGZGuMEZhWn6HiqAU3KVUb93DWBHtIoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZCrklgkez4eqA0kpVh2m2NEH+MF/+/6UxC3vPTUUOIFncLvXtYTwVM2WfD7S5GEoGltNUev8BMM9+67qAN6sw4fk4NC3TSleH/TFpL87cw0NMOX8kxH3FfbD5sGPPCOSZt/tB8PBr13RXbRhmS647s+OlESLWG3xaRVZMmJxEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=hS1NFKY9; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=omw6nAVq; arc=fail smtp.client-ip=67.231.149.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="hS1NFKY9";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="omw6nAVq"
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56G6gcat021953;
	Wed, 16 Jul 2025 03:25:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=PODMain02222019; bh=B6SMdH/zH2MIFpAQBa
	+W3vC1ZbOnktxWwqbn0ygy+sU=; b=hS1NFKY9/+sajcz9gtM7XkDuEdrq84WFUH
	rDdFlpz7DMRhkqMgZagiNjYQQcvGUCvQ4eolgmINTDsEdk9xfP9Noh/ng2rA6jAd
	NVwsqU8r4WWDgOW2SvlSUhIwkBun6+SCqGoa/kZptyDolqdoRLMLnF58tPL6vSOH
	8Yx209axGWS0pMHCYEJZmSyw1/GbnqXmjI+Zl+kwwpHAr31ltTvqlo4N0lw2P248
	gLqQAWm3uCsQftHDHumcG/qCekeK7WD3/DBveXjcnzkWxCllkqZwnwPyJirhSypu
	Sh43IeNsjoSlR7RJVipsc15k1B30nvH9p4QNHZ50yi+w237c7lLQ==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 47un42db45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Jul 2025 03:25:27 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K1qhyg7fy9pwxev/shhOUuvd9XIs86cZ80jJd1YDd/HaWp2V/c6mg+mCc3qhZyE6gbpPvjCHLTot224acnYqudZaNMWCLYZk8ugNGvAwuKQLaFCdSd/+lQMsMs9dphikgVpuXzD4gfsNNX8z0mjIG3FpPPRmHXEhoIm/2GPU6yqjyErkD5JP/v0+FKxZsQP5+28+WZ8RdZFoEg0aF+v9K6nQ9zfAkpH8TKuJv6lBEvRXKeM6y8JWYqHa6EACE3pVWLniXuQF9Oa0Dc6ZskHUq/kifTGlf0QI29IWxsMs1+ERw5p71cc88jrnh8TxfiDTEvFo6zHe4uod0H9RAVlw7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6SMdH/zH2MIFpAQBa+W3vC1ZbOnktxWwqbn0ygy+sU=;
 b=p9RJayGTGo4AUcN0PeKNgdGedA333uMdwCQpocem6N71B08m0Rp8JhKfQSBiYstlLTDz17sipb35R83YmRArx38bebJkIYlRbLcCd/dZLEwI3Vvies43vi5sUjzUysNd6zcFxpJOdiwVf7Yt9vSAZecf5YrYs1uAwLL5VBWzeq40epyCYLa9OlHojWkDGO1ckxqAJPnkV9lFUt92TAYkvj/Cb0krhpN8/7czhAUfDEXUySxNq6PEN9XEsHqAWsR09bvJivTqVD5A1NZDa8bXHvuiDyCmqdvBpbKmdruIJOy7CNlnv802P44nc+b8oS8W4VWg0tSPuKwb24gFN4Q7WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6SMdH/zH2MIFpAQBa+W3vC1ZbOnktxWwqbn0ygy+sU=;
 b=omw6nAVqu5MfceYpmxn/5oe2yrs/C2NxmtHR1v9l6XkO/WUDCyQbH/WwLHUWP00RebBxym555TAHAlTy+IQxCeXKL/Ux4Uvix1UvqAhjEkuKUDxYWIqbJh+jzySvG1jI+0PWUA4pM61SR7aB2t1u8KIOvOBesG9QM9UMM3fDHWU=
Received: from BL1PR13CA0223.namprd13.prod.outlook.com (2603:10b6:208:2bf::18)
 by SN7PR19MB4751.namprd19.prod.outlook.com (2603:10b6:806:f7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 08:25:23 +0000
Received: from BN2PEPF000055DB.namprd21.prod.outlook.com
 (2603:10b6:208:2bf:cafe::ce) by BL1PR13CA0223.outlook.office365.com
 (2603:10b6:208:2bf::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.17 via Frontend Transport; Wed,
 16 Jul 2025 08:25:23 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 84.19.233.75)
 smtp.mailfrom=opensource.cirrus.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=opensource.cirrus.com;
Received-SPF: Fail (protection.outlook.com: domain of opensource.cirrus.com
 does not designate 84.19.233.75 as permitted sender)
 receiver=protection.outlook.com; client-ip=84.19.233.75;
 helo=edirelay1.ad.cirrus.com;
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 BN2PEPF000055DB.mail.protection.outlook.com (10.167.245.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.1
 via Frontend Transport; Wed, 16 Jul 2025 08:25:22 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id C1DA8406541;
	Wed, 16 Jul 2025 08:25:21 +0000 (UTC)
Received: from opensource.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id A8C07820249;
	Wed, 16 Jul 2025 08:25:21 +0000 (UTC)
Date: Wed, 16 Jul 2025 09:25:20 +0100
From: Charles Keepax <ckeepax@opensource.cirrus.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Maciej Strozek <mstrozek@opensource.cirrus.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
        Mark Brown <broonie@kernel.org>, linux-sound@vger.kernel.org,
        patches@opensource.cirrus.com, llvm@lists.linux.dev,
        patches@lists.linux.dev
Subject: Re: [PATCH] ASoC: SDCA: Fix uninitialized use of name in
 sdca_irq_populate()
Message-ID: <aHdh8LOJblKP01rd@opensource.cirrus.com>
References: <20250715-sdca_interrupts-fix-const-uninit-warning-v1-1-cc031c913499@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715-sdca_interrupts-fix-const-uninit-warning-v1-1-cc031c913499@kernel.org>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DB:EE_|SN7PR19MB4751:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a61c06a-d959-41f0-628b-08ddc4424f02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|61400799027|30052699003|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uGgfBblzBRlF5Mq2WwoBIyXzE4YujC3gVRN+8jvX/U8+WGrtsicy8BkpWxjf?=
 =?us-ascii?Q?CuxoYvJGiffDkbpK0TgkN3rl2dvbjtZm1wxmvDpzAuo4wQaGiLLVEVzqxnsq?=
 =?us-ascii?Q?eZrd42wW9BFVIdtrNo4X6528kxfsFzC1FLvl+MJBBSj9z0QORtIb/0aaHvP3?=
 =?us-ascii?Q?DWUhmS2f4N3Skgqbd0x2W3vNos6KI8CSvoOEbrB1Jm/w4sLTL3eIiDrT6sDU?=
 =?us-ascii?Q?5cAgZKCeOEo3LsNXt5TNmftrGcYgT5O9eUWBHltYQug6zuzEGS/i9JN8CvCa?=
 =?us-ascii?Q?vGrGojwxMtC9QyrlAteUPzwrCLTp7FMJ0oSd7/4y133+7tua3d25UUqUvZ0D?=
 =?us-ascii?Q?3Hm1apmUYYoLfcm//NOm3Cd8pxvFk/trrJbwSWMOlamEL3qN+Hgp5fRsRa2T?=
 =?us-ascii?Q?N7oaF4lXzj/PKk6q/4EWhdQcyeNf+JaOQMrMtAOMwJhAL5kykFy1aufoR0Yk?=
 =?us-ascii?Q?J/bHspbUKZ9Yq0APbTvcfV+wgG600vS77Vzu7UM6ukavnSS8aGyM2lMiIJAA?=
 =?us-ascii?Q?q0Dr1a4A4YjeB/eu0bNuKKRw2nurFL1nRsoBbytAWZCcY4d+KcRO2BFHjrSg?=
 =?us-ascii?Q?p0PIZSIU0ECqegRC5DolufbUoEa3goPunI3pZmrqbg19vVq3ZPhe7STDUHSV?=
 =?us-ascii?Q?3CEjnk3PYsN2ARsybkWo/WqnaSWjL0PdCJt22s/YVboJSD/CdNbloUBL84e3?=
 =?us-ascii?Q?mwM5DFETeZyNyZ6REakL8vLA+RBuujHtX0Lufp0K2E6aEEgsePGThEa88bKb?=
 =?us-ascii?Q?+Sga5BItVSylBav7y2dkmwGj94/zH6/+OknF59zo9InkQpX4MjH/2dFJ5EdP?=
 =?us-ascii?Q?WnnL6KzDWVKD/gpikKcdIss6rnuUe+bHhZ7bLz2wIdEd5z1ntLqZRHjgqGYA?=
 =?us-ascii?Q?BKgjles5SZt1z8Jp+NT7bOmWH/o0mu7gTcFcfOsJ4dIW6AxhttN7tEUSD/q/?=
 =?us-ascii?Q?yMbifKRkIiLPpWMDgMnDmszzlDVYFYi5uhfmY7ssmJBINhPZZ9o0UwyxDDie?=
 =?us-ascii?Q?dpdAQ/mmiJkm/XGXlrNlGpiZYgmDEKrr9+1VjBNkoe+iLxOgvyYwyNEdoX1Z?=
 =?us-ascii?Q?/ikmcE1hnhMRJieQYp4EzORd3B6EYT/PH3u/HVMLsszgRx0ILjrFga9Kvi3W?=
 =?us-ascii?Q?1Od+OlP/nCAGgdbc8doEf5QEhftJrOKXT5b/AUNlEh/U5FUgCgjBaIP/4GVQ?=
 =?us-ascii?Q?c2/zHs+kBTq/IrF8A3n+seykm9DwiV+7RTAhM03U93P2x/Ru9kUH3caV+J7e?=
 =?us-ascii?Q?zPEftAfXQ/LvimyIOtAtj0XVvf7JGvoFL64X/UzeF7sMDKhvdQVUkD/knxE1?=
 =?us-ascii?Q?79l55wF07kjqIuo1F5Wkpo73IK9IBB1eAxIEAb9bQpvoLBaWW3064EavbLR3?=
 =?us-ascii?Q?6yWP3QsMm3QfBRmlPbojUZF2vN1Kqvh3fkFQTKt43ueYb4txvYdFQFSXYHzT?=
 =?us-ascii?Q?a5jyQ43+RyyIznAYw3aH2U9QpBArNykbBE6pd4BVn56HNVX7JGQtTw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(61400799027)(30052699003)(13003099007);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 08:25:22.6766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a61c06a-d959-41f0-628b-08ddc4424f02
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB4751
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDIwMCBTYWx0ZWRfX7Dk7SRoJlX6s 4n7g8cUpc4+MRS2A8GM9g5xwdIe3KshpJhZx8Uh7LYoZ5h5GuFo8ftqUQHPGCXgJb8RArWx5oN4 WA6w3BSZt8J8EXPCbBmMRzMMV3T3WHiSckHCX1N3/G98LcIfD6M4bzqs6KVbODeQxPMXXlsmUKP
 w0IJCLEXO7QZOHB+MWQnlGRZ6muPTO489dZm3nRp8imsAcaGN7gMQjaKWtuhJY5PDZpjuIJAuTg RtgrPvPgr7GzcR5BlrD29WofGgsQoFZGgrAam6c9XWbQWJ2L2uAJvyARLPHgx/mj76KPj6yoQYt Lv4AwBvmmIgv2PNGMm8iZlVYGZuICNuaO3Ukie2XHP8on1q+D6yE1hsFN95cx0xXL+hSUlFpwmR qZ7E25pR
X-Proofpoint-ORIG-GUID: uAg2rraBjjAR_MgJQWlF_1PCNCBBhtMb
X-Authority-Analysis: v=2.4 cv=F6tXdrhN c=1 sm=1 tr=0 ts=687761f7 cx=c_pps a=Ze6KCB9QP8ZtDdwQ7yE/RQ==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=w1d2syhTAAAA:8 a=HdNhKYMYHjAd70UOPdkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: uAg2rraBjjAR_MgJQWlF_1PCNCBBhtMb
X-Proofpoint-Spam-Reason: safe

On Tue, Jul 15, 2025 at 08:34:21PM -0700, Nathan Chancellor wrote:
> After a recent change in clang to strengthen uninitialized warnings [1],
> it points out that name is used uninitialized in sdca_irq_populate():
> 
>   sound/soc/sdca/sdca_interrupts.c:388:6: error: variable 'name' is uninitialized when used here [-Werror,-Wuninitialized]
>     388 |                                         name, ret);
>         |                                         ^~~~
> 
> Remove name and use the name member in the interrupt variable, as that
> is the proper string to print.
> 
> Fixes: b126394d9ec6 ("ASoC: SDCA: Generic interrupt support")
> Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

A fix is already pending for this one:

https://lore.kernel.org/linux-sound/20250715151723.2964336-3-ckeepax@opensource.cirrus.com/T/#u

Although they are identical so don't mind which gets merged :-)

Thanks,
Charles
