Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B921B35294C;
	Tue, 27 Jan 2026 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769523920; cv=fail; b=PUWkk9FFw4STucAxL2A+7YUVOFep6IWE8moVmhwAtko+j9+ItX3zL2CPEvmYFcer/Pxy3jNvSP+A7CSk9ujfsCn/DjWuT5nHaYUG4vvvMBkhyA83VST8wR+Z5cpDydcgJA3Fkk2kX2/FHSbiUyvQKya+mJUov39PMhgcrKv+JyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769523920; c=relaxed/simple;
	bh=eo+5ALVvPgjgNGq6k5To1fS0thHnfAkYiX80Zu8QCd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pacv9L88ApzqnQohEClyT9eNM0hG6dwAA63sbjhxpPY+0R1bYLfuN2ta7s63bkF7tk6XQrY3N3ikQp0L2pjMuoX1m1nxRSYoxSAEHvc6BMqCFsednaMrSmmcdGxkdm1nExqJm31v3bo+EnQ0CzQ2vKqXzHbAdPd9PFl7rP9PHyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sZgMmuY0; arc=fail smtp.client-ip=40.107.200.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sZgMmuY0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JMNjzZMNlCfNjKcCAukOxykEHH5ieX/Uwt788fB2BTjcWWcXrgbFUwdh8iTgJdq2diaw3ffZteOh9eYTrbuRBPYcwx2BuEu8zTi82hV2xEsyX7mpBqogSkRuRDnFOED1Ym78H3IAr7NY5NVHc+tWjNAV5ZEcvFzT2qfr1BFOXWAUxfokHlRtfGBrNWMfSYHKj59erlVGAMp8BM16pI5ZU8HgdWVJgCwr9FOSQIY8ofjeBlEQj5wDzPHKbA3fNKPe2zDIgz8BQDLMSzb97rzEs8PD9vQfVVzlXGYAfxlIJrsJS09ndKOwD4YWN/VcqfG4VexDHfTfREVXiT9lHgsnOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YzZFug2fpjTsoLQFt5JM7SMq3s0RdyufW3ro/ToPd7g=;
 b=I+CdN/RmsPPzIAz3p2wnDp9BPJG5VMkW4r69SRFS18AIiU6oc4oESnp/v7Jp0jvJqhbpQDpbekH0lhZxcnX69ttST2+fEZFQOwOPdRloNLK9g+AyC7Lbi9+I1MympYqW0DIcqwbhSQ/wn/dDgpCkEQ6uvd7xyKPXzttlIFbEInlOQvfn4DSRDuM4vUuOQ4Uif/rivaO3qlv8rdj53UeJLzhMUf79rHiUxFmonbsO+1fvOyK22T+AP4xM1h7O97+CnOxi4gX01KxwTOmMTGxQc+h1vjAdmcwvRkdcGGQcGAORzTtH1exOosQgUiWQ7DhOaXSHKqXxFQJdE+jQI7sPtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzZFug2fpjTsoLQFt5JM7SMq3s0RdyufW3ro/ToPd7g=;
 b=sZgMmuY0xCkezyOVQch5Z25ysRQ0QB2XEqlQQtQSTgLzYmK4lMFDdz2MGdM4x+c+GcLXcdwojhK8BiGo5Tzd08zsfVNQj2OdOWecKjYizJI+nIOTz4eFiV67JOKsk/fqGQWqNPozA9fSDKDyy3/gVWxMyQs72Mt10OSFEweNnp755N3KQ4w5CpkTdaf9t5qxf0OASEK/xRR5BHhB/Nym8/cWgHc6zdMBbGpSC1M2UrqcpEV/Nk/K9VEnakshdceuBMmo4R0iFZS5kfUz+8tujAwXOZRmQdgqBRCrKjIZNrs/ozmhCb0GGlHhPryPbAGFXe2jON1F3RoGHy70+MU2mA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS2PR12MB9800.namprd12.prod.outlook.com (2603:10b6:8:2b5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Tue, 27 Jan
 2026 14:25:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 14:25:14 +0000
Date: Tue, 27 Jan 2026 10:25:12 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
Message-ID: <20260127142512.GD1134360@nvidia.com>
References: <20260117154347.GF1134360@nvidia.com>
 <e0514ec6-b428-4367-9e0d-cfb53cc64379@amd.com>
 <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
 <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
 <20260122141240.GM1134360@nvidia.com>
 <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
 <20260123141413.GY1134360@nvidia.com>
 <ddeb2bc8-5088-4d16-bea3-91d58a4403e8@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddeb2bc8-5088-4d16-bea3-91d58a4403e8@amd.com>
X-ClientProxiedBy: BL1PR13CA0419.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS2PR12MB9800:EE_
X-MS-Office365-Filtering-Correlation-Id: 03c7b46e-9317-4d5d-4bcc-08de5dafe25c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6qfl4QMMuZstECY38U2KiFp9aPxkpGB0pFcBoEOZoK0zku5RP7CyN9GnnZ4+?=
 =?us-ascii?Q?ffy45xtz8LqqYo64J1mgwbTUzDIxhT8eSLrnmCTlQ73UAAqQ7Rgl213CqNli?=
 =?us-ascii?Q?lo9YXeoKpDTy4vcTxHxiV09vkGiRbtYo3YMlAhxzGSoi3hmMt+AIrc/9fhw3?=
 =?us-ascii?Q?MqQyTFsrRKGH+v88TN+TnxsJpmAbJa3wpZqM5wMI7KkCghCe6c0zDjtmZCED?=
 =?us-ascii?Q?Vm4PTj/cK7M9Bk0qDCG+zTgphZyaqQXp/Nf6exTbpw1QaSNSGAhmWPfDfgyS?=
 =?us-ascii?Q?+2bvllz/kLE4jByyES8TGOhEqWnlh+gZG/XoGdRqjNMmMM23Amtbn79FKfm8?=
 =?us-ascii?Q?hG4t+LqXtKFWrqyJ7gBKwjldbH7RaqucDMBKJGTooZWc1TZrL4qnDwKqSI+X?=
 =?us-ascii?Q?kiwUx5CXHRDtMpAVkUuzOtFok4AnNpreH5719HBTulhLdMQ9EHu+hAKvnWDh?=
 =?us-ascii?Q?Br7Ixnrlflpgiak5CH1X8Q1OQXsrWH8x9csS5wKg4wnHD9tl4uX1Tf70NwR1?=
 =?us-ascii?Q?Va+d5igaR9NQI/eIFgx5nundMR7tV3iK00XL/rQFqO+bEs/jIt4WVujjEfYv?=
 =?us-ascii?Q?EGZhu82aEYAzYgMZRl25eJ8/ZJHsRJQktVErKAhkkiHdoz/sRMH/2ZK4KSC3?=
 =?us-ascii?Q?eQt1m6NHkqeIE/YYKE40qPN5vaEQ/LGsHHgCKB6kWq7BWWTtNurr84AG7M99?=
 =?us-ascii?Q?XBNIY85Fcwex/bpH4eVzKJM9jSOozRg888KBS7jSm12QRGwzP36+oWW6dOYh?=
 =?us-ascii?Q?sWb8DMXwVVCZQqKgGBtZRbeAV7xejagL8hSOU7MzwMMGVOBrVU1moZ1+WrSi?=
 =?us-ascii?Q?/p6uU4NztTGvySkA/bMs6u2z2cEACHOoQcdqPAxokKcqD/qgHBLlGw5nqy49?=
 =?us-ascii?Q?SsFI/8ju+YD1Ue6gInFB/6GMWr8uK9cRnqMNCW2HRlSUGRz/sHDlSR1WizqX?=
 =?us-ascii?Q?gq4lXt/sj7zNu8yx+qmYvpYHN+PqE253kaChJsOkF3spkmuuHbW1e4ZXvxdF?=
 =?us-ascii?Q?RA5qdakOPqeefG8uOdgAPDLdzbo0yGYvFNX9ebr8ru7AsyTHVIeToBZ3cbxz?=
 =?us-ascii?Q?VM/1G/9VRdX6t5NQPF549iqaYaP1C0BzBw9X8kz7knWGuTEggd0uZOxQIXr+?=
 =?us-ascii?Q?ShJb/yjKXInpjRJfpKzhR6ZycJj9zBS0wX+1aBlq1OD5mXf3RqF6KWMWa9N4?=
 =?us-ascii?Q?vDmJQorfDcE/obIBOmT2EXglkJTabX6Oj2wGvG/vr/7JsFJhvhRNg5erxKZz?=
 =?us-ascii?Q?1+tpE4Vw0qoB+g78bjB+LIhWgVPtDI7kR4rzjE/N6rjvsMqFsfXAbjutPzxd?=
 =?us-ascii?Q?mjnzH8M9KSn7mgDDpuBvrh0+4vvxjxgj4fMX/TQROsYTFKA+SoHqaRK8RJPi?=
 =?us-ascii?Q?DsmPTf/hWgOGkWm3c8gHkRdooEYROj8AZnlc9NW5dzOLzxg4M/mj2rLXTyFW?=
 =?us-ascii?Q?gBWJUYO5tDRG7b/JX3jLWT8YgzukSPS3KKBZE4L0hMcN6/ODuoM7JDdaosP5?=
 =?us-ascii?Q?d6CpUyF7OgdPoELX9yvDO1ATSdZXkm4yJ47j9QJniEV+XLiliJx8ZPUc6wWo?=
 =?us-ascii?Q?iBkhIUDX66IENcUBCek=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qoc/iW7szxXDWqhK8NkGaBGtSG1Vic94wLv+I5qlJhjPiCeeK7kgV9CxlpaB?=
 =?us-ascii?Q?PvMbcKthp9OjajOGtOTBg9VEJ0j2m2QOHiPzajnoSEbqhe79oY1eyYE0vhYM?=
 =?us-ascii?Q?TcEFJCQt4WhL6D07/UGjUA8hx22Vs0GRagRWDTKoVDkZEwTh5tK8Toce+171?=
 =?us-ascii?Q?rkXS+Mo3QhgvjnQ2rEl0KErA1RrJwGiMpSdbfwc1sZLfAXEEKH6nB3lKZmeB?=
 =?us-ascii?Q?58rSAXV+RHgPg8BUtFdjprFvg/BdtZrNbfrv7RiL/EhZOS4wFLI18H1TLqJ+?=
 =?us-ascii?Q?Q1HNvQKJnhmTcUcYsTJZyKFfTEoQBFdhIA9diaUrgGjbP5+G7j9MXm5xA4F/?=
 =?us-ascii?Q?wwLorY1EqXHaxYQysIuAfWPot+X0V++WNF/3djptvkf+TxIWRZG+SjvIicZq?=
 =?us-ascii?Q?QLo0tOzD9exKp/g5gKX70TJeKF2J6bRZTC0oI1sjxST8IqA6fJvysdXrUBx7?=
 =?us-ascii?Q?wTDPln23StVp4Zh1frSCD0Ly02pN5x/CdC8Nk+M6xwR2mzaTz76jiG9g8zs3?=
 =?us-ascii?Q?ANhjerDbSSoK1nTit2khCyrjOXY5m9ntT9uJpIIG2wU+t2UGTSItuFCV5B3A?=
 =?us-ascii?Q?61ebMlyaTNdoHXvrOzu8C6cNtfqzpTlSLmJOImkYL80B21jwBoDISeR6HjPa?=
 =?us-ascii?Q?XbPeg1Qr1i4b5BMnz31tRg0IePcVeGrre5VqqGe56PS4lFoeCLmMwHUsZ5+5?=
 =?us-ascii?Q?W2WXF47WeEO5AsTKPg185CkMwBP+5sKEF30LQu1yQT+5p9NkrOL86qVeh//a?=
 =?us-ascii?Q?PnnPscwDqFIQ0BcjI8X8BGZ3Qg+TjA58u9X+l3aWSA+BnIfjQJtqeNVJy7z8?=
 =?us-ascii?Q?Vh6cfC+/Z+qzn1b71tDk10KDMN2ZwUOTxm7PmlU+LCz9YEO5qMO93ijBBzYg?=
 =?us-ascii?Q?OWrtxG1kHQFTxfP6o/K+RdVCh1PZ7FINQU1JWdDAsDNbuL1xJhlk1rVqdsIW?=
 =?us-ascii?Q?4MDEV2mo5Y2hPYkZ2cxjQ134QZ5D4La8tpjAhn2gYIKHJ3sye2u6pft2ClqU?=
 =?us-ascii?Q?xuzGGOMRCDVAehMZPAuobr+To7gByF+Hxc8NUWhvIPst61vqhy6cTp7LZKvI?=
 =?us-ascii?Q?tmDGlzGUIfoPLYrFhg5C+gCcCoJmR5MY14gzVMGyLvngWdQjaV6ltCI+hiPu?=
 =?us-ascii?Q?I9Ya/RfSPj70SAtH2BTv4AMpAol9JOgmyDrFBQwza5HVKgMFlh+ojMvYy7wH?=
 =?us-ascii?Q?degRf365UMADYCx+dTinfj9cbdsSrR/YQxtAYRAkcm7a1VnNP3HuFRMSa0Ou?=
 =?us-ascii?Q?M1aGC0WXXdQhXdciGJxvySaQi+6PlFdLRDkybhdQdm2lFngGX+mya0D842F6?=
 =?us-ascii?Q?xB4zM1RXuPRzmZHbET+aOuW3tv+rZPRJULAwrkaXd8CTz4BxkEo0LoMUINgL?=
 =?us-ascii?Q?v8TKJvs6ncmPAjLaGrSIv3iA8VCaMULo+JHRN2zpa1dPotJYSX+ND/hN5mi9?=
 =?us-ascii?Q?cmBopjS9s6hjqnURoOyMzbNKU9I9zeCfBzGL2DFG6gx0RJHgJHPZfLoKsft/?=
 =?us-ascii?Q?f4bCuJPLZxbmW8ZLKWRMzYO3jqeRomFKjYXGjizxe6M/1UikNsHBUyCdP3mk?=
 =?us-ascii?Q?yldOmxgYwgFf0JE0WTJBXsFWCYLas7k6o54SxFvh+tY58IuQ2YmGjF4Vx1Y+?=
 =?us-ascii?Q?07N/sbTs9gmHgp4MoWSRODHS1bgnqxPOhkuD9AHMOAzqQDbUK7PUtGq/zpd0?=
 =?us-ascii?Q?dlqCpS+5RluvfjySw/bXmfDmUJjhFmILRwQWsI8r/EKveo2Qrp+YFZi5Z3Yj?=
 =?us-ascii?Q?wTzHZwi7ig=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c7b46e-9317-4d5d-4bcc-08de5dafe25c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 14:25:14.0943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MhF/jAFQAJJY3QBOn4iTvXl3YJfVWjNRT/qU5In/4THTth+388GwHUK7LPWlcyxp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9800

On Tue, Jan 27, 2026 at 07:08:39PM +1100, Alexey Kardashevskiy wrote:
> > Oh so it doesn't actually check the RMP, it is just rounding down to
> > two fixed sizes?
> 
> No, it does check RMP.
> 
> If the IOMMU page walk ends at a >=2MB page - it will round down to
> 2MB (to the nearest supported RMP size) and check for 2MB RMP and if
> that check fails because of the page size - it won't try 4K (even
> though it could theoretically).
> 
> The expectation is that the host OS makes sure the IOMMU uses page
> sizes equal or bigger than closest smaller RMP page size so there is
> no need in two RMP checks.

Seems dynfunctional to me.

> > > > ARM is pushing a thing where encrypt/decrypt has to work on certain aligned
> > > > granual sizes > PAGE_SIZE, you could use that mechanism to select a 2M
> > > > size for AMD too and avoid this.
> > > 
> > > 2M minimum on every DMA map?
> > On every swiotlb allocation pool chunk, yeah.
> 
> Nah, it is quite easy to force 2MB on swiotlb (just do it once and
> forget) but currently any guest page can be converted to shared and
> DMA-mapped and this skips swiotlb.

Upstream Linux doesn't support that, only SWIOTLB or special DMA
coherent memory can be DMA mapped in CC systems. You can't take a
random page, make it shared and then DMA map it.

> > > > What happens if the guest puts 4K pages into it's AMDv2 table and RMP
> > > > is 2M?
> > > 
> > > Is this AMDv2 - an NPT (then it is going to fail)? or nested IOMMU (never tried, in the works, I suspect failure)?
> > 
> > Yes, some future nested vIOMMU
> > 
> > If guest can't have a 4K page in it's vIOMMU while the host is using
> > 2M RMP then the whole architecture is broken, sorry.
> 
> I re-read what I wrote and I think I was wrong, the S2 table (guest
> physical -> host physical) has to match RMP, not the S1.

Really? So the HW can fix the 4k/2M mismatch for the S1 but doesn't
bother for the S2? Seems like a crazy design to me.

What happens if you don't have a VIOMMU, have a single translation
stage and only use the S1 (AMDv2) page table in the hypervisor? Then
does the HW fix it? Or does it only fix it with two stages enabled?

> > iommufd won't deal with memory maps for IO, the secure world will
> > handle that through KVM.
> 
> Is QEMU going to skip on IOMMU mapping entirely? So when the device
> is transitioned from untrusted (when everything mapped via VFIO or
> IOMMU) to trusted - QEMU will unmap everything and then the guest
> will map everything but this time via KVM and bypassing QEMU
> entirely? Thanks,

On ARM there are different S2s for the IOMMU, one for T=1 and one for
T=0 traffic. The T=1 is fully controlled by the secure world is equal
to the CPU S2. The T=0 one is fully controlled by qemu and acts like a
normal system. The T=0 can only access guest shared memory.

Jason
