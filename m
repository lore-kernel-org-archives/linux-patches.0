Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731C630CD97
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 23:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756424970; cv=fail; b=YVoz5ye2E7zPcHHqy4jAlzFmDGfcZKOHJGY2tp646L/oQSot6D9Rnp54okA3QmL9mqo/xiTgLUa/3fBqbmPNoIwsrr7vW1x9pW4SDalW8Idkdano/nn5SIuQuOXchVNanbqD0cakaWFBrTB3VpWtI12A7hSYh538VJy9E9Ozvoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756424970; c=relaxed/simple;
	bh=NK8V/UifVjqFFJBRqFb3tRPpaX1vST+AhFcC6nOFR88=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bAsbQEI/amnkWDZzMwWLCQ3Z0cKFfku/tNHMF72zNR/rAZSujsN9URkq+EHKrlRaB9c2o9MTW9or7ar0gO1q17C0r0BRXqfO6TFk5wuaTMarsqwRQCh7DCYCZCAmOzDOnWZ0SvVOYzQASfz9NP2yQFgY167mf2agfT9xiqFGExQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mo9ci6Ug; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mo9ci6Ug"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756424968; x=1787960968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NK8V/UifVjqFFJBRqFb3tRPpaX1vST+AhFcC6nOFR88=;
  b=Mo9ci6Ug2rKapw0XQeUqTu5Jr59vp9BQEymOLKqzlzd2FiEH6dtbAOnd
   z2v4BWRnKsd+p/iA14QO/u819Cc6JICd0SgpuMu05cYsZ+RCO9Zy/tODX
   ShmJurrEnZziY7PEri1hCueclsiTTbSvdlToYnPkCXe4O8z49jiAf4RTR
   gyAgnP1BzEwqm74UF+pMF5OV9U/Ew8+aV8IYqyT0JuipQglGgiUh1fO0C
   fzy0D1nCoiTLFG775lkGnuI/UXXzU4pVollxf0YG2oDOBfrEMrPVyAsmd
   +lQVTPpqEFZQhIaA1bjrP+owM9hMKCYvlTnWegxRJB8F+k/lRnY819osW
   w==;
X-CSE-ConnectionGUID: JVsQCAgnQteTXndcbtyQHg==
X-CSE-MsgGUID: tVzvFDAPS96ueVcuyhmu8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58855813"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58855813"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 16:49:28 -0700
X-CSE-ConnectionGUID: /gnSKtClRGWF03/jOx2UvA==
X-CSE-MsgGUID: B3CtbHL0TU2rRclTxfXzIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169767316"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 16:49:27 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 16:49:27 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 16:49:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.57)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 16:49:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JXHU3rHvoy3x98XG77/vpDeQdm1p8ANtX6BDqTopfnT8lV9+qnwrhoA6ixiochEXDjpuEKcAQU2yFy32DwRfsG7HM1TE2ItrJ5obdRW0dYibFpFIQn5imv6RO6SsXDYQle2+bm5eNpqbHhj8nBx/Oo/bH1Vqs7Nb1ZlJjZ2PXBjNXiYFwspU2sTPR8/4THM7V2mh6l+YnqjtKDMUgYSrV34iOitmKNU8RQHCJatmp5WbdoTqMwnt7CpzOlA8P2GP3X3bg9Pvb3r0brVAX2TLIjG30lfl7vSs4sXp0Q2RkvSeD6B5sLuoc7VoXxrM2zuzkbRn1zikWm2AmdJdstafXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NK8V/UifVjqFFJBRqFb3tRPpaX1vST+AhFcC6nOFR88=;
 b=J/ILuQ46BpfzZM6DNQ0qJ4yOc9v6+wUmxp5/xiM3RnBW7KfnnjlldD+6NIaTvhaIRipNYlR8+h9BaQL45S9WlLQeUHReMUV48HnL8DdIL2crdwBRgzBSO3327BC+secS4PU4To68ERl1UaHHShjlXr7j8fs4tG2+s3KeK78t1nu5cuBs738ROZvfK+wxbfsdOCiKkwEfZKcIi8W9FfOjPLvR3ONSyEAEKygUW3HDjOcN92KdP3o7FoluIPnY/jaQQoL686tbEQKCmG1OJPb6IykWhTZPaAKwXgDZqOVx0CIT7SCT2zOOPsMqZdxvJA9sxPJJJmMD7lECOi9HsSlBsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB6830.namprd11.prod.outlook.com (2603:10b6:510:22e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.24; Thu, 28 Aug
 2025 23:49:14 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.9052.013; Thu, 28 Aug 2025
 23:49:14 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Thread-Topic: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Thread-Index: AQHcCuw1uJ+c6s9abkKfAjwTQIKC47Ri2J+AgAEH+4CAECZ+AIAEWXCAgAA6eICAAB7ngIAAG6+g
Date: Thu, 28 Aug 2025 23:49:14 +0000
Message-ID: <SJ1PR11MB6083B735CCDA74D30F605FD5FC3BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <c1d03d2c-9f5d-4fcf-91ba-dfe2c5907292@intel.com>
 <SJ1PR11MB6083A9FDABF6F33456CD14A4FC34A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <aKzhsOWp2TlFF5mK@agluck-desk3>
 <d06e81db-1669-4a6c-ba75-67fe15c53303@intel.com>
 <aLC4wVQiBDHW_Jte@agluck-desk3>
 <b3874a0a-f4b6-40cb-a705-d5c94d6173e3@intel.com>
In-Reply-To: <b3874a0a-f4b6-40cb-a705-d5c94d6173e3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH8PR11MB6830:EE_
x-ms-office365-filtering-correlation-id: 46db1800-f4c4-4dc6-3ce1-08dde68d7e9f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Smo2OEVQdFkreGNITFFoRWwvbXFwc0Q2VkNuaE9wWExlTjFrRUtCeWExanRE?=
 =?utf-8?B?VFhJTmJRMW14aVR3UEhMVy9YRm1qMThIbGYzMFlCaXE1NDMxQi9icVZQbFlu?=
 =?utf-8?B?MENUZVoybjcwSUIyeTg3VmowelVvZ3hZNWZDRWZveERVQ2xPVWlNbHhaemhi?=
 =?utf-8?B?NkYydDhoVkNRUGdNS1M1SmhqRmtUNVljWUdYR0VPU0cvL1R4cmgwdGZyOGd1?=
 =?utf-8?B?TXBGQm5XcGNZdFlBYk1FNTRucnl6aEF2RmhUMnNScldpTUEvaWljbk9QR3R0?=
 =?utf-8?B?Y2dieHdhZllXSWZXNklQc2ZTVDVodFUrcHozZDIwZktHSEdxaVdMZ1NWam9G?=
 =?utf-8?B?ZW9jUGxscVZQT0lnRndsYkZjYkYvTDkwanFUbWRsNE5xRXRDNVZSeVN5YVFI?=
 =?utf-8?B?TUJBckZ1Vkt6SWs0UVg0UVNGOXd4OVlXR0dRSUJrelE2QjF6VW80T2dUaFFn?=
 =?utf-8?B?MVRxd3F5YnNvU2JQMmlORkRXWTVhU0JQRlpCZDVGdFQ0VTFBNUNvWjRGOG4w?=
 =?utf-8?B?aWV0THhWM3phM2pKWEJ0L3BiY2o2aFlnWFhWbW9yanV0UUhYbVRnZGNWU2ZG?=
 =?utf-8?B?NTB4aXFUY1VLTW9FYklubkx2VkNKVGxISSs4WDh3ckd0enE5UlRxVGpLZjlD?=
 =?utf-8?B?SXYveWtnTnRta1hGcHY2bVNDdW95U3V6cEhFSGl5bGpDRC80MGhXUkRpU1hn?=
 =?utf-8?B?SDBmTWsrY21TbWxSbHRrUGNWaEgxVzRwNG96eHpaTE9Gd1IzdXp1b21lbEhx?=
 =?utf-8?B?MnI3dU1Pc3VVa2UyWTR0ZVYzZE9ZMzVpSzVVZXhBaC9tcjJPWVUxWVd6MjI1?=
 =?utf-8?B?a29LakZaM2tIN2VuYk0wUXlZejhpbGwreW9rb3FvenJqTjUzMnJuNmtIZmZy?=
 =?utf-8?B?OUhnczg4bGhMZ3RKT1BkNVdKN05MR3FSM2ptWUJ5Q0k0TzhMYTk4UExHWTVJ?=
 =?utf-8?B?ZGNicldWSVNidXFhdVY1elk1QmxjMUdndnJzN2xwSGQvWGF5QVNXTVE3Rmp2?=
 =?utf-8?B?TkNidkZTQVBOcCtXK0ZSRUpnTHljaEpYTXZpM2hwa3ZpZEhvSitOK0FwU0Vl?=
 =?utf-8?B?NWVNNk9EUk12Y0J0dnRmdHJTNjk4SGwrZ1BkYjdBcjJXUldycUFlNDdjNU5l?=
 =?utf-8?B?bVlLTis0NTIrWDJlUTU4elNtU3o5cTV2ODAzSER2Z3pYcmd4R2x4cFAyRmt5?=
 =?utf-8?B?UkdWWWhpMFJ1a0h1MWVqR3hHSEdnMzUxV2JJWkFSbWtmb0pSaW9ocXZ1ZGxC?=
 =?utf-8?B?bkZFZ29hTEQ3UmV1UTQvcVhwNkJwdHZqOTZWU2FQQmxSM202SVZZMjFHVHBY?=
 =?utf-8?B?YXNqeHFvM0xIYnJWU05PSUcrckpMaldTaE5HZCtMK0lsNG1Xbzcxa3AvZkp6?=
 =?utf-8?B?bGZuR0s3MkNHWS8wenVkTU5xMnhrbGJwTWxtUndISGZONjJQbFNqUnduUWZQ?=
 =?utf-8?B?N2xyMGtlVGVuUml1cVJPVVhIREp3emFkVWxmVE9qQ2JBS3lJUUlJZk5JRTBR?=
 =?utf-8?B?UVl2WG1mNGNoTVd2UERoc1RSY1YyNlpNMk9iMkRDUXQzT0xjOE13RENOZTha?=
 =?utf-8?B?bHZrcWFXcjJPQld3N3FoM1hDM3ZJV0I5aDNZUnVjZUJmcG5BNWMzTTVLQktZ?=
 =?utf-8?B?bk9KSDZPTVF4eURIS0JvWjI5Q3pFR01BZlc2U29aTzVSYThpdXl3SWVGdWxU?=
 =?utf-8?B?V1RIQ1pLVVgzdkZldkhrV2lFNlNNbHlZcFphemMrNGdmUXM2end2ckk3cnhF?=
 =?utf-8?B?aFlrcW5VSmZKZHppT1FkbVBmTTlJekhtU2ppY1dJYXRJbGM1K3N1RVA0c096?=
 =?utf-8?B?QitRNEZJS0d3SStrWkhtTzg1bXZkdm83dlJSSXR2ZXYrWkVqOWZJRGp2TEM1?=
 =?utf-8?B?bkxNRUVzbml2SDQ3QXJhaktSR3BEcDUwdGZvYTNucFh4aFVieTZTL2tVREhP?=
 =?utf-8?B?d0drY0J4Um5EV2I2MVMreXI2YWZJMFBIVU9XZTkycVkvcFA0WWRTOTcvdTFy?=
 =?utf-8?B?N0E4RHF4QVJ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDlPRStDc0dvQStEb0IwaU9ia3RFbWlMZ1ZCSEF4Mjg3Y2FwOGdTd3FOS2o4?=
 =?utf-8?B?SWNxazJjOFdDTkNYMmk4UG1aNGVrbkszdUI0aG1STy9tVFZEa085YjRMZ2V0?=
 =?utf-8?B?OTk2NUdPZ0d4cG1Fb0kxUUo3SXJhc251cDYvT25pby9QNXJFUlkzVTIrblR4?=
 =?utf-8?B?bFdaVjFKSzVTbVlFWmtJcXNhU0IycWgzWnl0Qk8vUVIrTWtTaldOT1RHNTlv?=
 =?utf-8?B?SmttMGl2TXhOTEpJK0QrbjZWMS91SWtseVRWTTh6Nll4TXBpUmZSdDdmNDFT?=
 =?utf-8?B?TFk3NEdydDQrRXZNeFRPTDdqcHRRbjljK1hvdUZvRHp6djI2TnROUXV0ejZK?=
 =?utf-8?B?MHJnVjNOTWtLSUNKcVJjYnFkRmFwc21JSkE1dDZMdE5PVmRzbWFDZFpFbVpy?=
 =?utf-8?B?cjRPY3VtSG5PR3JQM1FJTVYwdXpqRDd0dkpWZEdGN0pIVXNWaWpNdHRTSW9Q?=
 =?utf-8?B?aUVYRlRsS2hicTlLUFJnTW9RTXFHcHBNVExwdFo2Z2Y3TXZlR1lNYU1WU3hY?=
 =?utf-8?B?bWtmcUJLMzJGNEhHR1dnMG4wbTRZRXdxM3c0anFyUUIxYVh5cUp1dDZLNnpM?=
 =?utf-8?B?bFNFZEVraisxcTloeHlGWWFTU3pTTHI5dzNHR1hFWFVvRWFRZFAvNHZNemVw?=
 =?utf-8?B?K0VOdWxtdVV4T1E0UVo2TFpENmlnVHNjcFhZd05MckVqQVdFVkdHaDJybUZ5?=
 =?utf-8?B?UHZSYnozV3hFT3N0eUFPY1RPWllRdE5uTDUrY1lQb0tLakY4TER2TGUwdGRs?=
 =?utf-8?B?TlpoZjBWQ3VkSTlYZEwxMzJ1Q2FWZzFiMlVFd0Z5WXVJemZvTUdsMUpNYXBm?=
 =?utf-8?B?djIxblYwbUtMSWhGeEpRaXZxRGxnbXdETWlHamh3N2l5STVoVXUwRlFDdFFZ?=
 =?utf-8?B?VlpybFZneUI4a3JoTGN6OE1MS1JMaEw1b2cveEVYSis0Wkl4emdtbUdUK0xx?=
 =?utf-8?B?VTF4MkhKRlptVHFremJoelVmUmhsSkNjZHhYYVRxOHMxQzhRQWpaN2oyUjBE?=
 =?utf-8?B?TzJ5Ky82V0FzRnJUTStBY1UrSDQ4bTZHR0FwQnhGVVUzUDNrc3JqNlZXVjEx?=
 =?utf-8?B?Y21FMHc4eGd0aEhvQWxXaWFOTURJWGx0RHFXbjVYczRxTTRiNzgya2FaT1V1?=
 =?utf-8?B?ZXNNSjBkUDMrbXdHZUUrcndiemQ2am9CWFI4ZWRqeFVFQTdnSFduUnNTMXJU?=
 =?utf-8?B?eEliUjZHY2dBdElxdm1TWXJaUkFDT1VnOVBkM3Q0L1Flbnc3d3JlYkExNVJX?=
 =?utf-8?B?NFRNWk93RDEvV0hJdERSWlBTbFl4bFpsUmxBbDhsMjlCTVYwVURjbHBSWHFq?=
 =?utf-8?B?dXVNSlJPM2JJVlhDMk8va1lxenFyVFNMYmNBMEJBRGQ5YTdlS2lNRXcrVUQ0?=
 =?utf-8?B?THFENURVdzF0ZUM1bmZjQTJ4bU5wRGNRcDFKQzNTMFBWKzQ0aWRibUxYdkUv?=
 =?utf-8?B?dEkxY29scHBmVEtBVlhramxHNzlPZ09odGRXWkdCUTVnVENsL1crd3Rocm9H?=
 =?utf-8?B?TXM0Kzk2bFhNS1FPa3lFTlZzMW4zN3J5T1piZlpOTEYzamNHd1ZqaGNzcXNr?=
 =?utf-8?B?RXNJZXRTTU8vd2lBOGpqS244TXA4dHVCOXA3SGh5bWlzMk5weGhHVG5sNlN4?=
 =?utf-8?B?RTlBc2RaV083a2t3WFNMWnlhOVFnbUZmaVlrN3BsejdoekhTY3dBUXJYS3RP?=
 =?utf-8?B?REhQYXMrVi9lbjJ4bjFWMmNIb0tjajhwYmVRVHg2eEVTeFBHSVBNelA4Lzly?=
 =?utf-8?B?cUN5T3kyU1QrV2pMNG5heXh3eE1RdWtWTEg2cDhRUnV4aTBxekE2bDVCeG52?=
 =?utf-8?B?YWFyK1AwRUZKMEFoL2Q2VGxkalRDalhpa3RlajFrRWZlU3d1Uy8zR3Z6aWxz?=
 =?utf-8?B?YUpBYncwd1VhOHkwN3prT0NLRUZIVFNzUE5sU29LVlBYWmhPaWZWLzN3NUdH?=
 =?utf-8?B?YnE5R0dMemQ2bFNmK3ByQzk5SkhsS25GTG52WG5ucEZjSldCQ1JVRzMxWkhD?=
 =?utf-8?B?Mi9kVnRQZk04UWQrNXh0V1dTUU8rNU1KR0tSOTNJaGludUxnZi81cXVWTzZ1?=
 =?utf-8?B?U2c2akhwZEUzbVUxYjBUODVkckJGODlYYkVPRmUyN1FzTXA0YzUwTVdUTVpo?=
 =?utf-8?Q?MeMR2XXa0WWMYK6OIpITo41vV?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 46db1800-f4c4-4dc6-3ce1-08dde68d7e9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 23:49:14.5591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzR4NdTTvFuoCg3Az5w0oI3yTQlVQMoEd7QXSWzOX96t5Je5E++femiVaDMWGa19BBTBCFtuaxOEUe0j39woYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6830
X-OriginatorOrg: intel.com

Pj4gSWYgdGhhdCBpc24ndCBzdWZmaWNpZW50LCBjYW4geW91IGV4cGFuZCBvbiB5b3VyIHRob3Vn
aHRzIGFib3V0IGEgaGVscGVyDQo+PiBpbiB0aGUgSU5URUxfUE1UX1RFTEVNRVRSWSBzdWJzeXN0
ZW0/DQo+DQo+IFVwZGF0aW5nIHRoZSBjaGFuZ2Vsb2cgdG8gaGlnaGxpZ2h0IHRoYXQgSU5URUxf
UE1UX1RFTEVNRVRSWSBwcm92aWRlcyBhIGNvcHkgb2YNCj4gYSBzdHJ1Y3QgcG10X2ZlYXR1cmVf
Z3JvdXAgZm9yIHJlc2N0cmwncyBwcml2YXRlIHVzZSBpbnN0ZWFkIG9mIGEgcmVmZXJlbmNlIHRv
IGFuDQo+IGV4aXN0aW5nIG9uZSB3aWxsIGJlIHN1ZmZpY2llbnQuLg0KDQpPa2F5LiBJIHdpbGwg
dXBkYXRlIHRoZSBjb21tZW50Lg0KDQpJIGNoZWNrZWQgd2l0aCBEYXZpZCBhYm91dCB3aGV0aGVy
IHRoZSByZXNvdXJjZXMgbWlnaHQgYmUgdW5tYXBwZWQgdW5kZXJuZWF0aCB1cw0Kc2luY2UgdGhl
cmUgaXMgbm8gYWRkaXRpb25hbCByZWZlcmVuY2UgdGFrZW4gd2hlbiBJTlRFTF9QTVRfVEVMRU1F
VFJZIGhhbmRzDQp1cyB0aGlzIGNvcHkuIFRoZSBhbnN3ZXIgaXMgY3VycmVudGx5ICJubyIuIFRo
ZSBtYXBwaW5ncyB3b3VsZCBvbmx5IGJlIHJlbGVhc2VkIGlmDQp0aGUgSU5URUxfUE1UX1RFTEVN
VFJZIGRyaXZlciB3ZXJlIHVubG9hZGVkLiBCdXQgd2UgcmVxdWlyZSB0aGUgZHJpdmVyIHRvIGJl
DQpidWlsdC1pbiBzbyB0aGF0IHdlIGNhbiBjYWxsIGZyb20gcmVzY3RybC4NCg0KVGhpcyBjb3Vs
ZCBjaGFuZ2UgaWYgcmVzY3RybCBldmVyIGJlY29tZXMgYSBsb2FkYWJsZSBtb2R1bGUgYW5kIHdl
IHJlbW92ZSB0aGUNCnJlcXVpcmVtZW50IHRoYXQgSU5URUxfUE1UX1RFTEVNVFJZIGJlIGJ1aWx0
IGluLg0KDQotVG9ueQ0KDQo=
