Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C1553373;
	Thu,  1 Feb 2024 13:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706793889; cv=fail; b=Ti05d55MZWBjxEkZvwCuW38rGoyWEZ7KL2dRdaSY7meRFdDDcU6G5iXmC8q3IDTt2n6tx1UNm+h61d/rQCwJ++HXpn/hKKjAMq6ZO6zcyzT3WVFzq2TT/2kDmPDs3hF0NMiDZu57vFXIPm+Datnsh4a5He7y7+HbtKsQxruN9zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706793889; c=relaxed/simple;
	bh=nBdYzuhPlSC3mvZEuFwD4cu4jBhjGJUSD0D5nUlbB+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GtKRD3Mauj6IsrcjnH9UFrHtAQtsiB7Onqz8x2yPiMx5ME5jZ3jcVG2FMJJaLL7aeTOVkwdftvZUC8uPYtxmpjv3h8KCgTrvop1pALX0lwTJCfijn2wyIrwy8IHgAAHVB6H/QGgx4c5p9me8KtfN9txsSrZwcusIIJyKIM4VAt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YT67XPUb; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YT67XPUb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcWYq/HVxQwasmEp7xnK557RGEzBEJdjR4CsnHKxWKPtl4Ne2cj7cbDQ4ouRqY4OHtx4/Oec+Xubzc3v5Oef3UAxNMBQYMfdNIEBOqyNA6rm3gNTZBCM0tG77lKaSPBFoJwXdcI3Ex1ETuZaTt6zjpo1hPhBZGdb7wEj4QDi18bFsH/0+AI7Rq2yZuOcw8ImEbqbk/H2YjuR3xGm4i1waLCQiqFRXXiYmftNQIKsCh+y9rkgrNxa6DKSrhaNnGjeA5q26uIlxz8FAZgCjYgOR20HY8ND3MBnW+lxlxsVyixTfwPvkEPfQ9ONDu6icVmhYufApyE4MTD/PKN408Oo7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qh4rosVl3H2uo1A5VuYoe0qJIvzPmWasQXjmQF1k6SY=;
 b=Qd8wQPjX1zagCUJBvwEoLPV9Nw/sxvOyk19MM5fJqSdvgGyI4h61C26ZZ7iNqTzrmYdan1otdW1rBrX1W28drPwcmrPJKVCOudZ+QeVr5zxgVrd33LnH0o5CrjXnmA3qVRIevaq0t508w7wTF+wA93SKqIk/YYw3NEGUfqvKQK2aMjfU9QsiTbtyKvLqrsBPnNVW/daF86PTtE+wCDWY6059qZwsVIH98KUuDnqMIvjQ597gbOSa+J5Vjghq4k5w1ge+S5Rx8nLxqntRjlN065KvAyeV1bFIbfLxrZq1wYd+peRQtGdNk9hjz8GP+XxtZiGjnHKsciojbiQwglAPXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qh4rosVl3H2uo1A5VuYoe0qJIvzPmWasQXjmQF1k6SY=;
 b=YT67XPUbKWBLSjcNe3B6fIo4xyiQ45fUdjSx8LLalLeug/3h00ELzjSVEeE7OXLFD1UTaCokD8+ZpmOIhmOI4mT4WUyJ1kL2oUEEasJ8NhskaoQLbpT7vDuNcIWoQfg/zsRBvQyPwLT9gJSDheCUt1YugpIfQ+SgZuCVk0dahRZeHdmhD8l+73hPJXqaJbpkBulvp/d2udUvcnw5nsKWUg6IL2i717DoiuyNsfW2lLWAaQPyNHZvlmLbONdBFU16JEat5eldq0pH8LmDzl4AkaBovuM61PtqxyQ0RH6XMpZoR4YNexTD3/6gHm8sMQlJ6v/We5HeNEqBq28wcr9aHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB8186.namprd12.prod.outlook.com (2603:10b6:610:129::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Thu, 1 Feb
 2024 13:24:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Thu, 1 Feb 2024
 13:24:44 +0000
Date: Thu, 1 Feb 2024 09:24:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 06/16] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock
 during all of attach_dev
Message-ID: <20240201132443.GP1455070@nvidia.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <6-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZbuLeWDvhhufT7Pa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbuLeWDvhhufT7Pa@google.com>
X-ClientProxiedBy: BL0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:2d::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: df0219ff-c05f-45d3-adbf-08dc2329278c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nU56YSrVfYGu4mTld1LhLpPSLiBnMkDABaGrndBCKroLfWkBQZsBE7bzWR5O9JgygW3UT2p8Y4jERn4TYJwJMxiEB4kXsue1Ct0Wqefuyf6UVafe/1r5VF5Zier2ULei0RRVZABtrrZO1MgUo88cogsXTAnOLuh4rJJVDMJHllJN1ksMPj1SmdZ1zxW2mpDtFb/nFs1iAoXIymscaMXF9/UUsp7Gh3IntAtyv8nR0okW72R26nT6n+hWWfNQx1Ata+K5qHXGteyBh2IzPOFGcHFlK1+WIEQFtqZyqI6Vgtp6EkaRaETksbZKjseiVyGxUog5G5hKNz4KEBRNLA5PVnGpr5SBGaY8y4AgLTkEHUImiO9fmAXw52gvmf1l2EOaCxXEiYaIBL1iC0nhbNHdzIRcISZrFedU36gw0BwBoE0jrTT+gsgg+L4USU/PW7s5NvgR2Qo7ZTGvNpx1RzuXuUECapPK19tyVoehRCNVUW++hWf708NCxvBEilU8k1NfjOwCppIx5CNnyuAYX/DN9phzEA9rGyFUo7WK11xoIbh4zRIrNdtH5gqOe5I8oKQ5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(83380400001)(1076003)(2906002)(2616005)(7416002)(38100700002)(5660300002)(26005)(6486002)(66946007)(66556008)(54906003)(66476007)(6506007)(8936002)(4326008)(8676002)(6512007)(6916009)(316002)(478600001)(86362001)(36756003)(41300700001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmx4R1FkMG4zeVpkdmlDWTJ0M2c3RVhuMDB3QkV0RUZ4NFpabW9iUlVoV0hD?=
 =?utf-8?B?ZkhMRWVPZGdaNDl4ZGtOazM3SEF1UnRQaUkxbWxkUmJnbHVkcktFSHpHMUhX?=
 =?utf-8?B?cWNEbXRIam5STkN6M25RR005bUh4UlJlampTN004RU5nbldzSHhoK2RsRnlQ?=
 =?utf-8?B?VTBvdkZhTTlhOTBmemNCMysrSWxjMmZ2VlFHc3NTVktUMS94QTN5a2tXVDhx?=
 =?utf-8?B?YzA4NGQwbkc4ZWlyRkJ6YUt5MzhnVkRCckVjcXNya0lob1VkOHlNZXFRL1Jm?=
 =?utf-8?B?YjI0YzV3WDNEZVdMSWhvck5xL3NLZHpGUjR6R1dGNmxSNEhnN3o4d0tDYlBq?=
 =?utf-8?B?a2ZCZXl4NnZyb0ROK1lqdlk4U3dCK2hZeFlhMGNRTlFYQzhFYll6NXVSeW1K?=
 =?utf-8?B?SWJYaFRuNHVNMFliMzlqUDN4azIyZ0Exb2RxRENjMm1pcUJMalNlak9YVGVk?=
 =?utf-8?B?STBQSTVrR2ZJa1Q4VktwSmdNTUNBMXZIR1Qvbm1PM2U2STN3dXNwRUdSS1Ni?=
 =?utf-8?B?VmpwbUc4cGpubWFjWGNCK1pkY3lVNVlOUG5QczRQTnVKSkUraDd3YXg2ZkJK?=
 =?utf-8?B?YXdSRkVPTmd6cWZTQnJLNDNkMlIyQXowM09YeFN4c0UyNUFUYVVIcGM2ZWZl?=
 =?utf-8?B?eCtaRlpkV05LZzVrK3FWWHJYQmZQalNZd1BqQ055RStuTTdodVRYQmtobmVI?=
 =?utf-8?B?L3hCSGRZaDB2V1RsRGdDbC8xcU9MSFNwQ2xkRjlYMHo5ZzlZZC9EUVlnbENy?=
 =?utf-8?B?QVdDN0JLWFM5cDdLVUtValBQWEpmcTEyQjVtSGtLUE9mSE9TRDFpcTZhR3dy?=
 =?utf-8?B?UVhZamJPc3M3KzM4ajB6UkFZRTZtV3g4VXQxSzR6L2ZNeXZ3aFg5NFlVQXU1?=
 =?utf-8?B?Um5QWTJRRkpEUmJSYjRGN1diOURES29LSU5IcGIweUZPWG0waUthSHIwS3pP?=
 =?utf-8?B?ZlNJNU5tb3duaG5rVUFZVDlRVnFKQW81TFBvMU9rTFNLdzkxaUMrQmhzbVVu?=
 =?utf-8?B?SG1Pb3ZwYVpuaU5oUy9LeS9kMCtqUWEyeHZKS0R0VWU1MkVNeWtKZ3hpZXhV?=
 =?utf-8?B?RlNZMHRTVU1UMllsWmMydzkxanlvT0RUV2drbE9iWTdzNlNDNXNIamN4U2FU?=
 =?utf-8?B?SGs3ZU5QUFFaZFd6Z29MRW9KdnFyTzRaMzZhZjJzZmJpQ2dudXV3UzV3eXlz?=
 =?utf-8?B?MnZYU0s5djRFeHJTN0FnMVVvSE80dTYyWmRoUm5xUmxDOGVpMTNMcW9CSStG?=
 =?utf-8?B?SEtTMEtZWjAwZnhNM0NmSnpKOEV5TDhGcmNYT1kzazRndkFWMnRUNUdsT0xx?=
 =?utf-8?B?bkRiOUxwejJKVUx5YzNqcDJFY2grQmRERjRmelBkTllzd29oUS92b1JrMUVa?=
 =?utf-8?B?MGx3VVVrWWx2N3VId1h6UlVxbThLU0hPMTZOdSs5dWNEc09HRGVJMUpqVHhX?=
 =?utf-8?B?N3pQMm0rY1NVc2ZNTjkxNTlJNW5KbUZEeXJjc3M0dlowdXN2NTBJZGdpSTlS?=
 =?utf-8?B?ZlZiUTVjdlpPVDhMSFBzenF0WHdlUVNqMVNVeFQvdEVwc2FDdEczeWgwb2Ja?=
 =?utf-8?B?TVRYSlRFVHhSSVpsSDREOWM5bHh2MCtmSzRzNllVcEhnYmdvMkxzNDNkUlpu?=
 =?utf-8?B?ci9ZRDJ5N01SZ01CQ1ZhSVRkMkFMbUJ5WlVlemkzMGRuZ1pKZm1RZGE2M0pG?=
 =?utf-8?B?WFBzK0ZTWUhrM1BRVnN3YTU0WFl0U0tlakdaS0RhdDdsNUJWaWhGSkNJbmZF?=
 =?utf-8?B?SjFxZEJUdVpEQnkyZUZmSmxSSnVNeWtrY2pDTk1iREc3VDF3VTBneHFDK3Fx?=
 =?utf-8?B?YkFPekpBUThHZ0I3VXdLZFlUblNXZFdqcmU4ZHJ5YmV6NEVCenJLUlptTm05?=
 =?utf-8?B?VWcweHFHbm5zNzJpb2QwdC9Sa2w5N0JudjZQM2kyRzNVSkRwdjdrWWlOSzd1?=
 =?utf-8?B?MVZzbGxRUXJMNnJKUU5QWGFGUGJQY0lCcVd0Wm5Dd0tLNm1aTXpSemlrNlB3?=
 =?utf-8?B?bDI2bXVzbmliSGRrUGloLzhxaWk4ZjBkNXFGdXJPMGoxNVo1Uzl4QjVEdGNj?=
 =?utf-8?B?dC9WQmM3WmxSQnAzNm5mSjJ6aS9JNTNXYjF2RVIwTktXMGJqdDlYck83WkNj?=
 =?utf-8?Q?fV9BQjJjUA9Skkax2SFuJ7Ag+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0219ff-c05f-45d3-adbf-08dc2329278c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 13:24:44.4996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HreS07g61LKmd5PIemeoUNtS/0N7VZUg3WAq/s6BQaujEj1HBONdb4mouO385JOl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8186

On Thu, Feb 01, 2024 at 12:15:53PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Thu, Jan 25, 2024 at 07:57:16PM -0400, Jason Gunthorpe wrote:
> > The BTM support wants to be able to change the ASID of any smmu_domain.
> > When it goes to do this it holds the arm_smmu_asid_lock and iterates over
> > the target domain's devices list.
> > 
> > During attach of a S1 domain we must ensure that the devices list and
> > CD are in sync, otherwise we could miss CD updates or a parallel CD update
> > could push an out of date CD.
> > 
> > This is pretty complicated, and almost works today because
> > arm_smmu_detach_dev() removes the master from the linked list before
> > working on the CD entries, preventing parallel update of the CD.
> > 
> > However, it does have an issue where the CD can remain programed while the
> > domain appears to be unattached. arm_smmu_share_asid() will then not clear
> > any CD entriess and install its own CD entry with the same ASID
> > concurrently. This creates a small race window where the IOMMU can see two
> > ASIDs pointing to different translations.
> 
> I don’t see the race condition.
> 
> The current flow is as follows,
> For SVA, if the asid was used by domain_x, it will do:
> 
> lock(arm_smmu_asid_lock)
> Alloc new asid and set cd->asid.
> lock(domain_x->devices_lock)
> Write new CD with the new asid
> unlock(domain_x->devices_lock)
> unlock(arm_smmu_asid_lock)
> 
> For attach_dev (domain_y), if the device was attached to domain_z
> //Detach old domain
> lock(domain_z->devices_lock)
> Remove master from old domain
> unlock(domain_z->devices_lock)

At this moment all locks are dropped and the RID's CD entry continues
to use the ASID.

The racing BTM flow now runs and will do your above:

arm_smmu_mmu_notifier_get()
 arm_smmu_alloc_shared_cd()
  arm_smmu_share_asid():
    arm_smmu_update_ctx_desc_devices() <<- Does nothing due to list_del above
    arm_smmu_tlb_inv_asid() <<-- Woops, we are invalidating an ASID that is still in a CD!
 arm_smmu_write_ctx_desc() <<-- Install a new translation on a PASID's CD

Now the HW can observe two installed CDs using the same ASID but they
point to different translations. This is illegal.

> Clear CD

Now we remove the RID CD, but it is too late, the PASID CD is already
installed.

ASID/VMID lifecycle must be strictly contained to ensure the cache
remains coherent:

1. All programmed STE/CDs using the ASID/VMID must always point to the
   same translation

2. All references to a ASID/VMID must be removed from their STE/CDs
   before the ASID is flushed

3. The ASID/VMID must be flushed before it is assigned to a STE/CD
   with a new translation.

We solve this by requiring that the arm_smmu_asid_lock must be held
such that the smmu_domains->devices list AND the actual content of the
CD tables are always observed to be consistent.

Jason
