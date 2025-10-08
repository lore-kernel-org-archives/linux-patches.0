Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB192C0292
	for <patches@lists.linux.dev>; Wed,  8 Oct 2025 22:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759961554; cv=fail; b=bG42Fw1sOnmJMrV1tVxjc/Vv8adXA3u8x2SKD06FoLUFzvT3un4CD20jH+Ys55uVuZMmPZULZdnMkR2L4tF3nIf4OJMMlQv3+5n+mYCbaZv7iMsICszDoh/vOx+4kpjanyWrfKJdUdfkGokffDN3gJ/RY5p4vJWI5N3ZkVJAU2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759961554; c=relaxed/simple;
	bh=O8210vA26kyHaRrGxhask2CPK73gvf6n6k7CHKJ/wHU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rik97XTysMEVyPEaiIk/0oe55whLq7+aA7Xyn+a9g8fk/Ulz9OlHYL/PNG4trUUTXhVLR3ZzAdXNC+BJxIKioMfI6OMA2tk7Smd4W9a+Hh4+nvgrrvEk7xbSBlDK76NeRCMzuh2r80vUpdpP5veMvEZNP7R+aSvJ1aJ7Ah8RBJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kRCqMbfF; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kRCqMbfF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759961552; x=1791497552;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O8210vA26kyHaRrGxhask2CPK73gvf6n6k7CHKJ/wHU=;
  b=kRCqMbfFovSzbcoX4R5P2zAz4jBVt0agJ3xr4EVW1IS2I8p4mE1rJXu/
   RstYQpISaA6iUeDEvjfw0Qyi/3WN4MsgeZpwqyTYaTLSQKiw09YatjkvU
   b2Rb3J5OJKmMJl7lKdogA4UDDdY99qdvivdDBvb3dDm0fczwF/frhvKHQ
   nVNkg0SzQA7dpZZgAthiC3DEfSTshbXEffstE9sySsHhjEiiK/SKxQyo4
   l49aqmmUUNlyWwLem4EH+U8N1tE+2nGT3xtoyMb947F8ThZUA8ZV5jOR/
   a8TrZrAc7KC2z6d9ZI87f0DFtHhD4HEA+uLTdE7egr9IUMGl+0MMchj1E
   A==;
X-CSE-ConnectionGUID: iXqD9L2OS8yr2xb3LjO2XA==
X-CSE-MsgGUID: NAzzL0K8QMKCu053//AS6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="62211768"
X-IronPort-AV: E=Sophos;i="6.19,214,1754982000"; 
   d="scan'208";a="62211768"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:12:31 -0700
X-CSE-ConnectionGUID: 0nF9ls1gTeamqRMZdZfqjw==
X-CSE-MsgGUID: AB0//PmwTNWmd6XEIE8/SQ==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:12:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 15:12:30 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 8 Oct 2025 15:12:30 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.12) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 15:12:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FGaUhkdihsnM+ikVszjQ4RvV/tDi6qqtSVtKiLMmnJVFGRojEE05IIAFhdGomS+FzvPGjx0AgEZkQ6jdun0R74k3FwNuLaLd4AcxDFDxUD8h64YYKuixtfcOEYwqJi1jyfVTIhlScsX3BBIV0eKEXAiIXKwiYAUF3scD8ULpIl5km9QUV9JLqkNwtZ1pW+hWUvVv9ZwOIGXyWHd7cwVzrOpFwKxcKuCKjEFe4ByphKLeGFKoIWBPyn4a7UtI9yqV9mS3eGpPiQ9Bz41I/LYVNoaxjOPDDSRFBUcDhG+4OQ9+wRxkOaEzKkiox/LcQupOhhFncdf2N29w5kSRQAyCyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0OCxElkMQp9CHvfpQdxkU4UO6vI00ng7k3ML59f4LXo=;
 b=YcFYJuybmDzxo6iQGNMUXgqxbIAPkVC25+rH6OpSlfPzCV5UuU0gTaeHU76Vfjuf7ayUhD7iTUavOjL/AorChCtpwDQxbsXot3/kp9RfD1VRk9IhF9iDkhbfJxKBFlpYOD0saPI51CSQ80l93BWelWK2kPcx2BkEE5NDEP0SrdjcTAepmh+5xKS8/71XPsEm5qaXWIjbTLr1GdY1pPSjDZyG5VGb8Mc7pHC9et4hs36YwLMZSaT+Cou8gurrmzUvHSUBgGOI5Dv1qD6bLhD7j3voF+3Qm4ApT/kgTEgVol4llxKLk/YJF8XRlbfTHxAldQCVmjh3ZTPbqynLDrQVcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPFEC87B8781.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::85c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 8 Oct
 2025 22:12:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 22:12:28 +0000
Message-ID: <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
Date: Wed, 8 Oct 2025 15:12:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
 <aORMZ6NUXMpECHU6@agluck-desk3>
 <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
 <aObUZU8rnWIDR_tH@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aObUZU8rnWIDR_tH@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPFEC87B8781:EE_
X-MS-Office365-Filtering-Correlation-Id: f3f6abe6-2a0c-4014-93ed-08de06b7c471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WGNlaXRxbXBhSDNLbFNMRnBkRmUvclM1WEdORUZ1UDNUb01LOStjOGRKYnJx?=
 =?utf-8?B?VG1FbC9FRkNLNGpmL2dsZmx3RTg3RFVHMktOeTFLWEFqOFRrVXFVbitZRmRq?=
 =?utf-8?B?bUJta0tocG9jYnBtTWphbm1GQmhIaGF5UjNRSEpEYjdrR25QcnFSbGc3MGVI?=
 =?utf-8?B?WHE5S1BvSnRiL1dKdStJdW1pUWNqRUVCVVNCU3liaHQ4SFVqcmN3bU5YTEM4?=
 =?utf-8?B?RnJmSS9RaVZFOWE3Y2wzUEpTaERRSFBBdWJsYWFQQWNTR1JCb01CZFNUUHJo?=
 =?utf-8?B?U2QxeHpnamVTbm5sbGJsOWt6Q3pZQXNlTjY0VlZsYit1VjNKWTNjY3duNm5C?=
 =?utf-8?B?KzBSSVE2U0c1M01rRzNLVlEwNW5rSkI1S0RuSWRxeXVnTm1scFVaTGpkSlBp?=
 =?utf-8?B?SzJwM3JUNlNOSTltaHFwYUFxYWs0UDZFalVXb1JmbzNqRTFUSEkzNjBab04x?=
 =?utf-8?B?RHlOQUV4UnpFcWorWTZuaXB4eEhUS1Y5dWxLMEFNeHFWaXBVTHZRWUprMzFD?=
 =?utf-8?B?eTNJR1ZCQ3ROWmRmc2lYN0ExdHpMMjVseG9oazNpVkV0NU53M0NEQzJNaWtL?=
 =?utf-8?B?ejVuT2I5S3RBTEFkMXVURERHVzdkTTN6KzdvN2dPRWZrbk5IeHVzRktrb0t1?=
 =?utf-8?B?MmFFcS9xdkQ0UUt5SHVQd0lDN0c2TGl6SXZKRjVsVWkyT2FFRHNFR3Z4OGZm?=
 =?utf-8?B?UThuNWVzTE5iV3JPV05NV1VLRVZNajkrejlZaXRWNVRjMUlWRmwzVlhFQzla?=
 =?utf-8?B?VmNvTXUwMEk3TnZpV250SEhmMlhQclJ0QUFDbTRRUU5nc2FEZU1vZHc3emJt?=
 =?utf-8?B?UnpGbmZ3VExoRi81R3oyOUIrcGZ2OWNaQlJKdklDMFQ1RTB0MGhVNjlWMXc5?=
 =?utf-8?B?UzRudU5ST1hkTmNyYkdCclN5TEFWTUtsSXpMcTkrMU1YNzVqV0dKeE02NTZS?=
 =?utf-8?B?ckVpYmY2QU1uMWFuVEgvU0ExZWhHQ0RzTytwSXFTOGZ2aDlRUXVmc0VUWVRm?=
 =?utf-8?B?NWdpWWh0YUh0YkFWWGd1NkExdEpiOGtWc0g3a3p5TjZ1YVdqakIzcGlja2p3?=
 =?utf-8?B?NEFucWdBWCtMUnJDVkFhR095aFN2VDNBSUFKWTZ4OWdaSnEvWkQ2ZXNpUHZm?=
 =?utf-8?B?WVQ4TkNoS0pWOE80QXBQeTZEajU0dEJ3VXBPUDloSmhkMWd5d3BheU1BSVZW?=
 =?utf-8?B?UDRXajNhUVF2ZjFsbEQ1U0h6NERnTnlzM1ZkUEk2NmxEVHJDdzBIZkUybXVF?=
 =?utf-8?B?ZE8wVE1DOVBWLzQyaSt4bDRFUnVKNXdNL3BKYm5tR3FKc0pQK3lNVVlROFRn?=
 =?utf-8?B?ejluc3JycVNuRXg5azdHWG1hZktYaThPSEZHTjArTmI5UWRXNUoxUlRIbElQ?=
 =?utf-8?B?eko4MWtDRHZ5NkZZR0k0VGlpZDlPR3FGSG0xektxUUo0V28zdC9LWUJNeFZl?=
 =?utf-8?B?dFg2UTZWM1lOd1RuRUQ2dkkya01sWHZzMU5kQlBVY0Zqditua0IzdXJmbUJF?=
 =?utf-8?B?QTM5RHFtN09vQXFlTHF1Qm4zNHkrb21La2FrZUhBRkg5OERhSHFRNXAyYXlS?=
 =?utf-8?B?QlJEUklYenhRbWlBLzd5U292QThYWk1jYmJVMlhlbEdvdXVGQUd3eVFZVzFS?=
 =?utf-8?B?VTNZb0RCOFVtWThBNlZpdzhDU2JZYzNRc2h2NDdBaTRDMGExdTVmTy93UWpk?=
 =?utf-8?B?TGM1cXk3YzVOZjI3RHVDaHJPdU94Q204NnAwRWRqT0t6R2R2U2Fnc2g2SzVs?=
 =?utf-8?B?Vktlanc4Vi8zY0QwWEtuWG5SeS8wd3d6YVRMQ1NPRUhyUjNrMWJpVXNPNVZX?=
 =?utf-8?B?WFloODJESjl3bDczcjJ5ZlE5WUxIcjhZN3hRcjZYbStkQ0RDS0Y3VlRnU0lh?=
 =?utf-8?B?SVhKZGNCeHdqaXdkOHdybE03UGJmZXluUXpYTU05b0toem1Qa1lkOW1zdjFo?=
 =?utf-8?Q?N0mKUwRXYnIJAn6cbBE5EneLpc9KlU/5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUlWMG5VSUlPYXpJb283anhSelhTQ09rQmVsb211SGFpSG9ra0VGRUorNllt?=
 =?utf-8?B?QWFuL0F6S0NLT3FJODd5aWh5cjVSbytiTzM4Rlk1Y2Y1S1BKUlgrUERlWWxU?=
 =?utf-8?B?Y2JXNmFuNlg4QzdIMS8wVWRkdEZpaWhCdzNVVkk0bThndkZtb29NeERGVms0?=
 =?utf-8?B?clV0ckx5Uk5uZ0Q3Rk1LUGgzci9yTExpWHJPQ0NOYXlqVUtUVklQTnhCcEZv?=
 =?utf-8?B?VW5kMk9LeGxoNW14aDdrT1NDdWFXT0ZYays5aEZyUEtRY0JQTXZmc3RrVXJX?=
 =?utf-8?B?eGNpVEMzREI2STI4MURYTGJUb3dUblF0S0JNWHdRelc1NWZjazl0NmF0Z0RE?=
 =?utf-8?B?Ujh5enVXbVJTbmxBN3ZwMExGaHV5QjRFVXRKeDVoaGJYVktubkJMdjc5WDhy?=
 =?utf-8?B?ajFBRVpKR0tPY25lVEhrUFk4RFh5TFpIWGZzUVJ2WEllSmptM3NIKytySmwv?=
 =?utf-8?B?T0dESlh5NHc0V1hYMmVtWkUvaXNaTVlwSXdmVXROeW5VbXBjS09Qenkrd3Vz?=
 =?utf-8?B?Nkg4b2FYTEx5anNuWFFCVGI3eFlKR2d0TmYyd01HQ1kyajJlOE1PMUNHMmFn?=
 =?utf-8?B?NUZPTXhXQ21LcmNMdDFGOEJ0RkNaaTROUUc3U1g5UGNXTUw1bFNtaFBLZytk?=
 =?utf-8?B?ay8wRldBYXd0eE1XSU53bkRMTnpESGYzUG1ER2RudUxvc0Q5R0RJU3AzQ0dG?=
 =?utf-8?B?MXczRGJoN1V5S2VSSmoycEE3dHpmWjBBazE1dE9kcDY5SWwxYXg5eHc5TXVI?=
 =?utf-8?B?UTJjSlNrR21xZWhtUXp0TmtWbElBdWNEdXZaSnNsWFJvRS9ud3J3bERVdXVF?=
 =?utf-8?B?ZVdrWjEzbUxYYTM2VVhDc3pYbmlUWGhVNTlQQXpLUDZhdjE5c0tiem96eEJG?=
 =?utf-8?B?bHN3RzNNbEh3b1EzWmhmS3dvQUozZ09oK3RUVlZjWUhKUVZwRFNBQ25mQmRG?=
 =?utf-8?B?ZFRMRkdFQUk0MGY1Y0JzekpmbUJFcWtrVHZKeHZJQkxLN2lSNWRUb0pwd1Fl?=
 =?utf-8?B?NHQ5SFlZMUxpNWQ3YStoNVQyNk5HZ3ovdGhUWTNNZHU1NGVDR1p5d2FLTmNF?=
 =?utf-8?B?d1dxRUR1YXBudlNEeE1OMUh0QW5VOVJpQmhnUzBxbkV5MVVmd1hXVVpqT0hR?=
 =?utf-8?B?R3VyWkpkTDJMNFhRckV6MUpXdGRPS2RUeXBVcFNBbG1SVGRNWjI3RzZQclBH?=
 =?utf-8?B?eDhEUU1hMTdyUFJBcUpFTmR5UVp3NGFqRUVQbU1IdXFTRlhEWUJOQmRTMzc1?=
 =?utf-8?B?KzZwS2NFc0pCbU02WlRvUmpTTkpzY3lUOHF6MFQwV0lwdjY0d2YrTjd3Wktn?=
 =?utf-8?B?SmlLekdEb3BacFltYUdPMFViUm1rdTJDYjZNYU1OVGRhK1dib01CR3VWM09B?=
 =?utf-8?B?VVhCZnFoRyt1Um5UOEdOc2JjWVh0VHIwbVdlQlM3QUlDbjNhNm1CSkpncDVv?=
 =?utf-8?B?ZlFiTWRzYnRXRXNEYlVWWjg2cmxnV3VjM1IyYlhhcW9hV3R0WmhhOWpWZGdh?=
 =?utf-8?B?NS9lMXV1YkFLbFpYQ3JicUIzVytlUVgrNGo1WmdFOWFpd0VWbFdGa3JJQlE3?=
 =?utf-8?B?eTdGdnpXaTF4SVhqcGJKczNROW1SQlNxOHNQQytxZ2EzdHFXc0ZETTYrZkdj?=
 =?utf-8?B?ZEg1L2JHcThCZlFnS0JHdW1NSGc1NEZNU0Q3cXZGSzRGYVVWbGtHSFdJelc0?=
 =?utf-8?B?Si9CWW1nZ1FCaGFUMS9OM3RiR1VqMjFkenhKZm5EK0c2SHBHQWRtY1p2NzJZ?=
 =?utf-8?B?YWU3amZvZGVXQW15T1NsVnZva3NjUVEvcEZGandCUFRMVU90dFpsZmF2TlU2?=
 =?utf-8?B?aTVadlI4N2M2QWgveUlPQkhBa1NPWlV3K3o1NWkrUnV4MlNyTHE0Y0hMaG5s?=
 =?utf-8?B?NjkrM3VVRUdhaUVZM2pLVHg5MkYxMGVNZW9TbkQ0b2Q3ZzAzWVpWNnpHN21j?=
 =?utf-8?B?aWNqV1RYTnNsNHNVN1kwVVlzbDZ6LzhDc3FuQ29MSERISzd6dFFzTFdRNGU4?=
 =?utf-8?B?Vi90Y3pxYUpHNDhtWE5GRi9yZjR2LzFmaFZBSU1OdHpTTlBCQVJqN2kxbjBX?=
 =?utf-8?B?SzJ4eUZ4SmN0Q2NTUUpZcWIrZ2hyL0sySHBHWlpDUDNqZ1N2cS9WNU9CdVVa?=
 =?utf-8?B?c21ZV21qQmZMcit4c080OUpaV0xRNXgxek9KeVlYeUxyaTlJZDZkVXhyR2Vo?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f6abe6-2a0c-4014-93ed-08de06b7c471
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 22:12:27.9462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0bc23ibuX6YNF7JH6+cewEvDRBWSDBJcDy8gnguuNgvWPDh6ylfOBkypS1IXU8OP4Q8xmfKl09CNE/eOOdHL5H6LGLgqE9n3jHTq7x8E98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFEC87B8781
X-OriginatorOrg: intel.com

Hi Tony,

On 10/8/25 2:15 PM, Luck, Tony wrote:
> On Wed, Oct 08, 2025 at 10:12:36AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 10/6/25 4:10 PM, Luck, Tony wrote:
>>> On Fri, Oct 03, 2025 at 04:58:45PM -0700, Reinette Chatre wrote:
>>>> On 9/25/25 1:03 PM, Tony Luck wrote:
>>
>>>>> @@ -3253,7 +3267,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>>>>  		ret = rdtgroup_kn_set_ugid(kn);
>>>>>  		if (ret)
>>>>>  			goto out_destroy;
>>>>> -		ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, snc_mode);
>>>>> +		ret = mon_add_all_files(kn, hdr, r, prgrp, domid, snc_mode);
>>>>>  		if (ret)
>>>>>  			goto out_destroy;
>>>>>  	}
>>>>
>>>> mkdir_mondata_subdir(), similar to __mon_event_count(), is now unreasonably
>>>> complicated. Just like in that earlier change this inconsistently adds 
>>>> RDT_RESOURCE_L3 checks, not to separate L3 code but instead to benefit PERF_PKG
>>>> enabling to reach the handful of lines needed by it. 
>>>> Here too I think the best way forward is to split mkdir_mondata_subdir().
>>>>
>>>> rmdir_mondata_subdir_allrdtgrp() may also do with a split ... most of the
>>>> code within it is dedicated to SNC and mon_rmdir_one_subdir() only exists
>>>> because of SNC ... any other usage can just call kernfs_remove_by_name(), no?
>>>>
>>>> SNC is already complicated enabling and I think that PERF_PKG trying to wedge
>>>> itself into that is just too confusing. I expect separating this should simplify
>>>> this a lot.
>>>
>>> Ok. Splitting these makes sense. I'm terrible at naming. So I
>>> tentatively have:
>>>
>>> static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>> 				struct rdt_domain_hdr *hdr,
>>> 				struct rdt_resource *r, struct rdtgroup *prgrp)
>>> {
>>> 	lockdep_assert_held(&rdtgroup_mutex);
>>>
>>> 	if (r->mon_scope == RESCTRL_L3_NODE)
>>> 		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
>>> 	else
>>> 		return mkdir_mondata_subdir_normal(parent_kn, hdr, r, prgrp);
>>> }
>>>
>>> and:
>>>
>>> static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>>> 					   struct rdt_domain_hdr *hdr)
>>> {
>>> 	if (r->mon_scope == RESCTRL_L3_NODE)
>>> 		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
>>> 	else
>>> 		rmdir_mondata_subdir_allrdtgrp_normal(r, hdr);
>>> }
>>>
>>> Better suggestions gratefully accepted.
>>
>> It is not quite obvious to me how it all will turn out from here with the
>> addition of support for PERF_PKG. By just considering the above I think
>> that it helps to match the naming pattern with partners,
>> for example rmdir_mondata_subdir_allrdtgrp() as you have that matches
>> mkdir_mondata_subdir_allrdtgrp() that is not listed here. The problem is
>> that the new rmdir_mondata_subdir_allrdtgrp() is L3 specific while 
>> mkdir_mondata_subdir_allrdtgrp() remains generic. I thus think that it may make
>> the code easier to follow if the L3 specific functions have _l3_ in the
>> name as you established in patch #8. So perhaps above should be
>> rmdir_l3_mondata_subdir_allrdtgrp() instead and then there may be a new
>> rmdir_mondata_subdir_allrdtgrp() that will be the new generic function
>> that calls the resource specific ones?
>>
>> This could be extended to the new mkdir_mondata_subdir() above where
>> it is named mkdir_l3_mondata_subdir() called by generic mkdir_mondata_subdir()?
> 
> Reinette
> 
> Making and removing the mon_data directories is the same for non-SNC L3
> and PERF_PKG. The only "l3" connection is that SNC only occurs on L3.

Thank you for clarifying. I was not able to keep this flow in my head.

> 
> So maybe my refactor should look like:
> 
> 
> static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> 				struct rdt_domain_hdr *hdr,
> 				struct rdt_resource *r, struct rdtgroup *prgrp)
> {
> 	lockdep_assert_held(&rdtgroup_mutex);
> 
> 	if (r->mon_scope == RESCTRL_L3_NODE)
> 		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
> 
> 	... pruned version of original code without SNC bits ...
> }
> 
> and:
> 
> static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> 					   struct rdt_domain_hdr *hdr)
> {
> 	if (r->mon_scope == RESCTRL_L3_NODE) {
> 		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
> 		return;
> 	}
> 
> 	... pruned version of original code without SNC bits ...
> }

Indeed, this will keep the functions generic in the sense that it operates
on all resource types. This looks good since I think once the SNC code is taken
what remains should be easy to follow. 
I think it may also help to (in addition to the mon_scope check) add a RDT_RESOURCE_L3
check before the SNC code to keep the pattern that SNC only applies to the L3 resource.

Reinette



