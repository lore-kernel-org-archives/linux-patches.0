Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818BE149E17
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761193138; cv=fail; b=eo4GR9awRd6JA8pq7hZrP+XBDvyAbeKkUeVeNoM3RYVPxX8tzKchv3Ad0f9y/0+oiKakjSqhlc2lM+BQOU2cr0lEE5YOv6XYLNydZR/sB2/tSAtwgWxOA/1B0937YTCgLVzp+P1HAecpcPRvCWl7QBWjOHWmdWrrUY5E9OAAEmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761193138; c=relaxed/simple;
	bh=0e6BDcUfMycwede2ofjq0msvUcMsa10HicMOYcSpIgA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Om8n0I3gyUCF0WbC0suCGNi7/hewOXTgVsoZeo/2ggHf77t9+Th4ykTet9UJYoV5S9mZuQqizgs7hFHzWEQFimF1at1ciOSX0qo/m90W76cZM2l2i78tuBvwKXKHHoMmx/eJwl0QkNddeaO8PKB0rjZ1vk+psJcIkL9Qahix/VY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AyCKBTB9; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AyCKBTB9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761193136; x=1792729136;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0e6BDcUfMycwede2ofjq0msvUcMsa10HicMOYcSpIgA=;
  b=AyCKBTB9kwAYVjYIG+kEs6Rg717tClZq4ZcRAhojAgrh0Oyy/nhfnrlR
   /L4AdwkTBpB17p846x7CwpO+fqx7C4sA/3VnzZzQqJs/IZkq4uj06EYI7
   vQqGKG/lfu0+ndWM3qAgs2VvE20sNEddA8r+yuksd/8yvP0qhjBqATBi6
   F2km1S67ot7e58PPkPiO+7Z+XtUjqNxEVthTVMW9DdA05O55Bc822B0Ow
   9EZOnntS9NVPJl7rkQhFVxgE1RlTCjZGLEfxBHUh2zxfthkOTmV0hqZj6
   iF8fpasTFzIotoowoNXE8yCg+vz7rvNO2YspFO3ibu1nfvYdzYCqUK5GH
   Q==;
X-CSE-ConnectionGUID: MDg57mPUR9ms6cRjM5q4PQ==
X-CSE-MsgGUID: tVPOqYH0RlCnVyMXVA7Ebw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74699265"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="74699265"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:18:56 -0700
X-CSE-ConnectionGUID: xhhsdoYMQS+1kqAqaQlnIw==
X-CSE-MsgGUID: jZCVRHfxQOyAXfecGC8PTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="189177988"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:18:54 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:18:55 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:18:55 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.17) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:18:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I/bLNH95gbbqn6f1mDqZ/tWvz+fr3pEPkskUdQJ/MTXdjYuwRp/0+9ObqAYxY6TBxcSEwO9sTGuX2nU9pfCVW6MLH9t7XEBINjDqewUCD9ElMBuDTjL0AAP+La//vTQyyCbFB35GUkKs//0ozqbHRQGanINskvzVfzob2curIkakZkWiL9mO27uOJnBMyV2/7Ed/fDR4tauAK2R+K/FF09JPHYC80um9inC9oFCSTLGuRemfln8pOLdVrr1bsHpNIuBGygKoId3UtQiWbdndrOTsddouuuZhFSIvF84l6MgF8mtPKkl4wyolYXv+yXuhycoU/yurX12CuXOsIRlknA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eycxYI1YH28Gx+rLFRMPC6xBkyr9uBO3H4uqrRtraT0=;
 b=f7gVmhp2TeiMi/pLXjRVRE8qqKsfciCSN8FLK6BpvURtTWnl7A2sJBGa/xoXC3D+nl5su9oz9L8XHOR4JS06hcUHceQFM+yxmAi7iytX4h5WTstS86CESyVDsl6JSdbyTw6qwP8lGd5BHczJWkJ+ivjFVoIRhlm8oW6VvRXvjPz9GiyonLmUrC7XU6w9VlgFwuOE7/bdDsnKJHr9fvYRdwRtkY490UqtCIMuewyPEdduJFe6ia8piTbJuNT8HjJJsxyQBS49j2WdvRl4NIqWhsmKEW20h7ZBcvl71k58D2MC4EKxj5nOwWjmmByOWe0AoLNt6RQAopbLqv1HDQXJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB5965.namprd11.prod.outlook.com (2603:10b6:8:70::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:18:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:18:53 +0000
Message-ID: <0b9d5e86-b858-4fce-adc2-e5adae25e775@intel.com>
Date: Wed, 22 Oct 2025 21:18:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 07/31] x86,fs/resctrl: Rename struct rdt_mon_domain
 and rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0342.namprd03.prod.outlook.com
 (2603:10b6:303:dc::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 119237a8-14d4-4ff7-2e45-08de11eb467c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UnFoenVlNCtrblRWa09sWkNjbUZyTVdSV05lOUpISFJLbkxPaFZNMWFjT3U2?=
 =?utf-8?B?Y3FGUkx0eUhtbEh2dmxKa0h0VW5kUTVyQzhobVFDY1RhS1FGWXJjbkljb3Nx?=
 =?utf-8?B?VmQ2cVJkejh0a29xbGJPcmR2djlpNnZBbkdUWFlLY2lXdE5TV1RucTg3cG5P?=
 =?utf-8?B?RW9NN2t6RXA1SXB0UDJDZFpjRGJucUk3bGxmQTBFTVVIVE42YXF3MmtKTW8y?=
 =?utf-8?B?ZUp2blZvaUQzbFhXSlV0aTRHNkdwQlhuVUVjUE4vUlc3emFnYk1MSnJHMFRY?=
 =?utf-8?B?dDZiUGt1d25KWTJzaS90a3NnVzZlMFFqMWFzTXNmZmxIZ1Q0ZHVRSU50Ync3?=
 =?utf-8?B?RHQvRTljUEh5NE9BWFFmelJIM1g5STFIa3k0SVNxbEVHQk9nR3RLMi8rckla?=
 =?utf-8?B?aHA5QU8rN3VqZ0NZZXZQZGRvbWJkVzV2Q3M0NzQ3alRDU0MvdzkveUJYVzEv?=
 =?utf-8?B?UlIyU3FaY1VqOEJMZXNNdk5EVVFVM0Q1VUVSUzR4eHgwL1UzMFdJRnhsdlA3?=
 =?utf-8?B?SmhpOExEanU0cUlMOXFDeC9XQkcvSklWdG5qMk96M1REOWZLTVRTTktiVzQ4?=
 =?utf-8?B?b1RhU3g3MTNTNEt0K3k3d3JiblNMOG5KY2JuR0hQTVBOeGRhVTR4U3RLd3lj?=
 =?utf-8?B?ckRabjhqcExLTm0vRS9xZDFqeTBxVllManNzYmZiK0k5dnR2cDZ1SDRYWWN3?=
 =?utf-8?B?TWJ6SmNweWNIN0tqNy9qb0hMeXRWS1Badmp6c3JNVFVRZ2R1elB1VjYzZm5K?=
 =?utf-8?B?cncvRCtOcjlFL1VVcjhnYVdoNTdWY1NHczZyM2pCaU1oTVRFdlhQYUFGMW9B?=
 =?utf-8?B?Ykx6UjZWK29rRGM3M3M1WGZ5dG5wQVRQczVZMFZkRlZwdWtYcEt6MEhicWpD?=
 =?utf-8?B?bExtZExKNU5KNWdXREt3a3FCcy9zSkc5bzJTMTNFb2RIODY4dENBbkRVd0tt?=
 =?utf-8?B?NHpnTC9VbHV6T3UzR0FLZk1QaGJWbVV1R05kbmk0R3IxVzF0RTNkSjN2eEQ4?=
 =?utf-8?B?R0IrVENmVWxKUWEyS01JMGJGRC9HZEZ4RlhveDVoTWN1S2l2ZG9vUHRCeDNm?=
 =?utf-8?B?ZjVsKzN3VDE2U2JkbFEwam92dSsyNE41bVZ1cDcwdFpQaUVkVk12WG5tMDFu?=
 =?utf-8?B?eHJxWktiQ2hYZ0M1bnNTbnR4TTRhNEZDaXhlTVAzSXVkejF5aWVUSlB1d3RZ?=
 =?utf-8?B?aDhsUzNrTFl6eXdxV2lDYVFLYXZxbytsTXdJQXFwdDNWOXJtaERzeGpwY0pX?=
 =?utf-8?B?VmlIMVQyd3A2azFQaGFHTjNoUzltYXRwQ2FWVkNXK1NMSTlLbEYwQ1NudG1x?=
 =?utf-8?B?UjVianF5TCtZRW9aclJMeWJJMytJVGMycXFaeWsyS3ZsZXNzSXMyTWJYNTU0?=
 =?utf-8?B?MzN6LzRGeE0wYWxuSUlxaUtLRVRSRW9Nc09ka2YrOWVYc2hLWE9kN3VGR0l3?=
 =?utf-8?B?UXprSExrTmFsZzI0NEdSa0xvenFQV1JiOUF2RXdtRldrbzRla2tZMmE4YU8r?=
 =?utf-8?B?OFBVcjk0Wm9hMHJkZG5ibnByM2o5V0Y5aDlCWURpaWxWOUJZWFYxeXEzQzlP?=
 =?utf-8?B?YzBNWWc4RkplZkcrUjUzaUlaNmphTzdXbUhOZnJrQ2xsbWxHRUN4WWJVcFZN?=
 =?utf-8?B?S1RVTFpXNzByQnNadWExemJaeHpYc3ZaZFJEK1duSkVmMWVqWGp2UDdtcVg5?=
 =?utf-8?B?YXhQM0duRXEwdDE3NXJTbThYRk9BY1pTV002YlBtVzI0cFk3eFJsQVIvTEkv?=
 =?utf-8?B?amRYTnNkMmRleTljR3Vjd3c4ZnFGaWtEci9YQlQzdG5BSlNPZXhBYXVSTkUr?=
 =?utf-8?B?elBrNXR3cjJBYkFJLzV5dE9kekZDNmlZZitUSEs5YmN5YzVtVTZYN0pneDFq?=
 =?utf-8?B?WVJPT3RUdlVNcm00NmY0QVRaek05cFIyVno5dFM2Zi9lZjAzNWJOWFBhT3hF?=
 =?utf-8?Q?0a7tDrK+wbWhvBJZb5brW9StE7tPwGxN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2xnUGsyNktkOWtIZG1KK2gzSkpqR0g2cnlQNG5pVHNYQmw3dDlicXRKUDQ4?=
 =?utf-8?B?THFlOWdqYURLYXl5Q0pBVGVpOFNFdHlLcTFxVGVQTXEzYm1uL2UzaGtXL3M3?=
 =?utf-8?B?ejB3UHdOdGVvS0R6dHhxOEdSOWQzK2JZSmtwRk94OGc0VE5JQXNPckp0Tm5v?=
 =?utf-8?B?dkpuQ3c5NEVuSTNxWTVwclVJY094UzdJUkxYS3Y4TGdUdGhTM2tJZ0M2UTRs?=
 =?utf-8?B?RTBkMlhJVVcrazZBMjd5QWQvQmFKRC9VZGVHM0FDVEVqVHM0c3c2Wm5kTS9n?=
 =?utf-8?B?RzFDMG1idTFYMHNmTm1QSXU5QTJ0ZDhkRVpvWnpXb0FhMnZpVmV2OWJpVGdD?=
 =?utf-8?B?WjRiRjJONGlRWE5ESS9xZHIvcDU5Q3lMcjNmajBhaFgyV2s5cXlxc2NJcXBE?=
 =?utf-8?B?V1JWcjRLRVhDSENFM1NubmY5bDRWOHVMYlRoT0U2blNWVmVaQVlGQ1dYaGU2?=
 =?utf-8?B?eU52VG9TK0pSZ3lwdnRvRHRvMGtiM0F0QmRWR3o4RDFyTXVQd1hvSFhvVFZU?=
 =?utf-8?B?UmZxOFI2ZkFqd051YnRydmREZ1pnZFI1aXdpQ3NpUXFud1Y0aGlJVlRUT3Zz?=
 =?utf-8?B?ckxnWU13WHpMODJjRWk4eWdzb0c0dFpXNkIycGtFNGEvZmJydTVwL0xzRThl?=
 =?utf-8?B?RjRQZ3dyZy9pbU1oWGQvUW5zOUprUUw5d2tRT1dLK2VMZkxRZEs2YkVwOHEw?=
 =?utf-8?B?bUtaWHBubGZGanZOUFcrUG9TSzBHZWlYVnY2Vk5yeFpKUC9HQXRVejZiNjlG?=
 =?utf-8?B?RW1QYVNQdFNrQmluTWg1WjRxQWdoMnFnTzI0eUhOaWFSdjdjM0dZV1NaQ0ZE?=
 =?utf-8?B?RDExaXZaVHUwV1pOWmRPZm9KeElrSEtpeVFKRlRNTmp2T1loOTNoYlZjSndu?=
 =?utf-8?B?QXBURG1EL2FEaU1KTE0rTUpoVmp6YklFNEtrSXFmVDhtWVd5SUVNMXV6d0Vr?=
 =?utf-8?B?LzJpQ0hHb1c1NUlucmpnaVFlMmVDUFJDY1Vob2dyK25OZTVpSDVBeEsxUUYv?=
 =?utf-8?B?eDljV1dBam1GZ1BoYXd2dFBSZmJ1V05PYUozY2R4azVEMXVEOW5lTmlIcU1w?=
 =?utf-8?B?YWVISE4zQ09ocGhHSHNXNFo2eE5qOEd3QWNNM1dQNmQ2SUNrV011SWM0aDhV?=
 =?utf-8?B?YlJMWVhEZjc2b3JsQi9aaU5Eek5yaytMZzFvRTY0NEd0QUFhQVN5WFFIZzNU?=
 =?utf-8?B?M2grV1BBb253TmNycjg2ZmNGWVphU3I3bkFOZ3ZIMnZlL1dpbC9kaHk4VStU?=
 =?utf-8?B?YURXMjVMaXBEYW04ZGlSdTZLSFVmMWRKMXJDSzdCZXI1bmtXVk9TeGFSaEtQ?=
 =?utf-8?B?eXAvalZ2WEoxRmtHdkl1UDNiVXROL0N3Z0MwWVBxOXVIQm1MSFd3U1M1NXZ5?=
 =?utf-8?B?WGZKU00yVml6OEloNUlMYVlwbFJxL3oxc0t0d042RVVXVnpjYVIzYVdIT01t?=
 =?utf-8?B?UWc2Zmpzd2xCNlVXb25hQ3VDMWowMnlBNXdGS1QvaDB5SjBaL3pGTmFyblMv?=
 =?utf-8?B?Q05rVm54RjJtZnV6OTN5SitHL1lHUUt2d1ZvYnJiK1hRNUZRRTAzN3EwaENS?=
 =?utf-8?B?RjZONVl1bzlvZjZtRFBEbFR1enh0VWo2Wk8vUDU5NGd4WnhNSFg3dmZ4RjA2?=
 =?utf-8?B?R3BSajVUbUlXS2lMZklLTlM4bEEvSEJMU3ZhOVNRMFRRRzJ4S2dYMW02aEpG?=
 =?utf-8?B?cVFENVNOZDR4dG0ybGRyTjBlTlMveExXbm1JUEFsVXMxMlltTWRLcFhDYTB4?=
 =?utf-8?B?VWVlSkwzRjdXeFVHN2ZOOHJqQmZZS0NhNmVZdG1VWjVPNnJLeUdzYnhCU3p0?=
 =?utf-8?B?NG9CeFV3dXM4ZEN3RDNEMSttMFlpU3ZkY1FLOGE3OTh1cys1RlRDalFsWUpq?=
 =?utf-8?B?OEZqbVp5RXJ6Sy9CQ3Y3R3EzbmpwNDJ2SHd2MFJXQVpyam5ocjlyZFMzcndV?=
 =?utf-8?B?NVlsekNiNTJlVFJsZFBCeHQ5aEovbFZDNnhvYjhlTWFsSWRqYXJFaDNMK3dX?=
 =?utf-8?B?Y2ljTzJvYVRtNEovZlVJN3ByTWhQeVlFMmYxY2ZEcDhDTHRUMk5rTFp1aGwv?=
 =?utf-8?B?QWZOSU0rM28xODZSMjNRU2NkeHFkUHk2MkN2bGlrdFVnOEw2YlNQSFZtaDdt?=
 =?utf-8?B?OGhsVVZDcFlpV0dMSXcxSGxBK0h2VmdzQkM0Rnh6OXZva1JvR2tad00rczEx?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 119237a8-14d4-4ff7-2e45-08de11eb467c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:18:53.1803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: temULc20khBvpC/53ob6U4WxAIYQULnbM7qKsFGPjylGLJ6z4AvDoKQElW9hKyF5kNNWHRkHvdpDFelhuvQ/k7xZbsppUBPZeMQhaC7X7fY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5965
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> The upcoming telemetry event monitoring are not tied to the L3
> resource and will have a new domain structures.
> 
> Rename the L3 resource specific domain data structures to include
> "l3_" in their names to avoid confusion between the different
> resource specific domain structures:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Some style hiccups with the changes added since the RB tag:

...

> @@ -242,9 +242,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
>  			   u64 *val, void *ignored)
>  {
> -	struct rdt_hw_mon_domain *hw_dom;
> +	struct rdt_hw_l3_mon_domain *hw_dom;
>  	struct arch_mbm_state *am;
> -	struct rdt_mon_domain *d;
> +	struct rdt_l3_mon_domain *d;

This is a new hunk and it needs to change to maintain reverse fir order.

>  	u64 msr_val;
>  	u32 prmid;
>  	int cpu;

...

> @@ -3194,7 +3194,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>  			     bool do_sum)
>  {
>  	struct rmid_read rr = {0};
> -	struct rdt_mon_domain *d;
> +	struct rdt_l3_mon_domain *d;
>  	struct mon_data *priv;
>  	struct mon_evt *mevt;
>  	int ret, domid;

Another new hunk that needs to change to maintain reverse fir order.

Reinette

