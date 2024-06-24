Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AA119E819;
	Mon, 24 Jun 2024 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719249142; cv=fail; b=Ba0mMJYI3Z9H5FoqrbJXvJtbpxZJI+mUexQAZO8IDVOQOj2rVkTXI9DnZydHWVV1n+GbvV4eDouc4t1xEL9aGJXlGndiAcMf6fStU51VaOcWazv8QGE6M+xk88A9eF0UiH1urwHeD06Xs8qUPWQzesfmQVyF2StDlDLGhz9KI3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719249142; c=relaxed/simple;
	bh=MuNphmKq+l6wTTtzlfXSRXDLFaTgiIm39spx9l5MdyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PTGDOvJ2b6ABy/GsQWE5PLbraX+e8hAU9BPk+JtqkWuAkkfIXB9UyjiYBOqYsces6qQwiVGWRzNd6YVkBXdwpVwImZYAz81Yo6iWmmmS8XVavfIfrRVs/OdHI9CVWYZMLF0JYN8ZebmW4gpg4R7bechzH6sfu9MNKNsJMBLpOiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KcPpl/Dh; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KcPpl/Dh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ia7oxXOvdYJ27C5Ac5DACvtlsCsonure13ofV/ahIUsmY6y7lctxd8cCKER4ss2HesfmY8JoiCLe3P86Tg7GcANIKMp/Mukb6EiuPPyri+jlE0JnV7jlq1TBz8Sj03iZVOzeK2tPujew59ZxZOxmJo1PjjVHoj1/iVeoleUCKEJWK+yqVmoxuzvGu47kaf2wHbGPYWSH/Av3T8EIAhupGIEQwanj4GXn7Owohrw4VyImMZxf3iYeb16Ci9o13IwnRhBDl2VYzyTt1L41UeBQKhis8oGvC5Yifsr7U8Wt9Z3APjT6F+8O4OFnPzWniUXwaVRoZpQTbuaVGYcHWhx7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuNphmKq+l6wTTtzlfXSRXDLFaTgiIm39spx9l5MdyE=;
 b=dyHaw5VUl76CaoLLaibgCo9BwnA2PabhrLpNLbKoeOSmG+CTgx68t1rp4X6QEucpL7e3XdkkeXRtDJExsV5C4yHXh1jvXgHtISFtHXqqVIPDQr+gMN2tls3Jju0svObtF6lEXUaTq2YAFknPOgwTu7M8ZwEzP5LRd/WXZSu5OV1WLji9QiRsfC5Mrt8/tPrlnhnE/ctF0uOFl8WfaWZWvSVZF3H3AJ51MHChDyd4u9sNS574Njy0Nekw1pmQk8ap7DZAIeQFm1hxKr3LjbZc4q+PWKECqu8qX626oO1fvYgRMIH5hR1AOY7Q3kcOy6sTex8JT1FUyKpBGMLE08iSJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuNphmKq+l6wTTtzlfXSRXDLFaTgiIm39spx9l5MdyE=;
 b=KcPpl/Dhg7MQ+q05bC/9dGwG5LXwPv22YLI+YWws3NmAeQZagGume5SeSxFyJ5Wc+oOpmCqx34otUefejCLLpH3YZefdzJaV6J/3GRTWnLllEiBgGzkd9Wk3jxpVFwyWKwCcXJ6R/nknVx5QNW9+eDYPQIlFCxeHLX8ZDS1lRDTlTpSdaCM/puXw/6PmqknnMFX+eQmOk5/RdFajXAY8Ywn2OmnFIgNuBrzWRgfqsvQ7bKWh22I3pV8flee4h61qFkr2jvN1dC4es1yKTl5aXn7O9x5Ih1hnEL1aHw0g6uVR0HXGAYVSJTMmySfSUCh1gEOpYC2/4rglddR8xehqDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3843.namprd12.prod.outlook.com (2603:10b6:a03:1a4::17)
 by BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Mon, 24 Jun
 2024 17:12:15 +0000
Received: from BY5PR12MB3843.namprd12.prod.outlook.com
 ([fe80::efc8:672:884:fafe]) by BY5PR12MB3843.namprd12.prod.outlook.com
 ([fe80::efc8:672:884:fafe%3]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 17:12:14 +0000
Date: Mon, 24 Jun 2024 14:01:07 -0300
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
Subject: Re: [PATCH v8 10/14] iommu/arm-smmu-v3: Put the SVA mmu notifier in
 the smmu_domain
Message-ID: <20240624170107.GU2494510@nvidia.com>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <10-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <CAKHBV27hj5cefib6nx9CM9-9P3N2k=Y2W-FwT06W4OoEFJ_zqA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV27hj5cefib6nx9CM9-9P3N2k=Y2W-FwT06W4OoEFJ_zqA@mail.gmail.com>
X-ClientProxiedBy: MN2PR14CA0009.namprd14.prod.outlook.com
 (2603:10b6:208:23e::14) To BY5PR12MB3843.namprd12.prod.outlook.com
 (2603:10b6:a03:1a4::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB3843:EE_|BL1PR12MB5753:EE_
X-MS-Office365-Filtering-Correlation-Id: 65327c30-5e8b-41e7-0620-08dc9470cae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|7416011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NgZFTxc9FD59xjSVmoRtW1byrsQT2UBcQElEoTynZ/OoltA0h3+EBjuuBYkO?=
 =?us-ascii?Q?rf6sJJViWijeHmswLycLt4cGARh2/N9ap94+qfJ2vaLh5C+zfHQm0Do3XLWc?=
 =?us-ascii?Q?2tEFFIbOE/wTRBW73qXt42jJ2vbySyzOLTSfe7S1hN0XuoBXvUMjbKwXlO7W?=
 =?us-ascii?Q?xiqNOFXUJozQ8BdH7XVXFDXgtEgskkG6BGT5p6GIxQUP/eoBRfR5NmO+fym1?=
 =?us-ascii?Q?GYYyAXpekeEfsjcsTPQz9ANdjS+hvR9oKq0WPxFmn2hkyJKXWcziAfsWrWGs?=
 =?us-ascii?Q?kD3L3p+59ygfGSOYhmzcEHJtkTEtadgDE4CVCGXMA/0AGXmnfuYQSDuKq2YY?=
 =?us-ascii?Q?L+n8SY8e2MzKRalIFQH+9M4O5AWQX2Bp/8ujCTCDqPLFyoDI+0gZYT+dNYZ7?=
 =?us-ascii?Q?RUx2XaMhmUbjdBCI4LdyCUiQOSrxvZ0mJuw/ptWtx7N5ZJI33rAw5Gnu55oO?=
 =?us-ascii?Q?NJJSuHFEsK3ib8CgGPg36CZp7Quby0ixrtUQ1XLS+khzJ9/Fi5Vq/r5/vMKF?=
 =?us-ascii?Q?FUrrfommqCsoJgx4GgzE9NIylvmIYIy05R+ozOfO/mjb7ALlpzX/UqfxBjdK?=
 =?us-ascii?Q?Ka41ESRWFAvev+FtwWLSJS73OIwCTwh/VE6I7WojdVmONFC5SKURwOjPXTGF?=
 =?us-ascii?Q?BWBSsavzsFUKTXj2RTgOlK6O50CUFkXz+OfkZ5yAazVh5uYDyTBN/6tAvMNl?=
 =?us-ascii?Q?DB2PnjjPT9/Drd+4SHBh3Yi7H4uwdWFszK7WJpMOWwh7ce1Ec74Ct/IhqKaI?=
 =?us-ascii?Q?SDnMWo7ZRz/3Unqx+pVjeyLZ5EORaeEYYXDobQR55cjoz7Thrv/CkUXST0PI?=
 =?us-ascii?Q?qWft42MfM/t1LFNByEHCBNqv24LMG2c/0FBWxuHo9j+K0ZFZNFC7a0AA0VI/?=
 =?us-ascii?Q?TMSeezTVGSowRfBuxNgSUWdMBuYc/nh4N4uk+jPny5DZU8zeTuwF2CBWhBR9?=
 =?us-ascii?Q?ap0cAp+ZW0T2jHiuw5qEqszzVQGiO9TNKGGFU2/gMNH3G7XAZLql8HfXTD/H?=
 =?us-ascii?Q?zkHTmFHN7ErRidMjRsi1+knQt0I0IOhsVeJdz+cMQFAGrx5XU19fnPNQCJKY?=
 =?us-ascii?Q?u6h/WafdzsWcYYj+06oMHTdfe4+Nd+oWC0KfeX47JqXLmGFInAFQ6wiIUxlY?=
 =?us-ascii?Q?HrFsGkluBCckwjVIMCDr8lC21OlDda/kL3Gqlu35qzsFHqtIVXrU5MORIAG/?=
 =?us-ascii?Q?gS+/fjVQrJvvRZ8iRIHhDaB/73bGDYPJOFltoRJtLLX87Mzr45psNTHatoVe?=
 =?us-ascii?Q?XYkMHDeAn/VfpqlCmaPxc4mTYGK5BRDE0KN+AiXqnraA9Bl2pK0zML8NM5yG?=
 =?us-ascii?Q?Ugs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HJry8gEtArTQ8stmq7KzeZo1PT2VRD5n1fAhV5P1pGOkSjFiqBZ0vRgKPr2R?=
 =?us-ascii?Q?/Qz7a7uXJ5O7ToGnzZy81Ds7CyellLdcakVs5/MdMVUbtu4edptSjdSm12em?=
 =?us-ascii?Q?4O607W9zsmqukgNcHBPkS3iRsuUyJ2wEc7zfXRKnttw3yb/hjXp0qftAiQ5d?=
 =?us-ascii?Q?R6+53ZHMk9XgGTyYdwfARSEojOjDN1z9YFIDTkXcCUGZfJ7VSBCOFx/gZwU9?=
 =?us-ascii?Q?RE9Qbu4N3GU/C6z79jJr8L2V7auP73MAYJGAPRUbWuNiI+k/BOTvoY207CG0?=
 =?us-ascii?Q?3U/sHZAMqxz6xO1T5y203A/R/sPX4Qva320uxOklE8aFXneZxkpv1hJv6G/u?=
 =?us-ascii?Q?0LsO8nLVa3TP/OKknaUHXOvtIGmw8PtQ6II6U2qm/oYNS03M+NqBXmYXKdZJ?=
 =?us-ascii?Q?nIb8Nm47tvguZoUD0/fUyGwjh5wE4UlBAhhB5u/hI/6QhuymDMcL0DEfHg97?=
 =?us-ascii?Q?D3RMqHppfJH5YgMOiKXB+Q/WCX+qgSVtUohKGeQhAjFc4c3wpoEqQ4oZsH4m?=
 =?us-ascii?Q?gwip+jqrqRCCmgBXZ8RSetwM5uplroGKEhLW2qj2YM9t4rDtg+fL/a0SshOV?=
 =?us-ascii?Q?3I880iLzLdC7lcR6/MqwGQEMrEtsbTMzG+RMGdr8hlXtI2eIygrCeMT0C7Lc?=
 =?us-ascii?Q?qSVU5LDZUEVY4eWPC2tFWRxZYQjQ955W5KrY5Wtzk+cC2lGhZ9il9hbuBeVB?=
 =?us-ascii?Q?Wa+uBNFTRC4tZ5hiqrvX2v0YhvlLDyYbo7HlJbSoiwbNwQ7NzYUJ6eIpNM+J?=
 =?us-ascii?Q?QOL2Mb1mhf4mef5RrlyRohpb+YSn0KAVP3lGg8b07TWZl7JY64pD1Sy1u2p1?=
 =?us-ascii?Q?FD4cpLdS6ReOQvQlLREUNTsYm9qqfqB6cIct3u0IDSnq2t6aktTFEKmRoOWK?=
 =?us-ascii?Q?FM1TDA0sBucGbEn8oDzAMAH0GIwNZGA2ieLT1RHJObY05ig/1OQsFh6UsnB6?=
 =?us-ascii?Q?yJeuN4vgnO4onNFQsWAks2/hoQgmofLZpo+E0ZZJc2/5KZXuZKF1CTvEPoSk?=
 =?us-ascii?Q?X5qAbhJ9uwL09c6jhbCwGH6QjdNOzRh2jSjo+BWZ1tmcbOcCYEvXAld2qtQC?=
 =?us-ascii?Q?NGpmxA923SzUXETp7neAYXnmIBvOCavpPIBLYfrh8CAX/44s9R1vmCeWcjj9?=
 =?us-ascii?Q?Bb8tLV48e/Vh+rlKk6ZvkFoloGRXJ6enp5Zd+OMMrvos64YR4POTuG5+RLrA?=
 =?us-ascii?Q?9t6a30Yy9/7kkRxOqgwNnfs7XjumUu6mQXp1LIHCDuTdLVJtbHe8rTBULblM?=
 =?us-ascii?Q?2IWDbrRf8ilvkxSKk6dmlUa6r451fMRTuOJ7eftyn8Y/4kFLgZd7NS9fXJlK?=
 =?us-ascii?Q?h868X6OrWwcZ9uVkDwjOomPOxlWFNyysavZDOU/OIytkLkumAZtKFe/kdWSF?=
 =?us-ascii?Q?Cc7ysqbAyP3NJ0NiEDeF29K6b+r1WujI6/yp7sntd182hNfNVRxf96azUL5c?=
 =?us-ascii?Q?DjTnrigwhujbUWc9P5ZTQG8Ob9GqItGQ1jsHCseMYV+2Ac2zm02QoQrJRKbC?=
 =?us-ascii?Q?9HDxmlvjFLXROhf5KV6oOJabWqSURbAt82tp4F/P0FRwgmBwwpfclSMUfiYQ?=
 =?us-ascii?Q?YC/o7WRRsQ8327/TPoKkttVi26zrm/bBflzIUdBS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65327c30-5e8b-41e7-0620-08dc9470cae3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 17:12:14.2176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4eukalHxjB65B/cc+/70VYtH0ysuHWimiJKUPEGeJONIl60MVKwGVODFfh1fhdX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5753

On Mon, Jun 24, 2024 at 05:54:42PM +0800, Michael Shavit wrote:

> Can we leave a comment on ASID sharing in the code since it isn't
> added back until the next patch series? There are references to ASID
> sharing remaining (and even added in this commit) that don't make
> sense without this function (e.g "Prevent arm_smmu_share_asid() from
> trying to change the ASID").

Yes, I left the comment references because I really do expect it to
come back soon.

My plan, broadly, is to allow the domain's to be shared across smmu
instances which should introduce the infrastructure to avoid the
invalidation race in unshare by letting the domain have multiple ASIDs
at the same time.

After that we would add in vBTM support, this is BTM on systems that
only support S1 with no S2. This avoids the VMID issue that is
blocking it while still being useful.

pBTM would come after the IOMMUFD VIOMMU support that Nicolin is
working on as the VIOMMU would be the vehicle to bring in the KVM VMID
binding from userspace.

I can delete the comments too, but then someone will ask why not
delete all the locking as well. :\

Thanks,
Jason
