Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DD121D3DF
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 23:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749512056; cv=fail; b=uI8TWZmamcA7MiKMM3V7B7AsXRC8fU8iCrN513YNhE5SDcUKsWyKPbGI35Q009It2CEm0nNSICdZoKPr0WXBClMm8UL+gdeIy/xFi7ZvCb/Vp/1Wf/v0+WBddy1l0155v8pK1C0Tr7OOTjF62VGnVTXX5q8rZe9R9F2d+0dkfzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749512056; c=relaxed/simple;
	bh=1rYF/2O+2BJh54wHYZbwfeIepNRX0fmiCS6Ul9La/rM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tR1AvgYqj0PkyZh+3W2w8HmbpWIO8V/9+Ytjshvt4UjuzQS0BOYHIxCpS9MzfB8hTYpHBydLuCoPr0nvb1E26yv4uyKc+jObZNbURhcoPlru1IyD3fbZD3CF8D1CBU5AeL6EfkbxjLGYgEQCvD2UCZ5WOLj2X6aWkbXVWUI5ZGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J9vUAAuA; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J9vUAAuA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749512056; x=1781048056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1rYF/2O+2BJh54wHYZbwfeIepNRX0fmiCS6Ul9La/rM=;
  b=J9vUAAuA5pA8ZGSLSqEbF61CLR570XVAPvLmZk/zV2ehgEq2Iic+IJMh
   Z6hMtkx3bQoChwP6h8UFDTtVAJlgWrsxT4dsLU8b3Ly6QOOjq2PfBNVw/
   hinftnQAs6vBYEfFR/kADN/sy66907PL5MjjZwnDZprOvQG7JkkgDvvgQ
   P5meTbZBwG2Kmus1a/EljbtwVpmA/LJ31BW0vRnYu7bQSylklL4FwvcsF
   4mI9RXrn97OBRVY8IfZHubWlgUqsfh72vd63ClxSXzH+4AKfsybCiG2vo
   Ou8Qzqy0egpx5tHuw3c1C+gLUIkIVuwRJa34ojaAJ6dXR+K43qzg4dGYD
   g==;
X-CSE-ConnectionGUID: 8RVC5SmDT3OlUzLA9JWlyQ==
X-CSE-MsgGUID: /V3iOrqbQRaCP7QpHSSZ7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="62958619"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="62958619"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 16:34:15 -0700
X-CSE-ConnectionGUID: bJBDwz67SA6OYBfmn2oPQQ==
X-CSE-MsgGUID: +PKIs0RWSxORhlNbLmsbyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="151656524"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 16:34:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 16:34:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 9 Jun 2025 16:34:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.77) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 9 Jun 2025 16:34:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kbnnIVa21TISIeodsdzpZXaM+zoeNy9FF/y2LzzmOvaHes1fjxiTEjASLoQ2p3EncuJo3YoL8hzyjwGMLngauJSsp3+kc2n21vZw2Q6X1mFSUtlQAVosibVbv4/Jhe0b/SgOIVdZcfZuTMKYvHaHAp3AhWvKcqHJUYTmRhXyr0OleydjlhxBOSplyujemaCmisZQrOQ6PJus8Rs5/7ZkDloAYvrXuxc055CHC0JVF0B9p+OKNxcbkPENV+/TpsfaSxxF9cCrHqpC0WMxOzy4Ez4GQsPq2oXC4sevKZUKwdX1qhlw0XevXKMLFGgJTxeXOCSK2yz7mlbfFEKqK29RxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rYF/2O+2BJh54wHYZbwfeIepNRX0fmiCS6Ul9La/rM=;
 b=lWFHdanFpTOOxbHqlld0M/5FyAGvtUjjWTSc4CydK5PiIxzwkgunxVNlfvnMgwEEHxELr0ee+Uq9bNaZgR45jMJuesHiRhkUYsPkNS62Z1sRpsouuzN8IbRV+/td6CGKw/JMuqy2FVU3kLibS8GTTBRS3B6E3fFvEdj8megEBPpQOtM4Lmwv6TQRrrq5A1dLkSVtLdS1Gtc7WsUaSdr4hnTnSezidoLSiwMOGvuM9JlKYEwjlX/EdDSLlMyvOxUdB/IaZxxplhSPrTmGgWbAPXy4UclXHcU7vfiW+ovgFuVESPB2zKLClLJMCVCl2EIbf2Jwz0WZMZwEo+NmMuMnGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB6854.namprd11.prod.outlook.com (2603:10b6:510:22d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Mon, 9 Jun
 2025 23:34:08 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 23:34:08 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, "Chen, Yu C"
	<yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
Thread-Topic: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
Thread-Index: AQHbyqLX473MPadm60CQRdpGx16QQrPyeTYAgAPw74qAAFC2t4AEzq2OgAAF/+A=
Date: Mon, 9 Jun 2025 23:34:08 +0000
Message-ID: <SJ1PR11MB60834D5E5D78CE229D04204FFC6BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-28-tony.luck@intel.com>
 <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
 <aEIxzbuFybLBE3xt@agluck-desk3>
 <9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com>
 <aEMlznLgnn6bK9lo@agluck-desk3>
 <d2be3a4e-1075-459d-9bf7-b6aefcb93820@intel.com>
 <aEcsxjWroliWf3G0@agluck-desk3>
 <fb2396c1-3799-4d45-ae24-ce7e6f0d42e2@intel.com>
In-Reply-To: <fb2396c1-3799-4d45-ae24-ce7e6f0d42e2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH8PR11MB6854:EE_
x-ms-office365-filtering-correlation-id: 1cf1fbf8-fada-4acd-46fc-08dda7ae217b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NmMzanpESWR6VnQ5WXplRG5oZVlBaGx0Sk1Yam5mMXlBaHJxdTZacllUOC9W?=
 =?utf-8?B?TkRYMUxyeW4wV2w3V0FsZlJJUXZZMTNiRUR4YWNYZStWcXVJS3QxQ3lTaHBC?=
 =?utf-8?B?TTZYRi9BT09MSHBRdHJ6cW1ZY3FUUDRhQUptOHA2eS9LTldzQmJTa3lENWN6?=
 =?utf-8?B?MTNDNWFWYi8yMTBQMDIvZzRWbUpJYjFieGpRTlVwYUpCbzhGQVUxUjVSZExl?=
 =?utf-8?B?M3kxblcvdDRqbG1QZE1zYWdCU20xb1dmN3J2UVBSUUFlOVZoRlVCb2lXL2ZC?=
 =?utf-8?B?U25Xcm5GajkxUUh1NEdkdU05OEM5aCtyNnZjd3B6eVVzdHo3d09vOGhicDZP?=
 =?utf-8?B?RFFxMFVYT3pTUTNTUEFEeGk3by9SU2dyTWRtbmVFVlI3cjB2Zll2NGpNaUxZ?=
 =?utf-8?B?UnB2blhLdkdUbzZDcG9MNG9YYmhmN1VOdjVnT0VPaGZ2VzBTZUE0cmJqUjNH?=
 =?utf-8?B?V1dZa1liNEJQUGNpQjdKZnlHZEV3NkF0dUNEL2xaMTdmalIrTzRiN1lkb1JB?=
 =?utf-8?B?L1hTNmNtUnFVU2dRRVFVZ09jc2drc21ZZTROa0g4TjlONUs5L1pLcTlMVFQr?=
 =?utf-8?B?eGlBekdWZytIdnkrMWY5T01EK2o5dDVWSXBvVDVPditPRUZhWDVRc2IreHJl?=
 =?utf-8?B?R1gzY2NiSzZBL3NraVdJZi9aK1BzY0RFR0RjN204VnhnWi9zZUF6eGsveEZT?=
 =?utf-8?B?ZENBQ1RvbkpEbm04ZjhYZ2pQVFFFREp5bjNpMTcxZTR5cmZ0K0dVeDN5V3Zz?=
 =?utf-8?B?aThoT1c4WWdtbkt4YUtOaG9lVXFVdWN2emhjaEpMNFRiTlFQMlRDZE5JTVM5?=
 =?utf-8?B?RE9ka3JFZlQ4ZUV3RVdxajBQNjBFZjIxTW1DaXVSODFBSm02RmFyZnAxKzFK?=
 =?utf-8?B?K1MyZk5Gd2RoRDJtYjBaMXltbk53bHBYV24wNnhKSXBTbkppMFQ5cGxOcWpu?=
 =?utf-8?B?SlpVT1drbjBNK0VJSlJWZHAzc3FScXJVcTEybjNkK01SZFhrZW9MK294alFD?=
 =?utf-8?B?Q2Nna0FQeXI5M2dYRG5Yak9UWFAvSm9iQlRSQVlGZm9mNkluV1RYV1FGQW9I?=
 =?utf-8?B?b3pPcnVmQWFJa1FyeGFzWnhXMER3V0VRL0lwUVJ5Y05FYVZZNENnS2I5SU5i?=
 =?utf-8?B?aHVIcDFtdGFVSGxIeUF5Zy9kRXN0RFRLLzlOQVR3bkd6QmRaRVVFa1Nlby9Q?=
 =?utf-8?B?ZDBNc1RPcGxZRXFlZ1lWaW10RVFoTlcrUWs2cGRTMUFKT2JndGZHQVA4aUFE?=
 =?utf-8?B?Rnd3eVlzZ2NsdjNOa3o2UGNtYjhpdzltV1dBRUJ2UTBBQy82R3BnQTY5a0Q2?=
 =?utf-8?B?ZDIyZGtFWHJmc1V5MUNpaGxDOXlYWVZFcDVZQTlMTkVITWRwRzRtbldINEly?=
 =?utf-8?B?MDNNckE4QzNkQlYyNlI3MTRJNkNGL2c3ZVJaVFo3UDB2UWNnakVqM1paTVd2?=
 =?utf-8?B?WCttVUFNVEVRMVUvNk5JNDM4b2hUT2xPR1lnd0RHNGI5eWlKRVllVWM5MEhL?=
 =?utf-8?B?Qm1ubFBURUI4V1hYY3phb0FEZ3J0bG1EcjlmNW14cCsyR0V2QUZyMmZod25P?=
 =?utf-8?B?YUVmTktxWllPMG1hRVh6Mkwwa203Z0VSdzhFWHc5WlhFK2lFMFFLRWM5b0tk?=
 =?utf-8?B?T3cvTnJuYi93aWpyR08vb1BZSFlhTC9FQ3RxRjFBTWN2RWhBU0lXV0NJN0l3?=
 =?utf-8?B?c2FsdWpZdzI1N24rUVQzUXdWM0RLOE5mWmk2dWIxVGFqdVE0cEZlUHVVSlNv?=
 =?utf-8?B?UVE0eTRsaDMwdUhwc3J2T21zL3kvYVhVWVFYME5vcEVzWGVHcDVaemVyMVJn?=
 =?utf-8?B?YkRVVHNORnE5aEg0clVQaHhxRDRZYnZDNE9uNkVtVlRmd1U1MXh3RTVvRWFO?=
 =?utf-8?B?S0hlYm9uclZZZERXU3BXTzkrZkJzYzBkQitna1F6T25ORXBHNG9pK2I1OGtN?=
 =?utf-8?B?RHlLTDlQdlpCNDVZQ3pBT1FaT09NR3Q3TERSV3I5RmZxQzl6c2JEbFhpUkdJ?=
 =?utf-8?Q?OANzNyXxiKVIVXeAQAt7wRihprXVzo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWVpS2JiOVV4bjJYMG5uSWIzMEkwMTJQODBnd3Q1cUJ4S0xBeGdiTTFsWnV1?=
 =?utf-8?B?NnRJUlFzOUM5c1FjcGZiZm5IczU5ZU03ZmlPUE5yRUx3UHRCMFZ2YldnUG1y?=
 =?utf-8?B?VDV6RUc1L3g0akNGck43MmdlSWpSaWFNQUFSUzNDNkt6eUs3MmlNTkFiYVRW?=
 =?utf-8?B?a0tmUENlTHIxVDBCZ1VGd2Z4cVZ3ejFKa0RTZFdPQ091R040TUpJTHYwRUpD?=
 =?utf-8?B?VmhYcnpzMWphRWM4eS83ZWc1ZFZ2T1hWVWh6azJuRkdYNFpESXhZNW82MWlr?=
 =?utf-8?B?K1g1V3FyWTlxb21za2tyN2lHTVREZS92aXdMNFVXL3VJYWhKUGdNSlo4K21T?=
 =?utf-8?B?cnpQUHJEdG9Dd1NJYlVLOFY4bEhFUVJPNXBXSXRzWXp4ZTNnbW5vRW1ueVRZ?=
 =?utf-8?B?T3lPTVJxQkZFRDZyenFHZWF6dE5ySjlZUjB4ZGtnTDRXZ0Y2RDJVNjNzZy9J?=
 =?utf-8?B?bnp3eEFzMUNTaFpCS1d5aGtEY05SaU1rWnFKREswM25Xd1c5Z1JVYnhDNlR5?=
 =?utf-8?B?MUZ3djFvcU1EY2pjc1BjTjkrL2lRM3hrMi82WmNTLzJiMHZpbkoxNThtblY2?=
 =?utf-8?B?aEEwdGk5dTlzTFVRb3BaZXJ3bk5SL3VtbC96VnludWlsaUE3d1VReVlia2Y2?=
 =?utf-8?B?WVcycm51QnBnK2xGZTFnN2hrRVp3Rm1QZ3RtbzV3MC8rNkhpSi8yYjBMMy9r?=
 =?utf-8?B?b0pYNkFoSzRpK1ZkZ0xmTlNZZXpaVmFZOEpuaVQzeG1UVmhIeERyanJKRm5l?=
 =?utf-8?B?NUI5eHBDNWRRRDBGSEhyVTJzMEcyT1lHVnJ4dDhqaG9laFJNNzkvTTJsZzlI?=
 =?utf-8?B?NlRGbGVqbm94UGsxcWgzQkJEY1lHcVdjQlN0TmxUaW9ybEJORHlpdjNHK2ht?=
 =?utf-8?B?M1lkTWNHTXhsMXpvMnRseTlUTHRUckN5aWU1bmxTdFI1WDVOengxOHZmVTJV?=
 =?utf-8?B?a3pVTXNiNlpZL0dDZGZnRmlHWDJxcGNCbGNtakYzdFRBOHFrVkh0elhOd3pH?=
 =?utf-8?B?bCt6STVqcDdHVDhGTzlhd3hDZmxrK1RHb0VNaEpOa0NxTXd1dDE4K2dDYW9N?=
 =?utf-8?B?ZTRWS3hIdUYzN1NNRmloTzZnWDU1SkhibjNNRml6dlF1bnBaeG95SFkrWitB?=
 =?utf-8?B?Znp4ckFoYUt3OTZIUEhwYlRTeVRhcFM0QzUwNDk2YStaY3B4eHFzMGpjSWxk?=
 =?utf-8?B?dzRETFpPTTlnVldBcWlNWndDN3lhQklWdnU4Nzh5Nmkxdnhva0FHclRzamV4?=
 =?utf-8?B?UXh0Q3lIVC9VV2QzejVZbGJUTDIzaEtncHFWdFc3ZHNuOSsrYm5ISE9vYkVT?=
 =?utf-8?B?SVovN3gyUHlwQ0VkYkJMZzBYOWRkQzdiSDRLeW5QdnZzNEhPTVJQZlVxNEtH?=
 =?utf-8?B?bzNsTndDYjVtVTFQbzJhKzdkTlYxeUN5RVN3ZTNaU1RDaUVwK1NkV0lEZGxk?=
 =?utf-8?B?NWNySHBVQVloUDZxczlYUHhybjUvRDE2bnBwUmljVmhCU0ZSa0h0RUhodnZC?=
 =?utf-8?B?WkVKV1dyVFNYYmt4UGRUU3pNckc5WUNYMk80KzdSWmZHS3ZscnZocHBDakU5?=
 =?utf-8?B?NkFzQU56OTlleFg3SUJ1NVhJSTgwbFdDaVo4WmNKaGZvbUpjVmQwak9CQ2tN?=
 =?utf-8?B?SXNUQWYrSkpHRUZkY29uWVlXTG1zYjZ5WklMRmRQQUlMTEdvN3dGamxWY2oz?=
 =?utf-8?B?cGF4NGoyVFltNWZxMHRoc2wwVnFhZUJPNUpwWkNLUHNXTlVBT1MvdkZRbFJZ?=
 =?utf-8?B?NEQrUU40dU5ya2ZlNEwraDJjY3Z1VlJQdEQ2dXF5WmxUNTEvRXVxWHdHZk5l?=
 =?utf-8?B?Q3RWZ0grcnp3dFVvY3Yrb1o1V0RHeUJJWENLTjA0dXc2R2FFSlZ3Tytndi9O?=
 =?utf-8?B?ZjlmdG10VWl6VHlJam1YVndZTWtKSDdZU2Rod1EvU1Q5UDlPeFg0MWIrZjBZ?=
 =?utf-8?B?eFJRcXpvZXpXLzU1ditlU3hNLzhWS2kzd2JTdXAvUEVSbm14WmtROXpOcFE3?=
 =?utf-8?B?R3JyOXc0Si9MWDNyVW13QlQzZEhuMnBwQ2o2eFQ5UU1xNnEyK2ZlV3ByQU53?=
 =?utf-8?B?S3BmaXJZM21LY3o0M09ReVdFaUlLYmJ1T296ZXMvL2JOMGhoL3ROdDk5UzQy?=
 =?utf-8?Q?RtYverqttDys3MG7lzr/R2Ne/?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf1fbf8-fada-4acd-46fc-08dda7ae217b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2025 23:34:08.3866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jkjjvcP54E/rnz9w/66R9HdAis+GTgnRf0HTp6V0riNKrEgI/eh7sD3mXdC6vHYeLbKmZvzzBCauVMs8cGy7Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6854
X-OriginatorOrg: intel.com

UmVpbmV0dGUsDQoNClRyaW1taW5nIHRvIGZvY3VzIG9uIHdoeSBJIHdhcyBjb25mdXNlZCBieSB5
b3VyIG1lc3NhZ2UuDQoNCj4+IE9uZSBwb3NzaWJpbGl0eSwgdGhhdCBzdXBwb3J0cyBpbnRlbmRl
ZCB1c2Ugd2hpbGUga2VlcGluZyB0aGUgZG9vciBvcGVuIHRvIHN1cHBvcnQNCj4+IGZ1dHVyZSBy
ZXNjdHJsIGZzIHVzZSBvZiB0aGUgZGVidWdmcywgY291bGQgYmUgIGEgbmV3IHJlc2N0cmwgZnMg
ZnVuY3Rpb24sDQo+PiBmb3IgZXhhbXBsZSByZXNjdHJsX2NyZWF0ZV9tb25fcmVzb3VyY2VfZGVi
dWdmcyhzdHJ1Y3QgcmR0X3Jlc291cmNlICpyKSwgdGhhdCB3aWxsIGluaXRpYWxpemUNCj4+IHJk
dF9yZXNvdXJjZTo6YXJjaF9kZWJ1Z19pbmZvKCopIHRvIHBvaW50IHRvIHRoZSBkZW50cnkgb2Yg
bmV3bHkgY3JlYXRlZA0KPj4gL3N5cy9rZXJuZWwvZGVidWcvcmVzY3RybC9pbmZvLzxyZHRfcmVz
b3VyY2U6Om5hbWU+X01PTi9hcmNoX2RlYnVnX25hbWVfVEJEICppZioNCj4+IHRoZSBhc3NvY2lh
dGVkIHJlc291cmNlIGlzIGNhcGFibGUgb2YgbW9uaXRvcmluZyANCg0KV2hhdCBleGFjdGx5IGlz
IHRoaXMgZGVudHJ5IHBvaW50aW5nIHRvPyBJIHdhcyBtaXN0YWtlbmx5IG9mIHRoZSBpbXByZXNz
aW9uIHRoYXQgaXQgd2FzIGEgZGlyZWN0b3J5Lg0KDQpOb3cgSSB0aGluayB0aGF0IHlvdSBpbnRl
bmQgaXQgdG8gYmUgYSBzaW5nbGUgZmlsZSB3aXRoIGEgbmFtZSBjaG9zZW4gYnkgZmlsZXN5c3Rl
bSBjb2RlLg0KDQpJcyB0aGF0IHJpZ2h0Pw0KDQpJZiBzbywgdGhlcmUgbmVlZHMgdG8gYmUgInVt
b2RlX3QgbW9kZSIgYW5kICJzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zICpmb3BzIiBhcmd1bWVudHMN
CmZvciBhcmNoaXRlY3R1cmUgdG8gc2F5IHdoZXRoZXIgdGhpcyBmaWxlIGlzIHJlYWRhYmxlLCB3
cml0ZWFibGUsIGFuZCBtb3N0IGltcG9ydGFudGx5DQp0byBzcGVjaWZ5IHRoZSBhcmNoaXRlY3R1
cmUgZnVuY3Rpb25zIHRvIGJlIGNhbGxlZCB3aGVuIHRoZSB1c2VyIGFjY2Vzc2VzIHRoaXMgZmls
ZS4NCg0KV2l0aCBhZGRlZCAibW9kZSIgYW5kICJmb3BzIiBhcmd1bWVudHMgdGhpcyBwcm9wb3Nh
bCBtZWV0cyBteSBuZWVkcy4NCg0KQ2hvb3NpbmcgdGhlIGV4YWN0IHN0cmluZyBmb3IgdGhlICJh
cmNoX2RlYnVnX25hbWVfVEJEIiBmaWxlIG5hbWUgdGhhdA0Kd2lsbCBiZSBnaXZlbiB0byBhbnkg
b3RoZXIgdXNlcnMgbmVlZHMgc29tZSB0aG91Z2h0LiBJIHdhcyBwbGFubmluZyBvbg0Kc2ltcGx5
ICJzdGF0dXMiIHNpbmNlIHRoZSBpbmZvcm1hdGlvbiB0aGF0IEkgd2FudCB0byBjb252ZXkgaXMg
cmVhZC1vbmx5DQpzdGF0dXMgYWJvdXQgZWFjaCBvZiB0aGUgdGVsZW1ldHJ5IGNvbGxlY3Rpb24g
YWdncmVnYXRvcnMuIEJ1dCB0aGF0IGZlZWxzDQpsaWtlIGl0IG1pZ2h0IGJlIGxpbWl0aW5nIGlm
IGEgZnV0dXJlIHVzZSBpbmNsdWRlcyBhbnkgY29udHJvbCBvcHRpb25zIGJ5DQpwcm92aWRpbmcg
YSB3cml0YWJsZSBmaWxlLg0KDQotVG9ueQ0KDQo=
