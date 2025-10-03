Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B295A2857CD
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 15:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759505357; cv=fail; b=adCQq4nXJWy9B7Y/tem+Wc7Z2kiUDpEZH6GmyymxbeGiS3kIuOZW1A4iC8BXrSB2j2ZmyY0gJgtQJCIORMiYiqpqmMjCtAic2XLq8MiFAZpnJGTI0FdwOrmXt4q4TB5eFnzemeUmXLB0jiG0DLfXgGuUcwP6MzyaWvxQorjZlSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759505357; c=relaxed/simple;
	bh=wEpQKzOSyon0Xxstl37wtZszA5VOr2mI9XPlMLW2Vb0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GthpX6Fq98kfraolBCDve9VPSriX2mK5cuB2RIPu6YsWsdJwHkIuAbiXkO2x/qwU5t6ps4csqLbwzC7VUe1DaGFr1IHZGa8bscFslef8fctdKAp/oppJ9eLyuN7YZO55zKj+dOaYZqruzpDTMZqxfNUggkNt8ZwBAJ1NEa2CcW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S+l+6P18; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S+l+6P18"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759505355; x=1791041355;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wEpQKzOSyon0Xxstl37wtZszA5VOr2mI9XPlMLW2Vb0=;
  b=S+l+6P183zuQmHIf+ezyNvClBRXzwWwD1HKMQXqCvcT5XeYAU32LKfio
   oVgM1nnCcTc7Dr+VqUBjgvWd9k9U3zFP1JJb4DAv8WoMWgbbJi6VkMDMR
   M/JA8sK9BiijmTmhxFeR1vDihQSBDfxbc1WgGCqlFdaEqdYw9yQ44hG7R
   jltx5xbJiNpnU+cVmZmSK4CL/ICJixUoWjEB7f/aexkkadmTPm+q0Omvv
   TyrOpJNzauL0VZfj02pABaM4Id4GhxqntTQSIUFfVuLgMn3eWV2dvz72Z
   My5fB55L3v4kI9HMocVhDBp0cN4UPvY8fDe/t175Bc6MZbO1q8V2pWDdW
   g==;
X-CSE-ConnectionGUID: fUqqMMFGTC64xsyRboqzoA==
X-CSE-MsgGUID: bVNgfIKcSVGE9M+8sVVKhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="79218265"
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="79218265"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:29:08 -0700
X-CSE-ConnectionGUID: f4vPoCWfQI+rQLhCL/BOqA==
X-CSE-MsgGUID: FAKqc/yVS5a0tWHPrJKAYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="184599262"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:29:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:29:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 08:29:07 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.10) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:29:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VaGODC0aQXyV8a2EG4XWsX3mVd6HIiMCqGeweQMAWxg2saDdLXsTwb2Hvd7vP4CLXeDj1Xd+eEpmGHAIbCadrdtGh3rGZSlESJD6sC+lyK0JQTz9ljtMl2KrCy9QgrzzSlnLs9CpxmaDZKsrj7irVLR9acUnkSxBvsz4TRQVo/OzYdqpwkrO/f/DXKwFNw9elpcWndpUz/HY9JfA+9KJ/SU1ZA/KlITXDZblvtnTxmcqXnXnDOORHeoKZxECm0xJOmteLDJL2G1f1sf3DG6APYRrfg7y9hBWeH+gmfcvKORBr+tsBnHurIaPfKLbbikUk6GFaOab954hRPCrxTozHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/0eBKRyyRIrTb5lxX5XtH4FVVhw2zYHLzHj2Ov5Oss=;
 b=wt0a3YVEVWzcvz0X04w7u1xkEqRgzjuJNGR0JF+F1YIpOsifkFxD7+V3SxgrIOx09irtvCkTxfyENn8IJilB6zh65tkpEOvzv6ev7Mk58uguvXj1BFOIuHC2EjXaiiM82fNdGG7ngDvCqeNhGEnvDYrOQp4/i3ttam7Yj5c8ELNdloCSMJW1qbnbe1PoLzCGbKwZq5gOWkf4NtPcM50PaYyBYcgkTxwDGxRHrsyTR8+WOFtgC5M/oldIHwvwOTyfJkACO1L554e8aetPDKv5AtmSbdXIJvBiW34m0K2giTtztTAzggSgH20rbaswZM38DRuA6K//CAiEphimKXHQwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by SA1PR11MB8796.namprd11.prod.outlook.com (2603:10b6:806:467::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 15:29:00 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%5]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 15:29:00 +0000
Message-ID: <377f5544-0e1b-4fd8-841c-c18f3663d10a@intel.com>
Date: Fri, 3 Oct 2025 08:28:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 02/31] x86/resctrl: Move L3 initialization into new
 helper function
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0149.namprd04.prod.outlook.com
 (2603:10b6:303:84::34) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|SA1PR11MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: f0d97e2e-097c-40e2-becf-08de0291938b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SUdjekRCMXc3amJTTVBSZlNuYW1BU3lBRnZVTGNNeXdIejhHMmFZdDIxRWtL?=
 =?utf-8?B?MURUS3dhdlNDdWJWY01LZ3lndmlCVjJjZXgvWTFVTVZoWUdVcFVrT25Mcjd2?=
 =?utf-8?B?elJ0M3FBRlFYYXNHR21kNUFtbUdSTGkveWVPVmMwUS9DcFNvQmh1a3M1OEFt?=
 =?utf-8?B?M0Y3RWlvUXIreTJPNFdZeHFVVmErQWx6eldsOWxQOVVvU0drVDl1ek81WHBy?=
 =?utf-8?B?N3Z5U05uOWFTdjA5MjdrMUFCMDdVL1Y5RzlsTzFHam9UR3JNOTFJUm9MMXRY?=
 =?utf-8?B?cHh3RXlBWHFTOTVpMkVWN2xOY2Vpc3lTanhtOWFEZUE3UzAyU2NnUW0zdTVB?=
 =?utf-8?B?ZEJUYW1kTC8xd2dVZ1pEUHBwNkNySkg3aWMvTjZBbmNncllPWGRWRGplTnli?=
 =?utf-8?B?ak1EczRvQ1Q4a1g1L09QUnlRMXFuL2Q2Wm5VemZ6ZWpjMkdOeDJQRjU0S3FF?=
 =?utf-8?B?OWhKZWVCVlZvNllpNkwrcnBta2ZYVlpGZzk4ZHArbXgvQUtFU3VLSVZRenM3?=
 =?utf-8?B?bGNWRTh1N05uZitWSlRGcnVLRTVwQXRvaWR0Nm9XWmpzV2pLQzNLUkJjVFVu?=
 =?utf-8?B?UzRiL2QzSThnaXVsb2VTWmtsR0NGcmpXWmh3Sy9sVytCRzJ3bkd6b3lnWFFI?=
 =?utf-8?B?Q2cwRkk4OFBtMFRYSStJdk50NFdabFNsLzVKVEttVWdyWDhjRmNQdjhhNHJX?=
 =?utf-8?B?TG1aQ3lEQlhTS3JmQjVtY0dsSnQyNWF3SjNLemIyZGhqbVdNRFdPRjltaERR?=
 =?utf-8?B?dXY0MitLQkk1aUJabnBpMzVESVkvL3lPVDBRZUs1VHVqaVdoTzJsTTRnR09D?=
 =?utf-8?B?czJtcUxUMFNFdkpZQ1FFQU43R25GTUhyMXFnQlpKM25lZTJKb0dPenE2bE5T?=
 =?utf-8?B?b25aWXVKdDRGWFVuZml1Mm5nRndOd3ltbHNIbEprTTJRT3ZQa21KUjBSa1U2?=
 =?utf-8?B?cDFHZjhEVlJnbGhrdndRWksyNG9BSEgxMFlxZm04ZHJ1eVhXbkMyamsrUEgr?=
 =?utf-8?B?LzZyK0FXejN1WHVzUjZsYVhmMjFYK3Q3VWRRbEJMaVRrdVFVYnpBZG5YbVU2?=
 =?utf-8?B?dVpzVmF0V2h6SG9JbUo3eUt2azM3YzloOWdFektCM2RlWWJ6bFBqV0lFaGlD?=
 =?utf-8?B?SUV1YVhiczd4cFZsekhJQTcwNFBuMmtiYXU1dDVFUHZOQS84MkFNcjg3RVBn?=
 =?utf-8?B?QmpWcnl3SjZhdzlJSGtMU2RXc1Ura3lLV055b1ZiYTNURkVIRG9oNjc3TDVw?=
 =?utf-8?B?V0U2K0RZZEY5Ymw2YVIrWFh6ei8rd0ZSMW1VUnY4OERvdU9iV0FQNzlNNEQ3?=
 =?utf-8?B?Q2YrVmVZUFAyaFZUVDlaRkhlQlM5eURmK1ZVTGt4eWRrWTF1ekZOeFdJSlI0?=
 =?utf-8?B?MGFNN29ieG9kbGNGUmZPczF6U0drRVBYS2hjTW9IY1pCRVBxYmR2VnpTcitl?=
 =?utf-8?B?ZmNYRjBtZlNNcXNwK1ZaczExQUx1WGhzZGpVTWFrTnNJbWIwZE9oaWlLRGJD?=
 =?utf-8?B?c0JFQlpUVlVtbHpoQUJFeXhROXFjMDRKRGlERTZCQlZySmdtZ2dHQlhXWmlW?=
 =?utf-8?B?bTBmU2hoQTZyYUhGR2c0VWk5cFNONUtnUDk0dUNHUE9Xd3d3dGZTN1FSUGF4?=
 =?utf-8?B?bFk3MWpWUjNtc1VoaUsvZStlY2IwSEdMUG92VUVydkpyQ3ZQditLTlNWallw?=
 =?utf-8?B?d1QrTDZxM2l5a1BVQUN0YlBvQ3czRU13RjBJbno4SjRYRktOeVdvYk1Temk2?=
 =?utf-8?B?Mml6Z0RrTmVZZWFFV1BBUjlrcGx2cDMydm1BTTZkNUJRNy93bWpockdoT1kw?=
 =?utf-8?B?WGpES1grWThrdjhoVTZvdGFlQ3ZqRFM0WkhXT3c4Nm14bzNUbVNqS2c4em1B?=
 =?utf-8?B?MzdpNEZ0ajZBZ0tQV2JQZ3JtSjQyMkFXZnY4RUY1WXB2NURhMlBRN1V4dWJL?=
 =?utf-8?Q?lXjr3LwxBI86wqhWONG4WmEUNsf4tSvQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUZHbEhxeW5uaW82UytjNkhZajZwZVJrUDJjTTdpMkx4RW1RN3RjZW56NjY2?=
 =?utf-8?B?NjB2UHZiN3ZwRnI0MUNjUE1pcTh3L0hGbDNYRm9jdHJkUFR2VWQvTkpHR2l0?=
 =?utf-8?B?OGg4R1BjVzNiQUorU1JPQ2w0Vnp0UHBmMXVxYmxmdk1PalNuMnM1NS9CNmxW?=
 =?utf-8?B?Q2FuVFU3V3BUc1NUS2NvQW5nSVdhdDhHOGNOeFp5QlBrQ0JYeC93RXJUaUwz?=
 =?utf-8?B?SXRkMEhoUUtvcWhwOXNMU0tyVlMyNEZKbi9RT0lnc1hQcU93NlVHVzE4UmpK?=
 =?utf-8?B?TENwbzdmdDBpeDFsMGllQ1FBN1VXNHZ5WWpiNmVxeWFMQ1dZaEkvSFFUalQ1?=
 =?utf-8?B?cS8wNnNoQ011d2JibnFVZEFienlVT3ZnM25hQnExZkIvTG1JcElnZlp1OW9u?=
 =?utf-8?B?VTJXbWZXVlBqSG0yQzRzQ29Nb2VhVmU3UGt1SXZrcnZJS2xuZmNyR2dTeFRC?=
 =?utf-8?B?a20xR0tjeGpxYjhHYU1XMFRsZHhaSkFHUUZuK0NBcVVOYWRpS0pib1Zmaks3?=
 =?utf-8?B?dTJsRkFJbVk4bXVPa1hjZ2NmUmVSa3BBbkVxR293cFhtc2dPOVZ4N3ZET2Jz?=
 =?utf-8?B?d2l1VGhrcmxRejJlUnd0QkozRHozanRXdXNSNDBXZHBwYVdYanpQQXFnTTVG?=
 =?utf-8?B?NUk2WE5GUld4M1VXY2JrODBCQ29Oa2U1U3BXRjRVQko2UE40eG44Ly9DYlgw?=
 =?utf-8?B?VmFmZFVHUkhmc214eHRaeThMVlVtVkRBLzNEZE1wZFVxaWREcEgvRmkrKzNv?=
 =?utf-8?B?VXZuREk5QXBtY3VUWlV1U3d1eTliRnNGcmlIWmhxRVFmblRScXNydkpjWXJD?=
 =?utf-8?B?THUxZkU0MXIzU0k5SjlLdGloK3RxdHEwck1WZUx3QkhQeTZ0VlYxQTQwL1Z3?=
 =?utf-8?B?QTA4cVFOcnFCdTVYZGZFVHdTekZqdmd3UTYvZ0htUkdJWmdFdzNYT1M4Z2VF?=
 =?utf-8?B?NTQwNGI5Y0lXRXdqdEJlS1JmSGE1eFc4ZkRaTzRGaitRQlZxQ3NqeCs0T0hT?=
 =?utf-8?B?Qkdud1ZMZldFcXJBbzRSMTM0R054Y3hYMkFaU0FpMnd3cWFKR0lJNlYxV1Ba?=
 =?utf-8?B?S3RERWhCbW5UbDhnVEpjS3MrV2FxZE9UbmRQWXpOWU5QWDUvUXdjV1o3c1JT?=
 =?utf-8?B?cHdXNmg2czlDM0VUa3k1bmJCZXJxbHAxblloZUVGZVY0VWlJVnl6WncxaXM5?=
 =?utf-8?B?TDhKVHFXWjFQQzREdFA0QmVFRURZM0lnZGZiSkFkcjg3N0hZMENRTmRmZGl6?=
 =?utf-8?B?aEpLKzhqQVErYm1PVXAxMVN3OGE3Z2RLY3I3MXJxMkE2UVA5dk1HY3RkMmEw?=
 =?utf-8?B?WVROelFFL1ZTbU54dkFQUTlsQ2VINzZCdTR1QnZzSG5YR1lhdmRiZThWeWty?=
 =?utf-8?B?WmVhcmk2OFNTdThWTVNVSmFxY1FBa2RDUEIzNGVZTjNOQ0Mvd0ZRbDB1M2xC?=
 =?utf-8?B?UzlYcmN3MXpOMUg2anQ4bmdRTU9UTkpRRjVvaFZrb3hUNkdCVGZnUEl0ZEpY?=
 =?utf-8?B?QlVLdTh6WGhPNVNqc0NrdjBBYzFwbXByM2xoaVdBTllQT0Qxa2RJN1pTZFFU?=
 =?utf-8?B?aCs5SGlTVVRzVmZOekdGcEhBazBnL0RFQUlaUjhQbTZaTlh1RlFQM25hUDJJ?=
 =?utf-8?B?MVFRemcwc3p1cHR0NEFTQjBscWR2VmZDNEJLYk1WMlE0TDhFb0FodHZ0eGFx?=
 =?utf-8?B?MWhlWHFhVmhnNTlCUTZ0TXRxSEdrWnhxaWo5aThWL2E1QkdFQUxtMnNhS2tN?=
 =?utf-8?B?QXpwZUNlL1V6SktCY2JoaXNvQWNjNUFtYk5oUWNWaEtnZldHZmxzdzVRMy94?=
 =?utf-8?B?SkZ4VUx0UXNobEU3L3NzTzQrMjNEZHFlUzRNUUh4UU4wdjMwTFpqeU9qY3ZY?=
 =?utf-8?B?UjdZQWcyUXRHc1JZR1JmdXBxYUhkMW1XTUg3ZTdnS0dDNmN4eHJBcEFud2g5?=
 =?utf-8?B?bkFqNmwyMVZjeUM5OWdXQmdaYzF5bFpVMnBuVU95OEx6NTBpaXB4SjVWZGxM?=
 =?utf-8?B?UGxGem9FQ1lISTB0a0hITm1ZUDJHZll4MnMwV1BTc0syQk9iQ3NuNXZ0ellr?=
 =?utf-8?B?YmRGb0RDOWdtaGdYMERVV0dHTW9TZ2t3NlJXcytUWXIyTkxkRnplVldMdUxJ?=
 =?utf-8?B?Z2JCWnhjNkZBMjZGUkZkVDlUNTJpSXhUT1UwN3N6QW9TS1hmcUVGNUpsY09t?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d97e2e-097c-40e2-becf-08de0291938b
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 15:29:00.3272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VuPkkS+wcXwSgrMnN0Z7Ox3/uX48gJ6B+66Ian0XuaRx62q2uvCVTW263l5VzkjAkL9ehdvSj8zD/MfWidPwPThYo1Y2kaW12qTf1Wqybs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8796
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:02 PM, Tony Luck wrote:
> Carve out the resource monitoring domain init code into a separate helper
> in order to be able to initialize new types of monitoring domains besides
> the usual L3 ones.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
