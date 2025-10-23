Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4762132861C
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241963; cv=fail; b=NIGKA5wTJY5PAgWMXoGTnTGdo1bIPQPGDv89zBZRFIiN8NpgifNulY3tn30CgX+r7oXsl1guUOrStiFnKqM38nZrhFp2mMCg5rVsOp7Y9eQmUQp23b365WD79iKDaygV2mGaPVTOlsUoEIuJ4Ypvt32UYT5y0Aer/iaMYst+VE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241963; c=relaxed/simple;
	bh=se9zvxhihe6Lpni7eGlQ+rpcoQZrCr0Azmol4ZtEU4k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NLqXkEO1+qv218+/zvWaHp+VZWI2VuGNAnt/SgkY6MJ+WM5j69yRcdFygAEPH9UIDFWMlq159JQ6YgCngeQdlCtv1A5/fxJEa/vQTycof4pobzI+HRjcnUwK/L+wppJr2qYBAC96hMvqXpfWlFtoNXg80mg/dOrAAiq2zwSgALs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MDNP64hN; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MDNP64hN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241961; x=1792777961;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=se9zvxhihe6Lpni7eGlQ+rpcoQZrCr0Azmol4ZtEU4k=;
  b=MDNP64hNWVSocc1y0lRsC4JVVKGuC+I5kf/wiMnsXYO+trc6mmcglscE
   CUiCXvUlCLr8Mtv4FB8kL9x6VwMhVIQGvfAT/SyJbnsPbmgkOBXX6jmJy
   dJZuOj++8ioVIky36ONAcRlBGRdnW3avnR33ZryXhnwdHFyyHAUTnSmAS
   KjFA1fBpUvrLsNE1Lr2roFxGdOjifjvmm2Jez0uz6jE3yTsFJ19BArwlx
   J//C4EHNoV2OMn/bPDWCHK/bf/obZPwOLsO1YV77F4lDZW3oGs84wQ6JI
   nYw77IqLIF4jbxEeMOWXBGwoUB75/lPfUZo2e6MZNL0E7jZ2ZcBnMJHJs
   Q==;
X-CSE-ConnectionGUID: TJjPlGD2QWyoFs2k7bNPWA==
X-CSE-MsgGUID: Iajys48ER5+IapgRBISxKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63327601"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="63327601"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:52:40 -0700
X-CSE-ConnectionGUID: 1u68osNTShCKg1pw53fXMw==
X-CSE-MsgGUID: oobsC2DFSqi97BuVinR+eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="184699309"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:52:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:52:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:52:40 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:52:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UuKLKDYPPKzwF8y55K2pJAU1R4sDjBvp664g8wQHHqlBjkopG/rNiZumn1CJrkucZ92L6bz+TdJWygULshlk0WI/7+gSzVcFLRes4jfYCLXkXKXEtNIfKxffit729te5CAkYr4d/ZSjEYSft7HCkh8nEF6WhhrIFhSI7Y+WR2HKXTf/KHV42ZkEWYbPEkyaFLh2oOhz+A4b/8hWfQJvkcgy5JrU2tqIty80aHfKBu7s6EUD4NNQoHVZ0bl6tk+99aKreLAdiCNbMBLu6oomQEmEsJ/Ptyxdb7VtCO5y0Mf7J/3uW8gtR2UV9yRD53QGj+pyH+WlIJYISV8prjP95sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZetocs+UeO9DhzoLwjjfYOwh2+E0RIdssDMvVdoQAA=;
 b=blE3oS79PLzL6rMXik2F/yOE73I5DaMhp1sT409hYvDKmVOj3rrp4MVC1qHMUnSP6y2EgCk2jTDIWi7fuUgejd9+5ilkkwcOrtFaxj/rqG7BJ/38J5pMiunpy902dPw2QCOal+dKOAc3frpXnJoWhiYhjkoAmsCvnoqQOZacxE/yGDr1IvN3xG6qI/FaLvs1FaJm04q7bBruJ08hEFt2c9V8Sv8L0a6nZlN9tfUSL3hN80iz6NkJfyrD3fXqCm6lqiVAial+xrRN0cn6ddHj3uBlFGNaCbfzNpKlZboQhaIAPDbiBzvZDptxVjSQPFIsLozExuF988OAubDny5uFaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6784.namprd11.prod.outlook.com (2603:10b6:806:24c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:52:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:52:30 +0000
Message-ID: <79cf5b51-b2f5-4824-b5bb-33071237b349@intel.com>
Date: Thu, 23 Oct 2025 10:52:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 31/31] x86,fs/resctrl: Update documentation for
 telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-32-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251013223348.103390-32-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:303:b7::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f1b1fbe-0fdc-4f4a-229d-08de125cef8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VjJWNDRyQVBhVjEvT0dkMDl2Yll1UjE4NW9scTlYMkxjMVlzbTlPM3Rzc2Rs?=
 =?utf-8?B?bjZVSTdIbTlxeDg1Qmhqbjc0SmdpYlhxSXdqSS82R2hwSytqcnNSdFlQcndj?=
 =?utf-8?B?WWNOUlU5clViVGlzeEpvU1JpVE1mRzNqLzNWUUpub05YNHNJYm1jZnNTWWJk?=
 =?utf-8?B?RytnSUdnUENZT09jRFQwaWFad0ZIYmVGTlV0WTJUZk8wd3QyOERyQUl5b1k1?=
 =?utf-8?B?NVJSM3ZnWnBBb3p3SUJTRjdHdi9UZUNvVGNNK1ZCV0dpSFBCV3RSa3NJYzNk?=
 =?utf-8?B?b3c4N1B1WW1hSDVwejNVSi9EeGppcklGWisxc0FSMkRKcHBLSUkrK3RMSlZ1?=
 =?utf-8?B?NDdhajRSUXkrRXJvQWtVcHBMM1cvUkZwamNQWUhiYUVqSUFRM2ltVUNFMndQ?=
 =?utf-8?B?VG1OcjJWdy9YWVM5K2ZvQTd2OFhid0dJOXVWOXk0WGk5eEFHYms0SDA5WG5P?=
 =?utf-8?B?cm1aT3d1OFFZcThGZm5RU2VxTmVXdjlsOWoyQWdWaCtodTNJb0F3b0tLRFEz?=
 =?utf-8?B?Yk42c050YlNOQnk0dGdncUlYclBCVlI1bFBIaFAyNmtyclNQZjNMVnUrQmZH?=
 =?utf-8?B?Tk9vb29aQzk1SWR0K09vNzZpdTc4akV4aVJ6aGh4a08xK20wdmRNVnpzTlky?=
 =?utf-8?B?ZWk2VUxjcndNQU5kV2ZiTU5NYXJOa3ZBc2NPNGlxWXhYcWt4aFJCZURMTk5y?=
 =?utf-8?B?ZjBCaGVSdWEvU2lYNGtQTnpHMTMxZUZLTUQ4eXNSUEQrbUY2bWRIdFNDekR1?=
 =?utf-8?B?dXh2NWtwd3Fjak1Fa0E0TVM5aWlZeVZZek4wSWJ2MUxCZE1HQi9MNXhyTEV6?=
 =?utf-8?B?L253T3pydW8rTC9oU0VRRHloQXpLL3EyMkx2ZXplckVUakJTQURVZlJqMjNO?=
 =?utf-8?B?Ukd2UFYxcVV2bk9RcURtT0NKeEFtOEptazdERnVDQktDY0tENmEwYit1OE1r?=
 =?utf-8?B?Y1YxWHBTNVlJblZ5Y2FkNzh6ZTloU0tXOGMzWXN3MGJaWlBWd2NlUmlKZEQx?=
 =?utf-8?B?bDVWMHNWNHZTTlYrMSt5YnIyek1vMlZPb2hTZVcrZmtFSnk0RkU1WG84UWYr?=
 =?utf-8?B?ZlJicGMybC9sU054WngvYi9vVEh0REpFOGJOMVBZMUNzZnhMc3dOa2o0M3lp?=
 =?utf-8?B?amlmOFFaTlB4RlZhWEprQ1VRSHJhT1ZmMlB6ZWcvOSttV05VWU9Ea3o5V2Er?=
 =?utf-8?B?NzN5TnF2VkJ4cW16VGV6cGlyMkJkanhWaXJnOVpyWnI1T1ZKTUhFcENMYWg1?=
 =?utf-8?B?SVhUSTllRG43WUxhQnhoVXcxOWc2YjUxOS9iV3htaEc1b2crREFFUkx4K3Rl?=
 =?utf-8?B?WmVhSTA1bHd1bExza21WTEFPbm41V2phUnBFbTlOVEJtSkFsS004ZjdUM29h?=
 =?utf-8?B?YXJQTElST1JJSW80dVlPWHZ6aGx3M0t1NEJSMDYyYUZoUHQ2c3p2L2pseTU1?=
 =?utf-8?B?QXJ6WG5ZNGt3Wmo0OUZSZGV6V1hVVVZwYjVBdFMyeC91d0craCt1NmFuUXRu?=
 =?utf-8?B?UVNxbnBhakJXckJtZU5CRW1XeWtJQUVQVTJFTTJZVE0xYm1kOGlCQ1o1eGJ5?=
 =?utf-8?B?N3RlVGE4RUhOT0JOcjVWY3JjTDF5TFZLVW4xNnlHTGVBbWVIaC9YUVpGVzdq?=
 =?utf-8?B?SEpocUNqbWVYOXVaWWxQbWxOTFV4UFhyMjh0b0ZNWEx4RXUvdXN0MXRxdkNr?=
 =?utf-8?B?dFRkZnBrQ0pVVDJCUlFEVC8rbVN6ZnQ3bk4yTjRZcDA4ZkkwazBsRkJlVTNQ?=
 =?utf-8?B?QXZLaGhJL3E1K2N3LzNRTTN6ckRIVDgxdS9KK3lEdkNBTHBDejc5SStURXRF?=
 =?utf-8?B?SGIyeEdTZlhydC84cDM4Z05TcEZWeXpORkVhUXpZN0ZXcFZBTG1UTWU3cEl4?=
 =?utf-8?B?SzhUa1ZvM2JwV2lJcWJFaUZzYXlsY2JtZXJEb0U4cU1idXp2cTFwM0ZaeE5H?=
 =?utf-8?Q?FQg0rPjVBj/NN6ifZAkScZLuj1IKAikJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anF4bVlpazRNdDNmbXp6Mkp4bGp1b2crbHZ5eUd1NXhlYWxZalBlbzQydmZj?=
 =?utf-8?B?bS9ueDZRQm9oR3A0bHEvNWJQdEQ0czAzVlJrbHhEQXkybmI3Y0twSzFzeHdy?=
 =?utf-8?B?aVNvL0JSc21iTkM2TmY3WWJCSXJtTk5UVitOcHpJY2V0bm5pbE8rZTV1c2ds?=
 =?utf-8?B?dG5SVWMrRWxOeFFJZGJBendCNHVzOVlwS1lPUDNYVy9acjhuU1htaHNLYjNz?=
 =?utf-8?B?OEJXWmcvMkRFRWNsU2MxQ1dZWVdGUlplQmlWZmZ0TWtkT3NnSmhYemQ1UnFl?=
 =?utf-8?B?eEtTWTZveXJSNGdKUUsyTWFIWHErV3RseG9sbDE3QmlpdDNYbVRJUHMzRnZy?=
 =?utf-8?B?TVpKNGRtTlQ1ZlJncllWaVFKUE8zY0lRQU5ackRKL0U3Y3BhN0xJWVJwdlR3?=
 =?utf-8?B?ZC9vZGxuRHBkc0xiUVdBSDNIczRqNVZ2QXdRZ2c2MGluOHNJRG1IbCtFUUlL?=
 =?utf-8?B?YTBmMHNtNjJ6OUNWdTUzTDBnT2s1Ky9jYVVydVN5aGtBRVZXeTQ2QXJQeFE3?=
 =?utf-8?B?VWhheVJ0eEZqL0d0S2VScDdYSjdlTkR5NXJJRWU5YTlVRkdVeUpnQ1F0dTNE?=
 =?utf-8?B?Ritsc3Bmd1Zsa3c4UEk5dnRHSncwUUNIQTN1bjJubGl6MjY4SXFhWlRmWmRw?=
 =?utf-8?B?eTRZN1J1eHhVQzFsZjAyMXJDY2x1bEFia0tucTRLYzJyU0ZxRlNqK1Yra0dI?=
 =?utf-8?B?Z0dSd0pnbkJMWFlXVTUzTW9PaFM3aEpPdTdDb25EMXZ0RGN6U2tpVWFYZUx6?=
 =?utf-8?B?dkg2eUtWZ3VJMVNXTkVBM0xqVllTMnBscVNyb3IxSUhSRkwzclpXSUJkQzF0?=
 =?utf-8?B?czhjNzh4WnlTT1NjamZyU0ZSVzU0S2JsajIvb3BPYmdsYkR2S2c0RXRCMjBL?=
 =?utf-8?B?RmZPb3c0NVhKMTZkcXhiRWxsbnNBN0tGNGRIRXJxK3ZYRy9NaXhkaTVqbFll?=
 =?utf-8?B?Q0FNOURSUjJpNytBN0IwL3Fob0xXck5kVWR0cGtlM2g3ZUN0WGU4eTA5NUZo?=
 =?utf-8?B?VTZZYmllM1BScmpMdUtJSnc3QU9oZmt3Vm51by9FTDVMUDdXY3BpWnpSQnhk?=
 =?utf-8?B?QTlaVkdjK3Z5SS9YVmxlOS9RdHhaSSs2b3hFSllCVjhXYzE4cHEyZDZ3RElS?=
 =?utf-8?B?YnZBNCt3UTFtcjAxSUpTeHg1LzJJRDVnMEh4Zk1LTXpQQnRCK0NnVXY0bGtr?=
 =?utf-8?B?RW9udXRSUE83aXlENTFQMytxTHREMDhlaHRDSVAxMnAydUwzUStSNGgybVVX?=
 =?utf-8?B?cUltZGZUN1cxRWhoT1pRK045Z0JVNEVwMitzcTBvRk5naTJDVGR1aThIbDB2?=
 =?utf-8?B?Vmdlczg1aFRTNXllbGpZKzI2NFRSd1c2MjdlSUpkaytRcHliVHVWMFZmQ2F6?=
 =?utf-8?B?OFpmYlJGM1FSWkVPRXdoR054dS9WRnVnZVFHMDJYNk9XVUk0OWhEQW92RFdX?=
 =?utf-8?B?K1Q2SXFtY01OY2ZScHJPazN6cVRObmVZSG03dVlkakVwNUc1dkxESHBSdjh3?=
 =?utf-8?B?YTJFcVJmNkwzSDZxSi9UeVRzdjQvUCtpbGpJT1lVNGxlYjc5eWl0djYyclp1?=
 =?utf-8?B?dnp6QzVLMUJGWUxLNTZ2dmsvcEdhSW4wZmtPd3dxNGF2VjZ6THhNQ000Vk5p?=
 =?utf-8?B?aXp0K2hqaXJYeHJRbllKNlcwLzZRcXJxNk5nVmN3VHEwcXVKUVVYbXdNVmpp?=
 =?utf-8?B?NnpQQU04dzJYMzIzVlBtQ3ovWFpqa0h5aXkvZlloemhvdjhCSXVwOSt0Wk54?=
 =?utf-8?B?UERiVEgxVGF1aERIL2NLbllkRmpRZGliZ0N6VThEWkZPVmFQdnQzSnI4TWRV?=
 =?utf-8?B?VEM4TFVjdmIxS1owTDgrdXhOdmQ0VC8xaUQ1aExvSmdWeERqYTBtdFQwNWwz?=
 =?utf-8?B?YjAxNVE2Y21vTmFVUmRHK2RoM2I1NHpQZFBKVGs4akt3cE1OK29hWkpWTkh4?=
 =?utf-8?B?dUkzUTMwRG5QRjl2Z2ZBcXI1Q3REUEpiblIxaXg1NE0vSURvYk1Jb1NVVmFp?=
 =?utf-8?B?OGZ6YjlhMXdzUmQ4WEVmYjU5QVNWOFpRdVJ2R09QZ0FWVHIyRGtBRWRCV0JY?=
 =?utf-8?B?NWdicldoaHhKNC9kSTYrd3o2RGx2L3huRU5oUUxrVUFyemZlTGpWbnhwU2NQ?=
 =?utf-8?B?eUp1UXFvZ0R2VFBXRHN2cmxFNUFCTHZIcVR2TU5qZG1CM1ZPRjFFWnlQbk5o?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f1b1fbe-0fdc-4f4a-229d-08de125cef8e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:52:30.2004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cR6pyJpJuSAT6iuSJ1m0q8mTvybfhgRtgGx5TEz6egrPqdECczRoTfHpbqu8OGCTdkVSJxC21vfsXtdkqGZ30mGiTbNScsj+QwfUNXXmPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6784
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Update resctrl filesystem documentation with the details about the
> resctrl files that support telemetry events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/filesystems/resctrl.rst | 102 +++++++++++++++++++++++---
>  1 file changed, 90 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index b7f35b07876a..5e4a5d4bbe9b 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -168,13 +168,12 @@ with respect to allocation:
>  			bandwidth percentages are directly applied to
>  			the threads running on the core
>  
> -If RDT monitoring is available there will be an "L3_MON" directory
> +If L3 monitoring is available there will be an "L3_MON" directory
>  with the following files:
>  
>  "num_rmids":
> -		The number of RMIDs available. This is the
> -		upper bound for how many "CTRL_MON" + "MON"
> -		groups can be created.
> +		The number of RMIDs supported by hardware for
> +		L3 monitoring events.
>  
>  "mon_features":
>  		Lists the monitoring events if
> @@ -400,6 +399,24 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
> +with the following files:
> +
> +"num_rmids":
> +		The number of RMIDs for telemetry monitoring events. By default,
> +		resctrl will not enable telemetry events of a particular type
> +		("perf" or "energy") if the number of RMIDs supported is lower
> +		than the number of RMIDs supported by the system. The user can

I do not know how to interpret: "if the number of RMIDs supported is lower than the
number of RMIDs supported by the system"

> +		force-enable each type of telemetry events with the "rdt=" boot
> +		command line option, but this will reduce the number of "MON"

It is not obvious to me that number of MON groups will always be reduced ... for example,
this will also depend on the L3 RMIDs. Perhaps it should be "this may reduce" to not
create confusion. 

> +		groups that can be created.
> +
> +"mon_features":
> +		Lists the telemetry monitoring events that are enabled on this system.
> +
> +The upper bound for how many "CTRL_MON" + "MON" can be created
> +is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.
> +
>  Finally, in the top level of the "info" directory there is a file
>  named "last_cmd_status". This is reset with every "command" issued
>  via the file system (making new directories or writing to any of the
> @@ -505,15 +522,40 @@ When control is enabled all CTRL_MON groups will also contain:
>  When monitoring is enabled all MON groups will also contain:
>  
>  "mon_data":
> -	This contains a set of files organized by L3 domain and by
> -	RDT event. E.g. on a system with two L3 domains there will
> -	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
> -	directories have one file per event (e.g. "llc_occupancy",
> -	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
> -	files provide a read out of the current value of the event for
> -	all tasks in the group. In CTRL_MON groups these files provide
> -	the sum for all tasks in the CTRL_MON group and all tasks in
> +	This contains directories for each monitor domain.
> +
> +	If L3 monitoring is enabled, there will be a "mon_L3_XX" directory for
> +	each instance of an L3 cache. Each directory contains files for the enabled
> +	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
> +
> +	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
> +	directory for each physical processor package. Each directory contains
> +	files for the enabled telemetry events (e.g. "core_energy". "activity",
> +	"uops_retired", etc.)
> +
> +	The info/`*`/mon_features files provide the full list of enabled
> +	event/file names.
> +
> +	"core energy" reports a floating point number for the energy (in Joules)
> +	consumed by cores (registers, arithmetic units, TLB and L1/L2 caches)
> +	during execution of instructions summed across all logical CPUs on a
> +	package for the current RMID.

"the current RMID" -> "for the current monitoring group"?

> +
> +	"activity" also reports a floating point value (in Farads).  This provides
> +	an estimate of work done independent of the frequency that the CPUs used
> +	for execution.
> +
> +	Note that "core energy" and "activity" only measure energy/activity in the
> +	"core" of the CPU (arithmetic units, TLB, L1 and L2 caches, etc.). They
> +	do not include L3 cache, memory, I/O devices etc.
> +
> +	All other events report decimal integer values.
> +
> +	In a MON group these files provide a read out of the current value of
> +	the event for all tasks in the group. In CTRL_MON groups these files
> +	provide the sum for all tasks in the CTRL_MON group and all tasks in
>  	MON groups. Please see example section for more details on usage.
> +
>  	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
>  	directories for each node (located within the "mon_L3_XX" directory
>  	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
> @@ -1506,6 +1548,42 @@ Example with C::
>      resctrl_release_lock(fd);
>    }
>  
Reinette

