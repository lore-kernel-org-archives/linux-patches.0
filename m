Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692D8279357;
	Wed, 27 Aug 2025 18:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756318892; cv=fail; b=Cg2qVxIbAlBmShxLasJOzfscCyOfThmLVJI2RgAzF27g4jrqaaH0NNBmHi20lg9rcY8qI3IcaCSpH+SJvPuLiGPH11jP6wYLK7jwuwTPqSm0R9iemPLGmCl/trv9jpfp2cxmzvSaF4hTCZw5diAjC0rNdkKSHKfBCZ0V09cgXv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756318892; c=relaxed/simple;
	bh=BC4BuAbT+D0QUzKJR27EDii2M781Hq33Ww5/HR/Js+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jQKr8nDBZyrqQcBSvPk60SlYdzPNn614C1/k18PPg9FRql8r3vmifMY+ycXn03Zjva4pJsGdiyoO4ou29auYynJA6wWk9dRVhpyjUB2dWHFdl9kCUSnpqzGq2FBMUiqfblLWrhw91nX+eTODoBhmRRzjCp5QNycKOo2vcWVvOh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E0DtUuUR; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E0DtUuUR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v9XhavUecV5uPlIGTZe/KTyycnKycq7oVtDRpguwq+2AnnHkyDxK/7L1AKvwsCh0cCTq65yaG0CSG28O6xwRXgtci0/RZZ29jSBsJ3r/I6LeJt+zQWBxOnzkcO8Ko2ShboWiZtDIHYoo1rtG2zGBja20WoOaxsypUsAB32G4CByeD4+5OSh5Rab87BQ6AoOHYaGCsO18rV8CjqVObY38AxCUbfkx5+L33HYVqn8MZhtk8X237p2oOCs68pnULwWtHe0c/L/9ukfNMkuXLTHyIdIiyvfbzj5E72OFqRNG/s3ERDzYYRc4NDBXv4il9eP58s5hQWUlVG3f3kW42U5JvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jK/gdIclTnjtlrXrucYNnBoEiqmWzMuua3prAoiXTZk=;
 b=wzjOckaF4hrWA6Xivo7AVd5CXAcG6y0tzRSnMvebdkcTgyO141owSa2tHoTqZz1hGCUokIVr75DqQhqGo7b3gcIrUi2CIq2TZBRZmh0B2kxuSumgJhzjgguUmubPNNCHNPzSLqzOhmS+S+pf/KOwfgMgQXbc3ij2+eAyu0ZXNJykB1CiQ0Z/k6TL/xsA0apH7J0GHPpWquQ/W58e5BE57lHJMiTCaTLAQNGs2sB3iRDhaTkBmhAKxSqO5Z9KOe6n89ZRF6R+MIxSUZZck1KtTQ+57G2kDROx6FsxVvmZmXSHRhLgLlvEL1nAiYjjckjD2kKa9J+Zj+hRKQKbTxN1PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK/gdIclTnjtlrXrucYNnBoEiqmWzMuua3prAoiXTZk=;
 b=E0DtUuURKWWAwhOEjJdSimsOw/CcZd2RH0MLdYNXTU8cLum/3TSr/HSScKoPinZI+3buCb0o0jagRQmRe+zz9qqUo+d+BXgWPoDugMGTwId3QQZ2frSB33rLNW1rIfFRmQqHjP/H1dT9Sly36GVjbiNK7vhUKlIz7Ht9GkEBFMs9FI1SC4n/YaDqXLbYMYtlQrKHXOvt5bvhoDF1eq8JPy7bLqjJP/NAYdH+nbv3AI0fr+gxNA1+mnQvIkii4bjrdgzPZR6kpAl0u3pWmcDwpeqnTls+Qa3POsYEr0tlVFLANbfTmntycI1fdctVvrDPPbgOLA4ttboRa0LSgDIaew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6479.namprd12.prod.outlook.com (2603:10b6:930:34::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 27 Aug
 2025 18:21:25 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 18:21:25 +0000
Date: Wed, 27 Aug 2025 15:21:23 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com, zhangzekun11@huawei.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv1 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs
 when attaching masters
Message-ID: <20250827182123.GB2206304@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <d4dca0a6288e4c15994d41aa6722fa7d66e3816c.1755131672.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4dca0a6288e4c15994d41aa6722fa7d66e3816c.1755131672.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BL1P221CA0031.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 06a2cd3d-3d41-42fa-8a34-08dde5968839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m7+efFpFVdyL+ViIDd29Uds4gU1voua5daiGL3oBeOFqERB3KiPFBaKaAp00?=
 =?us-ascii?Q?IOtH6F2Y3wsjiwEdFFj4c0vFiaDDwc3U7QKZrasOta5g1efYSoLQTB7N9uGw?=
 =?us-ascii?Q?G/Z4zSNM8Stz1cMJB5nBw728DNJHHUpOnYz8fJpdVjjJMb77vaU/G3jbyBf5?=
 =?us-ascii?Q?6dQSmERRx7KWbQUjev9EW3BjY86s79veaE5xQBvcvOJWtiT/i2xJwji78+Po?=
 =?us-ascii?Q?OqkFOWLTj3LnVC+l0cdRCL384Zr/6Z1MiKF9ETy6670e2U/MNS/+tImJ7SVN?=
 =?us-ascii?Q?Eweycn4c6mDnvwyEwsS3VJREHOYGt14pbNiiO+P3Zv5wPNW+JBZUb7bt1MNf?=
 =?us-ascii?Q?pxwxki8gUZXdEMUPpYND9LXrIPhYf153szhyl5oPxluUVYcPlh5wHBs41NS2?=
 =?us-ascii?Q?RCKGCmsW5pFyxGMuQkLXxPzJAP3sWONbzm6fX4C8c6cVRt9znLF1qIOT8z2T?=
 =?us-ascii?Q?heZdGL3BgYg934QlZganWJYKqF0E2e6wnRpgP8kMB1piHBmL9FoChsiygeuB?=
 =?us-ascii?Q?LUTTstSsj/oLKMF7wnKjxy9IBbc0D6iWF5EMdn9GFnBaPiTNK2AyFpzmuDS1?=
 =?us-ascii?Q?Ff9iCYwQiwAN9l3FL3JHnzNlz2vNr8jvZwDF5CheOxxz30vV8mCRF4gTQiCa?=
 =?us-ascii?Q?hdbc07l0D0eZ+nJkvcq5jCcJ3AvCEB6nplK/ZQdIwhMt7TX+K8Lj0peX8R8Y?=
 =?us-ascii?Q?J92A0d3mKqeuC0NK8P5Ja5hEz1XcPDuz89ddeQ13/cOlcCGUZTTxvq5LGU72?=
 =?us-ascii?Q?lwkHrI2O9RH8E71yVuupUCpRzFUoTWZoq4wTbB9qpnRFaz06+jiUCjpi3P0P?=
 =?us-ascii?Q?DzbumU3LONL6kg2NQFpo49rNWq9PsSSZZ79U5HOHO6usVG66ErP/o8b3ihhd?=
 =?us-ascii?Q?7AqtggXIb1Ux/j8j5YO621n+gWFvBJ0mjw7s6Cxcv9kBrUkYQ7ZH+ujb3YPC?=
 =?us-ascii?Q?IgS0zUBbY9WnAwNIX/kdBY76n5KEQxOhPtIhWDGjrN4oz8mH9enaA9grzoOV?=
 =?us-ascii?Q?E9mGivfMwtnbB8rCVyzEsXhUHVAMscRqf7phH/ZwZ0Q7DmHe4oC3rzcxPBpO?=
 =?us-ascii?Q?SWSL4r7ZzCr+N5mJ9Dyy9t1C+1xhyY3tmJQuGyHn0EfBfg6zSzLD2qvMApv/?=
 =?us-ascii?Q?RfQ79bf/6SpKKwVEWLKwgon3bB35u7fsMnMu5+5f1qJgxqCsmZdTlUIRPAdE?=
 =?us-ascii?Q?qqv7k6oGu8v7hIE2wIQYPLx8ciIdA3lm2K3KgFfmPsCgBkR646gBB4ySE7Zv?=
 =?us-ascii?Q?h0KrTJoBuNfAFoV4D5W7565YfXg2kqqNm1SKEn1Rpbhle6+VD+kvMyVrc3vu?=
 =?us-ascii?Q?qRMfMG1mteJDItRPMOzwm0hmCQtQ9tKi3Bo4SpZj+1v/tpD7Re9PurtJ67TO?=
 =?us-ascii?Q?UftimyBLEZHJA9r5lfqYd4o/wzu7ddMScRl+2QrLMyEwQQwS+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JMu9wHpIEL8P6RY+5yRMKhgvQkwKFRL5mXUsvneiACerUCVL/xwkIhka9+bL?=
 =?us-ascii?Q?dDnxgjgKAWVZmZZVJJLhQ6kIrUT/Wycpmi+dGRV+baPC1BfgI6QhuxALU3pa?=
 =?us-ascii?Q?PHG0WRVJty/gR9PAtc1+Xj+xellN5mAzkZHq6Zzd3P7f1Bb33Eg2SN6IGndK?=
 =?us-ascii?Q?AQpGCLVtlXZieAXto4TpZL01KQlNrNm8KeEWvo08Eu/xkPsFShxsXwPfinS5?=
 =?us-ascii?Q?bV5EOkukM14sunikpTZaUCd+m29qD9kLps2c9Pr4bU9vKRtF9HAHSy2qrkhd?=
 =?us-ascii?Q?stEgSxb/HnUDonW7KcHnvx912y9XrfyQj2Ap8mFxL9u6sz0p/TkIOm0a7FPG?=
 =?us-ascii?Q?axOmpX0rZugMfK/6xHDntSMuB+z4AvwZ8RU1HY3+XltSEc1xyyLUYXD2/Bz4?=
 =?us-ascii?Q?niS3qMHCGdBZjS/d1rvXsfMLOgQyxyOEik70l8m+aH+LWO50ZpcrV7hRAAlX?=
 =?us-ascii?Q?SrJjgJBVJcmsUlg6wOjXEwXiNR83UAbH9DsVaG3sNG7G6XRXuleJgvZr0HkU?=
 =?us-ascii?Q?V5AbZCbKkJlcY8cuxN1YUsVQdKU+SXudvZ009rgohUDwehNYFA1jyS7xHyqY?=
 =?us-ascii?Q?x7W0Af6VRHoOdQjKnGSW+z9GB/FLdmYp9b0hSFXl8FmsBQHA28X8Prf1LFyO?=
 =?us-ascii?Q?otf6RW//D0pZmkdGTIFBKkrHCZWnu1pTUsngY9B/8AuClH16XuJwX4NO72cU?=
 =?us-ascii?Q?5cjg9aHM/8PMwADcScReJeeCmMgjabGftAJBhNVW4ObrtG5o17xSs0VeMM+s?=
 =?us-ascii?Q?BikGJe4sLGo0oAVn7YcZJ7pHoJywjhn8o758ayLfwo/eS1RYQWkJ6FC8iHGg?=
 =?us-ascii?Q?fSmWNrmRrgckr569ZEY62+aflFNAy7+eKdctFd7WeGz1WorKMzYkPdjvtopv?=
 =?us-ascii?Q?8xUbYxbThUuba8rU/abpprsS0OSCB14XERNvQDvhjtiEI8IbVJ7x+qOlEgwg?=
 =?us-ascii?Q?Nf6eeMI0SpFZXwimD2KlnRB4vS1Mlkxt9dXhR2e8/81ZTbrgjjJ0IQ0dp/tw?=
 =?us-ascii?Q?iz0lOfPdolvXNp6/Qm7ZbjUHxx2m4+Ge1E5YeLUpy5JgT72ZMq0V3SGS64az?=
 =?us-ascii?Q?JprbnzwcHOs365GoVHOzM3xQa133UuDPtpqNdKZrtqfGyA3+0jp+277RZp0r?=
 =?us-ascii?Q?QLuzGJY4j5lu5Bjqe6HMvMNbp15rrxozHpEPZ5GMwyhk7Y6DCJO9kHivrUnE?=
 =?us-ascii?Q?ptUVqteM02xOrc+LccYPwZ1mFt7S3731cHkX+ioBEVQt3GSwO8+KwX6lVNm3?=
 =?us-ascii?Q?K4C4IU7xuaCpzS8TXN7i3bAzYcI+KM8DMwRTD1ytTZr7KZZ2I64xZRioObA5?=
 =?us-ascii?Q?eO4CPXUl/KLZabflHEQzcSus/2O9Svf2zAl5iqnKDyl2AEo03aSjRBIeZF+k?=
 =?us-ascii?Q?eODJpLuaWmMTZ+OZaBCFq8psRTwcwYi+KrQRgnsERFEGcQ3eNa1FkSBgcrFy?=
 =?us-ascii?Q?89OGXHmkRaBm0K/jk+DX/Xwyhdzwnv574DgA54A3TeCMts0LhdAaW4a0ZuXM?=
 =?us-ascii?Q?ud1FF85uC1qv6whNUEIJ0AaewRwE/umHhCKj8jwzerQgFWKyR0SNMPIFXCSQ?=
 =?us-ascii?Q?v+oyHDpOxURvkZ7q5QSi8bkLh9UsM30zsnh/PQX6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a2cd3d-3d41-42fa-8a34-08dde5968839
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 18:21:25.2009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vt2ZdJtj+qxs3lM7kDYzYK62Dxci3K62nQFiVEC3vnM7OEQDq8NRgr1zsiocrqHW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6479

On Wed, Aug 13, 2025 at 06:25:37PM -0700, Nicolin Chen wrote:
> +typedef struct arm_smmu_invs *(*invs_fn)(struct arm_smmu_invs *old_invs,
> +					 struct arm_smmu_invs *invs);

no reason to pass in fn, this always just calls it as the last thing
so the caller can do it..

> +static struct arm_smmu_invs *arm_smmu_build_invs(
> +	struct arm_smmu_invs *old_invs, struct arm_smmu_domain *smmu_domain,
> +	struct arm_smmu_master *master, bool ats, ioasid_t ssid, invs_fn fn)
> +{
> +	const bool e2h = master->smmu->features & ARM_SMMU_FEAT_E2H;
> +	const bool nesting = smmu_domain->nest_parent;
> +	struct arm_smmu_inv *cur = master->invs->inv;
> +	size_t num_invs = 1;
> +	size_t i;
> +
> +	switch (smmu_domain->stage) {
> +	case ARM_SMMU_DOMAIN_SVA:
> +	case ARM_SMMU_DOMAIN_S1:
> +		cur->smmu = master->smmu;
> +		cur->type = INV_TYPE_S1_ASID;
> +		cur->id = smmu_domain->cd.asid;
> +		cur->size_opcode = e2h ? CMDQ_OP_TLBI_EL2_VA :
> +					 CMDQ_OP_TLBI_NH_VA;
> +		cur->nsize_opcode = e2h ? CMDQ_OP_TLBI_EL2_ASID :
> +					  CMDQ_OP_TLBI_NH_ASID;
> +		break;
> +	case ARM_SMMU_DOMAIN_S2:
> +		cur->smmu = master->smmu;
> +		cur->type = INV_TYPE_S2_VMID;
> +		cur->id = smmu_domain->s2_cfg.vmid;
> +		cur->size_opcode = CMDQ_OP_TLBI_S2_IPA;
> +		cur->nsize_opcode = CMDQ_OP_TLBI_S12_VMALL;
> +		break;
> +	default:
> +		WARN_ON(true);
> +		return old_invs;

Return ERR_PTR, it makes the error flows possibly wrong or at least over
complex to return something that shouldn't be freed.

> +	}
> +
> +	/* Range-based invalidation requires the leaf pgsize for calculation */
> +	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
> +		cur->pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
> +
> +	/* All the nested S1 ASIDs have to be flushed when S2 parent changes */
> +	if (nesting) {
> +		cur = &master->invs->inv[num_invs++];

Don't do both 'cur as an iterator' and 'num_invs as the
location'. Delete num_invs entirely and just use cur.

> +		cur->smmu = master->smmu;
> +		cur->type = INV_TYPE_S2_VMID_S1_CLEAR;
> +		cur->id = smmu_domain->s2_cfg.vmid;
> +		cur->size_opcode = CMDQ_OP_TLBI_NH_ALL;
> +		cur->nsize_opcode = CMDQ_OP_TLBI_NH_ALL;
> +	}
> +
> +	if (ats) {
> +		for (i = 0, cur++; i < master->num_streams; i++) {
> +			cur->smmu = master->smmu;
> +			/*
> +			 * If an S2 used as a nesting parent is changed we have
> +			 * no option but to completely flush the ATC.
> +			 */
> +			cur->type = nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS;
> +			cur->id = master->streams[i].id;
> +			cur->ssid = ssid;
> +			cur->size_opcode = CMDQ_OP_ATC_INV;
> +			cur->nsize_opcode = CMDQ_OP_ATC_INV;
> +		}
> +		num_invs += master->num_streams;
> +	}
> +
> +	master->invs->num_invs = num_invs;

Like this:

	master->invs->num_invs = cur - master->invs->inv;

> +static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
> +					struct arm_smmu_domain *new_smmu_domain)
> +{

How about a comment:

/*
 * During attachment the invalidation lists on the two domains are sequenced:
 *  1. old domain is invalidating master
 *  2. new and old domain are invalidating master
 *  3. new domain is invalidating master
 *
 * This uses two updated invalidation lists, one with master added to new domain
 * and one with master removed from old domain. Prepare these lists in advance
 * of changing anything. arm_smmu_asid_lock ensures that the invalidation list
 * in the domains doesn't change while we are sequencing to update it.
 */

> +	struct arm_smmu_domain *old_smmu_domain =
> +		to_smmu_domain_devices(state->old_domain);
> +	struct arm_smmu_master *master = state->master;
> +	bool blocking = false;
> +
> +	/* A re-attach case doesn't need to update invs array */
> +	if (new_smmu_domain == old_smmu_domain)
> +		return 0;
> +
> +	if (new_smmu_domain) {

This if wants a comment, it is tricky:

	/*
	 * At this point a NULL domain indicates the domain doesn't use the
	 * IOTLB, see to_smmu_domain_devices().
	 */

> +		state->new_domain_oinvs = rcu_dereference_protected(
> +			new_smmu_domain->invs,
> +			lockdep_is_held(&arm_smmu_asid_lock));
> +		state->new_domain_ninvs = arm_smmu_build_invs(
> +			state->new_domain_oinvs, new_smmu_domain, master,
> +			state->ats_enabled, state->ssid, arm_smmu_invs_add);
> +		if (IS_ERR(state->new_domain_ninvs))
> +			return PTR_ERR(state->new_domain_ninvs);
> +		state->new_domain_invs = &new_smmu_domain->invs;
> +		blocking = new_smmu_domain->domain.type == IOMMU_DOMAIN_BLOCKED;
> +	}
> +
> +	if (old_smmu_domain) {
> +		state->old_domain_oinvs = rcu_dereference_protected(
> +			old_smmu_domain->invs,
> +			lockdep_is_held(&arm_smmu_asid_lock));
> +		state->old_domain_ninvs = arm_smmu_build_invs(
> +			state->old_domain_oinvs, old_smmu_domain, master,
> +			master->ats_enabled, state->ssid, arm_smmu_invs_del);
> +		if (IS_ERR(state->old_domain_ninvs)) {

Then here, as per the last email, just get rid of invs_del and use
the scratch list master->invs for the next step. So all this goes away:

Jason
