Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2262472AE
	for <patches@lists.linux.dev>; Sat, 28 Mar 2026 03:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774668036; cv=fail; b=omEIIvZ7qUD2RHz+kmz7iX1BWf8KuFoJVr/M1klZPowulHQ8/QJRhf6sMPktYVCaiHYvYPtP90XxAVs2aGHbC10TVUVbicNhmgoLGVaLFyn0zgv4YnD2UKDDKLW4K2q456rsywSkEOkZkkWDE7PIqqojgPV0FPXMeLB2spglbrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774668036; c=relaxed/simple;
	bh=2ymKFJvsssCyBmj2YqAHrmsssUoKm7sujYYB0T0xGzY=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=bNgA/1Ec3lCdX96h4nRFLxErkceduGr7b9EG9NSTkPVrFyfwRl4M/l8tvoYpMRGtljlyJZozMoj4PVr6wYNpbbxTZUeR132UAYu2EdspSiyuGINyKvyS9aqhKAM8UZolzsPX2Q472gfwVGVFpRDMP4SzjwnXWx3Htau8nurEZdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lxU1mk/2; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lxU1mk/2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774668034; x=1806204034;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=2ymKFJvsssCyBmj2YqAHrmsssUoKm7sujYYB0T0xGzY=;
  b=lxU1mk/2wUUmRu8hi1f2pNVN0GG9IYEAdE/iBC/Y8/KsX1kHBxTSNI+3
   8Y6js+Z1ouX9GVxoOaUV2oEpZr0mA3PoVxrW2jQB0+qz+8oL9uAOsghBr
   B5bluCyeqO3KaUwyis4QVrCGnRFYynqE30ccTLNoyxNwCDOkAm3jPpWph
   lCMU39+b9ZWn+w9j9Cgi73lPyY2OwnrltzICsWqp3Q24mDzT/rbFVvKV+
   So0zsSgr3eFFbvfoRH7ocDM+otO0LTVDRpHCGp+fnj++RwG2Budly0OTP
   vNPPMe7wxD0OX3sfxK6smDUJJUx0zQwGWY1erNXwCuFjEjDJREXi/B6/0
   w==;
X-CSE-ConnectionGUID: 2vOAYLcVQa2YE/xIn5UXkA==
X-CSE-MsgGUID: UIb2sZujRWqcSm0Xje1NeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="86820163"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="86820163"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 20:20:34 -0700
X-CSE-ConnectionGUID: aqvyzp9xRIOK7oPvHD/EhA==
X-CSE-MsgGUID: eV4gNOUoRE+zL71fkb/URw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="224689375"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 20:20:34 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 20:20:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 20:20:33 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.49) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 20:20:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PfMUzoRpOvh52QXpIb1hTbQB3YFm+it7mIY+R8bJVz5q99EkMVMPkCrrvkSHB6oMey8F81xYWDVftemZ6xS8VWpTra2c9VunmE5RwJyjsKYELE4Jc4Rl6VBMRBjzwLI9VIdQsz622NCHEqoQBnmr7V+mR1jf+1ZK15rvnAHdQzMD8lYxuXJNu/egF5oz9UVeStyHrqAvUyqlQ2Om3vPC/oIYlIwPwtZh1iQQaCu/VKzQmFX9Tu60pq0xTy7hF4Zp130f39l455dhBSNJzLOGiavSAaKvNS7AXvRDgL5x/bcx2Z3jYfMVKDa1x9dS5SrpwtIWak0ocXQ60/kItkQTMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PRIeLKBVc5YuCvoxxfHxMUju/Ea3syL011dg09cTqQ=;
 b=QwWUkEpTMDI0dOPpMBKpIVsSakl5y/2eWFyHSanmezpv4MbRj3vpw81HeSyUMOwZ8uF3E98jqwcl2tHHz4lS7yJzTROmC24jl8BzhfGoSla+ONEoTHy3ujdYVO6QNrFoTqOLgpzhxz3dNaCLr3R7Xg+vFlm8CKN+OZqz4sUppBW0+smXO9cnW5plW0/2cU9WhLMgnynbW3BIgsJ7AHitEVkr4XLy/DQ4anG+iTMDwAzz8x09V4nBelSYlWXMCZ/E4Kx8BEgwXtoNCWVAhvGvct3G3oSmoUMp93B3Y1yTNktb/4+Wz0ROvxol3rqg0Y1uZBeN2Mo9DPE6ywadO061cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB8112.namprd11.prod.outlook.com (2603:10b6:806:2ea::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Sat, 28 Mar
 2026 03:20:31 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9769.006; Sat, 28 Mar 2026
 03:20:31 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 27 Mar 2026 20:20:26 -0700
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Message-ID: <69c748fabe743_17890410085@dwillia2-mobl4.notmuch>
In-Reply-To: <accZuj_b1kB7M4AD@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-10-dan.j.williams@intel.com>
 <accZuj_b1kB7M4AD@aschofie-mobl2.lan>
Subject: Re: [PATCH 9/9] tools/testing/cxl: Test dax_hmem takeover of CXL
 regions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:303:8e::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: b180d5f9-6cb4-4c38-d585-08de8c78f753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: xEcOgaaUPnN12Ox/p15GcEeTWIfr1wJTZmX+VcSwRiUAdNieyOj+SP+TVjouxb8JCzgdE8+oabkqdd/58mjJnSl3VREwWkYQhNs3L3Ip357LZkgMPLXurYQ5renpFufBzhwHs7m2ANFDKdRxG85jCrYXTS1fvBtrquhbK9pNnEJx2N7dSdKdH2IQ/NxDLGQs6gtggluwsdfyTOHk4sedwaAUrHNL7HvOTHB2CfedCn7xr3R3ycx2Yo7AUCYjdNkeksa0dNhN28Mu18/JRRDWY05Ts57A7MTukdfTqkOlayifo6a/jJOZG2U4/JaH4Wsj/Behwq8hyxREtjNxX2dweKN1ygjqhi+ISTwN1vPBazTfq+B30rReUNzTJEMLJvqJhCA3wloSftnBb0M+AdAM8BXap+nEERGc1CSddeCpqOiGpZxWp7lsGl6dAvGZPOcj1NZrsW5RVQyW4BAPHvmQJDzeEJ8zkFpAuqv5mDbr1y/sNY+D76onC1NjWh11NSVL7a1TOaj0yXcl6L8oVE1ONq3W819YB+pu6PRRj+YYEZH5bDPsBuJsCRia9qugyfF8b1c7a1V3zAd8TU6gwvGdmYOb9GTtOOTxXMEc6wRrgBKUJx4kegjcETHOq/g8+CDNKOQYfKzUDYCiEOn2LAULvVIQsuvGJ4zPggduvvLLjuNOGo83q9gMVHopNA2D7oROWiEvMPDlcgephlalh+NWDb9UM7y5ZpQEAU12/zVIcRw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1R6b0c0RFgxSDA5S3BydFdZenVlL3FtYmxrRms0VnlZM3BpSmR6dzNDVHJh?=
 =?utf-8?B?NXNCZ2ZmenBNWDJHRXd6UnRSS0p5Zy9mTERKRVJuWE5ZT0RJUjBxM3ZIYUdk?=
 =?utf-8?B?SmwrUjBkcmNvM0NodmxsWnRCUHpWTGpDTHdBRUFKYjNKRkUzRUk1c1V0bDJS?=
 =?utf-8?B?cldiSnBlTHhoVDlzYUhlRTNUaUVDajc3ZWIySHRJM0ZGR01iSGtHWkV2Vkgy?=
 =?utf-8?B?dkpYelZLWUNwWWNIQms3MGZjTUZGdmZ6dlJEbU11TlpQcURCQVpVYjV5VEJP?=
 =?utf-8?B?bGR1ZlhPL2hOQmpXNUVid1NtaUlXMDV1UEE1RUxITmNIV0txUmprMkpxYU53?=
 =?utf-8?B?Z1JPTXBiQXlsWmh2eGpwRUNudG9raGNlTll3TlE3OEtGR3UxbHl3b0s4NzdV?=
 =?utf-8?B?OHZUTnJ5S0o1TGttTjNhQVRPZityQnpPZllRWkxEVitSemxnSEptRVVManJF?=
 =?utf-8?B?blYyWDZUSEh1UkxvSlVkMmt0a2lqMDBIT0pQOElDdDlpc3B1MEt1SjdoaUsv?=
 =?utf-8?B?Z0t2RHhHZDdlUWc5K2dWazhwMVQ4WnZsNHdFcjVaTjJBTExKMFcwVEV6bWxt?=
 =?utf-8?B?andreEp1Z0IzeUpUQlJLcEZkUU5vR0FraW96ZjZIR1JJZ1VPNGpQeU1manVW?=
 =?utf-8?B?OCt5WHNKcGJHbWZEUHR3Q0RiVTRwb3RsYVVhb0EwR1o4VENTbGw5WU5KY2xM?=
 =?utf-8?B?S3NtekpGU2dGZ25sY2JBaENJcFFCSHU1enBMNDVGaXR2ZGdiUFZjbGxBcFhO?=
 =?utf-8?B?VXUwNVErSmpBT0ZVRnU5TVpvRHYzVmF5eHhORTJVODZnZENXQ1VlaHRmZUVz?=
 =?utf-8?B?anErc2tvVVR0WFRJbWlNRlduVGVOVEt2OFdxOTd3ek5rMStlRG0yTlY0OXBT?=
 =?utf-8?B?N1ZWUkk0dE5RaGp4dzRGenJKZVRjMDI5SUQwakhsVWdQSE1UMmZjTlZwWm5o?=
 =?utf-8?B?M1dDd1dsSDNHQW1WNGNDUjQwdmlvcGdRMXBxUktYaEJ0WkJxWlZFVzlLR3Np?=
 =?utf-8?B?RkQ0UmNWOUJPNWYvQlpPcnlQdWNDOTJ0NUp1clNJUVJMVU1lQlY2WXdIeDZh?=
 =?utf-8?B?RzJpaUI4UVN4enJkRlJzd3Uyd1JUeG1Pamtqd0pqN0w1Z1pSMW1hUVZxMCtr?=
 =?utf-8?B?Wm8wdTE4MlNOYS9wbGFtOFMvV3M5UXdaZ1dldUtCa01UdTFJSDBBR0p6eHR2?=
 =?utf-8?B?K3RXWWJXOHJrZ3pQcVJNQ1lGeXRaN2FsQlJOaWoyUjZONHFGSXpzVCt3TmZW?=
 =?utf-8?B?SGtLNnl3OWlQN3BNSVIzZDRXSDM5RE52bGRDVUxMZFh3cm9QeEJ0Qm1IVWc3?=
 =?utf-8?B?SnorcDQ2Y3pYamxacllNK25za01zWlQxeTBWNjZrNXRKU09NMmxyOFdVdVdY?=
 =?utf-8?B?RlYweHFFRitJVzJlM0RROWtyZVBGRE1RMnhTUGMxaTFkZUhtOXhROWNVVXJG?=
 =?utf-8?B?T1dNSWZmNGQxdTljNjBEaEE1L0JKMmNzZ3crOHNpeGlaN04vUE1PbXA2NEdK?=
 =?utf-8?B?VVIzcTBodmVNdSttcTdHNTZ3dkRLQ0FTRW9DT1A1S0ZjYy9qSVU2VG10OUdy?=
 =?utf-8?B?WEJSOFoyR09zakNRT0wxVVdiVlRBVnI5RWF5WDh4S1pSSGlSSktKWDlwYVgv?=
 =?utf-8?B?ZnZEMWhycTdQNmNDRHRBYlhxTXB3QUt0TEcwMXBremNJUGpZSDluUmJIS3Zp?=
 =?utf-8?B?Uy9OSWg0K1BPK2RsMVdEeUw4R3FlM1hROGFqR0NkSm40ZC9XcGxYTk1LUW5p?=
 =?utf-8?B?SDBRY2hLNWU1eHJFTjVWTC8vdEZjWHp0dzNZM0hZcFF2WDdGQXpTM2VvZ0xn?=
 =?utf-8?B?TFdUcmd2VXBid2ZuZ2x4UVRrOHNhWW9SNWVsZkJ6N0k3TnZzOFIwUU1ZMFh5?=
 =?utf-8?B?M1J6ZklXaUdSenZyVkE0MnhaTWJ5NGRLWGhyNjZRdS9QbWdxWDVrYnNiM2hN?=
 =?utf-8?B?cThIMCtqeEVycHpQcEt0ZWRqeW15RE5CYnRVYnNnMHhWRHNqcmUyWGZkZ3Qx?=
 =?utf-8?B?NGxIUTVKUitUYklTM3MxM3cwaUExL0ZTMHVTeEFkQndiZTVaeEk1L1AyRWRB?=
 =?utf-8?B?K0M4SHdLRitpQmFLeVBzK29wSEZtaGxGY0h4ZjhIdmhSM3czUzFKZXg0cGZa?=
 =?utf-8?B?WG9TUm1FQnJvOHhNemloenI5RmtWSXZ1aWFLa0g3SW5VYXc2TDZUaEhBalJS?=
 =?utf-8?B?aVVrRnhVZ1Y0YnFVMDdMVjk5V2xoVCtkMlpxUkZaYzBrclBiblAzaGhkQmU5?=
 =?utf-8?B?clZ3NTRVM3VjYkdRT3A5QWhGN2tTaGRXNmoreTdhL0s2THluU3VuT2RMY2gr?=
 =?utf-8?B?L0s2YjRXMXN0S0k3QTF5T091eHJ4NFJzWXFzend3T2JwRXhqY09aK0Z2amNm?=
 =?utf-8?Q?Se3uY9HCVDAUr0QA=3D?=
X-Exchange-RoutingPolicyChecked: kU/9mQM/SjSznCQPoZfU/pLB9C1JVtAjqOVPVoHSlF5FLK6QQf/a0c8noqu7uExJT4HPIi3uA3ICiZ4DJpzg/aLLY7jUIV7icjG2V9yXrjDl10vvG7UprVhb5cgdYSj8iIlnvQQ/r3YIJrsj1w3k6DjO5Ewm7AS+mqz8a9kSklkO4tjGdujzmd23gO51tlMDLMOOW/cFlR72fIbZSLwdjmvX9ZWS07IZFWkg7RxTSZdHW9Q7jL8yaKpOFpNwvNjE2lRTbbwBGPrTjoRK3zoTlsjZbobXxj795mm5LXDUtDFVWSXZXgbgnYCgfEJMRDlmo6+Drf5IjOGp1eiMqQqVug==
X-MS-Exchange-CrossTenant-Network-Message-Id: b180d5f9-6cb4-4c38-d585-08de8c78f753
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2026 03:20:31.0500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O14QMku+hFZaFK3zE0CmgmJrTzsg/oOLnRfVDOQTgaHID7W0osTjyemSb2dhAmWU1azSMglOJYsbVyv3mvth++66tuK+0u0c4FGxtWISskM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8112
X-OriginatorOrg: intel.com

Alison Schofield wrote:
[..] 
> > diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> > index cb87e8c0e63c..cc847e9aeceb 100644
> > --- a/tools/testing/cxl/test/mem.c
> > +++ b/tools/testing/cxl/test/mem.c
> > @@ -1695,6 +1695,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
> >  	struct cxl_dpa_info range_info = { 0 };
> >  	int rc;
> >  
> > +	/* Increase async probe race window */
> > +	usleep_range(500*1000, 1000*1000);
> > +
> 
> I see your words in the commit log "Attempt to race..."
> and this sleep looks like it is only widening the timing window,
> not making the order deterministic. Given these tests are typically
> single-pass tests, what ensure we actually hit the intended ordering?

The determinism needed is "async probing will have started before
dax_hmem starts to probe" comes from the test loading cxl_mock_mem
before cxl_test, and making sure that dax_hmem is unloaded.
cxl_test_init() then registers all the mock_mem instances before
registering the mock hmem_platform device.

Now it seems to be enough to dax_hmem to hit the windows, but to make
sure the test would need to do dmesg analysis to make sure that
messages like this:

[   69.111420] mock_walk_hmem_resources: hmem_platform hmem_platform.1: walk cxl_test resource: [mem 0xf010000000-0xf02fffffff flags 0x200]
[   69.113990] hmem_register_device: hmem_platform hmem_platform.1: await CXL initial probe: [mem 0xf010000000-0xf02fffffff flags 0x200]

...are emitted while the typical CXL startup messages are still firing.

On my runs I indeed typically see a couple seconds of CXL init messages
before these fire:

[   71.514222] mock_walk_hmem_resources: hmem_platform hmem_platform.1: walk cxl_test resource: [mem 0xf010000000-0xf02fffffff flags 0x200]
[   71.516478] hmem_register_cxl_device: hmem_platform hmem_platform.1: CXL claims resource, dropping: [mem 0xf010000000-0xf02fffffff flags 0x200]
