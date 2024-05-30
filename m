Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41930183991
	for <patches@lists.linux.dev>; Thu, 30 May 2024 23:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717110613; cv=fail; b=CoC/POhvYscW9wqKpY+CasqRJcI6a2zopfoasjqmVKMaAeUXb9wxSQ6IkO40+YegFCqNPiiS2KIJHd6oplHkdhV5ORR4BdUW/o4yc02Lyu8tI2bBqvWWzUYhOtJayQuBYEoAbDVf38W+YmGPFrXlfRAa7wk9tfsz8tE1z9V9BWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717110613; c=relaxed/simple;
	bh=wudzwiPhAGpNQmvY2/r/WPQjs55qa3uWo/YJ+u3hoPo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DOnAPotYM5ZyFE+MmDQDI7UoYrLYRjjNv3rvbRKdhkTTUaBqFcOG1mHuZLXnuINMDivG9lAsfoSoKboV4qrG5N/6TkKhoYXXoXHf3BHnlVjupknbDan/KFwEO1pnkq/RDa3fvS3Pb8LXz/BJhBJynLmI+kpgkwKCpboC9vi6Jdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dy3J5/Jq; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dy3J5/Jq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717110612; x=1748646612;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wudzwiPhAGpNQmvY2/r/WPQjs55qa3uWo/YJ+u3hoPo=;
  b=Dy3J5/JqVX1VZlLmk41CPuTPU7hYQTzn9jN9ZIUv1RMBP+DcU9nkDxw/
   OyLys/uF3MVBVsdBNXRFIq/iKwjZbHeBz1+YzAOVlge+et3OKAqE0g8jp
   9/QbPrDPHtE9VEYDEWHs9WiQRP0+XhUHehDuTDbmOiBeuHfcycjKpjuAG
   I2eMm/lT5mebUS8N9CNtKIDC8q2IUXY2wSbGfIPPrHm3NmwBRwX145Amj
   pzQqUX4KyxOUiYO4yV1A6abD9oUrK1yMnzqvGo+zzsRyIWqE+xEEvywfn
   WW5jRyptnbP3f8zjEDFak8Oz8Ai7MhxbQdKaIRAQJK7U9sTE/e8w+q4qd
   Q==;
X-CSE-ConnectionGUID: rLhVI632Sz2k7HxMzHyHYQ==
X-CSE-MsgGUID: 3To4M5tURLWDh8sL66NAHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="16584335"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="16584335"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 16:10:10 -0700
X-CSE-ConnectionGUID: OAZN/tlwRVuEGMXpToCk3A==
X-CSE-MsgGUID: P/O0MHN+QNetOBrJ2MLQ1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35905847"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 16:10:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 16:10:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 16:10:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 16:10:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 16:10:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3W5rzVxKoQ72SULJqbZv6VBbK1Z1M4EC9wfmKZI9WVQCw7SYWQ4fAecgIoaVGp6X4NxYqHLmGJhVYOYIFyk/DPuEvYPBq05MWCROY8KQDGCftzfM79X6VWbbOWs8Vc9oXAlax6aaA7NFdAT7eXa3MBDeOHgrgaujxGMFyCwBXr7OXTU3cu0fOwQOdnv69DSXZM+GObyRJg6oAFlW4jgYdtOAFEmrelEy+VD/uEAKJkF6cJrsInRArje0Kdpoe2gWQHrWaiiXejBbriSglfhfkeK9esGuRa+8FBSOMkyqg5aP0Yg+r65pBPusDC7MLOolkAIIlB1ZRaH0Z9leSoG9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xE1IF8QPwcMBU4k7YVNhSSzFWJShbOkzNsli0u7wPWU=;
 b=bcMq/jUsjGZpRLbGFBJ2cRrh4N/q7Xga6NjGO23lfY+laqP1FYyttIrnVmXMIW9fuxvft1eL6+okYvwAXAUQg8ffJ9DMIdZSUSVUWXZ8kjyJkXhQhjBN94FPP3/Dh08zCtS0884GYy6/Nx8SevgwUTwiOxpdXPzcO+4/r6ErMAbOuobd36QaBoavo+q2ETLL9wCAG4c7H4I4wrX3FOm2RT5dKuuumo1jj/SW16Qf7Ek5k1ULEj5CPSV9pY+X23lcKhtnuXsZXu/mNScwm02hIcLaNnNTuzwX5ZdTzNJlemSzUixlbIhZUykg+KhMqU1v+3zEH88UC+11ilnbbzNytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4981.namprd11.prod.outlook.com (2603:10b6:510:39::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 23:10:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 23:10:07 +0000
Message-ID: <9a72eaf6-d750-4898-be75-6c27512750b1@intel.com>
Date: Thu, 30 May 2024 16:10:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 00/20] Add support for Sub-NUMA cluster (SNC) systems
To: "Luck, Tony" <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <08ca8fe7-9da6-41da-aad2-0081b789326c@intel.com>
 <ZleODtL_6D-Q_OMX@agluck-desk3.sc.intel.com>
 <a4d37f57-328f-4456-92bc-5e6469d092c8@intel.com>
 <ZlirIUbLw8fLHe0j@agluck-desk3.sc.intel.com>
 <2a761266-e934-4740-bf15-95dbfe4e4d5d@intel.com>
 <SJ1PR11MB60836D413A87A0351ABD90A2FCF32@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB60836D413A87A0351ABD90A2FCF32@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:303:b4::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4981:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a5fba92-fd31-4322-dda7-08dc80fda588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VXpnZjJ2bG4vU1F6Y283SzZ1dzNJbzBOMjI4UWE0MFg2aWQ1Rm5wcTJ4RmlM?=
 =?utf-8?B?RjMzazdCK3lwSThuZWllSzBMRVVZaWdwSitvOWM1ZWdXeDZYZkJ0cS9CNS9U?=
 =?utf-8?B?Y0laMWtTaVhwZGd1LzlsdzNDaW1nY0ZhaUdON0JMOWdDMHEyUVVlQkpFb3pX?=
 =?utf-8?B?OFg5N01mQkg5cGk3QUJaazZhU2RPSmFaVW1SL1NnZC9Oc0IxZHdpWmNod0V2?=
 =?utf-8?B?RzkrMnZKSHU1blBWSjl2YVU4VElOYlE1NEw5RlNhZzBZU1RsR0g1ZXcwYlhZ?=
 =?utf-8?B?ekJiVEc5cVlTWEgrV2ViSE9VVmliRU45MjlyQXd4WGEwcnJMeVRtU0lmSDl0?=
 =?utf-8?B?Z3Y1ajhNL2wyeXBYeWZPMXlEcEhCNzNjUVVZWXFDdjFmQXJCSFoyWDlKSkhD?=
 =?utf-8?B?M3NKQ0hxYnh0b0Q4Y0pVVGlzTUpZdjhIZzRBVndORHYwWjVyam5PQUN1SFBn?=
 =?utf-8?B?em9xbWllejZOV0w5VkVEcWNDRW40L3lJVTZoazBEaEZWSVNFdWd0eUpLTlIv?=
 =?utf-8?B?ZXBlVHhmT2MxQjRaVGJIalNRTVZmR1ZuQmppMHZpYXEyRk5jUDBpTUhiZmpZ?=
 =?utf-8?B?YUV1WGZQTVFMbTJQREM3NTVsNU5DT29BaXAzcTB5bkZMNHBHZjNuUHA0cUMv?=
 =?utf-8?B?dnhzSnJNLzBmWU1mSVU0OFNQdkd3N2ttUjJnODNGeSttWklHVHFSdGV2NUNy?=
 =?utf-8?B?SUNhUCsvU3RqTitZM0hnNjY5UnRCb0FuSlQzMzhPSG5LL0ZYbFVKMWIweWdL?=
 =?utf-8?B?RmQ2YUE2bzBtVUNHeFR2c0gxZlJLditwN1dZMXJvVzBac1RmOXpVZndpMWc5?=
 =?utf-8?B?TzQ1QWhCV3VIcFFwazkyRDlZY2cwUEM5dXBOclEwMHoycUQ1VDhzOTlma1ZP?=
 =?utf-8?B?clpLb2U1Y0diSXY0T05zdzgrSG15Z2FKSUZ4encvYXlLMTFBcGJpVC8xMmdF?=
 =?utf-8?B?SzRTcHpYMUJYUkNoUWQ5d0pzaE9aZVFpKzlCRi9Ybi9jV253dXhQS0o0VVpO?=
 =?utf-8?B?OFVwblRxeFhyL0NXSXc2Y0U5aThWYmJPanlDbEFSSWJZT3ZOL25vTE1sL2FT?=
 =?utf-8?B?bm9aN1JteHlhSkVTc0JIZ0xMbk1LVFdNazNxYU54Q1VDMmExZVRqYlNmeVlG?=
 =?utf-8?B?WUZFSXQyNGI5Q3UxSnZRcGd0L0krQVNhN3RHWlRvYjhDdDZzeXJZTlRIZkdj?=
 =?utf-8?B?NnJoUTBBZy9WVlI3NVlrZEFwZVNmalgvTXVrOHFCdFNiOXRtNUxocWQ1Q0w1?=
 =?utf-8?B?eGJzYmZlcWxNWnRTN3poRE1KbWQ3cldUNFBnY0UzZVJGT2l1V1hsZXdobkM0?=
 =?utf-8?B?azNqUllhTEJWazQrYzhtR1hvV2tSSVRYZStNSEc2Y1ArSmFKVWcwZ3hESjU5?=
 =?utf-8?B?ZjZ6aXhvTzM5bkhnWWIwYld1TWc1OThPcEQ2MkpicnhSS0dCU2gyVy9QNTdN?=
 =?utf-8?B?NDg5MEpEQzJwOGtmeG0xSzk1ZHhOR01xY2MyUnIrdnl3L2dBUVdLTXZ3elox?=
 =?utf-8?B?aXJvM2FZZzRMUnJydklWQS9wbFlsMnhmODcrSHRnbkpMRzRnNUhPWWljKzFx?=
 =?utf-8?B?eWYrWjkzTERwcVd1Y2dSWXM2M29NVlRGSW9IWTVGL3drWC82ZnRQWmJ3cHpJ?=
 =?utf-8?B?dzFGK1VMRnFJN21KZEh1MlVjcklIZ3BkOWdPcC9IV1BKUEQ0YXJsekRvZ3NO?=
 =?utf-8?B?dFYyK1ZCSVYvMlIyb3Z5djZSY01JVWV0TWlGYWFYbWR6YzhYT3JJWktnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHY4SVBRRlRKUmNkZWVrNnpkRHNMc1hKZzJwd3c3RzVHc1dEVitRdzk5K01o?=
 =?utf-8?B?UDhMT3QzV2xIeFNLcTJpTnY4ZlJ6VXduQXJ6S1Fyb2VPYlBuOWdySi9yVlFx?=
 =?utf-8?B?a2RMY213cm9rOEhHK0huMSt1SUJUVCtvNElUVHBhL0dlZXlEZW5YS1E2dEww?=
 =?utf-8?B?SENzY0hST2ozTmpCNGxLMkZST2Q2c2RzOUI1amdXek5hS01BMzdEVHppaWho?=
 =?utf-8?B?SC96K3lraFBGV2NRV2JyT0NKM3lPeFlCN2dWZHRWTTZ6UW5TeWtXdllUUTJY?=
 =?utf-8?B?N052SjI0MmFEV2xUeGhUalBENVhJdFloUUw5eEtibVRlWXhtTS9tUktnbi8v?=
 =?utf-8?B?bXZWOWdWLzJ1aGk4ck9qS0krWmJRaXAwd0R2MGphcXpuUzBMNFB0Z2p1QS93?=
 =?utf-8?B?MVFURldNcWpnT0tOcWJ1RXFYUkZWbTBQM1JwT0t5OGticXBLTnA2NDJycFNk?=
 =?utf-8?B?Zno1N1BnZzFwWGtIbks5L2VWNU9LVmJCcWI1Z0ZMSkI4RjN3ZWtlRUhoKzFi?=
 =?utf-8?B?bnBtTVVscmVlMlpDdWlWRGpINEE5Y0N5SDBOZ3JiaXRhS1Q4Q1VMc2JUdk1L?=
 =?utf-8?B?OVRTZDIxT09OazZLemJ0dlQrcWh6NUI3SjRKd2o5WWZ0RjUya3FRRTdQbkxk?=
 =?utf-8?B?ZXBMTUtaWHcyVjZ4dGprOWJMMGU5dGRndFAwT05rTlduV0lLeG1pMWQ5TDY5?=
 =?utf-8?B?YlhJSDduY3A4SmF2UVpGUlZMcTl4dTA1SDlQQWlaSlMydVo5VExxOTJlVnFk?=
 =?utf-8?B?aE5ldGppM0IvcGxwZWNFUmtPazZJTkhheEFqam1GNk5vMkNocmF3dWxRdURh?=
 =?utf-8?B?b08xTzhBZ0kxaGF3ZFk4cWNweEdtVTdZQW1lcUFUakZpUlMwWDFJeDJNWC94?=
 =?utf-8?B?Q2xEblNNS2I0SGY1OVYrTUl5eXQ1RjNxTUxBT0ticmxXOWJzTEZKeTljS0tw?=
 =?utf-8?B?aXFtQmpiK3p5MEtsWFNxL2FVaUdDK1JGUm5waVRsWDhQdHBRVzVwbWxaOU1S?=
 =?utf-8?B?MjAwK1Zab1E1VTJReDJmTlI5WUlEU3B5U3diaTNkY3QweUJUL1NQZlpZRnVh?=
 =?utf-8?B?T1lPLzFnMGhXcXVpOW10TllncU00cS92bnVjNWlwYzExakFGVmNtUTVKemsr?=
 =?utf-8?B?czhaM1h2U0xyb0NyVDNCV2NsSTJkN29MSC9QV280V2J2d1dtZ1IyalNHTzc4?=
 =?utf-8?B?bGxJMjR3MVFmandhYlNVcGlGTE1OSFhLbTN0akdUZk44OHhWTU5jenlhMWF0?=
 =?utf-8?B?dEJid3QzR0tRcGV2NU9tWG1Rc0NGeGdVQkVhcnhYNUlHZytlb0VtVE1jWGJ1?=
 =?utf-8?B?bUZwWjQvMWRXS1JWeTVEQ21tdk5sWHB0MTN6R0wzaU4vcTlpUUd5V0JObm1G?=
 =?utf-8?B?SU5wa2F1eGtxcDFNVkNTdEd4UTdWM2FVSlVwYmNnSkpxOWovNjNQVE0yZ3kv?=
 =?utf-8?B?dCtOVzNYV045dE1Hc0QxN0Z3aUFNY2tYRVNKTVY5S0dtL3pDN2RiRm1oUXZX?=
 =?utf-8?B?eVprYkFxRFBsTEhBNE1MY0dqUzIwc1BOdTBHa3YrbmJLQ2UxOG10V2NNcTBD?=
 =?utf-8?B?emd0cDhWTEV3dnl2R0UxMUZQU2Q2T0RrRGJSNFhQY0NDT25aNDROVDhvUjNp?=
 =?utf-8?B?YnVEZVNoNXhSZlZMbFpDZFJUMFZIa2x2Y01rTkdLdytNT1BXR0NBK3Z2eEFG?=
 =?utf-8?B?ZjBBdnpOaHFpZzlmeTQ0ZC9oOWdNdFJSWVJWNVRqaWZJS1JjVEtUUkdWc1BZ?=
 =?utf-8?B?UDRTTVh4OVNIVnVvNUpJK0dmemxKQ04wa3lFQ3M4R1MxL1lhTVhYbkhnakRm?=
 =?utf-8?B?NEJ6SDFLa2JrVkV0ZUJqWVBqZU1UN2d5VjBIZVdZdjVnQ3lYc2xpWkJlb3Ra?=
 =?utf-8?B?cHlobERic1VVaWhiSTR4WjQxSWFmamxDVmNQQTJyb04zaDlnYW1FTStoZUNs?=
 =?utf-8?B?MlM0aS9kblRiRVByUjNoUzZzVzBmUk9nWTY4NmpseER0NTdLOWc0SkhkZkhP?=
 =?utf-8?B?NTRjUFE5VWIzRCt4bVZ2SThQejY2SVY2dExYUElEaTBGcTdiS3RvMHhaUHRI?=
 =?utf-8?B?Q2piVTRvQVVYQUlnK3hCOUtiZ1dsdDJUSXpHb250UCtZSm5GMDh1cGlXSGc3?=
 =?utf-8?B?RFBJZGZqY1dOb3VkS3BQalh3R2hJNy9uNzR1L3BnZHhEZXFjYnRUaG54U2VS?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5fba92-fd31-4322-dda7-08dc80fda588
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 23:10:07.3033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fpNMA5DSe7XbqfQtErFr5xkOZE4fqs8wsrWd5C2lKHKGsK5GzQpkLQC2bf00nOK6qGoF16NFMQuJUUphR7Xc/IKfW2NwBJXDHZ8uyaiwhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4981
X-OriginatorOrg: intel.com

Hi Tony,

On 5/30/24 3:49 PM, Luck, Tony wrote:
>> btw ... the static checker I ran did have four other complaints, three about
>> uninitialized data and one about divide by zero. Most problems appear to be
>> in mbm_update() that does not initialize rr.sumdomains nor rr.ci before
>> calling __mon_event_count().
>>
>> Please use available tools to check code before posting.
> 
> Which static checker?  I tried smatch and it only finds one:

I used coverity this time.

Reinette
