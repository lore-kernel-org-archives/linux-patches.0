Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8FD39FE0;
	Tue, 19 Mar 2024 18:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710873430; cv=fail; b=NpaC4xpFWJnjGVWTIYKvxNTUeifVhByEGSpMGdQ8fME0m+DhKVQ+3f/LWUHMxjLBNZrVkEU/Zj7aK9VfJz5rA2SH+D3k5p/YAufhda8JzyaOIU8YhzMLEyHvhwpN0VEP2QGHFTV1QS3qwr7QukSQh2e1yJWdoTKHgLxuVINu1JI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710873430; c=relaxed/simple;
	bh=Psi3AdHk6EOgnvYw2bM9MZ/l+vMDcsT0IQG7R9wupXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DEpKeX2ER6QSx/WX6uJ3fOKHMA2EIJ7qCW4URecHlQ9DVG1MH5NoAR9JEJdezgHHI71aeg2fVwSZXT9nWYFwwItTS+Sxe2w3S10LWxbjhrY2hpoGmRKJ6tIx8pkO5vBvWibgEtVytybf1Q3tLrBQgcqy+dofWSbMfvGn4zAXD90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZUne/VIx; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZUne/VIx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efwQRM4S9vCBINuH/jMshopGaTAW0AfJ2AFTvdWatlHEapVK6tR5ROpAW/pwHmU5ipHVmBdRyJ/FzuqWQHKugKO9Dc4g2ALdGX0O1+/0frQ3tRusHJldFYUsJ1/AYcIPPc4aDc1JhYOhlDXYwB3cVJtJgtrEuTrzQvh1W8bowOJDFbU8dDcwgT2/AYsH/T3vj4ivV+NBdZ9VEO7A1qmB5PxhfDVCHPmpwxjnG6759Jr8avSJg8Fp4P+zG92dt+vrJoxp4cfUTEwcMGbxH5I2Lhm7A4WLNGJvSiY6qXq55/bbNv1accl1c4t9BfaCKdZTnMSOl0yn4OtAnX2LB/kFlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Psi3AdHk6EOgnvYw2bM9MZ/l+vMDcsT0IQG7R9wupXE=;
 b=NnvWHedJARZvf7r1u1XJ+7ETpNrSumevyxM2FIbjCAFENPmt8xikXI5R3XCQaUK0qLTDpwEMHefZBfWnirJpgzCUOGrHIRCMsO+36k9+avZmk3yvzxraP3JEFEfeDF3VJR5OtTK6qZcTy3LsaL5dJMTFkawl14axa9Z8rTXAlnz38jj5Y7prBZU0HqNqVLxLOOgbaRK/rHGwCm5NYTtlKB9egxpXdLjAnfN27iBMdVZDqpwGFF+taReHIH5m40R1afcxibmhgV4rXtWqIlrfA89OpEEuvURD4/exNwLYlORcWWxtTMf3UoeKOlg8M8kI0UNjMehvVmDkfytjUWRsgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Psi3AdHk6EOgnvYw2bM9MZ/l+vMDcsT0IQG7R9wupXE=;
 b=ZUne/VIxiXJ3XdsGUMRjeB+T9bZKn1okssSmGZ2dsL6GWA5rkTXOx4Z7SMu3CBj7FCbWzep3XY0EPtGoQF8/aBlf/7BhJq/YYYqjv8LloJh1SMpRWRV3TbPJ+2uolsxX9THPqJHOO4DGSS2gsErBTxhdhKUsA8jC9JxQTDFh6pfebLvaAIrzIzvQTjOGb6F8/N2eSvTBL19l/D6wf6NFb93564ua2+S8Yw/FEBZ5C6/utCFQnT3i1DsGnos40oNt9V5dMMTRFhbVocBmVuIQeVl9vdhtD9ozotOtwVxiE4p+jDYL0bt2xSs10XKgOEDKNK13iuJljx6f5wajh1K1ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB7583.namprd12.prod.outlook.com (2603:10b6:8:13f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Tue, 19 Mar
 2024 18:37:03 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.025; Tue, 19 Mar 2024
 18:37:02 +0000
Date: Tue, 19 Mar 2024 15:37:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 22/27] iommu/arm-smmu-v3: Consolidate freeing the
 ASID/VMID
Message-ID: <20240319183701.GB159172@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <22-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV26RwVZXysaLDMxCsNkYB9BkkQqRBkj1-dnhBf8pO_QE5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKHBV26RwVZXysaLDMxCsNkYB9BkkQqRBkj1-dnhBf8pO_QE5w@mail.gmail.com>
X-ClientProxiedBy: DM6PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:5:190::37) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB7583:EE_
X-MS-Office365-Filtering-Correlation-Id: 249ab166-2445-463b-3e6b-08dc484391e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9vzRqVgOlP4SXriWITK6KFtQ/WNlJ3G/Nk64mvyprPvggTkgHLGVWisWLoDfYlwKIZ3BrGZqE1fP4Rh+Ol8PXaoOHYG6L8Y1BVwNlGWnXMfUPgfruN087KN/QRg5kskwHAFIMUOMigBME/Gr7lls7NujJ6LmVuyHpLgdD9mS0DUnVidRW18GHMudnJZsec89AjNsl8w5fTqyQCidY70zyVHyVNvqmck94AVspgyQANVDEiAysi+KBSH804UvqILckdsy0+sx0GZrtCUjSrll7OA5ZrpcWUZcvwWGrDShXD/8RRNFzkRfDHfwCRiCbv1SV0BR0hWYPQ8Zfwq4i/az3BCfUv4akWPyp3JoyqSgBGT2jqNvZlw0c/x9YXDfSE6Rz4awDcP/fpdxIVAsztHO5/qWR9nYb6cPYwlDv24RmeHVgjs4IobAMSSqxvEBmPzbG417c2KS9ZAANYTAQ+v0stlADdvSKttyJCdY7L8TTOVfNlkkQvcx1pyUo+j6IfXKGx1nWHn1EHldV/ncEcWQX901Cc+ELTUtSPf3VCFoc2qEdaXPBzZP6ulOlWQcgGcQHA/V6Jh1bw1LbkfLQIKreSNgyrYeJ52/+Ycb1O9yV/bzH8a/dH1tNn0QwZ9t/en1xfHK1I1TZT4VupKzQcm+hKfnFdE3bwEEdMSA0/3tbQA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWg4S2JKSTB3RVdDajVnM1BOaHd6TXpkOEE3Tzc1OFg4MUFlT3VtU0FkWjAz?=
 =?utf-8?B?UmQrU3Q3bnpCcFNYOGhWdnFrR1RseUFzK1J6aFlUUERyRjNGSUdMdG9rSVY3?=
 =?utf-8?B?YkVIUHI3cHRhZkV3M2FVQ2R6dGNoaDV3Y2FiWEVJWjY2Mklxa3lxd0NaSTM1?=
 =?utf-8?B?MEJ6a0s3b3BMS0VJNWtwa2UxNUVtQVNrVDJxRG83M0hGZ0xadGtDV2VNYkla?=
 =?utf-8?B?eU45N253dzREQ1U3NHVYRVo3d05XZUxLc2JBZmlQQTJyRW4zRzVEcmJYRS8r?=
 =?utf-8?B?cm9yWnB6dkVDWVBWWm1mbGYvdm01cmhoSk8vSUNHTldYNnYxT1NabHUrR1E4?=
 =?utf-8?B?WVY3RW9ERk5KYXB2OER4czhqdzJHUCtSclFUTFQ4czdMUXcrS1piQk5BV2x3?=
 =?utf-8?B?czNySTlqb0N6TFVjcnh1NjIrUzQvTnRONk83T25FcEgyRVM1ZlJqYUZ3eWNa?=
 =?utf-8?B?YmFuMko1TzRhbXFMY1RQMTNFOEY3TVhBQmpKencvaHBWRmFPVm0zVzF2Ym4x?=
 =?utf-8?B?WWc4MytNbVVVMGNiZHkwNk9yMFFUTERBV2tNd0Z0YzMwVjZuZ3JxSUtITFlw?=
 =?utf-8?B?NkZjcjZpTXpTc0dEcUsycU1tM0VFWnJFWlFrWG1iLzJnREVSMkkrS3d2RGV4?=
 =?utf-8?B?WVNuRDZZSTZrd0VWR3NXVC9laW5ZSmp1RzltRjY4T0JzR0NXbzI2RGIvTXpB?=
 =?utf-8?B?SExlNGlnNVRxZTBCd2RVazEva25nR1FEbnRvNCsyT3FQLzJhMDE4em90bEVo?=
 =?utf-8?B?clA5MHNyVUJkRUFPV1JpTXZVUTZIU0dsc01TWTM5OUZYYzR4NkJtcmMwaXAv?=
 =?utf-8?B?dTF5Z3oybWZJUVo1Q3F2d2t0ZXJDUVppSmRDUVJRZnVCT0wvZ052V1ZuQWN5?=
 =?utf-8?B?YkRsZ016QlI3a0hkYUJvb2FOS0ZYaUlBaWN2YVNONFluNlRlMjJaVFViM2d5?=
 =?utf-8?B?ZEFWWW5qTWhnWURuVkpxdzN5d0tJRU8zMmNxelFhUDlQL21rY0tZWVZuZk1o?=
 =?utf-8?B?U3djMjUzQVlSR2Jma0I3QkcrTkJwZ29KeE9Ub2NwazJyaG1KZENuWG8wYm9q?=
 =?utf-8?B?Q2E3UGNlUDlnNUJpMzRadXcxc3M1ZUMxNkQ5TUs2QnlQcFVMUHZrNW01WVl2?=
 =?utf-8?B?UmJHMHlONzlHNnk3RUV0SWNUU25RZmJDbHR1NE5SV2NPZVJuVEpEZTE5aHJm?=
 =?utf-8?B?aFZKdDhpeFMyVU1wOE1xNXIyR2tvWVNpTkh3VGN2VXExVW1pZDRQZWcwY1JK?=
 =?utf-8?B?TW1jdmtIcHk1WmMzVTJvM1NQV0RCSFl5L3hobFVHQkxIU2U3WUZUZmxWRkJE?=
 =?utf-8?B?QXVwdlk1dW1iUTNNTkhSSnk2S0F5OFp1bUcvL3NXOCthN0IvME15YXBrZXZu?=
 =?utf-8?B?cEpQTE5ZekJ0M2tQOUh6TC9YeDVqMjdsd3g4RHp4WHpqdkZncnM1OUJEQWla?=
 =?utf-8?B?VVhsWWJzSTg2clh0NWkxNW9kbkt5b3dyWXpGMDRhTDdjV3NxeUdhZk1jYWto?=
 =?utf-8?B?OUxzUzdVRXZtRHMyZUtPMzIvRmxYd0tyM2I1aVRKSTFDTWpqSGNEVEFweXZP?=
 =?utf-8?B?eGx0WVpRMnlIZG0vODRIZUtOVnFOb0xIV0V1WmthMjFFb08xaWxXKy93Y1BG?=
 =?utf-8?B?T1YyUVlpd05GUThldWIwUEJxS0NGRENMMDZwVjdtby9pa0x0OUt3QWFsU3Vq?=
 =?utf-8?B?VldEQkxHVmhCMVpkUkdMTDJ3WEFBcUdremdzR2N1Rmk1dU5qRlpiOFhSU3ZQ?=
 =?utf-8?B?R2g0bHY3NHp3eDViS1JNNFRmdHRvM0JjaG9MU0ZCSE02TkY5MnBLdHhKam42?=
 =?utf-8?B?Q0xrYllFRThWOEdpd2tjcGFheFVJS2JOUnJCMS9pbnF1R3c3NW1WdEkwZXR5?=
 =?utf-8?B?TXkzb3M3N1gzcVRqZ29qYStjQWc3ZWdTRE1sQnRHbUdCNnZBZ0hzVXFSdlpH?=
 =?utf-8?B?VFpoVDJ4K3VsR2dlc3NsU1VEZlZkUGxvc3BlYy9sZEhQOEwwbU9PSXBET0F4?=
 =?utf-8?B?ZjN2alBkVk5tSEFxN2IweHNvTmprU2MvSmhGTDZjTlU2cDIrV3l3UzlVM29h?=
 =?utf-8?B?ak50eU5QdVBhU1RvUXlTNnBTeEtTd2pFNndzVWpyZlcrZHVjYk5xYVdHVEU3?=
 =?utf-8?Q?QCnY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 249ab166-2445-463b-3e6b-08dc484391e3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2024 18:37:02.8829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3TeP3JKRTk5HSqaM0h/nJH8omgaN2eLqTydmUsiu5yuiUDmdFkW4acvni5SmgVo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7583

On Wed, Mar 20, 2024 at 12:44:42AM +0800, Michael Shavit wrote:
> On Tue, Mar 5, 2024 at 7:44 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > The SMMUv3 IOTLB is tagged with a VMID/ASID cache tag. Any time the
> > underlying translation is changed these need to be invalidated. At boot
> > time the IOTLB starts out empty and all cache tags are available for
> > allocation.
> >
> > When a tag is taken out of the allocator the code assumes the IOTLB
> > doesn't reference it, and immediately programs it into a STE/CD. If the
> > cache is referencing the tag then it will have stale data and IOMMU will
> > become incoherent.
> >
> > Thus, whenever an ASID/VMID is freed back to the allocator we need to know
> > that the IOTLB doesn't have any references to it. The SVA code correctly
> > had an invalidation here, but the paging code does not.
>
> Isn't that....bad?

Ah, that needed some more work I forgot to do.

The paging code hides the invalidation in the free_io_pgtable_ops()
called during domain free which calls back to
arm_smmu_tlb_inv_context().

free_io_pgtable_ops() is the only thing that calls
io_pgtable_tlb_flush_all() and thus arm_smmu_tlb_inv_context().

So we should also delete arm_smmu_tlb_inv_context() and NULL
ops.tlb_flush_all.

Then arm_smmu_domain_free_id() consistently handles the final
invalidation on all code paths instead of having it split up.

Thanks,
Jason
