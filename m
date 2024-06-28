Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A5C74BE0
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 20:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719608070; cv=fail; b=C1Vtgg0wmpkkWcxzLrosIiy9i3aYLQ/R2jDE/XLl5yVdBCtOKa2xqAk+KYagCk4wwXcCgy89lMxFL68fQyswBMtHHvwDK4GtmWOEs0vYgkxTBAE1s4489oTGt66wI9i2EstRtII8EQ238Z5UEo6Pb05OTkI0VxTBhR7+ZjHcHp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719608070; c=relaxed/simple;
	bh=J2Me/SpAWMl151DPB/JCPF2JGnouWSe0no7g9uPozfM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OSKEDSDUoH+1rvpdzlhBae7RsvEydwctu5J4ps5fdv5odI+9kb37t12ypk3/PdeRVQ+lQL/SjG77oz3HAbzijyCF+SjVrutIP0ohIxktuLOM0qAMTTSxd2gRiEwurWWwykFZTmTHSLXWKQsyG7LxdheG+kFobe42kDTb/3OORJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aerXmvgs; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aerXmvgs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719608067; x=1751144067;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J2Me/SpAWMl151DPB/JCPF2JGnouWSe0no7g9uPozfM=;
  b=aerXmvgsYycj1RCZuxW6Y/axzvWvEVIL2M3w85DSAqo/VekZvYbJkDp6
   IvFQfY2RwckuBEpREPgThDUL/NZMze91xXaaAlbvyN2/H/By7QT46CsVk
   EqoxgkeIaRSzwxvoyXkMzvrRw1oTyYfpGjI4CE8heG0ZKhP/bRRhWTCx0
   Nmd/SDlYm/sZai1xqZRv0gpCtK7TMm58ruGGeBMos0LsrVxiMMxTpDdzU
   iMFok/AumfUhNus+cukn+PPNPgx6cgannJQrRnL/V1lMxFpuZy5RlEYqF
   lQ9lpwPL37Ieku+yUso26Qxv+PgSDL/TZ4A4Xa6JJL6PFW09IzquYfJFS
   Q==;
X-CSE-ConnectionGUID: 8u0KqkA3RRKn14w+nN+poQ==
X-CSE-MsgGUID: wAEAJGHZQfeJgnAkPYqwoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="12307822"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="12307822"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 13:54:27 -0700
X-CSE-ConnectionGUID: GRvlPNdTR+iN4Xk7QBL21A==
X-CSE-MsgGUID: wdKgaec7QimnP2mChbH6bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="76036128"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 13:54:26 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 13:54:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 13:54:26 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 13:54:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gI0pP4cSNpI+ssnQSsD3JzGY/IDyAVD5qaOyYqpUyVZvODQFgXXirVB52U63IOKxUm/nOh/F2TkzrX8hF7tZeNgMbLfMUZVnEGD3/enXnFhmWJZHaG5MFXa2FKiUCTDbtZvIEANZu62QhmKsTLB4QCmjxuE88l03LQgYivaFMNMfTVnr9TsaQrHjZHZYJSDMtwpuZWqo3bBJA4AMO0X6VVCn6uW811j+kwo52AyrTsS5PurQX3BdKtFeLd8H5Z/qQRHjR4Iey6QQ+VrSjUiHlA96LFMvFdVfDtwz4ULF3+9jqbj8BZgZ4y5Sb9exydYZr9kKYfl9KRsrh+OiEbBL4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vK0CTReJ2RC+Wuho/LoXFZmI7CTPWS9dSmaTgVO8Yo=;
 b=IgFdU5UctC1w/d5VpMohIH9R9UhkRBe+oWiputlp2vF4EM3x+JOdaF48LJ/tVPaftI01z7m3i+wUTAqXq86BlpfkQGrEA2LFegxMxZZnYDARvY1Bdb++GuL/bUoDQAmJ2Ieyw2paxV3enQKrUuyB99rtovZHHGxpExT4yFYmNBVUKUBD2gHF5KcJGDkloTm/982mLHEct3On/bTXksfD7Re9YdhcuzkY450/ZQkAFMJwN48Hvv4xtXZj0f/SZi//9Nlqev4zgdMUikI6rwXvT4Tv+QloNYcOcJmiqv2xn0cu78SDlCr5M5/yxcnfr4HG8QYGlngj6KCatdszTQumlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6884.namprd11.prod.outlook.com (2603:10b6:510:203::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.35; Fri, 28 Jun
 2024 20:54:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.033; Fri, 28 Jun 2024
 20:54:23 +0000
Message-ID: <b2fcd6c4-a051-4da5-a595-5c4f6fe5b7af@intel.com>
Date: Fri, 28 Jun 2024 13:54:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 14/18] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240627203856.66628-1-tony.luck@intel.com>
 <20240627203856.66628-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240627203856.66628-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0386.namprd04.prod.outlook.com
 (2603:10b6:303:81::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c9575e4-8968-439f-97e6-08dc97b47d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QkFBODdaWG0xTDB5dUZZbUxuN0Y1MDkxZ1B2R2V1NGRvL2taR29nWGR6cFJv?=
 =?utf-8?B?REE1Y1hibjh0ME0wM09Pcm9Xc0NJMDJVTzd0NW1ocHhQNDVuTHk1REQzQ1ZY?=
 =?utf-8?B?Y2tHUGk1Q3paeXc3TjR2MWFYZ2VFaFo2QlQ0Q2dzb2Rzei9tdnRwZjl1Z3FQ?=
 =?utf-8?B?NFY4Y3UrNDYrSXJoNXkrc0JNQkNwQVJPYjZUV0V2U3lENVZYeUZZWDl3Mk4y?=
 =?utf-8?B?OTE1KzM0M0p5MWJwNVpzWUxXdGtqbGpLVWdKWkErNWVESU9yNU9WbnI5cDhH?=
 =?utf-8?B?K003anI3VjVRVG0yTDVlQUVlRXBneGljUWJPa0xmc3NsSEpseHE3TFozcTFr?=
 =?utf-8?B?Y3J2ZG5FL0xwSHN3MW94eWYzZkc2SW1jME04Y3lwSEpVZ0VHaEc0Tm14Y2Vo?=
 =?utf-8?B?dXdDVVh5TExOMTMxbFJxOXdncGRFSEM1WTlJa1dMeWI3NDN0QXBYcVVsTEZE?=
 =?utf-8?B?dmZLMTZRcVYxWFVPQjlKMUVXRUJKd0tLdkVGb1RxcW1PcEFIM0ZYZCtaV1FW?=
 =?utf-8?B?Sy9zMmVPb0duVnVEVS9KU2IvYVM5WFZaN2VJWUlaSkxOaVV1TVdzT3dqbkp2?=
 =?utf-8?B?amQvN3M0N3RFYU9peHZzMHA3SmdNbTlDdmdUVXZvZDZwSGh1S25MaWtBampQ?=
 =?utf-8?B?ekZxazJGVjBmWXRiM1NKYko2OXY0Ni9ZZlpaanRhd1FBa2hxSlRxdkRxUE1q?=
 =?utf-8?B?T2hFZ1M0Y3NrMkVNeHUzRStDa1ZxQnRlZmxBakFXdHM4OVBINDdoa1pvVjNx?=
 =?utf-8?B?YzVIUWRUZjJ1Z004SjdGQXVobmxkY2NJNG1JN3E0d1VZWGo2OXpvNTRrek5H?=
 =?utf-8?B?SkFmNE1SVkZZbjF5dlVqL0FPOHpiMjBYZUJGNGRLOUZwMU83Y21QaGNQZzdq?=
 =?utf-8?B?d3o1VER4YlExNlpBWUMxaXZheTgwZEIySmtxTHpUTlJDT051NEtUYWZpeEZn?=
 =?utf-8?B?Mmx3bHJrSWZkdlhWWmd3MFNyaHpTdmcycTBFc0VTenY3R2ZLaEUvNGZGOCty?=
 =?utf-8?B?MTZ0cnBMY1owV1haL1FXcklyTXZpUkdkeWxSWDBIU25kNUhPQURGOFFXVUFn?=
 =?utf-8?B?b3JrQkJ5RGFlL2Jhay9pMStoVlgyZDF4K0hQTWFwWDJpRG8zZFhVZGRMaXQ2?=
 =?utf-8?B?WTVLajlVcEZjaWkxTGNadE55bHJqSWt4Lyt2c0duK0dWeHZBdDltUFloOEQy?=
 =?utf-8?B?YWhtSjdLdUNBaFZTaGdEWXV1bFRnQTYwS01yZ0hLYlR4N1p3dWRMbVNXS0NS?=
 =?utf-8?B?cUdJOEREUVB5dHNDMFhiQXIzWnZYTjFFVkM1aitUa0NYQ2lORmY3VjR6OW1h?=
 =?utf-8?B?bzd3Q3ZRZW1PTGFrSHhaUElKRStBTmFaQUdQbkFuQy9ITFJrc1VDV2svQ2x0?=
 =?utf-8?B?UjNuYVVYbjhKUDBNbGM0dmp2TE8rZ0t5a3o4Nm12YXBYak8wTkRXVitHenVv?=
 =?utf-8?B?TGRHbWtEQkNzY2J5Wm00K21xcmMwV3A4UzNpR2dFRklYdmhxbmFhOGpsdk5x?=
 =?utf-8?B?MlpoMy9BUFhFYjM3VGQ5Tm9oMDhBQk1jSFh0bEdHbGg0V2ZNdzhuZHc5YTk5?=
 =?utf-8?B?VVpNWTIrSnFhb0FJVUpnSXR5bEFMWWFkYmVOdGQrT21aeG1qUG4wbTdtUVV2?=
 =?utf-8?B?b0hrN0xwcnIwYTRWSm40MFJFWnhqcTNjV3gxclFTNlg2b0w4ZlhUTHlITkIz?=
 =?utf-8?B?d2xZeWhBYVZYbVBhNzVhZjR0eUgxc1NFc0lnNW9ld255NkZMc0p4VURoTE1P?=
 =?utf-8?B?L3oxbEhaR1JWcGNzRzJmNUlYZGlGR3h0RVRmc3Y0QkN6MnVnUnBibXNuWXho?=
 =?utf-8?B?MUk2bXF4cmpRVDZwMG1nUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3BuRU1pMXB1Vm9sZUhtWHRwWFdSQmdHM05GYmx5VkdFcllLdDNMWmpuNm1E?=
 =?utf-8?B?Ui85Vi8rdVlKWGt5dENFZTE1K2dleWZBaGlhYTNiOElCZVpZdmRrM1BXWmhG?=
 =?utf-8?B?dFFYT2lycTVRT0VYajNvTUVTL21MdUdkbVczc1BNU3BKejFBRm5SVjZSUExE?=
 =?utf-8?B?ZklBeW9hYjRlTGtIdnpBUXJQT3pQNmwzVjNac09lUmMzaStuUDNIdUFBZWxX?=
 =?utf-8?B?WWYwRlFZU2ROMytIUTZTR0gvcVgrUFA1UitETVBEZ0ZFWHFwVnJsQnpoZ0VJ?=
 =?utf-8?B?TmJ1aVFYWWZuRWZNWFdDYmwzNERaK015TE9ISXVpZTZRZVF1VTRmOGltWkZn?=
 =?utf-8?B?ekh2cHFkT2hUdklDdUwvK0k3eVFUZ0tjQkR4M3Mya3ZlZEd1ODBoR29zOTdH?=
 =?utf-8?B?V2pJUzEwVHlIbTc4WjhzY1l3Ukd0eURCbnBEOTQ0ekk4SUplLzREMUFEVlRF?=
 =?utf-8?B?NWk2MDJKME5zRUlzMWs2S1VOTk55ZXp0NTQ0WTRLQ0xZVmk5Y0x6bEcyS0dx?=
 =?utf-8?B?Y2ltUXlNKzFzNVp3cDhUeTJIclFxMTR1R2p2cjJIci83dHNKbmZFR1VKNUI4?=
 =?utf-8?B?bDgwRGRtWFRRTGE0cmRpREc5eHlock8xbUdzYStUSjk2ZjlPUUxiRzkwQ0lR?=
 =?utf-8?B?WTBCaW80ci9JcmtUVnExcmlxb1ZPc0c4eldWZ1EvQzRNVTkxM2JvYmFEaitn?=
 =?utf-8?B?Si9hNjF3ZGtKVVVQcXovVlhDN0pybjJPQ3pjd3VMOE85SXpvajdLbUVSajVP?=
 =?utf-8?B?L09QZG81dWwyWFNWdWFxcVg2U0xPNGdzM0JXMXVrOEJ6TXl4a0RjcitHTnQr?=
 =?utf-8?B?T25TL3pHenc4ekJRTkNONXFHM2pjVzEyVUE3WVVMNXBaVDh0dWhCeE9zanBv?=
 =?utf-8?B?SGw5VkV0KzAxUndJRXlPSmZVb3dWVkFuYzNjR2ZTZ1ZTYmx6QkRRWEhMcFNk?=
 =?utf-8?B?dFdjSEgreVUzdkxzQXpGdWVOTFFOZkpNMkZCQXltd3hkK0kyeld2TVlmSWp5?=
 =?utf-8?B?NitxWVd1a29SVmo0cUlKZU90YVRPT3V4amVPeUtpc1M0T3hBQzNQWGlBcWJw?=
 =?utf-8?B?RzdjU0ptU0xyNEp0WTdqK01zNkJjNjhMcEFPRk9vbUdCZEZxaUxRU3Bsbmdt?=
 =?utf-8?B?MTVBc3Z5Zkp6Mzl4R0Fsa0NyNnB6U25qNTNhV292bGUzWW5JQ3VGUTRnWmdl?=
 =?utf-8?B?VmV3YU5CRCtoTC93Q052NCt3OWdmNGVhV0JoQmoyaTc3VFRKdmdLbE9PS01L?=
 =?utf-8?B?UjRvV0dOSjQvYWJ6Z0s5ekFuZEU4RWFzakM3ZW9FbkNRTTJFTnRDeVFOUWtP?=
 =?utf-8?B?aGRQNll0eW53R2xoWWd4OGMrZGxMaTZMZWRhYkI0S0V1aDVaOXZ3QlpLRGNW?=
 =?utf-8?B?czhFK2ZVVXBEWG5LRTlHNEJaazE5YUVrZDFTa1FMeHVqaDlNaXZZdlNnOW1t?=
 =?utf-8?B?NFVjUnAwZW0venJoK0NFREhFMXR6YjByL2VWbUNxZWJQME9sRk81UWtEQkJB?=
 =?utf-8?B?ZXZ5Y0ZTeTJlWnhLbmpxNUVncXcvK0QxelZSTzZtZHRDTTR6Y2JvUGF6Tjkw?=
 =?utf-8?B?Z3UzZGtoYXFmazBCMnlGM3ZUMXJNTGVxakpzN24yYUFWVVNjN2xzZ2RYa1dx?=
 =?utf-8?B?dEg2Umh4RjlEcW5GbjhhMmtJaEt1eDNpTndSUG00OW9kNkx1dHRHeWxkRjhy?=
 =?utf-8?B?b0djYVNWdTdxMEthOXBmQkU1RGdXL1A5K3E1dTRidTdyQXg3SkNmV0h1dTlp?=
 =?utf-8?B?cks3NmxMYjJES1JUaUhLKytpblJrZFN6cnNNTlF5dkt1SFhacTVBREpkR1dL?=
 =?utf-8?B?M3N3Q2ZWd2VzUHoxZmZQTWlGWlVMbjFuaXYxa1NGdllNeFM5c2xad1JpMDBZ?=
 =?utf-8?B?UG1YSXZwcTdNNXE0ckt5YU5KQlBOZU5jMll5RDhQalFCYUU5UjFMUTdKN3Vl?=
 =?utf-8?B?VmZEdnNHaER4eHBHUE1Wd0ZlQTJPWTdEOWV4YWpnalRtN0FTQ1Vsbi95K1Fr?=
 =?utf-8?B?MkpuMUNFNCtIV2lVQTNlaTlVRGNRTzBWYisrLy9Wa2pkMXFPc2xLMlJJQXJ1?=
 =?utf-8?B?QkFKajNVZE4wKzVBN20rM1k1VldvRkUwQ2lJVU5HRGVwR255QTFJMFVDeGFi?=
 =?utf-8?B?bUJEOVFpbGx4M0xWQVptdDNwc2V4QmF1RmEyQS9lZ0dSbjEzaTBWYnNMV2lK?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9575e4-8968-439f-97e6-08dc97b47d3e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 20:54:23.2344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zR9slCIIoWtveGmYrb6sLT/4KpZdC/cDW5CtG87cwcdxyZwQ/6r813ya/KvRve0TvId6iLlRvYqV5pq9PYPU9vXPH26jxo2GhjmPb9/UZds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6884
X-OriginatorOrg: intel.com

Hi Tony,

On 6/27/24 1:38 PM, Tony Luck wrote:
> mon_event_read() fills out most fields of the struct rmid_read that is
> passed via an smp_call*() function to a CPU that is part of the correct
> domain to read the monitor counters.
> 
> With Sub-NUMA Cluster (SNC) mode there are now two cases to handle:
> 
> 1) Reading a file that returns a value for a single domain.
>     + Choose the CPU to execute from the domain cpu_mask
> 
> 2) Reading a file that must sum across domains sharing an L3 cache
>     instance.
>     + Indicate to called code that a sum is needed by passing a NULL
>       rdt_mon_domain pointer.
>     + Choose the CPU from the L3 shared_cpu_map.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
