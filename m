Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2B258CE8
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 13:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749474895; cv=fail; b=I0ufxYyen7niJOTHRS3hT/1J2eQ4GjVny+prAgUx68r11352sVXbl51yRSXjrCBcVBBk4d5+J1VcKMvqIm6YIdUVB+ky5csFPRp1wiyDx9vj1dB8ni3C6MZ+JaB04DrZNbd3nhoC0DLkG7hlMGzKMORlhC7myG6vZubW8+yfHLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749474895; c=relaxed/simple;
	bh=m2v+elJ1RIov93YDxmC2NwjquM46sdNLF2UoPFl/+L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eVPZJd1nH61WvkcwpIWhKKno94zv0vi92Ir757SP3vbTMlzKpLtF95vlLRLGJwhu/N20H7hcKcDjRLBAPjbJZQcWpp0/irA6rk3AxAYCZQxUMnpD1tCTOgnt+ZvGPg/audhh+R3cUHRfhdyg5cny4mkbMhIKdJC/7TT0GxWJXU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XPqqA4as; arc=fail smtp.client-ip=40.107.220.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XPqqA4as"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTec4kcsW+l40/rEwUp818a6Ec08pfm6YLgalwa/Y8nRdlEfzwus51eP234jq03MJkfYOQbpT42GqhBn00xASCEp7z72gC5wQ0SGRKFM+0uiv7kvEvjn8xMTMvBxPRMym82i9Zc1dQYKducj9IYYGGar7sTqXwgffporo0kcK+tQdIrLUFDbOxYe7BfTihtzd8MZBx3FStoxn6KIeCnGHsiDSj4dnKRvo8X8vD7FppTt/t7Hr4AWkZZjGDqQZ+cxFNm+nXMUFIM06P/25Q6bhLc2pjSs48FHIqlR2aNVFmVinOJ34HILoQ/uZVNA30AkIuB7GzAGF7zefzI3Ec0A9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pm721eENmcm0am3nr2sYXWY6BT+3v3d3ngxn+CQeKxc=;
 b=KfwlbQkuOIzw/1cNyL7kOebpygIRa4TOB7pCKaMBxcKjcGWb+f+5NtguT7OVOTbE4wNGCzqoI5iwP7Fr0hJgGU5vOXMwkEd9nUUFDI2ErbwBlbHceYiLGwaAY9g3V6rzdFiAw3Dh+dwH844i98pfxSkfgjrPD0XgGAK/NVxHXHBtF2icfNxZqVC+PzqoUmLzJXao3iT2SrssXPh/39/OkkLUwJtWtZX/6EIEE4PGWCWDM0XBipcFtgQ0ycOT4m3AHt3r0qQI0Xvj5OfBJtvhkT3+asBNFAWNH2nj6LEFU92GVNrz6A8Hk8I5ZrhLhehEAooVuTxZYUHMBcNBjXbR4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm721eENmcm0am3nr2sYXWY6BT+3v3d3ngxn+CQeKxc=;
 b=XPqqA4asroCPk1gRgGqM14pXLXcyW/xtEH/B1C1SNZWmv90H/MKxNtOZm9BkjcyvWxr4vUHMvDrT6/cX+5hsM4MVi6DyBYfYefHFThoCoxtGs/Wdq2YeN/UDwSobPkMx2JAD571kBVoXCoeadiC7Sv6tjYRLpXU7W5WEiLxdtmVOw9MTVetHRC6Vn0LjxAnQ7j8p23wIiOHfYOxElhn2TRNVygNEDE39TbQHG2u6jJipzYvBhacXaX7K3E7kzzzZQW7X2mRi7VmhqZTabxFhw/6PvXFNbcvSH8hs4IFg8xWK7ROxzEYtSLu0mqEM7a7sbl1nlIpmMWrufI91aYX2vA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB9226.namprd12.prod.outlook.com (2603:10b6:806:396::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.39; Mon, 9 Jun
 2025 13:14:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 13:14:51 +0000
Date: Mon, 9 Jun 2025 10:14:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vineet Gupta <vgupta@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, linux-snps-arc@lists.infradead.org,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH] ARC: atomics: Implement arch_atomic64_cmpxchg using
 _relaxed
Message-ID: <20250609131449.GA379312@nvidia.com>
References: <0-v1-2a485c0aa33a+505-arc_atomic_jgg@nvidia.com>
 <499792a6-f907-47aa-ae30-4b9d6fcee669@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499792a6-f907-47aa-ae30-4b9d6fcee669@kernel.org>
X-ClientProxiedBy: YT4PR01CA0409.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB9226:EE_
X-MS-Office365-Filtering-Correlation-Id: 1318cbfb-24bc-4632-fa6b-08dda7579dc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mzp4fr7SBFPRtcRS60+KN0iaM7J85KEQHj4icqc+v1uWfU4MOXM8Ud0Ks5JB?=
 =?us-ascii?Q?9moU0uGgtsT4TlRDjV1EUw04UOq1y4GNiwFgYTYT4ONSrmfbsVAWb5oT2cUO?=
 =?us-ascii?Q?6mkXtmoVa9Z9VSsNjsmE5zkqIcdsVqY2vR5xf2urHFLTJWHM5mw61TS0b4d2?=
 =?us-ascii?Q?d9zdv4XkNgf84woyZuTJBDj5bMcJYDHQOUby0KNBHv3R2J01AzYght7KS6US?=
 =?us-ascii?Q?txxhEdU0VOWeeTrr1QVb5UjqPqlXbCS0fedLkr6vryOt0Vil+LTvxkh+Eu+X?=
 =?us-ascii?Q?4AIluU93HyVwdIKxZ+2UQfskSYUjAuM3Mt+94yDOzUuB7xmS3yyIsIXIniQB?=
 =?us-ascii?Q?k10ThUQUHksCRSKTUwJw7izidM47I1cvTwlI7kQ6wl2m5Dnf4bKi8V2B0+9O?=
 =?us-ascii?Q?xGl3Xo/CyVIBqDIELYrLLZYRpSu/px/9kAycdPaasPs0neznTQWxa/3uARgf?=
 =?us-ascii?Q?KKqt+N8QkgnG9Td0ipRruvGNaVEaz0UaTcM+7OGvOXBa33YwPciXghA9TqOr?=
 =?us-ascii?Q?WhAAq93K6CJMRUnK13PPG0QyKVab+S5l6+Bi4SawA6o94NkUae9srevbdtH3?=
 =?us-ascii?Q?Dq7iyC49DlAi858MTaH9jtxqU7g6F8JDvB9DkWo+qAr9I3hDd5xms/PNXERA?=
 =?us-ascii?Q?aVPeviHfCnB/j1eOUVE07rIE0tgHc4H16PbDCb11uVpxg5dYRdvW9HqQRfhf?=
 =?us-ascii?Q?YESYfcy+HMaBF8qaScnqrgIJWfUaxhoLdQJ9oWj8GtL82ds8yyjgV+CWpolx?=
 =?us-ascii?Q?mZ5878LyZsxCTXcraCLGRvuOitUTg6BtRIhZcAdKM7yZQFk3T+IRofqthJe5?=
 =?us-ascii?Q?MvFWQDvOs4FeWOmyDdcnZsKqBhXbk5Jq0tNZkdi9IZOkQ7LqLmParaGHMF7n?=
 =?us-ascii?Q?iShVbpvNVH2cH+AqkuLpoCigdRgTDD229BYBbrpSIFOuGBqsNoSKGTs1diK+?=
 =?us-ascii?Q?D/rR5LW1j8HTowh3H5Ku9k7Z2ApqGjomQjnvDRT3bqAy61DcQPL4QpevnSel?=
 =?us-ascii?Q?huA5ynsLpXlaK002PmZuI5mzMZBYDyDTEIThouaSagNc8ohyQnyZsu4IT24s?=
 =?us-ascii?Q?ghDibCpXcAQtpNmLICcTWmMdiP7mz3XxZtljiMarMq+RN/YPWMYSBlf4/vIq?=
 =?us-ascii?Q?n1Prmb4wHtPA8c6rFxWvr+KnFCx1NiLJkJChOKW4rQCdoxpmIhwEMYux2hr7?=
 =?us-ascii?Q?RUJWsaau08D9etuRXIGGdO/jU8GF8oEhjVNOkAALF40p9vcZWY2QC2A9MCTr?=
 =?us-ascii?Q?4PdpBWm0crZovdbZlzE/LbZfSOr4LvDP98MmXPuMN0ZL3Y0sZU3K3hI8b4Pz?=
 =?us-ascii?Q?kn5etGkwT8azBdhaqbkJij2F36eE6af0n+dp3m4PTNE9Rxbnhu/MM2J2icTO?=
 =?us-ascii?Q?Hbm9Y+Dd3Kon5zwmyMg3Ws/AI4xLXETm2JIcoAJsjgtVfxKsya9bJm3OavZU?=
 =?us-ascii?Q?J13n9uVGmkQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YSrrEIYwtbnN9kje0IwKogv1Tp6NzRSvUfBmKPRzMtyw2Rp9sTaQMcTosnBV?=
 =?us-ascii?Q?lrTnG8+CiIOa2zYYbgrUjnCTnhWyO8OVOvOf+kxHOWGk9L/3CAhjeINQqLgN?=
 =?us-ascii?Q?Rb+pMBOG+Nuk99lr/zSxfnAbof62aW2950xGuBgv2okIj0KViEupxLrFogaS?=
 =?us-ascii?Q?0Gxu6lnXp8ivlL+spgXCZCTcRdi+kZn7X5u/dZPBnX7QAzBUq2YMElXZ2XtU?=
 =?us-ascii?Q?HvamcRt21S3xGm6zwk8Yn4CM0EKfrgCt8i3w3+MgPeusfTPwKxqc6qvTEgF0?=
 =?us-ascii?Q?LTGFO+CecGIMpzHLir/y+AG4yqXKpSo0kRJBiWsvh7B+3ynIJflKa+UPrNU7?=
 =?us-ascii?Q?cSVWRPVFWbap/cGLcOBC3N0okVrWKyP1Cw/VldR4Z605XasfEDhTo6ChlluL?=
 =?us-ascii?Q?bkwSAKmm18O/GhBqMGvvruQSQCaZzXTr9ztx64gn+ZA02ZKUkAXUAxrxYN1h?=
 =?us-ascii?Q?iynkitlI3PEqhrfvYr9HNB+3cKb5kGdi25XLOOZJMQmuvugqAS2T2meTV6RZ?=
 =?us-ascii?Q?7g0r9uwR0vkAFVM9wngdpArmGiFuTS68OxKjEdSgxYGfQKaDuaacJ0FkwK4B?=
 =?us-ascii?Q?2lm6bNhxnfd4jzzGHN+BTyc6jdNI9wETIis0nvufvu7EtTSvdDptzDntOrrZ?=
 =?us-ascii?Q?GRPm8K+GyvlTZ3T76/48VFp/Mc8ToG472PpoV5EDQtRAAh3e2XT/QvB0OiFD?=
 =?us-ascii?Q?iRmrJ7HAtChYePqPMLZXRSZjmEGNsKhxZ+rcqMZ3G9Fd9LVkWCvLQwjbBQ/l?=
 =?us-ascii?Q?hPqjAkHK3hPaOccmDxvm62zjeToJCFwDh7FT1U8slJmLfAdqcZcBcXOmRqSd?=
 =?us-ascii?Q?vlms8DSj/Y6dGgMYct2XqdcyU+xI1A403OFSo53GAzR/C1HCZ0n6E/zQh64H?=
 =?us-ascii?Q?kSrVQeuxFhzuONt//SVZam1B8A2yk01AUHZkscuO/ys7nyqq2oiWfxkllwKT?=
 =?us-ascii?Q?fbkz3F5L0nntEVeHDHWJ7HvdmJgn0op0MdNzy5mWcbly+EFQcksnl81cxuo3?=
 =?us-ascii?Q?a99MAO6/TQfmdhks1M5pzU9YGr83/0L+RhavRLwTOhKM42iPmkyu7AhMEGSy?=
 =?us-ascii?Q?hJu2Va6kSusvc+7qfVdDsPI1f0NfgYkM9pqDz5zHQrk3W8hkjUafRHWDLe9K?=
 =?us-ascii?Q?PCsA5vkiwKc9E2Tk64iokd7SC3VYtbNMYEP1CmihZmKokb7tbzkx42doOFwx?=
 =?us-ascii?Q?kgrm8xddNMs4MZUmHZjNp9RbbTOthb2aOFsXlizQZPEZyWW39Q6/u/rWz7tJ?=
 =?us-ascii?Q?k1SaOq90KyZd38FKoHSZeuTROySPZRrlvpi0CmRYg3pn/XC2tqQnyBoTLfvB?=
 =?us-ascii?Q?9xU7om9iIzsQbUliHypKC6+XO0sbrLGIJgjTFxhkIJh8nIxXajyXq6hKkZzH?=
 =?us-ascii?Q?qgsmdKyjLRZyuRr+D58LBsMj7hjONswqUQIe9sTtiRTyr2BcfMJqfP5btZVw?=
 =?us-ascii?Q?MA8pOQBz+IuVW5vfamReaVZVqCJC5yvflVGLmwGiB4o2vMvOBKgGyhhki0n0?=
 =?us-ascii?Q?cNpnxaqpg/uBiF3x/EJ+3U2YNg8w+gDN8Koa2Op/TmyFhgyAHjK6afqvX+K5?=
 =?us-ascii?Q?FwXFTaRMxm01aIBgE3k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1318cbfb-24bc-4632-fa6b-08dda7579dc3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 13:14:50.9793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N36o5lujB7tOE5iRy+MHvOFvfxkyCS9ymi6WUipJ+Q2SK8GpgAklZ45n1CIBadCD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9226

On Sun, Apr 27, 2025 at 07:34:55PM -0700, Vineet Gupta wrote:
> Thx for this.
> 
> FWIW I missed the cmpxchg API when the rest of atomics were relaxed in commit
> 301014cf6d728 ("ARC: atomic_cmpxchg/atomic_xchg: implement relaxed variants")
> 
> Added to ARC for-curr (for next)

I'm looking at v6.16-rc1 and I don't see this patch???

It is in linux-next though:

commit ef7647b215c919a82ee3235b80998c9bb3a915a3
Author: Jason Gunthorpe <jgg@ziepe.ca>
Date:   Tue Apr 8 14:22:56 2025 -0300

    ARC: atomics: Implement arch_atomic64_cmpxchg using _relaxed

Jason
