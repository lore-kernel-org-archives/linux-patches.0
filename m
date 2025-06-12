Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34772288C6;
	Thu, 12 Jun 2025 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738707; cv=fail; b=hyasx7vR2z4EJ9fTZ9++UyLxctxihLoP+gmF+vdPNtm4NiU0SFlTOi4hiSRJEmnuP05IeynO/JJVSH33fgcCA55HRn8/DbSLiM0KHs1cumKtSMqGFIXQo7xstOtOz37uNHPQ037MsiPH78mYyWU1Pbeo8IRARe0D/T1yW7eTC0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738707; c=relaxed/simple;
	bh=U28INv0DpkMYmjJMeinNVWQYX6JkZQKrZptbdeK3V6A=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pDh+n2E8VRYbnPZ3Nhi714V/dPzqSfYqI1K91IDerpfHxpxiSV27LS4BNByPVvXLjZLuw38U0yUsEZqZYEGTtdlhbZj8H86Kg8AtNhaeM6DNnelKbq4tgQJRlEF4gTJyaqEdx5YLlL8pzNT6ZdUQbNOcoSRFxXK05CFTKYtT1M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uA5cWf9z; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uA5cWf9z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gmX8gTeouWUhAi766kz5pAVjLQxGQT9SgMHkKZL0an22lPRmiJm19BXJhNpNcdm0kJOhsWBsCzq9Z8cV/fF5S6FduJeldqnyyZ9sW5k2YqH4VTRo1/MokUJEGNBMx+IgLTbxsLEiEk/epYt25SSQKm7QwLEWZL2b60G0nPA1UPODAvaiRo0bhdPud+lDsL8z9+AbrXdwFFnQg+BGCJ4+hDVJdRkl0QN4YTIuWVJlARA/I0j5iZfsbW4zW2YByb/qt8KuZ/LtE64YZzO/RJQKVvffrSt5azDEqFWZtKtGSaBLxj4gMX1vv0REZyxIVJWINIOMyccbH06dCvl08dz4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwhhu73Btzpcm1ITVBCoVmUlt5SNCMjPImWgCG+5pjs=;
 b=isrp+PeWmakCEODPpDFcNX4Z4qGp/rpvQ2198nVIlq9UPDWvPIprQhPPr/W5BGyZn6D4CR6A6ypUxQzM501+CiizhQsO2L1C0lC3ipDFtrzasnNkuN4Z5yXE/8h7rIwoRunQY+su6p0BCXzo537zHWh719AHu/boOy+XYJDV90b9yRn42rdoOOBhWepjKAtdFw+ERcqHIRk+1Ti/GA0mGRtBLhcISN11a9qC6WPm2puZv+efBKLB65t+UJU91BhcxlfEranc/h8Wd/XcV3E0CzvgsWrJzPHDl+0gKX33RSQcvzN9EJ5gQdfgLO+iu8Nt1oTKNSnQTXVLfUzbfF7Cmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwhhu73Btzpcm1ITVBCoVmUlt5SNCMjPImWgCG+5pjs=;
 b=uA5cWf9zc6Oi1kFaae9fSNGya976SWgGhwlAe+uCRjbZBy2T9ACKah9TGuXAOzaFwD1EODvUAU6aonFmu+OcCQ6QcXgZ247xwTqJHxLk5xjPGvZbU0YfDHjsCqz352wRkS++bH1h+yGKSPV1Gxkm9Wyik53FW7jPiImZMPicMmNx/4/EWpk9KXXCXwdWBZ7/0yJiGAvIWFZwkZ2XKn4YnaOTfFdPNsIi1JfhFDnBpO/O44xUsy0KprPD/LtQKbAj71aaHMX8uV0jAk3rArjTZBQ/L77y0RANbCeMmb5x7lOwUFe0xIl7ZSvJAkAZME9gO8zFm1/3A1kMIPXkFkGODg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 14:31:40 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Thu, 12 Jun 2025
 14:31:40 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 0/7] Reorganize Intel VT-D to be ready for iommupt
Date: Thu, 12 Jun 2025 11:31:32 -0300
Message-ID: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0142.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f01a0ea-71b8-4b75-b2e8-08dda9bdd882
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6r/JlvQ9UfelTbLYbnEVVbD2vSDs/rSBph88nOO1rwwsxJkTU97lyK3c8Xal?=
 =?us-ascii?Q?pcgQ/qt7E4DC45B587UZd9GEU8MhI/tfRQInviaYPFchuJ+0IAO2A8PqD5IW?=
 =?us-ascii?Q?dE7l8ryuYIIsQzuYT8u+foabZarieaE6xZvPDbiFM/3PIrma6y3KeyFWZ7bx?=
 =?us-ascii?Q?h4MbldbC6sm/O3gAl8TCyH5TAoxrdQ+zdAXoSC9BSJ5qxxX2Ta1VsOkx0AKl?=
 =?us-ascii?Q?Q2yVz2QEazWoM92ZIPpw7XnJfEs5W29Ec3ANA3ThrG5DqD7W64D1VN+MOhpW?=
 =?us-ascii?Q?8kYA7KoNw1YVmHghZY5rcafgymXdwqAPlyDuoaByLDi0AcwDyIVl8r6m2i0a?=
 =?us-ascii?Q?IiXI+nBIDorTmCcz4Zm2Xju/gIkaVqNUZiaGdj+F6BmqRdNVGjQLyWNm3fvf?=
 =?us-ascii?Q?6u4OWpZ636JJjd/NsiR0D67rexuPUU7SwLOy1cFhc0whdtHl2mCljh0RkNBP?=
 =?us-ascii?Q?KarxM7BjN2KjyvNeRdaimMjXdHur8hnoAQFo+iGmEjlVsLOwLvG9xdVjoJno?=
 =?us-ascii?Q?xVh3/nWXrX0RgwhAr1yKL9Sy/Jwpfb5XdSox+f0gomRXGs/IdbFaMOBRTyif?=
 =?us-ascii?Q?ZBCVi9X12b3b2A0djPJpJOMaDSloNTuVoR0i2yoo2ACcpmDc83blV4EfW87J?=
 =?us-ascii?Q?GOSi4NnYYLv7fGieFlPd3haBqIFemhI+JCoG1pXgBycCD3nR9aXD7oUXFint?=
 =?us-ascii?Q?Mrp75ouBytUJdBmkmyHiy6XUookwLW28txN/yEcPqD7HKjcx++SHMp4vpPHy?=
 =?us-ascii?Q?SRsaDEddQV4UriP3V5GKmz+Xfhr+TKelUJ0oMwJ1qgtUDeK6lmkg//xVV458?=
 =?us-ascii?Q?nFomrMh80Pa+fQxIZvQdgi9ZyzR3Eqb4M8r1SDR5cphUMaf4Tw2EUf2dh1oe?=
 =?us-ascii?Q?iLwlleOW3Yx84fS/0SnJTSu4HpGoIjNI1pT0LPlHFCbyezO7joToJHURnQp4?=
 =?us-ascii?Q?AvkEepg37BHJLe3UF+XB+9suwEZsObCdQrfZLRAFsxozP2FsG9HhTVXb+iUE?=
 =?us-ascii?Q?Do7o6VifQUJVPZipygU+k3rHVFU647MRGNk7ucvOq/d4pkvmoARpjMf+9y0U?=
 =?us-ascii?Q?/JWkSh8Ns9yt7ny/OrAPlG0yNqwvZRT9r0QOvG+XmUCGVFb+xYKkO5P0f2at?=
 =?us-ascii?Q?oipqLfC4a9AqGQhvbciw2r2d1cHuOJdAY6LT8gA/ceKOQ2RGsCWzi9e87upc?=
 =?us-ascii?Q?/2FEV7sfVYBVtovEXS+GOczH1vr65wBUaqdgoUFG6MMi794QlBfgfOsFNpbR?=
 =?us-ascii?Q?RoypUAuu9t9+2F+QxOyiqnDBMoYVCx5Zd2bl4kUfv2eVx+16WbnFbNtHeurl?=
 =?us-ascii?Q?i0evXc2ea/vfUsjZVh7VYpGQQB8b90EdxMdDUgtQiXC9M6NTCUWk5TmG9oNw?=
 =?us-ascii?Q?ZrVu6qmyyc9MlMCszZM5+/wXWTW+THaCC6HngWNo+LZppXR8ZpkhA3EFTvY1?=
 =?us-ascii?Q?Pd9f4dV6YVU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zznJ5wJFsyhgESBzUGpKfcRIxgleNEx0bJ9pnN+gegMzpLCFYxwjouSqXOPe?=
 =?us-ascii?Q?p4FIM1fqzl73SIpoNtB8wOxAnqjjPMY7aFJQKg0uBDCmtXivvZDG7LBK1QrD?=
 =?us-ascii?Q?X1IntNGQ4QrMeDU7Vdq2sdnqEU/cODs5TX7nWYIKJkNUmkNVL3zEgsaoJlys?=
 =?us-ascii?Q?StovHJx/d4jhFrNwqcljZu7I2LNxAQAhvTojsA7SRIFSzMFPruHWjz/Upo7t?=
 =?us-ascii?Q?JchI94lK1XmrGQ4huwqU60P2J0aya0n/Rhz9v/84Of6D32iXp7US1CgUZc6V?=
 =?us-ascii?Q?cTKHf5eE8o8M0jIigjwriP3vmxTBDn8NfbpbFllvuRtblSifQFhY4qTZpTdF?=
 =?us-ascii?Q?1pXitymHsZmltN2r4QadCPBhpVkeRM873MS1uS4/Z1pkhqowOXeKZrPQ2djk?=
 =?us-ascii?Q?Dp4BZaj89MYtKMfo1Cc4k1EYF/04gno0AMsxDFaiLppKhxSjBajSa4zIhr7S?=
 =?us-ascii?Q?0XIKMeet7kT33dDvNNW50BR44xm8y4kWtJV3bE0KrDRFDtgPHkIoEmE6job8?=
 =?us-ascii?Q?V9Bm5zpa+OxF4wYlJIzh12GtXfFHiNe+z5c+3OhF5eLGaUPFwYfMtxiqlhia?=
 =?us-ascii?Q?26TjvFlzSnfWxL5XTZMV12fzcViajZIcZaRbreVJbTvh+46XUfd0FYT0QE9o?=
 =?us-ascii?Q?vPR7+GL3nSviFWYhKQ3JsSuZzf+iZ3BnYXwjYJPkbe0hS44ltcoRP8zRW2sI?=
 =?us-ascii?Q?hLXQOVPu0fHVUVLc5ik6eLWpl5FlCQW4mh1BkDENZHT+LnrMVCVvNCObQo6b?=
 =?us-ascii?Q?7VNwzWumJ/UxOBZ959CREV4QXujAlMK/eghaUQzj8hmSKG48zt3maE+N5M7x?=
 =?us-ascii?Q?6R5PPzicNdei+2/A98MN/LfuWadnEbzNNDmbH6kSyJwUQhIi61P5sq1e8OeV?=
 =?us-ascii?Q?rC63kbbrlmZbuWTTimuBHwOSsxIaau53n1upX1A0tIwTH/ZWPaRIlyVgVbYG?=
 =?us-ascii?Q?nOy7f0crhgIT4p2Nhdwmb1syaRKhVg55v85sFQ4XmszkgKeeKAxW4lmp5ppV?=
 =?us-ascii?Q?tUlX5N+DsqGxLQbBOQwB22kGd+VHUm5cIJvLaaENZdPlwUJysJjuxQcILACw?=
 =?us-ascii?Q?YOfJNtvGPtSVsMnWPDOYdyPYvz9kfytk2G1uNILBhhkKk1VcxOOPsZC3vir9?=
 =?us-ascii?Q?gT+VpP0DJHY6lVNDggLPe3puy3fZLv1EwROdVzs8MXFqw6ajSfdI93U3IdkA?=
 =?us-ascii?Q?TOxknHO1zFgwYCVYDTMw061yF9XXLHD4atVe5N9MRC2617Tx5nfYe+3rgXIx?=
 =?us-ascii?Q?ygt4wSDsLWWcOouzYWMhzXSm+jABIY7Hh6wzI5u+gNWkslX1Z4Ps126cLzgc?=
 =?us-ascii?Q?n2OjwM8ysE5sFDCrN0VJ2Hc+AE/B0rgGEkpIdC6DRHYbADkvj7N5iooo1pQv?=
 =?us-ascii?Q?ggGi8YZEtUZA9WIH4f6f/ID0uN1RdVD0tweKicgG1RvhUpofKbtUUj5ZNDdG?=
 =?us-ascii?Q?Nad0dlUnUysfuUjSYn/6jxP1vy8qXWlPCrwPO0HUu60zAYDXLGcs3lCPZWZs?=
 =?us-ascii?Q?aKOOGFrbMGZTMAm+OswXqasNUoIZLGQoo7TkauqK0r5xk9MBXwamubnqs2D7?=
 =?us-ascii?Q?ODNA5oQCdAoL6cSsV17ACcxrBCvFN6TKjjuRzJFj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f01a0ea-71b8-4b75-b2e8-08dda9bdd882
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:31:40.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PajWlIDMb7Rk3x9/URjil+nV8kOUfoS2uutpcvf6ZMXLwXpglPnGg3UohkTdklxZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

This is similar to a series I sent for AMD.

Lightly reorganize some of the page table related code so there is greater
isolation between the first and second stage logic. iommupt will introduce
distinct types and code flows for first and second stages, having them all
combined together is difficult.

Splitting actually makes things generally more understandable anyhow as
they do share only a little code. Most of the registers and logic are in
fact different. That was being obscured by small helper functions that
combine the first and second stage information.

This would replace some of the patches recently sent by Wei.

The full branch including the iommput conversion is here:

    https://github.com/jgunthorpe/linux/commits/iommu_pt_vtd

Jason Gunthorpe (7):
  iommu/vt-d: Lift the __pa to
    domain_setup_first_level/intel_svm_set_dev_pasid()
  iommu/vt-d: Fold domain_exit() into intel_iommu_domain_free()
  iommu/vt-d: Do not wipe out the page table NID when devices detach
  iommu/vt-d: Split intel_iommu_domain_alloc_paging_flags()
  iommu/vt-d: Create unique domain ops for each stage
  iommu/vt-d: Split intel_iommu_enforce_cache_coherency()
  iommu/vt-d: Split paging_domain_compatible()

 drivers/iommu/intel/cache.c  |   5 +-
 drivers/iommu/intel/iommu.c  | 326 +++++++++++++++++++++--------------
 drivers/iommu/intel/iommu.h  |   9 +-
 drivers/iommu/intel/nested.c |   3 +-
 drivers/iommu/intel/pasid.c  |  17 +-
 drivers/iommu/intel/pasid.h  |  11 +-
 drivers/iommu/intel/svm.c    |   3 +-
 7 files changed, 224 insertions(+), 150 deletions(-)


base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.43.0

