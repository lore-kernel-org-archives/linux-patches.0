Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011068.outbound.protection.outlook.com [52.101.62.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A284C3033E7;
	Mon, 17 Aug 2026 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975395; cv=fail; b=HJyLOur14mtokxcmoOM7ruWSO69ivFZmWFejBowsV6qgr2zORG6DCujym57z6Q0FPWHRxteIwdbEeQMGIGzNmDljgjOLoAn0ivk24taBW+sdQhSsg8LX40AVbp0z89m8/bzlCqJZTYhrUfebhlJYJ2zDssziZn0B+w2bjqZKDPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975395; c=relaxed/simple;
	bh=ZFdc1OB34MG6pnW1IMJ+rIQS17sVEoeMZ/FyIXL3mJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eJ98wQENq+zQrZxmGM2SGhIafyqUfpKtXOZKgV1duDihZN5zBBC9i1YxZ1Pgtj9hn1f+2IbOCauE09lmdYo4xxbMV2jvhKiyeSSlLuwR3oLZLnw5k5p/pbBgABh6THdCwmoybj8wGxp6lEMUOFpe4bRl4HjyBPdBZLwHrkGxMGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j4paV+iA; arc=fail smtp.client-ip=52.101.62.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j4paV+iA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KttuaFq4pl4qaNAKmuhBFhTw4gKqD8cJjUdwJ0qvxmqV+ZYsDec09Eul9Bt1qWct6MZ21SboG06NWjzny6WKT+bYrVTIfG6mh0p3/W6GTP8SCOM2IO4cx9is/lmT/s+1xQNwojMA70kiJPTMSCh/rybEM5iJ5qnmq8d8u9w8EpyUyMlhCkzr45nfcaQuIHh7K8vdo8b6iRecFZ1X20tN4E4L03G9+mP3iiX85HvBJLYZ/VymiksHlefx3Na7r7tVB+G39hjNJmArErVZuORgFqfHeKxRUfonnpEgt+n+x9jCwD7050OX3lSRTLgu5RLRfU2HCEWLT24jxREs2ZnOmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fh08tcPvc/AkDyFLA9s8b/5N/vK/2UobEpaHkfyKW+M=;
 b=jHR1vghBi5DhYeOfyfY2ag3eph3DZTDdmFJeZ2R9gup97mV6IIrzcgiDBF7+caKFPZ79UZiMEEY+xjKOEdg6VL1Spgf9no6vy1SGO744YgKkYyqeQaAcbcLHpoHlk5ZRFen9UJ2BBlE2q9o/b7CsVSyC8B3WeX1R59gDqIH86/t6hZOQ7OkRq7ORMnY+EA/vbT1KokDW7uNovMnBNTSK+ynCdAAkJq4/YR6ai7PZwkHHOjDj25RpE88/WHUm4fE9/yz4/Ye7s7qsdUSnrtLnyhS8dixo3Yqxq8z4Lk25HVV2gU/iwp0deSLV7/62IbqTH0PcdZYMKifDdr0ZqkVnaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fh08tcPvc/AkDyFLA9s8b/5N/vK/2UobEpaHkfyKW+M=;
 b=j4paV+iAL8utNp+4zw+fKRZ71/xP2+Fvo1v9aQbQ4hawUdOUvfpUjLvzpqM6z8T46J3XQ7t3O38uCXzBQtJouovj+7CP8cZKcIAB9YsHGCebLuQor9038VpiDNXwcKILOVaqzOv4cK5IfC0kLgU9zmqwBryEek9cbC1hXzk8T02aCthc5gGrhrSIMZQviDQVCRxdvmhv8T//3J7OX4bFktx9PbrW0u/qz5zc2wE28lY45qU8xEHGrm0Ow75s8w7OtYc6AqvZB7D9vqLkroO76MyjM85FSFYFju0FGuTKfUwNOJfyV5sk26Ug06prXaOXbdtbdeVulhxsSlM7nC6HMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 14:03:05 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 14:03:05 +0000
Date: Mon, 17 Aug 2026 11:03:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260817140303.GA1414166@nvidia.com>
References: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
 <3-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0093.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: a7a5f8ae-3a44-460f-7cc4-08defc684206
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|56012099006|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	X5OAu6yIJ2W59DzwSunswNbN7uXtWgVDIIp5s5EZZlFEvnAj4mRGwMvOkdgLCo9PbO6nyoOKih8z+dx1sJHxpvpdU8URoUijERDi913R/rvRVFzjgBQysn9B0IEzEJDUo5O3sPMe5vcIrmydu355qljS2pMORFTZKYLXGVYZ5SEbf1rGq0pX/pBPz22u9/95A4EgO+ta5ZrMlqdfo6KYsHPvgwSNAquDgn+FnrPYu+r/u8BqsAt5tIuTAUsPMP76bNg5zKiZ6ItiKYvXe1yZ+h3bfc5anUWyXuJvlwg2lw4SlUkj4ukJwvReHzs1WCPNF0vZcz6p+Wlzo8UMx5mtrKWlk3EPjHjBRUCGWkBh+ijB91kgaTQOWX/+7PahXdJIvJ/e4rhDSi3+I5TKRIpwwdRAJBIebpGY8cwKO10x0B1MNAm0fil9ofx4Qt+UBxpSNi31N1JLhSz9+07R3C5Q5kOWVG6Y0Hs0g1k88HIxHjB4bsgfbw0lktAh3sFhLAp2rfdN2XRcLuUyiT85NJGK/wXc3jIEF1jCcELXJXgGcy1NRBgz5FwrjQuZX9dzeL5veDycCrWU2H/5EH9BGl6dgO/YtbsTxx6pkWidYRL7zEUyt8roI9oxLDmqBRR3sz8NOvKAvMAXhQeVV3uJRB3vMHBs8tRrGTAdvkWmnfDBdlo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eMfIctN1x2Nh59NwCrokYNlOCp1NhskSDeJP2mWrRMXzEJ+B8/hcduWSOKlK?=
 =?us-ascii?Q?lJn3XTP1B/LPxWceZAohbTKk+vgvvcTbT6JPZUCq+gha5S6XFyMKXxqSUSqy?=
 =?us-ascii?Q?p1YGna/7sGTRSr24KqPvjGI6JKwoGjbD6PeHmyLbW/I27iGlL955Dp+mKiRr?=
 =?us-ascii?Q?0nQ+s8gHdXDkWUFTCyrUzu0TypROBQ/YfPeLMmHp+ccMbrQ0w4Gcmc7v3oNq?=
 =?us-ascii?Q?s/m1fOCNPvsIVkSnbMv4Em1gT0JPyjXPz1zWDBamZ1r+JrFgIICDcdlNVvkA?=
 =?us-ascii?Q?6/KzeO/mTe6Z5l2mbrOJM4MgiolaYVEUNjgR2psUZzrW8YAYvfp5SUP6ze8J?=
 =?us-ascii?Q?8XGZtfTG6n6TbLKe+kwvtkOnL0Z9Drb0ZFbIcYuY/Y/F/+VWmu7rfxGkAvfX?=
 =?us-ascii?Q?f9TdX1UBCE8SOFUMQFz5hVCYu9YGBC5YyTzB7ZZ+kmbrfpUAh4uaQBD/CH5r?=
 =?us-ascii?Q?WKH4OcwLPVEYjhxE7glo8PIBnKRSdaBtlI4D21IM3q5rEShrFUPuFZYrbgbS?=
 =?us-ascii?Q?Vq1d0dh/Sbnlt43bNPc1MCN8gXYPSvGfUERiLieL1qP1V/JarM6V4bPZ0ewG?=
 =?us-ascii?Q?hgaW9lhnHA6mDj+O+ov43eBVy6diWK5dxXzCu09rypbf3lP7rniiGJgpSPeq?=
 =?us-ascii?Q?VMJaet9yBUKHF5EkD7EVSMRz4/bwhe9RqHRAALafjXyDp9pAS8LzPZY5lN7a?=
 =?us-ascii?Q?VNhdxIIRWvrY0aHKrRS1eeQ9p+I9XkkLivHos6360WET5ArhQjjJ10DPzG2Y?=
 =?us-ascii?Q?9KoWI37PL7g7HlnYstyYsHUpEFOj7Yg389Ad1T+nyG/2MUs0RhjAO67OFAy6?=
 =?us-ascii?Q?yJ/iZzkFNEIwvx09F3zspf7YBQ/v+sEaWFVGJySgIKm+d29yhoUYne7nPeje?=
 =?us-ascii?Q?nT4cspKqIjGhVtAAPLQA7/fJx/zwkQ6lM5E/hEzx6pxv7508HJFWY7VNF8lL?=
 =?us-ascii?Q?pxvTQOiGwy1ALDRsyxeHfJmhlxjdzWY8W+DNZ2SI01qa6d4D4qf/qIE4nQo7?=
 =?us-ascii?Q?pPqvZZfXztVcT6oQirwwDrxuvbg4eXxh+NPNLkgDawletAY1D/2j2PRzNg1F?=
 =?us-ascii?Q?RwVSFdrS6TVZmKC0PSG+EVTbGTM/vNo0Ayq9938AZpEd9/s9wo4PeFWY8Euf?=
 =?us-ascii?Q?zYBFN7cxNRiJFco2kGYsTkz7IkidKwcH65XRNArofWz4N8wcEbXZeL+Mf7gg?=
 =?us-ascii?Q?ef4F1joQEaPrSPwpgueTvCpN7hD01+H8D92J50PuKEee50HeJqdV2dZYFTo5?=
 =?us-ascii?Q?2X6RRCiuKKsWb+txI66vLmc+jWFO7GbqLNLgeF2lGrRWz9VYhcrA1EMld5jL?=
 =?us-ascii?Q?muo7D9CDeVS8jCLtcbdQFhw39YWfcajimxyGS/8oTNIfedahmapKnbhB2wPu?=
 =?us-ascii?Q?1BLBAxuWfUiNWmGzwoZ0d2RlBFfP7x3a6eC0YEjVbpB8PmUZKe5slcjjCIg7?=
 =?us-ascii?Q?UoU36XMNP1v+MvYMvgSo0CeW7n++bDAFRnrxkUvKNFDMpS6LfYt3DElEOOC+?=
 =?us-ascii?Q?+yBEIoqtIj8VQ/Yjz1/HfnWrhbCvwC1rcHql0SzkGdrQpwl0qyybOVrj2sZZ?=
 =?us-ascii?Q?Ow3sZ4o+yYy2BI0h9Z+TEfNCXcGj3YEyFIgPgrcfXGOf39erMTAv7h8cVhsQ?=
 =?us-ascii?Q?4C2wrtYxmRNSXIYnRfBgfLze8mYm6386Eo7D32p5dAQKb0qG+XOFwbbhXoDO?=
 =?us-ascii?Q?lTuVvbiuY+woRSeomhK6C4vdTOc+NLkNqBiG2wdYDaUxbfZ7rOocXyPoOo65?=
 =?us-ascii?Q?0OJ+lGHCzw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a5f8ae-3a44-460f-7cc4-08defc684206
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 14:03:04.9929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7wfOnW5GJqrCKsV9qJPjIHFs5k9/hL6bxRTwTdyVF3WYWYr4K1JnHaHv6Qc6w0Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629

On Wed, Aug 05, 2026 at 04:15:21PM -0300, Jason Gunthorpe wrote:
> @@ -2633,11 +2681,17 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
>  		case INV_TYPE_S2_VMID:
>  			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
>  						     0, cur->id);
> -			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
> +			used_s12_vmall = arm_smmu_inv_to_cmdq_batch(cur, &cmds,
> +								    &cmd, tlbi);
>  			break;
>  		case INV_TYPE_S2_VMID_S1_CLEAR:
> -			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
> -			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
> +			/*
> +			 * S2_VMID used CMDQ_OP_TLBI_S12_VMALL which already
> +			 * flushed S1 entries. These two types always come in
> +			 * pairs and arm_smmu_inv_cmp() ensures that they are
> +			 * consecutive in the list.
> +			 */
> +			if (used_s12_vmall)
>  				break;

AI noticed that this has a gap if the invalidation list contains more
than one instance, then we could leak the vmall property across the
two instances if concurrently the second instance was being trashed.

I fixed it by using a list pointer to keep track of the exact pairs
instead of a simple bool

Jason
