Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A0027A104
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719927; cv=fail; b=dM6/h1fvSyqEgSprmBHz7Zzic5l2k6xqijCiAnKqs6hqGTAOfUZf9zWd5cN+gu9Pn03FB+d+3StsfleGIvLk/P8/4qK7pbCVqQQmgDZCAcEmEVMgf9d7JovgewtrLB9VmYsfmU+fcrBfJsQql7DYCErJcdhPo9FTlKKL3UCt6Zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719927; c=relaxed/simple;
	bh=acGWamZJmUxw+owWrn//zz7SvsDohKWWlKPHRIG/lrI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EljeLD/Ss0/5lMSS9pJWEU2OqwgVSReFAJ08d3IWv3BL6ASpgFifxBYsoCaAxK0bY4sNK8wIeayw7OI1TxhYKadroLJpBbcR2h4dIxFpZiQAEp1Vbt2NybSWGcUON2xIkNJqrqbLO9o7MwJuZsZR8gsZVKmIZfxezYSXhtP1qZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rof69006; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rof69006"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719926; x=1778255926;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=acGWamZJmUxw+owWrn//zz7SvsDohKWWlKPHRIG/lrI=;
  b=Rof69006KtWpzmnYSKMlQzsuKhLBZ8liaxn2NTbzQOj/VBtK2eC50ybT
   kd0Cn92wE66UN0gWfMsci6/gNftdsZWZHyr9cxVFQc2wD0/w79LS9byh7
   ve3HTsDtEDTXSEHRT1Sk/RxRC6srC/lP3X/ZPXXrU4SJjutI9F3JxQWdA
   hT3/xj3RFGn6jR7xLKK99zL7tfm9UYJg+zi1NpLJk08U1SV0alCPPaNsb
   IRxKW8Slm3TFy+efHX7uJSchpYAzJ7hC7Kru+LmjAt+ONv3d58eUJ6xcw
   C3rrETbR0c/i9FcNYI5q7Ob1HdAUKIS9Sae9xQxdUSIECVx81hDjF5TJt
   w==;
X-CSE-ConnectionGUID: h3pX+wwJSn+9nL1CDT2KVw==
X-CSE-MsgGUID: Ao+xG8BoTXOV9L0qfwEmJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="66049309"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="66049309"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:58:43 -0700
X-CSE-ConnectionGUID: cwCRmyNsS1mxG1IblqR2fw==
X-CSE-MsgGUID: MV3iifqQTryExYudTqiiHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137330267"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:58:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:58:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:58:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:58:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDHtks1+MUBJCLjCjOSw73RqH+ACG0pDWV1AN+hQIF1CE4ir9s+jvzsPty1ydIHopccnWO0Fqu7Aph8ai9uJX0Pe3IDm8FB/zEHN5NgVv91QRxmoyNf1D3pOevRJc58bfP0EmDSILsKkugTuEHeTI30EHVnvvwdEV4CY0eFxpyJNwMdjLMHgSNcxWmm3fa+ntOsXEUDxuTDuDhItLT8tk5lUnNKM1AosRnxWbGSX+cu19KgEbfqiosVL/wi9xxqYgFCCAfXIGpYpNWSuNB+MoaIjnMhQAMQDotGWpzd7b7Z2wgu2pdj35zPgmifXdNus7TRurmhHEj717L4wzOuNdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5iu73fhaeLdt40ENl89lKIzPyLNYIfHq0FH3n6wifQ=;
 b=cwgZuJefQ0eqlZRvcvacxde92NXMu1BcYaErYKXQ31ITwcqALhmJVlBVAeFpudoCgHe+NJOsGiz5jFVRQPxNKL4PY9uzsaT4XkrmxG03o2DRowvFHHVFt1MBYGS3kJX3uI5xnrcBZ4rPVcCuC0K0M9qZQDCjUQ/oXHcdRNMkdh19ESeEdD6q19RiMFwoQ+If0FPSwPGz+2dYxuDAZiUCB2tj0J4PFGCTK+I8AxGRPR/UuO4ZJjlkym3NfigVvjqGDEdsEqvYM3FWGWOwPj5KNXpssVDj77HJDm+AcY0W8tg8xXhyEggKkJOwTCnd4b08DjQdWSdoBuGNaKZhu+Gk4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF0D43D62C4.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::80b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 15:58:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:58:24 +0000
Message-ID: <24db7e9c-55f7-44c0-b32e-342a7dc29ce3@intel.com>
Date: Thu, 8 May 2025 08:58:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 23/31] x86,fs/resctrl: Handle domain creation/deletion
 for RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-24-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF0D43D62C4:EE_
X-MS-Office365-Filtering-Correlation-Id: 015fc4da-c6e7-4a7d-8143-08dd8e492999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cUtJS1BoY21LVDF3c0JLSlJBWllha3JvSnhyQVFKOG9COUE3V0dMWTZEaWtZ?=
 =?utf-8?B?N2xBdGRDSXJTYmEyRmFEVWg2Q09zaU5PMHhsKzU3dEdjWVJQVDBIeXJrMHV3?=
 =?utf-8?B?aGdxdEFJVE1GWTVSQ1duaGpocm9uVEtRMXVrZ2VGZFFlRHNhRk9nQzM1dS9o?=
 =?utf-8?B?d2U1dG5ldGk2c1E5SVh0dk5JbXUwVGRnMTQwMHMzMHNHdTRPRks5UXkxTGx3?=
 =?utf-8?B?YnpSUDlNbEtyem03S1kvZWVOSnFFS3BmWkRTZUxmbVRrZTZNc2NVcVIrQVpp?=
 =?utf-8?B?OWRLUEMwdFhDam1yUGZrOW1tV1VvazhidTYyR1VsZmdaTjcvcWozclhrOUVF?=
 =?utf-8?B?cVRlWUxBdUNLTVdpQThmSkcwZDRwdjh0RDEyR0tObklSSWNjRFIycWRRMGJT?=
 =?utf-8?B?TisydHlNeDNrYTVkUzdVRGtsMG52Q3ljeWlIS1VqUzZ0K2xQWkplUmNvczhD?=
 =?utf-8?B?bkppK1NKdm1mRlR0cTBIdFpuRnkyc1l1a1VNbGkzMVpkbWwzRCtmcythQUo3?=
 =?utf-8?B?dHdNaHZrK2ZacDFGZDZxSDFjajZKaEovMWw3ZWQ1b1h1K3EwR2tKWjJtZWt4?=
 =?utf-8?B?c3FCTHNuNE1TaW1GUkpRdDhoSG1NdGdTZnVHdlp5T1UxY3krYXVURkVMN2gy?=
 =?utf-8?B?RlJCQmRLRXFTRWhrM1J6QTJSbUpQMlZhZ0FWZlNLS3ZKbWtsNDRsTFRaRTRt?=
 =?utf-8?B?c1ZWRHAzWXhkbW5FYzluUUFoMGdYRFUwdXR5R0szendtaVkxMGNHWG1EUkpx?=
 =?utf-8?B?SWpxejFmWEtLRUhKZnplcWNTSWpudEtCUjVEcGhKc1lVdENmOVVPQkIwNTIv?=
 =?utf-8?B?cE9TcGo0SnZyZUpyRG5QeFlwUHhlQThqZ1dlejBsd2toUHhhanNjWHBUckU1?=
 =?utf-8?B?blJhM1gyOUVuK1dydnFLK1V2N0JKUTB2akwvcW00YzAvaGN4QldtN3RTUEJt?=
 =?utf-8?B?anEwOFZObXNxbVozS0s5M3FQSlBISitmbHl3OGkzRVQ2bXpITENUVUxYNXBD?=
 =?utf-8?B?aldIRDR4NldITWE5T0JMTHRaK2FqM2hMSWYzOUtzbVNXMkhEMGJiRG5hWGVV?=
 =?utf-8?B?WThBbmR5NVM5VkZ6V29oUjZRRjFjaFdHSFJPM25adFBldi9JVFBMeDFPd0tG?=
 =?utf-8?B?dmt0VG5IWnU4aHlxMGM0cXFNUzdpdGNib0NCb2FCNXI3b0VlRXhoMWprZmtv?=
 =?utf-8?B?Vy9OQUxrY05RSms1NlV5QjRBV252dUlLbDlOVEVLNTdmc08xYnVabEQ1cU95?=
 =?utf-8?B?L3VYNXlrNXFyL21UdzBuTDMwU0xIZHBZdGFhM29KbkR0enAxV2hyN3Mwa2w4?=
 =?utf-8?B?L0hVam1GeWhYWVBxN0Zlb1FQOHloOFNrd0NVZk9yNkNMbFM2S1YzNVpaZ1Ri?=
 =?utf-8?B?T0RkV0pBSnZ5REdDU1RhdE5IbktkRGJROTVvRkFOQ3ZpYzAxdjFLb3pWb2tQ?=
 =?utf-8?B?c1BFUk5wLzU1RDF0SnZOTjZoUnhyeFJxSEErVElOdERrS0YyY2cvZStvOHdW?=
 =?utf-8?B?TTJCbXorR2xYMXQzSkZ5WEVVaHo0ZEdudi8rWWZYU25EV01jempKTzlEKzVH?=
 =?utf-8?B?SEoxRjBINDFNQ1BLR1JNN1c4SVpTYW5tdmdCeWhvTTNsa3hsU29iWFdqY1ht?=
 =?utf-8?B?MStXeVVaVnR5bWNJZ0RJa0FabFNIYVpDaWI5SGxJZ2JiU2ZSWEl3NFRVTnU5?=
 =?utf-8?B?K2doblRhNHdrckd3cWFVeXE1Vkp1ektVZnd1Zk5VUkk4b092Y01SL1Y4eC90?=
 =?utf-8?B?TDZXenA0aGNpRVU3OUJ4d2c5Um0zR2dmWVAyeVcrNFFLb3ZWd3dIenJJb2xR?=
 =?utf-8?B?UUpsbml3MHMzYmdhZUxabm9BbnZqeG96VWMwUUpvV2pkZmNrRUJoZGR1bUFl?=
 =?utf-8?B?Y1VRdHR6cDkzMW5DYnZXOFFab0FnZDdZQjArTEZYLzZBTHhHZnlrTDFoZ0Vh?=
 =?utf-8?B?WElsZFAxaHpuTmtmazNRcHN6TXFNSG8vTTI2MHF4K2dKRmo2dXpoZzZkMmtQ?=
 =?utf-8?B?QXQ3MU1MbERRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eC9nRWhVL1dhL2VIS2laclFmZXlZdk1RRlQ1NGNvRGNENzVzKzFJdTByREkr?=
 =?utf-8?B?bFBrOU12ajNFeVBHRmFVRWpjOHpicUNVRTVHaUhIamtUR3ZOSDQ1U2hCYWlw?=
 =?utf-8?B?N3BrK3NKSWcwa3VzTnYyUjhwWldSTEFCa2l2bTBsejJsUXI3MFdrK2JIM0Vr?=
 =?utf-8?B?ZVA1Zzk5WVp0cDFRa0Yzd0xVWnU3WENCRnhkMVI3dzdqbHRibGM4QWwyRlJL?=
 =?utf-8?B?OGNOaXYyVTA3c0wwdllZUEpWRmkrbTRQT2xTcUwvZUEvcjBOd01SUGkxY1Qz?=
 =?utf-8?B?ajFXSG00NzhmN1c4OEFkNy9TTWx6bHhyalppYWRuY1ZSUDYyQ1Z0dDNTNFFJ?=
 =?utf-8?B?ZDJ0VTRKZnJ4WjMwdjZaTERqMmZNN09DcXlGSHFlbGdiZmtiZStkc2syVE5p?=
 =?utf-8?B?SERMdzc4M2FRMm9lMVVpVVl6bGo0bW1NRHNwSlE0TCtpTittZjdwVXVma01Q?=
 =?utf-8?B?ekFibzJoU0JRVkNwSWQ3Z3pFU2FtMWxWdmt4UzFHQXBXaUZ4NzJYYlMwN0gv?=
 =?utf-8?B?ODJhYitOUi9yNXdackJ6UFFxL0R6c2poY21lLzFLbTRjRG0yb1pHVklqbkE5?=
 =?utf-8?B?VWxSNlJtbXlVYlE4UDdLMWFCc1NwNW10RVpjcUVzSGd4M3lyVTIraVJPOXcw?=
 =?utf-8?B?RVVWMWNRMVM4MFM0eHNRZlVlbnZCZGRQUHdXaCtoeWdhak4vL1lnV2Q4cUhO?=
 =?utf-8?B?Tllqa2RkTmg2S3huS3lhdWJtL3ZPTUZBUUk2L01yeE5wODlDNkFsamJqbHhF?=
 =?utf-8?B?T1hUVG5MUFk3NkwvZ0xnTmhYeURwdHdiUjU2b3oveVlBK1NjNjlSNGoremMy?=
 =?utf-8?B?Vy9NNUM2VzFxNi93YVJCSEhRaW9GSEtOZE1kTWU4eHVhWXpna1JSa2trOGJx?=
 =?utf-8?B?dVNWWHlqWk92ZkpIM0JBbWQ3VTFCbjdDeCtFOVREQk1GY0VNUnB4NmQ0Tm0x?=
 =?utf-8?B?Rkw0YWVJc0s1Rlg3eG9mVHc1SlhRT3grdlZqNERWc1djY1M5ZUNCZ3dnOGZ0?=
 =?utf-8?B?YkhERnJJYk5md3RwUStISTZXK2RacHpHTHd0YlBLUXlkRWc5N24rOGhuZGJs?=
 =?utf-8?B?dTF1NU9PMmpJeC9hWC90N3MyS0cxTWVWcnlMNnpodWRXZG13OFYxb0l2aFhi?=
 =?utf-8?B?dmNOMDdUdTN5YVdrUmdvQnIwck1McmdUdmUvSzhkVUs4NVgzRVFmN2ZYMU1K?=
 =?utf-8?B?VG80dFRWVWQrUmJsUEpXcUowMVRYTG8yc2d3TTE2STd5amdyQU53TnRNbzM1?=
 =?utf-8?B?bVdWNUJGL1FQZy9HOHF6dWF5NTQ5RHJuVDJkYzZxQ2JPeWJkYUUwN1llOUZi?=
 =?utf-8?B?d1RhMjZKVGlCMjU3WVRRUnZXc28ra1VzM0w1ZEZLYkRXZkRxV0kwL0tzZHFl?=
 =?utf-8?B?R3FaRmF1MThUVktIVGJBT2tsd2FLcndLV0F3dnJqcHlIa1ljb0NEN0pxUXp6?=
 =?utf-8?B?QVJHLytyVnJyK2xYZXlzaTJXVytTQjV4dXFYMFB4b2lvMHV1UFR1dERHUFNR?=
 =?utf-8?B?N1U4c091YU9BRGMzbTFuUXpKNFJtSFpjSlFmWHc2VjNtZ2ZGbFZDcGdKMWNS?=
 =?utf-8?B?WnFnZEI5SlpCTk4vbWF2dVJnT1BNZTdUQ1ZIK1gwMFFuMjlFcVNoaU92ODdK?=
 =?utf-8?B?eHlDQWNWZnlmdER1eEVEdEFPdzNDWXdEM0hZOVA2c0tvTlFOTXRvcHBPZTdt?=
 =?utf-8?B?ZENCRGFtUTVNK203WFExQUJ1VGw5RXdYVU5VWFNHaUVPVDJNaUFNWXd0K1k3?=
 =?utf-8?B?TFdNVnpsNkVkT2gwYk4vV2E0NVYvaCsvL05IWWR4SSt0aUkyZVNBTklodmZE?=
 =?utf-8?B?YlhXcHIwejhqMVNxU2ZqZUxLLys5alNUMzFOT1pKY214dHVsWG9uSC9VY2xi?=
 =?utf-8?B?V3Z6aFY4WU5UMlJyRWVTSzQ1dUxCTC8wMjZOR1ZUNnl2SkFWVnVoWFgrQitH?=
 =?utf-8?B?R1FxRGF6RzM1dnRocDZTbHNRMWZtUnQwZEFGNnVCZUowNlcrMHB3TWQvdFJu?=
 =?utf-8?B?RmYzZHpOL204N0RIVEZIVW0yVnZqdFhYN0xDbHB5cUY1cTVLb0RvV2ozaFdG?=
 =?utf-8?B?WVBJVHF4RWlrUjNZU1hnSUtwcTlCb1ZoRFVQdkwydXc5WFlWZVp0TVFVS2F0?=
 =?utf-8?B?MC9aQmxpQkd4ejRtci9kU2t2bEpNU3IxUVpWa0NMakxNZ2ExeG9GS2NrQ2Rm?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 015fc4da-c6e7-4a7d-8143-08dd8e492999
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:58:23.9572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3JuDMAKnJ2fg73Kx/QN/iGYiG1vz1As4aR0XvAStKGMnSeBKpBz0qj89WUqrf90PlahJapJrX1iH5TU8Ug0oWlCvbW5lV69BqvOgjVadfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0D43D62C4
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> The L3 resource has several requirements for domains. There are structures
> that hold the 64-bit values of counters, and elements to keep track of
> the overflow and limbo threads.
> 
> None of these are needed for the PERF_PKG resource. The hardware counters
> are wide enough that they do not wrap around for decades.
> 
> Define a new rdt_perf_pkg_mon_domain structure which just consists of
> the standard rdt_domain_hdr to keep track of domain id and CPU mask.
> 
> Change domain_add_cpu_mon(), domain_remove_cpu_mon(),
> resctrl_offline_mon_domain(), and resctrl_online_mon_domain() to check
> resource type and perform only the operations needed for domsins in the

domsins -> domains

> PERF_PKG resource.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 41 ++++++++++++++++++++++++++++++
>  fs/resctrl/rdtgroup.c              |  4 +++
>  2 files changed, 45 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 0103f577e4ca..97fb2001c8d8 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -543,6 +543,38 @@ static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct
>  	}
>  }
>  
> +/**
> + * struct rdt_perf_pkg_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource

This should not be architecture specific. My first reaction was that this belongs in fs code
but I remember that the advice is that things should only move there when needed to be
shared among architectures. This may thus be ok like this for now.

Reinette
