Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B191384B3
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 23:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727478227; cv=fail; b=kJ4garxukckpC4Qi7iFCEiyWv39pazGsZC5hbnKACdrKFKeQpzQLSzmeTcKqWlPbi0ubBdpX7pjUKu+Zd8VUL9R06RHvXi2XdPgL9hZ0PEBYXUGyC+tN53QDwrW0ogC/eLpDt7ioFCGGI5obcMlsq42VFjw/taxu9V6y6EvP0gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727478227; c=relaxed/simple;
	bh=6X7MWeVAAr+8BFRBZhg3pJQry+fBAAKZs3te0VhjDO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RqaJBulEtLtKCh5KtQa80x3+A/LDpgEpan/bNr5ApuDlLNb8LAonCvS0r38rMQ+3CRvTzubYS8XJTPeNaeVPF8T6BOU1MgP+177dBf3coFF2DCyAlAl4N0uMp2+LERMozNR1M8a9X54VRkLspXoGE6m3mvM86mPB+Fp/DDwVsPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCXO1Tlh; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCXO1Tlh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727478226; x=1759014226;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6X7MWeVAAr+8BFRBZhg3pJQry+fBAAKZs3te0VhjDO8=;
  b=gCXO1Tlh7JUZ3v36d7OAAp2HP3AANBDG6MhbFJ5dJS8PO7MqE3u/1Ch3
   neQEu/Hr3eZHBJSYX4EZVGTiySMPmkzaaAJtikb75R3ki742v8hkFv0tH
   cG7HFRRTb0sVHHvA478dBuSGDgMpjL6DfwvXPkH1WM99uURYh+DI61ZTJ
   4swJ3r+A+AhgG3WnLRv1ONp1uZ9tAjFKpAeZETNJhVSag9eccy1I7H1Ty
   qLoHSAzMKRj1hT7Yr3Ft4VqIwJ57xJSj+KAI9BklJEHhQfiMxJyIvuNa/
   D0c5rHa0tS7+hKdQC6Zue0Zk0bDf86IIiIGcSnUKG+qkkVr4EBZkqXJ+/
   w==;
X-CSE-ConnectionGUID: dAL6DDCQQcGJOGcIzu3i7Q==
X-CSE-MsgGUID: 19pN9ounRv26uXbsNHpUWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11208"; a="26510367"
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="26510367"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 16:03:45 -0700
X-CSE-ConnectionGUID: geV9TZF1T7eGcE1EApLApA==
X-CSE-MsgGUID: Ug17q1YKTguVPjcL7xGpZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="77505020"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Sep 2024 16:03:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 27 Sep 2024 16:03:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 27 Sep 2024 16:03:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 27 Sep 2024 16:03:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XtnEGEVz7wuLtwglvRkKoWE2vBmFG7kfM6vwThe4kTEJvSG5YgxxKMi8AuM32PW7ipKo5DHjBDQ/XZjMoaS2kBI7oKCz30c3br4v3VTbvLP3MjasHmg5lastYzQQwe/AnA1ctK5tbETpGD7hpc73r/zUopiJc5hTevWhMrEGM80bAaToYcw1unxDnu2sRSPYxRHMh/mr8BD4f7mhLXCLJXSGT36RS5AMNW1Dc6q9E1HsaMGf3Pm1eFFnJqQiMYY31P/VwU+V49T/ByYltVmaYgZEmoBDFz+Q+IzVJ8/EzFFWsD6YKpbTH6vZNJZFZ3wlv3XdPNiej2p94sbZ+Ix82A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6X7MWeVAAr+8BFRBZhg3pJQry+fBAAKZs3te0VhjDO8=;
 b=L4KqoYk6PryjQWL/o+sT0eoEVcqgXmx0IYET8CbFWofgwDN14z41OGNR0x5Iz5ehTkHx8eIXXp3N64cyUuaiXg49CWt4QYXvVI88P61zwcC348JSotIXcwZsAnh6z7ZFYNrbFN0e1n6UxuW3yIfoU3IFtEopTPD9vfWWXc3DIz86d82TVXfgxbNYVACw9YeA+BPes0BX/xzj2eVP96AwKpBSwF8SzfbhfvtB9scOGiiTp1rdqSypNc1SrZi/plGMoXdy95e3mbRbPQoLmFhMGMkzzH/VkA7NxetlyzdQSGVzB+gsq6/kUT+/xcWuzg+2emHVlq3XPFowyHiEP5n6GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN2PR11MB4679.namprd11.prod.outlook.com (2603:10b6:208:26b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21; Fri, 27 Sep
 2024 23:03:38 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.8005.021; Fri, 27 Sep 2024
 23:03:38 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Borislav
 Petkov <bp@alien8.de>, Martin Kletzander <nert.pinx@gmail.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] x86/resctrl: Do not round up mba_MBps values in schemata
 file
Thread-Topic: [PATCH] x86/resctrl: Do not round up mba_MBps values in schemata
 file
Thread-Index: AQHbESz0e8myahOiPkmYsE1UzZmuErJsO+kAgAADNiA=
Date: Fri, 27 Sep 2024 23:03:38 +0000
Message-ID: <SJ1PR11MB6083528F8C3BB96A5D46020DFC6B2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240927223038.41198-1-tony.luck@intel.com>
 <623a4a0d-b479-4bfe-9c2b-b62584a19738@intel.com>
In-Reply-To: <623a4a0d-b479-4bfe-9c2b-b62584a19738@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MN2PR11MB4679:EE_
x-ms-office365-filtering-correlation-id: db03bded-cb88-447c-2cf8-08dcdf489f60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?b0RYMlVqdUxTam05T1hvNWkrRlZJeEJHL0ZJZHVnUGZoYWdDaWExb0RPV0pB?=
 =?utf-8?B?Q3Brdm0vc0tvVTZwdElaNXVpcjFrc3pOVTNnMFc3cHVHM2ZKYWpTOUNsTHI4?=
 =?utf-8?B?d2VIOUt3cFpNNWNZWkt4amxjek1vNkFTUmJjQzBKUGYzYmNZSDVGdWVoZFk2?=
 =?utf-8?B?RkRETUR0VUpzSlI3UTVkSWdsb1pZUCtzamZ4ckhFc0RwclZaZll2d28xMjc0?=
 =?utf-8?B?K2V0c0oxY3YxcE45dGxESGhHOU1DRE55ejF3UmtzcGQybDA5RUNXaGVCM0FZ?=
 =?utf-8?B?Q09aSDdXeXpUY0JwcGFMOFpmV01zWWF2Q2dVOUJsMzI2N3hlVVlibkMwd0Nh?=
 =?utf-8?B?RVZDYWVWWGduZUdDWlhFV1Nab21zQjZXRVFHUEo3SzNuV1VjMTRQZXJoeGx6?=
 =?utf-8?B?dmkwVUV1QllyRWd5aUJFbTgxVFZDNkdOd1lOU3JvQjlmSHR5WmVWaXRIbEgv?=
 =?utf-8?B?L2VKKzFWWHpCVWs1YnlaTXRLa0lEQWlVa3R1SmEvaVdrTC9hT2NlMEhmOHIy?=
 =?utf-8?B?cHRHaU53LzJ6SHd2bGxxZ2VyZ2ZpRzRLcGlaLzd4NjgwVExZdjZ5RHVDUnhu?=
 =?utf-8?B?a0c5UTNyY01rajVQOWhpY1c3SmlFZ0lONEh4L0crR0dXd3NFdGx0Z1BuZFBh?=
 =?utf-8?B?aUx3eUlDTCtjVVdSdDRQeXo4U2pMemNOdGhKTGJMeExyV1pWdHJhV3VCdXQv?=
 =?utf-8?B?YkFCSXFvT3hibnYzRVNkSHJnV2RZbVY4b29CUVlPdlhLQjhRN1laOXRNQnpK?=
 =?utf-8?B?eGkvTUNaUXBmakthRE11a2VwL0dKNmRsLy90UmZsNHlqbmU5dEZZaFp6bkc4?=
 =?utf-8?B?WkdNWFBLOHoxVjhLVUdJQnVCTHV3WjFhVUhiaHNKajN4NVo1Z09zNWZhZUVs?=
 =?utf-8?B?Z1YrcjhhZWc5OE1nUHpxM054MEJPN2Fjc0l3elNSOUdwaThpc1ppaGFURzNH?=
 =?utf-8?B?bWRuK3NPWTdwTkZkZGlNeFlLKzJNYXBtUlk3eFk4UnpGa2JaZUxadmVMNnVr?=
 =?utf-8?B?bjcxcDNHT1RYNzFoNDBRdDF0NmcxbUdZeVcrQjNpWituR0p6Y2VuZGdyTDRN?=
 =?utf-8?B?NlAvc1JVQ1RkUXh4NUl3WWxrckllbksyWVFoQVUyNGlUc1ZLeUNnMjcwUDJh?=
 =?utf-8?B?SnVGSDRMcEYweG43REdiVWpDcngxM0xYdTBPd2FnTStYR1lEQ3pvNkxCRitr?=
 =?utf-8?B?QmVEU1JtYmFVZUZaSTJXbUw2dDBPQkhGWHg5RDEzMEZLZXZYSTFRUEp3RUIz?=
 =?utf-8?B?cTRabFNTVXBiMXVGMnJVWENldUJQNVdtVkJJZ0FCOWt1S2pZaHBJRmhDY0ZY?=
 =?utf-8?B?RmlaaDZoQU56ZkJjM0hoc1M5eFVDT3VydUd3RnVEMGVzUDJmc2NMNDRKZFlO?=
 =?utf-8?B?bjNBWk1OZWFJWEhzNFRjeXhQMnd3TG9qdVgvMnVFM3grNS94dDA0eS9icTN1?=
 =?utf-8?B?TE82VzVZb1NuUFZ0aGFQQ2UxRzNvTW5ZS2ZNeDdxUHZ4SmQrL0FGSmpVUVRh?=
 =?utf-8?B?K0Nidlpwd0V1eWRta1hlaWZIY0E2dkozSjdVOGtaWkxnam5QZHUyK2Vnd0Fk?=
 =?utf-8?B?V09kQWZEZlBYR2NYL2paejFhRHhOZkFteHAvMEhYeitQbjJJaG8wNlh6Ni9y?=
 =?utf-8?B?eVJ2aVdZRFVVTzZiWHdlNExiNWNKdmgzSUNFR3hYTzRtMEx6SHQ2amUrcWor?=
 =?utf-8?B?aWptRklXWVRHcE0vMThHSkhLN1VMZU1VUE5TelE0SFJ6cFJ6bEF5SEhQSXFy?=
 =?utf-8?B?NEx5ejA5Z0E0TnE3bzF1U3U3ajlpUHV2WFpqR3B2U1hKRGhCb0VYdFFwMGNo?=
 =?utf-8?B?OEdNcWhZOEFSVDEweE0wTzBFODZaTlVKZ3k2V2k3dUdtNFcvd2JLUnE0dno1?=
 =?utf-8?B?YUlpUWdZSS90WVlPUVVlWG4wRVZBTlZQb3IyY0ZsclRidHRxYk9qRzdCSEYy?=
 =?utf-8?Q?TNj/SUVetVA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjF2T3AzL1JsMFBRTzAySHlBUlNOMlhJazMvVEpzdlQzNkk1Q3kyaEJVYVdt?=
 =?utf-8?B?TmNaVmNKSUJsb3pxcUFOUmttYmgvZ1VtOVEzQjZEajZaOFFNM25RdVFBZVJu?=
 =?utf-8?B?bVAweXBVd3U5YUJ2SkxDWFJXczd4N1N2OS94WXpITmlEbStCOHJlV0EwRHZK?=
 =?utf-8?B?T0Q4dVZ2NW1oMkRoRitFWHJlV2lkME1WZUhtVzNpdXlkOURFWjVpL0NadC8v?=
 =?utf-8?B?WGtxbDhsZzBzNEdWL3pTZm9GOG1KeXg1V1B4ZjVVT2hKWXR2NCtZS1oyS2RT?=
 =?utf-8?B?Rm94Zm5jOFl0V0NmTzZHU2V1cnhLRGlWRXZsY2tJbnhPeGpsalVuTDNqd1kx?=
 =?utf-8?B?VC9sWURMNXg1ZzJWa1NCUWVQeHRqNyttWHczZ1F0ZVhXL1J2UFd0bHR4bEtK?=
 =?utf-8?B?cUlXdDJvbzhjaG5lQUFWY2FFb091QmZwamRJSTZyNzZ6eGpkM2hkUHVpZTI0?=
 =?utf-8?B?aktrWnVWeGtTQVZNK2JoSzFRaExYeXl6SHBEUEg0b0J6T1JSSmJRM0J5T2My?=
 =?utf-8?B?MGo2M3dmZ2JVRHIyQ1BqL1VCR0ttN2YzYzRGQzhZLzNBUTdHNGkwNEFlM3l2?=
 =?utf-8?B?YVZyR0doZEVYU2xFUXFoNi8rTmhMdWRUbFNLbStEYzB6ZjBNK09nVEFsOHl3?=
 =?utf-8?B?bXJXa203dE13RzY5ZDhxWWQvdzMyaEVLUVNsUFpqNlM2R2QvWlkxS0pvRzhI?=
 =?utf-8?B?NWVTTFdWNnhuZFpRMkFlejRKZ1hBaEZPZStwTS90SGJHREhUN1VqYklIYkxT?=
 =?utf-8?B?MlBxby9KQW1LYmgwdDRncDRnWGsvTjVSNDVSWVQvWWhyU3FYYjRCY0VsZHly?=
 =?utf-8?B?NXlKMjI3eWZVMmNaR2tqcHVsU0hkMzIwSGdwY2UzblpKTGhpaE1EYjRMWDZY?=
 =?utf-8?B?d2NVOFBuR3M3VWZ4ODczd0V2ZXZuQk9YVG1SallKWXFON041U2VzMy8xWkhZ?=
 =?utf-8?B?WVdMcGVZWjhyOENVZzNXQ1FxNjJCaytVbFdLck96dGFNbVh2WE9WMkxkSVpI?=
 =?utf-8?B?cVNwczRlZmRsSWZHdWx6S0RXMHRIb2Z1ZTB2UUhjbnJyZ3JwMXZ5cExEMmQv?=
 =?utf-8?B?ZkcvU0h1NVo5b0pONnBMQ1AxM3ZaRXBCWVBVZ2U1Zmx5WnNCcDlMdVdSdmN0?=
 =?utf-8?B?QzQ0dHZKdFBvU0tzdE4yYS9VYS9OY1JuSndSdVhyRlBVZWdkT1l6THhOOWlM?=
 =?utf-8?B?bkFMNzFPSDYvWmhhbXlRcC9yRGU0TkR5eStoRjVCaXpRbkxMWHRxeUZ5cEc0?=
 =?utf-8?B?K2hzUUkrRTQ1bHNWeVVIVWhMcWVkdncxcEJjVXJwQjRVeFRSVzJpbHBqVUsz?=
 =?utf-8?B?WTVmdmd6MDAxaC95ZTlZZ3p1eEdpa0pOVEIyZXdHUHA2UmhsUnJmWUIwM1p2?=
 =?utf-8?B?ZzdBdm9oRk94c09NME5SSHYrbThuTktER3p0WXhXNWxRQ3lJU210Q1FnUE5Y?=
 =?utf-8?B?NjlSeEhpQWVXWG1IOUhOZC83dzZVSHh6Mnl0WXB4WnpXbEtxd1hNWVdXMlp5?=
 =?utf-8?B?cCt0SzF6aSt3aXY0QkpheXRtQUFwZ1ZwZEdWUStZUUhMZFFqQXErLzkzVjBJ?=
 =?utf-8?B?NW90dEd2OU9EUFplanAyVncyT3FTK2RnbFQ0SW5ZK29JRWQ5aFBNaksrOXlj?=
 =?utf-8?B?SFNINkRCUW9HWXd5YXVHVTd5dVA2bnZPSE5laUR5bVU0ME1GTFJ0T0FxdFdH?=
 =?utf-8?B?UWRSS05qbXdieXhrcTZRMENSZC8yZHZFSW1jNy80eFlMYzRBYlFXelN2WHVK?=
 =?utf-8?B?VnVGRzlBRmQ3MFZsNmJOTlJBVmVrV0pndlJUd1BxQVlud3g0WFY2d0dsTytX?=
 =?utf-8?B?eE5Ud2o1SGpKaXFUVFZZQ200NlZEZXFtYVQ3STVoNjYvc2cwKzZHVXUzSGFa?=
 =?utf-8?B?SVZIc0NESC9sN3UvWDByYWIycHpiRjdyTmNpV1BUamg5a1ZNSk5oc2hoemt5?=
 =?utf-8?B?NnM4UkVUOERZTittTWJydDFxM3VLa1NXalJZT2ZHZ3hTZG9adlZkdGJEa3Zu?=
 =?utf-8?B?OWNYMjlSb3Jxayt5LzVpZkFPQ1p2cmFFcFlMeVo0SXdTeStjZEFtUUNmSHpL?=
 =?utf-8?B?QzFBN0srQW9IeDd1NkU1dUtSSWp0ZDJRV09mdTZwNDVGaGhBM2VFRWZTZVBa?=
 =?utf-8?Q?Aqc0ecpK1gKkTURE+Li+rtc4q?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db03bded-cb88-447c-2cf8-08dcdf489f60
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2024 23:03:38.3884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MqUHYZDeFqIUGPbZKkw4h8W7gwUp6tgTr1bgNxxyaGbTwt093h9rFOZquaCV9KrXEgoH+f4jwYYwzWYH/lsbqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4679
X-OriginatorOrg: intel.com

PiBBIGZpeCBmb3IgdGhpcyBpc3N1ZSBpcyBhbHJlYWR5IGJlaW5nIGRpc2N1c3NlZC4gUGxlYXNl
IHNlZSBsYXRlc3QgZml4DQo+IGF0IFsxXSB0aGF0IGFkZGl0aW9uYWxseSBhZGRyZXNzZXMgdGhl
IGlzc3VlIGlmIGEgdXNlciBhdHRlbXB0cyB0byANCj4gd3JpdGUgYSB2YWx1ZSBsYXJnZXIgdGhh
biA0Mjk0OTY3Mjk1LiBDb3VsZCB5b3UgcGxlYXNlIGNoZWNrIGlmIHRoYXQNCj4gZml4IHdvcmtz
IGZvciB5b3U/DQoNClRoYXQgb25lIGxvb2tzIG1vcmUgY29tcGxldGUuIE15IHBhdGNoIG9ubHkg
Y292ZXJlZCB0aGUgY2FzZSBmb3Igb3ZlcmZsb3cNCmR1cmluZyByb3VuZHVwLiBUaGF0IG9uZSB1
c2VzIGtzdHJ0b3UzMigpIGluc3RlYWQgb2Yga3N0cnRvdWwoKSBzbyB3aWxsIGFsc28NCmNhdGNo
IHRoZSBjYXNlIHdoZXJlIGEgdXNlciBlbnRlcnMgYSB2YWx1ZSBiaWdnZXIgdGhhdCBVMzJfTUFY
Lg0KDQotVG9ueQ0K
