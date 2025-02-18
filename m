Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DB426E65E
	for <patches@lists.linux.dev>; Tue, 18 Feb 2025 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739898172; cv=fail; b=gPNb53C7EpUUFrpHjxXLcLs9UXNYxRIgGQzusLf03XxEKQfBEwTppORYOoVj/BgI69aHkZSG+9Hk3aRLp2tk3l9gAUPX6/hsrLdORTwvqzxtQuaXb9IKJPNaxJV/hApTFSvMgYmQnZlsSlmdFIVv92jcdO8NdY/jlMhX+cIlYeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739898172; c=relaxed/simple;
	bh=EQOCMUYxsH9sI3vHHKdGONN/MDRI2Ex3BdaKLMdkmuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=llARgowEuxN2ZYRlHfYkhHNTF0pR4UkiZjzsX3zkJRNUl4f8A45K3KnTPKTGcuXtlI1uR+qfu7abzU8fjB9dxofOjZ55mz1PrYNmq0KykSvnBkh3B0Ma66cqtX/9kyEi4gqZelykUwxWcbIummw8fZY/Mbck996IMHttmf21EL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qGq1CitW; arc=fail smtp.client-ip=40.107.223.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qGq1CitW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ex8XFQOuZlz6BQ5+HmUFcXB01FJ217SeSNyJQJe0CDceSjvg+my1+yMKizUKG6n71m+B8gziM5qnBxWfzQSGP0mi4aIFpda8fU8QOqFBGRadPvzohYffC/T8hST6D6+EZPPSFf2SQ46igIyiH4f4OoedkQViWMEHvQMKBsbfnWEnWTJqImGvW0SWdLtXLieAOvrPx4T93RAbVhYDdkXq6HMeXh5F5eFbn8hQ5D8k3E5Tm5rcHB6mfDn1dH+f3HgLFA9PaN8CUg3FcgMaFDuHUOw+PohTCDLxQDTIBMKoIr1PVJ8QvPonCEoIRguIkXC9/Fju5XaNRflSY3K5tr0/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40GWVhZbZOSSz6vlLWQhlGNjb30Ttyp1/Q9SFBLrscw=;
 b=ckX4mkazATXMzsXLqshRn/aE82ugXaT0yJkTS04Cvl1OxPz4+VGgbhbRceZeD9mtUULZNbqd7aE7ybj/n4wLVQDobAA268nvchzB98O6//vh1OAHC59MHJeDFPYRlL1yGspobE/CtFYuwQyGvldih+yh+LrMV5Jhsf8qBJL/f9JtAqjm6ChRFUqhkP414nMVp7GWPp1i5RlkwVdi/okLmLsAwDUHWE/ibLWv5qRcHnNsnt/A53XhfapOumMr7UtxepKiaWB8r2qhbqAcEke3hUy1i93gvErIY/4b0el/IUWDA6Pi1NUhEDLXbe7WzTy/n7qvjS0P8tjad49mll6LOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40GWVhZbZOSSz6vlLWQhlGNjb30Ttyp1/Q9SFBLrscw=;
 b=qGq1CitWUDHz6/0Ii9v2XEydMJqDy4A0zh+ZSeiQscrK8TunUCua+lAPa/jkQ0L3PyeUjoSOb59LRg2gAOF0IVsff0x9Q2/kFOsimgiUaG+Kc1sOZoxTx3uH/vmt71+crEvgmJk0rBVIoQKdcssbj5NUfvvAy//xcQyeEaG0HmAaCRtT9iFJPJH3fLxwNElMZR5bkUG7CkM9nlbnDU7Vp8MbOzyHxL0/LMXgeqNU9ftBr2q178hJab3h3iXM5Lp3v6ocNtNdM0R20raESutRdWM+B+HoREcMquAds7K1bbda+4fQLwS0jornbTikG3mRvAYsGHawyKHux1DlvKVqKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW5PR12MB5682.namprd12.prod.outlook.com (2603:10b6:303:19f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 17:02:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8445.019; Tue, 18 Feb 2025
 17:02:44 +0000
Date: Tue, 18 Feb 2025 13:02:41 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, corbet@lwn.net, will@kernel.org, joro@8bytes.org,
	suravee.suthikulpanit@amd.com, robin.murphy@arm.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com, shuah@kernel.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v6 11/14] Documentation: userspace-api: iommufd: Update
 FAULT and VEVENTQ
Message-ID: <20250218170241.GE4099685@nvidia.com>
References: <cover.1737754129.git.nicolinc@nvidia.com>
 <300d03449b9420d756c1589e1c24bb8b4d508293.1737754129.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <300d03449b9420d756c1589e1c24bb8b4d508293.1737754129.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BN9PR03CA0569.namprd03.prod.outlook.com
 (2603:10b6:408:138::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW5PR12MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: 3933f53b-64f3-494e-bc17-08dd503e0ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wqZzkQX7dRvQAuKnnpqE7/fG224sCxrfAd6w7oAVkmYwUvznZf15r5eqGXKu?=
 =?us-ascii?Q?u/fkrh6f/7kA98rekVXRqgUqDnHqwTxdoRFyCaKDzB9e3GfcgPAWoZEbo5+7?=
 =?us-ascii?Q?VS3SZt3UT7mqfcS+JcfQ5vvpghtpluiy4daMf9g+hxNhy7IgWKsTuEmXBN8E?=
 =?us-ascii?Q?41C/n9RkP6UNTo0p8kOJc1AbnjqhNfUd52MFVIt4tQzswEpmT861Ek5MZw7N?=
 =?us-ascii?Q?S/FK4+I3/r6h/X3LB81vOL2K7m0vAaP+Nwdy366i/QfB4qTE+GhZaCbgnjBS?=
 =?us-ascii?Q?vhGagdtaiv+ftNNUaVNjxmuzgx6F5+saQj+LZdNFnKy7IDobcrCjM5WVwSj8?=
 =?us-ascii?Q?X1rCGhofum+GKuhQJi1fHRDVws+B9Vrs7YSyksh7S4og23bBoqZf/DdXVEFP?=
 =?us-ascii?Q?HMW8aGmUdvHt2b58LI/DJSdOSBuCBxYIOkQ8qQ2QCfRqj2CXzTYjjTjwStoq?=
 =?us-ascii?Q?mYJFbLwgnvQWNxaDqceLkeuirB6qkmbU+/nL7YUQ31PLt5uSUDJvTf3cZ7bx?=
 =?us-ascii?Q?/rmE6jjfd2yiTa+Axz+USb5nHdbrzm5dbnsSSDoGexiMzbcz7qSH+GmThl6H?=
 =?us-ascii?Q?7+sZ/Y2M4I/ReGv7xC2z7GSNH0zERT1yJ3W6urithU+ErjNKaREOa8pA41Un?=
 =?us-ascii?Q?Bs6TbuPiQ7DbPZsNB/1Fxupln/Zl8RmNQnbdsl206oO+inJhWqWOmrzHMYE+?=
 =?us-ascii?Q?vm0s7DzN+4JWsVMPxXiBeqMWWE1hAuqk57xp+wiaGbtWkHEqKyUsOAJPqk5w?=
 =?us-ascii?Q?l1wxSy5adGtnEMC3XS1b+pqVj0vLcNqvIKaVqmoy1MvUFBgX56qfGpVQgOdS?=
 =?us-ascii?Q?Fp4OoC/0/+QfgFWUTdswQiJaIYFjZdFRYAIGmUx/C3TqJhOQKsMHT/RwqD2s?=
 =?us-ascii?Q?uxLWqGvVTzGnRjAhvZdf6H6ll2hN/p+jKrfT/dQK6x6F0HRarbDyBTterXQz?=
 =?us-ascii?Q?9aTK4M8/H+H1erSuqlMz5D06GQBuDFD9tagtcfYL48JFPK7ODGeKBGocf67u?=
 =?us-ascii?Q?SaJVAHT+dtNCLlE+W1hoSAfjouVZhCfWn2nk1d+IEA2Z6emNlm69lLU9Dvwb?=
 =?us-ascii?Q?qkrq/AsU2FMwJmrbhKBAGYw/f7122eXdXO2PXwdB7xP35YQ49WJ0gUjYWHTy?=
 =?us-ascii?Q?ghoCiMlXTg9BbZYW+IVqtIGeXxAUDtMM+LJaKY7U3cmHN0+Sr9vi0uXEOlPb?=
 =?us-ascii?Q?EcRKmUeJ+a4s1PswV1RXlBWXWN6bbSottQdHproKrXm2T6jLNgqW4LV1H69x?=
 =?us-ascii?Q?EMIv4Cqn+Dg72DWUmSxwZf83uLL/10nPq31hclrozjJVbxYFE8ZG7/twqtFR?=
 =?us-ascii?Q?KjCActy3H4TSI/xr4UDqgfREP4qCBO2OddWXFRADmjMzaa3FPq76Nf0yiakA?=
 =?us-ascii?Q?Ql0ZLH5vmdSigul3USuuhGXb4FWm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ptDNxeTgB4aeJ5DRr6E7ELaIWSOVdyc+LvG6PsvCR0fLBI35AgufjVOuVq06?=
 =?us-ascii?Q?FKb3v28Kp14yI/IYytNJZ82lss9BT/AlUV/xpnh/AXPcoJDr/HPc39Z6khWw?=
 =?us-ascii?Q?4mOdRuKdzcKqJH8e+esw4FVtRz1jhOhoJhUKbeJuO4MauDdt3YBGgQK/k3FZ?=
 =?us-ascii?Q?fNhxvDfkh+9+Cv56eJt64G7m8TfBlYUIUjv7KRxUNzb3vtbt7eivP2zoUQ4D?=
 =?us-ascii?Q?SEIw2aDfZy99pQwQ5tOgpTy4WQ/QjkjVIzjwt4eDzzCz7bk90XCcsgLzlIfn?=
 =?us-ascii?Q?lM4mteWG2moysYPMcf4ultwS+zh66FSsmg011MQJ75SXv2ko3fDP0w2lNyH1?=
 =?us-ascii?Q?/vwgnAdsqz0TtbDbUHRv6m0YwpLeCb8BGLmdihzcupcUbe6aTmGD9+QNGFNd?=
 =?us-ascii?Q?PeFCGBtESMBG0SiwO+HXscfEmp4UZ00PIytwfyzhDAIkA850piTjeIJ0Lmn8?=
 =?us-ascii?Q?dvOvyjNJyorFdXq0YMkdSXY/CdXAJdVsST8F9OfWRykl5/41CR6Ur5DjJQUZ?=
 =?us-ascii?Q?fjElASZBrzNM6RqJFM5MNTZeZcX6qQAie7hdL2lSGNv97/fTt4d76qTv55w+?=
 =?us-ascii?Q?x0s57i2d4/LvKYKUjQLcsvh1jfaU6IYsTmq60IvsShNruaNzZDUjD0tRY+SG?=
 =?us-ascii?Q?MlP1Z0yqNEXepcu7+FFFiVO9WbLuQFeX/mPwKRYHEKsRnShu/YxLeXEt05iG?=
 =?us-ascii?Q?5aN3QCSWYStLok+pnKBcnPJIiTvC2ZpUiz5rljX2A/h6eBKX3joeCamEGrnc?=
 =?us-ascii?Q?aXRLncovcx9G1b9zUqv4Yo18EzqEtKcqT4pEvYGbm6lrYiF71XSd3xB+F5eD?=
 =?us-ascii?Q?r4w+k04rVn14sT35h0VfmXCzxp4ET821Pir0/g8pjExmhf1u6b1dlhMuSQdl?=
 =?us-ascii?Q?CoOJUr9vXCOAy0BQid6PE8w5F9rWEbK3tL/9NRRtNE6BdiFY6Bm69i0V7Kti?=
 =?us-ascii?Q?qIpaua4Tgsu65ppQBJ/LfWrMDBFfsXPSQrOJIi5UTxUanQWPHcn+yqqRaGkU?=
 =?us-ascii?Q?8s6UXcMqrPaP8Er8NZxpcCX7o0wUnNgBHufuZIOqz5n0nBtxJWiebvIo3zG5?=
 =?us-ascii?Q?RovKmRWQV9YvwjJRWQfYDXmyv1E7ACVHFehD/RGp4RZkEZCPmt/71lP6ej/j?=
 =?us-ascii?Q?z06HRiGKSmcqNlsXd9hSnVtoqn2bkmNP/4ch2pFsLq+akRxlQ2KqzdR7tvAm?=
 =?us-ascii?Q?edXCuZdD+St0XK0s8gJCpnM+APy1LlkC3Dv/fUSD6F9wRDOpTYMPko7zM4De?=
 =?us-ascii?Q?VqFOij4vLSZPvnhtOF6g/+Sf54irExeIsaYfixu/SQN0ux+TtsukKfir0RJx?=
 =?us-ascii?Q?S1NkeZ+OSTSMCnjGgAgdITeYFOw1naJ2ls6KBFWzhnEZKo5ClYF//1G62L+d?=
 =?us-ascii?Q?aWOKfFI5iwXF/P140W9WVfgVAr5a8xptNsEtrV9e3t0OLpsiddphXsWAEUh0?=
 =?us-ascii?Q?oT6Zq/F2nfl1CJYp/orO2160XjU3EI8K7m4yxjEFIs7DJZQgfIoyG77GNChb?=
 =?us-ascii?Q?oAjudkwwit5XQftik5FXmPpCPkXGS26HzRFMBMSFN9YofUJOBvbOpRQ/NFTG?=
 =?us-ascii?Q?VsuSCodUyOaYRidDftylxwkjsoQByyal1rpF7hg4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3933f53b-64f3-494e-bc17-08dd503e0ecf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 17:02:42.5879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5cHrg2KWPynkJrk7OZFQoLP0b6R+qhMAfiDNvkuKjZkHEAAb06WPoP5saEO89RQe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5682

On Fri, Jan 24, 2025 at 04:30:40PM -0800, Nicolin Chen wrote:
> With the introduction of the new objects, update the doc to reflect that.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  Documentation/userspace-api/iommufd.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
