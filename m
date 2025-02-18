Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAE71C84DA;
	Tue, 18 Feb 2025 20:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739908881; cv=fail; b=Ausgpway/o4WlJIhK1htI2wYSnVEcV3c7HOKERf4HioeXhjZVSCUzyD1+fJzMCq/Xthur1BcgC3P6FfWcA0bPUEbe3IttA0rFi7FNlmQvae55Clq8zVf8LSNkqMp1DTNloqKS3iZbVXyae+AjkUL+hxJl0/c/7d1YgZ0IhN4m0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739908881; c=relaxed/simple;
	bh=LnzpSOQLZ8oQNEWih9RTUIoI3D9V/QDSPzTa2kE3BqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bvqrI6cQi8YbRq7ti/sq+1JjSwO00huakDCqGRn7i0iID7/eSbs4oZx8Sd6wl7zpw7BaufPU4pWQigADdfJRPNv7vajlcuf2luykhQ10w3G83xSIvsvYFDMrkeMr4FyUA0mJOiB0VJ9Mahx10rJU/KQaUh/i4FV6F0K+pDTy/A4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FBRDBGVm; arc=fail smtp.client-ip=40.107.95.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FBRDBGVm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fp0euKN4/2i9/WrmfreN66w9us6E7o+m412Jo7Ve39mWuNKXTKpFVPUMuzLpceGO3aZDU0J/nOYECl3dhsRVGqd8Q/Pt8TTSksd4ZC68k+C58/ocOY0bLcdqR5lC/uuXKtq2THn/74h2i0fgNHnK+CTeOqMPmTeSNkYgZHyKbtyr1RTfDB9cgeCAsoVXY+M5oug7RPkae4g6EPjgJRbG+Hg9fer4M1QLvus4OByoJZVAKEgONIHGxEWLrxkE276tgbTOPxwjBfEGbn+P+aSl03FZFQt6gLi/g4CWELcUBKyrZ3LQqFyIoeNHbGtK+D9Ze59wkr5XlFw7xSH38FUf4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/70i39Y/UfdYSza4yMPmBsI3S+RFRUGwAKa+8WCG20=;
 b=GCK8JTQf0DkX3JgIMMDYJr9wkco366pdSmqHP+2MF+Nano2e6iNkOnNZpPNr36QuARh0ve2bpJHQrHrd/mNX9AJc/8SOeJJinhXc4r3mr8Q2CubNzwETkwx0Vb7caHkVOSYfsq2regn38zBoPEnf/UsAdIbsKCEk4fltQQEEiNGGYf2o8PjLwwBWKrq/Z8WHgF/PstF4kjRpstAGPsZw0BoDQbIIa8RDGGihQZsMwcE4LbLXuVJwuCjx9nGE4A9fE/RmxGMbSYfKYFUV1n8JZyshfciv5KGYWG2Er22IGYQrGSFpHtY6zzrNrWhGUIJ1gC7Q5a1RHNBZ8jGuixIWow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/70i39Y/UfdYSza4yMPmBsI3S+RFRUGwAKa+8WCG20=;
 b=FBRDBGVmt3qEWn8n2L8ItwIWw3cAq6s6l5jZAVYEZ7WYC4f5Lo57ym91MkzLN61CjeBbmAGLyVC4H5WE7MNkTZU3WUVETbOWJv+9UGBDcncqZ2g0fM0fhaPQggxK2h2y4NIZE2mLhILSFzGuUFxXDLYZaUOsbMYj0Ic2sJ/xLNuZ7+5kxrcvw2gANs+iJ14APwfgiPwtV4hqLb6FnC4izCepL5Qhdf7N+Kr9/2tMKV5UhQXQ1C/y4HouW5kX3ZDJaTx3KvlUl6fe/s3h8rtrulXZ3BaGCo+ANlKiRNxJZtgMQ0i8vR7yEGOjaEsswuLOdelT1+iaWt97z2UpfGsmUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.20; Tue, 18 Feb
 2025 20:01:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8445.019; Tue, 18 Feb 2025
 20:01:17 +0000
Date: Tue, 18 Feb 2025 16:01:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: jacob.pan@linux.microsoft.com,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	"zhangyu1@microsoft.com" <zhangyu1@microsoft.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250218200116.GH4183890@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <20250212214723.1ebf173e@DESKTOP-0403QTC.>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212214723.1ebf173e@DESKTOP-0403QTC.>
X-ClientProxiedBy: BN9PR03CA0585.namprd03.prod.outlook.com
 (2603:10b6:408:10d::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA0PR12MB4461:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c1c3647-bb06-4d93-13ee-08dd5057012d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sdvisHQ3NhPsoU0k+o3bPtdd7qedypixtiH8OAQGUbON6yxDcgLbXpu2H8PD?=
 =?us-ascii?Q?p1Zm0UMWNyskWHyfzEJRSRuu4moR1xhmCrtP7OZE0tLMH/AWkPY8UEXfDlh+?=
 =?us-ascii?Q?+TxVvCdGXPbpbsqR9FqUbQ0qu9OWj/24owizft6b7OLgYYjUa4/vRJ9R1R7U?=
 =?us-ascii?Q?QQGuEAPEyKQ5khZy96Iq0C/wp6w1YYt8SMXc5Kpr1cbqtEkyLGygbZh7wRGb?=
 =?us-ascii?Q?eCMpwsUW0DuXmYd/g03Kc0sjGEkMUotNRle5HpYAvSr4uTLSpRrgBqHL6q0L?=
 =?us-ascii?Q?/o7LSZP0t+UAAfL8aElueOT+9AStle2bJ/QWbFpdao4raXELM/Ist3eyxnle?=
 =?us-ascii?Q?CeIlNlRmICwjpf3yuL6w+AWcrfM5ILoFze9U9j2+w3TNaHvvCe9nJ6dN+yBQ?=
 =?us-ascii?Q?wn5MiJP7iUUKpQcZIcbncPn+06JH8pYfLSWLfqhc2B4IetyB0DMUXD/kUFLs?=
 =?us-ascii?Q?ly0iE4Ublbet/GQHymsPk/1N4fpiBBZvlXbF9N8sSSGRTcgJby2HZitQTrR4?=
 =?us-ascii?Q?ZgVsR7zGiRNQJld+EDWKnUsENn9lD0EOtpqie0VAO+li29sax40BLp6WZ6dj?=
 =?us-ascii?Q?AFXXNxIhFGGxm/JeYbVy7UpABCuMgHV3cDNFjNEO9ft3twqSxv02DEMA8lq8?=
 =?us-ascii?Q?r1mRA3X7kp3P6pvSEQFD1rORKb8DOZHAcOcj8BHXdLeQDeG2WMP6uh1wgtD6?=
 =?us-ascii?Q?lgplyKkVbGKFvpnxacmfl6vC+JKLsq9GVbC2Zz92Q4e9S/fnEXqs/ntg/01R?=
 =?us-ascii?Q?sGAAdfLysvF4Kf+dsBmgFtgtDd1YqD2YUWeVuzO1LVcMw6+EuWlvYxm6UtP1?=
 =?us-ascii?Q?nVt1iTDVOGRfA/dpw6TU8jTwJK9FBSMGPaGUeIzjKLisrci6nKUizioVyF2t?=
 =?us-ascii?Q?/UPprBfHhrUm7YxJkJAccH7oLhYdaYMi0b9efSxj7brBoAQkX74LXlc4XbJA?=
 =?us-ascii?Q?HGTQMijP73RSVaB25iUWAX5qEoNTA4f+1DFcqJc+h7vP/LN35j+hcRMatyO3?=
 =?us-ascii?Q?bU40lHUDu9TDBFtWxZ+164yUhdPktR/iM3b/rSAOcqwLAZiAeYZPztSFvFI8?=
 =?us-ascii?Q?6zffu/23/5TO5oRNyrd05BG/gI79tev6hxgJIPJ+v5ipVJGoAtXLas7bNOIY?=
 =?us-ascii?Q?cfGw/Txb6MU7yUttFhxH8S8YI5wUtRUO0G1z9QIH1VIU5DszXdxnZrbhf6OS?=
 =?us-ascii?Q?5LhmGFWJ7pPfJoPaHR/KETcJ5/aHTC6F/DqDjE+9U5YsLBUJxCLkEJU+6ybV?=
 =?us-ascii?Q?Tw8A6Mdwl9+RPNxzaC68t/d3hSGxeLNHNRQSlNP4yL1bp3xkgYI/IL7cacpe?=
 =?us-ascii?Q?6OYuyxtt/7hqL/Ha5uSl7VDb10i/l8PKvPt4f3hP1HxWZ1bK4qeyc+wl6uQ2?=
 =?us-ascii?Q?MYry8SkEl406sZzzOaOstA4An2C/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WUiJoZ9ORSN9J/qA+QtYYmwxrFlrzVvgXhlAdvhT+6KXhja0OYBZB0+AUtDW?=
 =?us-ascii?Q?dDzT+3kg1Zx52aLD8/cjVQHsOrwzW1VTOYl6G+2sKRlMg4QGl18On/jvoiZz?=
 =?us-ascii?Q?0790/vCicn7i7Ct72vzbzkgUaKBPkcejBTDuBkmWzkyOCgz+rZjoEC5fgmMa?=
 =?us-ascii?Q?gjsI2xTxj2GP5nbSBCpyNXQ2GNYTsDZDnYZf6GpmVn/OWjGPAw1JGnQ7ZE9U?=
 =?us-ascii?Q?2WyAQ0GeJ28btO+95fp0iOtyURpbJspmytkCkEPxVvRrrU0dEdw3kWf7msq1?=
 =?us-ascii?Q?W1L+JaitFuw3YQBFwhctAEMyZeEdqrTDpR3EBqotx+qwlNOY4Owr+qVtsCyE?=
 =?us-ascii?Q?/Whkzqd5GEgmZSNA4kNGvdrKYShJqeFHkx4NtUCIvDGFpzFcZ5bQaZzM1y2/?=
 =?us-ascii?Q?rLE+oLv2Y8+Hyp+jF6JpJR7dumUb4WAS2NK8zeldEwAJKz7JaWv8O9pRRH2/?=
 =?us-ascii?Q?WUQ3CAQkiq+EpJ9E9YbyyWwzeBJLpHpT300KLXV4JpjzADukwgEMfPkV8aA5?=
 =?us-ascii?Q?4u4humtm1T55+HCqtzB1B41gyAKzKZ46+EEKb1o6nEFJwdIBiHE/QLlUKJRp?=
 =?us-ascii?Q?W3P7U80asytizJkl+7+oM6AG+vlc2Th32IVar+y28Pg73KoS8aBKKZMpgMsa?=
 =?us-ascii?Q?pOMnaAVsrZjoyFlLonhKT+tyutQU1Pn99SC/HufbheLsme5Htz5Ch+Obq3Fr?=
 =?us-ascii?Q?IkpAG8N02glcARDMt7BnhwZKjdqBfGWz+fu7S5sJiWtB1Fv2kYSV1ExujsFX?=
 =?us-ascii?Q?vCfHH9b55BvXGTwlq0SqcIezVHWmif9rOIJkiPvDtnWB20zMq+YF9cPcU6ON?=
 =?us-ascii?Q?rgi8q4rnYcX3qfKurb3gVw6yk9aSFPfO3h5KGe5g83ZydKAH0mjU29xpkyA5?=
 =?us-ascii?Q?iZSpGvmhd9+sFfpWGuh2vlfgx2AhNTlQ5FjbhFY40oREClG6Zcks1LUZ7n/l?=
 =?us-ascii?Q?NVHtQwD6zgUvdllzhF4SvAN+IGfOZlsPSEvjHaydHRRkBNcUgNk7cCj53iPZ?=
 =?us-ascii?Q?8zZb8IWydL1PhzUrfmqZ3EFxXoEN57Ark5tmAevzUEV691XrSZW/tqibTXBV?=
 =?us-ascii?Q?+UkMv5ZRTY8pvs7Z4+CNLZgfQwMvf6XaSIs6GGPyhvhoBeJttfPuI8WwYlXo?=
 =?us-ascii?Q?ri7eJ9FxnG5GVrnRtzUzDJKMTcEuUwUmcCvR14MbRiWZPBeomgNZIARSC3FD?=
 =?us-ascii?Q?dpZBlRVakttC1UhdYT7gLhpbd/wEcCEE+XDgZTTmaj0S85KBIJ301lrL09/s?=
 =?us-ascii?Q?4uKK4pFxAiyDrAfR44B9gmSEa50r7BiThqwmMR8/XOGWnb4tocROqhT5rZpQ?=
 =?us-ascii?Q?7Eqf+8sLxQjZ5/sp4vaWDgRZrsBVkM37QBFQJmXtcD1XMRUASk7PPLpIQUDJ?=
 =?us-ascii?Q?Dvxz3y3PlhKTVp3EdqM8ueMB4XtpD9S2Jgzbzp0i9Zf3jm38RyA978yChJtB?=
 =?us-ascii?Q?PIBg016a/0ZKmHcFFd4Ch8ZApyvT7Wc2T6uPmVDT/7qOnJv9kmtPkuLm3cXR?=
 =?us-ascii?Q?WSQTGDNIcqCoa49Pw2/zB79TrfCEzMLVySN+vQaNkbEID0rp/OCBohl3iHqQ?=
 =?us-ascii?Q?Me+dna1vlkhfC/IJrsbM6oLBgeZcgzcCrVfDLImz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1c3647-bb06-4d93-13ee-08dd5057012d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 20:01:16.9922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZgrnTx9yj9DVwgWd8y9qOjZv+7MSXYitCdUv0XiViu/wff3vde4/mF+yQ9eFIiY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461

On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
> Hi Jason,
> 
> On Wed, 12 Feb 2025 19:30:53 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Feb 12, 2025 at 11:22:35AM -0800, Jacob Pan wrote:
> > 
> > > Do you foresee the implementation can leverage your generic iommu_pt
> > > work? i.e. for building guest IO page tables. It will add a new
> > > flavor (page table based in addition to map/unmap) to
> > > viommu_domain_alloc_paging() i think.  
> > 
> > Yes I do, I think it should be no problem and it will bring the
> > missing x86 formats that are currently not available in iopgtbl
> > wrappers.
> I guess the missing x86 formats are AMDv2 and VT-d S1?

Those are the same thing :)

> It would be great if you could help adding/accommodating such usage to
> the generic iommu_pt. I think it will be a subset of features as
> intended for iommufd. I.e. map/unmap operation.

Yeah it should be no problem. hyperv handling the invalidation queue
in its own way should not effect the logic that drives the page table.

Jason
