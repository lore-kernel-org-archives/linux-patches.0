Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010047.outbound.protection.outlook.com [52.101.46.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DF830676E;
	Tue,  7 Jul 2026 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783440916; cv=fail; b=XRiw88pa+VwnWke0nmpnuiGZw80ZeuD7DTNVU1zRE7wneBSmmDz24JagWSpCHWA8MiEy7jPFwXE1+zfOG5BRrBjMTp28nbiQ+uMCqviT7RpEuWy/iW1NSOuauKssd+hCickDEcipttrzTI9lFwsfD1SJeS+MN5EpIwoyUKkcoPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783440916; c=relaxed/simple;
	bh=Sja3ljzBTr+L3LmgB5BodS12cG+33iFNX/DB65KhfQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qfSTMBZ51YBXpWd+S2kWN8O+cPtllKce7NZnzrtOmGVgGk1C/pspdmlpx7wDjqDqJ8VNYtE++DzblTM762+cS+5xMQAwaPq7uJEzRFdV48nHk84g8rl5zYpITInaMMHi71IIZa1wB/c0rA8gfyOPYfZmGWeUje8gZ3C+pK8XhPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XJvinxnl; arc=fail smtp.client-ip=52.101.46.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XJvinxnl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rxW0eYxFbgB2y7I3vPbDXwgkSzGmGa49AdZCOdat8S9EavBC5dYrNxYsd5wEbVdCV8HhypAGhQIUmKzh7sx9p2POmWTxvvePvH9sU8Tr3SHMUoetrZqOZxx12f1/nPWL4Obw+0EBA+pw/8i4avGlzukD7OICEUD8A97sIS3EcegSx1Mp+PRhHhal92oJ4aC9Fm0y+ACDObH6knLuIN9qni4BG0+nBPxD1OQHa7M0aKL+2cqzpydgIQcfLDHCsGMzbLOpS+iRn+O9jvO+4QEMN44RGZmnLoKCgFbcEU7JbU8RLbX0jnHPqw9uubuhsZIwDkvK0BFa/0JvER80ANIqmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aejrk6GLwJd233ZVG2vUYpgbA5iUlMKLCMlwkoRLakY=;
 b=ZCcyHyOLvOSaV778F1sMqrzagADEsm8hPiRh/21ZmZQkA3RctON+KsnAR3rDLqz5PDtCIEDNR2RLbRimE1pDm7keP03Bmnel0hqIApGKwbNM9Dgk2kaqtAlLMmxEQAIIv0aHt4t+OxkCn5GzeuichZxNDs2U2FCds09Yh70yvV6JRgZUPZRNoTu0D/xYyjpFJgt/bpWEgKXwfIBraexRizNZk/hAO+Xj+NZqCDhRKtdw+AxqplAQJwR3ViJYokF9M2tzNpAJt1+tBmZMDwxSArca3IhmP+CHh6gSmtyw4CXg0EoBXkxIr+wSIUCw1aTJdeweFW98atFpa0h94YVKuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aejrk6GLwJd233ZVG2vUYpgbA5iUlMKLCMlwkoRLakY=;
 b=XJvinxnlwRHhkFts1sR3FeANKrX12O/TZ00+X1/rhZwOSoyKxadQnjCEud+XfSYE5f3LERYaogiUEU1eDTXOCh+zjLS79J9sZB7iyEvAh/bh9+TNHTgUl20PR+2bY+ZDXcZ1hNaXxxbcQqbieuvvEXnh8lKV/fLtCOdWD9/EItSQkdXolF/UeNfLYY6s7MQfAcShmrtlRFJZDg1u31ZrhifbYxDNQyBYb8hYc7K9QyFir6uIiAA3ZxF1B8FIEn9y8PxhC9BNtoM6BrTl5/O6lLkxIEURZopgfbQtIMMsyX/9kzrtcwoNczrQMdruf88Wn+3rmE/JeU4D3eVOhh+pkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB9238.namprd12.prod.outlook.com (2603:10b6:a03:55d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Tue, 7 Jul 2026
 16:15:07 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 16:15:07 +0000
Date: Tue, 7 Jul 2026 13:15:06 -0300
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
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <20260707161506.GA226829@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akx5IvI6bi/OPuPe@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akx5IvI6bi/OPuPe@nvidia.com>
X-ClientProxiedBy: MN0P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB9238:EE_
X-MS-Office365-Filtering-Correlation-Id: 28ba38c6-6021-43ef-6ecf-08dedc42e978
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	NurfrhNuLotH5Eo3AnbZ7CRJD4l3Toh4WMKi1OL22aC+p6nqqX+TJFDZaTyDMPAiIHzZBke8oLWvIKeVG11YctnBaPSKjLeE/JLtghU2IJ+GQivN5QoDNiRYjJcsPTZBNkOSsUlnL7gjgCb5UBLWG9HPma0reJTlMAGUiV2s18CvUPWPQXMWnwG00Wwwg7av8ucRXSIa7ivf0OcyHmIxX+kBzoYFXn5UVRjOv5zhkUjH/UF8R8QmZJ6sVa1VscgGCJYGczNq77QIoZJqvH2IBcmuVQWyhC1Fke2/6qblktZPY9SwDceSc6oi8HrnM4sEdlesIZtZCoupl2O3j2XZRxDfNZktKxeY0q/DgxeMy4Di3QKWYv0J8eyat3SemVkI6hicvTrGNIKBXOE/g3plyxRhVCVwgpiGd8rDJDvuPdrYVcV5hG1+IwbvpiCrXE5YAOZNJ+lqsdrsf81GzUvZ5FUuAb1+PhUGS3cAiOtUP5MSYD7OyhuTRHpWvCenbCjase/FGwGrchEdMIUPKzaI7jXPYNn9Kn10P6tgAz3S33f+RVkxTj9oqFxAe7ndqZNSApH1NrCGdA9ASaGXpq3Gu6IaIxr2GS2451d+AdE0F8R8XYRiWTrA2O5eNj2Kzxwf2SNousTrp4+5QPfb+6PUcygpkISBHDWp51sfTSRmgVk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6qlaVhOArWvTE6C7djeuxfnkRFnTNax9ALRkoeE3cxBFdWxZCsT3LuAwgZHw?=
 =?us-ascii?Q?vjd0dhZ+uDuXTPXMYxok5cKTjKzpmU53xyRk2PlvG63yQQL0v1qYJ0/hc6/V?=
 =?us-ascii?Q?EIyvf3rksuD/rnHvcp+jYkPhna49Frp9ZZbqfz1SBLbyenIem8dVuJXee/nZ?=
 =?us-ascii?Q?QG5fH8VLDcms+lIf4cEXpdpJDMrHKa8d/pw5HAkLLYw4bfB6DQhIYtQOHgjG?=
 =?us-ascii?Q?z6xLa2sd1nCIsjGzrQxQY5ntvX+Zf6ZrgSzgMaOHrZ7XojwKBIAtyYI2HCKQ?=
 =?us-ascii?Q?TP2uXeNUbXAzn8gZHPDuUwH3BQg8c9y+iApCWDewanMfggCahpjH6AMIxHpX?=
 =?us-ascii?Q?/rR+ldsoS+1YOme6pjRa/Qz2WpLIlafNFB58rAfX0xWtHPJKEzHLn+WR8+5f?=
 =?us-ascii?Q?0s3qHl2EJl+BjZNwJRyRZXkLY0yFvDqrj5eUfpi651Ps23Ym1Dcpj//j9WMC?=
 =?us-ascii?Q?F7lyfD/AtsngRpdn25UkPV0fyO+whzTntTSChhsX/ajJyeaJxHNWgOivkaG4?=
 =?us-ascii?Q?mw1/WHm4Of6nz/oIB6GbAQyFlAPlfQZxBM+TkFFSSRzYoTDSeJrJVsRSJAfY?=
 =?us-ascii?Q?IYQjE0qtDhhk1vI4rBIVKuhmIkco/DLpVcV3bHw4mLuF1hMHVZa6b0DiXeBP?=
 =?us-ascii?Q?xRQBp0J+u6Dbrl1EXDS0D6S9hbEgKwULaZQCd9x/QFI17x8cHgnDKpwYTSDQ?=
 =?us-ascii?Q?1KYPqrngIfyxhV/8iYdbIJqAc71+1fa1sPqijGSbJtQxoWnELPSxmgivBjVq?=
 =?us-ascii?Q?mL+sbZ6Ao0GG6iyFgwVHcqfe/sTcUWIPL4BEFtL7UR7S7rLjmrR7e/Lo/Ils?=
 =?us-ascii?Q?3xeaoEv1PALFUYlCFvRG6gIEYJrusLliuYYdPneZ5uURjgMPE3utTrkJZJLi?=
 =?us-ascii?Q?jLrnGa9wCpL2Ex8lvu9KIDNeXVF+clp2wva4FW3FgLuS6NerF2t56O++C/lY?=
 =?us-ascii?Q?gURW0egL0FKBYv+bP+6atBcl2niY5BB+gf6VzMflxd0M8bUZnVkkPj9dsMyf?=
 =?us-ascii?Q?RrQ+1naTQhLaQgs1VFA8P83VTOApd4hNPrkHWL1Jr+W6/xtgN2ETFHtuBBOj?=
 =?us-ascii?Q?+DnxlfyPLhARsc1VsiBRgaoy+vRUJl1iKqskhvHupfS14QfsopyOKqPzsbzL?=
 =?us-ascii?Q?Lk1lYaeA33zOHFlSxFO0QwsDaEua9PdUV0oEkPYcPDXkJAt7wDbfbCd3Rejh?=
 =?us-ascii?Q?cwup2fBbczMpjROD0BmNi0HOUhQOGyJfkvO6KWIp29cigOev+OqXU4h5WUO6?=
 =?us-ascii?Q?3rziTcyatz/MBHvQWABbhdQnLbG+IHSCm0z9AUYHWcQO0LwMh8PVdPoBLmNk?=
 =?us-ascii?Q?4PzwJT1TvG0GTKva8EIi+xEKhl1vcZcN/SAd8m9FE5a5EUxwciIOWgIPNN0l?=
 =?us-ascii?Q?i6NaDXjJu4ffQkU41/2IVTxX7xS8PwpC7p6mRDliAwnOobd9rRBndcw6nA2G?=
 =?us-ascii?Q?rDxRgz5/68hEkSq3kXqjYCkp3NvNI9TSLHogv6p3zn5mMZJKKR8mpuifX7AO?=
 =?us-ascii?Q?8mhD0jsDtL3dgnd1kE7uKRvG33xYMUDLAHlTjr8/SJTJ+brbrHbxCsrducEr?=
 =?us-ascii?Q?A36CIjKqVUwuLDWoKUT++oGxUEdYE1wIx6qWrlBkfCf6iPkV/gz1we7KL+NF?=
 =?us-ascii?Q?h5JYPgRi1eAuqTG0HhTnX+tBqyl6/txcSK5N6L50H43pI6MfNokYmKD8yGBV?=
 =?us-ascii?Q?/le5re42ZRRvzbw2p+EEkxJEi6ySK8k5sh4cE2788FScCvpp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ba38c6-6021-43ef-6ecf-08dedc42e978
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 16:15:07.8324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IlfLy8qlV9m7SvPdQE678oLJbKsJskiq1G/Q2m4jyr3WmxsLJ/rKv2YAaOVrkXFt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9238

On Mon, Jul 06, 2026 at 08:57:22PM -0700, Nicolin Chen wrote:
> > @@ -734,7 +734,6 @@ struct arm_smmu_inv {
> >  	u8 nsize_opcode;
> >  	u32 id; /* ASID or VMID or SID */
> >  	union {
> > -		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
> >  		u32 ssid; /* INV_TYPE_ATS */
> >  	};
> 
> So, union has only "ssid" now. Should we unwrap it?

I thought we might need it with some of the other series?

Jason
