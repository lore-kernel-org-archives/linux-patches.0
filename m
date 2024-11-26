Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4AC1D63E8
	for <patches@lists.linux.dev>; Tue, 26 Nov 2024 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646228; cv=fail; b=Zprg7bXXXpZu9JGNAI+tHo2UK+t+jKCk6Wz/XU0uDI5pN5szN+pi+uT+MEXtEWk2my80qEXAUjx36Y+31YP0bb5XzwC5ITuDWH2FSGDKICsk4D7yUOJDK39v1XVplYx36CZFVhkD4L9qaHSlFJd0pYADyyomZWIcRBiprg+CTEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646228; c=relaxed/simple;
	bh=NtMBUVkrpOunpDuPOdWBUAJzONuo60GSNh2kIrRva+A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rvos243uoR0fv17S+fD9zr6tojnc93RJvI3zOTMH94s+S71W6rzxdYdRjTEH80FTw8jT01CkEABOjBUUczm2z7S7LeMfIOfS9GSyfEgancOmXI/nlxDgFDmW9GXSJWKeqBPPs7eex+meSEPGPKIBtov0DMk5fgzjpmDu2Jo+KyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AJBHzaD6; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AJBHzaD6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732646227; x=1764182227;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NtMBUVkrpOunpDuPOdWBUAJzONuo60GSNh2kIrRva+A=;
  b=AJBHzaD6Ogqd0wE/caf0b/HBVv9QpXQItAC+fl52uwQ6JiyEezrh2udt
   zwSXrURFAvKcMXcxEHdUBGMXjlK1kR+TzjFcvxQ5UQvzJFB0BHKytq2mU
   6jci+qO5u/E4zOME3nAEde+H6rQs91UfoaSZKYjiBOf9P5c9D0nc7H54C
   8GTNqiNLHb1xOqsocgFNZYkgYMKcH6s2GUzJgt173gY3fuEK6MsEJ5fx+
   Fz/rqfhtoXmNAdEdRV6YSbc1A0Xk103q9CJaCZOHUlYsEKaq7fopDIAOC
   6Qwy4tnisIijrtgk5KMgRd72fXWYWVbDI23ydAbuQWNwgSIPEd+jil2zv
   g==;
X-CSE-ConnectionGUID: DJtGgfY4RR62AulZ7+v0Lw==
X-CSE-MsgGUID: d6VR7LU6TNOidbSs2aeBaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="32972011"
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="32972011"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 10:37:07 -0800
X-CSE-ConnectionGUID: +hZirDpMRMWat/rAa8i6rw==
X-CSE-MsgGUID: kGRWXp6RRlOiwPyQ6+lZ0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="96129711"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 10:37:06 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 10:37:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 10:37:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 10:37:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rTlY/UYwhpEVwutY/xrAyjhYU1MnW0ifD2fwSrVbWqMGNhJWtu5zAe5GpFmSMso3XtifyICoxhJyPHEGfL49ixWrQaZ4i+Vp5P+zPGWPcRJqmSLcGEReneM2DHc/G8BMMAbpF/sfwu+KSIr7u3wD4TrYK8XewWKIm6ITz/hwhzbZey9/k//nyVuZByAQweMbYY31Pt06AIRHiIhfUMM7omO1sCb/1SYNabbWDLIL1QCJRInoWKr0EJZAOHg8IJNsruDhiRChVxU7eFvNsBUqUugDsXUQTJ2va7tPX303NuQXpsAluroXkowHrw/sHCJZTTl6vRK8cp1Ulnyz/wtNig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuiAd4CWiGJVf6SFmWYMSqg9+CvtKRlaO4+azYBNC/8=;
 b=sx+ioQ2vCpBhms9evLOsosDMFmvB20h6PXTG/ZHZ/DAclWQU2fjNJoAtQi+WyUcDJHqxp6ei9rvJCwXrJC7SyBreW1kb6QqIuAwwXvArRrNjXMCFjc5cYz7Alrso0iB09PWKxtpEvqaHl8j2X3Z5VuvFA6fRmlMMMYs5icu71ymPx3gPL5Zqwa/0uX9QEM9DP533VdkitfDHjXOGkt1DzkGSO7TKBvWOqe0fE0zc1NDOWKRePi3x+/uQFMbpZl9gziFIEwvn4t1R0+ls+CR1n/od9ACWbRR7dnScPffcSOHcnM69AnSZBG04XYoCoYXPJiYCuTGsrGyTeAxDsztEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Tue, 26 Nov
 2024 18:37:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 18:37:03 +0000
Message-ID: <b3c59250-d648-4898-b632-fe7441f8bf90@intel.com>
Date: Tue, 26 Nov 2024 10:37:01 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 5/8] x86/resctrl: Make mba_sc use total bandwidth if
 local is not supported
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241122235832.27498-1-tony.luck@intel.com>
 <20241122235832.27498-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241122235832.27498-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0063.namprd03.prod.outlook.com
 (2603:10b6:303:b6::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f5d6ba9-bb61-4530-2e65-08dd0e49524e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YUJ5SjRvYUZHUm8yeHByakNsL2lhRXk0c3FqQUdyVkNaVVVQNkpFUzdtOVgr?=
 =?utf-8?B?V2xyK1FOSFVmb05CcEFGeDZXcllUQlR1bVZMTHlYN0NWVzlmT3dxVXpHTHNL?=
 =?utf-8?B?MUhldjREMk45SjUzNnFyK0tQUEtlZTdGYUxtUkRPY1hrZ201L0c1cHJ3UzRT?=
 =?utf-8?B?bmFIRXAxa1krSWJjMkx6QXVtRWpPeEcyRDRxS1F3OVhSWHFrcnN2UUg3bmND?=
 =?utf-8?B?RzZiOThSMXdYY043QXFzcUpQSTBSQVhiVlJnQ0hSM0pzaE1KNXdLZllyaUZP?=
 =?utf-8?B?c04vc1hEbmZxYkxlVVFOREM1QmhGRjg3Q1RWdjNHenJBem9VaXVaS2I5WFV2?=
 =?utf-8?B?azJWSVJyOFRjWkVDMldMZktsSlM2REtJYlR6RUYzaEp4dW9TdXhqVWl4cVh1?=
 =?utf-8?B?RDBJZUJaalZNbmxsUG9PZjJ5WEozbVpZNExSdEo1QXFENUFxYnl0M0FJSU91?=
 =?utf-8?B?QnRxQ0NxdjFSbmNwcFAzOXNFa1FSU1dWbWNab2tRTUllc3pHYWREaVJ1aWVP?=
 =?utf-8?B?YWVmUVd6dHpvanZZV2NlbVh0QWt5WDk4YUZPZG8wVWMvK2N0QnJBU1g4azg4?=
 =?utf-8?B?R1Q1dlFHS0YwVW5ZYzZVTE1wbk4xYXA3SC9zMW5yTkNNRDFXQlNqTlY1cTdw?=
 =?utf-8?B?bTZRNnRVRUFFY21JVWZsMjZieldLSnBJdzhHdWhkUXBOMHRMYjdrekhNRUpY?=
 =?utf-8?B?OGxJaEREc2E0SXhFeVhYVmE2VlRyK1p0WURkcC9qL1BUU3FlWmJOTHJTenE2?=
 =?utf-8?B?bjJXdWhmUEZ0aHRlSWU4Zml4TUg0WEYxakhpci9jamVWK04wZjlMbTRsOEtS?=
 =?utf-8?B?STZSYWE4SmtXQ29VWS9jclpxYkhWRG8rRlBFVnhzOGZtTWczSThOWFl1TzBi?=
 =?utf-8?B?OEdSQTI0bWNucVBHQllFOTA2OUh4WkRmdUNTVXkwS2ZsbS95T0M3MkpNcGpS?=
 =?utf-8?B?SUFId2tDRHpBUmlwSWFyOVM2QXY2TW0wL0M2MWY1a25tNVNSZTlaOUNFUU9i?=
 =?utf-8?B?VDlIS0hvSUlmSzJ1OHpUWW5heXBoeVBvMDNnOXd2T01LSThnajA4L00rdE1G?=
 =?utf-8?B?S1FQckgrN01KVWFxNFZvcXpNREdUajJYQTZid09SUmJWTTlFUUh3QktCcmQy?=
 =?utf-8?B?R1NoQUNqNWR6VzhGa0Y2MVEvZU9tcGtEU2pyNldmVWN3T2Jqb1RNa3BTUFRu?=
 =?utf-8?B?cVNzcUQ0WU55K0cyTTNPUGsyZDVJMWg1ZlNTNlZxU0JobmRQVFA0WEtaUTNW?=
 =?utf-8?B?OWhnUW9yMnQ1TTdIeXI2VzdISENQcVRwWWt5YzMxWmEranduWkNSend2Wlhp?=
 =?utf-8?B?amRQUTN1alZMR2xDejIrb25aRWhWM2Rpb1ZwUklZWk01d2pKOU5rMmc0WTNW?=
 =?utf-8?B?V01GbXlXb202bEdzcit5MFBYbmlKd2VsQmRta1VvMTBNeW5LdzZFbWlNbzcz?=
 =?utf-8?B?V1d6K0JSa0tpa2xnNnd2V3ZwVW8rTzMwZmJsQ25maGVPaVJveVJKb1NPUWI2?=
 =?utf-8?B?WUVvanNhYzBrZGlkcmI5VDhHaXV3T2tUazBXZ3pEV0Y1akdVbW1xeVJsZTZk?=
 =?utf-8?B?em1BN1gvUGpTRnhVdll3MHVlMlVDQVdqYmJIUHlNUGxLd3ViemRUL2Y4dnY3?=
 =?utf-8?B?bWN0REFVWjhpb1JXanprR1JlOVpZRWdLMFFuanF4UFo0YnlDTGNJM0YwcGEy?=
 =?utf-8?B?RDNCNGc2ZE5EZ3JzcSsrZE15RHExOGxmVGdubHdBTFdhbDQwbTN6NUR0Sk1Z?=
 =?utf-8?B?Z3VRQWtDbmpKbk1xcUNRTzFmSGRWRlNCOHlwYTQ3emFqZkJWYjZ5WlNnTVpJ?=
 =?utf-8?B?Y3NvRzN3d2k0K3YzSzgwUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUlxVWZiYmJHbDlPdDF1Z0xDRUJkYWVPNEJTRDZzNXlqcHB1QWhML2k2aks3?=
 =?utf-8?B?ZGtxbjRFRHhYT1VFZ1ZUUDA2TkxIU0RuUUV4Z3pWNWo2TWdDSkZZTE1HQk00?=
 =?utf-8?B?bElTUyt3cjdSSWtkY2N3cFRHZHZYUnRROERQOVZGYmZhM2pmcFhTeXFGaEJJ?=
 =?utf-8?B?bTZwaDlrK1BCU0tWWFJXQVpUUnZUWXlkdVBVL3RIblF4bDhidkVBOXN1ZFox?=
 =?utf-8?B?N3kzQXByTzNGaTB6RG04NnVSZS9Ma2UzTVdiRGhpWENKendrY3M5NW5Bc3Rs?=
 =?utf-8?B?WlJMZ0RrcExzdm05bXhwVzhHOEZjSjllcFh3c1ZiMUE4ZEgwdFNYYU95Vlpo?=
 =?utf-8?B?eTdpandPMEpYMVRSSk5VM3NHY3JNQTd0RmRRNFYwWGZBcm9TenN2VkJpK2ZK?=
 =?utf-8?B?SmowM0IrTXNXUnlOSWZNSDhtNDlBOUJ4MlErNWdnSlhWMWh4OHMzZ0VuYk9R?=
 =?utf-8?B?dFdLVEtsZ2JpVEpERzB5SllvV1U5NCtzZG1DcHhxZThFVDJXTi9WSHl3Ry9W?=
 =?utf-8?B?c3dWMllsdFJDUTJGc1R6MDVmcm5jTmtta2htdEs3OThFYS8zNm9waGQwd08v?=
 =?utf-8?B?azMyVlNjR054TEVPNmhyNWN1UThlem1VVEcyUGpNbkYzSEZtWFZOS28reENV?=
 =?utf-8?B?YTFDRytRbDdQS0YvWklTQVNpU2JSL0Zta1ZUVTl6UnJGV1AvRWJ5UDU3M0pL?=
 =?utf-8?B?NEMyakgzeW9ib1Z6Mkxqa0NlK3BzK0JlYk5DbTUyRUdRd1dvdnRJQ2RMU2pa?=
 =?utf-8?B?RmNsUWtHYVpnalQ3SmdWMkNDajlKMWVvV1lVTFdtZzdITGg0emdvVUt5UWd1?=
 =?utf-8?B?S2R5bjFLeWhxd1VNT3dvR05CbGs2dXhUbUFQblp5NjVQcmJaYlBUZ2JWUU1y?=
 =?utf-8?B?THQ3QzhFUWtBdnQvbGdVZkJELy8wa1VDMmxqdmQvU0FNcVFqaWxpek4zWHNk?=
 =?utf-8?B?RWdKZGZQUzBrcU1TZzVoVmhkVi90dTAzR3oyRWVXUmtGSHh4S3cwWWczNlo1?=
 =?utf-8?B?UTVsR0pXU3liQU9RQ0d1SlFESXFDWFRCdUJLYXg0b0dMWi91VHVNc0xNRkRG?=
 =?utf-8?B?UmNka0JuQ1pkRUNRRVR3c29XTGxxNG9IVGd1QmRxNXhJQklZNDFaTm1reWFF?=
 =?utf-8?B?T3c2Yi9rcERkWTM5ZmFLclVMbm1VcUlOUEFnUzU0N3RyU2lBVEswckV2dVI2?=
 =?utf-8?B?cmEwMjZmbXRwWW96czRzVXpMdTBEczRCUWZXYVJJSDByUkNpVTVKUUdzODFR?=
 =?utf-8?B?VXJDS1duVVJuSHFQblFhK1ErNmJSYXA1N0NsMlpHckhOS251SHkveDdHSFhE?=
 =?utf-8?B?R3dlbEExOHdvLzVONk95Ti9xTjl6ZUVPT1hEb3BpdGM5bGFLRjIraEpReHB1?=
 =?utf-8?B?WTZkaXcxQVRUSE52eFU5Q3RCdnpEenI3OXlOeXgrV0pHbHQvd1hBQzBxdWpL?=
 =?utf-8?B?VmRXTGdBZEptWjJhSWhnSFRubGV5MU1lbm8xazFETTMrYnk4TytNQUlZNnhL?=
 =?utf-8?B?VzdxQkFRWjBqVVlsYlBwZVZ4SW0vTFQ3SnJPbXhJT3RMbHd1UXMva2hKMFN3?=
 =?utf-8?B?YnhTTUpiMEhJUS9Vc2N1RnA3dG4zYWJoam94V2VLY3NWbDhxbEk5anhuZVQw?=
 =?utf-8?B?dXEvakdDQUZlQ1NxNGRSSXd5d3kwU21ZdThuWFQyVlJQamFRK3pZYm5sVEdj?=
 =?utf-8?B?RDRXN2gvN1BxUWMyWnFKbkpwYUh3amZPakcyV2VnVUZNNW9uNDJTcXN1RUt5?=
 =?utf-8?B?ZEtiZWZBeEE4R280eVNIVEdSSnF2TkttQ0k1YllDNWJkcWR0WHF2QzN3V0NZ?=
 =?utf-8?B?SDlGTmhUSFlqdTRXZkRpZHhGMUI1NEppQTl2RXdWVk00T1o2VDNnVTEyS1BH?=
 =?utf-8?B?K0VsQnRlL2NaQ0VaNXRCUWlNM0svTnQvTE1XbHBqL0UxTFpWdEI0Q0V6Y2Jq?=
 =?utf-8?B?TzFwUm0xR3IyUGg0ck0wMVhZeEphWG9GeE9STmM4SGtMMkpUaWxRMFdlZTkr?=
 =?utf-8?B?aWlwRDQ2cmh1V3VlNjBjY1lnTDI0cGNwVVNvclMrdXFOaVhFQ1V1SHZ1Z1FO?=
 =?utf-8?B?NzdIOWQrbDA5Q092UEJhVGhwUG9zeFB3NWtZYWlmbmpldXBOT3NGZmdkbUQ5?=
 =?utf-8?B?UWRqOVRLdkpoWFc0M21pVVcwWS9XSkF2VDZxQk9CRWorMWxXMHBDUHFNdGVH?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5d6ba9-bb61-4530-2e65-08dd0e49524e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 18:37:03.3942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJTphKNoPDBrgtUEcgCmu3pFxKqiPhwcCUL67U7ideYlcaqGZhqTSXbpOJY7IkmeNpNOTgtNo68UkZb6kscneOomELLN/yu4a205PSUrRZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4545
X-OriginatorOrg: intel.com

Hi Tony,

On 11/22/24 3:58 PM, Tony Luck wrote:
> The default input measurement to the mba_sc feedback loop for
> memory bandwidth control when the user mounts with the "mba_MBps"
> option is the local bandwidth event.
> 
> But some systems may not support a local bandwidth event.
> 
> When local bandwidth event is not supported, check for support
> of total bandwidth and use that instead.
> 
> Relax the mount option check to allow use of the "mba_MBps"
> option for systems when only total bandwidth monitoring is
> supported. Also update the error message.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
