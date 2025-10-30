Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7809831A05E
	for <patches@lists.linux.dev>; Thu, 30 Oct 2025 06:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761804886; cv=fail; b=UkzsS0eApp8BZrH6hqtxW/C7D2BpQV6HvUV1XQ8QPJ+LjI0i+NC+no1QUW/FBTgrTuV1tY5EF29dad1BT73dJTpol/X3wYUG///f38eP2EYne2EAoP76SMWrWc+rVBsUNkC2EG2n4sirwHjUUO5wxxjOj+F9aF8kUg7sCEK8KNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761804886; c=relaxed/simple;
	bh=4TtWgyDu4uOWYsaXfxsdaG/zOFtQpGUgPOND/C8Jcdw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nDYpi2Imfa/g9vbvEmiqhT7RE0TZ/NvkKhMsgWDUfvtnWbNrFnu48Rdy/NsDWLl8/G0xrchUzRrGZjBorOSTsh7jB4CiuOA51WEjq9wDXxZLqb+BSxyiEKUReWCVNvlLRThzqMi0iIOM6X+LGzzqaybPrjjB5wfdoqlSEhSkjWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3OkV7Cu; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3OkV7Cu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761804885; x=1793340885;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4TtWgyDu4uOWYsaXfxsdaG/zOFtQpGUgPOND/C8Jcdw=;
  b=H3OkV7Cuq/nYuR2UjyPsC8OVoIX2vfrxZzr3+GsIGBrAj5HTOPAsVOPx
   y8JXnqSIiEKf6CN3DHQamnknBzRkhAbOzhMSWKxHE4f2T851JvI4B7xSn
   BXVHApNG9dLpxUkifQBIEH/fvU8eRjhrIp4JKrLkc76ctD16WVqSZYex9
   J4W01YgomN3zRF46+9WDCCrZfygYBET60YhxvS1BkB+G8tu5mzo856OHI
   SY2TXWc/oqxmkc8/cx/BlWBssoc+DsuNo4Rm+o9/ldG2U7/DseH7Rq1o6
   iexUX8m9eABp5Gr/L0bWiFRolZ5Ph+R6Uqw7fZAwaUi5gqqPjhcupl+rX
   g==;
X-CSE-ConnectionGUID: CTrGDK+UT4K9P2LRNmQiSg==
X-CSE-MsgGUID: VTAsnvlfQmWIimujEQOMjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63839895"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63839895"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 23:14:44 -0700
X-CSE-ConnectionGUID: WL/mL9DaQiuWTtItYYnzIQ==
X-CSE-MsgGUID: hqHv7xP8RaihmbgxZVfSbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="216527366"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 23:14:44 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 23:14:43 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 29 Oct 2025 23:14:43 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.3) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 23:14:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fLJa4T/lt1B0GyHK/5xrHhTJ1IyCDhDM6d8fDGLV4XXUb+8XkCl/ItjtaN1K763Q0mge9M7xCAMQr9GJp0CuqD4I8NIIinJr36cTNlSNyx/XUhSRuRnBYX4zVbSATfEBNnw+Focn2zuWmn5uHeZHLRS+hDP7b4R/2mords7lODhzCSgqgnTbOL8PC99nEwsXTohZMl6u11PVW0J0iADdT5lhde3bnUAqf0lQ7cOZhmz+mDMtngAyf8OioLXGEbVlxAAdzXg460RZYekfK/2Se5gLT0WD192RjTGxvncfl5YP0axmcMSXqJDCt2a87x08xmOxtg2mvK1IfcbL23TXmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ma9qLcZ/2gTEOEAXwnnHdOVVrKcBXPIGpedQFigO4ho=;
 b=Fl5DsgHgWorDbEA/1yTyWajpOdADTdT/hRwul06bYrJVWAoKWg7t+zVXi1m7fBjgrmHPKTlzW4zYvl8Fcq60ixVWecYdLUYTVDwpiGH1x60xbqqmj08thB1sOveOLiIZ5bfNtCcpLSQtZxvLE+WGCKS/nwtwKksqyR5AqqsCgZniwIlGj1is4OezSm+i+AXS/Yi0oRqkyOPyjHDx6cy1mbvNRZG8fLnyN7Pjty8/74bc5CDVyXZfnQ6bJP+ls4NrFXXsQCLxhqLj1FY3KYteD3BVF5RxUU8buM6MNK24XUsrJR9vfyygqoR4etzPkp/mgTrOyoEZ9g41TX8EcyOrRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 IA3PR11MB9088.namprd11.prod.outlook.com (2603:10b6:208:57a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 06:14:36 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%5]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 06:14:36 +0000
Message-ID: <83f2ae55-46e1-480b-a218-7be679542908@intel.com>
Date: Thu, 30 Oct 2025 14:14:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Reinette Chatre <reinette.chatre@intel.com>,
	"James Morse" <james.morse@arm.com>, Fenghua Yu <fenghuay@nvidia.com>, Dave
 Martin <Dave.Martin@arm.com>, Peter Newman <peternewman@google.com>, Babu
 Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-12-tony.luck@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20251029162118.40604-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0142.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::22) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|IA3PR11MB9088:EE_
X-MS-Office365-Filtering-Correlation-Id: b9d68f56-ed33-4fb1-caec-08de177b99ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YUx5ck5CMUhtRmxZZkRTQitFdk92OFdWMEZ5REJkY09PQkN6UVpvbENZRE8x?=
 =?utf-8?B?ejVkZW1RU1dud0Z6ODAzS08vNWMxYW5FSFNicmlzNXkwYUtScWkwN2F0MU56?=
 =?utf-8?B?VTVzVjBaVWd1NHFYWEk3Y21Sb3VGME1HSVk5WWhiWCs5eWRpbFNpNFMrNzcv?=
 =?utf-8?B?Ykl5M0toODhRdUlCUDdjUkYzSGhwUnpKbmg0Z0JNRmRaMSt6TTFiTmJpRGs2?=
 =?utf-8?B?R1dWbWpEakdKNU1KQy9YQkw5VTFRSmdWeHBpYzI4SE1ST3diemVqSUd0VEtK?=
 =?utf-8?B?czU3WFJhYVZNc3RoSXcvdmFQcXo2MGdYTmZ3SXRJZjhMUU4vUFhXSEVxVlMx?=
 =?utf-8?B?YUNLcFVKQytoSXZvWm1XWERoc3NlOVpaWTVXY2FWaVY1TDZvQnR0bWZoeDdH?=
 =?utf-8?B?RkVaODNoZlpBcUdDOVhOZHlJVXVkVTF3NmNQcDNEcnRjR0FQT1V0YXNjbW9j?=
 =?utf-8?B?cWNnaExCOGVCREp3RWNMMXp1bTM5WmRHWEdsMHhkWGxvTXB2Y1UrMlJqcHJM?=
 =?utf-8?B?dGtJTk5oWjY2aGFmZXVwSWJieTNOMTk0Sm4vR3hzNXc3bmhQRERpeFBGdVVW?=
 =?utf-8?B?MGhVVUdKZFczUFBjRDQ0bENOTkp6VDhQMTZpeWRVS2FhWjdHc3hjOG5Ib0p5?=
 =?utf-8?B?R1A3bUxHTDdhYTRzVUVkK2V5blFMZVdNclliaytza1psZGpoQzFNSWxlVWli?=
 =?utf-8?B?QnUxZTkzU0xsSHZrT1VFb2tzb2Jjem9RWWtuTmdYalljdHBOOTFTNTVwSGZP?=
 =?utf-8?B?ekVNcGRMMERjUVRTWFdqWTlocUJQTm5LVjRJenBLQk9VYnF1R2p4bm84RU5P?=
 =?utf-8?B?RUhUVXU1eXpGdHRzV0NnWFlyVk1LbDd1amZsOWt1ZTZyTFJ6MkgxRW9kSng4?=
 =?utf-8?B?bDZQRm5JUURDelhmaWZiR0Fra2NwRHN0REwzUkQ0c2hSM0ZFZmxXMjllRlVx?=
 =?utf-8?B?UnNWbHZXaTU0bS8vNTlnamxXV0pvaE5jMnRvRmJPR0hhbjA2UjI4b1FEeHFU?=
 =?utf-8?B?eEhFUzdBdDFqTkRqcnRyWGJ4Qi9vMmVNUEpvYmZPSDg4enl2Z0lsVGJTT0h2?=
 =?utf-8?B?NmZ6Snkra3FwNGxUSXNZOTBzeHJ2YUJDQ0lkNFhjSngxaURRdGNqbEJiV0dm?=
 =?utf-8?B?OHd6YSthelJQVjhXdGhTYlNqMFcwb0FYMEVXYlhzWHB4S05qU3ZGOHJ4RVI2?=
 =?utf-8?B?bmJWTlhycFY1U1E0WngwRnM2Q2dvRC9WeU9GUEJsbjdZLzcrdVVjcTFpeEJx?=
 =?utf-8?B?OXN1UmJhNXhOMzBXdDNHZW9iK3JGMTU2WStDcDg5aS9WK0dKV0pocm1uYkdr?=
 =?utf-8?B?R2k0RWdMQjI5ZHBySmZVcjhsWGJDQkhGc2pOVzA3b005cTVsYTNycm1uK3Uy?=
 =?utf-8?B?ZlMySjljblV4ZzdhZ2FlWTJtMWd5c25wa3FRR0hhQldmckViWmovejVBWG85?=
 =?utf-8?B?dkJ4Z1lCa280YzN4YldTM05qZU9yK3BHSXBscUs5RHZEUkRTeUJpV3JuUHJD?=
 =?utf-8?B?S1p1TmQrMndPYXg3QVpLd3plMmRBc2lEdEJqNkw2NEQ3cnhHbDdiSnVmTkx0?=
 =?utf-8?B?YkJqOUhhVVR4QStrUW81bWZNMFlyeUlSc29oTU9XNEhZZVBxT0k1Vlhqb0Nr?=
 =?utf-8?B?WmFsZ280ZjFOQnV6enhQVDc2bXF3NGlJay94MHJBOWJmOGp2WjVadEtGNlBx?=
 =?utf-8?B?dGxQbVF3SUorSzZaaWF1RFBSS2xjR1pUNXprRE93T1BVZzhES2hkTzZqdGo1?=
 =?utf-8?B?S245azB0VWVVOWdXRks2aXo5Sk5SNWNHdWxpdTNsd0VrMm1seDA0SlBkNmdS?=
 =?utf-8?B?QXRwNlJ4aE5XakNjSlNqQ3dkUFA1WHgyaFVoYytFN2ZYYWlWMVV5UG5DWDVN?=
 =?utf-8?B?ZlVMVXl5aUhmWkRYOXBSNEthcjRVRitMVmVwZzY1dSsyRTVlT3FYTUdXT3Jx?=
 =?utf-8?Q?HzWm0vXE4ETzJGlP8LHO2Bf9jRqJmT1n?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkNrQXh3ckVTa0RDYWRScUNCYnFIVGlpMWY4WHYveC9Md0hoZk05cGFwbWVS?=
 =?utf-8?B?SFIrRElPRUxkOTBLcFllaXVkeDczdkt4ZzNDZmNCNGQ5ekJPV21uSmRPZFp0?=
 =?utf-8?B?b0dXSlhXcUtFK3lUbk1ZUU5CZGRsS05seUhOTDhCQlk0R1JoZFZmQitXbGV1?=
 =?utf-8?B?K1g4RU5POVR3Q0I3QXlqQXRBeVE4TUltYkM0L1d6VTE3OWhBcjZORlcrV3Q3?=
 =?utf-8?B?T08wWDVkUVllQy9sc3Y4YUpkWGV6N05jS0FYci8rR04xNU45N1hQN3FqQ3Z1?=
 =?utf-8?B?cmxuUkNYU0xjMURXa1B3aHY1c2g2ZHo5ZVRvOEpBN3ppVGpYMzhwdUNPU2Vh?=
 =?utf-8?B?VVcrRnFuV0NrVHdod0xjY1RMSUFOOEVWV1Rwd0pJZVkweHhCalJMM3ZWZUVn?=
 =?utf-8?B?SmV2WUo5WStyeTRCWmNUY1JMcnYvaWdsWVlZREwyaXpCSFVUbHRUV2poSkJI?=
 =?utf-8?B?UEF3WmZzVFhSWnZha3FhSnlKemNMNmpBQzIwZU9LdDNQTmVQU1IxelQ5NkZC?=
 =?utf-8?B?ZGo4TmpWQi9yVHE3YzFjR3k5UmZPQVhjeW9FckFLekYxUHlEWkxnQlB6OU8x?=
 =?utf-8?B?STZXbU8ycXhrcUxLeVZSWlIwTzRrOXVyYmxxYklWSkFiYWdSQUhvVTAvZmVx?=
 =?utf-8?B?eC9JUjdJMjM4NGNGZGJkcFRPKytwdVRua2tQbXpCOC85clprS3RhZTBBSGR0?=
 =?utf-8?B?Z2pad1d2Mk44dlcyVWFMTXVWTDJ3UmZkdTc1THB1QW4xVUFwbTZFMXc4b1l2?=
 =?utf-8?B?bllWZmcxQ0xXQ3M0K0xubm5CYjN4N29OZklCM09LbGtobTlMbm1hblpuOGFr?=
 =?utf-8?B?dVJTZFdFdk5SR0JGUWdDd0laUWZjVVhvY0Zydy8vR2pSZDJlellkaTdXVnUr?=
 =?utf-8?B?MEpWSTZlV0N5aklSWms0L0EwdE1vRVdGSFo4cjNUV3Z4bnJ6djZncDV1VTg0?=
 =?utf-8?B?WldhUFFaKys5M1dIbE5lMng4YlpNZDNsZzZ4MDZxWml5ZHI1ZEphd1VjclVN?=
 =?utf-8?B?K3ZOVFNGV05sZzJ2TUsrN01kTHRNeis2UGNIYlI0VlZBUEtiQ3B4NzUvUUxu?=
 =?utf-8?B?VGJBOWZpODV3SXBYRGc2bC9jWVA1QnMvYUljVkUxR3h5dWpRdVF4c0xCVWEv?=
 =?utf-8?B?VVhMajJER1NjeHEyZ3pzdTRJMEptU0g3TzFadkx6cW0wWWJaU3RPaTVsTHBj?=
 =?utf-8?B?N0k3bkR2ZktrSjhJZXd2cEUxUXIvSmY4SFB3Rnc3Mld3RGZIWHZFaHh3ZEMx?=
 =?utf-8?B?SytIeE5IcGhIUVZISFdJcDJaNlRTN01kUWZzRVlyaWJVTEpHb0tlUGF3SUN1?=
 =?utf-8?B?K1FrY3RtdzA3bC9PNTJIbU9IWjR1Y0UrZzZqTmUrNW9iTytLMEhPRk9PbmZX?=
 =?utf-8?B?Uk4rWXNBeWx2K3VwN2h4aENGbzJ1ZVVhZitVZUVWbVplOHhqenU4S0p4aThi?=
 =?utf-8?B?bTZMVXA4Y1hGM01jRlpCWk5pcW5qbDdJK0xFc0dMbmJLc25kMEZoUHp0em9R?=
 =?utf-8?B?cXJwajV1dklaaGw4QkxKdll5ckxyMlZJazZFWEZ3cDZyYVpkb1hnZWNURHFI?=
 =?utf-8?B?RkZMTFlMTjN2dUowNFZiSU5oSVZ1MjY3WFZ3UkdDemxteXd5MzhIRWNqOGdw?=
 =?utf-8?B?K1hmdEUzUmhWdGhKa0hHTHFoTUQyTk4xc1ZGbGtPTjFKeEdlQmFoQ29aWmdP?=
 =?utf-8?B?OXdXOTFDeEtpa1lNTlV6ZFJESFY0Q1hOUEJUQjFJOThETHVsSDJvZDZESWl2?=
 =?utf-8?B?RzJSQ09DZmxBRzcyOGNTQXVqK2NtVllJZkdmUkxGQ09VNVBjRnRBSnN2Ynhi?=
 =?utf-8?B?Nlh4bzIwL0dMY05RUW1lckJQTUorUW5TSng4VHFpS1RSL0hYdGxnZFF0enVm?=
 =?utf-8?B?QWRtcTBOR3lGVVJTZVZZNC9RUmh1Uk1LRFJJbHZVbU9kRGNCVGtmQytUOXIx?=
 =?utf-8?B?VEZxRmk2NUV3SUF1Y0lqaE9IdHVxWURsWktCUW85bWFCUjhvZUZZWE5RdDlS?=
 =?utf-8?B?cllkenkyWkRYVC9GMUozdVd4djZQNVlvZzQvOWxGK0dqL0dMU1VYZko5MDBs?=
 =?utf-8?B?WUZwZUJSZFRsbE9lU3BnY1d1cHV2VXEvR1RTQlUzeCsxL3VlK1poR2hJeUZW?=
 =?utf-8?Q?oEph4xtudogXMbLWMfPiniLnm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d68f56-ed33-4fb1-caec-08de177b99ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 06:14:36.2956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtigPccoJlu1djXQguSV+1E7+8YME36PtGdA0WsIn8mYh5+dM5a12nVf5xLWXuuA8zq9dLs6SjrUq/12FWRs8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9088
X-OriginatorOrg: intel.com

Hi Tony,

On 10/30/2025 12:20 AM, Tony Luck wrote:
> resctrl assumes that monitor events can only be read from a CPU in the
> cpumask_t set of each domain.  This is true for x86 events accessed
> with an MSR interface, but may not be true for other access methods such
> as MMIO.
> 
> Introduce and use flag mon_evt::any_cpu, settable by architecture, that
> indicates there are no restrictions on which CPU can read that event.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

[snip]

> -void resctrl_enable_mon_event(enum resctrl_event_id eventid)
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
>   {
>   	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
>   		return;
> @@ -984,6 +984,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
>   		return;
>   	}
>   
> +	mon_event_all[eventid].any_cpu = any_cpu;
>   	mon_event_all[eventid].enabled = true;
>   }
>   

It seems that cpu_on_correct_domain() was dropped, due to
the refactor of __mon_event_count() in patch 0006 means it is no
longer needed.  But we still invoke smp_processor_id() in preemptible
context in __l3_mon_event_count() before further checkings, which would
cause a warning.
[ 4266.361951] BUG: using smp_processor_id() in preemptible [00000000] 
code: grep/1603
[ 4266.363231] caller is __l3_mon_event_count+0x30/0x2a0
[ 4266.364250] Call Trace:
[ 4266.364262]  <TASK>
[ 4266.364273]  dump_stack_lvl+0x53/0x70
[ 4266.364289]  check_preemption_disabled+0xca/0xe0
[ 4266.364303]  __l3_mon_event_count+0x30/0x2a0
[ 4266.364320]  mon_event_count+0x22/0x90
[ 4266.364334]  rdtgroup_mondata_show+0x108/0x390
[ 4266.364353]  seq_read_iter+0x10d/0x450
[ 4266.364368]  vfs_read+0x215/0x330
[ 4266.364386]  ksys_read+0x6b/0xe0
[ 4266.364401]  do_syscall_64+0x57/0xd70

thanks,
Chenyu
