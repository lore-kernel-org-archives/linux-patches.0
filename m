Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503654206A
	for <patches@lists.linux.dev>; Mon, 13 May 2024 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715626416; cv=fail; b=gcE1yaZWnGb72gqRB+Y9tODjOhP+zuJ+ne8UOv5FFW4QepmnyYXkda4i2r0+0XPcBJOtcebxx02F+jLkT0DaCdsIwRoimvjD9Aq9Yf5ecy/A+JA0vhFWq9l1SYHaPO9uIdjN0orhNEFnsAUxPKdmNMQOvfayI/t22sXIlUJl1cY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715626416; c=relaxed/simple;
	bh=OIva/v+E6+kBO+0/kWE2YMHoJJjl1PWXmU+OHL1Kmd8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ked6Kj2lXlB1JC2H5h6kVSw6zAriNcT5I7ur9wmSQ2Te/FZvYPeARYBq3jV/w/beohUzPs58aRpvmH62GxqiuMIctm6LdFRZIRknQo7HX5Xakf3gwa1znpMnV4FoHCScer7o2j3O9q9Kb/YCU47/l2TXUEi9QK6kAqhQa/+lgXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fBwJytuS; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fBwJytuS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715626414; x=1747162414;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OIva/v+E6+kBO+0/kWE2YMHoJJjl1PWXmU+OHL1Kmd8=;
  b=fBwJytuSEOKd4t7jAnrjSqPppo8fgBslQzivFUKrHgnYnhe5POOkZMdi
   sCrCMdbwTB7grtChRdZzMwNYgIUWAVC2wmbVs22nCMDSrCulVkYLSm+hv
   0FuMZVwG/JCWTks/2TIyMn15zzOzBCSkG20UutDBivpvee/ke8fpoJoNj
   3+lpqtap27mSkbiVG+RLsrtj/pP9ZUaRKNJHvFvZWFo8OFDb/v/39C8ej
   tHiCxb6Ypval0C4S72ySRdbGicdjJkJjjK3S4JQ3pc/w79Uo0AQQhTX3Q
   s3s1jEFjrQ+leVHQZ4YzZxttrDISRS+jydFoQMkQwh3/K2gFuj39yT6QN
   Q==;
X-CSE-ConnectionGUID: QpZePkjMSx+mQ/3UBFw63g==
X-CSE-MsgGUID: aRtEm5cRRmCmaQTiin/FGA==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="29069526"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="29069526"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 11:53:34 -0700
X-CSE-ConnectionGUID: lD9yD4r3Rra+KGS61aGsEQ==
X-CSE-MsgGUID: zK636nG9QBaF7Pw33G35Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="35176778"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 11:53:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 11:53:31 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 11:53:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 11:53:31 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 11:53:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LX54XRqK6a5Op5sXJSLZ/A2vX5+rMtzSBfRBG5x1DQG0Zuurli2IuRqlphJ3y8r83bR3B9CEgoq+y6D1j1VcQpIHMFRgZE/ybMG3HlM+AadihDkRr3yCtKzknohY8QVENMQkyvm41wfgILtAIQGCE9uT3f11EVgvRM4nBcnujZogClFSDE/Ks25RcQaJxLrvFUMbpxA4JoBHHz9w4G+FvbVCcW4cesmPnlEjaNRGg4huJmNlpctI2B3DvCi/rUn2IjNgfbhQ1ILJcPprf9P4lGfEejPL4bX9WEErvK4t1eEQH6JOTYseCnqSd9RGmojo3bMOsp7YEj6Duyw5MJKfyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uv2RLXlTWj4kphY2ybJPDGSG2tWP0/u7++cxUFO0Cjc=;
 b=UhCakuBV7e9RnkhdFhGVzqIEXbjWlxZaZ0+1xv2Yf2v/k/wyzsBWdf/N6rrhBhz6Mcz9hW/TBkgWn7Ng6pr4jqP1JrvE4vJ8A1On4Y0JOQWyVpJgd+fXV/XOy2Ct9DXJWwrhqQdcPX19+B4EbI01kixBy8cik7xPbnmmpnjagYvE3HsV9uefpppIr0n47wLHju76RMpIk4XVACRoddQKlzeB5buC/A7Zkghv5GlBE1GRXpfAMnVTJSiPi/gvVpOcuHNBPepM0f/kwkEjTsngkEac8BWJoZOZVh/IBvjWvHqmTrk/swb1oTCJqJpFcDUJokH5yYY/jayH2X8Enl+VdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7372.namprd11.prod.outlook.com (2603:10b6:610:145::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 18:53:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 18:53:28 +0000
Message-ID: <fc2de5b4-8a38-4041-9f61-d1bcdf810317@intel.com>
Date: Mon, 13 May 2024 11:53:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 8/9] x86/resctrl: Sub NUMA Cluster detection and
 enable
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-9-tony.luck@intel.com>
 <570e0c1d-8df8-45c6-a9a8-972e1ff2cf66@intel.com>
 <ZkJLO-fNXVxdm6Bb@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZkJLO-fNXVxdm6Bb@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:303:6b::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 370205fa-6071-4df3-608e-08dc737dfa19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a2Q2MFZCQ3I1RDlOZnFmUFp6eFVxazAwODg3NE5MVTFNMGdxYnM3WlJ6UW45?=
 =?utf-8?B?K2JHYTA5K2tQbnFMWGFqYkRDTXhEQ2sySzloQzdnM1F2U1dlNU9XR3ZBWW16?=
 =?utf-8?B?UFptK1dSTjNEem9RRVpNckYxbk03YUQvT2J2djNucEdlNTltUElhZE9BSlFL?=
 =?utf-8?B?dG03ZWVZQ0pqbW5MM3JnQXZuREtJcDFLUXY5OVoySS9xb0hpQ3NUREovSnRz?=
 =?utf-8?B?cVBsbTBJclZ6MkhucnIxYm5oeURZa2xkaFVDeWpWZzdiU0lld0I4ZnhmMTVs?=
 =?utf-8?B?SDg5L3pqK01pUjZnZURqR005SloxZlNKOFZaMkptMlprbThnTHEvc0pmK1BB?=
 =?utf-8?B?SnM2VDkxNkFFV0ZKVkZ0UXZac0lIMlpVSzlvWU5hL1h3dTlMZHlJWERSdTNZ?=
 =?utf-8?B?UXMyeDJnUGY0a05rbTRqZUFJa21Gb3VWNUE0bHhydmcra2dCWnRjNk9UbzlN?=
 =?utf-8?B?Rnl1cFRKZ3dTbXlvZUcySEhibjlvRjZ5QTF3c2N4V09zNkVqWHlZaEJEdFEv?=
 =?utf-8?B?OXdoTk1WV2lpekFmVjNWWEkzTnBSV296a2ZlQ1hlbi9HeVYyeVpDT3cxMkda?=
 =?utf-8?B?UFhRV1RJNDA2WWkwSzIyTUljWENNWVpEQ1JBNHJSWVBVVG16djZNcnM2Uyth?=
 =?utf-8?B?RnZTMm5pVDBWSk80aythcTdaTmNmZDZaekdmTkNxZXF0NGxScUdzdW11bXQy?=
 =?utf-8?B?bFdYTWxsVHBUQjUwNTU3YzFjTVlVVjkybDY5SDQrWEVUSGs2NHYxTkdudytt?=
 =?utf-8?B?a21rWEY5Q3NsMVVLUmV3SmZpaHVqNnQrM0VzNU1IbDRNaFFDTVgvemFuZ1Nw?=
 =?utf-8?B?WGVYYVBQTGFFVWh4QmNxd2dmQUpoQmhuMDByTkdJNG43TTFvVXEzcXR0S0Zi?=
 =?utf-8?B?MVgrZEN1ZjlGTTd3b1hBRVVpaWJJUnlEbWppUitqaWRicUZCbWRIY3p5dDE0?=
 =?utf-8?B?ZFNhUkxhRk1IbzVVdFFiSTczL01lRHhGVlYvaUE0VjBPL21HN3JGbnh3ZXlJ?=
 =?utf-8?B?cEZXTHNkblYyMG9manBFSVJRaHdQKzIzVXgxakpmbHR0Vy9XOE8zbjNoeHRi?=
 =?utf-8?B?VmcwdXhNMmd3V01YTjBtZXZFeVNKQnBNMkFKNnJTOEplVU43MzZBbDlBTW8y?=
 =?utf-8?B?dmJoc1FBaElJd2JzU09ReUhwNGw3L0l3MTQ2QjlFOEdzcStyNVEyWjRlcWZq?=
 =?utf-8?B?UGJjdmNodXRya25XVFhYS3c0UmZZbFdmZDZVUWtLVXc2U3p5V2x5bkVjbEo3?=
 =?utf-8?B?eDgzVkxDaHpDK2lwbkR4T01wMXBmTWRsQStROXc4L28ycnh4Q2RUblJtTTgx?=
 =?utf-8?B?c2d3NFdjcitCdytFenU0Rk9JTjZYcnZyam43aHAvV0hCa295V2Y5dmhqMXZD?=
 =?utf-8?B?T3hQc1c3MnRsdEcrd1J2UTBOS1VMY1p5RiswMG5qOUZQcXRZTG01M3JzZzFj?=
 =?utf-8?B?M0tQdXozWTVUdnBkTGdRa2dPcE1IOE14eGZlbkVrOTBraFhETFVtd0g1NThX?=
 =?utf-8?B?VE9ZaCtweGpXa2JmVzY3NFhYNmVuUnd6Vk9ZNGpwdGVxbXdXMWJuMmF0eUJj?=
 =?utf-8?B?TVluYjBrWDN0NnNsczdYMUFMWkNJU2MvUlMxZG92K2k1UG4xWHBCV3BxYktK?=
 =?utf-8?B?eXVmY3orREZ5V0xScE5vMTlNejRkRnljd2F0b1BGaDZDeWFBWkRRMDg3cGMv?=
 =?utf-8?B?TEdGZit0OWtKckhXeGxaYWNJaE1oVkhVVTRTZHAzYW1zZXVOWXdGOGp3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TElYNnlDMm9EczR6Rmw1dmM5Z25CdkxPRVdYS08wSjM4SWhoa09VV016U08y?=
 =?utf-8?B?R21STDllOGI4YndsK3JrOHI3VFFsTlZBSkdlVVd5VkpKN0hkeEhqWENDZ2hh?=
 =?utf-8?B?bXJnVDBUUytCS2lHNmZsZE85SUNFbThScENzSkxlLzMwdFNJN3FnQTc1ZjFZ?=
 =?utf-8?B?bjI0eXdNOW8wWC9hZStML0E5SDkvQVJSWTNDbGhVMlhsaUZrVmMxUnFXMks3?=
 =?utf-8?B?a1RhaldUeFhmajI4MUtzd1lPdzV4TnpyQVpVQk5aZDZNVDZnTnJTajFNZlkw?=
 =?utf-8?B?dWIrRm1JUTRrazdRVmhkUUhrKzZnRnU1eWtBRUZQYmRwUzd3SXpsVEUxSkVF?=
 =?utf-8?B?TGR1TWhrbWt4TytreFZienR5N0dvcEJ1V2ZpbmZsMDA1ejFnVEQrUnEzMXBt?=
 =?utf-8?B?eGdjV3dMWHFvZHpSQlJFQUMyS3AwbDNMckhtZERtUWVlcmg0NTNJR2VLRG5D?=
 =?utf-8?B?aERDOHBvN0Mxd0FWbFZnTTFieDhlZ1BKL2dSd0drc2xkVU1OVEpOUWk5c1o1?=
 =?utf-8?B?d2U1S1FYOUExZ2t3a3VqcWFldTNqd2M1R0l5ajNyRDU4R05vb0ZubzNFaDU1?=
 =?utf-8?B?ZjgxeUxpTnl4NGRWaTM2dzV3a0JDMWhyNkFHeEZzK09kRnE3WHpRMElNTElO?=
 =?utf-8?B?MkRUN0o4aXdTNHMrWUVJVElPZmsxWkZobFRnNE5XS0RCN3hxc1QyUlBrNW9D?=
 =?utf-8?B?NmpxV0xCZzdqNmxyd2JuV0JlM243dUJzeXF5Vm0rdVNHb2hJRk1ndTg1ZXo3?=
 =?utf-8?B?cGNTNjByd0pXbHpCSmFVTHRLc25QV2tFZ0VmQUlDb0VGRjNveWMrRVpud1Zv?=
 =?utf-8?B?RGFBNmFRcUtOeGJ6dDlFSGZWbmFXUW1CN3htNlRHeWRJcGloV1lEdm1oOGFn?=
 =?utf-8?B?Vit3ZUc0ZTFaVEdzMzMvY2tKNXpKNlNMcUpYNVZ0cmMvSXNEcnNJdXpSOGlw?=
 =?utf-8?B?eTJJTmlKZExLNDhBdXNQTXlMMjhURHg3NGhXVWEvOTNmeE9RYnFyNzBwejBn?=
 =?utf-8?B?K09RdGhQT0VxbllpSVVsV3EzMlE4aUMyZ0hGN1NjNUR2eGxXM2VsYlJMUUJa?=
 =?utf-8?B?eWFKb2trTXRkSEdrRFR1dUZQY3hKZkZvSzNmeGFoZGUyejVSWW1WUmNjZ1l2?=
 =?utf-8?B?Y0J1K1VtMEpZeEJyY2YrN1QveVg1Y1gxaWRWSjFJbEw4Tk9JcmRYeUUyMld0?=
 =?utf-8?B?SGl0eFQvSlp6eUQvTlljaTVPbVp0UFltaWlmWGMzZjJUSFRvVlcyUWF6UkZk?=
 =?utf-8?B?aWpwdXdCb2YwbVJ5L3lXVDNyblEvK0dSRHZPMHgzMzhiOG0vWnYyY0ltSmRs?=
 =?utf-8?B?SmhEdEVZbmNjSU5KeE5lMlJ3TGk5NlY3ZjRXNFNZY0c0MHdyV1RqUWFFS2lr?=
 =?utf-8?B?OGJmZk5KM3lmTm9TYy9VL0tyQ1htWFp6bGZ4QnIyN2JpZ2JmZHA2WGdWdmJm?=
 =?utf-8?B?TVZuS0dYdHY3MVltT3h3Zk9naUM5bkVhcncwQ3JZODYrUmVGanpSRjRScTlW?=
 =?utf-8?B?cXRvckNCOVdOUDUxKzZqbEZiUW9NNmN6aUtWMTRiZEJIZlZNWkhhV2JtYmlv?=
 =?utf-8?B?WXRlbVJld010bDYwUUI1WFZOQmJ1c2FnbjZ2RjNKcnJ3UTRwTmtPRmc1czc0?=
 =?utf-8?B?VEtKT1ZQYnNYMjRsZk9GRVM2RDVZZTNFYWFjVExhNjZIYzBoZDBvY1NKRGxZ?=
 =?utf-8?B?MHNWTU1JbXA1VVZ1M3l2UG45T1ZFaE9IbG8yVEorNTJZZTVET0loVkdVbGF0?=
 =?utf-8?B?OU0wUHBFWmwyVG1DTThuOVI0ckdOUGhDWWZrVU9kb3JEWjY4YVpiN2ZKNUlT?=
 =?utf-8?B?bXByMDdGSVhvNXJVZHdSVzhLaU56QlBVQkowRFN0NXp3bVc2VkxQTGROQXZK?=
 =?utf-8?B?b2xtTnRyUlhuNEhPbkQzWnpsQjlBY2FZQVpGbnZERzdYTTVtU2xNcU5jSUVz?=
 =?utf-8?B?bDZtU1NETG9vOG9rcUtCZGNjVWJuRFJNSmI3eDdGa2tFTiswS3AvWGxqZXE0?=
 =?utf-8?B?bDFVTGZlQ0JURnM1QTZtam9LdUhjOEd6QTlYbE5LeHFKSTFWRTlsU3lFVzB3?=
 =?utf-8?B?Q3J3TjFycHZ6eG1VcFMxWGEzY1NBaE5qSmNSOERzYmUyMnRYdUhRVnBHbmFD?=
 =?utf-8?B?K3dLVm5rYk1IVmZGanMwVHhPdDdob2hxWnFXUmNvQnVPY0VWQ2lHZ09mZGQz?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 370205fa-6071-4df3-608e-08dc737dfa19
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 18:53:28.5058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBqaK1nICGpE6gBlkNcWPqDW06TNFVyG9TA35wVbgT0RipXFkSbHg0G/IhtUnhEH5hAZrfG469XX4106Fx/K6dDNUWzxoCRY68qKFiYA8Tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7372
X-OriginatorOrg: intel.com

Hi Tony,

On 5/13/2024 10:17 AM, Tony Luck wrote:
> On Fri, May 10, 2024 at 02:24:49PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/3/2024 1:33 PM, Tony Luck wrote:
>>> There isn't a simple hardware bit that indicates whether a CPU is
>>> running in Sub NUMA Cluster (SNC) mode. Infer the state by comparing
>>> the ratio of NUMA nodes to L3 cache instances.
>>>
>>> When SNC mode is detected, reconfigure the RMID counters by updating
>>> the MSR_RMID_SNC_CONFIG MSR on each socket as CPUs are seen.
>>>
>>> Clearing bit zero of the MSR divides the RMIDs and renumbers the ones
>>> on the second SNC node to start from zero.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>  arch/x86/include/asm/msr-index.h   |   1 +
>>>  arch/x86/kernel/cpu/resctrl/core.c | 119 +++++++++++++++++++++++++++++
>>>  2 files changed, 120 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>>> index e72c2b872957..ce54a1ffe1e5 100644
>>> --- a/arch/x86/include/asm/msr-index.h
>>> +++ b/arch/x86/include/asm/msr-index.h
>>> @@ -1165,6 +1165,7 @@
>>>  #define MSR_IA32_QM_CTR			0xc8e
>>>  #define MSR_IA32_PQR_ASSOC		0xc8f
>>>  #define MSR_IA32_L3_CBM_BASE		0xc90
>>> +#define MSR_RMID_SNC_CONFIG		0xca0
>>>  #define MSR_IA32_L2_CBM_BASE		0xd10
>>>  #define MSR_IA32_MBA_THRTL_BASE		0xd50
>>>  
>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>> index a949e69308cd..6a1727ea1dfe 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>> @@ -21,7 +21,9 @@
>>>  #include <linux/err.h>
>>>  #include <linux/cacheinfo.h>
>>>  #include <linux/cpuhotplug.h>
>>> +#include <linux/mod_devicetable.h>
>>>  
>>> +#include <asm/cpu_device_id.h>
>>>  #include <asm/intel-family.h>
>>>  #include <asm/resctrl.h>
>>>  #include "internal.h"
>>> @@ -746,11 +748,42 @@ static void clear_closid_rmid(int cpu)
>>>  	      RESCTRL_RESERVED_CLOSID);
>>>  }
>>>  
>>> +/*
>>> + * The power-on reset value of MSR_RMID_SNC_CONFIG is 0x1
>>> + * which indicates that RMIDs are configured in legacy mode.
>>> + * This mode is incompatible with Linux resctrl semantics
>>> + * as RMIDs are partitioned between SNC nodes, which requires
>>> + * a user to know which RMID is allocated to a task.
>>> + * Clearing bit 0 reconfigures the RMID counters for use
>>> + * in Sub NUMA Cluster mode. This mode is better for Linux.
>>> + * The RMID space is divided between all SNC nodes with the
>>> + * RMIDs renumbered to start from zero in each node when
>>> + * couning operations from tasks. Code to read the counters
>>> + * must adjust RMID counter numbers based on SNC node. See
>>> + * __rmid_read() for code that does this.
>>> + */
>>> +static void snc_remap_rmids(int cpu)
>>> +{
>>> +	u64 val;
>>> +
>>> +	/* Only need to enable once per package. */
>>> +	if (cpumask_first(topology_core_cpumask(cpu)) != cpu)
>>> +		return;
>>> +
>>> +	rdmsrl(MSR_RMID_SNC_CONFIG, val);
>>> +	val &= ~BIT_ULL(0);
>>> +	wrmsrl(MSR_RMID_SNC_CONFIG, val);
>>> +}
>>> +
>>>  static int resctrl_arch_online_cpu(unsigned int cpu)
>>>  {
>>>  	struct rdt_resource *r;
>>>  
>>>  	mutex_lock(&domain_list_lock);
>>> +
>>> +	if (snc_nodes_per_l3_cache > 1)
>>> +		snc_remap_rmids(cpu);
>>> +
>>>  	for_each_capable_rdt_resource(r)
>>>  		domain_add_cpu(cpu, r);
>>>  	mutex_unlock(&domain_list_lock);
>>> @@ -990,11 +1023,97 @@ static __init bool get_rdt_resources(void)
>>>  	return (rdt_mon_capable || rdt_alloc_capable);
>>>  }
>>>  
>>> +/* CPU models that support MSR_RMID_SNC_CONFIG */
>>> +static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
>>> +	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, 0),
>>> +	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, 0),
>>> +	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, 0),
>>> +	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X, 0),
>>> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X, 0),
>>> +	{}
>>> +};
>>> +
>>> +/*
>>> + * There isn't a simple hardware bit that indicates whether a CPU is running
>>> + * in Sub NUMA Cluster (SNC) mode. Infer the state by comparing the
>>> + * ratio of NUMA nodes to L3 cache instances.
>>> + * It is not possible to accurately determine SNC state if the system is
>>> + * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
>>> + * to L3 caches. It will be OK if system is booted with hyperthreading
>>> + * disabled (since this doesn't affect the ratio).
>>> + */
>>> +static __init int snc_get_config(void)
>>> +{
>>> +	unsigned long *node_caches;
>>> +	int mem_only_nodes = 0;
>>> +	int cpu, node, ret;
>>> +	int num_l3_caches;
>>> +	int cache_id;
>>> +
>>> +	if (!x86_match_cpu(snc_cpu_ids))
>>> +		return 1;
>>> +
>>> +	node_caches = bitmap_zalloc(num_possible_cpus(), GFP_KERNEL);
>>> +	if (!node_caches)
>>> +		return 1;
>>> +
>>> +	cpus_read_lock();
>>> +
>>> +	if (num_online_cpus() != num_present_cpus())
>>> +		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
>>> +
>>> +	for_each_node(node) {
>>> +		cpu = cpumask_first(cpumask_of_node(node));
>>> +		if (cpu < nr_cpu_ids) {
>>> +			cache_id = get_cpu_cacheinfo_id(cpu, 3);
>>> +			if (cache_id != -1)
>>> +				set_bit(cache_id, node_caches);
>>> +		} else {
>>> +			mem_only_nodes++;
>>> +		}
>>> +	}
>>> +	cpus_read_unlock();
>>> +
>>> +	num_l3_caches = bitmap_weight(node_caches, num_possible_cpus());
>>> +	kfree(node_caches);
>>> +
>>> +	if (!num_l3_caches)
>>> +		goto insane;
>>> +
>>> +	/* sanity check #1: Number of CPU nodes must be multiple of num_l3_caches */
>>> +	if ((nr_node_ids - mem_only_nodes) % num_l3_caches)
>>> +		goto insane;
>>> +
>>> +	ret = (nr_node_ids - mem_only_nodes) / num_l3_caches;
>>> +
>>> +	/* sanity check #2: Only valid results are 1, 2, 3, 4 */
>>> +	switch (ret) {
>>> +	case 1:
>>> +		break;
>>> +	case 2:
>>> +	case 3:
>>> +	case 4:
>>> +		pr_info("Sub-NUMA cluster detected with %d nodes per L3 cache\n", ret);
>>> +		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_NODE;
>>> +		break;
>>> +	default:
>>> +		goto insane;
>>> +	}
>>> +
>>> +	return ret;
>>> +insane:
>>> +	pr_warn("SNC insanity: CPU nodes = %d num_l3_caches = %d\n",
>>> +		(nr_node_ids - mem_only_nodes), num_l3_caches);
>>> +	return 1;
>>> +}
>>
>> I find it confusing how dramatically this SNC detection code changed without
>> any explanations. This detection seems to match the SNC detection code from v16 but
>> after v16 you posted a new SNC detection implementation that did SNC detection totally
>> differently [1] from v16. Instead of keeping with the "new" detection this implements
>> what was in v16. Could you please help me understand what motivated the different
>> implementations and why the big differences?
> 
> Reinette,
> 
> Do you like the detection code in that version? You didn't make any
> comments about it.

It was a drop-in replacement for a portion that was not relevant to the
architecture discussion that I focused on ... hence my surprise that it
just came and went without any comment.

> I switched back to the v16 code because that had survived review before
> and I just wanted to make the modifications to add both per-L3 and
> per-SNC node monitoring files.
> 
> I can pull that into the next iteration if you want.

It is not clear to me why you switched back and forth between the detection
algorithms. I expect big changes to be accompanied with explanation of what changed,
why one is better than the other, or if they are considered "similar", what
are the pros/cons. Am I missing something so obvious that causes you to think
the work does not need the explanation I asked your help with?

Reinette
