Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7EF22FF4C
	for <patches@lists.linux.dev>; Thu,  8 May 2025 23:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746747875; cv=fail; b=BCY+N0+YwCaJoDJk07Km/zOGdx6MJSuf/bDaq21W0t5qF3anQCKosKXH4XgvFBRHrmXO/V7XST3MxdwCAeR3gQGJt4s6gYvhHrX5o2jwAeU4yHfnIe7PZluk3p766GjxZ0gPw6PBYm/8aQ2g6BOOkWpntE119y/Blsrv2NsQoyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746747875; c=relaxed/simple;
	bh=YA4jZBtxejeoxrY+1sr6zuOkP3Celc4G69yZrOyJwDQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r/gi5Kkw7M629YgwPOW5ZziemGbJ5oAodi7FCK7ajcRkdmxTXAand3TnswETBk0996hq42gCUf5N287DFx+w06/6K0HZpxiSkj57vWQIwATlk1+2pqQZ8TxXvwJAR5TdtKsbJ39AoUApPys8GZyNCQDws/vZ6yW2BeAoYpMtALc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N3jsouU5; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N3jsouU5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746747873; x=1778283873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YA4jZBtxejeoxrY+1sr6zuOkP3Celc4G69yZrOyJwDQ=;
  b=N3jsouU5eOqSBD5kXsQM0yh5mUQTfVwO5izShUbOoIFC9MLV8Y2ZcgKb
   yz6q4YikcHuYXTomnlwsfxw+PkWtAVHJ5RsMFs/wPH/qW7RINlzvzNz2Z
   I4NF9iZUg/ej8ZWOJw30g7eNxKtJ/H0jmpCFiIQnGKeFNt2nICrTps2Hg
   7HeK9B+HOLo6dxbmoq+UvkMQZ+vTnXH0v24Vjr9ZUbEBlCKt0Rjzil8o6
   exWwbyMcnuVmeDMMiH0iDgXqY+3V5jcTLyJvOnMw8Xeshh9flTzpme7ca
   61GAuSv8PwWsMpg30yvprp2bJFeu34JE3rIMDQLkInJjX8ekz7NETXPXR
   A==;
X-CSE-ConnectionGUID: BwKxX/7JTLG12O9dM8cF7A==
X-CSE-MsgGUID: oTruIpMoRL6+cxJheQ1Fcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="52211224"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="52211224"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 16:44:32 -0700
X-CSE-ConnectionGUID: o2v+qDoOTsChD4e2OcSU9g==
X-CSE-MsgGUID: fFQpPQ0qT1yySQa/epPncg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136150988"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 16:44:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 16:44:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 16:44:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 16:44:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WErL3nt7Bdr5kmEf8Aw6SG+QllfWcxl3sVxGbdEB6ZaD/BfvLrJaFl2s+2I/xFgaFfE2TcWBimzLUeQcCX2QrsFTHCPVVHm0rFTpMPsUL7JP5Ppu+W8tur231eb3jcf04yx3VBa6My1YkZ9Y6mfz71WB8uE6UAD2ufiV2QpmsgvSzPzs3zhz61sJ0zRtLmM1O1SHZPKkCMbeWmhz2wtgWA/Jt3sdefzSXYLsc0jmpPJ7QfiTPxm9i30J9Fs7uG79cKsUj+nQliZYvv7eTQK8jdPmupwzTRMksc5wOK0+j4AjOj4aMIrt9x7+UyWS3obdQIELugniPNEHJEJnlgQYTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2i7oShfww6dzicdnWrU35dMmKKQ84BKV2C2LzBZUSlw=;
 b=kHQuISX4NAmNMdOt+fOpG2yC1ajvlyBBYW1scrzucHbn3Kue5YyL+12E09SVjMMWdmzDUEBoQxZRAYqRfrsSYmWJAv93z2kXgMhJYvcsFGGOFGB1cj76jCWyF6FrtpNBI+QJhMu7iyfM/OD7RT4MhswjcjB+tNIer28oSQwxFNk184A1/dlRKN6iLIwaTnQova+d5UGDDRY8VbT1XuGALtOeIv2oHC/QI/iFHvpanUzR8lA71sQBGmU3CTgh6uVoF/tQPRU+sQ2X5+DDx26OvY8BAvMtfUKIkXYLLv02NOJ33ra3bHYnjJZy2lPcMS/LbpIc4H7/r8NfTfv7yw2zCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB7836.namprd11.prod.outlook.com (2603:10b6:8:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Thu, 8 May
 2025 23:44:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 23:44:26 +0000
Message-ID: <3c9cab11-f827-4669-9fee-e575fe7f66b4@intel.com>
Date: Thu, 8 May 2025 16:44:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/31] x86,fs/resctrl: Drop rdt_mon_features variable
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-2-tony.luck@intel.com>
 <eb141d41-25e2-4e8a-bfdb-6d3e6a4e542b@intel.com>
 <aBz4wZnuZRGxuAHB@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aBz4wZnuZRGxuAHB@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::41) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: 497c2abd-0e19-46f0-cb16-08dd8e8a44b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZFZQRnl6NmMxby9ZbDJKMUxFRldDT0loLzdUN3c0Z2pmSjhsQTJENkNDUXla?=
 =?utf-8?B?ajNlVkRpYTdMUW9Qb2J3b05xd3dhWHNNLzM0M3R1SERHWkwyZXpEcVVrTzhJ?=
 =?utf-8?B?ZGlFMll4dHBjODErUnhTSzdwQ1lYSTU4aE52QWlsb1duVi9nUTl5a01VK3M1?=
 =?utf-8?B?Tk1OK0FsNzhibkVPdzFjYUsxemdWWnVHcURJanRDaUlETzRnbm9KTkt4SzVI?=
 =?utf-8?B?Q2ZWbWNMbmVyZU12UW5La092V1hHWGJrTlJZdnpZaXBjekhKeFFhZWJTeE1R?=
 =?utf-8?B?ZVc2bmh6NXFqVXd5SUhPdVI5YmVBVmM2b2xNMkRMbmtkb3RldXhHTzNIMzcv?=
 =?utf-8?B?L1VBVVhkQ3RwS0NMc21xU3pkK0ZScFloTGtPVHkvaDhDbFRNTnE2ZnkvcE9O?=
 =?utf-8?B?bmJsUXpMQUluaUJXUk54c1ZFRG9abGIzSnRpcUoxSlZWcDA0YUhmWGNUOEM2?=
 =?utf-8?B?cW8zSU5tbWF1YkRMQ1luZXR4OTEwclVYNzJkVUI5N0plaVVWY0V2MlVvcG5W?=
 =?utf-8?B?R1hQaThyT2RzRTdMV0hscWhBOW8zeHJhcDNEUFBsTUd5RlVhUVhacTZDWkZG?=
 =?utf-8?B?YUFJUGFEekcrazYraEh5VDczTjNRb0xOL0MzZTNsVGxrVTNOZXdtWTYvY0RD?=
 =?utf-8?B?YkZFdFIyUjcweWFUR1FiMXhCME1FNm9LWUV5Wk1HUUx0YjRCOExVcGtHVFEz?=
 =?utf-8?B?c3I2dlZsS3JWYXRwa2o2dm1LRFgwcTlMeGF4Y1FZWGJVcEc2SXFwY0NOTURY?=
 =?utf-8?B?NmRjSW9hS3gveXQ3cnFKTDVQOUdwT2M3eFgzU0s0N09Ub3Fjdkl1TEIwSWd0?=
 =?utf-8?B?UkxBQ0ZxQnVwMDl0RWlFSGozK1p1Vm1yVFpIN3ZUVTV5WHN1aExDbXRyTjdB?=
 =?utf-8?B?RjByNkRMbW9JQjNGVUNPaEE0QWthQ25qU3Exb2hPRkZoVFVQbE53QW1mREZl?=
 =?utf-8?B?aGx4M09QVWpHb28xZTFTcWpWenNoUmhtWThDN3diWGRvdEJSQ1BOd0M3MHdh?=
 =?utf-8?B?U2t6dHpjMUlIMFJWSEJ3aHVNb2g4RW5nR2FnT1R2MXprUVcxTE1BOWZ3dXZz?=
 =?utf-8?B?MVYxSFo3WEVMSFZkZ1V6ZDI0bDB3czFROVVSM2NHMzU4SGdSSWNwNE5FVG9v?=
 =?utf-8?B?dkZoOERub1VabDNtdldpMzJ5U3Jrd1I5QlhvRStoaXZHV1lKaWRTZ2cxQ0di?=
 =?utf-8?B?MzRQOHE4ZGlnZ3VveUxIcE80blpqU2tYSHkwZVpuN3ZMLy85LzNGdGxjUklK?=
 =?utf-8?B?Z0NMMkFBU3ZwQnU2T2J0ZFQ1RldYNHZvSi96S1NTaWJ4UVNMMFhMR0UxcjNT?=
 =?utf-8?B?a1NZTy9JaTBCVFVWckVKNEs5RlRMQ2ZkSjduem1CMzZGLzgwa3o4TXY3cTZl?=
 =?utf-8?B?RzRaY3J4UG1WbjQxK2JFZXFOTkEvRnRESFluMHZxR2lWQkszUXdDTkVCWUFo?=
 =?utf-8?B?S1d5SDFvT3E3WmJ2Y1c1T0dzVXdpYUZBemQ2VVMxaTY3Y0FzVVF1UldlR2Nq?=
 =?utf-8?B?NGFlU3BvS3p3NElvYWZBVTZwU28wcGhia2NFQjhUZVVRQ3Z0VGFZSTJyK0VP?=
 =?utf-8?B?T1Q2TDhNRDB1c0tVVzNnL3grSzkydTAvM2k1VHBqYjB5VU5JT0JFVUpZSmVV?=
 =?utf-8?B?akpFUmQvV3pieDRNRXZhTEFYenVsQm5sNUNWWGdJcGs4bUFHbWJMS2xDNk8x?=
 =?utf-8?B?Ukdqa1lpZmJrbUN3OXF3MlJFZC9vN3pSRStWRWY0SERicHpIektIUU5FcGh6?=
 =?utf-8?B?NGZpazdSaXFVYXdHRVJmbnlWbzdIUlhhcHBQaytOeC83clh0MlFVTjdTZmV3?=
 =?utf-8?B?c3gzV0h2eGhzUUw4WG9JdWREMVBEc0ZXb1VQZGVjbjIzREpibkgzOUF0NXlK?=
 =?utf-8?B?QmZJcE5CVWt0OE9MRExoTS9hZmV0UGk1eGRrTk9ZY1hKRitjL1l3RTdkZTVU?=
 =?utf-8?Q?7eHBsqS9hqk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEN2bWk1ZjNXby9EakpLVzNlZFIxc0JvSW1OWVp3R0wwQjRoRzh2di9yVjNq?=
 =?utf-8?B?a3Brb293L2dEMjRYWjNtejB6OHI2QnRtTGV2MDhLaTRRMld2LzYrYVJVdVlL?=
 =?utf-8?B?K2M5U1N2ZGZib09PUU5MNG1maWU0YVF4dUtPY0dmZmg1ZDRqbWdCWVVzMUJa?=
 =?utf-8?B?RytlbFZXWm5RTkpsbDZDampRRHZkRUMza2R3TG56bk8wTTA3YjNTSnc5TWVj?=
 =?utf-8?B?WE1aMkEwK2dqVjQ4QTh6dkJ1T0w0aU52cHdSOEJjaDNBdlROcTE1TWl3QzRR?=
 =?utf-8?B?eEFROHRNcGZxZjhudWZueGZFaGQrbEdKdDlaQnZDU29OaGJDRTJRVnB2MFh6?=
 =?utf-8?B?ZE54OVNSSzNUZ3pYTm5JYVJ6MWFzLzdlVnE1cklYRUxyMzZQWGVXS2V6elRX?=
 =?utf-8?B?V0xKeEpvaFcyWHFqb1FGenZDcGNzdXl5cWIwQ2h4OFpBaXNBdU5BKzNvaWZ0?=
 =?utf-8?B?bjhXelliemRoc0xZMytKNVJnZUZkbDlONERNcC9FdFA3NlFXdHI2L25xeDkw?=
 =?utf-8?B?MitYNSs2NGlPOGpTdTM0QWtTSVMwc0ZqOURkd1hIZjJqd2FHSFFFeExsQndU?=
 =?utf-8?B?UDFmWGVCVGFKNnpoM0FFKy9rVjVGbCtDLzliZmlMR0hPMXhVcDc0eVU4eFVI?=
 =?utf-8?B?dGs5SWlHaGVIRFVBN1orUEVIeUY0cDdmRlVPZ3Q2QkdIUi9rcUh3OWgzNXRp?=
 =?utf-8?B?SlEwOEcyOTBpRmdmbkNPMUZMZXZialYrTUpGd1NwRVg1NHNadmhBVEhmWmlz?=
 =?utf-8?B?dStnTUFCUWxQUWNMTVk0ajhRcXkrM0c1UnJNeThCOWZhT2dwb3NzME01MUQv?=
 =?utf-8?B?M1REM1ZmRFgyNklYZjQwdFVOS0xESmJqN0xUa2NOZVkrU3FZbmQzMHNIcThD?=
 =?utf-8?B?K2FvbkJiWmVoWFd4YjYzTkRoTmt4M0ZqRE1kakZiczNTSEwwbW85Rms5VFU3?=
 =?utf-8?B?bHFDRDlCWElxT0wwTFJjTXh1aGJ6MWlWaW9RbTErTTM4M1NYWG5lWlhaM1dC?=
 =?utf-8?B?dHpPQ0E4UG9jUzhuTW5SUG1TUmw3aHpiSVo0UGJTOXJ6WHBtcXZJQnFCbjFp?=
 =?utf-8?B?VjJ1THlqZERDVDRPWU95enVtaVo1UmtNWFZYZ2gxZDNvWFkxTW5NQ0Z5Ukg2?=
 =?utf-8?B?NzEybkVyQllUQWZCRUt6dVVvUnN1MmFrWVVjb25PUndXd3Z3c21rR053VFo3?=
 =?utf-8?B?c3RtRUhqaFAvaFZLK0FDVzFCVlVqSmw0NDFjN1lJcmtWVU8wQkp4YTZYYXRU?=
 =?utf-8?B?Q0pLdmZCOW9XbFBKNUREVlNkWnJRTTd4YjFYMnF3dHBIRlg5c1VocCtsNlo0?=
 =?utf-8?B?SStacHVFQ3p0QTIvQXkxUDRaWkQwRlBSTEdWZzdtRC80SjNVdnZYREFzYk1P?=
 =?utf-8?B?bTZEaDdrU1FsQmhyUklWc1B1WUd2WERQQmxoN2dRV2JUOXBWN2dldmIrbHVL?=
 =?utf-8?B?M2ZUV0E3SzRvMm94aTRsZnV0aUF1cmJlTHJKY2hmaVU0N0hjL2U0aFE0RllY?=
 =?utf-8?B?bFJGMVpnRWVjelVVM2dYMzIyM25oTU44eGVvcmo3bEhidWVmbkJISUNoSFVl?=
 =?utf-8?B?VmFlc2ZrRzZIWCsxSGx4azdibEljWkVNci9IN2ZsV2FIb2tDUU9TMlltSkha?=
 =?utf-8?B?c1JvQythK0hYbjB5TFVjUmY5clhaMVZwOExsN1o0QjhtQzk1RWFKQlR3KzdE?=
 =?utf-8?B?UE8zcGQxZi9ReDFGNC9DZDFoZnBLZzh6QmxEMC9Oc3hCMkVROWNock1wd1Bl?=
 =?utf-8?B?dTFFUkhZZkNyOVI2R0FIdDcyTXovVnBEdjdVVmlBTmJmbHFmMUx0eUkzci94?=
 =?utf-8?B?Slh0TTV3Vzd6YWxiS2ExK003aUVUVktpdkdxN3ZibUlDZUZyZE1RVW1nMUlC?=
 =?utf-8?B?MjZuUDFTWkhsd245ZWJEU3h6WjB4L0dEYStUczdBYStlZkZmN25meTVhODlD?=
 =?utf-8?B?RjJVTkllTVZXVG15QW1rMTJYR2p3b01EQ2tqYkh5NkpFTHZmTkp5b1hWVHpp?=
 =?utf-8?B?TlBtd2ZFajUySWFYV3pjTVl0WVkvWFVBVkR4dlQ4dnpRcDVxd0pDRCtPZ2gx?=
 =?utf-8?B?NXJRa3IvS3ByVG1NdjNBa3o2ckZiYmpHZXRyV2VuUjUvZGZaVlFNUzVudExL?=
 =?utf-8?B?WUZOOWNIc3REdTNtSEc0TE04RVNpMTc0cU4wa0xQU1lDanVGVjhCMTU2ZWk3?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 497c2abd-0e19-46f0-cb16-08dd8e8a44b7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 23:44:26.7717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ug7OHPUueE5xpMwKaXFG5Y9VDX2sJ70Cl54J6Xo9fIWfWwVWt8ECuzZpfKbCmacwQY1m81V6/a6p1ClzI047101N6zz3Y7ugTWgjlszJTrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7836
X-OriginatorOrg: intel.com

Hi Tony,

On 5/8/25 11:32 AM, Luck, Tony wrote:
> On Wed, May 07, 2025 at 08:28:56PM -0700, Reinette Chatre wrote:
>> On 4/28/25 5:33 PM, Tony Luck wrote:

...

>>> Change architecture code to inform file system code which events are
>>> available on a system with resctrl_enable_mon_event().
>>
>> (nit: no need to mention that a patch changes code, it should be implied.)
>>
>> This could be, "An architecture uses resctrl_enable_mon_event() to inform
>> resctrl fs which events are enabled on the system."
> 
> Will update with this.
> 
>> (I think we need to be cautious about the "available" vs "enabled"
>> distinction.)
> 
> Maybe a comment above mon_event_all[]?

Good idea.

> 
> /*
>  * All available events. Architecture code marks the ones that

I think "available" may be interpreted differently by people.
How about "All known events."? 

>  * are supported by a system using resctrl_enable_mon_event()
>  * to set .enabled.
>  */
> struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
> 
>>>
>>> Replace the event and architecture specific:
>>> 	resctrl_arch_is_llc_occupancy_enabled()
>>> 	resctrl_arch_is_mbm_total_enabled()
>>> 	resctrl_arch_is_mbm_local_enabled()
>>> functions with calls to resctrl_is_mon_event_enabled() with the
>>> appropriate QOS_L3_* enum resctrl_event_id.
>>
>> No mention or motivation for the new array. I think the new array is an
>> improvement and now it begs the question whether rdt_resource::evt_list is
>> still needed? It seems to me that any usage of rdt_resource::evt_list can
>> use the new mon_event_all[] instead?
> 
> Good suggestion. rdt_resource::evt_list can indeed be dropped. A
> standalone patch to do so reduces lines of code:
> 
>  include/linux/resctrl.h |  2 --
>  fs/resctrl/internal.h   |  2 --
>  fs/resctrl/monitor.c    | 18 +-----------------
>  fs/resctrl/rdtgroup.c   | 11 ++++++-----
>  4 files changed, 7 insertions(+), 26 deletions(-)
> 
> But I'll merge into one of the early patches to avoid adding new code to create
> the evt_list and then delete it again.

Thanks for considering.

> 
>> With struct mon_evt being independent like before this
>> patch it almost seems as though it prepared for multiple resources to
>> support the same event (do you know history here?). This appears to already
>> be thwarted by rdt_mon_features though ... although theoretically it could
>> have been "rdt_l3_mon_features".
>> Even so, with patch #4 adding the resource ID all event information is
>> centralized. Only potential issue may be if multiple resources use the
>> same event ... but since the existing event IDs already have resource
>> name embedded this does not seem to be of concern?
> 
> The existing evt_list approach would corrupt the lists if the same event
> were added to multiple resources. Without the list this becomes
> possible, but seems neither desirable, nor useful.

ack. With an event array indexed by event ID it would also take some additional
changes to support.

> 
> I will add a warning to resctrl_enable_mon_event() if architecture
> code tries to enable an already enabled event.

Thank you very much.

>>
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>
>> ...
>>
>>> @@ -866,14 +879,13 @@ static struct mon_evt mbm_local_event = {
>>>   */
>>>  static void l3_mon_evt_init(struct rdt_resource *r)
>>>  {
>>> +	enum resctrl_event_id evt;
>>> +
>>>  	INIT_LIST_HEAD(&r->evt_list);
>>>  
>>> -	if (resctrl_arch_is_llc_occupancy_enabled())
>>> -		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
>>> -	if (resctrl_arch_is_mbm_total_enabled())
>>> -		list_add_tail(&mbm_total_event.list, &r->evt_list);
>>> -	if (resctrl_arch_is_mbm_local_enabled())
>>> -		list_add_tail(&mbm_local_event.list, &r->evt_list);
>>> +	for (evt = 0; evt < QOS_NUM_EVENTS; evt++)
>>> +		if (mon_event_all[evt].enabled)
>>> +			list_add_tail(&mon_event_all[evt].list, &r->evt_list);
>>>  }
>>
>> This hunk can create confusion with it adding "all enabled events" to
>> a single resource. I understand that at this point only L3 supports monitoring
>> and this works ok, but in the context of this work it creates a caveat early
>> in series that needs to be fixed later (patch #4). This wrangling becomes
>> unnecessary if removing rdt_resource::evt_list.
> 
> I'll see if I can get a clean sequence between these patches to avoid
> this confusion. Maybe evt_list removal needs to happen here.

Thank you.

Reinette

