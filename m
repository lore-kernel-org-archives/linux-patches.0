Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D79A936
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 00:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731458436; cv=fail; b=iYDAIEr4SIgM8FMzIrnXfAQVu6ahUJV2hGB1evA0G2urQavOcP/x+QZ9ScwmsJtqQ9Mb/OIRsDqO/7HjbOsO+yYP4BbtdeAcPU85qAHfU965Mdu8X0xPh5opSjAj5n0nT0VjPew41cLxTxp583JwZVWXPQ7+qrCC9OB1XY1kA2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731458436; c=relaxed/simple;
	bh=x+tiVyt7jvdo1mI4hDx35llzEEGJqV2s3/aXmqr2MSg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cigOKZUa4HBars0FUcGq1SzTpEDGFQhnPHiVTn8rMMOg5kdojBUrTYOPf4/uHzZnq8ocauHzWrKXWan8MvVN2Eldy0S46vkRLRxFR33fbD1keF/z7jODYjZYoGSd8nXleGMrp+b68g38QIiPXZIKXbV/kXbNmriWBELkdlF50hU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kB4Fksog; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kB4Fksog"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731458435; x=1762994435;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x+tiVyt7jvdo1mI4hDx35llzEEGJqV2s3/aXmqr2MSg=;
  b=kB4FksogC/WKxNRCaleAeqTEi2I110jvLA2ePzh0Q3AxqSr2T8s8PDvo
   QtUoE30kNvJSTcOmMpx5zHXClckCfjuITxZhqw52wIjKS5eNzB4aUhYsB
   ZfSSthQx/6z1l6EPOui2YxhZmJ6/qz5787qX4FwUx+5F7wHzxNZzViVua
   uGNMJk4p2nZf3XaJyEMiZeDlcT418qrFc/W6YzeBk+oKwedBZ1ZNa24gb
   DdpgK9oQKh+k9YF5jMqISWrwJ3GejqUDfm47BYPlUe+c+4Gf22XKSs2Ar
   rwcZpIYYGiPrkS7hOZ/Fk31RvDNoWm+AdvKsLi6u6EjfCy3hdZ9q+LBAe
   A==;
X-CSE-ConnectionGUID: O56lk3KmSjqymWOnEVHZ8Q==
X-CSE-MsgGUID: zmAKO3ExS1ypmQKdW9js2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31416369"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="31416369"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 16:40:33 -0800
X-CSE-ConnectionGUID: rpeu7/jtTtenaPLHuiiA+A==
X-CSE-MsgGUID: hFw36IR1Rjel1RLsUmFp2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="92652191"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 16:40:33 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 16:40:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 16:40:32 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 16:40:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n7l6A53ooPHRgczKW57Nxh8eIn86ZhFZOUaEyXPOYRNwrt01cOyldMEEvRwFIDsk+OwZ6UOjblK7xTOnGJbRZfF9lhot1Ce/eHERhwr0zHRC3g19jCgLyRst7FZFsu7GNpC3xzrvAB2Rs2dlghLKaufqUBJNGX15V3h+6WXqqiSaxsx0o1bbQ4SVI+wOggHChEFapqoMqqgu1Fa8Yhu6oENQRtka1heWugTKukhPTx/Qd/LrF9Hjju/xhu/xo3bZj/D8ss1YpPLa6RuHZ2MaF+Z9esO7QWEnB27te7/VOPEihD7d/t9rFlGGpSj1q97bhPrphBW+l8zHxuPlrqXBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=invTa5LcpjYAw/Edx0tBupj2PxlVwWeLG86H/W7cjtY=;
 b=EAxZymZUQ+BNsUJ50HHFU8tHzcPy7qBRuYKhZs+v/OwahRH38Pg8lzpw0Fjq/chqqunKEB4OAEJaoKC8EHtVW9tYlMgbglp+YJmd+1XPXWWnS6kBjwNy43RS0rJ/quR4UJvJloaDGoBT9xGBK5Jlt6k3zwRavUWrlAOlvkHZ3WWMpk7e7Qec2JIGK/hMee/oVm+V8XjQqXzLdwyhZAg9yQKGcwXr6AlCLg1q3XmxxPBB7G+6wlWJKu9h6O2UtykWmuTAbgXI35RskfckLH53lXm2U3owDX5q4IPzAjjQD2kl9kxnPNNR8Ttnh4X0Mr6a6/JN7uh2mn07ePThCXR63w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7363.namprd11.prod.outlook.com (2603:10b6:930:86::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 00:40:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 00:40:18 +0000
Message-ID: <4ca1fe26-5166-40cc-ade1-67d76a89ec42@intel.com>
Date: Tue, 12 Nov 2024 16:40:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
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
 <7f5f1f66-df3e-bebd-4786-7fe8a8115f05@intel.com>
 <71eb17c7-acca-412c-bd59-17ee5aa0aa07@intel.com>
 <SJ1PR11MB60839C385657E16FA5B84381FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB60839C385657E16FA5B84381FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0372.namprd04.prod.outlook.com
 (2603:10b6:303:81::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ad190b-a932-46bd-5b3b-08dd037bbf0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L0x1Uzk2clM2OXRjVXlaUGdKTFlLanc1eVpWK09EUmp3QkRDTllCQkZaTzVR?=
 =?utf-8?B?dmRhbjg3UXd0cFVOU0NIYUlVMDBLQnVuRnE5UEFXaWV1WkFHWXRrWk9oMVRj?=
 =?utf-8?B?N0ozalJ5THNNVHdXeW5FQVJzWXJ4VUwyNGFBeE1kZEdmekRkZ2xNaDdsa3lQ?=
 =?utf-8?B?Ymk3MG1PYnVRMDk1dVg4VUtKWlRLSXRPSldnWWUvK0lRSU83N2tqQ3Zsdi9L?=
 =?utf-8?B?c1dQSnZmQ25XT0ZOcWFkV3ozV3RmU2ZjalVTMnNnVGNIR3BjcXQ2cFB0SGlQ?=
 =?utf-8?B?L1ZiYnJCQ3BpK2VqQmZVSlpLNmVBR3dBTldZMlc3dm8xTXdVaVBQZVFyNEE4?=
 =?utf-8?B?V1VYK2RSUDBPWndkUjhFVFJQS1UzcDZ6Wmd0Yko2VmpkWkJWOVhKVm51T0Zo?=
 =?utf-8?B?VTluSDJ0QUJuaUNzZm9meDVuZDhPekoxVXhURGpqUjJWT0VXVTNZNjVjMkE5?=
 =?utf-8?B?c1R3M1lZblJiakNDVldwYjBzVzhteTUrZHN3SFdWa2RRcXErR0s2S2xoS01a?=
 =?utf-8?B?V1ZBVXcxdUlQVzh2c242UWtqb2FsNWxhOVh2ZUozbVJUbDA5UXBLRTlxYU9Q?=
 =?utf-8?B?aWNOWnIxQ1VhdkFGOC9pTFphRjd2YWdIWlBuc3kxeWVXTGV3WWR6aU53aUNm?=
 =?utf-8?B?aklUTVlXZ0hUMXNtYkx2L2IreUJGVTRZNWpiTEpsUTJjNGxBYmpEUE5Jb1JJ?=
 =?utf-8?B?WHVlZ3pRTzRxOHo2WHczT1k4MkVqb2FrT2hUckVBNmFjOHdlVGc2TUZQUmw3?=
 =?utf-8?B?eWJMVVU5aGc0cVlPdXUzL1hCOU1xODk0NXlNZzR3QzZscW52NG5rN2NPTVhn?=
 =?utf-8?B?Q2ZTczVXVXRESWRrN2JVemFQUThWK3hudnpGdy8xUCtrWjhVVUJ3bzRkUmIy?=
 =?utf-8?B?WjFubDZ3TjAxdXI4eGZSaXAzTlJzd1pXeC9FaWxrNk1RUi9CamJCOXN2Zits?=
 =?utf-8?B?ZFE3RWhwL2VXazFGRUtIeXJDa2Y2OHNkUktoc0RaL3NmQlB6VjIwVkQ1dE84?=
 =?utf-8?B?R21mZU1wUmhEM0NOV2pRNC9ldlNwOFQ1UCtBdnArS0ZzY1BUU3grZ1FBOXdX?=
 =?utf-8?B?L2pIMzl1TTlNbk51emptcENkVnQxRHpocGlETDVMdXZneENBMWR0SFpqMEV6?=
 =?utf-8?B?VWRobldtTThYaXh6Wmw1a1FsSlhTbWtuUjN6VFYyVU4zUVpHdzdTTnZPaEpI?=
 =?utf-8?B?THZ1dEpNcEpEeXZybThFcXd0VTQ2SjcxN09lamExaTBZM05MRTQrK3RmdWpr?=
 =?utf-8?B?ZVVCS01iTTFZdzZHQVZqd0pxekxSb1dzZ3Jxb0hXcGltNDRnY2ZFU2U5c0Nj?=
 =?utf-8?B?NkM0QTZzVmdRZ2ZYRnA4aEdyQ0pySEhGNFNKWnZPbzl3TnN2dkRCZ3NyVUkr?=
 =?utf-8?B?K0llaWN6QzlieGEwMVRDdlBrNzhjaVM2dUU4SVhLRGxITkV4MjYvUHpJdzVm?=
 =?utf-8?B?UktxbDVmSWYrck12aGtSRStHVjdnbmYwcTNmaGZ4U0NIVzhNcExzUnpPKzB3?=
 =?utf-8?B?UkpkMk5UVEd5d2xrbC8vUEc1VGRvTCtTeDZkcVpxYnYxMHpSZURMdnpobnJN?=
 =?utf-8?B?bmppQThHcTlHdCtGcHp0L3RyMVNIc0E5a2IxejViL2QrdGdyYmFaUGpDM2FX?=
 =?utf-8?B?L1IwK25BSWlGbFNJMDZlanlCU0s5TzJxMjBrVEJWNlRnckR2YlZTbDFNWmFu?=
 =?utf-8?B?T3c1RFNVQlZGMEtES2FBSG1ROGwxcytSYkJhY0E4WnhrTi9SalZJTlUrRE85?=
 =?utf-8?Q?wUAX1Px5M1dKfo44OJRs7PMQopcY2ljhn52vKT2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHVXYUVEeHE1NW5pM3preDlBVmx6eG1DNVd1RFlSSnVld1I0eTE4QlhkZWdE?=
 =?utf-8?B?Y1h0R0M2QmJHWG9uQnFKQ3puYnpBMEZrZTBtaWF1UDdPT2VhV2lYaThwYWow?=
 =?utf-8?B?N1pYMUhmeUNwSG9YSnBSY0dhODhRcDhpbXN5QjFsL1pKOHRVZXgrb0ZnVjNz?=
 =?utf-8?B?TnAyZ2JvTks3VktTZ0l0S3dMWmJkWkpVcnRRSFJ5NlFhS0psNytnVTJlZ3M5?=
 =?utf-8?B?ek9kWFFhNkZBQi9NcjBpblgvMVVydjI3RVF3QTVCSWdCbmE5RXBVNE94Wmhv?=
 =?utf-8?B?YWw4d012aHBaOXZUb3FQd054aVlrTWtOeFJnQmhoN2dTc25uNmJ5cWN3RVMw?=
 =?utf-8?B?ancyWmtQWndSd1d6SkIwKzlaMHM3d1h0eWZRY0ljZkkyL1JhL1J3clBOYmtZ?=
 =?utf-8?B?alRaRDNVVjRQUC94WVQ3Q3BDWVo2amFGcVgraitwNVZnVnFRaDUvWlF1MXpW?=
 =?utf-8?B?ZDBpRUJCc2RIemVJMEFxb2YwbS9nN1ZGdVFMbDZON2VObldiTitXazJPeWdv?=
 =?utf-8?B?T09kNDVXTktDckQxNG1sUEF2eVAzSTV0SDQzUFZTS053NG9xQWF0QzA3dXZT?=
 =?utf-8?B?a1NxREgwRUJxWmU1VElOYm9iT0VrcDRTMnBxWHJoNU1nUzdvQnNSRmd4ejcr?=
 =?utf-8?B?eVFoTmw5eng3WHVlbU41V05oaWxCUnVRSjBsVlNMbWZybkdObU9VcnczTGZq?=
 =?utf-8?B?UUM5V3ErYjlkMDZLay9PWktVYmZEVEdyUEVKZ3ljMnJLVmJQLzJBMGJTQkYv?=
 =?utf-8?B?WFNHTGUzc0VJdDRmTDBoRmlMYzUrSFkra21yb3BPQjUrbE15NVJHRXFHMlV4?=
 =?utf-8?B?VTFwYjhsTXBxOGExSnF4cmxRK0ZmUWkzQlZ6Uk5MTlFuQzZiSy9GTjh2RzZE?=
 =?utf-8?B?TUhRMWhMTVpjQWpzUHpOWUFEaTJMdi9UK1NscCtGVDdGYTRFZ0p6R2RMSjc5?=
 =?utf-8?B?SG8rWkluNW45QmV6OTNiSnZPQjFwNjBrc1drcGNrRnZxUEl3Y1QxcTN2RXh1?=
 =?utf-8?B?dkdyNG84ZEtwVDA1enlTS3hUV3BqYjJ6OFU1VEpEcGd1a0NUelE1cWRyRlRS?=
 =?utf-8?B?emg3anpOa3dBaFE5NjJ0Ukk2MFdudjZqZW9sRzgzUFBWdGpuUEs1UTdxNUVG?=
 =?utf-8?B?cWMyMHBCRHYyOVVycVEvNG04UDVXbVJla240UnJFM1JZVEdJYW9rRHFSM0JZ?=
 =?utf-8?B?d1l4MHd2MWpPcDNwb214L1M0ejZkVU0wb0doVTcwcXhjYVhvTUsyTXpONytK?=
 =?utf-8?B?OFMrMU1lKy9sRjd1N2o2b1BwRTlBM29tUkdxVlhINFVDZFZ3bHRhU2U4YjhO?=
 =?utf-8?B?TkM2aGx6aGVSaUUrazgzcDZyOFNzR3NrTC9abUQ3S0ZOamVTT3hrbi9jeEU4?=
 =?utf-8?B?bUw0UFQ4TS9kTTZ1YndmcmVXNUhNS0J3M28rL2tIblhoN0MrdXRQa3ZRcWx3?=
 =?utf-8?B?WFozaUpRSGI0VGE1RnF1a3FWWGJqWHJYNG80MHArZ0VVcnAyVm5hcFdIbE1w?=
 =?utf-8?B?bm9VMGlnWitoTjRXR1MvdXlZWEFodjRlY09ydDJ2SWlxTmpyUGNUYVJ4MW9m?=
 =?utf-8?B?YTc0dHNvM202M0czYnRQTmRreCtScENLM0phV1pReWJySEErU01zZlVVc2xQ?=
 =?utf-8?B?ZGJueUkvT25NN2I4WWc4R3BnVVVzMVlhejlNeFVNMitueWdaUXBSV2dVQVRH?=
 =?utf-8?B?M0NMZDdxY0hDbnFpdVE2ZmFtb2pFWi81Z1ZjRmNEREVKTzBQRjJXZ3dOTVhw?=
 =?utf-8?B?WGZmRWZCRXczS3ozV29BQmFTa2xtSVpOTFRoTDZyblJPME0ydFJQRVRkcFk5?=
 =?utf-8?B?WnNDOVdxejdhOXJmbGtOR1VDeGh2bTRnb2huS2QwaVpjWkxWOVEyKzVxOXJj?=
 =?utf-8?B?MGxYTXY4WVFsMFVFM2NJb0x2MHpCY1h0a2RoeGkxblNtanQvOWh2dDYwWkFV?=
 =?utf-8?B?bGhiTDRTNGkwOEtjRG0xUDhESjdKaGUvaWxkVysyM1FTYktoSm85cWhCMzFT?=
 =?utf-8?B?OWlCVGhxOEI3R3dpL0tqMTZ2NHNoR0dKQ2Q1UWFESVgxMUZjb2wvUWt1YWR1?=
 =?utf-8?B?ZHR0WS92a2lNY2xySmNIWURZZGk2NVpnVENRa0ZJaE9RblZmTTVoNE4wNzdF?=
 =?utf-8?B?Q3JPb3djUG5FRHhmSk1KZlkyblhDQTAzeVN4R0F4Z3VWMkpWZ1pmdGZUVUpr?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ad190b-a932-46bd-5b3b-08dd037bbf0c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 00:40:17.9232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYZswE4sYBcYn6BX+Ne5tVmX28ceLV1RYPgvH+DXzU1FRBANNBHMHeCxgOAuCKulfud8ig670zk/Vb9AXGXH4Q6t9f5LPxZ9Xp0+HzOF0qA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7363
X-OriginatorOrg: intel.com

Hi Tony,

On 11/12/24 3:57 PM, Luck, Tony wrote:
>>>>>> +   if (!strcmp(buf, "mbm_local_bytes")) {
>>>>>> +           if (is_mbm_local_enabled())
>>>>>> +                   rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
>>>>>> +           else
>>>>>> +                   ret = -ENXIO;
>>>>>> +   } else if (!strcmp(buf, "mbm_total_bytes")) {
>>>>>> +           if (is_mbm_total_enabled())
>>>>>> +                   rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
>>>>>
>>>>>
>>>>> User may think each time toggling the local/total event will effect MBA.
>>>>> And they may create usage case like frequently changing the events to
>>>>> maintain/adjust both total and local within bw boundary.
>>>>>
>>>>> But toggling mba_mbps_event faster than 1sec doesn't have any effect on
>>>>> MBA SC because MBA SC is called every one second.
>>>>>
>>>>> Maybe need to add a ratelimit of 1 second on calling this function? And
>>>>> adding info in the document that toggling speed should be slower than 1
>>>>> second?
>>>>
>>>> The limit would need to be per ctrl_mon group, not on calls to this function.
>>>> It's perfectly ok to switch multiple groups in a short interval.
>>>
>>> Agree.
>>>
>>>>
>>>> I'm not sure how to rate limit here. I could add a delay so that the write()
>>>> call blocks until enough time passes before making the change. But
>>>> what should I do if a user submits more writes to the file? Queue them
>>>> all and apply at one second intervals?
>>>
>>> Maybe define "mba_mbps_last_time" in rdtgroup. Then
>>>
>>> if (time_before(jiffies, rdtgrp->mba_mbps_last_time + HZ) {
>>>     rdt_last_cmd_printf("Too fast (>1/s) mba_MBps event change)\n");
>>>         rdtgroup_kn_unlock(of->kn);
>>>     return -EAGAIN;
>>> }
>>> rdtgrp->mba_mbps_last_time = jiffies;
>>
>> This seems like enforcing an unnecessary limitation. For example, this would mean
>> that user space needs to wait for a second to undo a change to the monitoring event
>> in case there was a mistake. This seems like an unnecessary restriction to me.
>>
>> I am also afraid that there may be some corner cases where a write to the file and
>> the actual run of the overflow handler  (on every domain) may not be exactly HZ apart.
>>
>> Bandwidth allocation remains to be adjusted in either direction with at most the bandwidth
>> granularity. A user attempting to toggle bandwidth event cannot expecting large
>> changes in allocated bandwidth even if the events differ significantly.
>>
>> Surely we can explore more if we learn about a specific use case.
> 
> Note that the kernel generally doesn't prevent the user from doing inane things
> that do not cause damage.  E.g. a user can already abuse the legacy memory
> percentage bandwidth controls with
> 
> while :
> do
> 	echo "MB:0=100;1=10" > schemata
> 	sleep 0.1
> 	echo "MB:0=10;1=100" > schemata
> 	sleep 0.1
> done
> 
> Similar abuse of the percentage mode is also possible.

Good point.

At least with the percentage modes the MBA allocation is promptly written to
hardware.

Related to issue at hand the user is also already able to quickly switch the MBps
value via quick successive writes to the schemata and those changes are already
invisible to the software controller that only consumes user's MBps once per second.

>>>> Maybe it would be better to just to add some additional text to the
>>>> documentation pointing out that resctrl only checks bandwidth once
>>>> per second to make throttling adjustments. So changes to the event
>>>> will only have effect after some seconds have passed?
>>>
>>>
>>> Add additional text would be great.
>>
>>
>> Agreed.
> 
> We hadn't previously documented the rate at which mba_sc measured and adjusted
> the memory bandwidth allocation controls. Once per second is currently an implementation
> detail that in theory could be changed in the future.
> 
> I'm reluctant to carve that value into the stone of resctrl.rst, But without a specific
> value "don't change the values too rapidly" is meaningless.

I agree that one second should not be part of documentation, a higher level generic "interval"
can be used instead. But ... since you pointed out that writing to schemata also has this
caveat any documentation should ideally address that also. With existing documentation seemingly
sufficient in that regard I'll also be ok with keeping it as high level with this new event
support.

Reinette

