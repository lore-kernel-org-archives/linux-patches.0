Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3D918FDAA
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 04:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741235266; cv=fail; b=I8wRONiaUZjEy+LbAgFzTbj6VloCXeiPRQB9iInKNFNiT7L90bKroqEXMV2rH4ByvEjfVL9bTWSxW6EjMOgfS6i0V+GgQHjkFhoaC6s2J4Fy0LG/gqLWsEpCQSzKOry5ohe5ljb1RwDu5oJos8VjhJr4H8H/PJ19nkEWc603nsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741235266; c=relaxed/simple;
	bh=oG3/V1BqBwT3QmP/HdJsSV8OdCWWqW7zK+Vd7HQHBXs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NDLVBykZYJ/3aOU7oAoPi3kcEBBz0shnx5tdGe3S18gtcSgypx6rFTdqYxPiioBTWs/MvHMbzje4l7tRqAToMYjYXVkWvlXrtmGbqdwUs2y4UD5n93Hqj7PBf9hn0LuOSaAWkwuJ2837ZOAT/3AYnMlghOkOdMqxipeQuYvPJ4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q3h3dAU2; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q3h3dAU2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741235267; x=1772771267;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oG3/V1BqBwT3QmP/HdJsSV8OdCWWqW7zK+Vd7HQHBXs=;
  b=Q3h3dAU20w5TxJ2qFoY6qrHyXHpFvFiqXRJ1zzq9l77V81DYtpxtW+r1
   FWHOqcCgeQnRsdPZdJzcMYnXV0iEN+BUrxuuTG/3ixeE/06VRrCiSFf1W
   UZWVYydrapTq44sjWHkdIht6i0cJWyO5fMEpDEH2/wHvXbtLZ+ZUqsd4y
   4/IrpD9zTJD9TzkPKuG/w7/Qp3vVwPYZlGkxMYeNSXs6YGa8mm7fWwH5v
   Doyb4Sc9fgjaqg9SLL91Mq8lMykunqAvroX7Kb09rB6qJFEabelEZTb9Q
   DH/AO1v1RTZcC3X+frJQCgLWS/RC2AaaXVYAjJ5eBbcOn8Tjb9lKFKUWP
   A==;
X-CSE-ConnectionGUID: bPIeB1WLSimgyrh3rmc+ow==
X-CSE-MsgGUID: N9vWO0THTXG+p7hrHKSm7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="53638123"
X-IronPort-AV: E=Sophos;i="6.14,225,1736841600"; 
   d="scan'208";a="53638123"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 20:27:46 -0800
X-CSE-ConnectionGUID: EkGZfnKRT/uvu0NBf1SGxQ==
X-CSE-MsgGUID: eyxDu/X8QbOU/pI/HJNRIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,225,1736841600"; 
   d="scan'208";a="142122863"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 20:27:44 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 5 Mar 2025 20:27:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 5 Mar 2025 20:27:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 20:27:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEZUqHn3yODcXufDj2atDXLGl5jaFyc+nrO/PBjDwK0DOYzgKVcRqta6uEmrvgBJGCUdaSJrpamOaGoASbI3abktwhhdT7C1EKOjIl1721Ht96ezZjeQhwBCjk/z9/aHw1bGWMEkz6V8T+0HF/33PmDzljcpg0FFhllDy0kTN8CIM7+dgJBeODkF3spLKSJhIZ6BA3ojJ3N3h2XG42KN6kM7BBF+UORrW92VLw2Llcb6cpxZxMgv6OdIJNSyFrwJTFVQNqoI43qh6ImUYb/jS/AvppYTbmn14vjV4kx1StVhMXD8I+XFu+y8oIx4lJvM66zBFltknMiO8AjKTwH/AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdH9pD98ogZBZXCP/AiXqFHM4EY4tYgaX6VKb6uxcpg=;
 b=qA9oN6bWPMCMPIUKgdbUWvLPm1XcPlcNXCVEFFAcScxRFAUQra5fsD6gz28wnxg15W27zUpPMVjH/WIjvFdHcHX72QPBc5FrGD44EyKip58qP9+ueYmTok0i5z3Qhnzl1YKw79970JZ1kEavTc36xU/UOR/ufCPkN2chEpLgInpdfYI5zT2QOdLmTohC8X1415NOq1qgBNtKlMWeuNnbOCwA3B5HoDmO1aALgeksScYiHtkl/eTouUZqhpxk/rVUlVgy0uKueMCezjgAOjMiiFgrXjupSbUwDtx6z7WSEmU2GyLAxk5RIORJwi176/BlhhEHfjG7EnVVrmptrIkzfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Thu, 6 Mar
 2025 04:27:41 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%3]) with mapi id 15.20.8489.028; Thu, 6 Mar 2025
 04:27:41 +0000
Date: Wed, 5 Mar 2025 20:28:48 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Tejas Upadhyay
	<tejas.upadhyay@intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, "Sasha
 Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.13 052/157] drm/xe: cancel pending job timer before
 freeing scheduler
Message-ID: <Z8kkgJELLD5oDMQb@lstrano-desk.jf.intel.com>
References: <20250305174505.268725418@linuxfoundation.org>
 <20250305174507.399643662@linuxfoundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250305174507.399643662@linuxfoundation.org>
X-ClientProxiedBy: MW4PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:303:b9::34) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: a64226ef-76a9-493c-bd9f-08dd5c673bdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5D26qH1DbdGGJwHaCeHhqrBTO6c2YigapwbU34civDav5MJwu6GPyDZWon5d?=
 =?us-ascii?Q?AiUBqEqwl4REqmCrjC52FEBQCyVOx0qwQmKQjWdlPf915iJIESZ91t/sxcpM?=
 =?us-ascii?Q?DjuC/TIwsIpbHaVbd+4xCEq5CDAMRqYV9EUmfCKmQE9/diQxkaJFysXynO+z?=
 =?us-ascii?Q?LEWfnfM+xTdJO9bj3XohXbBtp4Obut2b/e0W/P2k/fZ5LEzFmTOad2VngvGX?=
 =?us-ascii?Q?IlNZDLzMybPA2JtbKm8dwxReuVPRh0u1Lrn1QolO8IAOJuSTUwgzDny19lsZ?=
 =?us-ascii?Q?CrkQZiLF+Y9udoqPmo2afBY3JFsl3UviK0XvcMkiZ3SkrJDjfkoT6X1SxL5i?=
 =?us-ascii?Q?xFVoG3t1E1PIz4zWfL+3kBQl+dJnRO5D4jyiWt1akB8wC+yp3QVeukTWfu44?=
 =?us-ascii?Q?yGDMvcLYHqtuY5Tigd6tLEWZUZV7FWmLmYBVZgL+h0b/YWk/Ap6/ySX4mSER?=
 =?us-ascii?Q?cuoWc+dZhpiVYzFJ8vqqS3UKCK9wYVv/ZG+o5FPRAIlobyY9/+Zl6lqi8xBv?=
 =?us-ascii?Q?1kFwQEQHPMjwHczCYGVFZhZcK8eqh/nENt9dnaxnMs49vyZIfvxP7boNek9Z?=
 =?us-ascii?Q?meus+54tUP6F+oT0CElbnul7YyNMgXV41hsbdvpetGSNDVsGMwjaOzUMa4qt?=
 =?us-ascii?Q?CKhnfpx3MchUJZEV09Y2kn/VMJn2773n0b43hFBqlhfOd9fAVOO1aV1se46i?=
 =?us-ascii?Q?EZoZg8YCayq+29oJaLhIxgUThLvg6a0yAkH+rmu1qtDFC1RssW/r/19CqovH?=
 =?us-ascii?Q?hYtuRbFmUvWQHumPTJ265SsN9Cy7lurWtQODixDVOWLYebZPKQH5lh9Bc1Va?=
 =?us-ascii?Q?My2fnHhgSTV94bkNElOQJfQiuRqxbJzRoSefcsnamfnK3b7iVi4Z+gvvsE8c?=
 =?us-ascii?Q?ETfYCxMfCQmr7a69eLKxSCoQbeXSc6rgg79jCye7cW0d2Tdb9+KPsfSYh3uW?=
 =?us-ascii?Q?kZukIen7vdMdo/ZD/DQq7gwbo8kxJmaKfT5HGx2hS9IoPAPy+JxUIGP3GLyQ?=
 =?us-ascii?Q?9TrBdNOXqF3JYC5JiUDs/FHLQI1vq/ffzVRtmmJTyXDS/mTzCiQ7yH9+HM7R?=
 =?us-ascii?Q?OBWBnNOKLdQrMMq/K3iFEcxivshvEH5qzsi9dVSu2l4E4jYnuEFekVZD+BL9?=
 =?us-ascii?Q?pnI9jOZZ2Ez/PKCgdmY9HbpAo1NTazt6VoYCEiM0taVjr8+S6T/WBioFZ9PH?=
 =?us-ascii?Q?X3FCeJKQhBZkWmumh7ievLl8wysWhD4xwZquSjOZAJQnK7+wdmwhtB2CMmH+?=
 =?us-ascii?Q?KJnstpJH07BZaCgh/Wd0T5yQ5P0LcFEB8k5iS2QF4GxofEhS5mEuhc6SEDpF?=
 =?us-ascii?Q?kWq7YmI2RbPD7aZvwpy+x/8FvEvXjyA7dBWT6isql9ZwpA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FCPkalCf9Cc0cMlS6LvECK6N0j9CVuuOszleIV9gETwhuXN0KddzqeDnGPEx?=
 =?us-ascii?Q?DxEx7ecxIiPhB+VhPT3Wja0A5Q6xIr53PDS1YSs0EoBS3PSIsqbB8l3mV2Qx?=
 =?us-ascii?Q?4KatsfZPiLHOxYhiRwc+g8FDL1+4kr2w7CXEw2NDNRfWpkNoImsud2di1/o5?=
 =?us-ascii?Q?9ZcII83rxcDG67hy+y3JmiFID7hmQ/2dpVxS91BewMUK8KBXX2TjQpHd7jaj?=
 =?us-ascii?Q?s7dBH7goDFKpFR4sU/YrOm5NIEcDkZWLFzjiKBLU1AlYSbjHOP7bjazqVdSQ?=
 =?us-ascii?Q?x6CvzGK9E4ZPwSCBkwDKXBxnEIW4iqYcsHCLNB6n1c3eqp3xbfRvBF4i9/yn?=
 =?us-ascii?Q?VKeL/qu/nQbnspW38cfdmAVVTSluneLdjbegADWGlxJNJIvBs2O60r7MkGKE?=
 =?us-ascii?Q?QQ+LrLjVR+ZuFMErOXIyapwczyswQXla48DGTjypaOH8rVXbZq3F/zVszKoS?=
 =?us-ascii?Q?5QkGjHUzG+jzYDN3xK3Gq1uvi0C5SfDuq/gX8XuUr+yBToLNUrZCDA/70Pj6?=
 =?us-ascii?Q?LWv6dAAXkRTyCL++U1sJOMn006aBOD9PCkG92UYvrYYVpyMVVkVoU+v8iKty?=
 =?us-ascii?Q?KcLUI0YvrksC/IQf1tfMLLEC/YI1ctPAe/yiqgohplZykcGHtItG+tMHv46T?=
 =?us-ascii?Q?N5k1bgnF01oLxg6PqD6T5OrD9YPkzii4f6WjfQbejt4dxwNKhqj7yxe/9VBl?=
 =?us-ascii?Q?s7x5u4vbHg88zPQwGkr/okEPPNb5WGEz1xV+BIASnVYnpH2rYgtmjJR9NQEw?=
 =?us-ascii?Q?3W5V0jBdjw7c2luAUok6iV5yui6DAKzur4qFfcux8zXMVvinisBp9HlotYuo?=
 =?us-ascii?Q?uAzKYaNL4JPRZgRaNVBrJKZf9JVCuuMZjPUMBQTCyqTimxO1+/vrwH4NeUDr?=
 =?us-ascii?Q?xz/CY+XdntRBY4rLNK6QiPdzHvzmel211LdZJ9RbXPISX3dHhRe142DZ/md1?=
 =?us-ascii?Q?OLcxK4J1CjBBzWpxkXdNSyWivKfQtAUfeXxAN1Bvr7VG9XOUaNjJfzwoHCC5?=
 =?us-ascii?Q?RGG/D1CUUe9XAcI1NP4CZA4akGT6W1B1h8YG37tEIaG2MBAS876j8o1N7S9S?=
 =?us-ascii?Q?YauYeHGLvv4VBeaYmY2j74XmuSBkyUP99e+lEQAGj0GeLy2VoS3mvk9zizI2?=
 =?us-ascii?Q?RPQ623yoPcjjvNe8vYNX2wJm/ma8rWLQgcpQZEIPrqyA+I0l4oaRxSRaA9Nb?=
 =?us-ascii?Q?OSUujkn3/uz4e3UoPHV6oN34eqDupD0zndHq55m3j6ekBeetGKiz9RKMAHgm?=
 =?us-ascii?Q?t3/GcxbWhrQsNJBuOiMiFXMvEomByFAOKerGxyLOSBKQt8bLlIB8zJ9aMfrT?=
 =?us-ascii?Q?zM5am5Mw0fh5GQJr6r5hplUL6qp8bJ0jeCncqXNrJ+mxLSI7oHDUIALkdinL?=
 =?us-ascii?Q?6D7+Grag4ILL9HrQiFMwekRHKluW0WziDLwlnvoRgRWNo/ONa/Kxh4EYLtWm?=
 =?us-ascii?Q?EEo2KxQwFLvZOzzSnpSsPqSRmdIPBlcLQM2IqT1hf7IT0fM5CgxLN3Y4Sbhr?=
 =?us-ascii?Q?5cNjwF6eAckDGBxQV9IwmCpXrjRN3+FA0p2JdRjilEVUZMh6LDhwr3PR7wQo?=
 =?us-ascii?Q?+6RBjry4WIOz6Q4YGo8djdoor/sUw1Mrd1ZqTGukiBv4LYZd1xKWmzwDiyZW?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a64226ef-76a9-493c-bd9f-08dd5c673bdd
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 04:27:41.4126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LCXYrWgOJSjwFnYF3NkE/XgMF/1VjtXyZMSuB9vJaAOZMc/a8TaZqQGQAcbOist2Csb39uBYdmOHrc4bnL19Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

On Wed, Mar 05, 2025 at 06:48:08PM +0100, Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 

We just got CI report on this patch, can you please hold off on backporting this.

Thanks!

Matt

> ------------------
> 
> From: Tejas Upadhyay <tejas.upadhyay@intel.com>
> 
> [ Upstream commit 12c2f962fe71f390951d9242725bc7e608f55927 ]
> 
> The async call to __guc_exec_queue_fini_async frees the scheduler
> while a submission may time out and restart. To prevent this race
> condition, the pending job timer should be canceled before freeing
> the scheduler.
> 
> V3(MattB):
>  - Adjust position of cancel pending job
>  - Remove gitlab issue# from commit message
> V2(MattB):
>  - Cancel pending jobs before scheduler finish
> 
> Fixes: a20c75dba192 ("drm/xe: Call __guc_exec_queue_fini_async direct for KERNEL exec_queues")
> Reviewed-by: Matthew Brost <matthew.brost@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20250225045754.600905-1-tejas.upadhyay@intel.com
> Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
> (cherry picked from commit 18fbd567e75f9b97b699b2ab4f1fa76b7cf268f6)
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/xe/xe_guc_submit.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
> index 6f4a9812b4f4a..fe17e9ba86725 100644
> --- a/drivers/gpu/drm/xe/xe_guc_submit.c
> +++ b/drivers/gpu/drm/xe/xe_guc_submit.c
> @@ -1238,6 +1238,8 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
>  
>  	if (xe_exec_queue_is_lr(q))
>  		cancel_work_sync(&ge->lr_tdr);
> +	/* Confirm no work left behind accessing device structures */
> +	cancel_delayed_work_sync(&ge->sched.base.work_tdr);
>  	release_guc_id(guc, q);
>  	xe_sched_entity_fini(&ge->entity);
>  	xe_sched_fini(&ge->sched);
> -- 
> 2.39.5
> 
> 
> 
