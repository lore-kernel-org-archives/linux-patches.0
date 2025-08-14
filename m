Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F8C279907
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207787; cv=fail; b=RE7D2BppL20hNHbyizpqdrHdHpoAqTbkNMYylg94RwoVq0CloKBsufpeEBCuwoyFWJXQr0CbcYcP/46XCz0EwEqcUFGudEs0bV6uxqPYEWbTNoV57IKBp6+RYwlsMprGdyTnVRlWo3k4RqWzORmv5f/xZhwlW4nH5/yMe+GgfpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207787; c=relaxed/simple;
	bh=jLjjfi1wpDKYppztHkm+8jlBJo4tPpala4dvEXFoDrU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K62awq8Keq1HAe9/dVtxgXpBV2ispcxzJU9MVwS4AK5DbrubcZob2sPKY6P7TXxdGkuIomg7s+faSYgC86FcxmnQhqJElOBaC9I3foR7Tyu8Z3bOdGEyifvkOudrmk1snaV0lUB6Y0wkcH9alCC2xW+jP8BktBoVYA4Y30imTtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jIPugWJB; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jIPugWJB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755207786; x=1786743786;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jLjjfi1wpDKYppztHkm+8jlBJo4tPpala4dvEXFoDrU=;
  b=jIPugWJBzi5UPaxt6f6R9DKyImMEmT8yprnH/PDTX90zDluGyr178kzI
   9HvHn6VIFqbvFYsw71zKcTJEpJLzoZwRvWXq+wxxRE/I+3qhHvykCKnfh
   Ey2qmZy+lmJ4OiXeesOSTbkNgj1kBefLESM3Qxg+HXjzMe93bWt2+u7mb
   5REOIcC8VZJpkAzAt3KlY1VF5DDRCKpnHUGHrEYtb1N65xtZ6t4psLW38
   eWzMRI3SMR8Owuuoh32jcMh3fL9qczNvkylhq6aPwGbGbCFClwuCoi67O
   0B2ZCtuZE+yavBMUyouCRIVJb5Oh6fub08SawCBtgU2LkadLa9Jtmn5Af
   Q==;
X-CSE-ConnectionGUID: HHAaaWmsQqq3qII18TP/og==
X-CSE-MsgGUID: XZJoP1xNSkWsen9MM/UZaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="68990534"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="68990534"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:43:06 -0700
X-CSE-ConnectionGUID: POGmHY8yRDOt7o74IAZD0g==
X-CSE-MsgGUID: c7OqCa/FQqaWdBK3GS+u1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="171326312"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:43:06 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:43:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:43:05 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.62)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:43:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZjP8KF7t7bN/EH3mDSVZ/WY3kva2VHcle0Lm3FzHSf75wdk1DZ1rJtgiDvtoV/2Wvu824ooBJzySxdyvCdA49a7qOFRG3yJCK2fNyoneVlwvQhq6RvmjHsBijKFV+k8NpqAh1Yvtavf8s7li+eN3427dpkLAZPe8vWVrD11wY3zUAbfsGd4vH9OQb/FjbPceKZsr3VuQ+O/N+/9zsMtYZntJT9mb+mR/5C9NRxJVT69w1dvKwYESicTqv8hWK3qJnHVmKWrLValjbv88zHopg6k8xHmdTheck32GUvwrVJ5hrvUr9mQuJEi1sLsMuIGNZJgHGOXoHsDQo+k3E8r5Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rjDxDYvsJYNzx7axMI8gx+VazKQrVudCEF7lZenU1U=;
 b=ymtidjl7E2iqB2rOsxYxP6v4tnoYzHZT6VeSJmEdSjidqMlXP7HE/Ch9uwwgevWgVnA5hc9EpVlFR0/AnMv9uhOxlm50PPUE19Rm6zrBb5ATr24bZNQYjzFL8bRAF1ZVtyprDQA+rA8R5ksGp/iHbQ9ig7J9apQqcSJTyaRgxY5YGTtLT2m5GVMyZ5fXPojVZeZgHvsuZDrvC9Q1IomPJFRW/Usikye6b/nmxfB52qGnoiOq8mbe+RcThnfG6cecdDVy9SdRqat78z0rTn8eIddfJ0yF4ESvkHdoiQaSS1/XxOXzU7wdqsNdeBQKpS36IrLTCvIPxfI9JgrRgT3Pzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB8988.namprd11.prod.outlook.com (2603:10b6:208:57d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 21:42:58 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:42:58 +0000
Message-ID: <a13f26db-3c0c-4784-b1c5-0a9b3117e5c1@intel.com>
Date: Thu, 14 Aug 2025 14:42:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 20/32] x86,fs/resctrl: Fill in details of events for
 guid 0x26696143 and 0x26557651
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:303:b5::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB8988:EE_
X-MS-Office365-Filtering-Correlation-Id: 8656c2b4-b01a-4c93-2934-08dddb7b88da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aXdWMGRyekhpNndrOWdMUUdKODhDSXZmb2JPdlB3elJyaE9UQ3dmMW1vNnJv?=
 =?utf-8?B?Z29PNzBNZS9sdm5vQ2ExdGJTZllZT2JTb3dXUDdXeS80MVUzcHdmOFhwdWlL?=
 =?utf-8?B?U0hvaExXNUVHd3F2RlRUeXRHWmJlVDFOZ3VDcTZhU3R4ZlY0aVoyYkFJL29j?=
 =?utf-8?B?UmdRZStqOWFIVVl0MWF0Ky9UdzRIQWQxM0VNUFQ5aTFpNHBkU0dFdGRYd2F4?=
 =?utf-8?B?c1RMMXcvQ0Z3MGNDekdFYVRRSDZIeG1DVWVPd1lKek9TZDRscDVZaUpqRmZa?=
 =?utf-8?B?TlhEZUs2Q1JCSkYxTHViZ2J3eXkyZlVwcC8zMit6U2d0SlpkaCtIV3VGbFpu?=
 =?utf-8?B?c2p2UWk5ZFg1SGJxVmdtb3U2dERuYlJWdUdibkFBdU5VVkpQSjJNOGlHa29B?=
 =?utf-8?B?dGhjMmRHTUFScCtuUGMxYU1yMXIwWFprZnh3cTZObnF0RlpJLzQ5dktBek5h?=
 =?utf-8?B?UG9zNEJHa1NCaTh5SlNTajk1bDVCOGFwc3dNL0dhYkEwZkdrSUd0ZTZaRFpq?=
 =?utf-8?B?YlMxVm1GZnBtU2VNREcwM3R2SU4yZmREd3NKQXRyR2JDU1VBQ1lOQmV4NGUz?=
 =?utf-8?B?MXZzUDZwYVZnR011V2Q4Mk04RG9kWWdhdTVEd3NnWWZ5V3FReFcwT2c1anF3?=
 =?utf-8?B?UjlFOU5mTnljVkRJNkxEWjI1eERWNlowNUhjSWl6WmJFYmxOYmxvUi9LbHFm?=
 =?utf-8?B?MEpCZ2NDUDk1NzB3bTlSY0NmdmZEYnVMYzVucE1RaUs0VVZnYXUzZGpsK3Nr?=
 =?utf-8?B?amdFeC9qR2crb01HeVY4cjBlT09VWm1DbFR1ZlkrVzllYjI4TXg3Vi95Rk9o?=
 =?utf-8?B?WEgzQWEwTHhjT3h2Z1IxM3pEalZQVEZncnVabFplUjZ0R0dzSmk1Umptdksz?=
 =?utf-8?B?eWZrUzVQVjJEbW9LTG9OK092ZHczK2ltTlBPYmVGelJTL1RRdGt4L2p5SENt?=
 =?utf-8?B?YXBLbC9vemZyOXJBbTl2dG93NGlmL29iMittUGxrSVpuenJ1Unp4aE9CZ3RT?=
 =?utf-8?B?V3dMQlRLc3MwNWRIMXVKamV0SGNGL1pXcVpmaWc4QXJXenE1ajA1UkRYS3Fx?=
 =?utf-8?B?R21BTDhUVDcrTjUxZkxNYWJDK2lpYytvRUdLN3FvL05sRkFxczl5VGxJMlgv?=
 =?utf-8?B?V3lueWU1WkNXOHlzOFc3d1hYVDAyS3I4SUtlOWVKZmV1SEE0QnFCeWVnNE5L?=
 =?utf-8?B?S0VpMWZaL0FvUW1WWHZzWWJDZy8rVmQ4a1A3NGRCc21ReUUwL1RoYllwenV1?=
 =?utf-8?B?WWNrTURJMEcwVzZQRmpnbysyanBZWVBSeGVVamtnaG9RckpVQllqUTFCOFRs?=
 =?utf-8?B?ZnhRR1BTcmhSMFN6Qkk2YmwvbkM0eTZ3ZUJSVUEyOXp2ZHRlWm5VVmNaeS83?=
 =?utf-8?B?RWlYMHBoTEtjTXNScmdsdXJnSWNMYXdPSWNSK1pkUFBvL21adTliOGRJeEE4?=
 =?utf-8?B?VHY1WXh6WWFHZDZvSEhETFlOM2VrczdVTVJmU2JTRCt2c0Z5VVlNZjI0clNY?=
 =?utf-8?B?bFluaXVPaWJTZWxwMXhlLzYxUjRNOGRVcVJILzY0SjRTQm5ReHdGL1c2RGxR?=
 =?utf-8?B?MjBGTFIwVDFUdzNVcytobWNqbTQ0S1ZGaEFYajhvWm94M3lScVhjekQySEtZ?=
 =?utf-8?B?dFN6YkhQZk9QQTFncHAzRTBoQTBWLytpVmxyUGxNYlV5U3o2QTRVcVpWRG9i?=
 =?utf-8?B?cVF1bGdXcmJ4WDZxTzdxSnVaUm9mQVVRSE0vQ25YK0xnTWpMK2FZcUdvZW9K?=
 =?utf-8?B?VlJWZnlhNW1xT1RVUzZTV1FlYWhnU0tLY01za0Jmb0NJajhMRUpSTk41OSt0?=
 =?utf-8?B?dThGTTZSTkc2WjdXampVb2pxWDJZWGh3N3NVZXB6Um14aVFKUk5yUENvKzhk?=
 =?utf-8?B?MXFET3JTVEFpQTJJVjgyS1g2bTdkblNhOFVEMHRLMzJBbkI2L0xSMnNWMGdo?=
 =?utf-8?Q?KlLycf+1FFM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjN4QUllTlFRUVBaOGgxL2VQU0h1bXVqRkVpRmtTbENYNzcvbm5zY0dFeU9n?=
 =?utf-8?B?QUsrSzFNTVI0WHlFRGN0ZkpvN1hkd1hERGhnOFRuRWFOeVUyNXBhVUxLSVlP?=
 =?utf-8?B?RTg2SzQrc1hHM3FyVFNRYzlCaXQrVTZPb1p6d2dTejVKSGx0SWNESGU5ZDZ3?=
 =?utf-8?B?TUQwbFExdlZ6TmVtb2s0Nks5elp1MHFJZjQ2c2RwSDRMSEtvbXRpeTdCV2NW?=
 =?utf-8?B?VURUaEFMRHAzdVQyRjhLS09yVWVyZmpPSHVGQld3RktvdlROTlFwdEF2M0xI?=
 =?utf-8?B?Ui9TUFBrYXMza2h4QzQ3WG9Qa2xUd2lrMjY4dFM2amJTUHRtVVNMREJVNVVV?=
 =?utf-8?B?aVZVTU9wT25vQnV2UTRkS1ZnR01BRHdpSWErUzExaXVONVhqcGdZTDhuU0Ur?=
 =?utf-8?B?aHJsM284SUw4a0d4VG5kb0VvZFZlcnErWi9YYlczYlNjTzVTWVNRV3dMamlT?=
 =?utf-8?B?QzJaVndXdHpoV0FGOWdrZFBDYUFUZzVXd2lwWjdWN2hCQ2VSU0VwYUEzTkpJ?=
 =?utf-8?B?R3dpZ09ITVBSTjZsaU1UZUZWUTYxOFlwSSt0WFBUTldybCtQUGdRRUJRZXE3?=
 =?utf-8?B?cmpHUFB3UGNrdnJkdnN4bGpqZTJBWEpFbEpFdHc5WTUvVVBwMmtpQ25nOCtp?=
 =?utf-8?B?N3ZGRnMramlIdm81cVZtTTdJNCtoNTJKRkN1UlJqZDk4cXl3cXlYMlVhZXF0?=
 =?utf-8?B?bzRvTGV4cHgvaW9HeGo0K1l3cTNydnMxNHA5L2k5eFdVemU3bDRLaUFOdEpk?=
 =?utf-8?B?cDZoYTdpdjUyV3NKb0crKzFDRVFyaVErTVVoVElJdlF3dVZmQVlNdTBib01w?=
 =?utf-8?B?TE1RaEhiRTRjSFo5VUJLd0JBMnpaWUwrYVJ2TE1lRzVZRDZ5TWpaVnoxdkJS?=
 =?utf-8?B?YXdKemhZa0VPQVJMRWtaUnUzb0phbVFEVjBlWDk4Z0pZZG5QUzZuSnltRjRU?=
 =?utf-8?B?NTVEMFAvWXhtVjJNVDhiMVlsT1cvalhtelpGdHFqZ2Q4bHRQNVRJSlFOamJo?=
 =?utf-8?B?NHhqdHJDVTd5bHVSQ2UvbWFOT1hJVytQUDU5MXVwVjJhQUpsVnBTVEovZHI3?=
 =?utf-8?B?WXJaVGthNE94OGFCTEhhdXlUTm9rcUxWWlBYQnNoUThqdWtDdXlxSk5Kdm1j?=
 =?utf-8?B?eGgveXV4TGE1STVyeU9xN2NIWGxuNkgwbWdqMEVRdy9veExiNzArZ204cDVa?=
 =?utf-8?B?RkJQL2xYRUhKWWZrOU51em9IZitsTmNld2ZiV2g2VUVoOWhZWTVqaWZQdFNt?=
 =?utf-8?B?TkNJRlBXSHhoWHlZbmZpdEFUdWtOLzFLYjVwaGtZYXFJVWthL2taNWRweWll?=
 =?utf-8?B?V0VITThOWEExS2JIYjRYRmZYcmprOUxSZnRTT2RmYjBVYlJPQzlVZ0RjQjMx?=
 =?utf-8?B?NC9nbVREMDZPZ05IRDhteHN5dUpjVlF3Zkw1c0JTVmF6bFUzdU5sYUpzZjB1?=
 =?utf-8?B?ZERRTHRhcERDamRORFYvYWZOZWpnMjBtRThDd1hXS0g1R2RBcW55Ym04L1R6?=
 =?utf-8?B?ZVJNRWdhRTBzYkZoWGJFWmZaSkpjODNIc0J5M2lrOUtkT2hmTGg3Kzc4RlVT?=
 =?utf-8?B?WTdmT0laSlhzS2daTDBxTlBmRjFUTWRHaUVWTUx1amZGUXBZZy9wOHIrM0do?=
 =?utf-8?B?MmI2RlJ4VUUvck9Da1MxTGJvS0xUeEJUVmV6dmdWSXFTZ2l0anphQ3ZwMDd3?=
 =?utf-8?B?ampFOGJKYnlNYmpxcFdwQmptKzNwUVJFYVVqQ1pnZktoeEtXSHFLSU5EVGhR?=
 =?utf-8?B?NVFuUTBreHJneDEzclZkdFV6ZVJHV0UxQ2ZzRUx4WDFvSWZHVlhiOFVPMTI0?=
 =?utf-8?B?QVB4ckJDNGF6MU9vTDJ3eEZNZHJSWmpBV0hnK0VwbU95dVVNbHBjMkRSdUZR?=
 =?utf-8?B?SlplZmsxYXNVRTdiMkt2MHJIRkNIN2s4dmw2bU5wVUlNbEhvT0xxSEN0M0NI?=
 =?utf-8?B?bm1IdGRUNXEwMVNpYmRqa0VOalFXZnAvRDZ4Q3pxeG5SMzNlZEhHSjIzY1Zj?=
 =?utf-8?B?RHhobGcrc0g4VHRtMSs5WFlkMlppOTl5UDByUWZDbFh4UDlvSG0rUGMxNktK?=
 =?utf-8?B?bDlBVkRUSzd2UFdWdEtTcis3V05oVTh3K1NlK042VllldUZRN1cwUlQ2RjhU?=
 =?utf-8?B?eXV6MEFMaW5NYU16eG15TzhJTWVOdG1kdHByYXF5WVVjZlNjbVdNdzZMeUcx?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8656c2b4-b01a-4c93-2934-08dddb7b88da
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:42:58.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIBs8fhf6Vnnfj37Vo3rgQL1GmGGrULc1UDSORPYPSXnsd3BmleWUaUm50ko8XAHGLTAA39rL7PS6toO840ROzgP3GVEaPMBKo1vMoy62+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8988
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> These two guids describe the events supported on Clearwater Forest.

Please let changelog stand on its own and not be a continuation of the
subject.

> 
> The offsets in MMIO space are arranged in groups for each RMID.
> 
> E.g the "energy" counters for guid 0x26696143 are arranged like this:
> 
>         MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
>         MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
>         MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
>         MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
>         ...
>         MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
>         MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY
> 
> Define these events in the file system code and add the events
> to the event_group structures.

Please add a note/link where these values are obtained from.

> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette

