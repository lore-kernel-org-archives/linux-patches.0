Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7792036FE
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241544; cv=fail; b=W8e30ssTr6Ml1LJjnwyC0kZqRg1cnSmbP6HV/bsvEHgqfINRIxjE4H+obPIJ3CAt6AdRL3p0tydOkohbSBgdooXZB2MOdhx7fpuYLnQAFtuFxUEEy9U6WefqsfujQhnqKYuJLIdg7TRShAOPCscLVw62O8VzcnnS6TnRlICTHss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241544; c=relaxed/simple;
	bh=X7eOv2DL2JHYkBgJ4KlkN0JrfQp7RL/udi39bWGWpN0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HwFdd+mTQVnNUN9UO2x+83nCv/XQrpyReeN/9PsX1IqtfYe7bsDUMXt6hPZu3/LSpgaRa96gsLXrNrZqxHHGOtmkH/wimoHPn5/7865sNNucc/SpjINQ8Ze0JPDTFOp/jTae9UzEOz2Ibc0Kpwl/KKgpwIVDcrK6TjJ83oIFieg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bS2f3W1L; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bS2f3W1L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241543; x=1792777543;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X7eOv2DL2JHYkBgJ4KlkN0JrfQp7RL/udi39bWGWpN0=;
  b=bS2f3W1L7zgmZZRyrKrz4JzzWd1a/LKePu1rxusiM6cOoSahgcd+MYfX
   gVXEPv+xEYcB8T2uobHej+gCHdqno0PIrLA5vN68I4CX4IFdxyhQLe68A
   m6bXjZ4v3sQ6X159D+voi/sDOC9Xojp5FASbI+r7v7z/mcBGd63WZk4As
   Ar8IUAVlfsyQaCmCX3dDuM/NpLxkgKkUif/ND2cLNAxLdMr/vfLE+r/m3
   zfWpXAwAO27KarVQllqC1zSREPeXghq55jZKGpkJxd2aghnDhJyk4072G
   mpI9EEkGaFVVVICpwXnw5/l+MyD8BAl1uLLLCD2v4jaWtzb9OYpA2XrKd
   A==;
X-CSE-ConnectionGUID: Y9UFBfH9SnyciCi9LOGETw==
X-CSE-MsgGUID: 3NQ0qeXPTva+mfy290iHbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63457416"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="63457416"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:45:42 -0700
X-CSE-ConnectionGUID: bMgZiZmVTvWfoFkEQP2JRA==
X-CSE-MsgGUID: /9NrpY+hSmuR1sRAH7PQfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="184992506"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:45:42 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:45:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:45:41 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.39) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:45:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mbLq5LaZ56bx53chO6W24yXidn8Pccxjf4ESPjEddZTqH3z05HqnDJHdjt3airVSXkOCuyIU4OBiupnRDrLiWyf15tQHvqlFzQ1HTzOEQv3TdnLNSkWSAwjuTeWZUbrZ4Nb58aXKOj06Q0ccz5WMh36OZY6yORoGkffrswHYx04q82YjAbCD4B26V7NJ+6s9Qp907dJZmppwJydBnO3nrblHNWj3dL2t6dvjrskgla50mqd1XtKiMNteObrEW9Y+anLqKt6bBNFpItEk1ZNBmKwezQHvx86nZMyjRIu4h46fm6+Ui6Gv+UzYVqy1pv/jD0WKP1vs9lS40FQw85E4yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkMWGc8szYBvh7MfkidTn04kpjK7N8ZQ2uqsyXvEA1c=;
 b=gUGUY1MPUCebdSUk35Xwb2npkR5whGG0tkE3mB9R8I1EHr5HHJ/QEQGhG2oE6Zq20ekKVFaT+zcPPhcoDZJihHgZwaMt0NrbYU3IuLH+LKD8OGdT61/ev72pvtMloXWPgPULFoQYksg/cdb+mbjAW4MUI1WKQnngdMDRtmMT5xk0L3R3vBpjq85iHVKDlppteNX+hSMNjGAdg/oi3+zQ7DOHtjcFGGXvBG/QtH3PF+v9usoGl8xluSM211gqLtDfw7+qy+SW0hShZmQYp0urgABmI1QJWJI7ptB9HrJoWwVv8LKQT72sQB9wHO3IWcv1mh8uW2mgGfjR8h7wa4P+2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6784.namprd11.prod.outlook.com (2603:10b6:806:24c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:45:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:45:38 +0000
Message-ID: <3f02a7a8-9996-43e0-9f86-7d685f64f965@intel.com>
Date: Thu, 23 Oct 2025 10:45:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 21/31] fs/resctrl: Refactor
 rmdir_mondata_subdir_allrdtgrp()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-22-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d3d672e-dbfe-45b8-5211-08de125bfa15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?czFmSlJHUUhzQnhxeHZnR0N2WExmdjV6OTVoYVNkd2kvb0YvS3B5alpPaVpV?=
 =?utf-8?B?RFBiMnQ5OGlrNUd6b3FGYnIzdWJwT3RoYkhGRWRNTW03Y25YelVCbXV6RGRq?=
 =?utf-8?B?Z0xMR21Td2loNktuckRnQm40REY0cTZjeWlXYXZZQTVRZGNHc3RseUNIOXZX?=
 =?utf-8?B?djgyeWd2MmtQRlczbHJmVHJ2MGJlY2ZldWE0aExsRU9abDRKdjRqL0tPNzVX?=
 =?utf-8?B?MDVxMy8rVkpsT1hDT2FOM1BGaTRHRFdYeG8vTDk1VllGOXE5OHdkdlFlUnhv?=
 =?utf-8?B?M0wySm9vOU1SSTNwNHovVE1DWUhWSkx0UVJ6Mll0ZmxjbVBuRDgvMmJETUpm?=
 =?utf-8?B?VmRuUEVkRWFEV2d4eXBpSmFBVEpYdFlsbjhRUzlOUEJzRnE2RUFDNnRkMUlo?=
 =?utf-8?B?MXJwenkzWDMzaGdxeUM4ZG1VaVVGTHBEVGlvem9GQXpNa25FUEI3c1gyNzR1?=
 =?utf-8?B?M1hzNDRGNmUrY0RZcFhLbmRTZTNWNm9VeVZwVWQyTDZBeGs1ZHdrd1dBYUlT?=
 =?utf-8?B?U0JIaEE3cmVRcWpTRGtOQmJTaGVueGpDWEsxb0t4cDdTN2cvVmZndzVtY2c4?=
 =?utf-8?B?SC9UeUV3cEh6L3pHOFdsenloZEZSRlhuc2VtUk1GbWt4Zy9FTkZydkc0a3pz?=
 =?utf-8?B?b3RZUEpNS1IwZk1kblpNb09LOWlhSHlTMnVmeHpFQWVIWlZlQjd5RU1RMVBy?=
 =?utf-8?B?TWR6VEphN3hNRFppenFVVEpMOFhQbjRNR1pCU0lFdGs3NWNHNWd4TDV4bjRa?=
 =?utf-8?B?MWtRdnpYZHU1Q1RIWmxENVlqTDBjdlQ0S2pVd2pkVzlueThZaUlxZTQ2STdO?=
 =?utf-8?B?aGJXUXJ2dFp5RzBrZ1pOR0lwZVFJSE1LbXhiS3lpWXRZWE9qVXRzdkprUlQy?=
 =?utf-8?B?ZnBWNU9WbEJPTVZCbThYaGd0QkJDM1cvdVpLKzV0UkxubXplM3pKODNUcGJs?=
 =?utf-8?B?ZTVnZ05xRDRMRzhDME9QVDlhUlIyMk5xckh4SFlpS2JNYzZFckk5TFJHTUxY?=
 =?utf-8?B?eXg1SGlJN1l2MzhOTXlmVFhTRVdnQnE3QXZRZklxNVVDSlpHK24xdzBqSkNh?=
 =?utf-8?B?OXdseEZ0WTJaTFZJYnhOeEdEL3YzWU1IZ2R4SVhVOEhGc1RUcStCVWxBaEox?=
 =?utf-8?B?cTR6UUZVREQ4LzJGN2dBMzA2T21hZ2pUMWw3YUpXZlR5eDZUZm1aaDVTSUd6?=
 =?utf-8?B?dFlmYWNQTlpDOWowOG0rUFBJQ3l4RWtBRWNxeWZEMDNyUm4xNGMzVTJWSDIz?=
 =?utf-8?B?eDJRYkxCVTF3MlYvQXlhSGxwUGFWY2oxK2NiV3lmMnY1bnU2MDQvc1J2UjBQ?=
 =?utf-8?B?OVNXNzB5Yzk3ZW16L1J1M2dVODFOeG9pdkZZK1lSY0pjaytYVGw4bWJacExk?=
 =?utf-8?B?cVB4alg4Vjk5Tno3Snl2Wml1aFdIZXJPcVZQWGR3MlEvK2hTazRYZnZ0eHBz?=
 =?utf-8?B?ekpqRWNMSk9sMTdHUzlaT0llVVovMmprWjhUUm9wVkRabkE5cWJqUCs3dktx?=
 =?utf-8?B?aXc4NUhBdFNjdDBsNjZZVXBheUtOZ2poQkJrTDY1cjVncGdkUE5tQVUzY3pm?=
 =?utf-8?B?MDgvQ1I0elFvUVRUMjhZckw0MkpvZ2tMNjlINzhLa3JjTG5KTHhlVS9EU0ht?=
 =?utf-8?B?MHlodzIzci8yazAxQWVHR0UrY0FXY2syVFlVRjRuc0E5cDdsT0pFQlhHbVBN?=
 =?utf-8?B?L0VFRE45WUNZeXVEWmpUMVZ5WDJJNjBZNCttSW9yQ0hUV0UyTTdON2VuT3Q4?=
 =?utf-8?B?aGptOHpHL1RkSmJLM25QOVMzaXFzQXdRMUVEOHpDdmh3SHFBajMrREpscW13?=
 =?utf-8?B?bzYvWXpVTmcyYmZwYXk5R21xbFJMK0xMeXZkMm5Ob0h1YmswSjNiTTVBTW9D?=
 =?utf-8?B?NXZqWDBUR0RMM21zVHIxTE9mQVl2VUplU2VFSkp4NnJUbkZKNzZhak8vOGVr?=
 =?utf-8?B?VDN0YzBoQVpqSmpYeXYvbVByTUhQTEZudmJ4c3VCNFZXVDZsL1BIOW5Gakdz?=
 =?utf-8?B?Z2xZNXB2SmhBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE9NeTcwZ0MydldvS3NTYUxjb0JtR3RtZFlVd3NRdk02Y3pOa2dtak0vK1gy?=
 =?utf-8?B?eTRYNDNVZEtVYjV2KzJtdURWUFhiOWNzc3RublllZ1hjc29rSnM5ZWRQZ2li?=
 =?utf-8?B?dkxrb2V2eTBSRWdKZ2dEZWh3ZGZQWjdOaDQxQXlUVCsrcjdxWXFOYjRmTXRv?=
 =?utf-8?B?RGtLNGFIQ0pDN0tSUS9NVTdBTzFpdEcxODM3RmpvenE5NDJsUXBtOGx4YVBm?=
 =?utf-8?B?RnVheWc0cm9LL1VaenFIWHJjQzlnUTZFNm1kdktUK1JxZmNPV0xBRG9uZ29C?=
 =?utf-8?B?Ymphc2dWUzVmbkh2a044M0M5YmxwNERHTWdhNVRESzBzVUx6c3dIK2g1eWxI?=
 =?utf-8?B?Uk05Qng0b3Vya2dIVjI0a2d1cnoxSFlxRXJoUVRaYlUzbWZTeWFnbnJkbjZB?=
 =?utf-8?B?dFN6enV6MmhGMFVXSTVWOVNNNWNkeHU3MDhQeUdIQXd6ZW9HUlMvcDI1Uncy?=
 =?utf-8?B?aGlBMHlTNkorRUNNbUxvQlh6QTgrZlJrS01oRG5Wc3M4K0t1WkRXdlo5OHpl?=
 =?utf-8?B?Y1dVMU5qbFVlSXlRSm1RRUIvYzRreDhmY1E4cFRwNXV4ZlBPL24wZVhXQlA3?=
 =?utf-8?B?dWdsYmxOMlRVWnBWYkFCUzZReUNrcGVSN2NsejRxQWNtZERzU0d5MXJFc0pV?=
 =?utf-8?B?SnFHUTdrWncwOTFhZEh3UE83MTRuTzZLMnhTanYyN2ovUzZBTlhEN1VBVlJk?=
 =?utf-8?B?YXprbDdxOTdBL2U4UXlSelBTU1VNam9EazR0akxiOEh2TUpqVCszTXhRNnJs?=
 =?utf-8?B?Wm1hU0EvMXVWM3E4NXUwdk1sUFJsS0FOOUEzelNtU3BEMWVLcGxuVkViMUJL?=
 =?utf-8?B?bUJxanBXa0pvQUFNTFd4WW5PaGNzNTloMmFEem5iWjRUcS8zYXQ3R04yVFkv?=
 =?utf-8?B?aENselh5QzNMV2orV2Y1SFpVR1VkdnNUZnR6ZDVTWjd6WVNaOUc1Vy9RZzla?=
 =?utf-8?B?T241TjhvN0k2WE5pQjY2MTI3MStjNFg0ZXQraUJ5R0dJTjY4TzdzYnJoL2tS?=
 =?utf-8?B?ckJuRUpBN3J5bDhXazZrWWhPY1B0ajFkNEt5a000alNUZXJ4YVM2dEw3SmRB?=
 =?utf-8?B?SVJZcVY5VnQ2cGFodSs5Q1pFejJkVGZaRWdGZHJXeGdIWjNPZ3J3UWFLd0Zs?=
 =?utf-8?B?elJxTzlHNXYraEsxanZKRU1DVVVBVUY2aGdBSCtJYVFoTEcyT2xzNlNackhZ?=
 =?utf-8?B?OU0wS2dvN0lyN3Bxci9lUU4zUTdPYVRXVC9ncllYY25TS1hQaDdpa2ZBZlVh?=
 =?utf-8?B?TjVFbUM4NUJ4YkphclY4a2lLdWpQN3FmL256R091eGEwczVyVE55eXAwaldt?=
 =?utf-8?B?SW5xc1poWkxnUzdnVDNOOURKZWtsVDFBcm1UM1BTTDlqZDhZZTVoN2hlNEoy?=
 =?utf-8?B?bkR6Q2l5QU52S1RxdENRNi9vRTVQd1VrOGtsbjk2Wnhmdlllb1hRNFZzbkhw?=
 =?utf-8?B?UGdheStDK0k3Ni84QlRVeHFxNEFqZjdQazJmMmowZThyL29ZVVFxM0lQZ05j?=
 =?utf-8?B?TkVNWWExb1hsSDN0eXlkU2t5MklneHQ0Mng1RW45M2h5UHJFTkxHMnB4em5P?=
 =?utf-8?B?dDkwT2dvQUN6RkNHclFqUkw2NTdwNjVLNjM1QWNIK0xnM09JYlM5Nkhyamt3?=
 =?utf-8?B?bjZ3M2grSFpjL3NXSmJXN1k2ajlOVnh6Vll0QkhmNEQ3dk5iSGNKYXNNUnly?=
 =?utf-8?B?Um1OeVhFRU5xTkVQZ3g4bENaeXowS2dyVVpHemEzR1UzMmVENGxyT1pZUEFs?=
 =?utf-8?B?MnBkYmpVOXpLbnJlV2dUb0diVlZlSWxXOGRyVFh2ZVdONFoxQWkvODVvdTdX?=
 =?utf-8?B?TnFJcjNmdUo1M2FhL1lFUlhwdzBkZExyeUhpSmQ5bjRaN211bitIQVlGWDBW?=
 =?utf-8?B?eFQ2RVA0dGNpemo2QTVQV0FwaFQ2OGc4KzBueUNuRld5K0JHVmRPWEpVRTlz?=
 =?utf-8?B?YnhncDMrOUpwYU1DdGNpQndYRUFZYjFIVjRBMXNZNFZwU21GT0MxVmRZcUpm?=
 =?utf-8?B?dTVnbkVPU0oyOFRTY0xDSlg4OUc4NTRINnIzV2hDMHF2WS9WRVduTEM4VEFF?=
 =?utf-8?B?L0N5M2ttSXdJb3hFVnJFMVpDdFA1RjV1ekVhOHNrdk9Bd0J2NVVheG9HOVAv?=
 =?utf-8?B?SmtUem82UG9hQ2RQYmVFMEYzcGtqRytUdWtlcmtmbmZ3L2R1dUowQzhtMnEz?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3d672e-dbfe-45b8-5211-08de125bfa15
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:45:38.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHn+0v+em4YZly8wDvirfKLmCZ5WOo7MT3/K6J6SlJEVAS9Q5QVgILPS4oWdnu71bklNny0DhgY/gzs2fnol0+JxF5DzOKObowhp9ZYp4gI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6784
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> rmdir_mondata_subdir_allrdtgrp() is complicated because of the support for
> Sub-NUMA Cluster (SNC) mode.

"rmdir_mondata_subdir_allrdtgrp()" -> "Clearing a monitor group's mon_data directory"?

> 
> Refactor into a helper function for the SNC case to make it easier to add support

"Refactor into a helper function for the SNC case" -> "Refactor the SNC case into a helper function"?

> for a new telemetry resource.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/rdtgroup.c | 41 +++++++++++++++++++++++++++++------------
>  1 file changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index b7eaa4388768..837279d97db4 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3162,6 +3162,29 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>  		kernfs_remove_by_name(kn, subname);
>  }
>  
> +static void rmdir_mondata_subdir_allrdtgrp_snc(struct rdt_resource *r,
> +					       struct rdt_domain_hdr *hdr)
> +{
> +	struct rdtgroup *prgrp, *crgrp;
> +	struct rdt_l3_mon_domain *d;
> +	char subname[32];
> +	char name[32];
> +
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		return;
> +
> +	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> +	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
> +	sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
> +
> +	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> +		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> +
> +		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
> +			mon_rmdir_one_subdir(crgrp->mon.mon_data_kn, name, subname);
> +	}
> +}
> +
>  /*
>   * Remove all subdirectories of mon_data of ctrl_mon groups
>   * and monitor groups for the given domain.
> @@ -3172,25 +3195,19 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  					   struct rdt_domain_hdr *hdr)

This function's comments still mentions the actions needed to support SNC. Can this be
moved with the code?

>  {
>  	struct rdtgroup *prgrp, *crgrp;
> -	struct rdt_l3_mon_domain *d;
> -	char subname[32];
> -	bool snc_mode;
>  	char name[32];
>  
> -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +	if (r->mon_scope == RESCTRL_L3_NODE) {

https://lore.kernel.org/lkml/aOhd_A5L8PV0OYba@agluck-desk3/

> +		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
>  		return;
> +	}
>  
> -	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> -	if (snc_mode)
> -		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> -
> +	sprintf(name, "mon_%s_%02d", r->name, hdr->id);
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> -		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> +		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
>  
>  		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
> -			mon_rmdir_one_subdir(crgrp->mon.mon_data_kn, name, subname);
> +			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
>  	}
>  }
>  

Reinette

