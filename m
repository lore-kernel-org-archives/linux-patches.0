Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013055.outbound.protection.outlook.com [40.93.201.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C1B4D2EC8;
	Wed,  8 Jul 2026 18:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536046; cv=fail; b=EH4fsdiPgwUyam55yUvz/z7tvILQhyZxQsHJrHd0O8V4d0zMOnZK0jrk+Sg9xiaZqMUFWO9EmGzwNG/WQgNaJd3mETH2gCg2fZt3KudZp3yLWfJCdEoHn+pWLSY/7lP+Fho5dkUV7hRCNvmrjglvyjbVV+9i1k/6ShuIJVzUHpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536046; c=relaxed/simple;
	bh=kJebcFaE7az9VodDX79LrGJqTuGIurDCYZ/Z8UfLZQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EJn5Flol7UP6XxNTpVHzaQOgpXXNKove/+lFy/e9U8Kj/peQ3oU5H1A9pvy29k2C0bGGAIT168ss8edzQNae0+OTeo1/cwLL5YeSkAErAoxA+q1mAy4izn0mcJ+om1jJ2Fae8h/632LR7b2ZeeYC0xm/yOwLginYeB9640eBvJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J8F9BeGg; arc=fail smtp.client-ip=40.93.201.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J8F9BeGg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lPznUCI1fqTaDnu7RQ4d1FKBa0fdgqEZJoGkwn1p0B/fbHCrhpcSI0Js+5toFyLOcjh/mREZ5eDotnwsbhUEOvlnyyNAlJTqvbNN9Hz/bx8FMsgbQuEx4vhrtFYhu7hNDyXfSeBmh6dpKGoU1JsDguFRVI4rEasfratctOQJg4blPLdd4CnwgMwplBqNGRwlJIxXFdpdBIcn299cznOihtGsAJ/LgzWRIdS35b0xLKGm2PepQ0p4X7bqkOOkxHsOv7D9l4YhfJIwUhDKaq1g/5jD2xucU1ChUgB8h99FVL+RQ2Dk4uCrn+gbp9QUftOPGs0mpE4eYzXbnCXLRutb/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHEBSUQbgmEUEuXtH+c068lXKciluvs5gzYFwWTXfKE=;
 b=RbrTo8e7sCEhckubjkWQwduH/CUUOYJDiqyDiAHVjRZhOCvCubp6lnJfXsLfZd3VIeJTzMdacIkx7iZjka17MLUOb6CjX42Iq/SZsfDRRUEZUbkluqdrJZ6SMHhgPKVlGdEJcvj/jOw++5kRrrfsPLv8+ctdX4/TPTr7QqAvHlGI9ckiewM4O+o4oC2ZErJgz4tUsvPVPESVQ/ssk6z4ygPCN9ZlsgReJuFHT4fPDThk1RD+65SDm7+tWRbMlsut4D6rnAjlHlmWzbDHQjD5LIykNb9DjasSKaECMCz4K9WZ43WOEhq4KA7XMV7SU3H4il0gey3+a1tJDHxoCCxQnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHEBSUQbgmEUEuXtH+c068lXKciluvs5gzYFwWTXfKE=;
 b=J8F9BeGgATIchKmmcqsZV1ZGnRR8Mb7Djcv5MSTlBr4/bCVjybK4cOyYLHgrsamezrYUyv86veUcf+7xxaB7pFuQr7sdueSrNFhNV5hcw5utH31O6sfxw2aSRn7Kxu4VrSl6cdC+qiCaMXD9+dZWBXY5l1Z/J4Y/SRNJpLoRgpD9DIGpgQOqG7psREtcm++IIsDMAfV0WCjna5ZY5E5UUYO2VekjtjrdxaVje06SnTTHgIOc5XfREI9c3Vjw33bAyEkCTeOHmPg4SsoKk+sf6OmQaW+jU6Xmfep2h0NXmaMIiaiqe654lxAdONinKFHCSVkHXY0NFSfey1Xhxqtg8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BL1PR12MB5993.namprd12.prod.outlook.com (2603:10b6:208:399::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 18:40:29 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 18:40:29 +0000
Date: Wed, 8 Jul 2026 15:40:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top
 of the call chain
Message-ID: <20260708184028.GD422027@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <6-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <ak100gBEybGVrMZ6@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak100gBEybGVrMZ6@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR22CA0010.namprd22.prod.outlook.com
 (2603:10b6:208:238::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BL1PR12MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: abe61cc2-9cf2-4aab-9cb9-08dedd206264
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZPFYCe9JiIFjSl5puS5URngnSzMlnryr+mbxqvfo6A4lmtDWv+t1cbk/4AaS3J6suKpB9rwHj0AHicOe82ob85UCGvwScOcJHYdsyi6jLYGYcpctMZhRJxxvB/bdUwJGGyhP/CJTy2VYQguxb7JtKtmSecwzr/I7qCOAikRW2PrMVlVAq6Rin1Xcx+xTvzqDYHnNf6iLckllRh4Crk1i/nIvWzgFhSXTtVylQNTInc1N6soSZ48hj5Em9AekvEmIgIvkg1Y9io3SfqliL/Gn4ILU1FZTVKSrIrhlAGkTNufLgb7B1UVWyvumVO+kQAliQUFhbY9KQEYSNan1+2YJg/xTHNyLSFm1rmsJ1Ep49KBDLgd7DzTs7aOlRoWSG/lrRcS5mrmNhvJM6xXwBKmSrL6m958bMIi41ZmX2U4fdebRKjk2byA3SYXMZhBsaOedhYvkB2Y161aVhsEZVJ2Bt0vowbKntTB7rNrXeHXgTqO8PaGHWfm4SqlvoggI+Txm5BH+v6o51mLpAXKM8KtkffoasiZu4djlqA61pIM6qa0PJGJsJrigaPDAkqWzT0fUONxrYpCKRFNSIL16E355Jao8IxsY5eJmgFzO5/qGQX7d0qDfTxFjjMlH8LoBhO33hiiyoye55Nb923ngjKo8z5XQb2hLDQPdKSFhsrRewuI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+PeVmioWtY7klPcnaYXrCgtofc2Kwk2oPWhssB0rDbNv1aq3f8+zxWtZPpUt?=
 =?us-ascii?Q?ZNRn02Qt+F7gql6ef0xoGDQ1VQsNO7HcnGUx0KMR0kf4L1CE9fh8UWtH3UlQ?=
 =?us-ascii?Q?HtrhZuRUMjBOsxVEdfD3Z/PC6uAlsSk1/kpL1QAKPVCKuqx6A4kHY8G1Gx8N?=
 =?us-ascii?Q?Nm+cAnap2bFavmTBA18an1kqkN6w99b6EkI1ya4r6yTi6YoJrK9PlvDK8Gjg?=
 =?us-ascii?Q?3uJhas8wbOjvDCdJUdEZu6VYxPr7wxJiPbkm2z3U1ua5sKgI0r+ZgWPNN8QQ?=
 =?us-ascii?Q?fttJjv889IcgWKwVlsft0nmI/WlF+AKE6/Vyx9BDOI7nIKDlMRDtsM0gSfKG?=
 =?us-ascii?Q?V2hqVqTT/FGu/gqeJIL8+ZsFRpoCSJGXtlhByR2jhCP6qDVtc/+ri7vAhC4p?=
 =?us-ascii?Q?hAk5qJ+q9ex6v9CqE8lvLe6tmWfXu7jCyw5vXj2vPOlEwFJbv4td5ptjIKhn?=
 =?us-ascii?Q?QLojynOXLtWVw+iM7H1JjwinAZC8bnMiaVpMZkE5pgCHYapU3bd9TfGNb1OE?=
 =?us-ascii?Q?maB+qZ89ouWHYsaNc0zE4HkUe8zl681ks9S4H9sm8pifTAkSWqQeZgbYKs1B?=
 =?us-ascii?Q?yt7bShaLtx3U7w82v1f4gp33tRd8eN9pssUd57/0y10FpWPXP8aVTc++gAA7?=
 =?us-ascii?Q?zqCUF2SPeLyaoRjdNQhxaCoiDBZYVOZeQ7RUo514hBbiijsAtfz4lJvx+eRC?=
 =?us-ascii?Q?58GAEupyGyUYpBTSToLjOemSsx3ZbSNejie/MpM1GAILnACtdYAHdGrOJpda?=
 =?us-ascii?Q?zJJMTFwkpHkX0/2EaLD1XY00dAIsGD5BspZHLzoiJtgohKwHWkBYudR9R+xR?=
 =?us-ascii?Q?eSOCcU1FXq1mKjnux9hF4GPSe9StnwapiLTFY4Kvh3vFjNeZk61OKijjV9B0?=
 =?us-ascii?Q?2mLi6Z/oxqVqLdHECccpwVOjUM1nUKRXhqIbyl6xZdQVb1KsiP/mEjF5bbhb?=
 =?us-ascii?Q?8k3y8BSHxpRPaeXSfrM8aDgg8pl7lRnnGCE2UWUc5O+UpbUV5yTTKzkLOCY1?=
 =?us-ascii?Q?EKIjP/oUrWymkinOvuKmrNh9N2jQM1TGV4BrYJoHDc3c7MBqFQMIxgPPFx0W?=
 =?us-ascii?Q?9zyhtT/6T/Qo1xlU3hd62bKGK27RKzVv5MqaPDEM3SKH8hbtFLkm5VLU4hRL?=
 =?us-ascii?Q?nYk4f6XRPH2MCelHbpmU2Bw0Xts4AS4edHw76VlECROqe+XyP0Y/MKat2HGH?=
 =?us-ascii?Q?beJpuG2ydSMuYPUL1cJhFgI/XKZueW/2WwIXozfspKQ7UrwBEpCUBhR4K1oi?=
 =?us-ascii?Q?YwD5ET+k1wjJWSgtXKIx2dgDi9bGGH1Q4J/mEoj81UV9I9K9yLSbZM31QozZ?=
 =?us-ascii?Q?il/dD6X01H15u6cKtXGykdeVu1Zp1Z1G3uZDOUgKiRMGSkXNI6C9XGmmIqOd?=
 =?us-ascii?Q?lDW35GkQT6NBYg4O06J8N3cTmwAlGJemWBeb1N7GbbGbrFYq3EjjOB1lGjom?=
 =?us-ascii?Q?JSxsEIFkP/ayUKmU3n0DYTtlx2faE4gMZW3EsnCMUe/D/opG6uNMhdltOd+I?=
 =?us-ascii?Q?raXQAsOCIGyrXL8f1UGzz0gLglwpdmg68395VSla/VZV0pfEov0x7O1L41fi?=
 =?us-ascii?Q?tpFP8fUPhLz2lCNcsUpwtez2gDV4tdm51cMWqTQlkDw5UNGIuXtETLGk5/Eh?=
 =?us-ascii?Q?6+G20ZpvLklVEnf290HI3xptZji2d3vqQO1NKl8pjdlwTzhvLkcemwY2MMR7?=
 =?us-ascii?Q?es1dqablgsOGYly7v0acJLI6pEn+9Lc+dwfxFe5Ar9KzUMcK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe61cc2-9cf2-4aab-9cb9-08dedd206264
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 18:40:29.5388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HkGjYp3KBssUDnWMyfeGM6Otyw2tv/iE90KYd6P0CBmrOo4P/stPQVjmHKl2RlI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5993

On Tue, Jul 07, 2026 at 02:51:14PM -0700, Nicolin Chen wrote:

> > +	if (!tlbi->single.use_full_inv)
> > +		arm_smmu_tlbi_calc_single(tlbi);
> 
> My comments might belong to an earlier patch:
> 
> Could arm_smmu_tlbi_calc_single() be moved closer to the _range()?
> 
> It only has a couple of small steps, so it shouldn't be too bad if
> running inside the rcu_read_lock?

It could but, it feels more appropriate to only put things in the lock
that need the lock..

Thanks,
Jason
