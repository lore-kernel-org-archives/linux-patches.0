Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296C4376F1
	for <patches@lists.linux.dev>; Sat,  2 Nov 2024 00:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730509050; cv=fail; b=VXxm8aVExRaKBQQuNmG+u0xCmiIn6rzb0dVCuQ5kvdDjQues9qxc/WYAHhNGktkJ+z9QGfK91jARTOif37iFCZZe7UM0LgIgXmDp5hZ/c4rJYQMG4a4VdJkuMEIZoc4vhjZBXYLOS11oKSYaKqVxQJh3AlWagQVpj469j71MsI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730509050; c=relaxed/simple;
	bh=pwncKrxYYule39m3Zm1thFgD+n91gNwkgYIcKiUuPkQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RTtXX3fs+weutNmJJlg3bOkIL9NVrRv+GSYZ93nYRKwlXj4oCTmPTMROO+sWEO+CrTAZRsXs8lsvOIFj8FaToXOtyDBxpPHenRT2k7MGyCJbRz3Lk0QzucnbDa2LU/SZGY/z0J53n+MkTaywQ1qP/rFpm4G37AeThVZ2ckFpQJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HYZY7Wg/; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HYZY7Wg/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730509049; x=1762045049;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pwncKrxYYule39m3Zm1thFgD+n91gNwkgYIcKiUuPkQ=;
  b=HYZY7Wg/2rze1OT2qyEpwBMDuEtri7mXGpzuj5ex7xSFErp2Nr8otQXj
   lt10ibisR9A9QkaL8lNz7RWvL7SiDbcAWWmUTQSKRrzi8nJnRKjfD6088
   6HTfrNEqqRTY9ivok8QaZ6oUyn0lEf6wZUYnmF00q1zFK/aJH+tSmEgOc
   DmRyUa79Mmd0jHMLK2MFJoeyXTsPJVZqkJZmBjY3J+kjfIlqqKtCKV0Ix
   YBYO7k8F8O+GZNlyfKaxZD1uBQ0eglWs297iYYsko7qcmG5kbQahVaULr
   86Q+jclEHu+qGT+BBdB9UzV6f2jcBB/DtBI64Jb+gvgq3YgdCqiIOrScF
   A==;
X-CSE-ConnectionGUID: 2wGp6u/ORIeik6pfm4QKqQ==
X-CSE-MsgGUID: Wkn94RzKQouC2k3ScfK/0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11243"; a="41685206"
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="41685206"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 17:57:28 -0700
X-CSE-ConnectionGUID: QGaYIepNQ2CIeeGcdouKcw==
X-CSE-MsgGUID: BVI77hCKR328Anu8V4OVOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="113938349"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2024 17:57:28 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 1 Nov 2024 17:57:27 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 1 Nov 2024 17:57:27 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Nov 2024 17:57:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OyhJc9Na7JVHbDZmN10pqCCAvR5c9KYI/mb6RSoKMT15emxtXW8XSTwWhbvJPg6Ymc2Cdys0ZW/ReA9Pc3DGXLNA2fVCT6+H9SRZHfAysYyOKyMzhQOHVuclqhXJlsFzLehQvT92hUY6MVB6tYGhvnhb0BUQJAvB4Kg5B15ZEYdKjHDSrnnkQdzZZrJguUWLhMBsBLiTWo3syb4LKvyBLwDXbbiVMQEZqiDCCMCsgqanm+t250inqRfXAOW1XIGvQRD4ntfvXuJDZM4TUXLIMbjxuqGYRy2RqubauohaiLNYQZ2aZKeBagCjIFULPsMrh9eqGtFBVdUEoOqFZQuuKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPqpZO6PIr82wCqPMege8xFbzclc6jFMlCbczUhdeQI=;
 b=dnGRgMQm1ux5wbGPygRkfpqWO7fro+oor18v0jyfuk28anD44xaQ7yH5huYtseOWMZ7bm3m9IXmpY1t5xw3+XFNUIxN8q+E947OrMhRfcR1fXjLkHON0kwR7RIPXotP55HcG8Tegl4vaEH2NgdIW1c7mmmhbAqaD36IqGZzTUdIOdUVtqRjh2wB8clBwH9o4VYjOPtdGnrAQKUHoxmcXMojETq2nbm9auIL3N1vTv1gnk4D3HCIxt3UcwgZGbxLizvsGuyTSRiiGYSrUqaW4uWKdiTXqIk4RJLsEupZvyO75IQGBukGUG9fbS0Goc+2PkRgYbI5uiDE0g3xtp57AyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
 by CH3PR11MB7865.namprd11.prod.outlook.com (2603:10b6:610:128::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.36; Sat, 2 Nov
 2024 00:57:25 +0000
Received: from IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::8f29:c6c9:9eb2:6392]) by IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::8f29:c6c9:9eb2:6392%4]) with mapi id 15.20.8114.020; Sat, 2 Nov 2024
 00:57:25 +0000
Message-ID: <7f5f1f66-df3e-bebd-4786-7fe8a8115f05@intel.com>
Date: Fri, 1 Nov 2024 17:57:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
Content-Language: en-US
To: "Luck, Tony" <tony.luck@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-7-tony.luck@intel.com>
 <6a677a4b-7163-cc2d-a615-6b8c499eb281@intel.com>
 <SJ1PR11MB60833197C3FCC0B3CF9AA290FC562@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Fenghua Yu <fenghua.yu@intel.com>
In-Reply-To: <SJ1PR11MB60833197C3FCC0B3CF9AA290FC562@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0021.prod.exchangelabs.com (2603:10b6:a02:80::34)
 To IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6097:EE_|CH3PR11MB7865:EE_
X-MS-Office365-Filtering-Correlation-Id: 132bfe71-a86a-43bf-087d-08dcfad950d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OXV6MXozdlBoK0c3WlovQm9lMFpXWmI4TzVISE0wSElVeldsL3JEbXlZTnlL?=
 =?utf-8?B?akhNT0RCSk9BRTVsUzhHcmJBNHBZVnZ0N21hY1cxb3VsRVVpNTVTZ1FGOHNu?=
 =?utf-8?B?SmlYL25SOWtaRUtreUpIWUhkSytNVGFVSElGdEMzbVRBN0llUXRCdkFDbTQw?=
 =?utf-8?B?dU1MWTEwMzRBNXU3dk5EaHdxN2pDNUNZalAzZ3EwbjkwZ3dJTDZqNHRZR3Fl?=
 =?utf-8?B?cjRkcmZYL1V1L3VPbzRiZDlHOFVVanZHRkh5Tk5LQmh5TXZYNlc2SFZoRGlm?=
 =?utf-8?B?dUEva3prV05vaTFHNUp0aGtBUmJoRlVhZHlCc0tqSGVrM0psNnRzaWxibUcz?=
 =?utf-8?B?K2MwUTMyS1RWVkcySnpzMHA5TUl1VHI5bkY4T0w1Mk1Wcm13N0lUUEoya2hy?=
 =?utf-8?B?Z005Zzg1QUUxU2FHV0xkandHZ0JleTQ3Z256Qms1ZnEvUnhBaGtrbGNQR3F1?=
 =?utf-8?B?TmlxSUIrNFd6cXI2cXZBeHQ4eUNOS1hENWRzUlV5MDAraCtzbURra0JWS0Nx?=
 =?utf-8?B?ZWRHeGlmcVhhWFR5YXBtdllsZi83Y3BNUWVuRFlvUit0K2owYVpGaGdsMW9C?=
 =?utf-8?B?TlI2Y2ZsTERCRWpVSk44dXNXcjJibSs0Mnc2S29abEpSM21hYTFvSXJxVXJT?=
 =?utf-8?B?bis1ZENLL2xOTWpiMmFIUDBxSEJOY3A3dVRHTTIxTEt6U1NMdDl4UVNIanNY?=
 =?utf-8?B?Z1NMeTVOeFl6N1dnUytCRW9pejBqV3hSV24waytkQ3pYYTQ0Y2UwVUZlUFlF?=
 =?utf-8?B?TnJqWDVSZXNmTUpYYzRaRGI4Z29NeHFwWU1LS091TU5vOUlHbTVVN2tidVI4?=
 =?utf-8?B?dHJ0TDZRdnpkQ3R0N2Z2MG5YRjUxNDJETVpOOG9HWDVTeEs5c3NhMGZtN0Er?=
 =?utf-8?B?UGhiWm9ZQzdXNnA2TSsxVnNFN1kxSnZqRWhQQjU1U0JLZ1B5QWlKWFVQYU4x?=
 =?utf-8?B?dlVzZXRMYWQ3TjBsaW00N0NTVnJ6ay9WcE5lTVNVWXBQTFFoV1RwV2J5Qis3?=
 =?utf-8?B?S2Q2YWNuQzk5bWk2L1BJdzBnRmRkanExc2RYYWREU2lhR1JJeWd6Wlk2Uk0v?=
 =?utf-8?B?UU5UN1pzcUVxczN1TWx1STVYZTZoa2pyMzUwUHNXWWNxU1VHN3U3Mk52b0M0?=
 =?utf-8?B?SEpQUjRVM3IyNXpPbWVtYmh2dkpHNmtDcnZRL2t5T3cxT05mQThPdGRPSFpP?=
 =?utf-8?B?Z2l3a3grRVFwcFlHMjdSMUJyMW9hNmZOWjFwekJUSWVOOFh5UTBUdVl5Zkpo?=
 =?utf-8?B?WXlqd2pUeGxoQmxLR3JqenA4YmE3dGlWTU1WK2xhU1FiNmJ6Qk9IZEdFOFdH?=
 =?utf-8?B?Tzl1VGtvc0hlakRtYXRMK0RVSUxlTXpMNnplS01ORFlhNlJMZnEzUEJlY1BV?=
 =?utf-8?B?Z3dxQkxQVzNMRFRVbzJHTXdFd0Q2M3ppdFVudVJDeGl0WU80YXNjUHhXWDMv?=
 =?utf-8?B?b1lQeVpHcGo2bnVuMWkxRlBhbGtLckhGeWtVMkp3Y2hiUy9BRzlZU2ZiMWtw?=
 =?utf-8?B?MDMyKzMyaGhXMWhJTjkyMUNydVNtVmE5SGsyYzZVZHZSYXp5OUlnb1lneENa?=
 =?utf-8?B?Vm45aXZKV2V2OGRyWGFYbDhJQUpROEFIUXJDYjZQQlUzRjROdkNHY1ZNay9j?=
 =?utf-8?B?RW9wVGFveEthTC8xcExlRDNvR0NlR054cHcwQTE0Ui8rS1M0SGxMY1pNaGJE?=
 =?utf-8?B?b0VjRElrdnBkSmluTEZKVWFvNmIvN2xiYldqQW1pMkNRWFdhQVZ1VFR6eXFu?=
 =?utf-8?Q?NYV1bD+3fifVtS42pmATpHPbDhLQ0155Z5A0KT+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6097.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3BZMlR5MzRkY0RsaSs5RW5GQmE5OVBUalFvOTg1ZDFYbjBleEZwRGdRdDF4?=
 =?utf-8?B?cTQxMVorSndlRDU2ZFlUajVlT0JIYlpzN2NJVDhURHB4cHhKdFBKUXI4c29h?=
 =?utf-8?B?MFlsOHpzdFFqKzdNRUxCWEFsaHlhRmx4QnIzY1JrTGRJTE42dzc1R2hPbXhS?=
 =?utf-8?B?ZWRDUXFBZjlNcmRHUnpZb1VLVHY1WE9hOVlmOTE4SDNmZE5Ldld3WVNseUlP?=
 =?utf-8?B?V0dmajNiYXVGWEcxbjZKMndlNFlEbzhweVVINXJtMW43SFpvZkIyb2ZqT21o?=
 =?utf-8?B?aEhJT0RleU5PSll0VjRRdC9MMElnRUpaUnFRQ0ZPTEl4M1ozUjU1dU1vWXNa?=
 =?utf-8?B?ZVN5MnM4SDhId0FoeTV1Mm5HdmpLLy9vTDBudyswdTBVUUgvRTU1QlpiSHJl?=
 =?utf-8?B?bWh6K053V2xWbzRRWUJqZ29aREJ2TTh1Q0hLSnhPcms4dEpLMzlLUHEyS1pl?=
 =?utf-8?B?YjgyTk5iaXlTa20xQkZKRGxUNHJROGhHQ3FtK3FGV1BhaGxMaTJIRi91VFBG?=
 =?utf-8?B?UmJzZlBzT1NrY2ZidTlzc29PSGlaWWt2RFhHWWZPdFF2SVVnd0EwcTFHdDdW?=
 =?utf-8?B?NHNOZkZmSGlyMk5wZjE4NXFpdVBsNUljWDdDTWxKYk5idlZmVHorOE9aeDda?=
 =?utf-8?B?bzBOZ3RXSi9ZVnJoSHkvUUhzREtjSGVzMGs5NWQ5SzQ4Slh4NFFaRzRIa0hr?=
 =?utf-8?B?a0Q4Z0NWYk1jSGpkUWVLQmNLTVMybXh4UlNWYWhsQ1BGN2NVckRXTzJEM0RB?=
 =?utf-8?B?d2d4QmF1WXBHRUxoRWNib3FuWGtqelBsdlNEZFpaQ0FXdnRZeWhtS3o1QmJK?=
 =?utf-8?B?UFBDQzFKN0VUdU5NbUd4SjRhSVlYWncyWVdQUHV2OTVuSTJ0NDNNRGdjdTht?=
 =?utf-8?B?ZFhMdlZwb2U5MnFzN04yQStsMVM1Wis3SEI3VTVlNlpOeGxoTW9aNXBtY3ZB?=
 =?utf-8?B?MGI1QUlwRGVDRUJiOHFZNDhvb2FraW1QVlZqbG13aVAxSzU5Z0Ewa2lLWSt4?=
 =?utf-8?B?V3JrcUZlZEdhenNSVzRUNUxmV1hDZXZmY0VYbFY1M3NkSHJPK0dDeWgvOVhP?=
 =?utf-8?B?MFpKRS9XNDhUbmZPcmFzVU9nVGtWODJSVEZsaTVNelNwVE5JcXoxSkwzcEM2?=
 =?utf-8?B?SloxUng5Tk5WTGZ5aDZTa2Vwd3IyK2FWV1BaNzQ5WDBkdUwxSmRNYS96dzZS?=
 =?utf-8?B?RGkvUE1LT1hVcElQeWFwYjcyL0krSkZwL0VSMDllQ3RIYmtTR0NrS0pVeXFr?=
 =?utf-8?B?TjJzSXNRVlV3MlFES0ozZUlNbmF6MzU5T2NYalJvbGxOZElLcm1Wb2x3U1N2?=
 =?utf-8?B?TFNMR0l3c0F4YlFEc002LzN5b0d0aVlzOXFZbDBsRHZZSVBHYVR5NUloajQx?=
 =?utf-8?B?cmZvMTRmUW1idW9MWDMxdWhweUJlUUY1VGlIcHBHNHF1TWYrM2VpMlJXVElO?=
 =?utf-8?B?SGIyRHMxMUd4WlZ1Um1SQnZLRjd0OFlBQ3hFK1ZXY0orazQ4QVRyZHpmRmZj?=
 =?utf-8?B?cEgxazJKcnV3WWNDczdyR1h6V1kwdldGaHZqMUhHazdva2pKMDFvR0g3SWxZ?=
 =?utf-8?B?MlhBMTVwTW9ueGhvTStpSUt0V2Y3RFp3Sk1YZTVZY3pia3VHWk9uSXNHSW9p?=
 =?utf-8?B?eVhBRjkycEtxeVp5eHlmRW1QeThSbFpwcGZkL2RoYUU0SzdTaXhDUUNNdFA2?=
 =?utf-8?B?V0FaWFp1akVKS1pWTDg5SjBUSndxNHVTVHhRK0dOZzNzYzZhZE1pM1h6ZWky?=
 =?utf-8?B?Y2ZkWHVCRUdkekVmSkFmR3l2bnRhNUJJb1BDT3FTZTlESXdqM1l2Z3pHTk9p?=
 =?utf-8?B?RFkrYU14S2JjTVJCTFBpcEwySlVPbjNwZzd5elJYUTlBampsbzlONTJ4Sjdi?=
 =?utf-8?B?azdiS29GSXlmME9MdXRDOUJRTENZY1B0SVczL0NWcnhMVmJJTS9ZVlFLeFdm?=
 =?utf-8?B?ekllNEdvemVwTFZ3a0NiSksySy9CTm5wanRZOTFGSFk5ZWdkbndlZmY5cmZp?=
 =?utf-8?B?dk1hVGxQdEd5aHpteDE5SXFpT3I2Y0Zia09oZ0h5SDhaZHRpSmdKMkZ5alBn?=
 =?utf-8?B?Q3BIZUwwM2gzR0ZiY0ZSVVpZTkV6OVp2STBFeEhhRVR0TjYrcEVQbG1pWnpo?=
 =?utf-8?Q?INw1bLoB3rzCMdRRswxwAw6eW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 132bfe71-a86a-43bf-087d-08dcfad950d8
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6097.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2024 00:57:25.2834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ul8LT5EESRMOyVb+9OKZHwMEZr0Z0bz62hZx1jyPx0X8BesQmG1SeIAhFJRxoNTQrnVpEOhZ9DWg8yZalXvJqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7865
X-OriginatorOrg: intel.com

Hi, Tony,

On 11/1/24 16:55, Luck, Tony wrote:
>>> +   if (!strcmp(buf, "mbm_local_bytes")) {
>>> +           if (is_mbm_local_enabled())
>>> +                   rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
>>> +           else
>>> +                   ret = -ENXIO;
>>> +   } else if (!strcmp(buf, "mbm_total_bytes")) {
>>> +           if (is_mbm_total_enabled())
>>> +                   rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
>>
>>
>> User may think each time toggling the local/total event will effect MBA.
>> And they may create usage case like frequently changing the events to
>> maintain/adjust both total and local within bw boundary.
>>
>> But toggling mba_mbps_event faster than 1sec doesn't have any effect on
>> MBA SC because MBA SC is called every one second.
>>
>> Maybe need to add a ratelimit of 1 second on calling this function? And
>> adding info in the document that toggling speed should be slower than 1
>> second?
> 
> The limit would need to be per ctrl_mon group, not on calls to this function.
> It's perfectly ok to switch multiple groups in a short interval.

Agree.

> 
> I'm not sure how to rate limit here. I could add a delay so that the write()
> call blocks until enough time passes before making the change. But
> what should I do if a user submits more writes to the file? Queue them
> all and apply at one second intervals?

Maybe define "mba_mbps_last_time" in rdtgroup. Then

if (time_before(jiffies, rdtgrp->mba_mbps_last_time + HZ) {
	rdt_last_cmd_printf("Too fast (>1/s) mba_MBps event change)\n");
         rdtgroup_kn_unlock(of->kn);
	return -EAGAIN;
}
rdtgrp->mba_mbps_last_time = jiffies;

> 
> Maybe it would be better to just to add some additional text to the
> documentation pointing out that resctrl only checks bandwidth once
> per second to make throttling adjustments. So changes to the event
> will only have effect after some seconds have passed?


Add additional text would be great.

Thanks.

-Fenghua
