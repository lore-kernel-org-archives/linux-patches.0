Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72033D8915
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834219; cv=fail; b=DUu7IFlEKH9knPrXlALY6gwpBknTWSda6Yyj5Z7mlLkpYELVF+yo+3EOXc4ZvhLBJdHqJTBjvcBOlb4TrHK4imnVOZKHNrzULetLfCnLPuYYVDOCyurohR2fKJDovQbb7a1anRSJ43ZlW6i9wpNW7ijOxj8miUdkcEGaZdP2Qww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834219; c=relaxed/simple;
	bh=tp7E7G8kHc6Ih8BXqcjwvmOIWMYw+kp/6UWaFsTx5Ow=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nMiwilAwDbJcPI+F+4gMoKkwoIjMzbHNHmbz3FKZyLfNZmeUamiDATIMTb06gtotJ+0u/PmVwswdbo2o1ynJw+YtpSRQ5M67MTNq9YiuAT0pwv8TiJpVu97lhOo7bhzNxpOeF+pJMdpiPjTt3ztqvNsSm7ErSBQ8zE5+C+BrowI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YDgFkpnV; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDgFkpnV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775834218; x=1807370218;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tp7E7G8kHc6Ih8BXqcjwvmOIWMYw+kp/6UWaFsTx5Ow=;
  b=YDgFkpnVpEpDrrZXQWNZCEFgLr1M7vCTFb4XZ7DBixIS9wUVt4wYBBJM
   BnBCSMd9WIRSMrmdnjPSZaH+g9GZ90XZYLDD3Fkr1StZqpGAGzN8XkhSt
   xDj3M4Z5KbPSgPQIWL8EIvdC0INykBwdT3IErfO/yW+3Vo02eE3deo/+O
   hmk5i+nQoKH37DX5L/0nggoVAUi79FFVnVwAu1zX7E8TZLGoknyjDRb+d
   4ScCY99+721vK6AnjJAx9Gw81J23eGqVqsTSM4kQ0S1JgSsuBFKrlmUnH
   WZk/8VofwSdCm8/3TBbc7NJk1U41TtQVArAOQH9sTiXyZKebSwY66LMpO
   Q==;
X-CSE-ConnectionGUID: t5YNAkpNQwmnl1Eu5rpC3w==
X-CSE-MsgGUID: BrBwl6o+RRaPhZujS93ATg==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76874212"
X-IronPort-AV: E=Sophos;i="6.23,171,1770624000"; 
   d="scan'208";a="76874212"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 08:16:58 -0700
X-CSE-ConnectionGUID: dGFZlkyrQVO0zYEDzep4dQ==
X-CSE-MsgGUID: goo+tZL+T0yJ+n/ylddxTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,171,1770624000"; 
   d="scan'208";a="259565245"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 08:16:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 08:16:56 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 10 Apr 2026 08:16:56 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.27) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 08:16:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UNrOabZdnFLaJfHg5JrJoMK9h57opmZIulAZytocbAE3l1ZtLZK8cXMmVGDyX35wdvo47do7n6XZ+6SGdnYV0eeLiBgfHc1Hziqp+L1icRtjonh2H4P3Oq83C7zPRYXy1qnrXHI01aMY3Tgw2GMSIbyU9rth+vJb5MQUwzZZs6UhVtj5ylG8JiwFG8WjyCIPxweARmQieF2M8PtmNxnuF3iKGGDZPR5jHC81+m+s/FLzahs3VznrabZNgxJPAiBn3nB/FsfA7dIERoSk8PR5SE3jED/DrHZDOk1PaedtukGSlJcxMbWzBsAJM5wwwZSkZPpodutE49kofUcY0jTn5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWeOPewOtAM651AUyk1MNIVLuYNMJ3hPQ5/flRa+4Bg=;
 b=kiXkT4Ariag4OsfplAheAHcTzo1rR2N6FzVViGSks+5i4GmHQDcVxAMPV8TkR31Amu8lxAE/77gHe/OlUC1cGlpQMZcbESMZPoj6dlRqR920kMDg2slhrMGYZzLHDqYXOmka4Q9CE0RIWFqjPUhyzE10px4DfjbpDb8OeXTDqEQZCIERyryblrpyviD+JP43F9rwMY3NaETZ3LJupohKPh2YlVXTyI8xCfMSydOs3p6xcIBFkx+YkgpofAK99mky3KBvgrrmmeadQtGBL9oIpkQMPdyt7bnb1JlaRqePBBtum00kh+TPScbw2k4QpHgGba71RLMPpfbXlzML0oUj8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPFF9DAC6756.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::863) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Fri, 10 Apr
 2026 15:16:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Fri, 10 Apr 2026
 15:16:52 +0000
Message-ID: <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
Date: Fri, 10 Apr 2026 08:16:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <adgNfJSeHVyBXumt@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0359.namprd04.prod.outlook.com
 (2603:10b6:303:8a::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPFF9DAC6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 096eaa91-4eba-4f2b-3afc-08de971431f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: Xfyhazq8z9VzW0De8/xSi9oLNZmS5zQWSjZZ+5hRwEdex765mlt8JHNXCVIp0nk7Q7GKt/dXsjFsxWYrpmwJPTTmF1KoEbzZAvVF9ksiGMbA0FX/tKEwHJ2yn9mr1+jJsvgl6eVCHVbOiBKmigTD1uWCz7OAYIPiahU8qk86nJ25svUCMaIFsoJncCdoJKUJ7oUfsYIo0Z6OG/qYhKS5Sfcq6F5MON2Q6fbOJBnj8BZZzbMBZX0QdOKILHdNbaNRRouW5vuUcr3JrclnEPu+EyXattHFnwazU9P4H61aQe/MUi/E1aiJt+hESgqXYtODvZyJ266XKq9KvfjMyBSkzZ3B2VQ5kCvuZw8RX9yMtlX96yxQBkMY/MqAk8vTGBJTvt3ZuYCbC1eWUF1GiGZrXJRanzvfwiLWWo17ZA3SSwpNA2THBb9aiI8gS7FIH++FOriCjwTWb4Pgtgwu7ehGxLpYtOsxoYYNAg9zuJjEra/ciLTAfRLnAnHJE5UR57liV/gECuNbBaItDmmw7EnLrmVHEigV+ppcO/zB8R0mZJmJVsgroiXGnS2gIKs6O4+DmGZA9Uq+fubiJnFWh7evR0aHYjHY39n3xY0untgFz0F81+VFLuJ8GEWUn9XdyzPT6rRRVNYTax22mQWZuWZGbSOnLxYFtBfQD1vtr3bmG0F14qs9kf3un5yo29m1CLbXSpdReARYKYLH7RciqVfhGODJPRa7Jiv4gB56yO56nao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnR1bi90WXFIMzM4SWNsU2RVcDQwa0FMRitNU2lWeklKYXVSREtaZHcybTZG?=
 =?utf-8?B?dGtXU3RmYWVic0dzc29IVXloeVQ2SXI3eGRXM1hYUkZ3eHhGNDBJS0xrclBS?=
 =?utf-8?B?RXQwcTBIajVnVzB2Z3B1TXNrQWhjaURzcDlacy9rd2FwNittaVZnTEtGUHIw?=
 =?utf-8?B?bUR5NE1xbnVJY09DY0NXYkpScFNIdWc2cm9ZdTVXUVV3Qi9GTWZNTXcrNEFU?=
 =?utf-8?B?ZHYvUldwWW51QWRhMmMrUEFGNUFLNldVcEkwUThybUVrV2VuWUVvTzhyOVNr?=
 =?utf-8?B?Vnl6OE5mZXl6YnBjOXRJanhWc05hL2NIVlFMQ3ljZzBCNnpwbEtoOC94Zy85?=
 =?utf-8?B?RlJjUjdOU1dIMHZvL2F0bVZ2cjBYKzVROFJoYlVqNWlXbk51MnRjYVVmcXdt?=
 =?utf-8?B?Q0ZyRWtZOG1DcEx4MVA0cmhhU2kyUUpZYmp4ajNxSEpoWlduakJXQUIwcWRm?=
 =?utf-8?B?TmJmMTNUR0ZqRnpUbjduZGo3WEdBMVR1a3hIZk5tYy9VaW9mNDYydFRBR213?=
 =?utf-8?B?NjU5S3c2d29hMHZNL1RNWXRGYVhIbVdaMHo0bEkxWmFVK0REMmVVZXRLbDdV?=
 =?utf-8?B?QzRrcjRxZnM2YjZoeHRDUSsvMkpVanMxR3hZZUxOVHI0V0grUDlUb29CYWh2?=
 =?utf-8?B?dGRUZWNGL3FZWkpoUm1aRjRDeDJOTDFubzU1MGpEODdkZmN3ckFyNGU2bVJD?=
 =?utf-8?B?bmlSZVV3OFZKV21vYlZzYmg0anZicXVXUzl3bXFyVC9EY093M21FZUNYbDRV?=
 =?utf-8?B?UWlDWFZhbDlLNXVXalFuL3pmNWExZnl2WlA2aHVYajhreUxHUGtVRTFHY3VK?=
 =?utf-8?B?YktCd3RhMmU5RXQyTGt6cURPRjExNFZ4ZEk4VEZiZ3kzSWVKWDhYc1pCYmhJ?=
 =?utf-8?B?Y1llaTNkV3M3RS9IaWxZd0YwaXQ5RWRkZEdzYkd3MVZKNXNHVldsdVM1NUNT?=
 =?utf-8?B?VThCSG02eFpUZUVDeVlIbFhTVlB5U05vMVZCVzJZUE1MbEtYZlVuNmVVTXZQ?=
 =?utf-8?B?Ny83Q3lRTHBzZGlNZm5WWUU2bGRGcVZxanMvNml4YWVqR0hzQ2hBMWhVMERX?=
 =?utf-8?B?aW94Nnk4K1RIT0ppbTZzVldQSmoyRGdQTWRYTDB6YWVpRTlEVnN2Z21STUJ3?=
 =?utf-8?B?VCtuS3ExS1VGYVdBcW9rNms0bDJ6MUtmcHBhZm8yWVhaaWErbUVjMGxDRGpU?=
 =?utf-8?B?bXJUQXBwbmRhUlc1bnBObS9kREFVdUkxUEpEOW5vREY3QVlWT1E2M2J1Yjdn?=
 =?utf-8?B?a0MyWHl3SXFCa2Q3cy9lZ1hrdDE2L21pU24rNERDRzd0WUw1UVFGMHFrdm5n?=
 =?utf-8?B?OVExM0EwM0lOQisxUTBscjN1dVRJU0FqWjJBWGtuQ1VJS2xXU1U5WTl6YkNZ?=
 =?utf-8?B?RjdTWnlIalpwREprSlg3Tm5LdUJybGowQ2Z3TlV6TnBhRU40WU1WdUwvcDVU?=
 =?utf-8?B?M1R3VFN6eWY5eCt5NzNEeXpvNnRUNkp6Z3BSc2N3QnlGN2hJeXhFU3V6dDZl?=
 =?utf-8?B?YTFXM29jV0FMV1JZcnQzK3NvWXhIcTYzY21GdWNkK0F0a2tqWERHU3BXelJl?=
 =?utf-8?B?T3pPcis1YmpDS0lDU095VHFNRmtDM2ZNR05MMHZYSW4wVFVRekxhSCtEOWtj?=
 =?utf-8?B?eFRSY1ZGNWViMjlxOXlqdjdUQlNMLzVWdUhsUmh2dm15c1kvSUdSa0hiclEw?=
 =?utf-8?B?eDVDdEJIaU5veUVuczcvSU1oWC96K28rb1lGL1BGMHowWjAxVWJFc1FQbm42?=
 =?utf-8?B?Z3FyeXJZWkc0Tmo1MW9oZHlwUkF2WWIyNjVoS3Fhd1EzbnppWHAwd1RtcWEy?=
 =?utf-8?B?aWl6bndQRUlaWllud2NQdG44dk5PUTNTeEtVYmFTQ0N1OEZBVkp2ZzVxaUYy?=
 =?utf-8?B?dnM4UFJUNllKVVhZVk1lcHhzSkxxMGplWnRNVkdpelV6SWsweGJiRzZNOE5k?=
 =?utf-8?B?QlZyZTFFdTJKUllxYVphQ2x2WFFyMmE5dS9oblBPV1VwVXJ5c0dkVUZ1QTNK?=
 =?utf-8?B?cnh6QmVjcUM5ZHRqRkxsWWJndVhyVk5BZFZkTjFmdndZN3R3S0xrMzFXVDRC?=
 =?utf-8?B?L3Jmdlorc0NIR3NrT25KWnlhVDMwMkQwd3Z1SDRIc1VwZFRwQTdGU2EraDkz?=
 =?utf-8?B?YWNPSDcwclR2OWJNQXlzMEFTYVQyTXhMVkF5NEhqUlNXblpaa052Q3I1Rlcw?=
 =?utf-8?B?WkY2Y3g0OG00Y3YwL3IvOGk2NXQxQmp4bXB3Q1RZTjh5VUc1bzFzSFduYnUv?=
 =?utf-8?B?K0FBRmJvYmMxQW9HKzYvRHJjcXowazdjWmdFWlViR0pVclBYYUhPSHRWUXBt?=
 =?utf-8?B?NjM4M0pGTVNnTGpQQkYybmdweS9FVkxwL21XUkFjdEdvQmFiU09zVzNLVnE1?=
 =?utf-8?Q?GEPvmrlBP1BluP40=3D?=
X-Exchange-RoutingPolicyChecked: kyw9N2kgNvWl1vSgiIfo4VopCtdcgMg/6PRrw9pf2o4a46wRGEmMP2iJqybGVTRd8ncW5z8Wjbwi4hggQ/ZGdJWYLdPH9IavXbbUIgdc6hksi5PtLJm78HTwU4d28O8Wwc+6h23VrGa/6dLdD9kpFiPyHDKF/CWsp5qmJlIv7ULNak9c0eMBKHiaQYhoRFkidalR27ui33jrMOrIfrb9Hjhh82iqX3z7+6QHo24W1BMps63djgAUZ1/bOx2P1Wgq9CQbJvlS7DT0/0LBkaLseiepjKn39RaepRDhPxWLDF36gOJUXXd2KrnbwBnN9pLIUOCazGWfUBlpWSgZmKk5mw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 096eaa91-4eba-4f2b-3afc-08de971431f4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:16:52.7990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZnialHKbRaXtSoBfLpADS8JrIdK/Qs8xcoFFy+wT0q9BvLOg4nS/tu3ae/GWbcUkPCSFAeZjXZbDMTI1eMnsQtCIWm+yyvvm1HUaZYLPAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF9DAC6756
X-OriginatorOrg: intel.com

Hi Tony,

On 4/9/26 1:35 PM, Luck, Tony wrote:
> On Mon, Apr 06, 2026 at 02:16:46PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 4/6/26 1:35 PM, Luck, Tony wrote:
>>> On Fri, Apr 03, 2026 at 05:52:30PM -0700, Reinette Chatre wrote:
>>>> On 3/30/26 2:43 PM, Tony Luck wrote:

>>>>> @@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
>>>>>  	return ret;
>>>>>  }
>>>>>  
>>>>> +static int rdt_get_tree_wrapper(struct fs_context *fc)
>>>>> +{
>>>>> +	int ret;
>>>>> +
>>>>> +	mutex_lock(&resctrl_mount_lock);
>>>>> +
>>>>> +	/*
>>>>> +	 * resctrl file system can only be mounted once.
>>>>> +	 */
>>>>> +	if (resctrl_mounted) {
>>>>> +		mutex_unlock(&resctrl_mount_lock);
>>>>> +		return -EBUSY;
>>>>> +	}
>>>>> +
>>>>
>>>> This does not look right. Here too is resctrl_mounted accessed without rdtgroup_mutex
>>>> held. This change implies that resctrl_mounted is now protected by resctrl_mount_lock
>>>> but resctrl is not changed to respect this throughout resulting in unsafe access of
>>>> resctrl_mounted.
>>>>
>>>> Does this new resctrl_mount_lock need to be in resctrl fs? It really seems as though the
>>>> needed synchronization belongs in the architecture. Could this instead be accomplished
>>>> with a private mutex within the AET code?
>>>
>>> If you dig in lore for the v3 of this patch, you'll see I had the mutex in the
>>> AET code. But there were some complications.
>>>
>>> 1) Need to acquire in intel_aet_pre_mount() and release in intel_aet_mount_result()
>>> which is legal, but makes code more complex when call chains need to be compared to
>>> check that the mutex is being released correctly.
>>
>> Why was it needed to hold mutex for so long? I cannot find explanation here or in changelog
>> of v3. I did not remember correctly and considered the AET code to be doing the domain
>> addition. Even so, I do think a mutex internal to the arch code can be used to manage
>> the synchronization. Could you please elaborate why this cannot be done?
> 
> I tried to move the locks into architecture code. But main problem is still
> handling when a user tries to mount an already mounted resctrl file system
> and gets -EBUSY.
> 
> In that case file system calls resctrl_arch_pre_mount() with the file system
> mounted. You suggested that the AET code could detect and ignore a repeat
> enumeration by noting that the event_group "(*peg)->pfg" is non-NULL, set by

It would be great if resctrl only needs to enumerate once but I do not see how that
is possible since there is no clear indication from PMT driver whether (all) its 
data is ready or not.

> the original enumeration. But that fails in this scenario:
> 
> 	# rmmod pmt_telemetry
> 	# mount -t resctrl resctrl /sys/fs/resctrl
> 		... succeeds, but without AET present
> 	# modprobe pmt_telemetry
> 	# mount -t resctrl resctrl /sys/fs/resctrl
> 		... enumeration success, but now calls resctrl_enable_mon_event()
> 		... with the file system mounted

Thank you for catching this.

> 
> I think the bast solution for this is to change definition of resctrl_arch_pre_mount()
> from "called on every mount attempt" to "called only when resctrl is NOT mounted".
> This is because architecture code cannot tell whether the file system is mounted.

Does this mean the addition of the extra locking in resctrl fs? I am not comfortable with
that asymmetrical locking.

I think a problem here is that resctrl_enable_mon_event() gives the architecture code the
capability of manipulating internal resctrl fs state directly. This is a consequence
of the original design before the arch/fs split. I see the additional resctrl fs locking
as an attempt to make it easier for the arch to manipulate fs state but I do not think we
should go in that direction, instead I think it is better to improve the arch/fs boundaries
here.

To that end, what if resctrl uses its familiar "capable" vs "enable" separation here?
That is, the architecture informs resctrl fs whether it is *capable* of a feature and
resctrl fs, based on interactions with user space, determines whether the feature is
*enabled*?

For a simpler addition resctrl could obtain a new helper, for example,
resctrl_capable_mon_event() that only marks an event as "capable". resctrl_enable_mon_event()
could remain as the "early" call that marks events as capable
and enabled but may be deprecated. Both of these *have* to be called before any domains
are created since per-domain state would now depend on whether the system is "capable"
of an event or not. resctrl fs can assume that all "capable" events needs to be enabled
and it can mark them so at the beginning of each mount, resctrl will only expose
"enabled" events.

There are likely some simplifications on top of current implementation to not make
this too invasive.

What do you think?

>>> 2) The "only mounted once" case meant extra state (AET_PRESENT, which you note
>>> in next patch may be redundant) because intel_aet_pre_mount() is called, but
>>> needs to do nothing.
>>
>> Right, I do not see need for extra state. In fact, since it is not clear to me that
>> PMT enumeration will be complete when intel_pmt_get_regions_by_feature() is called it
>> seemed worthwhile to only rely on event_group::pfg - if PMT enumeration was not complete
>> during mount N it may be complete on mount N+1? This creates a poor user interface
>> though since user would need an alternate way to know if AET is supported and then
>> a "remount until it works" approach.
> 
> The race remains, and is lost if resctrl is auto-mounted at boot from /etc/fstab.
> 
> The user can tell if AET is supported with:
> 
> 	$ grep ^ /sys/class/intel_pmt/*/guid
> 
> and checking if any of the RMID based event guids are present on the system.
> 
> Delta T for the race is small enough that delaying the mount to some other
> startup script should be sufficient. Users are likely to have such a script
> to create the CTRL_MON directories and configure schemata for their workload.
> So annoying, but easily solved.

I do not have a clear understanding of how the new implementation with registration
function will look to understand the races involved.

>>> Adding resctrl_mount_lock to the file system code made things simpler. The
>>
>> Adding complications to resctrl fs to make things simpler for x86?
> 
> I believe it is necessary, since architecture cannot tell if the file system
> is mounted.
> 
>>> pre-mount code can't be called with rdtgroup_mutex held because it needs to
>>> build the domains. That needs cpus_read_lock() + mutex_lock(&domain_list_lock);
>>
>> ack. Can an arch-specific mutex be used instead?
> 
> See above.
> 
>>> I need to add more comments on locking. resctrl_mounted is only modified when both
>>> resctrl_mount_lock AND rdtgroup_mutex are held. I believe that makes it safe to
>>> read the value of resctrl_mounted with just rdtgroup_mutex held.
>>
>> ...but not to read it with only resctrl_mount_lock held as in snippet above.
> 
> Holding either of resctrl_mount_lock or rdtgroup_mutex makes it safe to
> read the value of resctrl_mounted as it can only be modified when both
> mutexes are held.

I am concerned about this approach due to it not being symmetrical and how resctrl fs
now adds additional locking to accommodate drivers.

Reinette


