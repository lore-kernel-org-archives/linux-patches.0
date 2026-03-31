Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB143346FAA
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774978765; cv=fail; b=Av0PamUVWm2NkLIdrE0pz5dA7VL1xfJZ8sLWJonD+B7dxF1cpDWCG9sVz6kPbeybZpz4ZvQlnPNOXYG67Mf4CEpCOF91jz018xCbN3xq9hICU+h9Gs7gqIH1Twfs96exLv+pB9uVR3ra3/fg1VTLNBhCsjbsYV572rWWiMV4cfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774978765; c=relaxed/simple;
	bh=Su712e/6kd7zjwKSkQ5A/pxbg+NxV8F/hzD1CuheTis=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FpqZlJ7JnXFn8epVVpJbRsU1Wx1furkIyEnisiFEaPjeyBc61j1w7h9jkWKb92A1LIUnZW4fVgsj/s8M/aDw5ce8a5sJsHBfvyQiWDptj2k1F5/O+nGQyl2Vu8RwAyAwN6ityfPkaplG3N7KvVYWKdUZlVHMYi8L0/cppRAoKO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVbrxaZ6; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVbrxaZ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774978764; x=1806514764;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Su712e/6kd7zjwKSkQ5A/pxbg+NxV8F/hzD1CuheTis=;
  b=fVbrxaZ6YNuogHsukYBe4gRytVq65AovZXYRz7YtctEa5weOu8assdT5
   X/MJnQ42j/EQ/Ac1xaYw0TlLFw/4FQIX6p8jZboGCSkmb+sK+vVTcM0UD
   lZFCtmsYuhBWk9UHwXfq9be0Asz7jeQEX+NHqYxMNwnEBEkcnj0Ulgi9k
   1WFAaRvAIYvfaexLbkFOchpIeq7Ong1xHiEPxCgJFVTX+7Jzg9Dc71HES
   3d7Y3GRXaRjJDG3Ob//2p929t2c9vpKnol4sSCH6Kn2xnfxAc3VpLB02d
   nH5CQyzy9ooehVRZNBz14YOb4T8W4bgOuLIFxfNrh+WFusTLWhyekJpaf
   w==;
X-CSE-ConnectionGUID: BySzdvSPQbeS6oKcl7SseA==
X-CSE-MsgGUID: RkKIq3tzSVCJ2daIbeH6+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="63556697"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="63556697"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:39:23 -0700
X-CSE-ConnectionGUID: UBweod0iTHCaxbu66q9ruQ==
X-CSE-MsgGUID: e3NoCxRSQ7ObknsC/ilH7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="249485097"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:38:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:38:16 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 10:38:15 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:38:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AFiCtZe09ym4sqE92KsWeIu18zGBCSxmI1rX79mokuVPAkcNaSCtSVARHORaagtVpSwmW58KDzQoozImY7f2vpuE29TtIzRBmwiunHjsjEL1Qig2GsunSzYezWxKo83H/QSan4r9lSmW8/b0LQCGEXC+rGH4acqY9i1RSXT13gpCIDNy8lYbTBCfDUrzysmCNrsF48nVC6O8dIYjM1WfznHzIlLawafpwbSz2OcYIDuWARIPVdb53HoxRdqke/OrD+mmX8maTkQKZRGit5E+jVutkM7GwItsZaDTLWLXamg/qXZtIwqHlO3XUlXwqwAsWZqSpKIMrNlLmyBRkaipAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3EAChf6nQPUQ/LA/fJgIgMSHpSUxlKlp10k1ZZiQ4k=;
 b=bkbXACxzwccaJrX9rkm0sV5bBUqq+vmpOG1WhODh4owyIQ3hhGwflrFbe9mbIpdydejcarhwYtkhZdYZieSqd40BLp4guuAKX+hKsRU8L3WoIchMsSCI57Z4C/Wb39KYW1Y8D2wLQpzlZWRQDkec21eAMc3JuX7nhybAhIiaiMgOetUXC0tlMsiiewFX82WpX7yKc0rxSt1J2jfI8R2VhkyWS6BlHgLU/LH1PedixmV93bsvs5KUgxC3OkluRL1JYGhF4oiL5MYz6GWPDRX1wGKiROGhi6slRc5r3o6i3dRNm6JNzCmhnB4QNjO5vDvP7Nv5Niu5nS1gxinp6cQCKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CY5PR11MB6438.namprd11.prod.outlook.com
 (2603:10b6:930:35::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 17:38:13 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Tue, 31 Mar 2026
 17:38:13 +0000
Date: Tue, 31 Mar 2026 12:42:07 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 7/9] dax/hmem: Parent dax_hmem devices
Message-ID: <69cc076fcab6c_17924f1001c@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-8-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-8-dan.j.williams@intel.com>
X-ClientProxiedBy: MW4PR03CA0202.namprd03.prod.outlook.com
 (2603:10b6:303:b8::27) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CY5PR11MB6438:EE_
X-MS-Office365-Filtering-Correlation-Id: e625eefb-15cc-42d7-f29b-08de8f4c48ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: E/W8ihx8GR0yt1ovynlkHNlx+v/Q2kC9cD0ODBsFhUzgxt2YJY3K2FsFR80mnwzrLaYiP2vXeuD5IVLqGFzWmBaeOTIX0p+wVTe/Sv+F0bzeFShIP0gRtZYNbLsYipzf3S7Ce0WhNBMMog0nPnksrHhMPN5zcdm7XWWqkUnpI3uGjWoBCG+D6hKjUDhXD9+xfNtMJcm4PV6LEUYVm40feQXdFjkycl7L1hLghSId4gNAz2em30RYvyTJC52XlViygdKhX3eIl0M2uUEtpTqkqRFOF8WlCTsFN0jL+qqR+u0q/jgEZHenqwDNrz7jhb5IrfuZSioKDyq5ul0NasVZGq/8AtdPLRlMmjfNcWVi2cODXKtTxcCCOCCGvGr4vC6gQJq7CGYRIyxnMxbdmMsJJZrq9cvbhtwYmHZW0BSChGNcIzQVt7EPIgtiTvjQOz+AZ4H5xigZ2tmnRESovC/R1v0axM+BaO/Wimv7LX2zd7vAAd83hpMVvZtfeQF2m3W9pswqMfmuZg9xTGwZ5+agwOlsAUflEnCP5UaJQIBIABuYYl04YV905o7STqjARuSlJXH3ajx5/zycEOXaF5om2UenhkIpTvx3VMhlnAdMUtQYmXysUpgON4q23Znkd97JQi3c8YmPHzhHV1z0bEUYdIWVf9+BVyvOsLv/a8Zi4WoKLqcXrbBRF/cMEMV8rFhdU+vMDSeXOtkN0PXJ2AozsQN8T8fPpGLEPT22vb56LtU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KFQdG6UnErFU2epm/Ab2whfDL9pBZFcJacg1TZt872iCHqGCusAUjZ8y5M0n?=
 =?us-ascii?Q?rJEc2zNpL2H3tkgLOIFOcwvD9wG+1bcnZ6zbs9WeuM17rNmgwb1Jzs3j2rB5?=
 =?us-ascii?Q?rwPZPi8CUNhI5Ur7FKwZUldKNAPh8yn6yuIlYea8qrGPp+r4J7EEHocft4rd?=
 =?us-ascii?Q?NRAgMfDEkyEjA0LlIyc0YNFrCC/vXE3e+2XD820uBQYaDh9mhm5ncrNGOAHG?=
 =?us-ascii?Q?snxnjoD96ngfhq5nZL19GneXTjfveM+4RNRO0rD3Hn+J0zFulSekvIUR8+iJ?=
 =?us-ascii?Q?nbP1+UZxMy7P94YXkC2HDS7k+aVX0wkbI+79gqvRfaQiEFdh6H+m+SEQw+QM?=
 =?us-ascii?Q?ekRT8Pln83+8KzI1+m3ct6Oe+QYTdtgCDZpUGezYml4yADj+MjLB17V3t5hY?=
 =?us-ascii?Q?VaYiphKuAgLwQPqHDVKDtzGyhdihtFsCMTSuN4Uqgnc0tvwYkqW4EfiLcBuP?=
 =?us-ascii?Q?eZK20acgCQ0JWcDEQnyxMpp9+bMfJlOHDrxsRcBlz1GQFXxXu0XXAJzpg5VC?=
 =?us-ascii?Q?wVyQq36ab3dc2AaDzsWdlw7QCMz7loAyjj7gZqoa2znd3rh/G65iw1eTeL4z?=
 =?us-ascii?Q?3MoWBKySR1A2Flm9Jd8XLYTR+4qJPt9EsLumvIDGqg/OhHTgQSf5zkDHMrOs?=
 =?us-ascii?Q?hlbKk5UjrUA6q5oOGXMHbYBgDXrYd9q+mYIWTImE6/E6jSfL0FmhGQgTIZ6y?=
 =?us-ascii?Q?izcdJWJ4naZpg+ZrIsDjhXjSf1Bqky/c3iu7V0ZVxB1YjrNHqAZ1jaxHoyPv?=
 =?us-ascii?Q?JIaWAJHPZ8Brw62+jcRwJzQOv08NtG4kIjNVmJ6ysnNYCEVCoDuK51UA+uDa?=
 =?us-ascii?Q?vL+JVX0kxD4ZBadwFmK3meuautbH2IR8kq86k9zNue+utVm7ROgT+cYIGVcn?=
 =?us-ascii?Q?A/pzJQKsGc53ee/bavftbulV0QFyrfq36Bf4WtEkPbCT0lhSV0nLyPbmEdki?=
 =?us-ascii?Q?BPJaSDyNNx03Sv2wulKNoBwYGoxdMKyqiO5a0SkblbXRKc/KuqmN4AUY5lVU?=
 =?us-ascii?Q?R4BMMUP4kgf2sMq3FgbK9dfwu3xntwLfZ4Scp6ZaNnmi9Xzs0FE64bcI66FQ?=
 =?us-ascii?Q?JcKIQ68kav3OVqD1zDxB1UwUXgHSFZRTKiQwkcRgT+JMWEKpm/xrBIAfuC5U?=
 =?us-ascii?Q?RnRHGu3qT3ZktcjWG41jcDyjrf+m/E9Mj/kLXdOKFWiJRAFrG98mJ/GSB/Uf?=
 =?us-ascii?Q?c2XiLbY7HhVszEx1Nq8X7zW0uav6BXxPWUqWaplBr38QH4GH8rUlvG6FI6PW?=
 =?us-ascii?Q?C05bf+tUERNKC9xRdN50JuvxHFIgQI/SeaTjoRsSplYlJpN81keFhQb8vVZv?=
 =?us-ascii?Q?XZmFLTIQrXVtUBgiIp/DbKrLkgK8RQKPacPTZO1FnDCWUl/Vh4ENzq3oLaMj?=
 =?us-ascii?Q?gvcwBZfOVqU5mijLqpMWfN3Jy/abVlnvwehLOdZuBZxUYOpv1mhw4Sj5Uf+c?=
 =?us-ascii?Q?jFI9dsIzcGK3PM+7up4gkzOePrBK7oHXAL0thXSzSre8YA5ZsHPMXKyjaoMa?=
 =?us-ascii?Q?dY9rW/ZcZu2fLcxE7NYlyxCVvNzm0QJFOrrX+F5l30mWgNoFZxH1K1Y1S+b4?=
 =?us-ascii?Q?fRxKSdYqyrsDcHhaDflyA7dRWVcmsYyjqrnYmJ54zm9k55MRUSYpTLaGS/KS?=
 =?us-ascii?Q?iklMWIwqojPAOeJQYWX56UmM5dkCmKGGKO9NFwidQ+yHo7fotOWWMWWTT/7G?=
 =?us-ascii?Q?0WIKFyDXNbBgxbbuYQFCsGVwX4tLm5zKoDsrznqrLPFefbuCW9ndhgmpMGHO?=
 =?us-ascii?Q?KNMc0C+WVw=3D=3D?=
X-Exchange-RoutingPolicyChecked: bhueZU7R0VDJ5nKmALQlYWkX0oN1qGnShlezegvOq5xVZfXr1DrPRtUwtIRN2UC/76L+ePrt+/RmR2jyo7aT53DK1kWXc8f8HuFFEBSPLoGLD8eVECe4HqGs5enbLSgTBWmVHQVwymPvrVJMJLoD2emZFpRmau4sLkCMgGscmcmc4kwiB0ItvLotG7pcWJS8E2GVi6wlg+YV3r7/7DFWf9RFJnwyR1i7Ne5qM3QfyWyJWGzVtb6yBl50JkavqO7ieEek9fop3So+VhuBAnFmmKOteLUbFByF3uprU0ujpECWFfTVfbTloXkoz8/jJdZpDiUKKMFDjVSZu3X7LygY/g==
X-MS-Exchange-CrossTenant-Network-Message-Id: e625eefb-15cc-42d7-f29b-08de8f4c48ad
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 17:38:13.4746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uemFdryULyXHmfF+2J0NkpL4IpRQRg79XpLHvfI7ivGqeaH1SubEUBYokogi+JD74WwdaiKu2yBjjJ571IFjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6438
X-OriginatorOrg: intel.com

Dan Williams wrote:
> For test purposes it is useful to be able to determine which
> "hmem_platform" device is hosting a given sub-device.
> 
> Register hmem devices underneath "hmem_platform".
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
