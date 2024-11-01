Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7781C9EC0
	for <patches@lists.linux.dev>; Fri,  1 Nov 2024 23:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730505330; cv=fail; b=kEC7WxdfeopAtfpY+AmqGv+B9Qx3bzRMeHRw9ruCKltNcrqxEJwprK6om44T/ptn6nDhdk+1BQO+TNrKywuH0NJwasTGsRfFYHSbkq/316uvvR3LCCT6aAJqonwDN/QryxDI6creZpiYa+j7AFO3x0VPU2OA5d65G8FzWL1Tmeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730505330; c=relaxed/simple;
	bh=2RTENDAa8OKiKcVpOCcEyKHrwdS+1CdFnU+7kyTEn+Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qpd4skhQ6M/jn1ukdoCp7SXXwQ9Ji9kZfqaTrtiviYa/6rdCtYqnLlWEPrAt65vo6bsgnGLIosWEg0ofCrB9IecI9/92UeAEUeKZEaz5knPq3J4M1m8JwKE3kZj4h75GbN7obzvi04eCUlrRRDJSiO8GakVEjnwmXmSpNKjPbmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JiCWLKTc; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JiCWLKTc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730505328; x=1762041328;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2RTENDAa8OKiKcVpOCcEyKHrwdS+1CdFnU+7kyTEn+Q=;
  b=JiCWLKTcjSeGGWt5GjC7k70S4K7Z1vMOXQCnQSVhIH2Y5ggOK/PEdmiD
   RKTJdS2rKCQRGqhTraShaCr0YU6hvICe3iOHTrGj6M6gLefTRKVvS1HR7
   mFMIkziuPspJAhq61MHSfauD/V9HMXOKOlAsrgwh+zuxdDtz6Szd0zYIL
   5zn3RUjS/RkXR9z4V/xJIpCPiEODXRmJXNCOaBCPUknoorcoAPc6njWuV
   REX5pRii0S9oxMfKFmcfsuZGzHKPhyueRlEfH5dGoT/qjIZI/DIuktt6J
   Py8BjSFjklME7gmQODK2M0hGdwmuvOzZz79JOJ1/GCPC8stdlxGozPaJn
   Q==;
X-CSE-ConnectionGUID: Nufmy94WTYCm3pB8pdqCLw==
X-CSE-MsgGUID: LuBASlb8QxKJ+VHpiQHSyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11243"; a="40915350"
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="40915350"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 16:55:27 -0700
X-CSE-ConnectionGUID: 8zW5A+wNTOGazVJyiaFfkw==
X-CSE-MsgGUID: EzS5PmCLTTWpo86WpOnZ1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="87922322"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2024 16:55:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 1 Nov 2024 16:55:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 1 Nov 2024 16:55:26 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Nov 2024 16:55:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KWSBNkf5ou3rtqgYkQ6mQnWnfEXzqzje4KwT+UlTY7Ma7sFM3RojmH6cWLSXji4gHaUXKQn3rlIu3SrWeJWS4ZLNpb1N9tdPV0rRcqxlaYGNTzBJ//QWmoKezvbB5p4oKdRQahBY4U6TnnsdzJ/BmA+4uefiA5LqMGU27+B5zrTz1ATMGcvftf+QDQjd1TOgxPes+IABnQ84vOqHCawQ46RZc0bsy/s3foaoet8ACWyvA/phV9hz2IA8iRkDFMPeYeygXNDFkHfXCHaICvwa2upmzYH4GdnwKhx+8gBDTCwahk5gW5uh0CkieTlIq6qz6H41Rpy9lfWHMbpZyL+6NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RTENDAa8OKiKcVpOCcEyKHrwdS+1CdFnU+7kyTEn+Q=;
 b=uxc2gJpPz3x2hw6MWHqLQY+24T+Rz/5G7yw3IneyZZD8l/PXXoEZYdgXjZaQFYWNWIKH1XCGXdklinOIKwwH93LwgCrntoURqNOyrGwiwtBXIbSIXTplF7rQC1JzM6hpqab0Kwj3TbdJ0ZacMRvl0OnEQLTqVViHgkUSyPLEMBRdEmllox+J2M35mCnxR4skw+E0IUJzJysl6Wt+LQcOqznPwlPF8UyLe6RDjs7YlpPNLbM1wZstI5syklIP/fBYqi0FsuSDaC+vy6mwnap6Xu8fEPwiQUKWajJaARjgovRXyh/6auTpzKmM5JTD63o8Y+yzvnXGIQQSrnnwUBRc+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN0PR11MB6010.namprd11.prod.outlook.com (2603:10b6:208:371::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Fri, 1 Nov
 2024 23:55:19 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%3]) with mapi id 15.20.8114.015; Fri, 1 Nov 2024
 23:55:19 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
Thread-Topic: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
Thread-Index: AQHbKigHp2P1tXTtZkmmnqKqvRPLY7KjFsiAgAAFx7A=
Date: Fri, 1 Nov 2024 23:55:19 +0000
Message-ID: <SJ1PR11MB60833197C3FCC0B3CF9AA290FC562@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-7-tony.luck@intel.com>
 <6a677a4b-7163-cc2d-a615-6b8c499eb281@intel.com>
In-Reply-To: <6a677a4b-7163-cc2d-a615-6b8c499eb281@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MN0PR11MB6010:EE_
x-ms-office365-filtering-correlation-id: 263ff7dd-8a28-4dd6-3206-08dcfad0a3f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UDMydi94Z2hvaS83U2Z3NnoyeVBDd1E3L1ZZYk9yYm1uTGZUQjkxYk9wYitk?=
 =?utf-8?B?ZThVcDRrZXhyWGV2Z3NwN0ovaXBabW84S0cvYkhSb3JVbjBYQm9IeVBYcmR5?=
 =?utf-8?B?c2ZOWHpjRlFDSU8ybXlCOU9BcmJuUWFKRmhpekVKbElQMUNORUNMaTdpY0Zu?=
 =?utf-8?B?MFNyMmY2aUV4OVQrdnIrV2RYRjhCVit4b0p1dkQzalNXMHFWdEt2OW1TaVVE?=
 =?utf-8?B?bU1YRDFKdVg2dmUxd0pxN21jWURmZG80cnVuQzh4QytaMnpPYnBWcm0vTFVz?=
 =?utf-8?B?V2pXb096UkJrVzNycHhMellzaHhJc0dySTVxd3Z2OGE1SWFvRnZWV0MwdEJE?=
 =?utf-8?B?Q3diOXQ3anBPK010enlyTDJLU29TTy9wRlhrMm9wOTQzY0Z4VkgrTUlLNXYv?=
 =?utf-8?B?L2UxS3JJMHVlQmdEb1VycyszdkM3RXg4Nkg5ODVKQ2RYaFQrUFkvYVBoUFYw?=
 =?utf-8?B?MTU5bytyQldEby9PYkpjTklVQXRmYUR4bjZTY1kxM3ZiWXhqSGFhVGZKWWov?=
 =?utf-8?B?U3NlQWJLaWJ1a2Z3VnNTQmIvSzJDOEszbkEzd1VIOEdqWUF1Ny9SRWdGSGNl?=
 =?utf-8?B?T2lEdjMvZWZGRU1rUWhucDdjd3FJS0ljOEJSUHpiSkduTSt2L0xKcDdoN1Jq?=
 =?utf-8?B?VktvT3dGa0lDdzN3SFRJbnBaVnBGeTVwckJvSlRaOUNqNVdSMWhVVWRjTFdW?=
 =?utf-8?B?OTllU2dpSEVUc20wQm92RXMyTVA3Z2lWV0RTOWlycXZuOE4rSTluUWNRVHM1?=
 =?utf-8?B?ZUJUaHp0K3pqcmg2YnJlb3RjTFBsWlNNL2JQYWlVMnkzYStPZ2QyUnp4cVgv?=
 =?utf-8?B?eXdiUzFScXorMDMvdDVoTkpjWEFiVDJXenBWNHd1bHN4YWRKRzlBd2N1dGVp?=
 =?utf-8?B?c1dWODBSR2pGUUdSS2RMM20yTzJRVXovVlF3MVRiMW91SHpaN0QvcHlFT2Uy?=
 =?utf-8?B?RGtCbjNtOFNzbmNzWG83UU5jWlBFN281YjVLOEZOb3RNeGhCRkU5aHFkS2Nm?=
 =?utf-8?B?akRPSnB1MFkxVEU1RUNRRW9rUEZNOC8yNmd3ckVPdjBNTEFtL2VIMTZKR0VN?=
 =?utf-8?B?dW1EblRId21xMHlodnpJL0lYcVNOTURVVlk0Yk5ZNVZsa3AzWnpjbDJiUkJn?=
 =?utf-8?B?Q0QvR0JpaEk2T3lqR1lORFhvQno1NTFJQ2czeXM0L0ZyMVNQNEJBYjhOZllV?=
 =?utf-8?B?aWkvZVZhdDZTNi9WZ0xYUWVSRjRpSlY2OGl6UjhWZCtCemlqNFVQK1N6RjJT?=
 =?utf-8?B?U0NYRU1VYk40WUhTUUttVGE4RXU0dnl6LzFIQVUxV0lNaEVsQUNSQ2pWS2xn?=
 =?utf-8?B?VmEvODdyNFBjZkZ2dTlyMmxsSlMwT0szanRWVWxramttVk53VG83NHdaUFcr?=
 =?utf-8?B?cytrM29haUppUjlOVGlaZmxFczJheitlOXU2OTNRZHJnSUVLcUNhTVFCbFd6?=
 =?utf-8?B?NTh3M0NBSUZLUTJhcFNlRFRQT3FZeEh1MFFXMmJta3AvQStMbmVFMmc1SEhM?=
 =?utf-8?B?NWIyQUhkWkplaHlTdGtMS2hDcEZEMWxDM2hsdWFwcllya2NyUW1XSVdES0Fr?=
 =?utf-8?B?NWgxSnBuL1BmSCtYUFdUM2JOY2lrdnIySEoxQjZHSm9pRlBPMDEvelkvUVA4?=
 =?utf-8?B?RkdHdlh4M0hUZFp1YmErNWdZS0F4dmFSc1FZMU1QY2JNeVdSNVhlemdBVDBJ?=
 =?utf-8?B?aDNzcXBZQlBGY2szcHg5OWZsZ1ZOWk53UFQwekt2ZmQvMUd2UENQbE4rWjQ4?=
 =?utf-8?B?SDV2NTdWdHdQWmlnWlcvdDhneUZBWVlRLzdKMVNieG02MVFnS2FEM2RGdW9s?=
 =?utf-8?Q?JZ1I/IDoWfUgQBugtfBqRUE9jOPS9na5WrJYE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekkwM2lEa3Y4NDFzR0tIbGdOU29sWUd0Z1hqRmZKbGo4R0pYUFRwaEZmUDUz?=
 =?utf-8?B?dUNpdlFxOGpNc3F0U0xFODhUTnlFU3U5SmtVRkFXdzBXeWt0YkQrbnZTdStJ?=
 =?utf-8?B?a094OG9EOGQ1WURXS1pMN3dhTDJwZURPTHpPWDhHUTVJeTFJc0FSR1JWZHl0?=
 =?utf-8?B?WUYwcEszUnhOS1Zlam9wNHdZMkNzcGZUOGNudmh6N3ZkTjJsY1pMNm5HeC80?=
 =?utf-8?B?b0NQd2hmaUlKaldnS2R0eXNWSkd6cGR3ZG5BUy9NVHFOZjI2MVF5ZHBPNGVW?=
 =?utf-8?B?Wjl1by9rQ0pGaVpyZVhtczRCNnNHNDlYeGsxeGpJL0FqMXphUEc0c2hNWlAw?=
 =?utf-8?B?Z29IdGI4MS8yclY5YjczZHZFMHJqZ2N1OTlOQWFuRTloMFVnVHNyVjR3dFlr?=
 =?utf-8?B?bnJhenQ0dFNhWDBCQUxIMGhGaEpPWGdXVkgxRjlvaHZIbnFLQUozN0ovdkl0?=
 =?utf-8?B?TWZUUlI4enNkejFCUG94NXVtVm5UTGh1NC9udnFSclZTY0VsZGdWNURwVFRk?=
 =?utf-8?B?VjczSVByVjV0alBjVDViRFNmWkRBejhGTGlYcFk4MGppcVJPeUxZeE94Z2hw?=
 =?utf-8?B?TDJWcWlSTXNoSVNKaWNEK3hvT25TdzZoM0g0bFlldlE5YjlWZmVXQXlXR2I5?=
 =?utf-8?B?Y1NMOFdieUhuKzJtQW5ud1M2UW1tU2FYVnVhekd6V1UyNmNGSmRGRDlzK2xk?=
 =?utf-8?B?OFh1czdNUkpERDVOaUJGcXQzbHlJTlc2REE1QW5kbnk3T2VQby91SVRzL011?=
 =?utf-8?B?SWlPd2xYVjZVanF3STg4OU03ZHRSSWxkL2Zqa2ZUdmF3QnBMU1RpdENtUkEz?=
 =?utf-8?B?MHhKMEFndk9LSWJ3L2VudDFHWWJNVGQyUE5YRUF0c3hnZjlncElNdDVSTlJp?=
 =?utf-8?B?dGhVVHJTcy9xWFhQZ0RxN1dGdXdiYW5qRzB4WVlqL29GSHQ2cjhhb0hxVjFK?=
 =?utf-8?B?QldiVG1nQW4zc1VXaTFDb0VDN0lhNEhvUitsV2loV2g1R1FMR05VM1NvRWVt?=
 =?utf-8?B?eU5aNjU5cFV2eFM3czBxS0ZlclNWMmhBQ1FSNWlwQ0ljZjBpeUUwTDh0TXBs?=
 =?utf-8?B?dTYvblZBbk9sK0UrSjZORnEvT2ZCN08wOHNuVWJySHR0NXY0Q2pCeFhZY1NQ?=
 =?utf-8?B?RjlPM0JpY0o5cnc1RVdnRlppdmNZY3p6MlJKY2lNbVF4RWdkS1gvR29LWWxn?=
 =?utf-8?B?djNiMzN1NmFCRnU0R3ZhSHFGNXdjK0pMVTF3dHNXQ3ZkV1FVc0lQa2x5QThw?=
 =?utf-8?B?eC9mdTROU1E0WERPcnBEWnc2RGRaSUlPZk51MGd4M2I2N0s0dWE1RmVBYmRO?=
 =?utf-8?B?UmxzQ0hqeElXclhTZ1NxbWIyMVB3TWRmS1ljdldMRUJBRFRQWVBHQ2svWGlM?=
 =?utf-8?B?UjFna1BHTm5MSExpM2VjUjNkM0RraThscFV4bENza1N1RTdmU3JjMm1mQTd5?=
 =?utf-8?B?VXRNakMrVFhWNVVCMDNITWVZY09yVHE3UzdsT2VmVTBGYjVycWJQV3pKV3V2?=
 =?utf-8?B?MENCaENzUWJESmNhaGZIREZOL1VIaDcrdjhrRnM0a01HZnlGaVpja2FHZG5C?=
 =?utf-8?B?QlY5Umo4N0lpMzhOOXJlTmFIU3lmcDZ0czkrdzk1T0tmNE4xeEk2cTA3ZVhr?=
 =?utf-8?B?K0h4RTdLNUtnYnJvWGp6aFV3ajRSbW9ZWk1URFQ0ODRxb1ZpQThBZ1hOYkU2?=
 =?utf-8?B?ZmFJWVJKSmNhNjllRUs1VlRNRkxMUkwyM3ZCTHBTOGJPQWxHOHpidXYrNzlE?=
 =?utf-8?B?bDBCR1VjWTBJSlJrZDUvSVM0eXdGTURzQks4c1A3djJJSDF2SkZhUU43L1or?=
 =?utf-8?B?cVFqV0djT3BidUxsOFhMR2NVdmZob2ZPeWd0UjJBMjdOT1NpYU1FbS9ENkdR?=
 =?utf-8?B?U21rKzJQaGt0L1p5RXZZZ1ZPOTl0c3lkMEZZMzVuYWNWSGRkOGVOMTkveW5k?=
 =?utf-8?B?OVpZYXRHWUtXd1FZKzcwMUI2UjlXR3NvTEdSVGJjV3lnMGFKSW82OVF2VVor?=
 =?utf-8?B?WHNtdHVpWGV4VmdNTWNsNS9YVTkxdVE0RmJHR29zYVljZWFVQkkxSVh3ZDlH?=
 =?utf-8?B?MEVXVEEvSkgvWnlxTDlpUzhKZFNpbzJQaU5vYmorWit2ODlzbXNJNVNsWjhZ?=
 =?utf-8?Q?yy0UgtEQ2N+P8a10AStRE34OT?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 263ff7dd-8a28-4dd6-3206-08dcfad0a3f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2024 23:55:19.0382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qCLsugxAuxBxNRK/IHmzLqhODlEf1RSM0NgjxhYzsdk6bF1cIz5HN39Cke+o/9aAXFncYagGDU0yG659I13HIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6010
X-OriginatorOrg: intel.com

PiA+ICsgICBpZiAoIXN0cmNtcChidWYsICJtYm1fbG9jYWxfYnl0ZXMiKSkgew0KPiA+ICsgICAg
ICAgICAgIGlmIChpc19tYm1fbG9jYWxfZW5hYmxlZCgpKQ0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgcmR0Z3JwLT5tYmFfbWJwc19ldmVudCA9IFFPU19MM19NQk1fTE9DQUxfRVZFTlRfSUQ7DQo+
ID4gKyAgICAgICAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgcmV0ID0gLUVOWElP
Ow0KPiA+ICsgICB9IGVsc2UgaWYgKCFzdHJjbXAoYnVmLCAibWJtX3RvdGFsX2J5dGVzIikpIHsN
Cj4gPiArICAgICAgICAgICBpZiAoaXNfbWJtX3RvdGFsX2VuYWJsZWQoKSkNCj4gPiArICAgICAg
ICAgICAgICAgICAgIHJkdGdycC0+bWJhX21icHNfZXZlbnQgPSBRT1NfTDNfTUJNX1RPVEFMX0VW
RU5UX0lEOw0KPg0KPg0KPiBVc2VyIG1heSB0aGluayBlYWNoIHRpbWUgdG9nZ2xpbmcgdGhlIGxv
Y2FsL3RvdGFsIGV2ZW50IHdpbGwgZWZmZWN0IE1CQS4NCj4gQW5kIHRoZXkgbWF5IGNyZWF0ZSB1
c2FnZSBjYXNlIGxpa2UgZnJlcXVlbnRseSBjaGFuZ2luZyB0aGUgZXZlbnRzIHRvDQo+IG1haW50
YWluL2FkanVzdCBib3RoIHRvdGFsIGFuZCBsb2NhbCB3aXRoaW4gYncgYm91bmRhcnkuDQo+DQo+
IEJ1dCB0b2dnbGluZyBtYmFfbWJwc19ldmVudCBmYXN0ZXIgdGhhbiAxc2VjIGRvZXNuJ3QgaGF2
ZSBhbnkgZWZmZWN0IG9uDQo+IE1CQSBTQyBiZWNhdXNlIE1CQSBTQyBpcyBjYWxsZWQgZXZlcnkg
b25lIHNlY29uZC4NCj4NCj4gTWF5YmUgbmVlZCB0byBhZGQgYSByYXRlbGltaXQgb2YgMSBzZWNv
bmQgb24gY2FsbGluZyB0aGlzIGZ1bmN0aW9uPyBBbmQNCj4gYWRkaW5nIGluZm8gaW4gdGhlIGRv
Y3VtZW50IHRoYXQgdG9nZ2xpbmcgc3BlZWQgc2hvdWxkIGJlIHNsb3dlciB0aGFuIDENCj4gc2Vj
b25kPw0KDQpUaGUgbGltaXQgd291bGQgbmVlZCB0byBiZSBwZXIgY3RybF9tb24gZ3JvdXAsIG5v
dCBvbiBjYWxscyB0byB0aGlzIGZ1bmN0aW9uLg0KSXQncyBwZXJmZWN0bHkgb2sgdG8gc3dpdGNo
IG11bHRpcGxlIGdyb3VwcyBpbiBhIHNob3J0IGludGVydmFsLg0KDQpJJ20gbm90IHN1cmUgaG93
IHRvIHJhdGUgbGltaXQgaGVyZS4gSSBjb3VsZCBhZGQgYSBkZWxheSBzbyB0aGF0IHRoZSB3cml0
ZSgpDQpjYWxsIGJsb2NrcyB1bnRpbCBlbm91Z2ggdGltZSBwYXNzZXMgYmVmb3JlIG1ha2luZyB0
aGUgY2hhbmdlLiBCdXQNCndoYXQgc2hvdWxkIEkgZG8gaWYgYSB1c2VyIHN1Ym1pdHMgbW9yZSB3
cml0ZXMgdG8gdGhlIGZpbGU/IFF1ZXVlIHRoZW0NCmFsbCBhbmQgYXBwbHkgYXQgb25lIHNlY29u
ZCBpbnRlcnZhbHM/DQoNCk1heWJlIGl0IHdvdWxkIGJlIGJldHRlciB0byBqdXN0IHRvIGFkZCBz
b21lIGFkZGl0aW9uYWwgdGV4dCB0byB0aGUNCmRvY3VtZW50YXRpb24gcG9pbnRpbmcgb3V0IHRo
YXQgcmVzY3RybCBvbmx5IGNoZWNrcyBiYW5kd2lkdGggb25jZQ0KcGVyIHNlY29uZCB0byBtYWtl
IHRocm90dGxpbmcgYWRqdXN0bWVudHMuIFNvIGNoYW5nZXMgdG8gdGhlIGV2ZW50DQp3aWxsIG9u
bHkgaGF2ZSBlZmZlY3QgYWZ0ZXIgc29tZSBzZWNvbmRzIGhhdmUgcGFzc2VkPw0KDQotVG9ueQ0K
