Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9408A285CB6
	for <patches@lists.linux.dev>; Tue, 30 Jun 2026 21:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782856076; cv=fail; b=SGvmE9dbF7aAzu3t29eeFTAN6PA1OQf16DvFaV2YNA4xOHYflhamfqVzh/cXZ/N2WywFYHMxg++RoNOx7biNScTADCDa+Z/3h+GHKPKm43/iKkrB7NUsOGW270VsYws21UobekYtx6k5Tkw8gQXAL/9OrxvgO4vXxF/OoOmgCks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782856076; c=relaxed/simple;
	bh=DqMMxHSdopTrF8Uw4KZlxQG4+3nYEOOJb/H8/VWEUFw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a7AHUR2yy0voemBna7CUwAlnCo+sUBJubJJEqPJJp471DBQznZv84CrpJHGNQuMs3Cab9tPMlos9PlgUJnh/fGYU6d2SLDkBTGKKBj7lttIrnDGxd5uxG1DSw8rGWU9fWzdSVcor+2QGNuBwQdbyJm8feXuI0xk5zLE977gadd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XBzbB/mr; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XBzbB/mr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782856075; x=1814392075;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DqMMxHSdopTrF8Uw4KZlxQG4+3nYEOOJb/H8/VWEUFw=;
  b=XBzbB/mr5PwZ92GxDOrBRY1vVWGwUMK3iQYnWV0zoTIydH+ZpJIZE9VF
   DQ/wQ/ISP1wZjOfwszVqSzo4jFKLOodcKgOcsE5JBOwWu25bzQ/8TNEq1
   8WX2XFF6lCv1COttT8U/3sGKfMuIqro1UoCilivCe6w9d6KmKYDY6SwgF
   jEkgzgBdN3FhuTDIgO1YeBG41JIzFOWMpBc0nB7ZhadC8O1LMChWNdWZr
   YoUThpm11mASbRJj95WDFIMCA51BCGkPcXxjOqW22pk5OuiD9GrPa75ht
   t7xyrhBSRESKPPqd4K9qhFRuCB8T24wi6BD/9W3hFEfPudf+x2pr/7gnC
   g==;
X-CSE-ConnectionGUID: xZt92io5T3OmUAot4vVjhA==
X-CSE-MsgGUID: XJV9Q14dQ5Suz3LttIgrfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83355779"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="83355779"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 14:47:54 -0700
X-CSE-ConnectionGUID: bbTqyy5GSW+4z0zFwRDQyA==
X-CSE-MsgGUID: OblKK3b6RqCYtQoXE3isWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="248392154"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 14:47:54 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 14:47:53 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 30 Jun 2026 14:47:53 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.5) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 14:47:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxYCZAl96PO58U4UEpv8UBkdPg1kBAXeezjdrtGUw+BENAI7pmDDhG+L8PtQz6+94NtBCls4wA9MDxf1Jv0p2L9KiIKzo8EgTNgsY3JU+0Z4KqA5CUXTgf2yPUmxOGXjOxvE6hyC2rzW/oIMWcydmeooShlGimW+4OReoN84yoLSG6NzXk9TNefzVe5YX6HTpn6o88reYW+ZJ68bgVpxfnk1X6e/3X3E7BgeSC+ZUV3Z5ODEq2KcHKhQgvCHl03BJAE4s3BiltE1g9zpiLWACyTMP0cXGD+S9La+LxWnmWfUJRor/08nObEHFrmBf6xJfTZ5Z24BSra2NYWgLCIyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRYiKch+y9OfpW7zSAPUByQIkgGo/gPy6Ir2nlD3SKk=;
 b=BKLr2POVJvnkw+ioSouEozYK01FpsY/UqO3GeYup7HbgEYXuY0lcqrNCV19h2gB1F794/H9L394JnFl3Q+sZUJd6D5tKBYjkHRoX1QRBLte+eD1niSwP/Ld/WUUAXoSDusOnWLpJS9UI/Aytz6hsuv2uNSaY/0x0KnQp11RBHd/Q2MdzYo2IXsjJX8OyfmsjHOTPOl0m/Aqqb9JBlsUo9NsnIvT46EC5YrkVqiBW1N7jzsORNMoGUlz31opJVd0gRiCPuA5CfnoXmqIX5gyXFvorjSAy8HitlIx9B30V7/vIBEIkuEb0+ENq117R9PuqzqCCftwCDmQXR16Ai8uJxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ0PR11MB5005.namprd11.prod.outlook.com (2603:10b6:a03:2d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Tue, 30 Jun
 2026 21:47:48 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 21:47:48 +0000
Message-ID: <b58d51c1-67f1-4640-b00a-1a99dc93ccef@intel.com>
Date: Tue, 30 Jun 2026 14:47:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:303:8c::21) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ0PR11MB5005:EE_
X-MS-Office365-Filtering-Correlation-Id: 04099520-9ba7-4047-3dd7-08ded6f139a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|7416014|11063799006|18002099003|56012099006|4143699003|22082099003;
X-Microsoft-Antispam-Message-Info: xmLO7uYSS78ScogcnhV6mn8QXK0J/A42dY2HA13HhFFgEe9sbKdzshweUMDRzCavL27XMojTwk0OX5cbkHaybhPVHwnoijtLCqYbj2uhU8k8D/8qttDYoR3rFgoyqs5PWQsJPmAH/uuPReAnm7JgsvnPdxnE+UnmEI6V3YuKTmgg8L/LMavfw3hLXrTxdFkb5aectKX1oDIiEvJbl3WzDVbxhlOT1oquhMxKdUJuUsD0hIhGIjSFlXAeaZg/3yGgKbQ8fE/HBimAAe+DKksWPmVaeZDU2iRdShQOqUKFa+cnpLKuMdurMitWdBM2KUvNt9B6qSjsLIK1WRtqxIZViObq8R33MkAALmNqTrGEPnFipAHqAkxFo7zl9xC94DXyHizt5gkHfMXLTQYqNi3iF5zrte2uVZSWJvS1NrXyrYeuIwlRW1Zux2J/PX3mRAUZusjx1JjJjbrM1xPTPw3ZHDbttFEDslL7RI36PH5cgRhTw9rN5oLCGPo6fxE0N40tLHnsnOmz7yub/Q3AFxQe4v3Pq/q02ZTEssj+Ut+/fzj13/xEzjCQhWlhC0ZcMHbwCzSbxaHg/cfQQlIp25YznKKaA4KOzlRpoQMfDwMDbLLn3eXIVNYhpJeqSap7CKQjAN6JYJ4FCP/qpxx6muc7rTNCPje1aZJvrSx+eVMEyFM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(7416014)(11063799006)(18002099003)(56012099006)(4143699003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjVVSEQ3V1lGNUkxaDBaa1RTYjJKUzMrdnBHa0Nmbng2Vk81dGszdGFqMXFv?=
 =?utf-8?B?ZTVNSFhWZ2NyZnpMTlYwdGh2Q2FMUFBRMWpsRG54bGRwMkRQalBtYjdNRi9u?=
 =?utf-8?B?WHV3ZmgxbVpMaGh1Qk5EVFgvSEdWZDBXT01FcWZQSTFTemo2UXFjU2p0S1Vt?=
 =?utf-8?B?QTNVQjI3dFBPRWdzNUc2UFZ3U2Z2RG5HOGkyY0kyWVhLVDlSZnVKOXRTRElY?=
 =?utf-8?B?Z2FrY0ZMYjRlR09PWktPYXdPUU1QZktCTTNKMC9JTlhHUnk4TWZmaHJGVTBj?=
 =?utf-8?B?MHBkVTQ0MkRaS1VhVGE1VGtsUVJzRStGY3Q1bkRuMFl0bFFiQlYweGh2dGgx?=
 =?utf-8?B?UVQ0RGxCT1ZpNUdzeWRwSlVsRTZJemFUSjA3U3F6aVU3Mm5ndjRFYWZmWENE?=
 =?utf-8?B?Z29HU1lOSTJLYjlFOGRXN3RTeXN1aFREVUx4OUsvaWI5ZGw3UXlFSVh6bTNt?=
 =?utf-8?B?WWdSZjJlclVKclZKelNKM2phOEVOajQzS1JrYnFiMVQ0dWR2M0Q5VWxjSFV2?=
 =?utf-8?B?RjErdlphK3NlczZvUWppckNQTU1GQTFJQW1XcVhZL1JXaFB4RlYvdUMxM0pm?=
 =?utf-8?B?cU1PQlZNblZJS1NyNDJJMG1Ob1BKaDh2M3kvMnNNN0g1ZEhQTFJjeTNyZWQw?=
 =?utf-8?B?SmV0R21KdUMrNHQrSHgwTHllb2lyY0xVK0R4YU1HSURVUmtlRWcrVWVKR0xF?=
 =?utf-8?B?dFhoV0lnM0t2cW1jQWNHRk5CMTUxem9TVksyZDkyQzNWODJSOFZoSlNZTHk1?=
 =?utf-8?B?RTdHSktsa2t6SkVnc1NYRnR0VDB4NjFuTEdTOFlHbTNqZ2RLd1ZFWmFBendk?=
 =?utf-8?B?T2FvSDJjaHk3bDlvdDNBNU9aQnpjd3o5c3F3SmJVTFZTTlVLTjZvVzBsZWpZ?=
 =?utf-8?B?L3Z6aWg0SmxsaDdseHdKVUczSzMvSHhSSzI3ZXFhMmJkSkVjUlRuYlZBSWlI?=
 =?utf-8?B?ZFJrcG03b1haU2tpMHFEVkFRbS9OV3dFWkhBdzhkMUZsbXI0dGdWbHdRTG5m?=
 =?utf-8?B?T3prQXMrT2J3QkpjMWFFU3JSbnVucE9tdm9xRVVkUDdIMDJHei9QTmhZdW1x?=
 =?utf-8?B?N1hWT3pnc2szemY4MFV5MEhHcVZBVUpWUnlUL3F5YUJtUDFwY3ZCSmphU0xD?=
 =?utf-8?B?NEFOOGg5WFJIRi9iR2ZTcHpKQmdReERkYXEvQjJDWFVBbVhEMjd6dkVNUzJ3?=
 =?utf-8?B?OHZ2Uk5vcFNrelZXTVB2eXlUS3VNOEpXMmpWdGJXdi9nNTFNTHAvSmdqV0di?=
 =?utf-8?B?cTg4VStTMGZMUFN4U1o3eG8vRUhnUXU0ZFcySWJSMkk3STUyWEZYM3d6SDQ3?=
 =?utf-8?B?YkRNZWFBNDFRV1dkRTZLRC9yU0plbGhqdmh3Y3NCYzJmUWRxb1ZHT0xaVXAv?=
 =?utf-8?B?Y2pYb3JKc3c1aVIwY0FVdGdyRGRvT3pEK0tDVm96RjBBQWN3RlIzZWN2Rkt6?=
 =?utf-8?B?SjI1b1FHbERPSTREcytKSlZpZkxGVEp3eisrTTRTTHpOUmpDZXY1NEM0ZUJK?=
 =?utf-8?B?VTFiNGFIQkkzODBwRTV2Sk9Jb2ZsWFljZ2RvOUJPcFZRbmM3cWVDazA3bXRB?=
 =?utf-8?B?ZFArSjdwWlI1SmU0eXlrQmhjRGVNeFFOWWRrSnVKcU43NDdQaXZiWHdZQjhz?=
 =?utf-8?B?eThuTHNkT3R4WXZYMVFIeVB6TUJHR0hPdkltMHNmSGhNNmFYeWZhMDNDV1pZ?=
 =?utf-8?B?dm5ZZ1JKR0tkd2Z5N3l4NjQ0L0JiQnFMUnNJWXVkVE03VmxEUy93YUQ5cG5i?=
 =?utf-8?B?amRjVUprTHBXaDVIUWQwYThtemFsS3VpV3BabGk3cEN0TFBxY0cveVcwL3Fh?=
 =?utf-8?B?YU1GbnJiaHgxSnlZakNZT1VrNFgrYkxpUEUzNzFyWHp3YnYrVStxTUtpYmpK?=
 =?utf-8?B?YldvR3REYTkxbWZSZEEvSnhzaDZWa2Y3QTRQZ2EvRks2Z092Vjlaamp6bFVI?=
 =?utf-8?B?ZkgvM0w3MS9JR1k0c1VXQmMySDFvT1VSb002YU1qL0oxK240MzI4RE5UeWdW?=
 =?utf-8?B?NW5UM2lMSnd0NmVFNFV3bDBQaXZIcmMyUUE5QW9TeHI1T3JGZmxXUWhObUpB?=
 =?utf-8?B?UXlFVHJhVjNoOVN3bVloMUJLTTJJcGxSRUNyU3lBSk9hVHpad21tbGRIOVJi?=
 =?utf-8?B?NStnUDBnSFF4Q2lBd2o0MWtvb0pDR2ZlY21lZHZkUW0vNTNQeDJPN1dkZ3Yz?=
 =?utf-8?B?K0F3MjVGSWRQQWN4RVZqMjNSeGFxVVQveVl2dWZXNXBqdHp3RjRZTTBsaFk3?=
 =?utf-8?B?UmltMVBhL0xyelhqczBOdnFsZFBHWlpWbGphQmppSER4SUpPRlFJM1VYcUNn?=
 =?utf-8?B?Q1NaUFNQaWFEWFRPVEZ0c0NiYlBlempDTzdvNVZoWmtzc09TMHhBaS9SaTUz?=
 =?utf-8?Q?MQ+7F2PRsbX6SYqI=3D?=
X-Exchange-RoutingPolicyChecked: QonwacNOxOmSZYejd8GVFHyT4b7ovahyog+GlYCzIE+aTl0RMPu5v1yhRByWGX7U0ZTYVzCMtoHQ2k9AODvGvVNy/iDFfkz+4VfOjqf0U7NfjKl31kMUQgzXxWl7r0HBL/OAHlQvCIgcmcpbKaMoKzJTypyysf/9w7s2A0/X/5+EnkLzCdtkasb/YLhpONArymBTOrVjWkdnTfIII3PegJUdDV1XWtPOhZKlpA6Aox9H2lTcJxMZGF4tPt2JzTv5R2MJZ3X/Z6JwYIGU5YKdsDEG6ibZKRNjqaNvFXt6AQ1Zbx6hC2vXpufjh4JalJUwoVsJzz7R7YdwzI+zYIwPdw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 04099520-9ba7-4047-3dd7-08ded6f139a8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 21:47:48.2431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwY0mpyVltZ2Y4fwG3JP0fxcIQ4xmKdSCFLSILqxf/uIoGSyi0BMlFedY3ON8hVukI+L/nQN/A1qyQCAT1MWqywwH2pw/SviXw8TXqYk38o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5005
X-OriginatorOrg: intel.com

Hi Boris,

On 6/10/26 12:21 PM, Borislav Petkov wrote:
> On Wed, Jun 10, 2026 at 10:48:06AM -0700, Reinette Chatre wrote:
>> After considering the latest Sashiko feedback and deciding to stop adding
>> new fixes to this series, I do think this series can now be considered as
>> "settled".  If there are no concerns with this series self then I would like
>> to proceed for it to be considered for inclusion.
> 
> Ping me after the merge window pls. They'll have to catch the "next train" as
> it is too late now.
I confirmed that this series applies cleanly on top of v7.2-rc1. Could you please
consider it for inclusion during this cycle?

Thank you very much.

Reinette
