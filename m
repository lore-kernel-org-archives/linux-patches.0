Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628211487C0
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358307; cv=fail; b=d07WuK9UUxF+Y7BYlI+BNTW7hBOVr+wPMkkbzDattIcL4lecUvMODuH/ENn9oUNV5ZQgxGC4y0OCWDZDpy/H31yRmrtC0/b8+Tq7iogmRCp+n+FAL+MqFkkUXltJNUey/yFSJ2Ma0Ms/106RQB7RU1eTDm29kqwbS2Gr10sIO28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358307; c=relaxed/simple;
	bh=us5iPBOIandWEaSGkm8vowbIwqE+TlW3Gxhz5xu29FQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VKblmseQdEDce/QFVNVEcndowvPW/bCPimoPPgF5t9nt4M1mBfs/AWjzYoy8GzyCbuhur3/WI0S4TCY8Ao4HfCKQ8Q9ryDgJUJnPJQMc8ifh59kgecEQEf+5t7cnys+yj9BOSX9BoVEYVNG8ZsdrT8tk5SBevXf1GFG0SjhRQ8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YqPPJGnh; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YqPPJGnh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358305; x=1750894305;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=us5iPBOIandWEaSGkm8vowbIwqE+TlW3Gxhz5xu29FQ=;
  b=YqPPJGnhM6DwaJDCbIku9hcQ/0CgJgU5kzuHJtAWOZRqyide4OLpApJp
   3srFuJeTx3gNeMq06tJenhCiFPHiXSfLMkt1Ty03iFYKx6DwFs3TFBYC+
   D5c83d9pC6WXp4wxxZYu/0THCsOzNZkgsaYGyvwsbJmNsebTJN1a8tGJ9
   RRHeC8Ab9fMRHUl1pw/Yye2+MDPthtd7y2Ri59DbJitzv4pFoD7qWI6wu
   8xy5obGitGnXADUpmhmXJwvjo7qF6HjlTBEwFyrgtarBhiW3HCP6svC1C
   FnvCkGrkllK5am4mRIlY4v+QnHNpBqPx9dx/SfVXY7Dn/K6rXvEAZF8PV
   w==;
X-CSE-ConnectionGUID: +BEuWviyRFCGEiNtx9e4ew==
X-CSE-MsgGUID: yCr5sd08Sl2zlvVSD1YHZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="20287460"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="20287460"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:31:45 -0700
X-CSE-ConnectionGUID: eYVP3MUWShuN7Ws/c0NqxQ==
X-CSE-MsgGUID: tig42uGuTHO6W3v+fLlMlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="43780402"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:31:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:31:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:31:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:31:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:31:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJ2EU90BMOebhesplp2UEvY0zyqC1K47Dhbo70oy/sN0Yk7rKsS9/cNDoklLvsExIc9sLMVB6tGNlS5Nw9bwzRC3W0dFrNwD41pYRuvlUINbQ2q/yg6RrnXSBc5UWDnrLctCvA8dex3/MAOFYbYhnb8Cb9ei5Bei3xU+h2mouNwiOMD8yUOLQ5FoXAfRMUvY3o7veImcRZYBmEjvasucmnQI2GXbMmAX4/qRo6NPdTL4elnIgO8o1oCi3xZZBK4i5r1D/tCdwjr5HxJnRN+ZbNqmLpMtCXsjwBcAqLqZBwvoBKEjAMTP49BmoYTLqQjBqauQ5zHEbw6fOAX8hWuHqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydAA8aUf+aQ2N6hxKsjQpP7xLx/ZPszT3Akt1mfh0xo=;
 b=D7QPIRB73RaM/5ylCUII/Rc5NU2l0OFWfAk9DwwWBlkpsDxLVQ1ZboVJSEBoK0FG3jGXwesBUn6Qia6K7G9/NnYzUv6QaH1X3jgcekc4qXHoAbsuZj4ycDPnNyJTMiGsJ25WT2mFTzAUsWbjW7F8w8VRjfLguNnl20P5TDVIje1W91IV0kMFYUFE3NjyDztX6HlA3tNOiHdoP70t4+Du36QLxRrV98hIkUZkyJtbh9NJY4GNhC/UPk7hDW+VaMzhSS2suCEAjvIAP+49HrqA7RlzTVuOozNzka/hBnAIeE9OildIvA1MXw+3jchmuxW5zB27C0beUHNG+ieS6XCGuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7170.namprd11.prod.outlook.com (2603:10b6:930:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 23:31:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:31:41 +0000
Message-ID: <c3596297-0728-4933-8d13-b988c2bc4175@intel.com>
Date: Tue, 25 Jun 2024 16:31:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 13/18] x86/resctrl: Handle removing directories in
 Sub-NUMA Cluster (SNC) mode
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240621223859.43471-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0250.namprd03.prod.outlook.com
 (2603:10b6:303:b4::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 34fad308-7378-404f-86a2-08dc956ef7a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L1d1cFpqWXI1UG1ocDRFZ0kzSWllM2tKdXh6ZmVlWGZxcTErdVpCdEVzZHhF?=
 =?utf-8?B?ZjJMQUdTVjd6dE81bXNXajRCcHkrSzBtMFd6WDJaVmdwZGFFU3lWSUhqWjhD?=
 =?utf-8?B?NnVKVFd4eXh6SHFvNlBmTm5McjFOVHgySnBrbGZnRTRaTWR3Uk5ScXFmNllF?=
 =?utf-8?B?OUxFK3BnQnVsRDJXWjdiR201UGpPcFVhK041Q2IwM3BPeEM3aTdXNUk1bkx1?=
 =?utf-8?B?NndLMG1meXdCeVNkOHMxR2JVMEFqbUw5NlVMamc1TUVDOUZicitOaThFaytE?=
 =?utf-8?B?dmRyTEl5d1Bpa2F5NFZjbTdoZlpuNnVxM2MyNG1qbk1XV3hQS1Y2cTFMblRv?=
 =?utf-8?B?ZlUyYVFGMGtYWXAza0plbVFtcFpZVEt4anhuOVVmeUhIcGtndXNrZ0RtOXUx?=
 =?utf-8?B?b3VkZ0pITDlTZ3NEQTNET0lRWGR2dnJJSC93S1FCT05ObXNyRUNoN2psS3FW?=
 =?utf-8?B?SmkrRHhiMU4rTGpTR0VOblZTWlUxa3ZmZ2plZHhsb3l0SnVoai9PeHpyVzFp?=
 =?utf-8?B?cURjUkdacFgxUWRjajAzcThFL1h5WkViNG1BMnlocE5xWXhUSVVra0hmWHVD?=
 =?utf-8?B?bWRBY3hmTFVQVmo5c1h5Z1VmRUVsWW5PSy9uZVlUWnRtMWN4NnV6L2loL1RU?=
 =?utf-8?B?aHluamtkalgyMitVZ214RVkrVzUvRFlIS2lORDFwY1d5K1Rzb0Jya3V4eHJx?=
 =?utf-8?B?V3dOMlQ5N2xGTzZNSHBHcHBaczk3YjZRUjhNVmNmN0pLV1hOMHo3YVdLWGJx?=
 =?utf-8?B?aG5DR0JLVjVEckJuNFZvbk9hREpkcWtCM3NoYkJuZTVZVmY3UVVnbnRvS3Yw?=
 =?utf-8?B?aU9hS3pvZVh6bHpiODI3dnNyeDJzV2RFdG9VZ1BaM0dmOFhZd2t4enZOZTJF?=
 =?utf-8?B?MkduMW1MRWVFaFpYQmNqVUh2RTZuZ0VxNVFiUHZ0S0ZmUHd1bTFoWVJxMktL?=
 =?utf-8?B?cFBpZVpCNjQraDZVcVNRMlNCZUMwdmJsQUtiVmdscS9xWkswZXhxYTc1Rlor?=
 =?utf-8?B?U05RQ2hwSXV3WC9rbEt5aXRDUGR4QzhoNXhpMFVxdU1MTEZrYTVKNzlIWGVr?=
 =?utf-8?B?UFVrVlFtUWxGdGczZmtNYktITmMwS05DY2VGVHZXcFBSUW41Wmx0b0VPck9I?=
 =?utf-8?B?V0JUSUpvT3lET0xwSkNRbis0alpTVWh2bEU4eVNnOWNpU1NlQUdHdjhMOE9o?=
 =?utf-8?B?R01IK1pLem9lVFlhLzB5TUpjWVVLQW1SZTl4cWh2QmZzVzk2YUN5aks5U3NX?=
 =?utf-8?B?TG1JVmljUlhGZTVwUCtqckRYb0tXSEZ6b3BRMU01OGdsYUtmUzBJQlN0Tjhh?=
 =?utf-8?B?TG1TcEJxcGQ2WnJ6NjJHem9zRW94M21ubDQ0UXdCMUdCL2QrZGxWODhrUDA3?=
 =?utf-8?B?c0NsbVA5dDdNOW5rc2NkZmcxWW0wVHM2cldQWmEyZEdOSDRZUUVIWWora3RP?=
 =?utf-8?B?WjJUMUp5eGtvS2MwUXVGakpTYVZ3NFhNVVZkQmdUcE04VE5oNWpDMEQxR0hh?=
 =?utf-8?B?ZjRXWUZaczdzV0tCaVN0K0k2WDdCLzRqem83WU53eGhuY1htZXdWbmUxYVAx?=
 =?utf-8?B?eHArZEtKTnE3ZzhQS0JYRHhzQ3d3N2I0WVdraHpZTVQ2NlFCa0ZvQkJJaEdR?=
 =?utf-8?B?eWtNUy9EMU85Y083d0dZN0dIbXp4d01kbmJGaE94QUxKL1ozeTBaOUdKaVIr?=
 =?utf-8?B?aUZld0dTZTRkUGdhS3dlQTIxbTlneGQzRnVKS21pTXZNWDNld3BrT2FBZlVX?=
 =?utf-8?B?dkxoMnk4algyZjd1WHRFQ2piUkhqVHo5WEIwQVN3ekZxWkttaXl5NzBQU29H?=
 =?utf-8?B?RFZoMnR0MzVETXcraTFkdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yit6Y3R0aW1nU1RvVU1ISjQyemxJZTJvVjRvcDN2alFySUtvdGpzZzMxSDlH?=
 =?utf-8?B?bGN3NG0wZVJ6aGRZNkFRU2lTRWtKUGxvaElNRW1tRFlMRkdKU2haWnZ0OXhV?=
 =?utf-8?B?VFBDQ0NIdm5LT2daSGVnWk5OVUFPRVR3WWkvRFNHVit4b294ZGQ0dDJ2YmZx?=
 =?utf-8?B?SnhYbFdsY2dVbFRQTG94TDN0ZGxIRXd4UnZVU3Y3Ujhqa2VTcFNML1o5TWp0?=
 =?utf-8?B?Y0tUSUpPWWovWlMwam1CVnNudmtnV0FKVm1CUUdtOUlWbXNjUDY5YkdBZlNa?=
 =?utf-8?B?ZGIvVDBNMk01aWNRYUxOcFpsUVM4ak9PSkRDQjk5cWQ2b0ljMi9yWlVRVkEr?=
 =?utf-8?B?SFd6TmcwT1pSTzFNbk93S25KMUZBVEZQUXVSbU1Wdm9vcWFzQUlxV1FiK3FN?=
 =?utf-8?B?SE9zWDFFYU5GTmlPMkNhcjNrU2orTlQ5QVRCaXlmWi9IM3hjVEVBRm9LNzAr?=
 =?utf-8?B?TnNacllnSzY1eXBwQ3RHMlBFdUdHa0tDa1hSRFIvUTcyeVRxWFlneG5GVDRP?=
 =?utf-8?B?bDF0TVRMbkJhUERKS0FmR0pCSEN3OUd6MFo0OXlwL3BhaGJ1eThHamd1eDE3?=
 =?utf-8?B?RE15WGpmMlVXSDJlNncyUTUrYnBHQ2FLNE1jeVNCZEVNWUR4MUdNaXM4ak9N?=
 =?utf-8?B?TXVsOElNdUJPaE1ya3pHM3JzZzdZTm5rTFJvYmdlSEZZbDlaZTVwQmMwa2ZF?=
 =?utf-8?B?R2hLWHBIajV0OVhRQlFxK0d1Z2J5cFprWHNyMWxhU1dSQVVxMS9uZE9wd3Fq?=
 =?utf-8?B?am1WU09SU012SXk3dE1yS2d6RkFjU1lVSDM3dG1jTGVUTVZ3N3duTUV6MkN1?=
 =?utf-8?B?bGZvSGIzYkxLS2pUbisrODh0Nk5GckF4c250SkJ6d0hwQ0wyckw5a2NibERT?=
 =?utf-8?B?L3g4eWd3eldGMG9HbGZnQkVEU3VEckNtdXV3UzNPU1BjWWc5U2s0MlRwRkk4?=
 =?utf-8?B?QWVzQVJLeG0zQ2xVNnV0ZnI2NTV0S1BIbW1jZ1VoZExSZVV5NGlUMEhHZGYv?=
 =?utf-8?B?dDh5bE9NK0JncEJ6djl1N2hLLytjcW02WHcxdUZITnpuczMwbjl1SFZzMXdv?=
 =?utf-8?B?WU9xemFsMFJuSjl6WlorUGZPK0xyaitFc2JEckdmam4vTGc5MEFESzMrMGdp?=
 =?utf-8?B?bTNIeEVnRUZCaXc3NkV6ODFDMWd5aG5kcFkvd3RoTUNkTVU2U2Y1UTRLOW9t?=
 =?utf-8?B?b2hjV0gvcUZNTW1vejc1ODBMQVhybTk3TEZRWDI5QWhHbldnSEt5Q2x2RVJw?=
 =?utf-8?B?V2JmSDZCRzRKL2duT2dlM1lqRTNhK0tNU3Q0Wnk2anpNRGFjLzNHOFRTRXh3?=
 =?utf-8?B?MlVyeFdQRkJJWFFzSnRNNkVYOW0ycEUyWGJOcmRoT2FyOGN2ZUpEamlFSito?=
 =?utf-8?B?SEY0S3hFTWFzOWJvQk1nZ3MyRk9yWEdpZVpHRmZPSEIrMjFDZGZ5aG9HLzFz?=
 =?utf-8?B?YUxyZG5VNmU3T3lxM2dMUnlqM05xenV5MWdPb3ZqVkkxY2laN1pjT2tqcnc4?=
 =?utf-8?B?SGs3ckUvRXAwY1diVlZ2Umsvbm43T2QrYlFQaUxPeFBtOHhpWTExTGlsR2E5?=
 =?utf-8?B?dHdLazBCZ1VQd3VLdnJTanUxTzR3WEhPRnlieVEwYXdkZTZCc05aNnBYYlpV?=
 =?utf-8?B?eGpCWUZrNkVmZFFBQTltZUpNTjQ4U2ZCZmxOSHA1Z0lNMUxyVVllbnB3a21P?=
 =?utf-8?B?L3NZZzBKNGN3VVVuSkM2VHBqVzJMUktyYzRCS2JjQ0x0cm44VWdMdWNhc0dF?=
 =?utf-8?B?NE4rajFDcW9sNEVZWEhUUExUNUVPRVFuTzRud3orQ1ErZWpCeXN6VkNRd1c2?=
 =?utf-8?B?aWoyVkpGZ1hiY1lHdWZaK0g1QjlsZHF5dmlBc3d4VitSOWUzbTFKOGg5NnJE?=
 =?utf-8?B?bGljbkdiVG9BVkY0WWVMYkpkN1I4Snh3eUFyNUd5ajZuQkhVL1lKL2JlT1hQ?=
 =?utf-8?B?MUFlOVFhKzkzcUs5WnVSdmFGQ01OQ2pjZmx1NlRmdDJBQ2krQzF6bFZFTkFt?=
 =?utf-8?B?THhxcFRuenArZUkyM3VCYkJ5VGZPTUdpQjFqTG5nRHhOTTg3WHR6NU1uWGFN?=
 =?utf-8?B?b2luOS9iUDVlRHhxMUJHcXNJWXB5ZzQvci9FZElCbFVZU3ZIckF5QUQzeTF4?=
 =?utf-8?B?OUNzNm8wQS9yeERrYWJKQmFOa0ZQOGVRTTYzLzltQmtUVGt1TWEwajVPZUJQ?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34fad308-7378-404f-86a2-08dc956ef7a5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:31:41.4816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNEU9AA4dy+PCd0feK2k8lPrnZzrg2Xkjmdof1c/mskLnaXptsb566e9y4DGm7vsUjYjcu72UVHvgb0kZglAzu5MwbtvMYNyU597OtgVZNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7170
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> In SNC mode there are multiple subdirectories in each L3 level monitor
> directory (one for each SNC node). If all the CPUs in an SNC node are
> taken offline, just remove the SNC directory for that node. In
> non-SNC mode, or when the last SNC node directory is removed,
> remove the L3 monitor directory.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 39 +++++++++++++++++++++-----
>   1 file changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 2591a6876232..14482d88b68c 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -3008,20 +3008,45 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
>   
>   /*
>    * Remove all subdirectories of mon_data of ctrl_mon groups
> - * and monitor groups with given domain id.
> + * and monitor groups for the given domain. In SNC mode just

I do not think we want the Intel architecture specific "SNC" to be
a "mode" of resctrl fs. That means all architectures need a "SNC mode".
How about something like (please feel free to improve):
	Remove files and directories containing "sum" of domain data
	when last domain being summed is removed.


With mention of "SNC mode" removed:
| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
