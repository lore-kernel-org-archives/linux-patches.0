Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04623143871
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733764228; cv=fail; b=Kowz9bHQH3a2e6VT3l3gpqhTI1sBH1w5VQEp/Rn3fojt6BpJfyAQLVsTn1U32ONW6NhLbx6Wmb6xaevPIzHa/Laxva5SBYgWUyrqg1phzKagLBRcTQDqltbHpmGD2HLwkm3dULnrM9I8yjXwwKMFf1ldLVbTbkhNNFhM6s7uWNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733764228; c=relaxed/simple;
	bh=ZlNRdgttHoOXFqB+u/UB8At2hAxe9p3gDZxcDcBHyeY=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I9LM+XuSQEbvGZ5y+TfsE/6ahotRptBbpTY5qYElE5B76XoL8dPnDt9pS2L0su8g+xCMwNia3KU0lLfm+mqheVTO0B9RFmRiupE4ztT2o+lefpY9/Of6p0b1WNeYPAWEFHOzY0x3XgPXMWxKpQvmRr1AHhhczeLNRjq0vkVfomc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gp1CQ03X; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gp1CQ03X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733764227; x=1765300227;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZlNRdgttHoOXFqB+u/UB8At2hAxe9p3gDZxcDcBHyeY=;
  b=Gp1CQ03X5ifDFprA/quoiBpcHKcgbvzdLmRTnfK+Xm6jpZRtEp/zDdrW
   iXcxBOGrRHiTqJyn8ZNWN0acDLJ9jKxhw8NYFUY/KanljddFfEBkLi6WF
   /jjkeYVnQN40Im/DIVJjCYqXwlQsDF+5Y1Q7SZntZlco/mfhWq2JEpsf6
   UQwM7pJ7PWWa2eEXU/mvKp8AKf5mXVhfmTeDsYVh0cqEgDnV/SzEwcaMw
   4JCTSX3+dEGusVeJsgpGiTtdHTSYj7giPS+3h4YKZI9+T7tVoIwqJYoE8
   d6KaoqDYwbYgAT/6TZq/F0cDCSU/Gt1sLLYl4wYfWCSOInLVSnkphc4yd
   A==;
X-CSE-ConnectionGUID: O+hKb68MR4apuAT0dXTw0A==
X-CSE-MsgGUID: NXL49/8ISFWu+cOkFBYFuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="34201072"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="34201072"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 09:10:26 -0800
X-CSE-ConnectionGUID: jDYxHmIZRNOcsnuS58Ttkg==
X-CSE-MsgGUID: xIO1BQ28S1ycJq6idd2gdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="95933476"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 09:10:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 09:10:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 09:10:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 09:10:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qpiwtSDGylhwC7RpgzGCF30gQSj2RhwfH42p8ErU1ult6FkO2ToMC1L1ifNyESxMG6wgLmqt80v29jbw4ihAneF3yx4qWuUadkFxjYFsYW0EFJNuIZtl8g/zWBes9wykNGaEn5YZv5d4IJlLOtWG9KpU/dXNd3KKUZXuFRF2WDyGBFW/lu/qn59PO8gWWFH+Nm5NhDNjHac+m7VGpJ/l2MBaiIHPQHctMrVCi6WtL/+RKeFfmJ16LwrEjZ9+9nR9iXWV5Ldm+AStO08iBm1PQU2anrjl1RoxFIpFSVYimZfyCLuorqXLKGqCEhahTtMj9vnaqw1+JVCFD+DaXmWbHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwhrCnfYaMkQ3dD22ueU8r2W/qIneyIGbGhmf/oWACc=;
 b=Ir9N6Bht6pKqiEWt2HRBcUL7PpyCloGBwLP6oj88iCK61cN+YjqqvNWNemxmq6XpoHx9/fMitNoyYmJirJihb7TH26tpQmnuK3f1VhhBOul6lPyNtFZDavbkI1spw2NqK6T+qc4mvNA2iRlfpRUfLju34J23AJEtO3GV3vCCTW8Kw48tBVYfqdCOjaHEcS8z6THT05/UbrJmejlV8LYNapXnZJE3BlHKtrE7L1yRhGELJ29waZ6+SdFOituN99s2B6160KPn638TclF6L6mGBTmaLjq4/lk6S76e9SOlbMLcbLAKAcWGx2O5d+pkv7kYm7XCC+c8T9pBVAVs5dcfOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB4985.namprd11.prod.outlook.com (2603:10b6:806:111::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 17:10:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 17:10:22 +0000
Message-ID: <7e7c01c5-f64f-42c3-9364-ddcfd01b25c1@intel.com>
Date: Mon, 9 Dec 2024 09:10:20 -0800
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v11 0/8] x86/resctrl: mba_MBps enhancement
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>, Borislav Petkov <bp@alien8.de>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241206163148.83828-1-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20241206163148.83828-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0277.namprd04.prod.outlook.com
 (2603:10b6:303:89::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: 8947ac7b-dd4f-4028-dae2-08dd18745da3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VDhkeHh4VkE4UFN1VVVUSjJBMzlsVVNFdUdRUWl2VkNYMzhzZ054VmxZRGhY?=
 =?utf-8?B?a29CTnN5MTNqcUFFR3d0OTI0SG05SllQb1hvTktURC9pU3R5bGtTSXE3M0Fp?=
 =?utf-8?B?Q1hiY2F6b1c2K3gwelZDTE0zVFpOazdpSnZIalh4S3NtK244UGVOUVpib0VZ?=
 =?utf-8?B?M3Y5NC9PNHhXMHdScUMzc2w0OU9GWjN2SUpwdURNZmcrNUpkN2RTbVJsT2RN?=
 =?utf-8?B?WmRsRmJUelE3SUdVZTNUMGl4WnBjTm9LdFRudlIwaEIza0lNNHhJWWV4ZFBB?=
 =?utf-8?B?ak9yamlucHUzWTJ6dGMweTgyRyszeEFobTlPSVY1TjhCeUZmUjdObnBnM2NN?=
 =?utf-8?B?ZmQvS0I5RTNVS08xajhVTWtjdEpUd0x2ekJLZGsxWWxGQjZyNGFncHlISXhn?=
 =?utf-8?B?RWVaTFcwRHc4VCtodGhFbnFCYWNtS0RMQVRyWTdiTWFFNWthMmZreTlCSjlK?=
 =?utf-8?B?VEVxNTJjWlpJSWxRMld1Q3BkVURaZVphTGl2YlhlRmNNMlVVc0FRME5Rb04w?=
 =?utf-8?B?Sjc1VXFDSHAxRXpwVXJhOXVGQzVJdzVPa3ZHWWEveXQwUlVlQ0lBeG1sNnI0?=
 =?utf-8?B?b3pRckVvWDdnWG9BMDVWZnNiMmNvbmtuYU9Tb0pwYk1jTmZmTXRXUjlWN1Uz?=
 =?utf-8?B?MkxFZFg4SWc0NFFhdHpqS0RCTllUUW10NkdiaTRXOElFUGZjbmVvUmV6Zmwy?=
 =?utf-8?B?bTcxejRDZDRWSkpXSFd0WXpyOXN3UWJUN0M0aUthYlZ2RnRBbTZMeVdRYW1i?=
 =?utf-8?B?R203RmpNT0prejhLNzdXLzFqZTNoZjNnbENDL2sxMVQzT0VYblRpQ3RLOFFD?=
 =?utf-8?B?aWhKODRjU3FZSWo4OThBRnp6VHlOSnIrdXhsVm9EUEVaM2psUG1WN3VtVThK?=
 =?utf-8?B?dURSbmw0RXpCNnRVQTVINmpUZ2RjZ25nWDBCR3UzdGlZSDVSRFZQWGtucDJj?=
 =?utf-8?B?OENvdnhDWXNwNlVMSStIdUt0cy91NThqQ3JWQy9FbUprRXNwTjVoUmY4ZFdo?=
 =?utf-8?B?ZkRkVktzRGpGa0pyNElQZDRpYW1pc2Z2ZzBFUFJpTk5kMHBrQ2dFcmhGK1R5?=
 =?utf-8?B?c3lLV1FwN0VzQ2xjcTNtYndhRTJkVFRQVXczTGlpZXZMVjJvd1BxSXFKU0kr?=
 =?utf-8?B?NU9ERWFVMUZVVnBoaFA2Und4d2JISy84TXVhWUFNZUhkQWY4Vy9QbkRlQkJS?=
 =?utf-8?B?azhiM3MwWjFYK01CUjEzemtJeERkN2g0SjllVzY1UVBid3VhSUJ4VzBOakFI?=
 =?utf-8?B?SnRSb3FBcDNqL2FnL2hOVmNYMysrYitHR1lJTFAwNlBzcTFzbmpWNExwTW8x?=
 =?utf-8?B?ak1LTitWQ211UGdtbm1MdVVkSnFQTzNBbHJsdnp0MWE5YVh0ZmNxb1IrMDFR?=
 =?utf-8?B?QWo0cklOcTV5S2NNbEt1YjNoUTVpUkZXZWlDUFp0T0pINC94cDJHMklIcGFL?=
 =?utf-8?B?Ukd6SkhJMHN2dFpEOGlsTjRwYTd6Ujd1Uk9ZbC9mWWIzRk4reDVRVE1vc0Ur?=
 =?utf-8?B?OENKb3M0ZnUvb0tnTStVVU1HL1dUaUlZWHlreUtOcGVSeGRSK3gwZVJoMnVj?=
 =?utf-8?B?dkMrSTBydS9jODJXRE13c2J4WmdmTVFUVG12K0ltVUc3NjJ0S1FLa1Z1c2pn?=
 =?utf-8?B?S3VmRHlBeEdNLzJvc05DOTlnSzlrY1FaQitDbjJYUFYwY0NNSzBrY2UrMkZY?=
 =?utf-8?B?alp1L242VUhTRmhZL0lCbHpEaHgzZzlMZkt5U2FEc3lEVy9MOENiMW1hR0Jv?=
 =?utf-8?B?bGVMWGRDVmRuN0VGb1N6YVI0VkVVS3k5YkNzUWpCS1NLRTQwYnVPRmxtN3B2?=
 =?utf-8?Q?7DQBGyj26nSCvOpBP4zjN1YAXBoGv5y+rrol4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zjk2VWdkOGNiTnkxSE1pQTdMRHpVemJBdnk0QWNOQmorRW1qTVMzMVpNK1Bp?=
 =?utf-8?B?OERvZFpDMmFtUjEzU2xWdzd0ZXlrS2lFRTBWbm5NNnhpY0d6NTVBclIyS040?=
 =?utf-8?B?RG4wMUtxSUp3RFJrWkJweHk1Tm8xalNQUkJ4TGN1eENQaHR1Qld1NkxZOW4z?=
 =?utf-8?B?alhzNU1sVmRUaXpJTDNVNmMyWUlLQm9jRkpMTFpXOFpJYWh4Mk1jSDdWcGIz?=
 =?utf-8?B?eDVYTnpRYU11eWJ2RFJ4Uit3ZURPbDB3QitaV2ZPSmxZa201NDN2SEN3enZp?=
 =?utf-8?B?U0hYQWxHUFBxQnR2dHN6SU5Oa2hOdWNFdDhZdVkvWXl1UUkxMkdLNEVud2Z2?=
 =?utf-8?B?YXA4eFcrSGZ4VDE0VGl6Zi90YUdRZ0lURWh3MndaeVlkM09udGg3eEJsWW1q?=
 =?utf-8?B?cDAvcDh2bkxCcWl2UzRrc2RqVnIzQWZOaUV6SERUbktDaS9TT3Vla1FkajRH?=
 =?utf-8?B?Q3NSZUpqVytEdEtVeFk4ajZuM3lxSG9EZkpSd25wUEt0ZVZqbzkzZUFSTzZS?=
 =?utf-8?B?RXBOZTMyMkpERGhuNCtvZGFPNHAvRGV3WS92TlJublVsN0J0V3lYY29HUXRr?=
 =?utf-8?B?Tm9RakJLK3pQQmZPVHlFUTdvbitQVXp6S1dVMHRtSTJmcC9NblVSSDc2U2Fv?=
 =?utf-8?B?YmMwUC9CRFgrUUorYUJaM09ROE93YnZveFg2TVVaZFlJNUJjYmduWDJYT0g0?=
 =?utf-8?B?Z0huTzV2c3QweFFQekJtMm5hQUt4RDVueFNVRmlieDg4ZkRaSDNvWkFwSjVE?=
 =?utf-8?B?OG1UUnlrTmlhQmNYNERzaDJRTW1Iei9LQnBXYU1kMllaR2ZFZUxSVDNLQXUr?=
 =?utf-8?B?S0VObWtHWWpyaWg1Yll4U2EzMDlFV0c3Y1h4TE0ramgrUGFYa25lcUFFZk5S?=
 =?utf-8?B?Q0Q1U3ZWZG9hZXZkMFJ0c3FRd2ZRbHE2Y2N5WnF1UDY1eTdHOWVsUDdRSzRY?=
 =?utf-8?B?ekI3NFhqanVjbks1T1pocUtJeVFuMlhHTEZJVFJHb2lGQjU4c1IrTXpKT0Ew?=
 =?utf-8?B?VzU3amQzaHNIQWs1UkJjdkRkTVZJNEV1aDNXcW1SYzVaOHgyYm9CaGtEWVA3?=
 =?utf-8?B?Y2hWNDEwQWxSMHpuaWpYYytkWFJqQmthOW9CSWJjM1ZhWXVIWFBJdHc5UjdJ?=
 =?utf-8?B?dUFCMGd2c2YvUTMxb3p3TmFDaWxhcUd5ZElTUjEydGdvRDhlR2NXZG1rV2hj?=
 =?utf-8?B?dmF6RFBhby9zV1M2YVFKa1ZyRnViQ2VPSEF4clhpVENYWGtveWhYK0pScklr?=
 =?utf-8?B?cG5OQmx1U3RwYXZVT05lWHBjSWNQVjh5VE0xNytNTGpmR3VNNm43aW5DSnFM?=
 =?utf-8?B?YUtLOUhBN255ZnlNMmdUdFZmZjZnT3JnVDJqQzBFUkdtclYvbnRtVGZhVHV1?=
 =?utf-8?B?RVhqQUkvU3JCWlhCUHVvNkRRRXVxZnQ0Sml5OElPYlF4MjJrMGRITVlFZXFx?=
 =?utf-8?B?TjFpQWZ4R0NZZnlxWmRlSjI1NEEvWGV0dDBCSEpuNFkwSVREWFY4bUc0TGh3?=
 =?utf-8?B?V0ZIUzBnc0NYRHNHWDlVZzBGa3NOSW02eUdQL0crVHFiTHc4TWhjaGowWEZn?=
 =?utf-8?B?emtGR09oZ1Y5SjJzNkdCNEYzOVNVYlhKL3B1Wk5kSVM4eUU5dUFQQkp5Q0xy?=
 =?utf-8?B?ZllkZWNINHUyUDF2dVFaKzR4a0lwbnhIUVo3emxoUngvV2pvUFZoTWgwNCtS?=
 =?utf-8?B?TzhMMWlvbVlNUmdZYndnMWcxR0QwSGx3NVYvUjFkaCtZTFBFbkk5U3BYOWZV?=
 =?utf-8?B?Z0dSbWFuZllLcTR0VklaTTJKbjZjTHEySGpPNHVwMG0yOEFzUXl2aGFZbTgy?=
 =?utf-8?B?VEhjTVBQa21BUTBLcTdTUkVJV1NDUmZUc3l1Y3M0U2h5a094aUU5Z1IrTmhU?=
 =?utf-8?B?OTU0YmJuYnJwRnJ6N3ZlRzdpTlJudkNjUENZVGZMTEZxSmxNclg5cGswd1BX?=
 =?utf-8?B?eVlkQURzeHFpR0pVSy9zQ1UzMUtLUzQ2RERVNVZhY0M4V0JsYisxVi81aUFu?=
 =?utf-8?B?ZnZqNVpFblJtQlNEM0FEaGFKMjNlUERtV29tK0hzekpWVGNPNTFWdExyZDhz?=
 =?utf-8?B?N2hNREZQSEtvbkVmYXJIQndhWXMxL1RsT21qZ2JSamFTMDgwRWw0RUNkRHNI?=
 =?utf-8?B?MU85NkJiMUZSVkhiWEg1Rk1ocjNsWTFtbHEwWjNWY0oxRnlwOVpDWUx1RlNl?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8947ac7b-dd4f-4028-dae2-08dd18745da3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 17:10:22.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5KgG09r8UMF7FWm7Bdxk/BIRXaEmvIyYcMzgSbcRYd98QlxvQrE31WK4O/g1rNmaKfwYHHOspkLqSDQyucAuxC8qYLnJeX1c4JSccrKBzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4985
X-OriginatorOrg: intel.com

Hi Boris,

On 12/6/24 8:31 AM, Tony Luck wrote:
> Background
> ----------
> 
> The resctrl filesystem supports a mount option that allows users to
> specify a memory bandwidth limit in MiB/s for each domain of a CTRL_MON
> group.  The underlying implementation uses data collected from the local
> memory bandwidth monitoring event for the CTRL_MON group and all of
> its MON subgroups as input to a feedback loop that adjusts the memory
> bandwidth allocation control percentage up or down to keep the group
> within the limit set by the user.
> 
> Problem statement
> -----------------
> 
> Hard coding the local memory bandwidth monitoring event has the following
> issues:
> 
> 1) Some systems may support total memory bandwidth monitoring but
> not local.  The user cannot use this mount option on such systems.
> 
> 2) For large workloads that span NUMA domains using local bandwidth
> monitoring will not throttle jobs correctly.
> 
> 3) Users may have a mix of large and small workloads and may want to
> use different input events per CTRL_MON group.
> 
> Solution
> --------
> 
> A) Provide a new user interface to choose which event is used for each
>    CTRL_MON group.
> 
> B) Allow systems that only support total memory bandwidth monitoring to
>    use total bandwidth event.
> 
> Changes since v10:
> Link: https://lore.kernel.org/all/20241122235832.27498-1-tony.luck@intel.com/
> 
> Patch	Change
> -----	------
> 
> 2	s/filesystm/filesystem/
> 	Reformat block comment above definition of mba_mbps_default_event using
> 	more of 80 column width
> 
> 3	s/Update_mba_bw()/update_mba_bw()
> 
> Added Reinette's Reviewed-by tag to parts 2-8


Could you please consider this series for inclusion?

> 
> N.B. v6.13-rc1 introduced a locking change in commit f1be1788a32e ("block:
> model freeze & enter queue as lock for supporting lockdep") that throws
> a lockdep splat when mounting the resctrl filesystem (with certain
> CONFIG options).
> 
> Proposed patches that fix this are here:
> Link: https://lore.kernel.org/all/20241206111611.978870-2-ming.lei@redhat.com/
> Link: https://lore.kernel.org/all/20241206111611.978870-3-ming.lei@redhat.com/
> 
> 
This fix has been merged into v6.13-rc2.

Thank you very much.

Reinette


