Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9009728CF56
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 22:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762985186; cv=fail; b=FYauo9xsQ4F+MYnfQV4zOI8B8OAPMpoRB8c9mpHzsmdZD3/01YzS0L+fPi+mpN/UbSKhEbBAMeTdFnnswWbGNIYLgUbNY+zDCm7loGYWfjlaHw2PY72Lgns+5/H6XcbcOx7eC9BGA5DB7iIJ0SilcpadFvuVIYlmKMjnHm3dNCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762985186; c=relaxed/simple;
	bh=BlyxrUo5+jG03zloDpQTNPyG8SFZ+iOQX8BYBjkXkA0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AmskxIyV30t1RDT/dhEKm46UdQwdVTN9/4kEXANfC03eW0cRCkNp/L1kB1+NAfwMAiEWWySNs4olVZ7YcQFQzIqYcbeDEhjnTL4+JkCBXwMcc4vZ5PF6t+8c3kZmr7RVm2F0EvYq2WWwHrTBE7uJQTdOo8IAqap3woXbctEWpLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VglifIqM; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VglifIqM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762985183; x=1794521183;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BlyxrUo5+jG03zloDpQTNPyG8SFZ+iOQX8BYBjkXkA0=;
  b=VglifIqM9F1w3xhy5UyCvaTFJpf4HqrcGWBuXTNs0Fejl1RQN0SrXuwt
   UhALOAhkWGk8GKoPfHAcv6QugH6NjLuN7XEyYWBS4asZ5j3g0ps4NNVEQ
   QdBR1/GjXDGA0qEdCHrcc3bIygUpEMajlrsJcs3W0TbaJBYxmHG76wcgB
   g3modEaVd2LlYz13qgPjNLsYe/erMGnrj/26CKOqWm3w2cXRnXGBtuJSH
   CEaD0adZ+R3VI4nmlqiEqZvQpduhvpnN/5K9ZAvlfq+v7RjscMQUtXC4v
   l4UHZV8Dgf1UBzz+h4fm9Vbhs1MtLcFnVSM2CYPk+54wM1MtACFXYbFq4
   g==;
X-CSE-ConnectionGUID: 7Sg0u5UOThawuT83dtqM6Q==
X-CSE-MsgGUID: adpp8PFJQCm3Fxz1/WGhqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="64965874"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="64965874"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 14:06:23 -0800
X-CSE-ConnectionGUID: apkXwukrS1GSN0dyTvlnrg==
X-CSE-MsgGUID: egMm32lYQw+RpiPgJNvVuA==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 14:06:22 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 14:06:22 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 14:06:22 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 14:06:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TzSJhHsE60aNZS+utU55S2lZPxfS9AMRNs91n8B2kHj/Mu6YtUtoW2d+prmZh5We/ldVno6S+c+P6aruEtnEPBmiX4+IBLgiz3l6sF3mBVjkRgMuN0msyl/GRdab3hhRCcO6zIt+7Q6wnd7vUyG7uSo2ugKScN0hUFnRSCTg6EeOU08Wx1ZUL/tq31SRmV668Ta29gYdY6IMajvDi0XOBJe0d0ldYE8KrVlgYjXSv/qElo++Mp+rDOvMArHC2xxeNPrZOsLePGlP2VDB0ejNoSbYk0AfXHmP8U2HeOx4o5Z/qzezrYUQV0YN3vOPz9D0qzrAS20O1EXnf3nUdkqKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vMGYjOBMMnjlM1V5rJpnGEUf+fqrfayzIz8muDycdc=;
 b=g12xUC0Iszo3g9RkI5j6O3u7IftlnnbRs2FxIvZ6h0RyylZSX7eXMAkQ12x3A51gTH5tgA2+h7/gdc5w3GGdkjsYN/sW6+djlepevSFmXjQlfvT/rTddtcur22NSOFNdwFJQEy7PPk1dzTbJ2CUI5mu6xTJvrodYcqvn0OkPy/yEQ5L+ar/EzDBq0do+YoMfMWmREsw9PSQ5eqvQU6L6zCsrPcoNSsLIWKilErGE9x0LFr0BehLoTPJtlZNWsc287qsyjF9w14hNrnxuiJ6F3yPXPJQKgSI9JDS5P7BayoOEbhL4I54mwFQ0foZfpWRoHZS+85Fo4O1jzYX1nM7y6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8683.namprd11.prod.outlook.com (2603:10b6:8:1ac::21)
 by MW5PR11MB5882.namprd11.prod.outlook.com (2603:10b6:303:19e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 22:06:13 +0000
Received: from DM3PR11MB8683.namprd11.prod.outlook.com
 ([fe80::5769:9201:88f6:35fa]) by DM3PR11MB8683.namprd11.prod.outlook.com
 ([fe80::5769:9201:88f6:35fa%5]) with mapi id 15.20.9298.015; Wed, 12 Nov 2025
 22:06:13 +0000
Message-ID: <539c632b-c265-4546-8780-ac0132aa2cf7@intel.com>
Date: Thu, 13 Nov 2025 00:06:07 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 425/565] accel/habanalabs/gaudi2: read preboot status
 after recovering from dirty state
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Koby Elbaz <koby.elbaz@intel.com>, Sasha Levin
	<sashal@kernel.org>
References: <20251111004526.816196597@linuxfoundation.org>
 <20251111004536.424063948@linuxfoundation.org>
Content-Language: en-US
From: "Sinyuk, Konstantin" <konstantin.sinyuk@intel.com>
In-Reply-To: <20251111004536.424063948@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::19) To DM3PR11MB8683.namprd11.prod.outlook.com
 (2603:10b6:8:1ac::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8683:EE_|MW5PR11MB5882:EE_
X-MS-Office365-Filtering-Correlation-Id: b672a02c-c294-4520-6254-08de2237b1af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WUc1Qm9QL1A2QlMxK0toZUFzNzZtY1F6Q2RRTVdnemtaTmVIOHJsUWQ2VXlQ?=
 =?utf-8?B?VWtuSFZjeEhDd2VYa1R3Q0pJbzZ2Mm1VTVlGQXlyajZ4Y1FVUW83cStFYU1U?=
 =?utf-8?B?Nm5lQlArSnB3VHFnL21IK0RNTEZSbWx6bjJ6S1FLL3B4T3UvU1FpdEIzYXZO?=
 =?utf-8?B?TkpQeEVZeW1HS05QTUExTGQ1ZG8rMzJScTUzMmVnVmF6eG5IblpmNzJXU24w?=
 =?utf-8?B?amJmLyt6MzRrYUlnaDB3VEFURFdNbXBvSVl1a1BIUklocStkZkpiblZGTmho?=
 =?utf-8?B?TUQyVUdGcjlhZTZUMnA1RTVaOGFBVkJXWDNhRDBXUUxyU0NpVzljTlNuMWdy?=
 =?utf-8?B?eEQ2ZThndzEvek5weHlwUjV2NTZOeVhzTS9IcTNwWDczTHpWL0lHejJWUHpO?=
 =?utf-8?B?b3RHM0J3QWhHU01mSUxsYnFLYlNmeFZpT21EbVFKZ3JENVhRT09CdElHeVhk?=
 =?utf-8?B?VjNSZC9tNmxuSjVaMnY0QTFZTmdMYVlEN3hhb2VEZEhiMmo2RHlha2hKazZs?=
 =?utf-8?B?aU9UaHBxZUorV1dtY1dhaWUvRkhhR0FRVkpNeTJ1bTl0RUtGb0RvZWdRODJ6?=
 =?utf-8?B?N3NkOFFkQzUrem5wcU5jSjRIb1N4R1BYMnlROE5veUw1TDBhcWFaUFVRV2My?=
 =?utf-8?B?SGRjV2pEY1paUFBYNFFBcC9HTnVOQ2tpTHpPR0M2eFkrSlNJMjhVT0pLVXVp?=
 =?utf-8?B?YWdrV3VSR2FucjVzZDhPNzQxNXJQa2ZyMWR3YlAwRWoxKzBqS2VqMXNFZkhi?=
 =?utf-8?B?aDZXdVRDa3dVSU5ING9BZ0RlT0NkcEtIWjBSV20rOGs0UEVoYTA0bk42K24r?=
 =?utf-8?B?WFI5aHNYSndHZmVXT0VYZ1JrQlZ6MVpoY0JZVEN5KytzdWV6NTA5WDUxN3VM?=
 =?utf-8?B?VndPOVN4L1NjbU5qd3NCU3VEZjdpNXI2OFBBbGR5enZ2Z0h5bkJGZERMWXd5?=
 =?utf-8?B?c2FqbXdFRHdUMCtGSEtURllLRFJvOW1zaUwyZVBlaFlQZ1VvM2kzNEY5dmxU?=
 =?utf-8?B?U3ZkZm5FVVVLVmlWQnRycnNZRTlSYmNZd0ttTFRRVWlJV0FnNkNtYWlUTlp1?=
 =?utf-8?B?WW1nc0F2U2tYcUkxVzNDTEJjYUdtUzVUUFhmVmJTL2FGb0hBSUJ2QVQ0NTVF?=
 =?utf-8?B?SWpXbUZ6UnFIeWQvMWpoOW9VZkhPRVprSnNmaFJaSjVRQ1piSVYyMDZoRlVz?=
 =?utf-8?B?WGordHBWeXNDUFBKeUpjdDBtYlY2OFhYbTRiNzlEaEQzdzdJNU9XM0FzVGkw?=
 =?utf-8?B?RkFiRWozMERvUDhzUlFXWTJYKzExemtvV2NnRXZrUmY1aSthQVhzcVBBZ2N1?=
 =?utf-8?B?NDdsUlFjbWNodTlvLzdJQ2JGSG1aVjd4M0dwR0dkMElxUUZQZGRWS1ZBd1Bh?=
 =?utf-8?B?MCtlSlBjN3hyTEZYR3lsOWl4MGZmeFN1QzhsSzdzWGZRSUlrMTFSTnVDNFQx?=
 =?utf-8?B?OE5lRHNycEg5aWllNElqQVJzNXpITFFSMmZFM0wyMHBuSWMrSWgzdzk5byt0?=
 =?utf-8?B?N2kxMVZhcU1DTk1ydGxkYmQyM0ZmYXFIVGFZcDByVndJYWNJS09jMlZ6VVkw?=
 =?utf-8?B?YlpPd1lPeDJUTHRFbkNtYzFsaVQ0bHpyOXFUL2ZYM2FGQktneGtxQTRvY3h3?=
 =?utf-8?B?MXVqYWtRb0w0YjhQYXFjMFpwa1dPQUREU2pRWFd1dzNoQUtqdnpBZ1ozSnRX?=
 =?utf-8?B?allncng5M1c1MzZZN1F1dC8vVFA1UE0rQjlFODUxVDhjZjBSTXF1SFdIZGZ1?=
 =?utf-8?B?ek5OajFaSXdLL29ZWHptdTg1ZFdpV3dRbW9Kcjh5RTRETmtsYTgyR05zTGt5?=
 =?utf-8?B?c2dvVnYwbVpxclhrNndnM0FHUVFDbUZvY3VsTk00RllNUytSMU1CbFNjTFhO?=
 =?utf-8?B?ZFV5eGVLVEh3SHZMdWMwc3FJNEYwbzl6anUvbndhS0pNZEFSWFh3Z2FsOVBu?=
 =?utf-8?Q?XfvKBErPdZMmqW8pWVRtJiVeRFT0E+jc?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8683.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkZEeTFXWlFReHZ4VG1mS0cwOWdDUFpUQWhQSjhaWGEzaklVaGNNMmp2QVAy?=
 =?utf-8?B?bElXRzd2dDRQVXg0U2lRU2NFWWQ0d1B3ZEFnRDhVTUJwSTFkb04wdzA5M0Zt?=
 =?utf-8?B?S2o3QTNQTGhJb2wvUlNtaUFvZEhmTWFLTHlyYmJFWjErVlUwSHJqLzFlbGFB?=
 =?utf-8?B?NFErbCtaRjJyMGJCamJJb2JUSTZsN3lJRStZWFlYT1dvWmozdGxXN2pudCtY?=
 =?utf-8?B?N0hQcm1KRC9mczYyMGdXQktZeE1SRThFVFhjbHk1NjNrSFk0SndBK0c2UFdI?=
 =?utf-8?B?R0VnNjlTRVJNVG54d0FMUjBudmlMNFZIMldWSzIzRHVoMkJ5YktORmkyajVt?=
 =?utf-8?B?c0I0R1IrNnNKWW9Ja3lDeXl0N3hqeEx3WjlrU3RmQjRMV2Y4U2RvYTZhTXpv?=
 =?utf-8?B?R2MyQnRsaFEzVjZnTHM4SUxXUjFDNmdqVjRiWXphV0tqeW5CZVY2QW5WTXNz?=
 =?utf-8?B?Tk11MFR4VlRuQ2RnWkY4NXM1ZmtJS0pZQUhZQzJUSDUyWGJ0cTBqYmErWTJR?=
 =?utf-8?B?NnQwQlQ4dXB1bUozd0dRODdGd3JJNDJ6MXE4Z3pWU0xPVUpLQTIrWHdlSUtp?=
 =?utf-8?B?OVMxQTJ0Z3ZtZWtURHo1MDh4OWxUQ01MUnovQzNRaDZwU0pCbTBoOFh0TWE5?=
 =?utf-8?B?SngxaTN5a09CdnJJQmRCSnNEOVlwVllQS1dvRGlrdGJTSW1CUnhnYzZKdm1G?=
 =?utf-8?B?bDRwc1NteXFyN21HK0h5V0Zzc3dtanhxWFh0a21jUDVzRHlYMUd3ZE55M1pj?=
 =?utf-8?B?eEdISHpQNFp6akZkWVVSZkRTSWtXNDh2eFY3TmJmWFo5RHkzandDQ0IvbG9T?=
 =?utf-8?B?TWd6bXYyOTU5c0h0K3duRmFPeXFMTHUydmcvakovYW1BL1RSKzZscW9zSnlm?=
 =?utf-8?B?eGlzYWZZemdSY3lFUFI3NXpucGdQNUhmbE5tcldBZDUwWnQ5QzlpK0RjSXhQ?=
 =?utf-8?B?eVdrbVdQb2wzSkRCNU5RQmZDOFVKV3pIc0xUczUyOHlWbEs1dnpTbVF5Unl1?=
 =?utf-8?B?Y1laMUlOR2FOODZubzJJL2hzZW5rVjhnYUJtN1ZmaGM1Z0lkOXdiSWhqL1ZT?=
 =?utf-8?B?UWNxQ0VDOEF5RVZ2RitEeGcxZFJxR2lXRTlaSGNHbUdVaGJ5NTRTWVZFSEdQ?=
 =?utf-8?B?UmludFQyalFFcTZkQ01tbFBSN052cXN0NXp3L29UZ0p5bXl5MlVMWTJGaDNp?=
 =?utf-8?B?QVBvdzRRWkRwZVBYU1V4VzhiY3hRS21BVlc5YTczd0tLUHpWKzB5Q0tyYmRr?=
 =?utf-8?B?MmowNXNxaUwzYW80TStDbkNyZFRIdTF6bDhqMTV4bGN2L3NVbUdKN3lDK2ZY?=
 =?utf-8?B?TDdRRkpQZ01zVkQ3STFRN0gveE93bTZnYjJYckllOXcxNURUWEhDcDdGUUp3?=
 =?utf-8?B?Q0Y5YmJDRnlTWFNXU0lITHdXUWErNnhnSnZDakZSenl5cng0QXZGWUs3emVI?=
 =?utf-8?B?cEtTLzBLS1ZMQWhIV2xtMTRtOWpwb2cwVUNBZjduRHBKTjd3S3ExdWJDMlRU?=
 =?utf-8?B?SUlKcVFna2xsUlRFOFp4TFFyajJkR1pxd05HelZySC9YVUNhOUpJL0M0T0xq?=
 =?utf-8?B?RitDYmlWcnRFSnVYM2NKYkNrdVRkNkowK1hDUmFFc3VKUDQ5aEpGWFQ2K2pt?=
 =?utf-8?B?aU5vd0RzM3RQTlo1aFc2MHMwT0ZaSGZBREtiT1pwYzF3amQ4TmVEVFpyL09p?=
 =?utf-8?B?L2JldExseHVQRUVDbHdRZ29oWEk4bXlpRzNuWk04c0hBL0dQUk5JU1NBekF1?=
 =?utf-8?B?TUpQWkZEa3JyODY3NjFtRUhqcHZwQzQ1ME1QZnJxcVhhY3hUUVRkWDVYLzF5?=
 =?utf-8?B?NkJuQ1FGTTdFTnF6dkIzT28rMmd5QVk3L2lvNVJ4TjJGdjVOMFl4OURPeWRI?=
 =?utf-8?B?QzlYQU1LOHNaeEtaejNxaU01SnRXeU00cW5RMldPTHFRRUtSTitKaThpd2ww?=
 =?utf-8?B?WXhiVmJrRGlLd1R1V2pIZjFNdVg3WHZWSWJ0SDhJbnd5V1haWWJVQmJ6Q3dN?=
 =?utf-8?B?eXV3c0ZkZTZ0M1JNTmFrTzRFN25oeGNYK0FDeG1EUzZiTVNzSjVnNncwU2Ra?=
 =?utf-8?B?M01oa2taeXl0WlpHK0E4SjJPL3cxeklZb1FGQTRreDZYck1aY0VQY0dreFNi?=
 =?utf-8?B?SVAxeTdtODR1R2NnSy9hMkxaV3VwanhqdThmclZKd2g0aUJ4c0x4TTJRbEtP?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b672a02c-c294-4520-6254-08de2237b1af
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8683.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 22:06:13.5916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyttfrrD3wpRKP0SOmHhck0850LhsUpo+1doq8AcAoKdqZKrSHb3raJz50cOrVRP8CBvVKT62mFOuP4dlpgjN0udMzVhTkF8A4Fi5rUeXlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5882
X-OriginatorOrg: intel.com

On 11/11/2025 2:44 AM, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
> 
> [ Upstream commit a0d866bab184161ba155b352650083bf6695e50e ]
> 
> Dirty state can occur when the host VM undergoes a reset while the
> device does not. In such a case, the driver must reset the device before
> it can be used again. As part of this reset, the device capabilities
> are zeroed. Therefore, the driver must read the Preboot status again to
> learn the Preboot state, capabilities, and security configuration.
> 
> Signed-off-by: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
> Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
> Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
Looks good for 6.12-stable. The backport correctly re-reads the preboot
status after recovering from a dirty state, restoring accurate capability
and security information following a VM-only reset.

Thanks,
Konstantin
