Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4409B230BE9
	for <patches@lists.linux.dev>; Tue, 19 May 2026 04:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779163419; cv=fail; b=LS2QNb3ymuYzCz4Vrj8OEDO0LKwneAkuv3s+4KxPhI7Jmb46SiEjXbzU2ymKiiT6UVhpmvXtwZQGNQqf9X9ibYA773EAZnJjKcIk+dtawlqNjE/hb5Ecq9Jn4MI04XRryDVmmEyCl9Z7bQHYoTBegLFrEtm2YWCm6DGXllaWSBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779163419; c=relaxed/simple;
	bh=yu2+FwbiHOiJUVDD7m4xn9eTQt59p96GI1G89CDKzkY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dRiW9e6+psYeipNxS7JWJbvvoSW5Jg8+wQQ0OChUjxEeJ4znbCgP+yooQv7rs4r+KVf5CDIHaH6x4buRZxwEjA/w2vM/bpeW+u0zkTgvk+5Q6s5sX+AItjKpNtmRcUeTQArk6s2LPDR51wsf/8O/exxwCd3QKq9mvSaB8VH4PyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e7abcM2O; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e7abcM2O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779163417; x=1810699417;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yu2+FwbiHOiJUVDD7m4xn9eTQt59p96GI1G89CDKzkY=;
  b=e7abcM2Ov7cZKFlJKhHuChrKW9dqPFM40TLAFxd4y3Y2c1jugC43/1kF
   ddQ4Os1fiNtOuL+RjN8x9kRavZBwrbArXWVm/3trRbhBRQkA240ngi9EV
   /uwejcEofhIwVGxAo3vFwwmet+FAfjEsSIehSgIZrMmnBTKEkYEECg4G/
   xWPI+m1cmXQcTWGVSUUDClw67ao0lYBCadclJY7ISp6yyyvIXSIXxklHB
   +EYVPJeOsjdztCiqKTUTo32Ehfa7uE9UDPdox5q82K5drz+7I8TKUoQkO
   m9/YcnvTHOupdoz03Qiq0qhXC2lZ+Asyo8VqTx4/8vCE19nUrwnIIch4F
   Q==;
X-CSE-ConnectionGUID: lJA3j1iqSWqNkWKRXhxIsw==
X-CSE-MsgGUID: jlmzb5bEQNiPDZD15EYgcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="105490929"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="105490929"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 21:03:36 -0700
X-CSE-ConnectionGUID: C/jKAO3ORgiKHyNXG53e6A==
X-CSE-MsgGUID: qsczVKf4Qyqv+Piv7UghvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="235189763"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 21:03:37 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 18 May 2026 21:03:36 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 18 May 2026 21:03:36 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.45) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 18 May 2026 21:03:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lrydgpfucGv1xbpBTQTbHsCX0ZR2q/m3HtPixyQdnG0cvLWGk5tiKmfITQLVIrUjNQj5Amc8GYa79keos6smgaP8GS02g9K9d91c78CpGtEa2V1ygqs1Sk887iMsLUb1rNZ0Z3ipe4jxQQwlrsn0JbJzdM0ehpAZQlkF7IRYkaKd5orUKtHP8YOyDabOfLTARg5XfMSrHSW13L6u5WX+WagdRCghm05lqLs1L/7A3Om3MA0dIKsYXABOGwvBJHbbmPSlSSq9zo8/gRYE5fHL6ClbUuJHKEyhL8ptfQZboKnCueAt8RwpGTIRFbuqjRJiJcpktrf7cHyovVIbreuNGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEQ3MdABMGdm0bQgHjqo7mooxPhFvloKQGamL/vAed0=;
 b=IjbiGVxUYPSmhkP9+c/EsiWPvYNjYFI9IIKKLn8H5YdY13c7RwiA4VHysFR2/N9LAvmQ4uyZU5Lec9u/pcC3MCl5VW5fbi5UQCOjOw46+4jXZbkLL3gHC7pNZvTlIP75pfvkJpP/a2YdGavj6crKjv/gOqTI1Q/wpkDBsH9ZTqgua2qPCdNd7/Wwh6WieyQQdfNoRZJfB0Ehhq+Xzb2VYbP5ypcwq8D88MbW83QJyhzDTn26YwUmyFPSIrid+ffgCOJNFp943G2vWQ/9hbdBo0ueTcMa0Lx4d8nB55XiHSjcpVbuT/L/HGoQ2W2eFaia5+OBQvS+BhIg2xiWYtrO3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MW4PR11MB6618.namprd11.prod.outlook.com (2603:10b6:303:1ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Tue, 19 May
 2026 04:03:13 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0025.022; Tue, 19 May 2026
 04:03:13 +0000
Message-ID: <389e1f79-adb6-4c50-bb14-b22a3706a98b@intel.com>
Date: Mon, 18 May 2026 21:03:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] fs/resctrl: Fix deadlock for errors during mount
To: Babu Moger <babu.moger@amd.com>, Tony Luck <tony.luck@intel.com>, "Fenghua
 Yu" <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260515193944.15114-1-tony.luck@intel.com>
 <20260515193944.15114-5-tony.luck@intel.com>
 <75aa4c10-8e5a-4a9b-b702-100d761fa13a@amd.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <75aa4c10-8e5a-4a9b-b702-100d761fa13a@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0128.namprd04.prod.outlook.com
 (2603:10b6:303:84::13) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MW4PR11MB6618:EE_
X-MS-Office365-Filtering-Correlation-Id: eb3ce432-2ac8-4337-c45f-08deb55b8c4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info: haBlsWFzt5EBndv6rJlK7/Vcj7ySbWKVc0HRBlCtdWRfZyMMiOvL3Up8AoLUsEDyu4Z5SokLBUwvFE7OK1R8QI5MURroIy5VLrMxtpIVOkcGGMtOnSpcexfhZAhFx+SspGLIDAzRzu3RAVZhoYr8z2WJfbqBVbSKOIzfp3wwuMk6as7rkINO/l/9+vvrGcQS+D+JkRx+L+7r84q1EzEqbJE1Xby21G8+XTlLvdJo+qL0QUK0SU29vvd3vw8KWxeuwycXNlgk9j4h9cjsQaDpeBrnWnVT47GvOAiiGnovEA7p2VXzKLXFzYoIVN5i6gvgIZCDBRhUyApqKECW1RgDkH5525jC7Oi71rK8u5GpqZSw2LrqfD/7heapzzoCacc4abxM1EEUzaL1uX7e8DEMSYPd2lY6PDeZfWNjNWFkMTu/ZoE/jmkS6zdoho3mHywrDYpKFGLUpjhkoGHiPqEMya9MwMmPR1MknTJyL7GhUfDVADzyc058zhHAaTICQKBL+derPJohKkW92WdcZdxRoqkMzLALWQNnZ9qvbcCEdFTP1Wbhtu0jLPc1i/NA8+t7rfkTeKXIGIz+VGiRfflQNZNlCn3lPHpqcDvDqx8+0wh9ZqEdFNl5Yq39esDGIoh1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU9PamhSTGFia2wzNmFVVGFGZ2RST0hZNTVZa0ExbkNBVkpTdit1a2dRMktE?=
 =?utf-8?B?RWUrdnFCZ2c4QzFMZkFpaWtPQytNN1NFVVZKKzFGRExHaDFzZmh6WmoybnYz?=
 =?utf-8?B?VmQxRkJxZGhhRVdBb1NZbHpyWnYxeGNQZnNHS2p4OUZTdmc2aGErdjc5REY3?=
 =?utf-8?B?RzNvSmhlay9VaUpUNlRJRSttc2V0QkpLcXRhZXpXM3dFS2gxSjNZWmRUc1dG?=
 =?utf-8?B?M1BWclNSZ3BMR0ZRaGJvOWM1bDBqNWNqNDhpbEl1ZWNKR3V1a1NQYzhya0NU?=
 =?utf-8?B?OEcxSHJVbXgzOGJ0RmpsaklrVFplbld5elFUcVMzeVJ4MGxpZVl0cHMzRWIy?=
 =?utf-8?B?b1hBcEFNMzRtNTRpSWlRaHhFaWpMUU9KS0NWL3AyZVZZSlhKLzhyRTZUTElR?=
 =?utf-8?B?dUxnZXFUdHNIY3JObjRFVGpnNEpHMzNxaTFqZlBWeVNPVjhRR0xWenMybk1a?=
 =?utf-8?B?S1Y1RFV5VVl4aFhWeGY3Lzh0K3E1NjE2dHR2WWZ2VHRXL3NkSjNFRGhwaVpt?=
 =?utf-8?B?Y3FjY0l2c0tFQW5HOFF1MGRCTVF5NXlXY1Z3Ujg4L1h5eVJLMVdNeG5LOHFu?=
 =?utf-8?B?REI5d3lLaE1qZVFCL1hMTm1FaE5XaXlzNDNVZk02S3Nuc2MwWnMzV0VyVW9J?=
 =?utf-8?B?MVR6SzBOSEVvQ05TTjBYTUR6ZjRRb1JvMkVrTkhNV2hqVjYzVzdVNHJRWHlx?=
 =?utf-8?B?OHJzOUFIK2FSU1g2VjRxR0x1enR5aldTWERLQ2pST0hwVHdYU1lob0o4ekxy?=
 =?utf-8?B?REszREpYcFF0N080cFY1TURxdzFTaWlqcW5jTDgrRVZPa1ZHUDNCcFFtYjlw?=
 =?utf-8?B?enRuTFZTb3o0UnNKTTBsWjFxYUVaazJZSU1rUUtQM2hEam9hdXhUTDJQelAy?=
 =?utf-8?B?SWJHTVpMaktTNXg3L1YrUnQ0Vkg0K0Z5MXN1MnRZNi9XV3YranZsVzh0eU13?=
 =?utf-8?B?U1ZhZ1BxQUFuOXlja0NEa2lxUUVuVGVUK1FaN280Y2xwekJFczV0YVloMGE3?=
 =?utf-8?B?ei9GVjIzRkkxaDIvZEFobjdNU1NFUWdSYXEycmZXSGZEcmtKWmFvL0REdjd3?=
 =?utf-8?B?eHRQem4vRVc3VGRSR3NqakwyLzZNQVQrbXJLMGZsTU1EK3R2cDBPNTB6cERF?=
 =?utf-8?B?b1J6Tk1yL1BUOG54aUxtWlo3TU5UMm8yVGpwTzRwWVZ3UndHdEJ1VEUwcmRp?=
 =?utf-8?B?UURQWTBmd2MxNCtPNUwyNzZqK2FlaWVzaUFheUFETUlRTTJoYmdyaWp6L0Rq?=
 =?utf-8?B?OGJUeEMrVG40N00zQmxEUXBHYVB0RkJKcU5paDd3ZzJhQlR4eWVoYy9yYmhh?=
 =?utf-8?B?bllIZTJwT21LMlhDRnM5K2xuTEtCM2RHZmYrT3VUUG5vMk1vR2pDTG00SGxV?=
 =?utf-8?B?TGdqb2tXd1l6aXN2eHVBQ1FnK1JpRHBBZkkzMzlwc3FUc2RTS2FLeVJsSjFq?=
 =?utf-8?B?MlUzeWJLYThvbHdMMlNrYzgwdGRsTnYxdEpuL1R4cGkzcVVaUFEramVnMlF2?=
 =?utf-8?B?VnVKMUFSdXJPUVBzZmlwVE5YU2JCZC9wdit2OTFrTXFPVjlCK2ZkclRod1FX?=
 =?utf-8?B?aEJ5ZHhrbVlQc2d6bWU1ZGJoVGZEUnhqQnhPOGFSTkl1UnhnQUltTnZSODlS?=
 =?utf-8?B?ZHgwbWlNdCtMVHdhazVHVEtsMlNqZ1ZpakV6cjF2cWE2aWxpdmRaRkw2MEhO?=
 =?utf-8?B?NlV0TEU4RC92UkJrdjZEWTlBWDF2b0kwcmU4Qm5sNVI1MHI1WElyYVNidFNN?=
 =?utf-8?B?MGFKckNRVlRocFZWMzZjb1ZKM2NGZCt1MkhPa0dQakpTY0pDcWdNeTFlbE9S?=
 =?utf-8?B?amlnMm52ZGdoQmwxK2NEOU9PN3M5MXBJSlZCUE11djRYb2c4R0J3OWNnVXZG?=
 =?utf-8?B?aTM5MTNTaEhuLzdrQWYvNjNpSGhydUh1SEhLMGVxZ25uV3JUY1o3YnMwVnhG?=
 =?utf-8?B?ZTBtYjQ4ejA0TThNMnl0R1hBTFJpVW5WN2RQcWtGV0ljVEd4VVRrSWIzVVBl?=
 =?utf-8?B?bTZpaVdRNzl0cWQvWVRnQmZGRm43R2Z2Z2lydGhReERvbHQwM0R3QU51L1A1?=
 =?utf-8?B?T2VIL2NXL1g2dHlacS9adTNveThEL0NwRU4zUHhaUEdkTGEzeFBnbkNSOVRr?=
 =?utf-8?B?NEF2NExRdFVLbHcxZ3lRSXA3K2szaVNRSnNSR05XQ0NQU0YxRkI2OHI3eVVu?=
 =?utf-8?B?OGROM2w4dm1aZnhlTDh1OVpvUE1aeUNCZmMwbExPSGZTWUZmR2RnQXpKMDFO?=
 =?utf-8?B?TklwK1NZajkyNExJYklZY0FkOVdCRVNLWEcvZ2UveHpJU1FUSjE4eStvTEJw?=
 =?utf-8?B?eHg1d2s4cjdLTjFzemxINzcvQnlLZ0ZhT0pTTEoyMGd0eTlvWXJnUW9FSWha?=
 =?utf-8?Q?K+UuaRz0Xy9/n3Gg=3D?=
X-Exchange-RoutingPolicyChecked: fsvwZAF+KnM23t89Fo40G9ZMko1jqVEKpfuln/eMK27aMxYSjPTSKs/iB7QbxkZVQ4lwNwtS3Nuh02zh9kGU3lH+TlHrtCvjWtpWVW3IUevUFfmVVEzKsHEQQsBQhgevLG19HeiUpPQD/F0ZEmWL2Jc878PMNzkSSC+gPSXw1xQzJ/CLFZdLKng23ED2pfUMzBDrp5SNEvrYE20GqITUiAQYRCxYojnU3D532PNCxtT2zSnLSVMZOHeJrhgvzUtW2eNcXHekHS2GTxIUQzXdklPbM3VN3tlXyeKx36BePvf5ieGJUIrVPUZU55GqphhXlXbh4oWYBbteEm9Crm1i5g==
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3ce432-2ac8-4337-c45f-08deb55b8c4c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 04:03:13.6643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edKbYkP8i02FwAJEZvQVeqIcJKqOE142G+0672WpCW5EY6uMtl1A0CXrHkYf+GXhLaDxeH5/hjLerxoqBKI/k6/r1fe1vTjbkXy3LS8MTn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6618
X-OriginatorOrg: intel.com



On 5/18/26 1:54 PM, Babu Moger wrote:
> Hi Tony,
> 
> 
> On 5/15/26 14:39, Tony Luck wrote:
>> From: Reinette Chatre <reinette.chatre@intel.com>
>>
>> Sashiko noticed[1] a deadlock in the resctrl mount code.
>>
>> rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
>> superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
>> the same thread before the call returns.  rdt_kill_sb() unconditionally
>> attempts to acquire rdtgroup_mutex and deadlock occurs.
>>
>> Move the call to kernfs_get_tree() outside of locks.
>>
>> Add resctrl_unmount() helper to keep code consistent between the
>> rdt_get_tree() failure path and a normal unmount.
>>
>> If kernfs_get_tree() fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb()
>> has already been called and no further cleanup is needed.
>>
>> Add an extra hold in this error path on rdtgroup_default.kn to defend against
>> other races destroying the root which is then dereferenced in kernfs_kill_sb()
>>
>> Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
>> Co-developed-by: Tony Luck <tony.luck@intel.com>
>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> This should be
> 
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by:   Tony Luck <tony.luck@intel.com>
> Signed-off-by:   Reinette Chatre <reinette.chatre@intel.com>

I have not yet given my Signed-off-by to these patches. I am still wrangling with
sashiko's most recent concerns with the areas touched by this submission
https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com

Reinette

