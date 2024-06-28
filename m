Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CD7BA53
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 20:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719608062; cv=fail; b=BW3ZnH/50jZYpo+kukc+Ic6spatzZ5JzIOSthEQyvXa6knA5NN826KCrzuCRaYiYHEOuI+K8EeITXWYTcylbSUpVVII57qT2RO0D2hbZlvbAtXLkBI1ZRKK/8sdmZJctQYl1ZE+eLCGIy54P1VsPQjXtWXT6DVAOP6UHiQSJXjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719608062; c=relaxed/simple;
	bh=2rD0kydHu7QSiLIbY1ZNV1Cfkzq9XHGZP/mtkLqCRAw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gg4E6z81hNAZadZB0P6xydiSzNOQdIAjg5FLktuXrmaz2rMH6yCdlj+6XC5i09Y3H9hhgo0KZ2VvW6phIrBV7nHZ1T5q6YkW0of0iaEsfq6l7AaED3cVopNE38VlkpTW0T/vLBLdP30mhda9dxRLy37JPtxHJSgKzr9wk1mgTA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UTetkaZH; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UTetkaZH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719608060; x=1751144060;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2rD0kydHu7QSiLIbY1ZNV1Cfkzq9XHGZP/mtkLqCRAw=;
  b=UTetkaZHgIQ+E5Ml5vv68egt8HPwCj8VMdhlVZjo4v8DWq2O9lEKBqYQ
   8TSBwcu73cy31g2SgOW8+qO64YiXgN2ES6s1DPivVBDQyBmd8VwQD2RDO
   7/b0s4ZiTfa5Ghhy4mWc1mJYnvnIiZxiLZvNHPIpE02F2gRX2lO3+y3iE
   KkESW/i/6OZIAb1du/fH5lym8BkviJ0c75o4hwfkgMg07KZkzOFjUIv+Z
   6pv3muH8C6uJCeu23yqNWjk6Srm6JfWM/dDb0HsjhcrDCY89BhioF+Xqt
   hCv9Rzt1dicdIBw9skSbuktlkN9jIDFPbrErURwPN1C4njegwyz2KuPiz
   Q==;
X-CSE-ConnectionGUID: S9CDKTZ2Rj69Zi8he9Zb6Q==
X-CSE-MsgGUID: mTIow8ehRNmQTHHp+Od0nQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16947521"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="16947521"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 13:54:19 -0700
X-CSE-ConnectionGUID: L3YiOcoqQG2E9r1z2X6R7Q==
X-CSE-MsgGUID: AyinafFsSQ+k2R2dwAv8Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="49200401"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 13:54:18 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 13:54:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 13:54:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 13:54:18 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 13:54:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZOmYgZX3G5ckNxpkcBet3lzh8WlRmeZPtQcHBLkrjtj5rBzEKkEf+Kf/ZWLRUpo67o0x1CJGpd5Qq1kSYW5UhZwHnnDOQPcP+YxYkljMCwKqmhQMacRFWIEJ6NLkeU/U7MGbi5aOAV2gSWqeQ2uAG+lDJvgsFI+2wcsokGn5GFjdAEDOQpK1nkmDf4C/JXcKCp6wL0qRESuHRcgHK/VDdxrRmkYveI46xNcJ/M7VBjH2VRnAQoho1zHUozmEJPTN3h7nJ3PY3S3NfxugI4rC8VWqw4bMS0SJ0I88T8dd9k54HEw1EB8I9GKZbBANKyIItMZHIPlFSOIatx3puNoyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGEjO3AYF2qHF+8zS6O76Bl6/WCC7/psV/epVe/zei0=;
 b=k9OIImWJlqIeV/FAEtYN1aC3YgbJQqPC9WZjia1qcjNmxcMb+MxnGWyR87KcW++ATTM2GrTKfN5KoZ4tQd/IWxRTSnM6EHS4vg3VdgYRAvJQDMDt76lI8SMX2IepYfjmNq5RQ3RYgSDYNfZ1QrBNuyVm2mJQHRyApFHAu2VSbZDiacBEN/bz7KuL4fWEZA/wcj3rySDwdI9xCc7WckY9rwdd02vI+hqqsCnSwvy13KqX5u9aRpxc2HyeOwszpqokwBlFlKAqrUKXCAoY2lzYdGEUCTPAwg9LYoUHNbFYcErVf2MqXoAzys/6UFh/NYDpfAGnljyta8RcJJ2Ryq2XcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6884.namprd11.prod.outlook.com (2603:10b6:510:203::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.35; Fri, 28 Jun
 2024 20:54:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.033; Fri, 28 Jun 2024
 20:54:10 +0000
Message-ID: <2b155124-1a82-4a23-8de5-0c4f5c89186d@intel.com>
Date: Fri, 28 Jun 2024 13:54:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240627203856.66628-1-tony.luck@intel.com>
 <20240627203856.66628-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240627203856.66628-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0366.namprd04.prod.outlook.com
 (2603:10b6:303:81::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: 02b0a72c-9a97-432f-7e3a-08dc97b475dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXl2YjlUZHhrVkhwb0ZqWnBxREFvdXBXY1RXa2pnV1ZvaGZMSHpEaU9hUVpw?=
 =?utf-8?B?ZXR2UWNjdVRPbTBEYXZuU1RpZjh5M0hQampvbE5iT3N2TXp1aUhCVXdBNHpU?=
 =?utf-8?B?WjZkbG5xNHNwZkljWXNNb1EwcnczWmVxQ3l0aXlYaWhmUE9MSXRZYUk5dHVO?=
 =?utf-8?B?OGtPVGxKeWZHMzk1emhQYkV0YXNHaXltSG1pQzN6ejY1c2tscWJDM3RqMmQ2?=
 =?utf-8?B?S1pFVGMyYjUwQS9EQUx2Z283NFVDaEUxajFOQ200RUpPbWQ0VmRmZGpha25U?=
 =?utf-8?B?Z0dSL2VwVGViRnRPM3A1M3ZPQnozSzhRMTIva2tLaGpNRXVZS2VyZUNzd05o?=
 =?utf-8?B?ZzA0WmgvdUIvVGxlbzhBaTBPaHhJUHNJK0pHOExuZ3ZBMUFtY0x3cmZSbnZV?=
 =?utf-8?B?ZUdFY0ZBT1ZTc1BjL05pZlAwTE9RTy9QMTArSlkyTUYxT0g5WHFyNkE1Tnh4?=
 =?utf-8?B?U2pkWHp1NFJ0UGJ2dFI2T2tLckc1bmNRMXpPRE9SOHZ5eHM0VVErMEdWWGVh?=
 =?utf-8?B?VEwrWG1mdXRTRHA5WnUwcW1kTWxPK05HUE1jSGh4MzFGZERTYzBCdk83T3F1?=
 =?utf-8?B?NDUzbEZUU3pHeDRqN1VRTGljMTlxYzFYS3R2TGJKVVl3YThQOHkxS00zQzho?=
 =?utf-8?B?OFI5RXpEeEV5K0VrNTNXSHdBK09sd09JS3NUelVSNXZMRGpLN0JyUjVCaFJ4?=
 =?utf-8?B?WHNvWm5ad0xsYmhGd2FmdjdGaXhFbEJIT2VpZkNXelpqSG9mSUduZDREbk45?=
 =?utf-8?B?V3pKV2xSSVhkVkYrZTRwRjdSZnNMVzB1b0U1RkN4bkEyNTd2ajVkRnpNSTNY?=
 =?utf-8?B?cUMvTEJJMjl0STNZMUtITXVaRVdlRjVja21pMmEwQmVlT1c4VHBRYllSb2Ez?=
 =?utf-8?B?UmxiSDN2enZ0RG1veFhBaTRTanliN0ozSGhJUDB3VjZGOHhxbU05azJ5VzlD?=
 =?utf-8?B?c2dLOVYrb0ZGWlJFNitEd1R4T3ptaEJyU3M3UXpnSVFzLzcyQmF5R29iS3RY?=
 =?utf-8?B?K0FOU3JKSk9aZ0xCTnRwbVk2OVRCanJPR3k0SUlVZmhHV1QyTlBBdVFCQjdo?=
 =?utf-8?B?NlZjZ0cyUWhFSmRSVTFLTEs0dUNJd0Q3eGMySjZCZysrRjBVWE9WWkMzZEx6?=
 =?utf-8?B?K0xxamFocEIrY2k5WFNYOGlyNUNRYUxzWWJObmhBdDhmVTJseGNDRWYzWkJ0?=
 =?utf-8?B?OEZzUFVPeThNM2gvK1NHdzNocExPOHpScElraGt0UTAvUk1NclNxcXRGSjlD?=
 =?utf-8?B?STg4a2duemdpLzY1aSs4QWNKeW1UY2xiclNBZkVYYXlvUWhDM2NPc3dYZjZD?=
 =?utf-8?B?MVNGNkhxeGxuTlE5WHQxaEc5NEVOQlh6OWxYTVRtdjlpV2pWYkVjTzlpaXNY?=
 =?utf-8?B?QW5Uemc5UytiMkJKdlgyV2FqQ0prYmhaUmxKWjRDVVJJY2Rka1YrU1NieEVD?=
 =?utf-8?B?L2dzczlybDBpS0JnM0lVSUEzTTdWa2NpN0Yva1hDUTJ5RURTYVNqSGRWS1JZ?=
 =?utf-8?B?OS9wdlY2RXZMc2JpMEt0Z08vOCtEVlljSmRlbGFIVDRFbjcrMjZETHM4cXZs?=
 =?utf-8?B?T1g2NW83d0tESnZSZjhERXVRak5Rai8vcE4xZ3lVN01abzB5L3NiT0JJQ00v?=
 =?utf-8?B?cytwcXlPRFVXK1JrdnJWQitDVFdyWUdmdnN0STZhS0ZSUmkyVTVMai9lWUFy?=
 =?utf-8?B?V0tDRlFFN2EwZXkxbXAwcWgvWFIwWkM2Q3FBVXYwRWllZWRFbXB2N29IZkJ1?=
 =?utf-8?B?SWNoS1JwNzg1YmNjV09FcGowUk1XRmk3dENTa3UycSt0U2FQMm9HV1hMMU8z?=
 =?utf-8?B?NHhtUjlDKzlveVRxbi9adz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZCtkWlY4WmhKK1d5bXpIMFd3ZkU2WEJldURPdFYwOFhidG5RU0wvb0c3cGhI?=
 =?utf-8?B?YitGcVFOVDZFWktDR1BuaGNQeVEvRHYra1VkZS8wOUpmOG5nM3RiM2xrUjRw?=
 =?utf-8?B?MStuY3FRNTZNbmtvc09MMXJGSDFGNlcyY0hWY1I3dFZjalN5QWpNS3hoTlND?=
 =?utf-8?B?VTRJYzhpSmdzb1hnbTRrRGt5MmdlYVh1Z1ZtUUQwdEtPbzUzcU1yTTRLV2Jm?=
 =?utf-8?B?bjJvTU9XNWdha1RTQ2pIUDBIeXpMb2U0djVJM294akVFMk9lcGE1Vm5sdW1P?=
 =?utf-8?B?eW96NlRxMmM4U2NoZlp4WWZlOVU5U1V2TE85cUszQnlPc1BDTjNJSWVhZ0Vr?=
 =?utf-8?B?WDZ6TEM5OUttdjcrV2xKbXpXSTZHanZEbE9pWUFONWJjYmUxamxKcExlazJr?=
 =?utf-8?B?cnRSM3lsR0JrSjRKUDJua1k1anBzMHZxK0VqSkpHLzNZamhiQlBEamlFbjlr?=
 =?utf-8?B?eFczdHBGNTVrTU8rbnRRWVNNdXEreHJCYzAxaWVYQjlxZ2dvU3d5eW5DbEhr?=
 =?utf-8?B?RnpjOFRQUytLSDkwRnNOeVVmQUY2WnlvQmExWkZCZFdsblpUTXlNdE9SMlZr?=
 =?utf-8?B?d2tvREhZcHhFa1RhT3N5cEhybGhocmIrUzI4V0pNbUxpQVJPV2F4clE5TVZK?=
 =?utf-8?B?cE95eDNZTEc3RTdQUjFjWGN2SGJKMVI5Mkc2WFNONW9lWlNSc1FJdzJ3OVZQ?=
 =?utf-8?B?OXYwNk5lQ3FvT0lIRXM0Y0xHQ2FWMEk4bzR3MkwvbTcrbEZTVHJoRHNvbm1j?=
 =?utf-8?B?WXVDSXAxTFdjWHNvSnpyczRzTHFmdFFHSEpPMkpDR3pZK1lWdVZhUzNKVkli?=
 =?utf-8?B?dFdBVWQ4cWgvTDFsL3J2Q1p5TE5SZ1hJY0RqUzV4aW1mRDNIZ21HZFE0d1NQ?=
 =?utf-8?B?WTN2cERTbGJlVE1uWTEwSDdVcVE0WEFQdTFmckQxU2t2bWVER3ZrUEwvd1ly?=
 =?utf-8?B?SFJ0OGxVVGpKY1BZVkw2bTRjcGFkbklmRmJSS3F2eE9iZ1FMY1B3cXN5bzJl?=
 =?utf-8?B?a3dGUStES2laRkFOSjRuOEhqa3RkbjZiQUZBcFZGY0dSQTV6NDdqaS9SeXlm?=
 =?utf-8?B?blZMVDA3QjAxcEovNS9IQmF4QUN0YVhQZU84bEpMWTdxMktQZytZbUl2dkFv?=
 =?utf-8?B?VWd4aFBnR0djY3lnZitPSWFuTnpmZ09uUXpiRnZwSDE1ZSs2YWYwWExGRUkz?=
 =?utf-8?B?eWF6TEpKaHNWZnFiRGdYdE1xWkFRUkZvaG15eVV4VFNOOVh1TE1PeFRSUDNz?=
 =?utf-8?B?R2JTeUxIVXhLS1FrQ3phcTR0alFmWWhFKzNDK1V0N3pyY0tGejlCWmR6R1NB?=
 =?utf-8?B?V3Jqdjdxc3o4bURvNzFZR3ZEMzBVNnBrOC9SVEo1NWlQM2lxcTdEN05ZN01q?=
 =?utf-8?B?cUpFYWJFUXNuOU1FaVRlSmF3NkpNSEtEdkJ6ZDF4VVlZVGtQT0xMbmVQR3JK?=
 =?utf-8?B?SlpoS25tWFVRYjFEM3dyREliMHN5eFA2S2p6N3pERW15T0k4ZmNsbGJCOG1u?=
 =?utf-8?B?R0xnOUp1djBTTHlIdlBYaEpxTnVXdXZmWG5nS3dJNTVjYThDeGprb1huYTMw?=
 =?utf-8?B?REZSNHhQSTFWNjduck4zM21JSWRYVU1kWTJDNUVCTFNPb3VUNDJDZERxQXlF?=
 =?utf-8?B?cHNGYlo4Y28zeS9iZzRFc3hyS3d5NWZselEzb09hN1J5bEE0L1Nnbk9FK1o0?=
 =?utf-8?B?Uk5UdlZTZFk1MytsN0xVTHI1QWVNc1EvZUpCOUtIbCsyVDhNR0M3Q0FEUVJE?=
 =?utf-8?B?U0pBQ3V2RDRGT1AvN21QS3NMTFVsN1lzTVpvUWs5TG92b1RHQmZHRXFpU0Zt?=
 =?utf-8?B?ZFZvTTY4emlPMTZQaGtuS1VWa1Vjbk5oTWdPZ1FOS1VFQlhHRUVya0hFQklw?=
 =?utf-8?B?SjNXRHoybzM5c0VrZHFBa1c5NlVvS1RaOHdCSzNYcGcvYXluQWVuNUhnM3Fm?=
 =?utf-8?B?OWNTQjJjSTRaeVZRUFRXSkNQd084cWJESk84RWcxcTlHZmxOU0UrL0dpVUlU?=
 =?utf-8?B?WElWRDg1Y3JLRmsvVE5rcWI3cm10OHBOQ0tBandaT2t4SHBrRHFkTmhKMVJp?=
 =?utf-8?B?WFVDOEZwTW1UNGxrRDJqV2JrSG9MSTZIU2RVMFVYT2wrUFZ4bzI2bDNISFgv?=
 =?utf-8?B?V0MvOW1vUkxIUTN2Q29IdFk5VnBsallOT1dZRXN2SjE5cTJQY2tGeEN5bUp4?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b0a72c-9a97-432f-7e3a-08dc97b475dc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 20:54:10.8508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVn6aY0Uwpr9WDepizwYD4NzwvqMHf3DFXdbLhXZTDtTf5VcwinKbRAe3ke8F8nA5Vy2+Q6JIXiXpV0czhpPf2eWDKC3gfDfuoXDtBAPqkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6884
X-OriginatorOrg: intel.com

Hi Tony,

On 6/27/24 1:38 PM, Tony Luck wrote:
> When a user reads a monitor file rdtgroup_mondata_show() calls
> mon_event_read() to package up all the required details into an rmid_read
> structure which is passed across the smp_call*() infrastructure to code
> that will read data from hardware and return the value (or error status)
> in the rmid_read structure.
> 
> Sub-NUMA Cluster (SNC) mode adds files with new semantics. These require
> the smp_call-ed code to sum event data from all domains that share an
> L3 cache.
> 
> Add a pointer to the L3 "cacheinfo" structure to struct rmid_read
> for the data collection routines to use to pick the domains to be
> summed.

This patch has evolved to a point asking for a split. Everything described below
would be a good fit for its own patch. I do not know if a single patch like this
one will be acceptable but at minimum I would propose that you motivate the
additional changes as a result of the semantic changes related to this struct.
For example, something like below inserted at this point in changelog:

	The new semantics rely on some struct rmid_read members having
	NULL values to distinguish between the SNC and non-SNC scenarios.
	resctrl can thus no longer rely on this struct not being initialized
	properly.

> 
> Initialize all on-stack declarations of struct rmid_read:
> 	rdtgroup_mondata_show()
> 	mbm_update()
> 	mkdir_mondata_subdir()
> to ensure that garbage values from the stack are not passed down
> to other functions.
> 
> Remove redundant rr->val = 0; from mon_event_read() and rr.first = false;
> from mbm_update() since the rmid_read structure is cleared by compiler.
> 
> Reinette suggested that the rmid_read structure has become complex enough
> to warrant documentation of each of its fields and provided the kerneldoc
> documentation for struct rmid_read.
> 
> Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

With patch either split or its changes motivated to be logically connected:

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
