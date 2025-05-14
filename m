Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7995A211278
	for <patches@lists.linux.dev>; Wed, 14 May 2025 09:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747213929; cv=fail; b=PFIxdmDTSaRr/lFjpEHOsKlx8PNjg5vrp6COzJ5RJcpAJfungdyo6ZP7RQRaJKc5rFBmMuL1N/JAJWgJYOa53ffVy2LZCcbdsc6wBZ3bkzboj2kRPSRF/imNhlbIK7S7EQ4j9efI0dG0U4ofxItgdmL25f8aBVYUFmlKqSwK1FE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747213929; c=relaxed/simple;
	bh=Y2mSl+4cA+PjwWbz04dsSMADK0KwAoAn3fF8pe2l2og=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fov8tLK2HOAQ2x2ouii97JsTpovgRiYdwNSHWhPPRRS04ZxsscYDarePsMLDy05EjcqFF5l8oOVgNGz7U3WkFu2CMWz8/VvQC3KnmyMQ1/pAJahW81+pKYhpQBJhrZRVa9uXPhb5T6XWDbHpEHDgGrbzB6dfz8P7jNcWtvxGAEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HyPeEOm/; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HyPeEOm/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747213928; x=1778749928;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y2mSl+4cA+PjwWbz04dsSMADK0KwAoAn3fF8pe2l2og=;
  b=HyPeEOm/ZndYR0d44EO3RdqAvKcB6StzyUxRKSjmpqFsrP0cVc2I0O3p
   hx58+3Y/15pi43wwcQ8DqzBp3k+nKBs+EGG/wgP5Wo6mlgjbob3uGXbPJ
   uG8DQgBihsQshgaPn8mpSPTfLKFbcixogfwIlndcZEDmGQwEdwxlJkAGF
   5N+HaBNaa20352r2EQwe1w/xiK/EIaJQ9ZqIXfnf4dnh1o/KbCMqyNnuu
   4LgEtopa+pagrNL2EG79dMsU0wxM8nV/EYfROd0RWa0Od0FEd2/RSqGpn
   O87qEZsVtJ2/cohwRM6qqXtnHdeJDIVvBdiako5o1+jMeOPa7o71wBodv
   A==;
X-CSE-ConnectionGUID: iv+NHFvtQRuSBpWh6SsCMA==
X-CSE-MsgGUID: k1dgHLDpRJ2JtTVcPuenuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="59329123"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="59329123"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 02:12:07 -0700
X-CSE-ConnectionGUID: 1uFZ+KvcQeKnbyTn8ULNRg==
X-CSE-MsgGUID: W1cmbff3ToSmQuMiO+BKOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="138904488"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 02:12:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 14 May 2025 02:12:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 14 May 2025 02:12:06 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 14 May 2025 02:12:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ccn+t3uyiU+uFTsRWgxSBjgGTRFxOjA1t8rUsa40fjwsn00R8sSSrAo3uxKCUyRz05LWXZHNLW+PoKuewpItaZI0SXX0AKHXwZdvUAQ6V8FMAZNf05zyXJaGZAUOuMwg2Vod8DgvAPQtzvQtFIy1ioVmNXV1w41ykfkdj6q/L3x8l3Rfqm/fNt4Qn6LTkkakSdg652IQEfjd+a1m+HW/QizdKEezGPsHzfJWon9bdUzODovk6E3bRkoBEtwkmW62bIl0wCW8Ao8wIva+jyys7ym32dlTfNdSWow8kt1fg0NLxGwIsiTtLOntRKsA4f0KyL9mvaoYFUOci4tLfEWtuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDe1kd9JrCRiPlfPjOKFvfFxwQGgkixEhRBVgG6nthw=;
 b=WjDl2o9oLcV+AY+f14tbcjamB/+89ODLCcFrNcZJjsjxUVYVliI6WQCMtlCiCh7rwo7m1SlGWJi2hr/pq2bSqu93mwrnf8Vb/0uw5HQt3G6C2nDC2fJiWOhcgAb0wtNhJ47s0fj26Hc4hog+fkThyfIcVUeJ8OQnl6WundHkf8jefZNWq++b/Kkm87ULtPt7RdJEoofuL2JDqplDakPs0yJVyefO7rzXR1GIwSM+2OGu7Bn5FUoslo8zoZqaWEP6la7G6B3d3pt0hPgsexWsKSLugmKtX/yy9fc6EESRiFh89tMOM217CcnEr65W746R91PFrJEiGOapkOMU+KlLfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CY5PR11MB6284.namprd11.prod.outlook.com (2603:10b6:930:20::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.31; Wed, 14 May 2025 09:12:02 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%6]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 09:12:02 +0000
Message-ID: <c147325c-6d8b-4b81-be22-a6311162b6f7@intel.com>
Date: Wed, 14 May 2025 17:11:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/31] fs/resctrl: Improve handling for events that can
 be read from any CPU
To: "Luck, Tony" <tony.luck@intel.com>
CC: Reinette Chatre <reinette.chatre@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	Babu Moger <babu.moger@amd.com>, Anil Keshavamurthy
	<anil.s.keshavamurthy@intel.com>, Dave Martin <Dave.Martin@arm.com>, "James
 Morse" <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-13-tony.luck@intel.com>
 <e818906f-b03a-474b-8a6b-d291cf1a74fe@intel.com>
 <aCNxSjUEFREUS8zG@agluck-desk3>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <aCNxSjUEFREUS8zG@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0044.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::13)
 To DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CY5PR11MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fd067a3-9b3c-422a-b4d7-08dd92c76317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RHR2RUl1OHBwRTFUOE5Ed1Joc3MzblhJVkt2dEtNTVRyNUFQUWZGZUFUcXlE?=
 =?utf-8?B?RElveEJEbzRCYVc0bWN1c2o4eG5uZTVzb2dKMXNUY1NtSkZiNHlPMXVtOWZm?=
 =?utf-8?B?ZHFoa1Nvd3RLVThtUG9UanBvT2tLcG9IZ0wyakg0cFZhcTRtU0QrWGUxZGdG?=
 =?utf-8?B?TFRHSGtvOEFiQ29qNEdBUk10VmM4clN1SHYvVVVxQUxYUmR6aVA3bWpyUSs0?=
 =?utf-8?B?d00raC80VEgzUnlDRUxKaktIRW9nMnU0WnhJdmVpVTlKMlZRZGNBemR4Wm5z?=
 =?utf-8?B?N05ONHg2ZDdKeEUzcnNXU3QyTG5zQjZ5VXRIQnlkSnJJdUIwN29NYTdzWVFP?=
 =?utf-8?B?Z0owTExFYXlob1lXSGlGL2pSOGp3Q2RNMWo2akFpL2FDSTlPM2JkbGRvenpW?=
 =?utf-8?B?SExIWm85MFNpYWl3REdndDliV0twQWVyWUh3ektlYysyVDFSbDRFRTZVQ3pl?=
 =?utf-8?B?aFpLd2YxYTF0Qk11VmlibjNQSDB4a3JuQnZJWnVkc2ZaT3duMHlmUktMc29n?=
 =?utf-8?B?NUZIWUdJYk5uNXBod2JpNXM2L1pxYUg1M2ZqcmtWTU1qcHBIaTlhZ2NneWwv?=
 =?utf-8?B?WEcwRHlXNExKdks2SCtkNjhJOWY2bytpWWMrRnExWXkvZUIvd2V1OCsrSTNK?=
 =?utf-8?B?S0xjQURlLzZ2Q1I3aTNmSVpJNitYS21MOXhzZkx6eTVtclQvUUpweElqSjQ0?=
 =?utf-8?B?c2FsSDEyWWRkUnBGRWhmZTh1MFZTeHl1VGFsdnRmSDB3VkRZeURPM01vends?=
 =?utf-8?B?bC9vWWJjdk5PTmF5aXYxTWlnNGtzZ2NTeW1XY2liUlB1MWhLMHl5RHltcVdp?=
 =?utf-8?B?WTZlbzdIMmF5UnZoWDA4NTdUUFRaYWtaYktUTWIrRDIzQVp2UVVnVDRWZFE2?=
 =?utf-8?B?aTZET2V2YVYvUjE2cEhMcFlZR0Q0WHFxc0JlQjAyQnYxemd4a2F4UDJJdmd0?=
 =?utf-8?B?VnphaXF4NnZCakNGKzkrelpBVmxlY1ZUR2hMOUlrKzBSZmVPbjhROXpYRHQ4?=
 =?utf-8?B?WTF5MFRZL1lkc3hsQnRFWlNYVWZLV0plN3QyOUxoWHVDNGcwa3pEZmhkK3hO?=
 =?utf-8?B?UlJUVmtxeE93NGNRTnI0NnRvS09Mc01XTVh1aDFUQm5XdXNERDFQbHNndXM3?=
 =?utf-8?B?WWhKa2ZxKytJL2JYcHJGcXVNT3RjVGorMmZzM2RHUzZyNzJPYmYrWVZpZWkr?=
 =?utf-8?B?UDZ2ZXhPa2NNSW8xSEZxRUpGMU50MmdMQ25oWUJObG9ON3YyZ1dEK1JhOWx2?=
 =?utf-8?B?VFRpa0VHemFTbjNGcWFtZnIxYnRUSWhGaWJpRkxoVmM2OUlXVW5wc01VUUMw?=
 =?utf-8?B?NlZEY1JIaUs0Tjd2TFpQc2NsUzVtVTAzMFJLN21hc3pRcFZjTldpS2x0cmFr?=
 =?utf-8?B?WHZzSHJVMVhZSWNWMFhuSjY4N2VONUNPcVcxOE1pSEl4NFBmelBBQ2ZhVnRR?=
 =?utf-8?B?L3QyanEzdXRrTDVoZ1pxbDF6SmZVeVV3ZVhMbEQrTGdSV3pXaGpTbnlaREgz?=
 =?utf-8?B?dDdDcU9ocnlaVnJZYmtTR0ZTS0FSZ1JwRXNaaHhUaDdMek5Ud3VHSWVJaEZt?=
 =?utf-8?B?SDZJRE5hYlZONjJZaWVMTkV1RUpTemNhTytTVExKd0RHSUxtOTlzK3R6RERq?=
 =?utf-8?B?T1BGcERBYVB3LzhTSjlFZ0xtRFczMmxJVUhmZHI2VXVpZGZmMy84ajRSYkJ3?=
 =?utf-8?B?dG5BeUJoVEdHdGhLcUxoRUFIdmVSdW5aM0NibVREVUJSeDhWMmVCRkQyZCtl?=
 =?utf-8?B?eng4YXkxeUpCaUhCTk0vSnZnbytmNmo0Mi9YZmlNSGg4aThseFFuOVYzU2lT?=
 =?utf-8?B?cEJ4SGhIQmtLR3ZqUHlUQVNScklMS0UwaXVzM3c2MTdZSkgrVk44QXQzWFZZ?=
 =?utf-8?B?M21uRjhPNm5zZ3N3WXZFenR3cjlpaVFhUGhrVEl5QmczcmYrSFFXOEY4WERJ?=
 =?utf-8?Q?s3QJGqjeo78=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW91ZE1FeXBDTHg2d2JrSXFrV3JpMVR4V2Y3YlRocTFPR2tuZzc4bDd6ZnYz?=
 =?utf-8?B?NEJ4M25tYWhHZXVoUE5xMXJWMlQ3WkR6OWNaUkZaVWV3S1pqdDlaalAzNENk?=
 =?utf-8?B?OUI5UWhadnRQaHdvbncrcU13dmp5c2RnWHN0M280QkkweDk5QnFDYTZ1ZnVU?=
 =?utf-8?B?dVpkeHp4dGFsUjZBN0lENnJVSkhXVVBmZGtpMHAwU25XYjFrVnJlcmVNOXVy?=
 =?utf-8?B?elc0ZXoyQjdSMndBMkdHWHgzb1ExcC9TMFd0Ry83RThUOWM3enJiczJIVWNB?=
 =?utf-8?B?SVZQRXFkZ2lVbFFaK3B1QVN4RmlkODRnMUJxN3pDN0F1UkhKTUs3bU11T2xU?=
 =?utf-8?B?aFhhU0QrTTNnU1NOZk1wdXE2eHZPOFdXL1h1RTV1c2k3SFhQWUI4R3hTZkhP?=
 =?utf-8?B?OXI4Z2w1K09adGZvN05kOEJUMXdMVm5kY1FzYWhpdk9xRW1TbWtsYlZmWGlJ?=
 =?utf-8?B?NnYxSzBOWThLU1ZsaGw0N25KRTlWY0JBZVZ3RElPVGZnQWRBZHp1ak40Qkpr?=
 =?utf-8?B?NkowRzhEOFErTS9TWmxScGphWm9xME9DWHJWYnRXOWhKYS9WaThITkZLRzNW?=
 =?utf-8?B?Y29JNS8yaWxqRk5XNGZSbnU3bytQVG1hNTJJY2hJNjdid2xxMkpqY3ovRVM5?=
 =?utf-8?B?MTFYN3A1VzFnZnZrRGtVRHYyK3lHbEdLcWR4QmFteXJrMHdZMTh2R25uZFRV?=
 =?utf-8?B?MTdLRkovWHF4d0VQZlBhRnNHZW04WG1uT25iV0JaQzRMdjVTZHlOZmloZXox?=
 =?utf-8?B?Tmh6NVJrMzMrQVJ0eVVwUEkzbm5ZK1g3eU9sWi9KeTZTSzA2dHFZN2o4WGdp?=
 =?utf-8?B?TjNIajlBVlhldUF0Ym5mMTNOalJIQUFaMnpuNTlPeGxqSHVoSUpja3FiS1Jh?=
 =?utf-8?B?NXFWSk9samVqZjFRdDVYdjBoeDZFaGN6Y1JwUjRtQzNMTzRUMFVQU3BNYUlM?=
 =?utf-8?B?YzQyR1M1Qmx4YU1jYTZzZDNGV3Ivc2xsWit4THVjTjA3YnRuSEZGQ1JZa05j?=
 =?utf-8?B?ekRwK3JnV1RtRnI3eGhIOXVUQ0FCZkZHRVNEOFQ2TWNSRkZnK2czMUcwdjNi?=
 =?utf-8?B?WWFTM01ZK2J4UThibWVUdFZ0TVVWb1VwaTd6bElGaDFaQWluNGk1U3VZYWoy?=
 =?utf-8?B?Y2hPbTE3aXdWV1BvWUJzdm1GVjFwVHNFaGEvUW9ITmNxMzNCb09QVkFxLzFQ?=
 =?utf-8?B?TXgwbFZ6SCtIT3o2VklKNTVjcmVSRnhqZU5qV3BJb0ErQllqZ2ExSVdLRUl3?=
 =?utf-8?B?ZVh3V3UrMFNUdlM1M1RmcUdNNmJUUDUvbzd5Z0RIeXFSZEdSeTBFS0MvcTRa?=
 =?utf-8?B?L1d5blBmdjNudDdXSmg0OEFqbWlHc0VJNlJJaHVoN3hQYWM4a3lUdldqK2Jr?=
 =?utf-8?B?QmQ5cFR1cmo4RFJIdlkvT3pacWF6anZ2bVkxdEozSStNdHBxZmIwUVNTMXE0?=
 =?utf-8?B?dTFLZTFxNUN4OHMxTDVjZmxlKzlVQWd0WUdxZVdOZmRDWGs2ditsZm1CbzZs?=
 =?utf-8?B?cE5TRkdZT1RzaENXUDJUa1F0OEdyajQxVG5hcVlFcEhnYUZUWmJEdGNTVEgx?=
 =?utf-8?B?S0NJd0pSUWFXRGNnTmpPNTRLMy9GNlY5UjN1d0NLNFlZcnlrYmZBQ2d1VWts?=
 =?utf-8?B?N1E2b1FhL3gyZ3ZZcmZiWXpkTDkrMnBIYXBSWFBvM0FzbVArNENEdXFYTFlM?=
 =?utf-8?B?aitRWi83OFA3cTAvWk1jbCs5aGczYlFhTW9mREF4R2JBSHJBOUgrZVhvQTZn?=
 =?utf-8?B?Z3JMeFl6T0tJbjJPS3F5aXFHTG1EMlNkUXRuc3h6Ujl4K0RWQnlNV2hGM1FM?=
 =?utf-8?B?WXI4bUdtMnhXQXVnWC90c2R5ZjNYSFRCODlFMkFuOWF0V0FYdGRKekFobEF4?=
 =?utf-8?B?SUdmREJZZ2NBRGNUNHFsWWJxa1BFVXZXeVY0UXVIbytuNDZCcmdiMWtKQW80?=
 =?utf-8?B?aklrZ3dvdVNBNE94VG5sQ1B1b0prZ2VleWkzUFQ4amZpczVrODBnVnNWeTRi?=
 =?utf-8?B?bDM4d3NMTjg1V3RRVUkrMENJVW1YYXBEQXFiM2dpaS83YW80YVNzRmpmK3N5?=
 =?utf-8?B?d3V1MGpVSGV1Smg1Q3JlNklDMFF1QVUvRWdyQTFGRnJLcDRoSXJpZnNZRWFE?=
 =?utf-8?Q?38Y+EjiBE897sw7pK2ycnE7LB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd067a3-9b3c-422a-b4d7-08dd92c76317
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 09:12:02.1535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehYhSE9bFh4VwWYqGMQ5oL14o/PRpzVr5CBxN/xIjP0H7SJ2Kd+XLpMKHc3rO8qf/V//yUj3cBD7zm5Urq7t4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6284
X-OriginatorOrg: intel.com

On 5/14/2025 12:20 AM, Luck, Tony wrote:
> On Tue, May 13, 2025 at 11:19:23AM +0800, Chen, Yu C wrote:
> 
> Thanks for the bug report.
> 
>> get warning like below:
>> BUG: using smp_processor_id() in preemptible [00000000] code: mount/1595
>> caller is __mon_event_count+0x2e/0x1e0
>> 2483 [ 2095.332850] Call Trace:
>> 2484 [ 2095.332861]  <TASK>
>> 2485 [ 2095.332872]  dump_stack_lvl+0x55/0x70
>> 2486 [ 2095.332887]  check_preemption_disabled+0xbf/0xe0
>> 2487 [ 2095.332902]  __mon_event_count+0x2e/0x1e0
>> 2488 [ 2095.332918]  mon_event_count+0x2a/0xa0
>> 2489 [ 2095.332934]  mon_add_all_files+0x202/0x270
>> 2490 [ 2095.332953]  mkdir_mondata_subdir+0x1bf/0x1e0
>> 2491 [ 2095.332970]  ? kcore_update_ram.isra.0+0x270/0x270
>> 2492 [ 2095.332985]  mkdir_mondata_all+0x9d/0x100
>> 2493 [ 2095.333000]  rdt_get_tree+0x336/0x5d0
>> 2494 [ 2095.333014]  vfs_get_tree+0x26/0xf0
>> 2495 [ 2095.333028]  do_new_mount+0x186/0x350
>> 2496 [ 2095.333044]  __x64_sys_mount+0x101/0x130
>> 2497 [ 2095.333061]  do_syscall_64+0x54/0xd70
>> 2498 [ 2095.333075]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Hmmm. You are right, but I didn't see this. Perhaps it only shows
> if CONFIG_DEBUG_PREEMPT is set?
> 

Yes, CONFIG_DEBUG_PREEMPT checks that.

>> Maybe avoid getting the CPU at all in __mon_event_count() if
>> evt->any_cpu is true?
>>
>> thanks,
>> Chenyu
>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>> index d9364bee486e..32385c811a92 100644
>> --- a/fs/resctrl/monitor.c
>> +++ b/fs/resctrl/monitor.c
>> @@ -358,12 +358,15 @@ static struct mbm_state *get_mbm_state(struct
>> rdt_l3_mon_domain *d, u32 closid,
>>
>>   static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>>   {
>> -       int cpu = smp_processor_id();
>>          struct rdt_l3_mon_domain *d;
>>          struct mbm_state *m;
>> -       int err, ret;
>> +       int err, ret, cpu;
>>          u64 tval = 0;
>>
>> +       /*only CPU sensitive event read cares about which CPU to read from
>> */
>> +       if (!rr->evt->any_cpu)
>> +               cpu = smp_processor_id();
>>
>> tele
> 
> I might fix with a helper just in case some compiler doesn't keep track
> and issues a "may be used before set" warning.
> 

The following fix looks good to me. I'll apply it in the internal tree
to continue the test.

thanks,
Chenyu


> -Tony
> 
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index ddfc1c5f60d6..6041cb304624 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -356,9 +356,24 @@ static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
>   	return states ? &states[idx] : NULL;
>   }
>   
> +static bool cpu_on_wrong_domain(struct rmid_read *rr)
> +{
> +	cpumask_t *mask;
> +
> +	if (rr->evt->any_cpu)
> +		return false;
> +
> +	/*
> +	 * When reading from a specific domain the CPU must be in that
> +	 * domain. Otherwise the CPU must be one that shares the cache.
> +	 */
> +	mask = rr->d ? &rr->d->hdr.cpu_mask : &rr->ci->shared_cpu_map;
> +
> +	return !cpumask_test_cpu(smp_processor_id(), mask);
> +}
> +
>   static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   {
> -	int cpu = smp_processor_id();
>   	struct rdt_l3_mon_domain *d;
>   	struct mbm_state *m;
>   	int err, ret;
> @@ -373,11 +388,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   	}
>   
>   	if (rr->d) {
> -		/*
> -		 * Unless this event can be read from any CPU, check
> -		 * that execution is on a CPU in the domain.
> -		 */
> -		if (!rr->evt->any_cpu && !cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> +		if (cpu_on_wrong_domain(rr))
>   			return -EINVAL;
>   		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
>   						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
> @@ -389,11 +400,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   		return 0;
>   	}
>   
> -	/*
> -	 * Unless this event can be read from any CPU, check that
> -	 * execution is on a CPU that shares the cache.
> -	 */
> -	if (!rr->evt->any_cpu && !cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> +	if (cpu_on_wrong_domain(rr))
>   		return -EINVAL;
>   
>   	/*
