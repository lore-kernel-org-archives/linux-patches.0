Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE40419C556
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 03:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755143998; cv=fail; b=Gn8Nh1i2BpfuhJOpMPyzpZ0o/6gi4J96KplKxYfHzpUwO8L167cEIkOSRhxP1bjFaPPsUBHLpoe9hvUkF7jP8qcYKU1nQUafWqDqo9QtN10uu8LiJcvF23qB9US+tlUi+K4eUPYbHe9nCqR1BbBhOF5frVWF9zX5uN4jNB4s1tA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755143998; c=relaxed/simple;
	bh=icI3I77SPk6atOmeb9Gi118wibHKNyaVrhY2AqvSGf0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L+bZ9H/kjdnAXjB8tEz4+z47TPmQV0Ub7BhHN6HVmZERWAo9H3MxSMClrr7OqClfsjyKwZi6545UpwbtyXTDOStLYSnlW48dmx2G9zrskp3wKOS0TRtmwo53efvom0UdIBcULFUlUzUYqgpkoz4Nxsi9nwcTPhnRSy8kMAJ8QDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2Z3ss4G; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2Z3ss4G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755143997; x=1786679997;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=icI3I77SPk6atOmeb9Gi118wibHKNyaVrhY2AqvSGf0=;
  b=C2Z3ss4Gjy6SRTi20iJGOMQeHnNmlOlyx1J7PJ/96U1vIk5TRoSI8KUi
   8xmeWW56tXgLhHzWMWRA++0VCYEoJoHOJZz6qucRUp6K06WY/3LyJ8MrL
   VWP3+hVdXVTs1XtG+EKZUiDirPUN/Gl3XBcRA5NRfnrVUvzICMZPKxJjQ
   V2AAUygK9Qt47TVP/S/P75Gn/JPAR4lPlQVaLEhVpfkCoh6jt24Rw+d5/
   sT1WOvAmA1RDPRUua0jNwwh6j6yq18DXTnasZS54m4DGip6rBNvX7ApFu
   Xqsy/nqyGAzOA9KWM9cnBEIB6SlkUk0VyxPRitamIxao37owl6sfSM/Og
   A==;
X-CSE-ConnectionGUID: FhX6Y9X6Tcukuec1dNijig==
X-CSE-MsgGUID: yAjCEUlPRCK6NnBQ3jjHSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68056937"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="68056937"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:59:56 -0700
X-CSE-ConnectionGUID: ADkOWm7+RymbZIt7gAYUuA==
X-CSE-MsgGUID: 72Y4dNykQSW1sqBgc5JRxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="165872405"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:59:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 20:59:55 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 20:59:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 13 Aug 2025 20:59:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Acy3zbQien+/fdcKPucjXZI/YtlvY+nChvVMr3A8K2OfJX3Fg+VJGul+ohwAb4pS3NpmAOIITSbLaas0Hndx18EcJjh3VE6IQAb1uhz63GaD7P6YML+5pZGWWVpL+VKwaY7sdDFU53/RQsWEOL/Ri/iNYJP8QIeWpSvcbU2xDVTtSJne1MwaXnFuL92+zegAw/OXq0VNgFpzDsI7xrpodoVvznL+p/uRyiFN++finzPMyMt5goNlpPwDnTCcnmyW/VdiaBFH9IRCFp+O+HZl5QCXWqVgLYiK9kS3iNQITtAuzsBPhi+LK+tChGc7UB9wHVQbLoe+WQPEKWDvuTr45g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIDnuaew682VyFYd9wtcoMd/13pcJkwPrssHFr70MoQ=;
 b=XoVqE7Rhk/67XTA/d26Q7Ub7FCYnOwUAbSyNj3jQWIbHdnfO0zxt6NAPNHu9cdH/b1/VCM6mc2imlwkvVb6I9lkhGTEU9i3XNu1m+PE2/DGi89Dbj66FzoptYzgIjWsEwW2xUN2xl9edxIGb9ddmFCA+LZKoHPRMfzVgfUtRP0PsQ5pQ6ZdPtFCwQ6RK0nJee7yEvgeCOIZ7gYGyKV1QEBcnCFfu28ivx3H/gJAGKmpCS7x56h8tler8c/1IdMPeoxoi0q+CGtH9Ij8qOtDkCHVbb8cCZ+N1xE3rr81HILnUUXd5VeG/XIMXzvR6y1W+uOajKQk0y25CR8fII9UDRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5198.namprd11.prod.outlook.com (2603:10b6:a03:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 03:59:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 03:59:53 +0000
Message-ID: <0825f3c0-58f2-4421-912b-cb4964e4f6c9@intel.com>
Date: Wed, 13 Aug 2025 20:59:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/32] x86/resctrl: Clean up domain_remove_cpu_ctrl()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0001.namprd16.prod.outlook.com (2603:10b6:907::14)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: ce82217d-e0c2-4af2-e493-08dddae70637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cVdQb29IY0lRWlc0V242dGlWMk1GOG12T2RPbjZEdEJ5NnV5NXJ1SUF6a1V6?=
 =?utf-8?B?V0lIUjhwRmRMM3J4azQ5aEpGa3NYLzFhQi9FOUZkVm5UMUZTdFJ5SUw5SG1a?=
 =?utf-8?B?NEhZK3hwWWVnSHpHVEZTaFlFclJFVmNJeUtIQmNJU1UxZC93THNQYUNiMWhw?=
 =?utf-8?B?VkNzR0txYWJzanpvUjR5LzFOejhwRjFBc0ZaZHNEcFdVUkVMdnp0UkJnVi9T?=
 =?utf-8?B?WXh1ODRHSkRRb2VYRENpWUdaVDhhbGQraEZCUGlIQks0Um9NWlBxOG1TVEhz?=
 =?utf-8?B?YlFsSWtSaVIzaE1BVm4vYyswWGRIenQzaGk1Q3U0NUlJZkQwU0FqcUx4TXRZ?=
 =?utf-8?B?dHJwM2d3bWhnbWpUMGNBT25mNTRoNmxSKzJsWGhuaDRBMFNmYi8yaGkzK2dN?=
 =?utf-8?B?ZlR6NnFndEdndzcvVmFDMlo4VjFYMDhKRXVJMDRHYW5Qakd6NG1VMDdPa0JH?=
 =?utf-8?B?cWtPeC9qNzdEeDUrR3RlblVjTEVRaUZ6NWxLNThHVVpCV3gySytma0hqaVB1?=
 =?utf-8?B?TTlHamZ3empkUlJHK2tYcTdHS2Z4NllrQWtINGJLczBEd3Zqb0ozckhYYTJt?=
 =?utf-8?B?L2pFdzVRcDgrQjBDL21vYWFXNTdIRllzRis0M1dhdzgwTzFqSmV3VlNaOTN3?=
 =?utf-8?B?a0pmZEdMRDJ6MGRyeTBqWE1WOS9yektNeDVUVWVDSlVXaFJuRXVPNWFPTnQw?=
 =?utf-8?B?MkhTN0hOYWxpY0RvbEdPM1lZRmxhM3pFSnh5RTh0TWQvdTdkS2pnOWpNamZu?=
 =?utf-8?B?dldqVmd3QlU0cjQrbGx3ZGdmcDRWSXRUVnd2T3FPRCsreXB3UjdteVBrZktY?=
 =?utf-8?B?ZTAyODNlNURnMTJaYlBHazltZVJ2UkhGWTJGSm1GTkxzWFFJdXpQcU1GMXE0?=
 =?utf-8?B?RDZ4L3J3VVF1WVM2MGxWcXkySGlENXBuYjQzLzAwc200c253OGdQaWdlT3cw?=
 =?utf-8?B?SkdvT1pnaFhUQVBldS9xL1B6eVo2VFpqZHU0RDZlZFo1SmM4czdjTUp6TWpv?=
 =?utf-8?B?VkF4L2V4TzVVeWJ5bHFZWDg3RjBQMHpLUTdQeWZtR0VkeW5mdEI3OXN3VGsw?=
 =?utf-8?B?clBweUkxWEw2SVRUZmNDTkUvaXE5Uzc2dWVTaHNtTmM2clN3SHc5MlFIYUk0?=
 =?utf-8?B?NTRSUm0yWUl6ZG5Ya3RIamJ4OWVWS0JiL1REc05YbjdKTDFYTDRVT1JUdnJV?=
 =?utf-8?B?ZnZDT2FreURLRDdLbExtTkcyNitpbVQzcDhyS09ZeXdmaEhnQnFqV3V0Q2lq?=
 =?utf-8?B?bmlFM205a1p4RlpXNUlHMVFDMmxKdWhuWElUSEl4dkhvcCtpTmlKemgrbnpl?=
 =?utf-8?B?K2VyK3B6b0g5UkwvcktXQjlKRllNdXZzTFJUTkF6aS96b0htOWw5SkdZNUI3?=
 =?utf-8?B?V3V4MXB3dFk5aUdCVmlYeUdGbWFlS0VhUTJpN20rOXZlMTdjR2VFWjM3UkUx?=
 =?utf-8?B?eXpMcjlPMnFYcWpaRkxvSHVoelN3QTFKeGlLcUo1MjJ4bzdmY25Yd0F6aHND?=
 =?utf-8?B?ZGljWHo5eElmV0NTaVMrRWU5WkxJcXBsMVhrRmxUQjR2TkJNSTNVTnI2RDdE?=
 =?utf-8?B?cDhyZWZYdzM4a3ZzZXEveXNZTDlEZGhVdXVqSHRmNTNpVkEzWkxYZmU0L3JL?=
 =?utf-8?B?bTJEbE5hOEs4MnIxeXhBOS9IWmZCMzM2eDNsWm9QNWVWbk1ick1PenQ1R0li?=
 =?utf-8?B?bkZTL0Vnb045TmVRZWdDV2k0czdPS1RBZUZqMjZVTEpGUlpkdGJpZDc0d2pU?=
 =?utf-8?B?TWxjRzV4WGdqMUFKZVVoVjA2YUtEZWRQdjRsSlZCYklubnFEdnRDUU1yRVFM?=
 =?utf-8?B?OWh4MHV4d1ppcFRDTkFFZnJnVXFBZ3dvNzJVd3VwbmpYa2pOazdyWlduZFhx?=
 =?utf-8?B?cmFxczJ3cVVGM1JBRktpL25vbHVWZ2RkenhkYWtuZmpHS1pZeEdYeGJ6V0hX?=
 =?utf-8?B?QUE4THFac1V2WjgzOEVROXhKWUhJck5WdzFGU1lyTkVwODFmZHByalZtVDhN?=
 =?utf-8?B?RlVJTE9XbVJBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2lENFBoQTJhMWpjQStNN3ZJTzhqYnl3ZlVxWmhmMG5CS2FxNlNQbjFRZHI5?=
 =?utf-8?B?YU42WFkwMlNUU2NVQUdCZXp2WVRTOVRkQW42aHQ4VGdlbkZEWTY2OEdhSmp6?=
 =?utf-8?B?MjNhckhkY2lnQk5ua1NVa2J0WUZPS1N6WE9kRjVUZXh6Zm9QRHdFYW10akxq?=
 =?utf-8?B?b0ZRd2RDSk1qdTdSS1NNZHRGUmZ6WXIrN3J5UDN1S1M0ZlZranVYRkJBdlp0?=
 =?utf-8?B?K0pGQ05qR09yMm5mbysxQ1N1cmhHYmhHRjVHVmRSZHE3OHQ0WTQxUUE2bmZ5?=
 =?utf-8?B?dVJEQzBINkdTMmNlZHVkVDV6MTIveGUyalNBSnM1M0RTUWhMVXY1MzZvNzlt?=
 =?utf-8?B?R01mUHJjRHpwVXF2RzJYaC9mV1gwSG1PM3dCL3lUaWk4VktqU3dteWJQQ21h?=
 =?utf-8?B?M3JiM3A0UkpiTzZ5YXROWnduM1o5RWF4WU9EZXVqS2hwTHNrVzlnbVl2YnZF?=
 =?utf-8?B?ZHdzQWJUOFRLazk1QzRDVXlKTDdjbUVWK3FVUzlGN0RHTjVvZ0hiUDRIUmU2?=
 =?utf-8?B?L1dMaWxrVEJYVTJSQW9yUlBYSjJqUWMzRXZJa0hJbE50QXdwNkx6b1RKc3ND?=
 =?utf-8?B?OWxJMTRtUzRHaktKYktWMFNiRWR5ZUhZUlFuQXB0ZWtPSnhsNUlaNkszdzkr?=
 =?utf-8?B?RmdFaXZuelhKOFUrblpMSzhtaDlXKzJCckJlSzIzS1RPMTZ6MUU5S3pvMU9Q?=
 =?utf-8?B?eTgyc25XRE5QbHY4Z0RFZ3gvZGQvemg1TnRzQUF1UUNXdk90WGtjWXJ0bkZm?=
 =?utf-8?B?R2hWNFJpRU9JcGt5RzBXMTc4cWRyOUhqaG8rYTV0U3dEQWl5cVl1RjZNU05U?=
 =?utf-8?B?dE5QOEo3VmJqSmx6NlNWNWtLYk0zZlBISnhtaThCM2tCeFFtSzFJWHhtNHVz?=
 =?utf-8?B?K21WTzVVbW95ZkNCSFgrazQ1THdjTTF5ZVFOdDA3V1Y3ellkYllOTklqeXpU?=
 =?utf-8?B?V09OYlVXQkE0SE5JTTNFWnhlMlRaODAzSWZkTSt2UC9RY0d1ZnBLMHpXakF3?=
 =?utf-8?B?L1F5RXJXa0ZEQ0Y2azVrK3ozUXBQUkVlZk5VaHg3QzJKYlQxcjZsL1M1bENU?=
 =?utf-8?B?eG9wQk9tbDVZN1hxTElFc3J4cXowc0FNNEZrZ3U3aGJCN0VBUlQ0SU04Ujdm?=
 =?utf-8?B?YmRqdFNLNUZmVzlrc1dKcEVVUTF0UWlLWHpuSEszYURKc1o1aGxONk5XK3dF?=
 =?utf-8?B?NHE1QXZ1N1U1UzVCR0Z1M2VzNUN4OGhPUzBTWE9GQXpFNnVZRk83YmNDK2Qz?=
 =?utf-8?B?NjAzTEJNSW4vTXZVSFNsZlNwNDNmYWxUdEZPb3NOMkNaekpXNDMxa25BaHhl?=
 =?utf-8?B?VllUakI4bjFLMzlaNDhLVFlnMkR2UTBMdXlLazBKVVVFaDluWnZpdjFva0VG?=
 =?utf-8?B?Y3VJcElIbnlBcmFCeTIvOStCYWZqZHBteUR3MEhkOXhDa3BnWkdicXRpTGRV?=
 =?utf-8?B?eVAvMVRnNUlpNXpCUFZVY2lhajBHSHNLTGorSG1LV2hpUThRUzVtQzdLUUpP?=
 =?utf-8?B?d21WQllXTDg4Ni9mcUxyOHlqWSs3MmIxOWJmVXBHeXB3c1BPNHUxY2hrbEJi?=
 =?utf-8?B?ZDh1NEtGUncwWkwzcDVSa0xzWlNTMk16eHI5b1Uzd2ZHMlNUUDhPeHhnL0ln?=
 =?utf-8?B?QzNGaS92OXA1MHp5RktXWDlpSnRqNjM0WERsRWp3UGxJU1Ava1RURm05M1RV?=
 =?utf-8?B?M2hmcHdvQ3g1cjVSdTlidDI4MWx0YlhjOTlTY0tzWDVOS1J5N042dml3MVhE?=
 =?utf-8?B?WVpzN3RKMWJDR1RpNW9XemRRQmtIZXFZZjNPVjdDMkpPNTdVVzdjTXpxMXU0?=
 =?utf-8?B?MCtRYitMK3NHL2NVU2ZhdGJodW14YjdRWkdIUE9BRUsvRDgwdXdyeFFoODNo?=
 =?utf-8?B?Y3laWkJNMm9Qa3prQzJMeUhad3dYT3VsUngxSWorTHZiL3QyS1BpaXY3RWQy?=
 =?utf-8?B?NDBsL3dTbDNDeWpjTitUV2dvZDJ2dGJYaGY1dDErb25YTVJDQk5xaTRVajF2?=
 =?utf-8?B?YlVac1FjMU9CdEF6cHZVUFFseGJSUnFURnhMWFg0eEhzenI5Mi9JUEtYYlNn?=
 =?utf-8?B?NzAyK2pmc2pzanZTUnFMQ0JaV3BaRTNsQTVObEV3TUJJQzY5RGgxcUVZNkdr?=
 =?utf-8?B?MFlFUEVRbE5ZRS95bUhManJzOEh3ZXcway9nTktZeEphd2lCUHIxUFpkSHoz?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce82217d-e0c2-4af2-e493-08dddae70637
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 03:59:53.4259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Kt1rQ7mu0RMXLE+fiWZKiFwOhi0n0F/ljojj1AlU0Id/o/g/4HU1FvVGeO5PBMCTBdWX+Styo+Ilfs7AVUk9tR2JoW7b0CjFNLZUsajs20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5198
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> For symmetry with domain_remove_cpu_mon() refactor to take an
> early return when removing a CPU does not empty the domain.

"refactor" -> "refactor domain_remove_cpu_ctrl()"
so that changelog stands on its own and is not continuation of subject.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 448c2bf9837d..911100994fcd 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -603,25 +603,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>  		return;
>  
> +	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
> +	if (!cpumask_empty(&hdr->cpu_mask))
> +		return;
> +

Here is another instance where the domain_header_is_valid() checking is
moved away from the subsequent container_of() that it is intended to protect.

>  	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
>  	hw_dom = resctrl_to_arch_ctrl_dom(d);
>  
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (cpumask_empty(&d->hdr.cpu_mask)) {
> -		resctrl_offline_ctrl_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> -		synchronize_rcu();
> -
> -		/*
> -		 * rdt_ctrl_domain "d" is going to be freed below, so clear
> -		 * its pointer from pseudo_lock_region struct.
> -		 */
> -		if (d->plr)
> -			d->plr->d = NULL;
> -		ctrl_domain_free(hw_dom);
> +	resctrl_offline_ctrl_domain(r, d);
> +	list_del_rcu(&d->hdr.list);

Missing the change mentioned in cover letter.

> +	synchronize_rcu();
>  
> -		return;
> -	}
> +	/*
> +	 * rdt_ctrl_domain "d" is going to be freed below, so clear
> +	 * its pointer from pseudo_lock_region struct.
> +	 */
> +	if (d->plr)
> +		d->plr->d = NULL;
> +	ctrl_domain_free(hw_dom);
>  }
>  
>  static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)

Reinette
