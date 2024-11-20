Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751341B7F4
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 03:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732073975; cv=fail; b=DoISkTZtsxDIgVfg5DLMuLbar0iz6vsiMBE7dIcOA+8ruaqdP1Bmj6U0byTiFiJIkU/zwicXuUq1UxdG1PabW5+u2bQCB3CXyuNdbZB0WtAUnZPZg3bPoQC3+L3Ma9ceKwx9w0PjBKFlrfdYR3VA6BMPm0GFK2AllpHM+QlP4/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732073975; c=relaxed/simple;
	bh=1wl4kh+3x4FV0uMztlbGLTInGtpdfvhj8c8nwko5Jm4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZN5wAIV0MTkQKr0YE9NjnX5baceeU+hHuzG1vOMPArTZqW7iXu8glGwi15zcP7EW/HtkkL1bNvMcjnmlUBgU1/alAn5cpOeIYm4IFIVBcT2ZwznrE7QGXwHxKH8VXQZAsRRKYJK6GggWX4k2Do4Oj6TB17UUT4WfJfsl+yytzdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ams4599X; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ams4599X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732073973; x=1763609973;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1wl4kh+3x4FV0uMztlbGLTInGtpdfvhj8c8nwko5Jm4=;
  b=ams4599XK6F6V1huf5qJUEHNstnO2uO5zHsIXuk+tjZuPVdVIhOFUqKb
   VcazU2OPCXgpOPmcgh24boyTnMn7dRhIaVT1eQRPD+qMhcFzDrTC2tiio
   YLpZtN0lcqcMyeB6mxYLUPHLOndwlMt08u+oh/SrJrftEvgx7fZSbS6Jz
   FbjUpDS1VXLXzS0RyGmMTs45eVbKA/oua34Ri+6W74QThH2omFCnpjScu
   W/UBBugCNkrEVk5oP4rj/xMr8LOUFYtjd85nHTSbPLJGKToC3WecqJ/wy
   1us6a2dRz9IxUZC4lzyJgF6HhJ44FwPX/peKw3P4ndGHchCIRVNmHC335
   g==;
X-CSE-ConnectionGUID: 7msW2Cl0SA+SFraE579f+A==
X-CSE-MsgGUID: 8boPqvhjSOyx46Cd24DqFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="35895237"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="35895237"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 19:39:33 -0800
X-CSE-ConnectionGUID: c5TBB0AUTGuGixMMnG38zw==
X-CSE-MsgGUID: qoWrbIXgTLWYo3l9sk6CMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="90596278"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Nov 2024 19:39:33 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 19 Nov 2024 19:39:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 19 Nov 2024 19:39:32 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 19 Nov 2024 19:39:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EQ6l3vx1rchCx20bNS08F/zwwfhHIyoapPvhJZs4+OkftwpPUbX5P1BZYY7lNsmGPdOCWWL2UdAB3RYSVFtktrVByuekobCOY9vD+xffbkbqfT9MCgwhcZmQpR6nSSozAc/h6eqsyzYTm/nYsKTHyhHqwhsFSTdflnGAhtE6ZhOMLWbSQu3t0wJCaRYt4m1s45p47E1R62/ZS99Q4cj8861DziN1FcVaQzxZcVPjoKJ041OzTwCcT2FVtmCWjFeMaDkU/gPVf/FedV0wDHPd+NsA/JW7qMHiyFjlZlPpjE6j2rspVxO54TXmPnUW3ghhU6Ycd6aWSyAo4CPKhbSYdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+Kb+45pH9z8w7b7yTFxeahXOpzi+tOAGWwHdPvPC9M=;
 b=to2jqzJbGBZfzA1KareOUGkeqeIJM+khXhvklVlctAsLOOxKxVqAiA2SW/nwDMMHdO7d+5dfscbEnCmLZaOQe05GcJkw/ssqLvpUEcrb2biH9CwReaUqIBmUfgF9WoOAWscpGAiuhyfCcZl6lESbIreTPbGzuvMo8sBAebQvGcPuaHgtOWix4PE/9X6o37EBL1u3ItfSDPCISCmL+eazVXgHtracnMMf36aj2nJ5iMcFp4Y4cEkLTI6P6qmBo8MoJGbQ/1A14odPPf+um9CaMPr3UXGtcwfUTo5lz+TgdmvQdhpn1MJGsWaRwDb+LDDkr3bRH4PL3A17jWPiF185SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL1PR11MB6004.namprd11.prod.outlook.com (2603:10b6:208:390::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Wed, 20 Nov
 2024 03:39:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Wed, 20 Nov 2024
 03:39:29 +0000
Message-ID: <156beac1-4596-4e39-bb04-d3f508bbb552@intel.com>
Date: Tue, 19 Nov 2024 19:39:27 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/9] x86/resctrl: Modify update_mba_bw() to use per
 ctrl_mon group event
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241114001712.80315-4-tony.luck@intel.com>
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL1PR11MB6004:EE_
X-MS-Office365-Filtering-Correlation-Id: 13700198-c744-4439-122a-08dd0914f05f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RGE4ZElvOXNaS2UrbGVablZUV3Rydk9VdlVVR05lVktmczdKbTZFOGZHeHhE?=
 =?utf-8?B?cHZOdU5McHl0bU9GUVdmOUI1aGRGRGpmVzN5NkZnYWJyenRJY2ErM0VUUTVh?=
 =?utf-8?B?QTQ2MCtHVjVQb2dLQ2FFdVA4WjUyeFMyL1hVKzNRZXRCY0xTQzlNdDVLaHIv?=
 =?utf-8?B?ZW1NcmJodi8wOFZaK2lJd3hobm0zODNla0c1NU9oaytLUXA0OXJLQWRtaGFE?=
 =?utf-8?B?cWdrQmluL0lya0hDa1ZDOEgyeUgwU0pFckNObU9yVWFKSHhienZ2NTYzNmNU?=
 =?utf-8?B?bXBETGMvVmxvcGRBRU1hemFpRmRXUUJKVmpSNmVlU0pOSGRSaVJMV2k4bnFD?=
 =?utf-8?B?TFBnNThaVW5UWXRkbVZLVFRVdU9XV2hjTUgwdkdNQ284QmlYMkFVc3J3VGd2?=
 =?utf-8?B?TVVUR055dTd6M0RZN0o0UXFHakZlWitBbktuVDlUZkwyN2N5SytaQlhoNm1a?=
 =?utf-8?B?a1pKNjN0WnUrQ2dIYWhxaTJOUURyanV5Q3NOcHg5c0pNZWZ4ajhhSno3cS9x?=
 =?utf-8?B?ckdVQmpSM09mVzc1bUlJS2RhWDd5L2xXME0xVy9nOVBySzg4cENncWhOeEtU?=
 =?utf-8?B?Y0lBL3NSelBiMDNTaVV0bm91a3V0K0hTZDg5WnR1RXpKcDdIY21EL00zWEln?=
 =?utf-8?B?bzY5QzlaQm5TMHBnOXp3M1IvWlpsUXNySEVNRk1DK0IvNllYNjlub2ZnYy9G?=
 =?utf-8?B?aHVXOTA5Z0NRQzJpcmhFdkVXWlJlK2JzV1dWai9kNDJMOTFoK1hVY2pXL1dD?=
 =?utf-8?B?bUZEN0ZpSGdaUFpmV3dpeWZQWnpuN2swd2VORGFDc0JUK0dhRmhBV3B0dWsv?=
 =?utf-8?B?NHBWekg2TVdXT2doSDRaamg2WHYycW5VSEV3ckFYM3VESzZCaWJKTmh1K2p5?=
 =?utf-8?B?c1UvdVFFQVRGSWNtaDBaaGxlQmhMdTZza056VHhGMUxsRGQ0ZFVRUFowc3k2?=
 =?utf-8?B?amIwWUFucmhBVWFFV0RiZ0RFNFBkY1Z1aFU2bTNoK0lhRUhEeTdtY2dPeFA0?=
 =?utf-8?B?WnJkanM0Z3o4aDd3QUdnNHEwU1ZkS1VCY0YwTlhGYWhPZXF5UXJ1ZmQ1TlRS?=
 =?utf-8?B?eFJVZ3lORzdlSGZIOUw0UUk0eDBpNlFLK1VzYVVId2hoTXZEQlRESTl1d1JG?=
 =?utf-8?B?T1lya0ErKzRUK0pEMzluTDc2VUo3bXdZT0wvSFptR0hrV2lYQjE1SitRNnFx?=
 =?utf-8?B?ZEF0eEIyOVloWllKS1A5YTBEb21zRDJPS1RuNENIUFNKMFp2K2ZzNXovRFJR?=
 =?utf-8?B?QWJtNGNFcEpHaEJDQXpUQWRIN2c0VEFKY1lNNnNjY3NyNlg1ZEtQblZ5ZTlv?=
 =?utf-8?B?OGdESXZHZlBWdFFpanFDbG5LN2F1MWlpZS80T2oxVUJSVXk4SE1za1hXNS9B?=
 =?utf-8?B?RTB3RXp1SEdINXFnSks0U3l1RVp5RThZYWJWN0lYRjhuQ1Rhd01TMHpPa0lT?=
 =?utf-8?B?emo5U2F6aFp4M3NvOEpUaWRFTXJDSTZnM2VIYlVSQ2ZTS1J0T3krTEFRcklu?=
 =?utf-8?B?enpvazVIbzZXa3hMRmxaNHRNeUdmOThJT2tlU0xJMjZPZHc0dnFiSjlqa2w4?=
 =?utf-8?B?R3dHS0pUNVJjNkQwRE9rTE9QUllxMndVQk9tZUxIZk93SjBHTzIyU3RFVkh6?=
 =?utf-8?B?aHdQc3BoK3NKZFcrbS81MG5lRnFKZ2xaNVIvdU84WUJ4UjRWSFV0QVJGUHIr?=
 =?utf-8?B?aURqQXRXWEUxVkhBMHM4NW5XUDdkUjFmL2JPNEtla0xLblUzeDg3SkFkWXJp?=
 =?utf-8?Q?9awYlz4Tm50Or9aDbbUxAvjb/Ul8KVxxss6CrKs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amlud2dBcjlNdDlMRmtWc1NoZnNLVGIwWjNEZlE3NVowTU1WdE5PUmZ3TXow?=
 =?utf-8?B?bW1iSXVQRUVlT3VzVnpKdHFYUjA4TGdwMjRvRjlzc2NLamdVYWlYeFZ5ZHpH?=
 =?utf-8?B?eXZSTVB0TE1pYS9GYmsxYm5INHhyWG11aWxSelVUU2pqS1AzMkVyRmN4ejBJ?=
 =?utf-8?B?dWZheS9mYXllNlVkekJPN1dDbjFqLzBLOXBVYkl2STlxeDRMT2E2YkFMZjVv?=
 =?utf-8?B?VVNYY21lK3QwR0NVc2w1NDhmd25WYW42bTF0ZzA1NXFWL2QzeHYrMTlEbGZ3?=
 =?utf-8?B?SmNSalZuMEpZZ1k2azJVbWJLUk9WWHcxakxLNTBEMlB5WVVtZzVLdWtncENI?=
 =?utf-8?B?azVoQ0cxV0pkSERLZ0tDZklXSjhTOC9VMXJKY2ZVa05wSE5MakJiMFdCVUhH?=
 =?utf-8?B?aERuSUpZRjJNR0JXeTkxdTRVZTlNZktsdnY3aVQrWW5udjRwNnhtU2tzR3o3?=
 =?utf-8?B?dFdmc09zZnNYNndvYUZxTFZSVWVwZUxHUzVwYktDd1VSSGp4UHJRVXFoN1Jh?=
 =?utf-8?B?NUhyMGZZcGtab05kVGg0NUNpTjduV1ArdzhWOTZJNFlpSUo2VGlmM3g5K08x?=
 =?utf-8?B?ZStlS2pCNDk2TEFSdit4NTFUd1ZCbnhjbW9WbVlBR2QzUHRaUER0R1B4N2N2?=
 =?utf-8?B?QWFKTFJJZEFhL1hhWXdwYVk0R2Vaa0xGU0RXTUNrcFg0cVVJZEFpajRYZUtt?=
 =?utf-8?B?VTcvcTJGTlhTM3ozSGlFY0tHT3Y1dlV0OFFyVmltTHhkSElIU3lsVU05TzRl?=
 =?utf-8?B?akMrQjgwemFiRDV6SHB6SzZ3dFZaSVByMTBkd0R2b2VRUWNSTjlZOXdvaXA0?=
 =?utf-8?B?SzJiaWhQUmJHSm5BSzJuWVBjdmxCNmlrTVlmWlN1dUExSVY4YjJUeTl3Rzdq?=
 =?utf-8?B?VDJocytScG9wNGFZa1hPVmoxYkJYWlJ0L0xkMGMvYkhLeitmVVBhS0I3ellP?=
 =?utf-8?B?VEdVOWxha1JIRXBqdUVYOHRzL3hMRldydmhoOW1ZZ29MWlhUWklpdUp3aEZq?=
 =?utf-8?B?aC9ZaGdWL2RWWVdYdkV3UXFjRU5Mc2NNd3RWelRQeHd3NUx6eHF1U00zTGFu?=
 =?utf-8?B?YWtvZ0dEM0Y1blY5MkVuZS92Z05TNkZzN3N2a0NPSDlPaGt1aHUzcnI5MFF4?=
 =?utf-8?B?OWVzWUg0NUpKM0QxMVBIaDArVU5yQnlVVDZOdmIxWDQ2VmlOeXlwL3pQVElS?=
 =?utf-8?B?STN2bFlJbUt0MmxRRjFaanQ3eDN2M1MvVGpOcGRqM01iVU9GUEY5ODJ4eVlq?=
 =?utf-8?B?UTFna1JXTUpuSGFwUVFIcXpjWHYzektpeTlXeVlYN3hBNWp0TVIwSkZEMWZh?=
 =?utf-8?B?RVBKUGprcHBhRUY0bFU0ZnYrVGRXaTNxNnQwOU9MWHo1d0t4d3M1cjNBZWlQ?=
 =?utf-8?B?L2dpMEplUjFxOXRDclVWa2ZyZFE3cHpEbHBudEFzRWVTVFFMdis0VDVwUW5a?=
 =?utf-8?B?M0VTNkFRMEN6M25xUzQ2WXFkbG5qU3JyVTJnR1p2NjhtWnRWb3dZQm1QRkpE?=
 =?utf-8?B?ejN0UmhUNmxPUlNUMUd6WUJSYi9jZWE0dFE1WlhhSlIzbG54eml1c3lrNEpt?=
 =?utf-8?B?aERtTU5XdmpVQ1lqWGVDL2tWbExibENGeHRXSXZ0UnpsVEgvRGxIc3V3T0Vp?=
 =?utf-8?B?ODRMY00rQkN3eGM3WXNoR2U4VlF2b3kyYmVlUkNtL25CaXBHMWZZWHdUNW52?=
 =?utf-8?B?MnAvYXZyeENXRjNGanJCRjlydEI4U2psaXdVdEZUVGVhUmlwblVJdW93V1FV?=
 =?utf-8?B?VERrSjYrNEJ3ZStuU2tZK0hzRTVueXdDS0d2U0h2SHdDUkF1dmFaOEJicmNG?=
 =?utf-8?B?UDUxQUZ4bmlIOTdsNkFUQjZJdXVCdkxjeDNELy9mdnhEenNrZE5UZjRheksw?=
 =?utf-8?B?SE9BbmR6L0JQa1NNNldqcm9IeXhabWdWRG1vbW1za25Ea0Z1UDRCbGJhTmlu?=
 =?utf-8?B?bHFmQmx6d1A2c0hienczbFZiQURsR1RtdW8vQVRnU0Q1TU5lSU43Q3IvdjFJ?=
 =?utf-8?B?dEhYOHE4dHlTRVo0RUQ2OWNKK2hZa3hDSDJOMUxSUGY3VkpRQS9rcDF2NWVs?=
 =?utf-8?B?N1FaSUhuOWFuOU5sQU84UDlEVEpPdk9GZlk1L2VWSXkrNDdPYk9IOTQxRHEw?=
 =?utf-8?B?VTFoNXdqVVpIWkROSExPVHdMRjVkS1h3ZlBDaW50QUNVMDJOQXpRRTBjS0Rl?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13700198-c744-4439-122a-08dd0914f05f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 03:39:29.4415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXqS0KwH6v9IZXaKbTMAM2ZS4otZiOqmH+2haTajgj92BiBU/e+ITAeZ+0MJ0ryNkzWxIEtcu6ADlZAFFES7UE7LLJmkuhhaVaPmYF9jPns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6004
X-OriginatorOrg: intel.com

Hi Tony,

On 11/13/24 4:17 PM, Tony Luck wrote:
> Instead of hard-coding the memory bandwidth local event as the
> input to the mba_sc feedback look, use the event that the user

"feedback look" -> "feedback loop"

> configured for each ctrl_mon group.

From "Changelog" in Documentation/process/maintainer-tip.rst:
	"It's also useful to structure the changelog into several paragraphs and not     
	 lump everything together into a single one. A good structure is to explain      
	 the context, the problem and the solution in separate paragraphs and this       
	 order."

I do not find there to be a context nor problem description in the
changelog. Do you believe this changelog is appropriate for tip? Am I missing
something?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/monitor.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 7ef1a293cc13..2176e355e864 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -752,20 +752,31 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>  	u32 closid, rmid, cur_msr_val, new_msr_val;
>  	struct mbm_state *pmbm_data, *cmbm_data;
>  	struct rdt_ctrl_domain *dom_mba;
> +	enum resctrl_event_id evt_id;
>  	struct rdt_resource *r_mba;
> -	u32 cur_bw, user_bw, idx;
>  	struct list_head *head;
>  	struct rdtgroup *entry;
> +	u32 cur_bw, user_bw;
>  
> -	if (!is_mbm_local_enabled())
> +	if (!is_mbm_enabled())

This change in the check is unexpected because at this point the event is still enforced to be
local MBM. This change is also undocumented so difficult to reason about.

>  		return;
>  
>  	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> +	evt_id = rgrp->mba_mbps_event;

(To also answer the question in https://lore.kernel.org/all/Zzvtj8n1_ukhnRWT@agluck-desk3/ )

One key point from previous patch is that there is a new "contract" that rgrp->mba_mbps_event
is valid if mba_sc is enabled. If that contract is respected with appropriate initialization
and change of rgrp->mba_mbps_event then I do not believe that the three checks below
nor the "is_mbm_enabled()" above in reader of rgrp->mba_mbps_event are necessary since the
access of rgrp->mba_mbps_event is within "contract".
Note that caller does the checking if mba_sc is enabled:
	if (is_mba_sc(NULL))
		update_mba_bw(prgrp, d);

Thus doing same check within update_mba_bw() should not be necessary. 

It does take a lot of digging to understand so it would really be helpful to document these types
of design decisions and reinforce them through the series.

> +
> +	if (WARN_ON_ONCE(!is_mbm_event(evt_id)))
> +		return;
> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_LOCAL_EVENT_ID && !is_mbm_local_enabled()))
> +		return;
> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_TOTAL_EVENT_ID && !is_mbm_total_enabled()))
> +		return;
> +
>  
>  	closid = rgrp->closid;
>  	rmid = rgrp->mon.rmid;
> -	idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> -	pmbm_data = &dom_mbm->mbm_local[idx];
> +	pmbm_data = get_mbm_state(dom_mbm, closid, rmid, evt_id);
> +	if (WARN_ON_ONCE(!pmbm_data))
> +		return;
>  
>  	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
>  	if (!dom_mba) {
> @@ -784,7 +795,9 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>  	 */
>  	head = &rgrp->mon.crdtgrp_list;
>  	list_for_each_entry(entry, head, mon.crdtgrp_list) {
> -		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
> +		cmbm_data = get_mbm_state(dom_mbm, entry->closid, entry->mon.rmid, evt_id);
> +		if (WARN_ON_ONCE(!cmbm_data))
> +			return;
>  		cur_bw += cmbm_data->prev_bw;
>  	}
>  

Reinette
