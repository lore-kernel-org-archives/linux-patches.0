Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8705018C930;
	Thu,  9 Jan 2025 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443054; cv=fail; b=AI3hjjmRyuI6ZM9d+y0e3gPEVm3LFyvtFrAc0ZUwqbpanUn6U6sTQRHEhLXJEJn/jBUk2X3gXiPyA/LGfmtkHDcRbliJvmKWfftW0TR4shpQ7DVknx1qiBDdctO2o17T4Btae9vIF129J4kFUavCUfzwXXjtkM+3j4kyGwet8ow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443054; c=relaxed/simple;
	bh=90FKCefiN11CIMfTwJQUINU/LIdHCK6Ojf8PstXqVG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PrOhkzwZ01cPcscgbu2sdBlgfDh+dS8Mp0LVXYOC3ag3kY4tibEwi9bSvdr3xZgpgW/CMD2Z3h6JGdQHntD8n331lo8bc4eBU8uYzbVMQDAcwMI63MrAhFVWpyQ6JLRnuJAi9+dpEsUrI+/H0DV2X4ftAXc2pWEbVflrQQDpwpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JCR9CAzW; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JCR9CAzW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rpJns/J+sjeH/AAENc/HPSc9487/CCdELheBo9HISeDhz6SDSvf0WslgLiCZQYrKuCIy1YFXgigGckTg9m1hVzbscy0HFD1nJWhvj+/2KL+9VJg8wW7gyr2oHu4+nsSa//S+BZqe0dv8x5yq032hVV1SbOU10kRQ6XI1j2a8KQesxpCCoMnVPsBcnU7KiDKXZTRIWTL8WnG47mQWgSKOxeNEM5KsLQLfoE68S8ptrsauv3N/EIJDA6gSBgLWiWJS5WmxPehsdZizXVzfT7RigjnFGceSDJVKOTdEWZqkkjz5By+UAgyVqkLCsgoieB5IOM+ai4MDFWxgQ9jjVYtf+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqpJLIQ0AGfurKTzV0hdqbrMPZxZEU5u15HKOUJ9fzY=;
 b=w8hQwc7sPdREPnmLVpJIpd5I06JcNdDz+JKE3fYF3LFWs5TOIWPtxImfwO9DQIi0O3ZDruaEtKQDz8Xf/ewTRBIli4iUDljReXDc+KcwLNOerbehCCmPNRY9bb/7Ck5liqUUdxvO0okHMU9ILLhfWEfgCpEaVkK1tQTKUO0xbzBX6Qd3dXPusP4cHsswtg0mMuaoV06Fs+PRgrq5y4wjPvGz1AwlbYecUi7nWkgbkdCRUv8dEWzIwtFUidfJ0BXio8YU5zt1J9GUjm8tYabWml2ppUJMtwbYzJuL1pgNOHZiHTud2F6G9GfJSPKxlYUK8FiudG9n28CQpQYA8LdNjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqpJLIQ0AGfurKTzV0hdqbrMPZxZEU5u15HKOUJ9fzY=;
 b=JCR9CAzW5xoZpKNPOZIP5bRWiOBEjvnGyhhfxA9UplOREDKbKCPvjGTV9Di4ggEfYULuWgkrZJMBp8ey6RtHaNCXhRcNoJGJ/5mHVk4HC6rzbjYM2R/bff7DMgpNc7n1AJ7FaRNNQIJiPX68ZLLx0mXXrv8w/bFO+MFbwODpdpqw4CtVVbo7U4fPHdwxSKg2zW2YjtPAG+2ppjq/CUIYWbqG0oS7Fd+QVu+X5rAL7UNM8I+IY3kDwNxuhgY4TOo2tJCBbseL1eRtIyszPJB075rSEyjFdrqo/t05fZLpMMpi+Ae+CcFBeFpTLaMyOx2kKabP7RA1txRRXJJ1UCUAVQ==
Received: from DM4PR12MB6640.namprd12.prod.outlook.com (2603:10b6:8:8f::15) by
 SJ0PR12MB6902.namprd12.prod.outlook.com (2603:10b6:a03:484::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.11; Thu, 9 Jan 2025 17:17:29 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6640.namprd12.prod.outlook.com (2603:10b6:8:8f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Thu, 9 Jan
 2025 17:17:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Thu, 9 Jan 2025
 17:17:27 +0000
Date: Thu, 9 Jan 2025 13:17:26 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 7/7] iommu/amd: Fully decode all combinations of
 alloc_paging_flags
Message-ID: <20250109171726.GA396083@nvidia.com>
References: <7-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
 <f8b228c7-ca79-469e-9266-985255a227b4@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8b228c7-ca79-469e-9266-985255a227b4@amd.com>
X-ClientProxiedBy: BL1PR13CA0396.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DM4PR12MB6640:EE_|SJ0PR12MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: 76ac048e-7e33-428f-8c5e-08dd30d17d97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NJ+NSwpbkJ3YnEC9e716GSpq74lQwUYA9DQB/mNpDzXkioct8GPAS7EEZPgw?=
 =?us-ascii?Q?tuCFqToo7ILmDV/nwh07v34amNt/7qMWGES8e+/ooiLwA5J1O2IIbxMVdPHN?=
 =?us-ascii?Q?+GGwh8V/HC0ImPDkRPYTBk4kpL0ezHlJE8Xj98IhTeEJGc5ILGKNGZaHkf+R?=
 =?us-ascii?Q?8LlZLjnT5YzqoP3b7rfNJBlwdye5kVWtx27dI0omcItY9pGo7vfwo2GRyTSC?=
 =?us-ascii?Q?TdHai/LPtmRmxq5mKpLvu6o9ebruRTpaW47LWO72luhw88qcRjdv2ZzqxuhA?=
 =?us-ascii?Q?Mi2X0/5SxSWUtE2ZuUbLNJDvXdPMNPQ+nIIv+UZ6GTOQK67XlTaClAEG/NMJ?=
 =?us-ascii?Q?19QTs49407enu6xdzk3MQLCC5I1+wtLcKyrGxDH341OobLTKFh8frcsMtIUp?=
 =?us-ascii?Q?0Bs3sGkmSpm63eG9blTyxpSs38dm+qDiJpVqR1PigSlCClrv0qjuuLrYYi+W?=
 =?us-ascii?Q?IAO6jKMf1+8ME6pzA+l9A91DVUV67BgpgyafT3vmUa3f1qtO0s3L7A5fCt9H?=
 =?us-ascii?Q?MNg/mYZJQ4zc4BBo7I4nBi9tUUc/7KoEDON+ZtyCT4H5iRjtZq2ya+X8R+aL?=
 =?us-ascii?Q?SJGvXzF9J5ULMKg3f3ab4nc+IDcO9HzSxbSofeJjWpvGhK/3l4ZtY4JbqQGR?=
 =?us-ascii?Q?o0hjr8yPXzWT3c0ywuk0qKNrKIOhgcxr7f+z8iqaFoCxHc1qb+3YNvYDmEgI?=
 =?us-ascii?Q?TT2RWgDkLft3aSjFA05ZgIDyT/aw0yJ5eR/MQ/5kiBuUzv0td8Pv8qmeao8N?=
 =?us-ascii?Q?30HPeuKeJt6liz4Rp9SBqWnnEzB4a9F5nhzf/QS3RvCNpMVOQtRJ0Xf3eBaG?=
 =?us-ascii?Q?GCNcynuOvSjrKPpZnWxdXBh+JqSsTIOJkyUJKYdmPZP+diPnM5qThO1NcnLo?=
 =?us-ascii?Q?va9/rrl3dIBNHlMFlgkSTzbki53whPFCiFU9Qqs0H53mo9kmAXs6OBdZDMIA?=
 =?us-ascii?Q?ixT4SuOefag7I5WEY7NWYbYGpwkJvYCOE5pazesIHMOwCrxwp0T8nAxt8taU?=
 =?us-ascii?Q?YG6bQKv314rlSUb3Vy/MqJSaXumdzoP5N10fdsX7yGwl+iagfx7uyc4VxIS0?=
 =?us-ascii?Q?pdFt3f/nx0w3aMhXefgS5AR3sQEDFRdTamqSA1A7KqPHnZDgrCjnWVPLjUpa?=
 =?us-ascii?Q?3aj3rEkMKvOQGcrLQjfrmzwbtbUAJlXaKjwELTpcJ3NcmNi6FFh6pMkS1oM7?=
 =?us-ascii?Q?ks7QIjhRRMRaU8NaaTC/Z0KI33vZPyS5M+wbZV8nxyMadRlMoIHE72wOKwcZ?=
 =?us-ascii?Q?5RD2y/4ufuufVG+7iNoxCt3CHTpiWv6jvVsNsKu+jHSD4Gm+EpBbjxGePFOF?=
 =?us-ascii?Q?8kuYCQF2KWxZFcrHnC0tNv28TVBSO2jMSmJysksUCNnid1eARdHWJY0EaFOd?=
 =?us-ascii?Q?eozvuF1t0eoZ0SCLfdt0cBFpQUhl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6640.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?omM/O88N0n+LQvWiQV5Lgx+O9RonWCooTLKxWenwAtZoGd6Za6YOT0JkYmv4?=
 =?us-ascii?Q?LbYu4urCuZ/Efi7BcZC8+BFXWyCpiLpkt59xStWrtK2woMmbo2uLBSLrHwL0?=
 =?us-ascii?Q?16iyN1vImwv8J2mn1Ecy1u+TyMvdZZXHlM5R/1XitekB4wMpEEAZSspmMqv0?=
 =?us-ascii?Q?OGNZ1CSteQOakaE2Tn2h5Ht4wDTSwvtBwxLCTtCfLs9ZxEj/FYLB56eERkru?=
 =?us-ascii?Q?0ICb3qJ+vtURL/rbQSKEiUNSQQ3Iwkh+WodzW262Ei+t9QNbwv8572yYoKN4?=
 =?us-ascii?Q?o33P6C8OBhoAO2rq8VRRWjM8HL7QzQ1xRtIQ5Cr0xQaf3O77YML32Ia2T34n?=
 =?us-ascii?Q?wgcifvCJ4arpKc3tiXcHu+U0+Xa5NpQLOgmVkgu3c0NkN6T5P8j/P5khIX30?=
 =?us-ascii?Q?LNM2BFhlIAiUAE5S1fRE6srYoYxeFeWmELBFSt3o7Es85RvWbh09/BnjINAn?=
 =?us-ascii?Q?mjC4TgdunLl57Vah0k22C0V+Kp7fDc4KZg7u3BptvVXyklngi2V4KxZ86RBq?=
 =?us-ascii?Q?bTSpHNkUdJKmvoyxJJeRrkOB2ctWZGSNV6I5oj7fdfd/35o2/M77Wb07xyrF?=
 =?us-ascii?Q?vvJLlVWiF2+v2PgQfJm8GlNbeqvhPyl7YhUbkX15uNBL9EJ0kmRTRL+LkcEs?=
 =?us-ascii?Q?XxkzNIYOMCz9j33DO+vp0tHdFqgoxbK11OZsGXFmkC+L8/Tc55bRQiEokijE?=
 =?us-ascii?Q?818IDcOYt3G0/7cFUI0BRvbH5omvzbwRsADNGaTHAEwANaeBQSwvG76qvG6p?=
 =?us-ascii?Q?JpcM16aqhU6jcdao8BXo31hri+QIArrBamEFzBkYL5Ymh6+D9NjN8AL9C9YF?=
 =?us-ascii?Q?ifFc51e5tLL78powDMpGt9GJeDx9SQR4zS6zwia8HmS4yOQ6p3ftiDTl3AnJ?=
 =?us-ascii?Q?SOpWfxrAjhPeCwkDBOqQBZEI9NYylDda32YWWYnY9P45Gooy5Y5ZXcZYNY4I?=
 =?us-ascii?Q?S3xo1b5Li9dMfCdI0TNeHkFHzOryhXtaA6C598H2gJcfZgfDm1MvYJK8Mx6N?=
 =?us-ascii?Q?CAMQO+I6YGQBESR8aBI8Svl7ym9NU4T754ymjlrI7XGOI3iaGSScwF7wgYaP?=
 =?us-ascii?Q?NFilzHf/FPEgfwI7HSEJgtEHVmlqaUJbxfJqO12kIwYteqDLf5G5spnpjyFG?=
 =?us-ascii?Q?AzARUod5hfFUWAoEqgwlReSnRGd6K1BKEeIEThBVMg/GFweJWHa6of86TqX5?=
 =?us-ascii?Q?/KyhI1LDCnRANtqd1un1try+yIPxuLb1J2XBUNzViqYNTxxkRzqZOr2diy1k?=
 =?us-ascii?Q?nlomJx7C0rTGREjf1dtVSX64fv09pEcu2W4+dDvypVFEzzlHMoDih3NXS3AM?=
 =?us-ascii?Q?G69T6Fhku4m1/vUuM5Xxd7VSfVVbR0yQW8b6/h+0CkWSKgtKv2eTmVBp7SNS?=
 =?us-ascii?Q?O+Hn/fJrua3zRV8FcjmUGrBNGv1MDzrqq6lq8w+bel6yD3GjcBv9KkYtgGc8?=
 =?us-ascii?Q?+QWVbEOj8RaVJVSHK82TUs/88ZBE5kM52u0HZVlbD9L9mjSvw2HD+V7ekB3g?=
 =?us-ascii?Q?vY2425qKXpkjauL3h1k1sXUEClLoHkykIGTfVYoQZ4xcg6LbPbcjU9L/1WWo?=
 =?us-ascii?Q?bCZdoSpkGOFaa67xcgoiR0vV+Td95bqzod6OCMR9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ac048e-7e33-428f-8c5e-08dd30d17d97
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 17:17:27.2000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3XOm38c49F8ppynUogkc955AqWtSbJAxN+M/nHKPx6NOMpveOWWMrzUcT3BrLMq5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6902

On Tue, Jan 07, 2025 at 04:17:59PM +0530, Vasant Hegde wrote:
> > @@ -2375,24 +2375,25 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
> >  	if ((flags & ~supported_flags) || user_data)
                  ^^^^^^

> >  		return ERR_PTR(-EOPNOTSUPP);
> >  
> > -	/* Allocate domain with v2 page table if IOMMU supports PASID. */
> > -	if (flags & IOMMU_HWPT_ALLOC_PASID) {
> > +	switch (flags &
> > +		(IOMMU_HWPT_ALLOC_PASID | IOMMU_HWPT_ALLOC_DIRTY_TRACKING)) {
> 
> Better use supported_flags. Otherwise patch looks good to me.
> With that

For now we can just delete it since we already checked that flags
can't be outside that range.

Maybe when new flags are added it will need to come back someday

-       switch (flags &
-               (IOMMU_HWPT_ALLOC_PASID | IOMMU_HWPT_ALLOC_DIRTY_TRACKING)) {
+       switch (flags & supported_flags) {

Thanks,
Jason
