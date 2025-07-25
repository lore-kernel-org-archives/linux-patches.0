Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189925F97E
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486194; cv=fail; b=NZZvzmEIhRxCFkqr9t3FBzb+15atDEb83wo571Ndnskei3YorQkqWHCmXxDFZogVFQl3pVqcvD7VIV+F5Kq9hbfoiHcQgIZpTd498gK/ZBU9AoRKiwu9nSCje4GQ5IyjVB/F6SgvJjbXY8IC8tVkcY/v/LYl9tB4pf5Nc0+Fw/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486194; c=relaxed/simple;
	bh=w61q/6ZDh+q5rg/5dzPB0BsvcFD3m964V9ybFcbttaI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G8Bk9Cdf4Tp9O1UHpbTzvuiTr1B2LbpwKttbmeny4dTR4RwZIjS/fpDIiSe4gJrA4YVume6YqvEup3dufiHZr/BfBUFvccyIZb5bL/Nus6hjrlykn8h61IGNZ91Ofkp6PfBBzMVBj9J8X+E/urI83TfNu3kQihIOAEOdLXGzwi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KMsdFDpp; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KMsdFDpp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486194; x=1785022194;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w61q/6ZDh+q5rg/5dzPB0BsvcFD3m964V9ybFcbttaI=;
  b=KMsdFDppNa5HHPQuFtdPOFul+kkbL1Fpt6PAlCUVdpl8D2YGhfyVsHT6
   AiGsPRiQGBfqYgFR5oUiH8SFSxSP+Sv10/PNH9EELsild7TiLbLDPEdxx
   /HI0/Re4FpnA2o6jz8A/QJSlZSQ47LWIMx3pUTA+bWjrrD1Dhm6BwTJDn
   kGEk67uKZNTBPkY8WYsQxMaTC7tCROTFkF/XqvmLZZJp7xxYQHcvxkxmc
   9cPszdMREIDVrvJrw7pynu55oCfkiTiV7fLP2hng76MdN8XfMleNPJv0i
   5XNCwSJuywC4xQhioUjiH6jF6N5fZ9G1msA99O7WMuJS9GMMleOUHfiIB
   Q==;
X-CSE-ConnectionGUID: pAVSn2a1RviTONy/QMq4ZA==
X-CSE-MsgGUID: 4YmR13KVQpuRtbmtbiW4EA==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="43439983"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="43439983"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:29:53 -0700
X-CSE-ConnectionGUID: NA1hixLKSVOHZOJVvio/Mw==
X-CSE-MsgGUID: k2omb39AQFy+5T9yT7+yAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="161424712"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:29:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:29:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:29:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:29:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IezG+0xV+883tKvi2ow9XmuWvHNJq6TGLAdTgCdPeIz5qg0nwnz6NCsLP2uy0D5rRNFSICFZoYZBZ7aejL7KgqONsXSXMW+fCcfK2v/kvSIzyiO1g7Qvkh24MAKta7Wy+n44So24JWJ5NoKWRUQKziCqKs7zRKZXSES06pFlmjVrovqc3ExtD6bXBOAyaaxyvQZpVyoP+f82EtKFrcB0yPctnI9kmNuxrOogOshF9Nu8ver/tLjU+wdqpFKIpD1n+LYUjsDRkzNRx99IyZjMkE1+plBudCnYBXWPQR9shhfDJC5y5/gUzBwe+zidmX6OidOtGNdi7lClCtjsmrGEmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qH5zD/bNbgwUqiPRv5Wq/CuERtNotVzemk7Ke8FRxTM=;
 b=hxtRaSqRfI02zWHfn9eDLvByT/2Rn3FWi1bpweX3/ywmokqrBYs4FUBf9m/vBB9hvwTOUc+K8EXw4reFhFIs7z/qt/LZvVzTc2fPew9CS1L35yIXiIn1A6UcltAPjP+K7bdUViIwv5cFNXX0yeda16ywn+PnrHM5z426QzmX9SlzpM1TUNKJ/W4/GuMhG1MmWu5DVizr+R1Jjtbdu9MozTVvAAAgcnYRTMN+uTOTky/ZfA1xJ7HIh/8B/oMtHs2SSXXWVqXnQJ67YdMGzaLwpfdloMKgQFIUvntaGBXgZJP5gV8XBB0eQqyaAHYKTxxS+IaBQqWmRtncYtBFm03zdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9419.namprd11.prod.outlook.com (2603:10b6:208:564::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 23:29:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:29:50 +0000
Message-ID: <c0588ea4-cbe9-47e0-9dd5-4357e616a429@intel.com>
Date: Fri, 25 Jul 2025 16:29:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/31] x86,fs/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:303:b5::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: c37a0a7b-f7cf-45fc-124d-08ddcbd32653
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UUFtZGJjUEh3Z1Rhc01wd1RzWDRuZ0FRWDNiRWNIZlJrQ0xXcDd1aHJubjZT?=
 =?utf-8?B?dElDSmlvU1loR2c3SWV1RTlrRnIrYnhRR0k3SlZXT1NLdmpYd2NRSW05bEZX?=
 =?utf-8?B?RGxXUVI0WWg4ZUd6UmlDRG5TVXVteFhKWE9JbHhaWngxcEhzNjBobDJXWkJE?=
 =?utf-8?B?eWZWN0lXcExwdlVReWwyVVE4NWF3azhGN2pGOEJ0ek9oNURqUWZBT3JBQk5D?=
 =?utf-8?B?SFUwZlZWTGFYWWRYYXZWTzUrSnY5Z1ZOSSt0MUd2MDNGYkM5Nk1CdnNXSEl6?=
 =?utf-8?B?OS9GMVoyai9vaDFMd1I3djBuNFpUWW56UXpqUHdWSld1UlBkVWtXSGRJckJk?=
 =?utf-8?B?K1NURW1KVCtQRitJRFpYOC9icFFrNDZTeng2dUFxNC9YcUd3RWhCZXhKMEE2?=
 =?utf-8?B?cTRuR1JHSk5vbWZadDBZVEtGMkhybjQzY1lXazN5WmtpTXhqaFlScW9UejJI?=
 =?utf-8?B?QnpPL0YxOGtoTkduTUJ6NHlzYUZubk9hc24zQXRHOWJkTURJalY2QXE4VUhC?=
 =?utf-8?B?MkE5Lzc5Y2hDWUp5VE92VjF0Vk9WTkRwSlhRUS9uaitiQ1VVcUFFbGJYaGtY?=
 =?utf-8?B?M0crWUhtRHA1OGZ2bHVZbzhWa0xod3h3VURjL1lpd2RmSXhBdTE2UjhCbTR2?=
 =?utf-8?B?NHV1V1VibVdnV2p1Z3A2VkRpa0xJMWxkOUhRM1ljQUZ2MzVObXFOdmlZaGdK?=
 =?utf-8?B?WVFmSHFrMG8wTzNsR1ZhNnBsRlgzM3RobjBGREEwMmJscUE5Ny9xdWVsMXZp?=
 =?utf-8?B?ODFCOUFnQjdzaUhrR21ReVdEL0FMcXkwUUhzR0o1M0lFNlVJSU8xWmg5TXFQ?=
 =?utf-8?B?TU95bFQ3VTJFNHVQMWR6NVJXN0ZTUkdTVzFKNXlIckxQWXBzdHNNN0lRS05X?=
 =?utf-8?B?NnZkczRnMGNtSm83YzNEOHh3QnRrRmFyQ1lvb2tXdzd5NHJWSnhEQ01kcjdh?=
 =?utf-8?B?L3ZJd1E1WUFGS1l6ejhIRFEzNUNQYUpBbXhkT3VYQTFNUEFPMUx3aFlkYUNW?=
 =?utf-8?B?STRlR1habWRBelpUVGFjOERibnY0VW1UYzY3bUpsOHNMSDFXTzBHem1heFBS?=
 =?utf-8?B?VFFXUkt0ajZ0SFRPd1pxS3hhS1puNzN6elZwejZsVldMZUdxOGFKOGh6VFhx?=
 =?utf-8?B?M0VUOGxCNXVMT01ZQUoxNEg5bUtxVTlkUE1BTzlDdlZyZkp1dWRvNFQyeXhs?=
 =?utf-8?B?TVU3c0xhOTZtc1p1ejE4cHJMTFZaVnVFK0Z5ZlZhMDR4dy9NdWZjc0xhWW8y?=
 =?utf-8?B?dXZTSWpibk9ZR1drUXZjbmR6c1NQSU00UENKWVBpYW9XeU1hQkVwWE05cUxI?=
 =?utf-8?B?WWQydHJvUkQzQzRkM0ZSNDR2blZTUU1wbUF3TWphUlFkeWVLOGJVWUVuOHZJ?=
 =?utf-8?B?d2toZjdvdzJjYmdqbGVVdmtTZi96SFkzZ0hzTUhqTXp2NUtob2ZqcXVHd0xQ?=
 =?utf-8?B?OUV6UXFrYXBCM0J5TWRZQTlQaHpoL21hUGpuOE52djJwQzdYaVF3TkI1SnRG?=
 =?utf-8?B?REFyWlQzQ0ZPSXp5eXoyZTdRNWxCbkgxOXhMMnBaRWU2ZHBNMlNVL3JvRlJt?=
 =?utf-8?B?LzJRY2c5OTc0UFBFZjJ1dnc4aUVhZStoMU8renl5YW0ycjYxVVhYQ0E0K3VW?=
 =?utf-8?B?MFlTYmJiVnBRRDdXOG8vYitHcm9kRXNScmgvc1F1SUg0dGU2S1hnTEZITURC?=
 =?utf-8?B?ZHpOTG44SVZYcHR3UzNZRnRjUm5zamVSVkNnZGlWWDlVZE91NVpjeGQrclNU?=
 =?utf-8?B?ZEhMWUxRMnRrYllkMXplTzFMN0R3QXJNczh3TTZJSkd5Zjc2OWllSGJ1SWcz?=
 =?utf-8?B?ZDVuakFQWEtpb1cycisyRW81QVpGZThkWG1pTVRzSEhDNzQrSm53WXM0dzJl?=
 =?utf-8?B?RzJ6TzMzM3Zhc2RsZWI0Ri9kRUhEa1BoeXQ5YjRvTTVZZ1ViSytIaktoRkZ3?=
 =?utf-8?Q?bq8Z06A5o5k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnlHakQyWENybjZQdFNycFBSbWZTRzdjck9vck1iQnBoYWpqMFNlYjByenhN?=
 =?utf-8?B?TTFGTk1nUEdBOHcxb1huWXc0bHpVcS96VE5qSzJ2VFVvVG1rWGtVZ0FCbE12?=
 =?utf-8?B?b3ladVNLaDlXVzVVUVd0Z1c1SFdDamJocWRRNDNDb3ovTGkyUmNGcS9tNGEz?=
 =?utf-8?B?eS9wRkk3dldROW1MU0dGSWlzSmxDSDlJQXlXUVRrMHlkT3RjUEJyVnk0T3U2?=
 =?utf-8?B?V3h1Y2JaZGRJcUJtM01kc2VVY1FsN3VQc1J5QUNmYmxBY1FXMHJDQmdzcFZU?=
 =?utf-8?B?OVBzZnhBWUkwaldBYUdnVWVablh3OTA5NjZXRmQ3U0VVR3RDUHRoT2xoSE9Q?=
 =?utf-8?B?ZkpVYnhsK3EyYW5BbTRxcGM2YWR3Rnp0bWJ3RFcyWjluY3VUaHgzNzhNRXRG?=
 =?utf-8?B?L2ZudUNYVWdtZmVHakN5eUVoUGhVMHBMUkdqSGVnbkdZd00zZjI5VWJicW5x?=
 =?utf-8?B?eCs0TTJNeE5YaGNTUmFBSHVWeGxkT1N3YVkrZHpZdjdlRytkcW9YelJaaFB0?=
 =?utf-8?B?R1VpdVg3OVV3YkF3QmN2N0ZIVDhqd2tWSkloM1dVNFVqS3lDZGtvMm85dUVp?=
 =?utf-8?B?cTNpenVTRUdPcDkyb1QvY0g4ZURPYkFJRDlLMFdvc2RqSmZnRmh5WEQxMmpw?=
 =?utf-8?B?ZW1naDhmZDR5OVZvWEFPYk5VWlMwL3dNOXRWd3VTS0srKzZUbktuczZ4a0Qx?=
 =?utf-8?B?SXA3MmZuMzFNZnNULzZRa0NJZkZCQkE1WEIwTytEdnVQamZVL01JTUtlbzNw?=
 =?utf-8?B?VTJmLzVJanIxSG5UVDVkYkQwWWVqVmtNNk1xeklNcTlLbXU4S3YyTlAwRzZ3?=
 =?utf-8?B?Wkl5Rk93Y3dTL0d3aUpuRE1ma0tjOUhhaXdmdXF1cmp3VGtDUVZVVXBLeGQy?=
 =?utf-8?B?YUFQblkrTjFSWi9pM2E3YnV6Mkt2MUlBM2FkRHUrRkl5SWRJRjNOUFdOS1lZ?=
 =?utf-8?B?SENoSGZ2M2JncnllUDVaNzRrczRxMFZYdkx5aHFUU3VuVXZHV2tYWm9HbGNk?=
 =?utf-8?B?OTlaenhkUHZJOHlKMjFYeks0d0VCTkpSTCt3QnhhM2R1WmRUK09vTGlpWWNx?=
 =?utf-8?B?K3g3TTN1ZGdaNVhhTjFTRlg5NXhtSmptdDR1eHJna2VuMlpvNzl6MFpIa1Ji?=
 =?utf-8?B?bUhoYVU5STRwc0loNjlEV05MMmIyc1RHZHEzN052MFl2MXZPcHhMeWRPQUti?=
 =?utf-8?B?NWt5K01VNlBmUkhSTUdWZ2M0bHJKaVlETTYxeGZ4ZDAzYVpsTlo2VkZoaHRC?=
 =?utf-8?B?VW9FVWovNkpYSHhMNElXNXU3WXhIUHN1c0RkSnlBOFhmMHVqYmM2dy9XUmRi?=
 =?utf-8?B?ZnlWQXBWWEIvd1VXY09MYklhQTl0YjlHYXlBNy9DWGxxMDRtU2RzdnFtRnJu?=
 =?utf-8?B?eTIzV3FnWEVWQTBBVXdzazhESGxQY25lTFh4SFNqTnk0cE5JVVM1ZStGWUN1?=
 =?utf-8?B?MDJTdlZLM21kUkV6bkZ1Rkw4Qy9UdStpV29PUWJwNGVVY012ZkJJdjJsZGIz?=
 =?utf-8?B?dXFXckV6RjE4cWtzenczT0lBZUJ3RUlCaFkzM2JtUkVjdHJxZHBIV1BnY1hR?=
 =?utf-8?B?U01jc0xJYjkrcmFseEVQTXJFQ0ZLckQ3OGdId0hLek5Fc2xUekFETitCaFJv?=
 =?utf-8?B?WFkzK1ZYTVR6dmtkdGxLK2REeDR2T3R0akxadC85aDRpcUlPREh1Wkd5NWVH?=
 =?utf-8?B?ZTcydmZNcnZPanVVbDl1ZXdneTJsOGpMSTljaDRWd05KdXM2VXhueEl2c0o1?=
 =?utf-8?B?WGI4QkNyU0IxZzkyVTQwSmJRdGlRSXhzejBzTkRabUtELzcwTkJROWZ3VDZ4?=
 =?utf-8?B?d093eDZZN3NFQU9lV0FHSCtsU2lOeG44c25BK2tlSXVCNjlDQjZpWmhVakhu?=
 =?utf-8?B?bkUwdk5hTk04T01pMnFqWVNBckJwYUlxNUxCOEI3OC9pdzNLdHdHRW9SR0JS?=
 =?utf-8?B?YWhNV253UGFMYWIxS0QwQWFHZTMySnVjTE9wM1YxUzVLdHZUR0I2RFQwaWR2?=
 =?utf-8?B?cHd1dVlOa2IwYlBKWWc5U0lLTGdEREYzYXNCNGI2cWx5eXBmbVZCdVhadGZj?=
 =?utf-8?B?dHFBNWlLZ29zUmFSeDF0S3VKNHpiaU1OT0xZa0R6WUxLV3VIajR5WHY4ZWJp?=
 =?utf-8?B?dXU3WXZVVElObk9rczRSWS9TeFY0YTVyU1VjUUQyNm5uWC9zTlh2VUtYcHB1?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c37a0a7b-f7cf-45fc-124d-08ddcbd32653
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:29:49.9414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdSLdzU0sxfJKVn0wG29s/gsSDVjvFUuAa0wZIAiPIJCbM9j6vNZfovWMWxeMlnM5qe9oWx2gFlxmeaG6fJg7+f4K5D9eal1WEBp4NzpE48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9419
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource. This will change when support for telemetry events is added.

This is not "history" but the current state. How about:
"All monitoring events are associated with the L3 resource." 

Drop the "This will change when support for telemetry events is added." from the
first paragraph since it does not contribute to the context but can be used
in problem statement later. 

> 
> The RDT_RESOURCE_L3 resource carries a lot of state in the domain
> structures which needs to be dealt with when a domain is taken offline
> by removing the last CPU in the domain.

Above can be part of the context.

<insert problem statement here> 

> Refactor domain_remove_cpu_mon() so all the L3 processing is separated
> from general actions of clearing the CPU bit in the mask and removing
> directories from mon_data.

"directories from mon_data" -> "sub-directories from the mon_data directory"

> 
> resctrl_offline_mon_domain() needs to remove domain specific

"needs" -> "continues"

> directories and files from the "mon_data" directories, but can skip the
> L3 resource specific cleanup when called for other resource types.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good.

Reinette

