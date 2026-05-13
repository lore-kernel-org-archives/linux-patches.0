Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FBC25B098;
	Wed, 13 May 2026 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685534; cv=fail; b=GpNIMPhbmNJzAgt8UQxmm0/HeJQTQKroyJxBY2hfvYQOCDgrtU+OG7Dexg0lznUJji1nZLdQ73yzQfAh0TQJOYJmdrUZziABG5dQ9DnNoflSd2MSMnztC7L0tbng5XhfGSjo6FcdZmeG1GBSpur+qpO1FDq6ncBQqS4RaFSlVu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685534; c=relaxed/simple;
	bh=shiwBhd8O4RjeA81XUHIEum68Q9Etvtheec5VdYTw+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pxz1+BwisKMm+P/oZjNAjm9tnxIMa7xPsjirYLuh8ZaiwprW4h5fk5/CTOqilAtrAetOpvJ9a7HDxpBZduBrhNsAPvl+P35l7MiGlKUFucsWbjBctZzOJ7vayrEMqlc7z/7fVGHY6bo7QpDWApzF5nj+DOEJP8Krt5MHhxwuunw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ym3tPGL5; arc=fail smtp.client-ip=40.93.196.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ym3tPGL5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/zsMFO3rZNepVySzX27B0bK/eT9zZp+AR+Oisc9Mw6uRBiOuyhMFPVIRc+VVy5S3f/yK/LGp+AmERZZblRvK8R6iQN2kMXR1DREdVeo/jEN0LNXOG3BuiRY8mza3EnqbLEQYitQT1MJPSdxIcbLzs+bVvAM2+W/QxSLX//KLUSBn0zpCIvxkUTLfPpWHUjuX0PM3lcve02O3oKxzclsPW+ibBJwr1hqfHFxqDoUauurOGCjSi36gKL+JuyePVLOfdspHWeNQbqbwTZvngXuF/zeWGa3AGFCRF8s3G8eTLo5UsiI1u9mPTC5BG1OsHKvLoNGysmMfAETwFTg90FAow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bkk0uKyHTKJeSVlHhG2p+picVmGAnkWT0OOfxTh4ZmQ=;
 b=Ddjb3mGUTVl2Wm3f/3D2b+P/sZ9y/DYrBBecndIIfaDgTl1EbwgNkBqlnJ4dDsyJq7vcZmJjxbGEp3SIvbSpjPezQ70KjbqMrTKZZ5TZVmdGSTHh4106kFG5tCyGDcit5gOfU1C7qT81iMednZNj7baqyvY/iEhuS2870Cq2wAXXxglwiWqRq67GmMAMedIdb85sww3isgt3FjOcMtPRxekU932a4WlqFS5C84Gn2GdjZXAsTIqXbSEIGBGt7iV2iHggcV6cxBTV4Yce7I5dN/iaY3OkA04PtPsTd7xyruI3TbZgmRzAZWF8Zj5W3vLuBulUYo9FUK2eqEE6UmyT3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bkk0uKyHTKJeSVlHhG2p+picVmGAnkWT0OOfxTh4ZmQ=;
 b=Ym3tPGL5X68fA00Iis8AYGT4Uwrvd2AAzkOUJtEqR4HiluMfbywoK49Q4e/I1mA/95nLQ3u+qROjLTs4K98X5iSIQXoVMgXrHcZ8o8KtjFytJDmOX67TmVO3e5ps/+h1UQsYBWmCcqH80fmHb2svdGcF3C5Z57vtgPXQEY3fWlfO5Fn/86BOjuIC8q5A/oQKgUf5s6dy5xUakwHMALdQICr93Msule7HuN49cDxERE0o0wjG3YKApn6dckKuPRwI05s8Sm2TSDEStWTu/ZHK+gvHkPAO0ACJLvZlaRJ9XclSibcgGJI0hr//ZzXlckCu22hs1qXKW/Pb7EhmHiPY+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB9059.namprd12.prod.outlook.com (2603:10b6:8:c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.21; Wed, 13 May
 2026 15:18:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 15:18:47 +0000
Date: Wed, 13 May 2026 12:18:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 3/5] iommu: Handle unmap error when iommu_debug is
 enabled
Message-ID: <20260513151846.GB787748@nvidia.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <3-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <agSVJeBx849TqOBM@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agSVJeBx849TqOBM@google.com>
X-ClientProxiedBy: DS7PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB9059:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bb67dbe-3ed1-47ff-b086-08deb102ee06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|18002099003|11063799003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XSQ/mPU9QrYctEhvUANQjEKfG2cVfAEauCMBBd4Bi3WpvauQupumlpdeDIuSniKTjmcouaPstTsZY0Usr4lIUJ5Lkb9mX9V2pgMds6jaSJduNRLjqiipm7mBZvQbSWVabUDHpgfjVLCEllWwXIJKuxfAIsqUSXiBCWlhguYwABff1KbmYyoE2Pxw5un6cakz8Ce8v9/zISak1L783rqGkY+oPQVydJBy12vRMzHuBNQz/SEQgrciMhNwCPtUWwIsod99oc7p6106MBYP2E5Jv0r3EaA5JeTQ9VvA1X1869iyTCmSPGa47TKxDrJQstBhgRFJfrt4giyNBM5eG6+VU+R3nT/rizV4OgYybjK+4hC/amV2TZKpafYu+tC/CVE0JBYHKygVjBF9wV96DJw9sLpAt8cLqVgGp5Ysyt0uR75uqMBs3ipttCaOwgSyrLNBXtp7IkQMkeAh6TgxkX0V+rcgD3EI+U2ajbGC2i6Jy8VrVDudQj3zE1Vo9l9PTpWbS34mq1Fer50Yn10MGrUgRv5CO/SytsyF/yoxtcv+59WhJxchEBCswTgwCT+UJz0TBqb2JWQ4MFKxIWjcOR0q1jvA72XKPzg/6XfNME7MPioyXIG/mY2ChpFhl+2UGKFdDll9ahrCQaCX2zpU8RKzfc/bbUXK+2EdpLsi6PQcOW7irz+1IQ4OsbiI9CVfL8BE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(18002099003)(11063799003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kSOeBSNH8d2RcCfGs/8tOjVlcx8JqJ/IIrUiC679x8qvSLHdOEcvDL5oIaj9?=
 =?us-ascii?Q?NKjqocRyI0yTaado+0VTSMkbDt+hJgIa7+iaLmvHZU4foD39K/Ngea1nUhfF?=
 =?us-ascii?Q?HPP6Ay4uHAqy/Y5WHh/42coucfqvVhxNyb95RH56JHsv625cdxfhJtRRyBC1?=
 =?us-ascii?Q?Kfl2VmUDppi3brZyW922RRaf1UUjo0SqzdtVEOsTVJaRD6jlgYw8x68eP77y?=
 =?us-ascii?Q?fGM1H8hm6680yoPNZBpWk5dMIaVBPfVkCt8LQtRqsyLt/K1KH5+TapHRCno7?=
 =?us-ascii?Q?2X1Ry/C7vb0mDs/6UJuETHtTBFZRZ9voNuolwVRuEuJ5B7FUOqouNL0elbZT?=
 =?us-ascii?Q?SoP00uDgOitOMaYxLy5dCsZ8cYyu8lIPyQs6PtDh+TpIbjd3T/mB58rpHmHi?=
 =?us-ascii?Q?jxM4OovHTlrFdhqbnk81tqxtwPhLNq9qXWNhlWgR/NAMPjhfV2XxZbXGgXa3?=
 =?us-ascii?Q?1H8R3wABJOC52ClVESKhFSzX/1jKyIKoKERUosJZJYL/lzomteUiFaYetDL4?=
 =?us-ascii?Q?8kynedwbqd0ASDHwFMwQpm5spnUs7HrVIU5FGyMs1d7ADFfAfw2nwu+tN0FF?=
 =?us-ascii?Q?GC4+VoUaO79gopDS/RrZh0ihcXp2LSSwdGhTdk7bHrFY+fd4ragg10ALeRuJ?=
 =?us-ascii?Q?l8kVEGe9zKAvqaQ4iHio7uxfIEy41Mmgu8eYPVrTAKol5pAtkd9aTskVrwEa?=
 =?us-ascii?Q?DZpmXV0CKu50UpykdTN8Q8v+OfJxoTOQPFxDkm7Y+XtaJYQee9+9tkef2K1N?=
 =?us-ascii?Q?ZIJbsTza/kfZqQ7rAVmYpCYweWHURuZyFBrZUOM2l34amQpEXngrgbC9W78t?=
 =?us-ascii?Q?Ck2gAqHtSUOESW8n6N4pYp6pdt/sgX/JxZHBarGU3UEKIjQuBJqJaNiYW26Y?=
 =?us-ascii?Q?5w6AWksxr8ADxybDoP6EMS/99KIqVkpxK18FiAuy+ZozLArv2g+XwrVwkjcQ?=
 =?us-ascii?Q?D3t8AnUkNiXy9BUzwk9qdLO0bHjbMZgOBIr9Z7m18TngnnF6Sgh9G9cL89r9?=
 =?us-ascii?Q?ToQjPbE67eVNfTrEKckp4SamnC1lazLzWMQzdQrT55+mIOFIp5cglGPDaugR?=
 =?us-ascii?Q?CmSsbvB1EcLzaH9iBn1vtVoqgcK+YQAv6V7PUTal2OuIoOZ1X+5aFmhM0ILF?=
 =?us-ascii?Q?wbdRtGe1YgfbxCkNVDQULvsZh0u5Tz01ny9lsFjRBEGiuoFimpjD/Q4CjP+x?=
 =?us-ascii?Q?N+udpLVO7ywFeUPirTAznJgOkPwROfPSq5E8FTmmmXmf2SfSd3CmDBG2O50B?=
 =?us-ascii?Q?A9U/9WBL5jkVGecnMBeqNKejPjbWNTFL4NUfddhHu1GJ9johhY/IPyUKkRNx?=
 =?us-ascii?Q?Yu0lwS9roNGQCcG+/FADHjEGuQEpbaWj1UKpKTAcgtz+ii2uaCRUkCV0/5ax?=
 =?us-ascii?Q?DEYMbZVOl5/Gu/SpvwhxFD6DwyA5CDKQ3567MwnlrnLmqegpausiI6GJ1QWj?=
 =?us-ascii?Q?/icGfqIZ1+/fUaiH3Q00fANtDyQhQ7CJh8Y5atdFaFivFQWgGy5kglYvvU8x?=
 =?us-ascii?Q?LmE1hgyUQkwCv/BKrlb/hmf/Bzo7T7jA5AuzNScDWbMxhafXH1fz1+wWCTIm?=
 =?us-ascii?Q?44Cf6ZmTLVzc7DKTx+AJ1FHpepwvH9iyQyysF3PRgroM53dtwnAR4oSyBi2p?=
 =?us-ascii?Q?3xbGbfVC3zp1rzLsU8/pxohlc0sbDqNx/p5WAx5yv87dZYpunWiR1sxZKC4b?=
 =?us-ascii?Q?6dSC6w4HalkF0Zj1QmrNZIwsrhVbhZ9AeqjcCGjntuQuU9/3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb67dbe-3ed1-47ff-b086-08deb102ee06
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 15:18:47.5598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqeIl67Auq+Zfj9tOCbEEd1za4yrHKVHzR3RTbXXXuWp3NVujyaHeS9gCN5tw5or
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9059

On Wed, May 13, 2026 at 03:13:41PM +0000, Mostafa Saleh wrote:
> On Tue, May 12, 2026 at 01:46:15PM -0300, Jason Gunthorpe wrote:
> > Sashiko noticed a latent bug where the map error flow called iommu_unmap()
> > which calls iommu_debug_unmap_begin()/iommu_debug_unmap_end() however
> > since this is an error path the map flow never actually established the
> > original iommu_debug_map() it will malfunction.
> > 
> > Lift the unmap error handling into iommu_map_nosync() and reorder it so
> > the trace_map()/iommu_debug_map() records the partial mapping and then
> > immediately unmaps it. This avoid creating the unbalanced tracking and
> > provides saner tracing instead of a unmap unmatched to any map.
> 
> There is usually littel coverage in such paths, I have been thinking
> of creating some test-suites on the IOMMU and io-pgtable/SMMUv3 level
> to cover some of the failure cases and some of the tricky page table
> operations, the problem is that there are many things to cover (starting
> from the crashes/logical issues till TLB invalidation correctness of
> some operations).

I think the existing kunit for iommupt would have caught this if it is run
with the debug option. I didn't test the io-pgtable stuff but I'm
working on removing more of that..

Jason
