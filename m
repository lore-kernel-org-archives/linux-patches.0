Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD96827D77B
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208504; cv=fail; b=X1PoBQL2CTgSvmW/WTKX94TgmlRNZf/jXskh/vU48n42hrbsZXBdQYIDXTeLYxaKjv7Nk4hCSpK8zjPP9SeXX9RDn6OIzEdEbwGF07aAcaNKu5cBQZ4tKs7IZkLtkBQ+mSa+/mjJDvVPojnQBu/RAF7WJKPJn8fWw3P72p5Q4s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208504; c=relaxed/simple;
	bh=ERVlIpC6+7T4DUyB0WiT1y6EIfvzBULbU4cklGG2Q68=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SRA3cVZjlin11AbaRawFBsz/VPkMMvDLDsTzSSsmiaSok4y1smpzNcOxkeoALb5cX6M28lMZIGQlAH0LY0cYoSWpwnzcXL7/5QLrRcu1/t7UI/nFCpgeTR6vNQNvQGbiwirEauY6MVWgb4rWOekznQKXs59E6bThPJB8NeUZ+Dc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T4+1lb5t; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T4+1lb5t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208503; x=1786744503;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ERVlIpC6+7T4DUyB0WiT1y6EIfvzBULbU4cklGG2Q68=;
  b=T4+1lb5tux52vmdHuNNnfqJ0kBqPQutGirGtfwcbV5w1i1uG1U4iJUL+
   x4cIE0CWD/uy+x6FL+O1uG+uyHe/jr+fDXnxtbt3djSKGOqKKoePFzNWz
   765lY5atuS8tVw8e/pVJGy60xa52SkeU1nSw2wovMIKTajCkLSDdm+yz5
   QTgvlduq28MshE3awjW706SAHWQHGKA1tYTCM3VputksQ23my4ycQnZqb
   LjAv7zQmBtaCiaevclTL6StRjrtod8JtZQSFMcg9CBL1JSkjTXOT+h3KM
   qJnP8VnXTYUpHDDGAstMCNsKCqtpyrKIWKHyPtTnt/kfz9EbMKCZEiSMp
   Q==;
X-CSE-ConnectionGUID: gikxWKGQTO6L3JS85uhkYg==
X-CSE-MsgGUID: BR8VFqmcSwOfip4t1/qCSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="74988786"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="74988786"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:55:03 -0700
X-CSE-ConnectionGUID: r6mVPbSwTEC7Dyf0ESuUyA==
X-CSE-MsgGUID: bpIivc42THmV6MgYrdM0Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="204052110"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:55:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:55:02 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:55:02 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.86)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:55:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Go602hG/WuJ1FeQhL/PRFyxLhTz7qZURE9Cv6YDP2MKpug4WR9t6jil++iOIregFdOb0GFglyjeIeFBwrKtb/dhZBM9020HmtPADBzpuZs0dftktP6LbQxU6Dk4nOu1hrNVpcougdbnDDQD6zg8LKQMjpDKYWbdDwkd12IICQjY7+SfWCQsmXKObZTlvbRV84N0Sr5VQ7e8eOeH4K2o6PjKt7p0TtG7lOW5Fiqs7BYXjFW7eqAzbLBIvXFLbQCp7B2ySuJoXnR1iqy/ho7MYsZ3H3KDjDeWA2t2z42B5daMeoF5zevy4aupuFrjsKvAcjs6g+eovVdZU1C68QqhWuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4424B5YyUyv9pmf62/0k/Gja2rGHve/h7JWGy8xxu8=;
 b=MTOlSv9zk/qFSWkX95w0P5SK1hyq5auJIEe/5IVv7vUpj3HMYZph7+Yf8QZjrkWwOZXobkIA+8ddrQhmugZkysPg7nB3LW20Yt9kszsD9XtO2y3NryjhC9HZF0pZ12qINdixqIZCzGQifSISPGXvo9HrOzZsFE+zxCrAeKVgt98jV6tD7lhS8Cdmt7ul/WU9utogVSFSWZ5cKwG2F6lAuriOeKgidYflF2SFnusoDWXX0Gi1I8aExLwZRo86iBew7DORb82o5dKokOTt1ANmdgIBbFFeGOX45qKHlklNiYu4BFrf3onaB004+phecd4be+REBf9u160OL5cfYsqyzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8467.namprd11.prod.outlook.com (2603:10b6:610:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 21:54:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:54:59 +0000
Message-ID: <9644f34a-db4d-4bd4-b5d5-2e5a0eadf7e2@intel.com>
Date: Thu, 14 Aug 2025 14:54:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 26/32] fs/resctrl: Move allocation/free of
 closid_num_dirty_rmid
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-27-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-27-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: ee17af5a-7ada-41a0-31db-08dddb7d370f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eFBNQ21DUDVIbHc1WWVQOE9EKzFUTWlVYldrajVJNHBLWjhBY2VJNjJuU3hG?=
 =?utf-8?B?cnY2SEt1SHlERXdBZDV3VHlkUjYwUE00cEh2QjU3bzhjaDdqOWpCU2dyb0hi?=
 =?utf-8?B?VXRSV2gxS21GREM2MGtSdUtaMUYzdEt6NENrZGU3SDJ0Zm4zWW1nRmpTZ0t3?=
 =?utf-8?B?bFd3WXcxeFBlb0UzOHczdSt1RElvc0tLMWtkb1hGaE56SjgvZ3NNWDRUOWhl?=
 =?utf-8?B?U3ZFTHNxTkVuR0x4ZXhEbDFSY3RUQzBodGowMXh4Z1JwbE9Ja2c5ckxkT0JF?=
 =?utf-8?B?YXdteHNhalZWNEx3dS9KUWtDd0ZGVm03KzVycVpPbTVldXdxWkdPZkZ2aDly?=
 =?utf-8?B?MGR1QjYwbytVTFRSSFVrdlJxTmRjaEpKNTFCdER2OXprY2xNK29JdjU5Wk41?=
 =?utf-8?B?L2wya0NoR2RuTHlQbGZURmROVHpxWjRKM3Nob2hDSWMyUmxVSTZYdXo4T2lN?=
 =?utf-8?B?QlVTYW5ZR21MZlBtb0N3Q0g4c3IxV1ZsYWlwdjMxL3NjVzVDek8vQzdIaXV3?=
 =?utf-8?B?MHdqOU1GU2xnbHdHNlRSNWU3a1lQS0tISTlkU1BiQnVQdWQ4d3FtYVFVREJ3?=
 =?utf-8?B?UVJhS3JaRjljKzcrREpJK2ozdlRublQzWG9kRGp6aU5EOFpUajZRMGlhMVFU?=
 =?utf-8?B?TTF6cnNPMWI3aDcvOWNSaEY4SDJMYVpianhlT0RpZEpMN2JtdEsvV2FnYndv?=
 =?utf-8?B?eFl5TnlpWlhDUDEwdVV5MnBnZFJqY2NzWVphL3cvOUVQV1c4Rmp1bGlReDdV?=
 =?utf-8?B?azF2TXlZc1h1UmU3NDdsSldxc0M3Vy9SVmR0cHBkaWVZZzBGRU9jVGc3Tzlw?=
 =?utf-8?B?a1pTUzhnTEV0MzZCVU1CUWRGNjR0Q2IyZHFvanN2Q2lGNW1McFZya0pKc2dx?=
 =?utf-8?B?aVhiTFFUcUtaQXRKZE03TWxYbUQ2akZwc1pzbktQSmhHTlo0dnlWb1ZoNlpI?=
 =?utf-8?B?Y0lhdXVrTXk0TUhVNkdlbVE5K0xPVWJsMUk5RVNJeVNYaytKOTdXSE5MYkNn?=
 =?utf-8?B?QmM0TTI3bnVuMlEwc2FDU3hpZTRzdFRhWFZQSVpBZVA0cG9QTlZqMlZXSUpL?=
 =?utf-8?B?K083cmdLRForUGtUbndOeTlaYkVKc2ZXTjhuNGZ1OUNwZERxekIvWC83OEEw?=
 =?utf-8?B?K1Jka0FhdXJxcDNhMlpZMmZiQWF5OEFKN3Yxb2hiR0l6Q25HVks5WmJtb0Qr?=
 =?utf-8?B?bHZHV2I5UXJIWjJZdHhRYUI3dmRjSmlVU2Y1VldodU1DTmhtRGZKUEVGeERv?=
 =?utf-8?B?NXBpSmxCeTQ4L3RPTXRJYlZMZSt0Nm9TdVJ1UDNCVnN1azVicjA1Rk1EQzZT?=
 =?utf-8?B?TkUraXhuY21vYUFydTdYUEg2Vzh5U0x6UmhVdzF6WjVmODFCelhtTHcvNnZ1?=
 =?utf-8?B?NzBiL0pCeEVRZGpwVThKanFsbUppTWNaaDkxek1QOWYrNEpXQTdBUWR5YTVB?=
 =?utf-8?B?U3NHT2IrUUdDYXdEbHVRcWlCZDV1RWpWdFk0MXBHb2o4UXgweElmZW02REky?=
 =?utf-8?B?clJwUSs3endoMllGenY5THpabHJpeTNnejdpYnpaeHhjTS9CdU1kTTlJYWx2?=
 =?utf-8?B?VVFsVHpJZ3N3S2EvSEtJZU9HNUs4UldYUWRYSmYzTSt6VTZOaG9kRnZvTHR1?=
 =?utf-8?B?cG1hZVZta3ozK3cvVy9PTUROK05JLzY5OVVORDhTck8vMlNwS1RzS0Q2bldq?=
 =?utf-8?B?dGRPUVpqRzFYVldQMTdMcDBYa1FJS3pPRmtRVDVSTjVxeXA1eGorYllPV05i?=
 =?utf-8?B?cFJXSW1FMi9FRnZRbGlKUFI1ZmplZ0lwSG9qS2F4eEFGamxCbTh0OUJuUUdB?=
 =?utf-8?B?dUNBSTNpNGtGSkM4M0VrTlRCK0lGM1JHZU5Ta2hPVmVPdmFQNUFqRXRWSGps?=
 =?utf-8?B?YVpxTzY3YUVNSFZ5dnVrSlQ4bDNveHFoZGo3N2ZubW9odjlGV2ozS05RUWlR?=
 =?utf-8?Q?z42KBGlO8+k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2Jmajd2RTRROW1YbFdtWjRHKzlWV1BacWExWjhhbWx6RXBGQzBXVXllZi9Y?=
 =?utf-8?B?VmpQb2wxQVpJMXJmbWdBT2kySEx0SHAvNThKRDcxN090dGlybjBvRmNqUnoz?=
 =?utf-8?B?MGRlNWZ0Smh5NEgrV2ZZZndqMjdENWRhMXNkeEwxbCtobDczcEZUbTNBNlFI?=
 =?utf-8?B?NnpqdEFKWXdCZ1ZWeWZHWXlSalo3a1RhcHdtd3RydEUrSjZQYThIYjRUM2pM?=
 =?utf-8?B?VWlNZGd0ZVdNZTdtWS9sR29xTklBYmkwc2N3S3dvT2lWc0NheTE5MEhTMDFW?=
 =?utf-8?B?SGVNYm9RYkpXcUlZZlVkeVpuMElDWTMzNlBPcXdRZUtzbmVYMVA4dHAzNlZS?=
 =?utf-8?B?eDc5eFVsLy90OUkxcGR1dkY5N1ZYSTFqOEVXbElmVnlpRnVDTnBmTHFvelpk?=
 =?utf-8?B?cVVuMC82eFVyakRuZm5nN2tqNWt6RFF0WXF4d3BZT3pWaUk2cFBQS296cjZO?=
 =?utf-8?B?UG00S0MxaEF2a2V0Z2ZCcEoyNWU0Q3dhVi9oSXltcG5XTktwZHhRVWxobXl4?=
 =?utf-8?B?bkxtanFZTzNTRWN1UkZNSDF5d1c2S1NlV0c4K2tFdjA0Q1FtYzRHbEpNaHJj?=
 =?utf-8?B?b0ZMVCt4RHVPa3UzZWRwZ0NwTlhGanZQaFFPU2JCNzBQUVdSdUlSVk9Idno2?=
 =?utf-8?B?SzlCb1o5aFVhK0xLb0lNZFJ6RzNweVU2LzY4SmdWVGgwbnB4RFJNY1BVZkc2?=
 =?utf-8?B?QTNxN2g2dDVPNExIY1E3Z0RacUJFY0RGaEJIZ1ZoOHo5U1loNmZvVU9LbUww?=
 =?utf-8?B?djdRMjdQRWtIR3gxdUlSRGxsM284dDVxeVNGejNuOUZkM3hTNHlVM2NXWGZ1?=
 =?utf-8?B?NWVpUVVFVnVBQzluLzd2bzF6ZmpuRUxaL2dQNFRWdWg4Z1FnSUpzRkN6UHZx?=
 =?utf-8?B?bUxKUmw1N0pxTFgrdHI1eXNKeGpNaGpaYW9SZ1NzcVluZmZIeVpCUllYQ3pj?=
 =?utf-8?B?ckFKa1JmU0VXZ2tscTNRL3NFRm5TTk9BYTBjdnZNWFcwN2wzL1J1SEVjdG5N?=
 =?utf-8?B?amZDUG1RSWhsSDdyZk9GT21WMXM1VXM2cmRyRWNlSDZCRXdoVEtpS3NLMm1t?=
 =?utf-8?B?N3FqSG42dXRuWTVCeDlCd2hEQXhwMEh6Q0RhWDNiVWJVWkEvNWY3VEVuUURl?=
 =?utf-8?B?K2lUa2pjZ2tERmdxVkFJaGloMU0xRENWajkrYmdobjFGZUU4a21RVmVibkkx?=
 =?utf-8?B?UElpVmhiQi9FcGtldVZ4eW1yYXBhYVNOR3FjazFrVzhiTFk4ZkhvREo1VEpr?=
 =?utf-8?B?dFhESGRUVnowNk15VVpCMHMrSVJnQ1M0cDkzYUtoUW4ybHRkWmN4ZkdYY0M1?=
 =?utf-8?B?U3FlOERHQURqTkZGcWFmZ3B0T0Z3c05qSjEvUmtqVzJaTmYrNFR1cWdBL25u?=
 =?utf-8?B?S1RqQXZtdkN3bVZHbXgxQnE5MHNYVXE4SWdlV0N5QWlOOUhSQ3lmRWVDYjdm?=
 =?utf-8?B?b2xxdHhQQjRreHlVWmJIb1Q1NSsxTjE3b0hIYUtmK0oxZ1VIUFBaQWNJRnBs?=
 =?utf-8?B?TkdFeDA0TFNmOTBidE83ZTFNMVpuYnc3aUswUVFicWVLVGZoL2ZLVDNEODQy?=
 =?utf-8?B?TlA5SmhzRjhqdmhudWFnbWt0OVFKZmJMVHJPZDNDRE10MDd5aUNDd29BUnJ1?=
 =?utf-8?B?N0t4dE51NVcrRFZscHp6ZVU0dklvTkI3SDNYQklZcTNHYnpBS1NTTG5zUFVG?=
 =?utf-8?B?ZVZUSy80VWhQUUI5TGpBMlB1Qm9PZ3N1L0FYb0JqU01wT3lOMVFaOWMxWTdB?=
 =?utf-8?B?aDk4djdtbmRoZUlDekdkUHRiMHVma2VxVGtZd1J1TXhncm9sNXE4YUVYU3hy?=
 =?utf-8?B?eElUY1pQbXJOVjRHSkxvYURwMUFqSi9TS05lclREbEdtTDBYOFBXdHpHZWJa?=
 =?utf-8?B?RERZbEREQ3dvVFp2c1c4MDVPZTFCd3k1UEd3R0VMS0JrL3FPbTg4dWlkeVRt?=
 =?utf-8?B?bzQ4UmpndXpvc2g4V0MzLzZJODB4bUwzYnVld0tpTkE2UCtmb0tuZDcwN1RR?=
 =?utf-8?B?UEtsRUViNnVLb3d3aXdoWmF0ZWlyRitONGZrNTg1TjFvZS9BUW1iOVJkVHhX?=
 =?utf-8?B?OXVNRmhmamxLbUFKRmcyTXh3UEErMHpFaDNLVkFma0xDcUd1aVd6NUhWUDJI?=
 =?utf-8?B?bTJtZzR2TWpqZC9BRjF4Wm8vYmM3NDNFM0pyTW1KREplbURjMVhaQjE4VVow?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee17af5a-7ada-41a0-31db-08dddb7d370f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:54:59.8729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxZExbLHmu19/oSYfBzVVXuT0aR0xEg5w75BJAPdAjrvB9HYVArfGkE4N5UC+5FksCmR9fhdsgMmcMP5cOY8DUAhc57q8Rq5AaC3NXKT6OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8467
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:17 AM, Tony Luck wrote:
> closid_num_dirty_rmid[] is allocated in dom_data_init() and freed by
> dom_data_exit() giving it the same life cycle as rmid_ptrs[].

To help connect the current flow with the planned changes mentioned below
this can be:
	closid_num_dirty_rmid[] is allocated in dom_data_init() during resctrl
	initialization and freed by dom_data_exit() during resctrl exit giving
	it the same life cycle as rmid_ptrs[].

> 
> Move the alloc/free out to resctrl_mon_l3_resource_init() and

"Move the alloc/free out ..." -> "Move closid_num_dirty_rmid[] alloc/free out ..."

> resctrl_mon_l3_resource_exit() in preparation for rmid_ptrs[] to be
> allocated on resctrl mount in support of the new telemetry events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette

