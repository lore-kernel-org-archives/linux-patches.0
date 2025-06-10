Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A318D246BCA;
	Tue, 10 Jun 2025 13:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749562025; cv=fail; b=LTfbK80jrsF4ZwJzkGZwVtumnEIrp/jjcfMejt2fIxdRX0hkrjJkV6Ufg5oNBtxIGLK9yDQDm0RNUqAwjUkn69BqlD+ih8fAL9sMKJU2YK4ED/+9z69f6mgycnRSce+pvc/Grh85nqoGRrrUX+NBDxUWCuaWjd6d5LgsESJjQl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749562025; c=relaxed/simple;
	bh=HBsJMqmUbnMOvqevJkmW3FVvVQJWmcFdH4quLSw82I4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lYMiP1OxgLNWCT8VSjviLtfdyYVsULc98N0ruKL65JDqT7KV0pTZQme3PNDlMe0LfDMSCNn9urwAAbT0kBB6td2r8hVoDabsQzfDVeWl21mdlZrVMcwgNTpX2L2dF2UhiphbVQs48Op9FCLlMRTd27BfnbVVSVGI6caZYAx1oG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aI/2imLJ; arc=fail smtp.client-ip=40.107.223.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aI/2imLJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2cgDnXehI06xMXdJhO9voO69HX1AihEe+cV4fagePIrU2Hwp/p4xfq+ugA27SQaqBz6uAgKjRj3kl4PdwvQcVqL6FPTU28b4CmEVz8VCGS6JIhVhO092tkTsHO3ENRKz8n+CEmT44XG28StVfd+FkXlrqLMt4vM/o0pmcqrYJzPYJy0BE5e3AI1MYkqynv/kc/ftv+u8zEDeSd13ZY8Wx2LZHJdgcaY+laucGy9amAgm1F5zc5GOk12hY3m+lxuJWhJlKwl1i+mxCgvxsdEg2bJaFLDoWVakdWGTRQjj4ERCvJd31O+JVDiq1G2nPqRRyhmFqJyWSKrTCTgzyBZZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBsJMqmUbnMOvqevJkmW3FVvVQJWmcFdH4quLSw82I4=;
 b=pYBLXRRgmidOfaGIlquDonseFpOT+39W1PMTUvMdMJjZXtY+qE2CmnLrmbj8MID7vKC36dHBRCf7U3WF8z2zXPC3gpY/a/DP5lvnAIqnA08+J8SDo2EGWMGQvQCCPw9CCZ+oSMf2GLOarvh1q6le0+ny96Pc+6bmcqWt/zZb2FBaGnh+utZOr1dcF3E5k58tzAXKE79Y8MFbpZ2Jlhv+t/CNJv9Dwtj+Wm+OsX9ZoqEMzrDyljlPU57oleQyBt47Da9/rEDJt0CTKrkB31w+izM0ERbSnCyH+9S1IgOFeWda2cMTavBvp4+CevCVizMLrm6EbKUOK2Z32wNQxedN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBsJMqmUbnMOvqevJkmW3FVvVQJWmcFdH4quLSw82I4=;
 b=aI/2imLJzaPWurqnroCPXww7OQbOi2MTqU4x5NRgNLqGNMGZjpqlPsdh58NKI98RAD08Jve+M4eE+FvkK3gXNIOQHky08wISbKnv9gSa2qO6AadUOSuOULE67RNWqs9m8n+JTsc/lWkLyjLlLcegvJF5J+eBNal9yh+dbAGfs1EjTo6MCz08rEvk98GE/IGRLmmMm7G3uou90jV0e8Q+3ebSMAJc0EEXauz71hjU5EeuW/sF5D7JfaWRC3CbupYl6PocCPzTxXyMkfMmG4QLh0UlwvdopjRQ/7faQ2t9nPH058viTd0gj+6vroPyKx1+gU6K5L3/uWk/s7gE3tYJyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB9251.namprd12.prod.outlook.com (2603:10b6:610:1bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Tue, 10 Jun
 2025 13:27:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Tue, 10 Jun 2025
 13:27:00 +0000
Date: Tue, 10 Jun 2025 10:26:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 5/7] iommu/vtd: Create unique domain ops for each stage
Message-ID: <20250610132659.GF543171@nvidia.com>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <5-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <DS0PR11MB637351CDD705AEDCC1189B9FDC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB637351CDD705AEDCC1189B9FDC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0028.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB9251:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b14586-7ac4-42d0-20d6-08dda8227b08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5P+lEtgxKnX5yo9TMzJDlKu8U3GXZqOCHoXZoDIBUk8w73aYU1AcFKe6epb0?=
 =?us-ascii?Q?DY/r2ROiupPGTWBt4yRDb83CZq9mLnjzf7+FvEUKgBEprWKWmSSIR+ZkwvWN?=
 =?us-ascii?Q?Q0n+aigWwlOl11SSYNH/YDTVogEC6Hm7e5SypYuKxMBNPBq6hcpqk6dUo37d?=
 =?us-ascii?Q?sU8v6VgdP8yMifhFJCX7gs7YN5Cem7kJfGVBCflQCqkn3iTAmWkGcn0WjDZe?=
 =?us-ascii?Q?HARp7rf5u6/c4qpEZztFWqnkvvviFVK6dF0vvY5/zdbCPmoIaPgC5rNEjEtK?=
 =?us-ascii?Q?NoQVfyfhaNYl3r6hFET3SaBMAzvPYZHQgZka0mnIGm6imrORczS9DB4T7z5D?=
 =?us-ascii?Q?KCbYExYKcge4tzYfIhFvKZ/oJ5QgWHAfjq4tHi6Eq3pOoLT8eNfmjnUW2PPL?=
 =?us-ascii?Q?xESsdDKOetg/VMtURnyp5xEykqbk8vdkvZL9ONbajVpo1Q8UehIGdQQu8iAc?=
 =?us-ascii?Q?5RSdEJLknnSvJkk06rp1Z1yFPMMLu5ypG3fWC7HfjpEEKa+lBpGJQmvbmpby?=
 =?us-ascii?Q?0FxKYkAQg/XCuwTwyDr0tc5YrztGV2U1P6Yk7S0thBbAq120V7ySYs9WGUSK?=
 =?us-ascii?Q?yKtDj2Z1WYe8WFYTyip9EVtQzP6Fv1Q4oBVhmpqJmU2mdnZxBBoqZHRlxazf?=
 =?us-ascii?Q?c8ply7d3VYuyZSKVNK/65YFHy0jCzSX8UE2IEToYjKFWA5WP6PMnG4ALa5I2?=
 =?us-ascii?Q?5h4eyeGVBl5Fd8QsGWa85R5loKuRW4H9SfXmNLl1zMReB+VkqR/InOBf0tpu?=
 =?us-ascii?Q?BL4oxDk4HEEC1HCwMZ4YqjGgfYJKmQB6cnZ9tmNibM2SjBGGFG+/pj9jxuZ4?=
 =?us-ascii?Q?cyEfe0c50lwhaksbtxyIKgtKJrbdQoh8aWsrW0QEshZfsBm3OaD8U21DiGtC?=
 =?us-ascii?Q?JD9hHBNhLBvIhLxlKB62p7T2tC8dNfyBDONjsgPS6j+4KQNTmytu0NTzIRVm?=
 =?us-ascii?Q?8r4zcgtOd5x3uG9B/JPVQAL6rGBKhdFc2hRg9lw0e5DzpLlcZCx1sfC5XUDt?=
 =?us-ascii?Q?EfPst+IWT19Qe9u1pSXN2NaNhCLcf8izFSPrEUf+no+C6jy9kEzqTDX5pJu/?=
 =?us-ascii?Q?9vblCj6/cO6MK56pSM+Ven/Qzvnavdwcnx8othicZGVbLl/pwE6x57R41rzI?=
 =?us-ascii?Q?ew5g0y8NcnBEaCkIJ8N8nObRUKeb3m/lw1KMPB8LBQM3TWppUuOim1rFUojK?=
 =?us-ascii?Q?2GITNnMKoX5RevG5Pe/HsfAUrefDbL5VIRPA0L9WlEqNJ11s8uXiPW/IESCD?=
 =?us-ascii?Q?wQuZkh4TReV6Gk8mlWkUnSJqHZw+9Ke/O+OK7TML+e+ZRxguQbXrxe6wVDGE?=
 =?us-ascii?Q?WHONrdmJLE++bJIQ20IBy182uT6Z9/8H0XzINbcRH0QAQktj4KYVACVSFgb+?=
 =?us-ascii?Q?TvKIsMZCJz9dSmVVq7LA6ZYNo8eypHhfOukRqv7l6ZnwnT0ZEqVWGiXGCq0i?=
 =?us-ascii?Q?3nL47mNOSdQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ls/pt7VteR7VPdcp03DeAn0MqYGF0LB8hUNkzxWBJPmkF1ODRXWdrdaOEwEZ?=
 =?us-ascii?Q?Qn0q6tcrSiOA1cA2MdBG6TezDhcmNgMY5dECq76zZPX5RAcR+bYx8eHHBgyn?=
 =?us-ascii?Q?cycad47FmJ4y6mUjGnVAzYtaYNGARiItbTO3+Dpac61Gkl+DmkNpnMPksEOB?=
 =?us-ascii?Q?eHz3HGk6RzrDX/D0fTjPVK5yItw4PyBi8vfbRi0Opo/I3ldZTOxknVerEOpZ?=
 =?us-ascii?Q?N/AUq605cA/a37lq0zjE85CARkSrKPFL8UMRXmWAPMH/W8ygLyiMZoU9QTzI?=
 =?us-ascii?Q?P6SO5ChBbeobfaK4HiO2/fK400nFszHWtaTZ4lmXm/DX+GE8720FTtv2xMl3?=
 =?us-ascii?Q?bAyqtC4VsWx5X8D6+8UdWDB/RaXiZIZ7BgRuWoV4EVITY/pvKflzb0QtOCtv?=
 =?us-ascii?Q?OdcU2eM7/TUhen9R2XWijO1RDnh5ekSoLqenPXSyUnM9JlzobQYOxboX6Awv?=
 =?us-ascii?Q?Pst8sZv+SqWuQTR6VnKEFGRbz3uw6d1HnfxHvm+/5l6SNxD1Nhy06tYDH/qi?=
 =?us-ascii?Q?hr0aMgEyvdwcPGC8hJx3SWfHjTOKX7Y2emf+hOnWKrrV7UWlq1VMPiQEkccR?=
 =?us-ascii?Q?SVsWjiegnSbYYA2PxO81O6On14WkufrP7TjoJVZmC3ICBnEHz2pt2Mz67ObA?=
 =?us-ascii?Q?wxrn1CYyjF7XZ/W7TpIAcYL6wgM965wHmCM5DlTfg1nImD2TYMWgbzEHSNsg?=
 =?us-ascii?Q?/exSQNPDMSekinCVeJMw/Kzgth2RpvKkDYWkBcoGgfRHmaNfBP0qxPmBqaha?=
 =?us-ascii?Q?MFL0h27K9+UmcCqrCQgQUGpddD3fc734k5us4+B3e2rhPXTs3cCT3DN2E9yo?=
 =?us-ascii?Q?UAJKHCreqBG/7t+BKPPrDgo89ot5aaGK/yeT+Uzjw9GjoxdPsSiNrWMlzJWV?=
 =?us-ascii?Q?mTKCf2kylMgJnLiCMRvGNLIElYan3ZzC6xTnuDrSKbDGg9O5CEp3xXOkTf5m?=
 =?us-ascii?Q?7llvWEqsv0fK5BtzinRJSdussuxWwVTGusxC3vPktOSc+bx2Jn88iSoQMpmG?=
 =?us-ascii?Q?k4DJ1eiyHnXm/RPBXQldtbXnQ5LlFrGLsqj00w2IZpWBKpKxPtY8rcaQOTAt?=
 =?us-ascii?Q?x6hb+wog83f7/MLhem44KtqcrDT+YRdwHdyukrNY2mYBvrStkdhVhZPreRY7?=
 =?us-ascii?Q?+TNOV9T1BWVlsih9oh3oAZqFdxyWJ7Kq/p2Tm0LGTQUeOSDnQafBGJMqzqO5?=
 =?us-ascii?Q?Gm8tglEhlyakNjqXqGfibIN0LdfVArqxkGB0/l0mGqusPfzoPPk4O+xUEyiv?=
 =?us-ascii?Q?6J3nCHPsI2NLdPD+8b9r38gGlTIw6L/GIMH5qldmRuZDHaTYY108QRxmtoni?=
 =?us-ascii?Q?jo6MVNnFg9biugpCbmuIjYx5OPRRimXLWKlo0hDn36r4FWnIMM7uXXWurLAj?=
 =?us-ascii?Q?mUFfAFsHLad5n0hi5jRwANb3d6dLsXoVphdM6FQhf1Vzm5l4qUtRGSEp/BDb?=
 =?us-ascii?Q?nuxwtQGdXDGCA7V0gYROauSKSBLl++ASOhSLKRzz7O3SlYhSrTbt+Yiil7I8?=
 =?us-ascii?Q?NrEYixlFhESwdEEk/DzehcUgctTP7mNg5GImmmBglD9C3Wg1TzGeBC/BDedi?=
 =?us-ascii?Q?bCM5A40WpRsJpY28sI+YkheALDOXQobEM2dCH95W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b14586-7ac4-42d0-20d6-08dda8227b08
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 13:27:00.4450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20BzSAvvc4Rg0NHZXEhijj2C7GSaW7JzBL74eY8FlSQrpOd0ZEJDKrrQ7UnSth4p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9251

On Tue, Jun 10, 2025 at 09:14:55AM +0000, Wang, Wei W wrote:
> IIUC, the only different callback for fs and ss is .enforce_cache_coherency (from patch 6).
> Have you considered splitting them by handling the distinction within
> intel_iommu_enforce_cache_coherency() itself:

The iommupt patches add more different function pointers, which is why
this is being done.

This series also uses the ops function pointer as a kind of 'type' to
tell the difference between sva/first/second/blocking/identity

Jason
