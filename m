Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072631DC721
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 19:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725392621; cv=fail; b=mjavJrSHY8rRXxqvnMMqilnEhm0lqm1Dm7BDNPU5mowdSxwXr+l93bs5qxriqA5FyVLssRygnexuDmev9Bj1SzFmK/bptyij224CA3kLIGYDSvxsjsIsG7MfjDC6j45n4iqk4CtbBA8pF1gKLTn6G8cnpFk+aQbA8AIZd+VVWDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725392621; c=relaxed/simple;
	bh=P7R7KfrR54iE5nKxro619+l0O7utc2K8NLDXFfQ/WtM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=honfw3NNFeseWJHhS69GmHI/Z67TZGOHiQeG8xwGW9U1biBdioagrhitIZRthv+DNpaGcDWwu6QtKSgPq8UogkMiwwRB2bb+iCkHpyUTbCbwiz8PBF9k6uZ05HEvEs8FU9EhICkywOTNU/gS0vXYkWZs3KnGiTfEj+nhPICQlXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+5gdUMF; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+5gdUMF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725392620; x=1756928620;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P7R7KfrR54iE5nKxro619+l0O7utc2K8NLDXFfQ/WtM=;
  b=g+5gdUMF2l18EZTbaXDmFBN18FwahPQRT7cbFKDyNeanV0d9I6yUJOQo
   cllGKxrb2hcRvblDhsaVyDxKJ0WLBvRWKVccT2B3rsylThgb2C1NVKorg
   XjX++clwZlN2PGKiWeWGNF55j2G7sycNtXUQtp713hQJzA3sOIf3w21sw
   pLK+9DjvLCElsHc1Hwy9HrifI8JZ1wOfzVpBmwwc4YOia9tfWX4iOK6uG
   vDgymdrVWeRl0JP/x3Soc2JsVkYSt4GqGSPd8qcAy4r99kH31teqNqTxi
   mulvJPWXROKUEtB4uUp/s1qPyrXreCEzggvaCk4xrMRhACWDx7iHf3DDH
   A==;
X-CSE-ConnectionGUID: nV7VYThOQhaZ42AUm27R+Q==
X-CSE-MsgGUID: oe4vWkhHTJ6g1rTAoinkzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="35408419"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="35408419"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 12:43:39 -0700
X-CSE-ConnectionGUID: X/RZMPwnTvy+mPwIT8JCQA==
X-CSE-MsgGUID: KWUxmCxNSpiv6WvMLCM7+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="65381286"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 12:43:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 12:43:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 12:43:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 12:43:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 12:43:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzWIwelYBrRmMX0n4SW992foPt54DLNefBIChLGqsS7dmAK53+xshJSNXZW5o89hILRXak3vVs5o7BRRY4EdXvc+7g25XmVl9UsjnCAQV4BSah6RuZkgLwteYCFf3SInrW/T2Jjd4zgKPzBEKlqTOijwaCZ/MYQ9+EjsPfxa6SzKfhyCH0PGoKfW1OZoW4Q1IzW3F/Hv+8NFZvpIefwAKvpgf0phOJmg8ktDnTNO8hLwi6BMbMjB1vO1JEH/2lhyEADvhmG2K7z6H/jZwuwwPp2pIe+BL7DgIKhzsuuu9P9VAsgrDJhRtTiySeQujrF/EiA7kPqAlJ7VqrK8Jg5h6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7R7KfrR54iE5nKxro619+l0O7utc2K8NLDXFfQ/WtM=;
 b=mbQFonTyQ3bOnCMz00jWCKme67GYz1bPZUKGwNXH228tMp+ggoCIJ6s/DVuYrhhwxPWJv+OZU8U7Xx5ZOLjLucocW9+n6sbZTZnp8ls9w2vKa+G9UpSC2nwLe7AJ9En61DRzQ3QgUks3H6EZBl8v4mIbfDhK3w5qFkWgNUdAc247GID66PPpXimx6C39Dd/5F9RucQnswl2F0dhlkI5Dq+vpNUCLHMli60EQpiQdSzgYJyzXh6SUdKZcqiqCo7yIBgfmlJgqLQeW/PKZwq+9iTJXOS1kRelwfZh1bUmwreKoQHX9a2Bujku47eJrfstReC6KyG9omLYhwse01lfq4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB6189.namprd11.prod.outlook.com (2603:10b6:8:ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 19:43:35 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 19:43:35 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Chanwoo Choi <cw00.choi@samsung.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Dave Hansen" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v8 0/3] Final pieces of Intel new families support
Thread-Topic: [PATCH v8 0/3] Final pieces of Intel new families support
Thread-Index: AQHa/ievli1MwvGgF0mLTuludertk7JGcimAgAAEHbA=
Date: Tue, 3 Sep 2024 19:43:35 +0000
Message-ID: <SJ1PR11MB60832E477464FFA09B248CE4FC932@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240903173443.7962-1-tony.luck@intel.com>
 <20240903192655.GCZtdi_w9xN6z9hPGV@fat_crate.local>
In-Reply-To: <20240903192655.GCZtdi_w9xN6z9hPGV@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM4PR11MB6189:EE_
x-ms-office365-filtering-correlation-id: b4f95bec-9f32-46d6-8374-08dccc50b331
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RWY1dU91VWRnaUQ5UUowRG8yYXBtNkNrR2NNdUM3eUNZSjVOT0Z4dW5mUCtZ?=
 =?utf-8?B?b1gwM2wyUjdyVFRISFFCYTBXb2xnaVNCM2lFN0p5dmk2WHhWb1hiYUdhUXVJ?=
 =?utf-8?B?ZklIL0VtbkJ2VFE5amJmeFc5Y0VXM1NZMGtRd3VieWV0NE03VHRGc2JXYjVa?=
 =?utf-8?B?Njd1SHNUOTFBSmJvcXluZHhzanlMbWJRYXh3YkFKSWM5aGI4aERGSzd4VFdt?=
 =?utf-8?B?R0dBZ3loR21aTEYxQWQxek8wQlVDc0lvZEtrVitlYWJCQ0VOWmg1ckNWd3dy?=
 =?utf-8?B?L29zMVhyaEdMTWRzS2IwTXZNU0dTWWtWOWlFaEhvaDd6T0xxMk9PR0kzRmww?=
 =?utf-8?B?S3lZS3hJdzhaZjUwZjNZVXkwYkFnenp3NTJaRGd0U0htaXR6a1A1eDdTM1dm?=
 =?utf-8?B?SmNlbHozZW1oRVhSbmNhQUswMkFRNWxaNkhMV0NMdk1KOWx4U1Z3TzF2dzdw?=
 =?utf-8?B?YTREaWUyZ0wwMDF2NUZkN1hiR2t3TVp4TTBualFTUjJhSW5WUmdnTFVqMnVU?=
 =?utf-8?B?NkY4WEcrWmlmY1VwM3FaN29pMmlrbjhITmVuWWtZQVllbmxWdGc3NnBGcjI4?=
 =?utf-8?B?WVlDdk9LeHU1aE1kb2pvQk8xWXZ5K0lQU0Z0M2czbzFQSlRKeVZLRnpFVGhT?=
 =?utf-8?B?THJhUUw0UEtianBVWStNZ1VxWmpBTFJSOWJjanFBcndQTjdHYlB1UEFFeFN1?=
 =?utf-8?B?aCs5NDJyd1NCODl3S2RBRkRlbFptWGpqY081SkRqbDFwanhncHA3V0QvOEJn?=
 =?utf-8?B?UkVQUnJCRXVHVnJQK3B0L3lybTRNbnVodVVRVDNveDhBVk43cVVQRGxBM1lt?=
 =?utf-8?B?N0dkc0Urb09KclRmUlJ5SDRBRUhOcjBlMDlmSGR4b1MyS0gyVzU2Rk42VHk2?=
 =?utf-8?B?dUt4ZHpWZVN6VldRT0ROK1YwYzQ4ZFhLbmo5V1cxbW5Wb1NEQ05DZTJ3dzF6?=
 =?utf-8?B?NEoyeU9zeXJtdnVlTGw2ZzJ3Zk83Z0xQNEFFTGk5NWtqUmlZUUFpdmtIeE50?=
 =?utf-8?B?V08vRGI3bGpWdnhrT3JBTXM3Tm9qb0Qzb1BXUDBFYW85cXZrWVRjVVZVZ3pZ?=
 =?utf-8?B?Qmh1MXUwWkNRamNjaGpJdlZtYVlLWTVvWTdaS1J4eUNxdDZDd1RkZ2szdVFC?=
 =?utf-8?B?VmFoRnNKYWJ6M1JTakxwdDExN0tUczd2N21jc0poQnM4UkUzT3RzWGRHZ1dC?=
 =?utf-8?B?ZnRMd1BPWGtDQnJjS1NDQy9keENGYkpJdFE4a1hCVDJRbWJzT3VFaDJQcWZk?=
 =?utf-8?B?MnhsTTc5UHk2MTRUMElISkpWUjJsK2tqSXdkMUVMWHJaVkRMVU9rTVhlYXk1?=
 =?utf-8?B?MHdQekhUVmUvRUU5K05KMCtjTkMwRVpDTFRFVUtya0g3NENEenQrd2RMLy9k?=
 =?utf-8?B?clVMOGd3NHhxdURkQ3J4ekN0WFdNeFpNVStWU1ZKTTR4dTVic0RTQkxEbko5?=
 =?utf-8?B?RHNleHFody9aSDBaVld4RmxTZFpkdGdOeWZ1WDl0MCt0b1lMeHVZekZIR1FJ?=
 =?utf-8?B?WmdVRHNVNllBMHhmckxNZlh6MkhWYitLK2ZDb1VZcHFiczBaTXpYNXlaUWpS?=
 =?utf-8?B?ck0zTmxSd1BYWkRjbng4VGJUeDBjdXFsaWFqWmFPb09WSEtKRmF4OXZ4MzNu?=
 =?utf-8?B?Q2JvbzZSY3locUFHQ2ErdkVkdVo4Y2h4UURoeWk5VFd3cTZ5ZTRpS0p1QnFI?=
 =?utf-8?B?NERmbjJUUlVKZFlhK1B1WERKdTZ0TDJRR0VzZnhJaVMzVGtYN01BdExOMkdU?=
 =?utf-8?B?UjV4L0pBSXFVd21EcWdhUm9ad1ZkV3k5amRBTE4yZWdGZHBUamxjTlRzZURM?=
 =?utf-8?B?aVRLTEdYT3dydFNzcDNTb056VDlhcnVpME5xU2dFVHZNT01tcjVDSEhNcU9T?=
 =?utf-8?B?RGo5cDNiTExCaXh5Qi9Rand2dkNFTm9DWWJ2UHpvekJ1QkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFlDYnpEeG9keS9heGg1bXBCSStnVVRwa0NtT09VQnMrUTRpV2tFdmk5SFFo?=
 =?utf-8?B?V3pFTUF1OFkwemZuMUsxS1luaEVhZFRDZGhWUHBuSlVLdVduSGI5V0QrSEh5?=
 =?utf-8?B?akxxeDVlNHBnVEdhRDhsYVZ6clhoMlNHcE92MldwRjJNWmVXSVpCMElLd2Vn?=
 =?utf-8?B?NnpvY3FwQ2NlV0lyREgvZmJyS05GcGFFaGNuSThqSUVUbmgvd1RzRFdrRDlL?=
 =?utf-8?B?VkppMjAzNllKZEh4c0IrSUluWDBNN1RNOXJDbjBSYWovVi9rTmk3OUd1b21I?=
 =?utf-8?B?dFN1dGtUUE9oZGl1YUw2TXZDby9nVngrNEtzWmJvRWxTcktBN0ZJMGRGaWUw?=
 =?utf-8?B?ajNUTkJkU1pQdXRvYkMvdkVBckE0M3FUKzAwTlpwV3lydlZYQjhhUDV5cmZI?=
 =?utf-8?B?YzhMQWd4QjRhb2U4VVlBbVBmY29ocUFFMmdBMGhLVW80S0pFd1Nyeng1S0Z0?=
 =?utf-8?B?MnRpd2s2dWdqOGlxOW5IWU5mRHZTMC9oYUFFdjFiMXFHMXJtekxEM2V5V3Z2?=
 =?utf-8?B?V3pXMUh5WmxPNEd5QUlRbVZkbEQ0eW1CNnQ0cnNvTHJ4eWZVTW9sY0krOUVT?=
 =?utf-8?B?bFFab3hqcHdYdnE1T3lYcWoxakNrMURNWkZ5UTk3ci9Sd0RMVzQrOVJGdUhM?=
 =?utf-8?B?MFR3QStkRHlMNk54SG1xenlkVUVia0RETFYrSzhBREZGRkxURmxQelJXREx2?=
 =?utf-8?B?MVo0WlV1NmpyMUdPZ2FHMFkxLzlKZ3hGSThndkpCVDRXVlpnNXNLM21LaUZZ?=
 =?utf-8?B?T2FrN25JYnBwQjczL3RsNWd1Y05mamVMZ0VkQmNSSks2K2NjNzF3d3BqNGNv?=
 =?utf-8?B?ZjN6ck5WRXFOSm5wUVRRMDhvRTdJcE1pYkNlN1FlbUdUUFdrMXhXSXZneVJI?=
 =?utf-8?B?ZVdWRTNoMG9tQndiUDlRaVQyMXlZU1puTWc0Z2RpaUlrNmhQVEEwU2tHUmRn?=
 =?utf-8?B?ZVUzSDlrVU5HbkRZNHVJR3RJVlVyTmtIMEgreXRsbXd5NVVXVFBnOUJrdTdk?=
 =?utf-8?B?OVNvSW9nb3BobVRuSDRRKzQyWTUzdFdxZ1AzN1FqZGFJS3dJeGFtNnRtSDZO?=
 =?utf-8?B?Vktsc1pSLzJDUnN0ekNrWSt5OGllY0NYZmRqT2xGRVJJeWo5L1V1enNLWFQ2?=
 =?utf-8?B?d1dOaXNiRjlaQk9IMDNBdVI5MVdudFBYbU8rL1l3d2ZlZ1RkTDM4NThFblRW?=
 =?utf-8?B?cDJlblNCVE5ReDNZeThaQW5HdWxIRHFoWEd2cGNXcVE3NEtTNDF3VDhYbWRJ?=
 =?utf-8?B?M0hucWQ1Z01YejVtcGNvZnBmMGNvZWY2Mm1adGJ0ZnN6Uy9iMDAxK2ZsVXFa?=
 =?utf-8?B?UkVSV05oN3pOUEtJcFB3WUtvSGxFMkM5NkprVkNKQmhIWWh2SEN0ZzZJdFNO?=
 =?utf-8?B?MFFKUW1WTUVUWTNFL0hwOWxodnAvK1dTMGJmM1U3UnEwSmNhVVRIRVBMNUQ0?=
 =?utf-8?B?cmdON1AzeE1IL1dMMEhxSEEwZXJpdGRQM1cyaDk4Z05IM1Z3MU5FR05QV2s1?=
 =?utf-8?B?RjUwUno1N21lYXBjZFp0cnZyTmV2cFIyVUNBZExoeFp1MTJZakhiWVZLM2I4?=
 =?utf-8?B?NkZ0cjVkaWNLajN4QWUrMkgxYWNHQUxJL2t3RDFHeTVSUUJpVnlCb3VWMzcy?=
 =?utf-8?B?Q2dJRW80dElVK0dsSXE1OXUwNThKdHQxemNVbjBCZkdxejhuYzFkVnZRK1RT?=
 =?utf-8?B?RmgwZjNkZUJCNzRvNzNJMGV4OUpMR1N2dFRUc3VxeTh3WFoyZGp0V1hvRjhC?=
 =?utf-8?B?a0d0Ui8xZXpKSGVKUi9DRXU0R2o5UG1hdFMxaDhYQldsdFNOUFN0bndVdDc4?=
 =?utf-8?B?T0VBUE1zZWUrZU9aZU9iQ2RFVlYwbkFlWm9VLzhUbk1zREZIVkF1cFIyNG95?=
 =?utf-8?B?dzYrN2o1L3dra2dyK1ZnN0I4K1E5ZmJ0S2MyMVZrYkJvZWIzSEZGSS8rZ2xC?=
 =?utf-8?B?ZnNtU2dIQWpnd2lDVkJkWWw4RGxWa3dGalhzZUYxeGJEQWY1Q0h1WExQdzRM?=
 =?utf-8?B?K1VWanF6eUtsUTBTb3R1NG5HL0pnWW4vQXhpK1ZPOWVGNE1mSisrYkw1UWlq?=
 =?utf-8?B?eWdETGc5V0diK1hXeWhpVzd0MXBiTW9ybGN6eVNROXFuTkNBU3VDNDZSTGR6?=
 =?utf-8?Q?RhXzubjbcmY4jEphAUY3p4Sot?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f95bec-9f32-46d6-8374-08dccc50b331
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2024 19:43:35.5464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HqTCJvUcoxKq85Xh1XkkNXjRMQLNvT+N/GtJDyL+dNlPxPJeWHRHtAKKvK+0qXLe27qLK8Di21mPlAQWyAfjsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6189
X-OriginatorOrg: intel.com

Pj4gQWxsIGV4Y2VwdCBvbmUgb2YgdGhlIHByZWN1cnNvciBwYXRjaGVzIHdlcmUgbWVyZ2VkIHRv
IExpbnVzJyB0cmVlDQo+PiBpbiB0aGUgdjYuMTEgbWVyZ2Ugd2luZG93LiBUaGUgZXhjZXB0aW9u
IGlzIGEgb25lLWxpbmVyIHRoYXQgaXMgaW4NCj4+IHRoZSBtYWludGFpbmVyIHRyZWUgYW5kIGxp
bnV4LW5leHQsIGJ1dCBkaWRuJ3QgZ2V0IHB1bGxlZCB0aGlzIHRpbWUuDQo+DQo+IFNvIHdoZW4g
aXMgQ2hhbndvbyBwbGFubmluZyBvbiBzZW5kaW5nIHRoYXQgb25lIHRvIExpbnVzPw0KDQpJIGRv
bid0IGtub3cgd2h5IGl0IHdhc24ndCBwdWxsZWQuDQoNCj4gT3Igc2hvdWxkIGhlIGRyb3AgaXQg
YW5kIEkgcGljayB1cCBhbGwgdGhyZWUgYW5kIGZpbmlzaCB0aGlzIGNvbnZlcnNpb24/DQo+DQo+
IEhtbW0uDQoNClRoYXQgd291bGQgYmUgc2ltcGxlc3QgYXQgdGhpcyBwb2ludC4NCg0KLVRvbnkN
Cg==
