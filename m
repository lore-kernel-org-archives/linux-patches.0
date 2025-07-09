Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C7EEC4
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 02:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752028749; cv=fail; b=MTec3khQ48oXhAFH6g8rf6CXtWmPYMFGPy7oW7V+Y4mIy30FhjuWQdSu3hDQ+OdSWAcyMg1Pt+410SPbqOKkFfiOsuxeNmRwFlTKp66FBAlsXPP6/IgggNjwNO3JBptPcej/VGfKW4aiuL6YzRK5Wc+ZEd9TacHVW84RrZnziDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752028749; c=relaxed/simple;
	bh=PMqI+C59tPADmw3eJPorMF/QRaF97m2PTvp0MbRftbE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nh1a+4fEgUiyXTKe3iV5UyOgigYYpevo4+VuZaHwHEphdL2zicJ1dVL9p7PI3GSb9idtrtpA1SkoiSRIARucgxvSxND2Rq0oxBAgCcknv5SQyrItbNnIXyJn2EMIJHY1rR5GSPt5CX9XmXWDp1itVNbrakq4S8ovGLharm4h5jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AuTOZoNr; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AuTOZoNr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752028747; x=1783564747;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PMqI+C59tPADmw3eJPorMF/QRaF97m2PTvp0MbRftbE=;
  b=AuTOZoNr8OULuNU30PnjAkt2j5oGHwDA3x5QzJpY+re7fRqe2pLrfACw
   dayHJZX0DwPkXBvK/V9VPBIBnwG7Gg1EnVrMRbplDKJ+tKve9d/zpt1FJ
   /NbfwJdIKtkahxcb2CjVdiz2s6nRqvKYfdjxYbUgk9BVxhnRcNQD8ydrs
   6mp5gPniBPvRpq3GScye/oLBq/r7ZKKlNz8bB+d0x/8OuxVyUUF+YchRQ
   iBdP+EcyVMicuUPdze9IF6t0ftcigVeML2QyhDZKrFbeGe2wOOIu5Zqj+
   bY1WCQFRuX+E6HK5rXtvAqjo+kK6iMVjJSeuGRnNqzhfziuScM13ZfXeE
   g==;
X-CSE-ConnectionGUID: IHzjhgiHQUyYO0I7kZC9Fg==
X-CSE-MsgGUID: xe32ZfeTQ6S5yojGIJkBdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="64863075"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="64863075"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 19:39:06 -0700
X-CSE-ConnectionGUID: ttZfCoJKRr25ZfOIrXX5Rw==
X-CSE-MsgGUID: pnfrmBW6TpSGNR6tPTVILg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155770505"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 19:39:06 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 19:39:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 19:39:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 19:39:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOsIMlWEYh8jfD8zvGRg0z166QWs/T3FnLF9ZM/RUm+hO6zIKA28Euw05QLXs2sdP8/V8+eU3Q+JdIUBw4tjHcWceASBAM+laOy8VT/GYYDN7DiZETYeYcgLR3SucqqB2OUDlYnMrwu7pzUEoP+xN1XzARdBZJGAJooGUH3TKSIF1O75ZH3WW/mU8Rt8cpC0cz2swK6jasCHyVD3lBNKR0lwrAV+Vr8moYkgczcQOONZcSCSXdi9wlCw6w1zDaUYICoBPcmgxCHCir6kVDJyteHDvgtnIERcJoDUlgR6aE0P0pBLMDCqER2STIbpntshTMR8rP5MKDJ5p06TiCTrPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlA3Q1bBjNHIRB3uFDrTaWDBKjHrvEy8ZHAZoDS/UyY=;
 b=FDNGvC3GWPgxdXF5L3alzBGSeI2JkinRHc3HcETUo1jZ9o2L3BCkCsnYP/Cy3Sfr4jzOT2BqdoOtOJcT6/jYWK/09gFho516URzUAMp9ROrfaT2bGC9boO1C04zloeobPUvBtD4LwSLXidZ8Xb2ksqdthFNBaTibjGODltU7+YyD/LOHiTBUPMwIM7J29Gm2czF0qFwvLm1k0i3yi7O3syDyYL0uek/IdcZs12FK+pGZYaNBrmREYTUM3xi6/Cc4jkJVN/erAHoyEDB+/1SzqXQpUy0pnchG81po8SCpwRVPdxJjHkUWakWCbzEMdDNivNVoj+v4t52doebvGkz/0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8388.namprd11.prod.outlook.com (2603:10b6:930:c2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 02:38:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 02:38:21 +0000
Message-ID: <a0800b06-030e-4aba-ad8e-937d4efa4804@intel.com>
Date: Tue, 8 Jul 2025 19:38:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 19/30] x86/resctrl: Complete telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:303:8c::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8388:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bef8f35-9b07-4258-8a44-08ddbe91ab57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SmlmcFJsNGdDb2M0SVgxQTZHS3dLaHpHYTd3VzFWdzRacG5WcFErWUg0b0Ns?=
 =?utf-8?B?MlkvMmgvS1ltd3drUEhYZFpoN3k0MVR5R1NYQW82MUFwVWpWNytHSHM5dUpK?=
 =?utf-8?B?R3c2V1pnZzYrQjB3TUp4ZDkrZjF4R0lGdzFYTXh6YjczalZxa041SGZRbXRH?=
 =?utf-8?B?MGxlNXZVWW9OQStuSDhCbW81RkFUcEhkVk9OclNmWVR5Tm9oTVdYTUZjRm5u?=
 =?utf-8?B?b05ZVjZxZXdQRWNtTUlWNDhYZ3hDM3VWMUcxRThXc2UvQlJmdlh6bUhOblN2?=
 =?utf-8?B?T1pRWEdiQWp0bVd1cXFIZmZaMnJFSy9iTXdPM3g0Y1E2OElRVDJ1NUl3dDB4?=
 =?utf-8?B?NGRXS2hIQTlWSmxXWm5VWG5CcW5ZYTZtM2dwZEZ3ditJK1hQdnducWtac0p4?=
 =?utf-8?B?Y2tHZmNMZFF3SEY4UjBrZW5Cc3I4UDdNbnRRbVZQUFBKaFU0WUdTalArQjJH?=
 =?utf-8?B?T0hBM0dZTWxpQ2l5VW5USzFXelNud3BxSkF5ekIwS3IwcDNOU1ErM3hWSDVn?=
 =?utf-8?B?Tk1aT1RLU09KODVEcXRaWXoxMCtMRW1vNGxVaks4Q3ZhN0w3anhwWi9YQTF6?=
 =?utf-8?B?NmJidEc0ZVhRWXIxWlZITTJ2U1Qwelc5ckZ1ZFhJV3ZDQUFHclJ3NkdUU0xw?=
 =?utf-8?B?QTE1ZWNDVHFZdnM2MW01aEJJN0N6YVJEcmFkWVZRd1FvUm55M0ZraGNGRldr?=
 =?utf-8?B?dGJHaUlIN0NhbVZLVVFTMnd4UHZYVVhXa1ZPSmRWVnpJREQ4NkI4eFRwNUlW?=
 =?utf-8?B?dS9QRlVtT08ySjJhY0lSTVk0cWlIeUNkbFlLdGNwKzFvNTREZlNieSs2ZTd4?=
 =?utf-8?B?cWl2YVB5djhLdSs3eUwxUS85b1RGMmhsVGRLWXBSdGJmSElTV2pzN1B0Zmh1?=
 =?utf-8?B?Rnc3VE15OVFUY2tHZm1QVTNGc1VBQkhRaXJYUHZ6RUpYMFNTOGdJOFRySVhE?=
 =?utf-8?B?YzVqdVpCWGxQT045dEx4WExoaW82aXk5YmxlbE16YWNBczdjR2NzNVpnVjNt?=
 =?utf-8?B?UmRtcERkTHMvWHJtQ00xMHNLUjBmdGZpME1MNmRLTDZ3azI3cTcybi9iV1Yw?=
 =?utf-8?B?WCtReWpncDZ5ZVlaQnA3VFNYWFhmZWlNN042MEhGVG9qNHVvdldYQ1hCK2Iw?=
 =?utf-8?B?aDZYZGNsZ0I4OXMzM05BQWtvb1VTNHdFbWl2T0ZRT0xIN3lKTi9lcEVkYmlG?=
 =?utf-8?B?cnl0WmdMdFd6a2hIblhuZ01CUDRCVytQOXliM1NOd2pFNXJvaTFXQXkrZXNT?=
 =?utf-8?B?dVB1alcvRmhONFNNQUZjL2kvWXJLdFY0UEhxSDR0a0cwa2lpWjAxWGxoYmM2?=
 =?utf-8?B?bFdEb0kvMXVCeEp3WUFNRmh2UkhnQ2tuUVhvTTl6WE5lUlg3b1lMaitjeVdW?=
 =?utf-8?B?RVFqL29iL3NkdENsQWZVM01hZ3grSE9zL2RtVzZFRFc4N2RhakFESEU3V09I?=
 =?utf-8?B?UDVCLzgzd1FHdXRCNndjaDFPV0V4QmdISmlvZlVrRmx1bTNXMzkzNE1QQW0y?=
 =?utf-8?B?QnlmMi81cEN6Z1BMTXhsdTIyaWtTS3c4c29rbXFkbVNWbkhSR1VVRmdFL1N3?=
 =?utf-8?B?Z3MycnJqeU1abU91T3RhVEtQOWRZZFFFanpQQk5lZndPWFpOSkZmTWIyV3dK?=
 =?utf-8?B?OUpjRk96d3VPWVlaMzRIUjhBNUJZRjZ2YVZ4MnB2MndvZkc2bkFBTzB3azM4?=
 =?utf-8?B?dDJDTzM5aWJaYi95SE13bXIrOUVrSm5OK0tCcDZQNDJoVktkcW5RV1krMGcr?=
 =?utf-8?B?R2o1ZHFRVkVBbXVtYVpSUHYrNVFiQXkwbStuOXF2cENZaDZlaE5PNHBjWVFO?=
 =?utf-8?B?cDljQ0kvUUFGaEpuVXdocjNWL3ZlZjc5N2ZENU44azdhSHR4b2JFM2xIMFNQ?=
 =?utf-8?B?aG1JQTVJVENORWIvaGpYTkkxemZYU3E5OHJ4aFg1T1RvZ04zVlFmc0lSVUwr?=
 =?utf-8?B?MjlxcUp2c3RLbWppVktoN3JUVTNJMmlpdFl3VW1DZUlPR2JaR2lOYjRKQm9h?=
 =?utf-8?B?aXpoWlBwdTRBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnNhcnB3blZONHhVbks4a0xBQjUwMGxzdmVOV3g0d01DN01DQ052QkRRcmk4?=
 =?utf-8?B?S21TZ2hFMkhNMUFVOS9rMzVUc09VekZVNk1CdkhJVFhCclB5TVQ1TnptTEVS?=
 =?utf-8?B?bXVjbnRFNmhBSTc0VlhNMXJzV2pkUUl1ZmxTekVJL0h2bit6RlUxbmRkeUl0?=
 =?utf-8?B?djRyNWlKUnZFRjNlQUdHRVU3Sys0Um85STNhQjBMRDMraE9VY1QyVUplUkF1?=
 =?utf-8?B?ZkVUMWg5ejlrcnF6cG9KUnc1OWZDdDhEQUh0TVpXalVJQVlVeDZkNjNWYm9G?=
 =?utf-8?B?S1hLVFhLR0R2QU9tUVQzRHA1MHB3VzZVaWkzUmIwczZNUmtHM1pydjk5RUVi?=
 =?utf-8?B?SnZTUyswKzVSa0pXa2J3MGpTT2lQdEN2MzhjNmJOb1psRWJLMWxhWnhrSXUr?=
 =?utf-8?B?VUlmd3ljeUlmTmVKeTVWVzdLUS8zeHQ0cWhKb3AzQm5TcjZRa1drRmlyMHMx?=
 =?utf-8?B?cjQyN0NJOEY1RkJXbFZ4QkE4dlNGMjdYaS9QU1FyZXF4eDlBa0xMMUF0L2Rn?=
 =?utf-8?B?bHQwQWd1VFg3VEduTkNtSGx5NFVsYlJkYVJQYkszYlBtYnUvSEQyY05HNXgv?=
 =?utf-8?B?NHFxQVVjWG9KemdhUjBTMEwyY2l4T1h0OHNscnlkNlZwc1BoTHhVeFlJcXJj?=
 =?utf-8?B?NEY2eUNXSHUvdlpRM2hMRjU4RVRxbU5rZnFyTUVLM1dvUUpQbXFMeHpBbWta?=
 =?utf-8?B?NjlTeTFnVnAwRmJkKzY4Tjg5amNqNzJOb3FYOWRpRmV2WUU0YlQ1b2NqdkJ6?=
 =?utf-8?B?Tmp0RDRUVzl2UklnbDI2U2pqbSthT3NBWUhsRW1Mcm9mSUU0VG9TNlBBYktP?=
 =?utf-8?B?SFBaRlltVFhvWHdjcFE0ZExXRkMzUVBJdmxQc1p2NWU3WDhQeGg3ZjNzTjVr?=
 =?utf-8?B?RW9GbjhFVUZId0RXSDBNYlMvVy90eSs2cFNSVW5BL0hZYTVQeTY1K0pvc3RB?=
 =?utf-8?B?ZGpmbDN2RVNTK3hRdFRUOTMvNWttNE1ib2lHUmZrVmZOSGlxZy9wallYdDJw?=
 =?utf-8?B?dkYxTUxSS0prNVk1UDdiNTk5WXREMzVOYU5EUk5HQ3llYndPaGVMNjRZTHdu?=
 =?utf-8?B?M2loWTVKOHpNU3JwL3NWQis0dU16NDVHMmx4V2FEaVNsREtCQVM2Yzl0S0hN?=
 =?utf-8?B?THVHdTdaNC81OTkyRXU5ZjFYUmt6ZmVyc2JCVnVGdGpMdFJhUkd5Q0lCb3dG?=
 =?utf-8?B?MGhkbDZZd2VIK2s5NC8wc1JnS3AyMW1USVFlZ2NXcDhIUVkybEMxR25MamJk?=
 =?utf-8?B?Qy91dElMTURGV2s1NHA5Rm5Ld0N4V2FNUHJFTytIblBMZ0tpV3QzTlczSGRJ?=
 =?utf-8?B?emNjQW5wZnk0Y2hTWmRyMXkxYzR6c3liQlpaWVVESGxpQUJ6VVk1Y1VkdWtE?=
 =?utf-8?B?bFNpdmwzVjJNTWc0d3lzR2JYNHJiQmJnN05FcTZLa3BEb3VGcVpNVXNSVzdi?=
 =?utf-8?B?VkM4Y3NLbGNBOUNBZEtFbmpkOTZNNmdzMGN2TEtYcnZlMG43RXB3aFU2WWRw?=
 =?utf-8?B?T2JNZ1pWcExVVGNnSWtxeEZEVzIveHZFVS9MRnoyS2R2UldtL0xLNVNFY3Br?=
 =?utf-8?B?VGp2UG5PemlMbHl5RGt5bW4wQ2hvbmJyTHFqcXBpTG16cU9FRzczSENFZUl1?=
 =?utf-8?B?VisrZkZYVGhMM2xpNkxXamdBejRLRTF2OHcxYjh1c3Z4ZnpkQXBBV0Fpb25v?=
 =?utf-8?B?dkNyY0tHSGJQdG9WRlc4c0t4ditHTUVpSWJxREhOMDF1K1N6cFhjR2xTNWov?=
 =?utf-8?B?bWpLNTZsaUtYSVNON2NpaXlHRXMzeHIxaGc3eE5mdDhDMjByVDUvUXNUak9t?=
 =?utf-8?B?NlY0VU8yOG1HTUJMRTNpZkg1SGxvWUMwR1IyVEF1U2EyRGNKY1EzK1IxZS9M?=
 =?utf-8?B?SVlVLzZQZ0o0dGFYYlA5SDVNM3pGVytDNE56V2tOcXJ5V2VLYUdncjQ5Z25M?=
 =?utf-8?B?cEp6MVJNTk51bTlKUlpMN1grYjhrbVp5dDJQaWl4a2ZUWXV6TTVoQjhUWDNN?=
 =?utf-8?B?c1JuU1hzdlVFRXFzRVNERXcvN1NHRWZmNjVLUm9FR1FMbkZvbzhYdEJMVlBG?=
 =?utf-8?B?MEFkVjU1VW1FdXhHaW84NWlsOFJFNXFzNmtLRWdPdTdQV2paSm1GNUtvSG5O?=
 =?utf-8?B?Y3RuUERZeGxtUHAvN25nQ2h5OU01OGtUbks4dTF5VWQ1ODJJRkV0dnpjVytT?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bef8f35-9b07-4258-8a44-08ddbe91ab57
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 02:38:21.2403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwcMAb6kZrTgfVt4HPvmeWyJrHFGmB6oNLykpT3Xr7pRVxIh5KqrNWsFl7m85TwZiFXuC9DXoBGsKYR1RGVp3b9s40Cyth+J0dLUDTTST9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8388
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Counters for telemetry events are in MMIO space. Each telemetry_region
> structure returned in the pmt_feature_group returned from OOBMSM contains
> the base MMIO address for the counters.
> 
> Scan all the telemetry_region structures again and save the number
> of regions together with a flex array of the mmio addresses for each

mmio -> MMIO

> aggregator indexed by package id. Note that there may be multiple
> aggregators per package.

This final "note" seems redundant considering the paragraph
reads: "Scan all the telemetry_region structures (plural) again and
save the number of regions (plural) ..." Perhaps just rework the
paragraph to read:

	There may be multiple aggregators per package. Scan all the
	telemetry_region structures ...

> 
> Completed structure for each event group looks like this:
> 
>              +---------------------+---------------------+
> pkginfo** -->|   pkginfo[0]         |    pkginfo[1]      |

since there are multiple arrays in this depiction it can be made
specific with a:
	       | pkginfo[package ID 0]  | pkginfo[package ID 1] |


>              +---------------------+---------------------+
>                         |                     |
>                         v                     v
>                 +----------------+    +----------------+
>                 |struct mmio_info|    |struct mmio_info|
>                 +----------------+    +----------------+
>                 |num_regions = N |    |num_regions = N |
>                 |  addrs[0]      |    |  addrs[0]      |
>                 |  addrs[1]      |    |  addrs[1]      |
>                 |    ...         |    |    ...         |
>                 |  addrs[N-1]    |    |  addrs[N-1]    |
>                 +----------------+    +----------------+
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 64 +++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 8d67ed709a74..c770039b2525 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -19,17 +19,32 @@
>  
>  #include "internal.h"
>  
> +/**
> + * struct mmio_info - MMIO address information for one event group of a package.
> + * @num_regions:	Number of telemetry regions on this package.
> + * @addrs:		Array of MMIO addresses, one per telemetry region on this package.
> + *
> + * Provides convenient access to all MMIO addresses of one event group
> + * for one package. Used when reading event data on a package.
> + */
> +struct mmio_info {

This struct name is a bit generic. What do you think of "pkg_mmio_info" to
at least help describe it is per package?

> +	int		num_regions;
> +	void __iomem	*addrs[] __counted_by(num_regions);
> +};
> +
>  /**
>   * struct event_group - All information about a group of telemetry events.
>   * @pfg:		Points to the aggregated telemetry space information
>   *			within the OOBMSM driver that contains data for all
>   *			telemetry regions.
> + * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
>   * @guid:		Unique number per XML description file.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   */
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
>  	struct pmt_feature_group	*pfg;
> +	struct mmio_info		**pkginfo;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> @@ -81,6 +96,20 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
>  	return false;
>  }
>  
> +static void free_mmio_info(struct mmio_info **mmi)
> +{
> +	int num_pkgs = topology_max_packages();
> +
> +	if (!mmi)
> +		return;
> +
> +	for (int i = 0; i < num_pkgs; i++)
> +		kfree(mmi[i]);
> +	kfree(mmi);
> +}
> +
> +DEFINE_FREE(mmio_info, struct mmio_info **, free_mmio_info(_T))
> +
>  /*
>   * Configure events from one pmt_feature_group.
>   * 1) Count how many per package.

(no update to the function comments)

> @@ -88,8 +117,10 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
>   */
>  static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct mmio_info **pkginfo __free(mmio_info) = NULL;
>  	int *pkgcounts __free(kfree) = NULL;
>  	struct telemetry_region *tr;
> +	struct mmio_info *mmi;
>  	int num_pkgs;
>  
>  	num_pkgs = topology_max_packages();
> @@ -99,6 +130,12 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  		tr = &p->regions[i];
>  		if (skip_this_region(tr, e))
>  			continue;
> +
> +		if (e->pkginfo) {
> +			pr_warn_once("Duplicate telemetry information for guid 0x%x\n", e->guid);
> +			return -EINVAL;
> +		}

It does not seem necessary to repeat this check for every telemetry region. Could this check
be moved to start of function to avoid parsing struct pmt_feature_group entirely?

> +
>  		if (!pkgcounts) {
>  			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
>  			if (!pkgcounts)
> @@ -110,6 +147,32 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  	if (!pkgcounts)
>  		return -ENODEV;
>  
> +	/* Allocate array for per-package struct mmio_info data */
> +	pkginfo = kcalloc(num_pkgs, sizeof(*pkginfo), GFP_KERNEL);
> +	if (!pkginfo)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Allocate per-package mmio_info structures and initialize
> +	 * count of telemetry_regions in each one.
> +	 */
> +	for (int i = 0; i < num_pkgs; i++) {
> +		pkginfo[i] = kzalloc(struct_size(pkginfo[i], addrs, pkgcounts[i]), GFP_KERNEL);
> +		if (!pkginfo[i])
> +			return -ENOMEM;
> +		pkginfo[i]->num_regions = pkgcounts[i];
> +	}
> +
> +	/* Save MMIO address(es) for each telemetry region in per-package structures */
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_this_region(tr, e))
> +			continue;
> +		mmi = pkginfo[tr->plat_info.package_id];
> +		mmi->addrs[--pkgcounts[tr->plat_info.package_id]] = tr->addr;
> +	}
> +	e->pkginfo = no_free_ptr(pkginfo);
> +
>  	return 0;
>  }
>  
> @@ -169,5 +232,6 @@ void __exit intel_aet_exit(void)
>  			intel_pmt_put_feature_group((*peg)->pfg);
>  			(*peg)->pfg = NULL;
>  		}
> +		free_mmio_info((*peg)->pkginfo);
>  	}
>  }

Reinette
