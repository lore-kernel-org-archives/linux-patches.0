Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2A51C861D
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 18:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761676847; cv=fail; b=mRzBm7Vb4D3Da7N81Es3A+LV0R9tdLGh69tII6G4uad2etZv6fdV6qFjeny/hpMyKM05TQ7anxpPhWfe1tn0EPRIzrltLIySyzYxTLUgbhowEIQiO9/UrJrpt7HoYljxtdb1o4M+aU9PYF0SJ7LQqDV7tWBjomWc2mRHLgRAuR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761676847; c=relaxed/simple;
	bh=qaCCQwmpCZjmHyOq5LDm2dj2NpCa9IgqjAPJ8OnB+mQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h9SqmKIiSvSHBUDM0Zi93Rvhf6d89z3H0RVf4f8t1NFyvlMgci04rAhSicRYsFlUMYhRqwj6byKog4aXWtZ2MyKDwIVCNAT5sD2a1ixeSM8M6rwjo5Zltu8VTWidqsG73jQeoTAfE4WQAz9gSeomL1mktHBw/z4p4MoDx8aNQok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZOWTg6EN; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZOWTg6EN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761676846; x=1793212846;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qaCCQwmpCZjmHyOq5LDm2dj2NpCa9IgqjAPJ8OnB+mQ=;
  b=ZOWTg6ENDDVg1sMYz+BTAC4yWDkT2wXfuVHum0gLT3PaB7GoXuDa83fm
   rbua97jDJ0RR4Vz+DY13ld2nOGVUZidJTNgh8bQsMe516yyDq2t/5lGRr
   4pAC+AVclnB3sdm+3ANVsQe7/1iXLuOk1w/KW6mzuIL4h/4qh/JC02FvW
   e9sHeJKwq+YXgK4gp5mxokPw/FMJur8QRSPHNd2ko1IERihxjXekYDoNf
   IU9lU+cvLvgZPXqSISRs7Yjua6aejtd8IulNh855ja9XiaT71JYsqvVka
   usUyp8APVBJtDK2L23KDsg+IuLAG3b2MlBN+67zp2ml+bWIxU7j33sGYA
   w==;
X-CSE-ConnectionGUID: ra3r/wikQ1WORw8V8LW1MA==
X-CSE-MsgGUID: Ui6A9SnlRB+0Vf0UhV1X4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62817955"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="62817955"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 11:40:44 -0700
X-CSE-ConnectionGUID: mFv0inWKSeaGLifk68vNxg==
X-CSE-MsgGUID: CSP4takMQ/uBani47WVZ8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="189744815"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 11:40:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 11:40:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 11:40:44 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.12)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 11:40:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ckhGYUePXuDtjO97O5stuF2t4/kBNuDZNB0pF+mDnNdE2A/MFuADN4hEtiq0CUJE5RCbnsKbTJ9i9rCDVwHGYiWMU9PN/fBKTZZeN4Vx73Iu3Mgt16D+3yn0l8O1NEYZS7RdK83Tijg5M1kPNRHxw5j2cYRSLUq/iwot/iwEMRKOHqs4kKuqNOVFTbhTwYFAfZ00a9+bzO67qHItE6SemL1ooYae0aXfvJYbGhPjVzdlMPJtWaEyKmu4RtEujxF1jEngOC66tTcFvjYQsApZcF5sjX9zcOtaxwpWHZGrtbi7Tzn67UO3UyFXA0P36DadnJPauMJF9TAFvQy/OPbpZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxOGa1naTFBzgpFlqZFNezPimY6ysSnlSFJMGc1F2MQ=;
 b=L7g1D48OchfXb5K2mXWDWgji/yicRPnLYAOQgNqfs01jkjCc2BPLyBcj90lUd2Lu296+6p98S+qb5C3NnzfjHn9zIEMa3MTC/cfURu7h34OCPBFY3WERH5FfMhvUcbh/xiw3k07elsTxBem9KAodNvG5kcVhoDYIU0NKqPtW822Ygw64YwnJBlnYAHoupG5VLkezaqEl1UXSrGcghE0Tw4sJ9+kIXwjk47GvGWzY2e41KGDlCLvKHtAASfoxEYblsOeDq+iZF6HcPStZw/HZZ3Ygxm/Kc72R4FjjF5OWkvWKdFu267FtOfltylT7U/ppVNQXBDAE6s8fU5iS/EwMJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH0PR11MB8165.namprd11.prod.outlook.com (2603:10b6:610:18e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 18:40:41 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 18:40:38 +0000
Date: Tue, 28 Oct 2025 11:40:33 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 20/31] fs/resctrl: Refactor mkdir_mondata_subdir()
Message-ID: <aQEOIfMFo1Dqv-sP@agluck-desk3>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-21-tony.luck@intel.com>
 <4bcb8320-687f-4c43-b4b7-150d503b9890@intel.com>
 <aP_5eW_GHwXebeyq@agluck-desk3>
 <b4921b96-3f86-45d8-a353-471c8f20e2b1@intel.com>
 <aQD560ppyTDob_Wd@agluck-desk3>
 <820cd2b6-b71b-435b-bc67-c35318f869e2@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <820cd2b6-b71b-435b-bc67-c35318f869e2@intel.com>
X-ClientProxiedBy: BY3PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:217::9) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CH0PR11MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bf86c7c-f330-4ae3-b302-08de16517c36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?k8lW0W7U2QzeudO8Wc6Wi//pAGbOY49r0RIqSdWUatGwfvTExhRpm5n+BEoQ?=
 =?us-ascii?Q?8JpaUg16+MD1QSPKYxEgmjLeXxt5WvBqVVZXYnhEcz7g3rWu+Gf7LmeYbOxI?=
 =?us-ascii?Q?2l48ST97BdRFNci8VndavLdweZnDbH9hwI/ZyTQvmmBfBGtEYuVGxxfYwG3X?=
 =?us-ascii?Q?I3632l4IRh+w3SKrD/NelcrBwLXRA/TdWtlulY7gEt/cMQRHfdAejzb87Uys?=
 =?us-ascii?Q?lRQaTMssiTKCNQBoRhqC9oX8q70KthfVNKRmYDrRUYUzeCo+x1C3gzXZhZSj?=
 =?us-ascii?Q?ad6YCEPxtqYxMeCXwjYrW0FYpQPZJQtKDDGgei+DKK9T7cAOmDX7ez0rdidn?=
 =?us-ascii?Q?aceU9mzcnMSC+SnlWfu/CaFK3qJ1GmetDsYkKrAA0l+fqgiEtWMpHVVoHz2C?=
 =?us-ascii?Q?VHVYiV5lSZP0dHCV+hKM1uPhpPMPO/4gIg4u2M0LClyFkroitnVQxP3/mRSS?=
 =?us-ascii?Q?NC9BmnTdlVhCqSCMa5VkFBILCDbCHu4N1cSCG80Gn8mATO9c3HfgmLdVY5H3?=
 =?us-ascii?Q?hDdDYqgumbxp7obj9VCt/VTghn3Kqg44xDpM/nEbSUFN0RP1OBIwJJLNDpUu?=
 =?us-ascii?Q?1q2ky0LX87Tbt8SZVRwUbeT8CUfYxC051vAGRm/OaOtHWK1QnIGUFQi+7Z6L?=
 =?us-ascii?Q?LMDpMfuZ+pJ4KZg3CvH8i7Kc5PizJpE75acsHniJVEsTpOoWO9nOmfjQITGb?=
 =?us-ascii?Q?TSfhCfBBSBjQ4O7ktQE4qj0UMs/9uyjncV4hoz9Know9byIKAoRdm2fEjlbv?=
 =?us-ascii?Q?ScBfmTJyDj+fYMPvJ15w2O9GWcSamdfp/5JDXDjVwOtsJa1GDQewQRD99d1y?=
 =?us-ascii?Q?k5/ABg0trXmUT05vlSU9kesC1jz4z5viesYF+S8rlIJDuordQ/iCRPwjUGVx?=
 =?us-ascii?Q?x18kMRKZV0pRkg0nkrrzgtsP4rPhhgpyE/mOfqgOQTT3qmpbXLi8hyP7rwEZ?=
 =?us-ascii?Q?KtMQSkOWVE+K18qkffPLq/nu7DOY3JrO0fS11Z/KBjnYUgRB1pL2GgGShpr/?=
 =?us-ascii?Q?rUaDOooNb3BMeCO7remFwfAhuzKGdJJ5XdFsToZvo07BCmoX0C7YTAD834cU?=
 =?us-ascii?Q?QtJqDmjuB1vVIHgI0zoxoOAPx/tugtyS7pz3QLb61vsxpy2SLdAAzJ/STTIQ?=
 =?us-ascii?Q?tNlf/5KmBjK2VlGbkp/wkT5tW7fvM15FJzDjJTCq9dkBErkqoYLxFQNudF8T?=
 =?us-ascii?Q?vkraNPaeb/6yy1p5bSfe7/p3K2PEEILe2nTEGQxUQsPYufPFAmzm2E+rKWpn?=
 =?us-ascii?Q?xIRJTg45wU9U5cmLkEA79TC16gV43PBY87tj91te0p7/XVPM3Ae7eMdOgEZ8?=
 =?us-ascii?Q?RnChGMwcS0/W5MOmKQruGNV3fWYWjtHUOpNQFl+1Nwbod65+zMFcdcDPq0gD?=
 =?us-ascii?Q?9mMMWVBXcYYoYOEkYJHHlP0I/YvFx0aOe7pMZSAocC5lA/4hgTaOl4zN1hDI?=
 =?us-ascii?Q?xyMCM8beRmZfQ9NHQgpmn2Lw5DQPYz/w?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k9IZecp/3+Qu5XVGX7M7ua9F6TsG3XMLWGRe9pFcG7Mm/2EcmekQq7tkpQuo?=
 =?us-ascii?Q?Luv7KaO0iAyU4SxoKvcJMci1xFrCb9YxUAr29tuKXDPV+o1NWHdtkdocoeGK?=
 =?us-ascii?Q?AYZZxcOb5luctDbYtQXJGS0HKd8DCvDxciNqXcew4ebha6o4VpzphcEhB/Qh?=
 =?us-ascii?Q?zDYQ33GsZ58dOBGsdhbLJXrp7RAfTmPBC3RoXUIPy4n9HqiAiihFp7XO+fFJ?=
 =?us-ascii?Q?tvPPjIOw4PSt9t2sjvjkW0X/aL8tQPnFoE5BihKkiVkUXm5ASoyF9339+X0G?=
 =?us-ascii?Q?BH07V5tlEc2Xl6H74vKF5lSJIEZQhxtmCGy1IyVudAcTV5JyBIDM9rS7vO0s?=
 =?us-ascii?Q?s/gXtHuBP6LUkIItuXP4T77xKZwSuK2eXl2h64ewTFqOLbcOK3inWyCTUw7a?=
 =?us-ascii?Q?OChNDI7tgsVkkrcmWe/tO/Uu44ZqkCulu9LGPtMnB/Uv2Bn6gKyeBY/BnvYU?=
 =?us-ascii?Q?CpxjSL2g/TNPD9ysc5cJs5f8hpHebi+bgDX91CUKy3DXT0okofF5d9QJ1vOV?=
 =?us-ascii?Q?XSIHVAVr1jmpXBLAWXuaW+bVbenc4h3VVnxS1of/0Uv2xDJ+J461gxkG/aRD?=
 =?us-ascii?Q?/GTpjonCGMOGGV8K6gnGDvsb6NEZ0YqVxbfqKAcPZcCZ+Qg4F7fj5NTTr5Gh?=
 =?us-ascii?Q?8AWcsZC42sifM+8V2Ig+U7jYPO+K5pOu4BYcBTJjwuGyFsXWVuqtlYizHvnQ?=
 =?us-ascii?Q?3stBTAGFUJAPHRJmUfEFRApytAewkjT2GZMnPZoamUHoFN0XMVN0Gf68ndzi?=
 =?us-ascii?Q?/42CZNNFC1WCvzB+Kx+rDxkkhohrI8YqCNH+GkqSni66t2zwRL2dpAkzF8VG?=
 =?us-ascii?Q?9DaeC80SRkZuhPIW4veHb/a0dCHETKedKAuyZEtriYULuKHvXY67t5ltdkmB?=
 =?us-ascii?Q?sdbDUxbsv5q4UDwJs6K8pPL4aYVBEbNzn/dbCw1EORB3gpo7dgzQlVSG/RRv?=
 =?us-ascii?Q?n0e4UU0/qQqvOhVBSfq6u1Zo8rpdPQvlZwrSfG9c1kyyNo/1eQfTPgcF9JjT?=
 =?us-ascii?Q?LYUl3NdB1I0rVszbYAOMcnTz3zxWDc0RdUGxD5dQwVK6FMSWgtmcL9jBZdeN?=
 =?us-ascii?Q?HLkXK7fqiAtYnTDPQL/g9c9obCDbNoYu8xqsLGBHxiAxeL9Y0ypBwxWh/5Bj?=
 =?us-ascii?Q?7IASW2P1s9/42uT+3li0cQNhyLPI+QgRg+0SKcjSlgDJKJqQqBljtEqIPZpP?=
 =?us-ascii?Q?sc8Z5Vfa8+SRtcBsQSfd33vqPlGwJxW1wsgjmsn8D7WJ5sY5Ozwnq9obWrKW?=
 =?us-ascii?Q?OPBK4XvQ/4VLfaSZArHan3xT4XrqdZN/sezfIdAHWsYJTc+lsTysbWmT009G?=
 =?us-ascii?Q?Lp7gW/IJ2T8UbcTwMJReSlzE/TShHDp36s2h5akIac8jZs7Yud/17+R9MHhL?=
 =?us-ascii?Q?RcVwFc50fkfBEGu5p+8sK1xZEoKq7qcxmGovFyt/OdraaslgKIjVqTwnV6HH?=
 =?us-ascii?Q?7UwO9qiksu1j79NXAwpdFv2BnmuSrEIY1mnKmXJWqyJHYC5mTS1ze2RPshMo?=
 =?us-ascii?Q?+p+SX/9Z1gjwp+R4LN0Z6lWxbFseFLhxKnKaNYf9K7NuMBAEI2QGKe6gpSE4?=
 =?us-ascii?Q?hoFVaf9A4E2SsLuavUVMSSTG7MrXmVaML2UD+Hu0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf86c7c-f330-4ae3-b302-08de16517c36
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 18:40:37.9524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +m3ozWXJ4JYj+2C2XZFRyp1pvLGWlHFTb/TsfzDbfvUrl1lhr/vpBuQN3IKYLEI+ASzNX608W0JTtgUgWWlotw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8165
X-OriginatorOrg: intel.com

On Tue, Oct 28, 2025 at 10:40:44AM -0700, Reinette Chatre wrote:
> Modifying mon_add_all_files() sounds good. I assume the node activation (kernfs_active())
> will still be done by the caller which would have this new function return a struct kernfs_node *?
> If so, I think it will make code easier to read if name implies that a new kn is created.
> Since the caller is already mkdir_mondata_subdir(), what do you think of _mkdir_mondata_subdir()?

Reinette,

This section of fs/resctrl/rdtgroup.c now looks like this. Call sites
are now free of duplicated code. Thanks for the nudge to do this.

-Tony

---

/*
 * Create a directory for a domain and populate it with monitor files.
 */
static struct kernfs_node *_mkdir_mondata_subdir(struct kernfs_node *parent_kn, char *name,
						 struct rdt_domain_hdr *hdr,
						 struct rdt_resource *r,
						 struct rdtgroup *prgrp, int domid)
{
	struct rmid_read rr = {0};
	struct kernfs_node *kn;
	struct mon_data *priv;
	struct mon_evt *mevt;
	int ret;

	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
	if (IS_ERR(kn))
		return kn;

	ret = rdtgroup_kn_set_ugid(kn);
	if (ret)
		goto out_destroy;

	for_each_mon_event(mevt) {
		if (mevt->rid != r->rid || !mevt->enabled)
			continue;
		priv = mon_get_kn_priv(r->rid, domid, mevt, !hdr);
		if (WARN_ON_ONCE(!priv)) {
			ret = -EINVAL;
			goto out_destroy;
		}

		ret = mon_addfile(kn, mevt->name, priv);
		if (ret)
			goto out_destroy;

		if (hdr && resctrl_is_mbm_event(mevt->evtid))
			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
	}

	return kn;
out_destroy:
	kernfs_remove(kn);
	return ERR_PTR(ret);
}

static int mkdir_mondata_subdir_snc(struct kernfs_node *parent_kn,
				    struct rdt_domain_hdr *hdr,
				    struct rdt_resource *r, struct rdtgroup *prgrp)
{
	struct kernfs_node *ckn, *kn;
	struct rdt_l3_mon_domain *d;
	char name[32];

	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
		return -EINVAL;

	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
	kn = kernfs_find_and_get(parent_kn, name);
	if (kn) {
		/*
		 * rdtgroup_mutex will prevent this directory from being
		 * removed. No need to keep this hold.
		 */
		kernfs_put(kn);
	} else {
		kn = _mkdir_mondata_subdir(parent_kn, name, NULL, r, prgrp, d->ci_id);
		if (IS_ERR(kn))
			return PTR_ERR(kn);
	}

	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
	ckn = _mkdir_mondata_subdir(kn, name, hdr, r, prgrp, hdr->id);
	if (IS_ERR(ckn)) {
		kernfs_remove(kn);
		return PTR_ERR(ckn);
	}

	kernfs_activate(kn);
	return 0;
}

static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
				struct rdt_domain_hdr *hdr,
				struct rdt_resource *r, struct rdtgroup *prgrp)
{
	struct kernfs_node *kn;
	char name[32];

	lockdep_assert_held(&rdtgroup_mutex);

	if (r->rid == RDT_RESOURCE_L3 && r->mon_scope == RESCTRL_L3_NODE)
		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);

	sprintf(name, "mon_%s_%02d", r->name, hdr->id);
	kn = _mkdir_mondata_subdir(parent_kn, name, hdr, r, prgrp, hdr->id);
	if (IS_ERR(kn))
		return PTR_ERR(kn);

	kernfs_activate(kn);
	return 0;
}
