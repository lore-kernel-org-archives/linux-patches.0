Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E852ED84D
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176558; cv=fail; b=dmZKSP3q8vhOOFCMla/PYIX8e5PJunmnuwAkMcPZ8onPundMtL+a7zv97lfZWlyDKU798e6CqsCRQ9RKk8PcVh/TqL7Q715+75ITDzIqwYOhpGKmm7SsLoa92NqQ9A6O5Vl6vB8PRVgugquP6Ti8iDu1XhB8o/08C9yELO7nf/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176558; c=relaxed/simple;
	bh=jl4CXyGTgN2sWwAZiwSdPiNP9z4q3N6DuUwXJNvPzrs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KFU6DiMwK6oP6WHNBHcgLX7MeGQjJUI4vT56bygme5WOSe2y8w+vwyEDGG3pE1SCoiOby72vxd17T0kg84LOqy6uOm0O6jAv8Kw1K/PGFqz2NNTYyKSFARs9WWmgICNvdNYVJ38sGXFNUkTaAHu+YTwRgcYbv24DC0zbfg3ohQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ffptAbPM; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ffptAbPM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4uWzTDJSWBGnpLOGrNHDmgzR7AE+g5VJWvV602Cqw7ewdl4ZOdt+c42foYUAj27El8+bGx6SdkxA9pd93vh5bgbO3BY7t6Y/pWZiiuGlCdjml4JaYH/xHKeddmDoyNexLf8goLFJ2KV9ApBS3SM7FCX2YfgOYAOXIBR5phq9F6NKANnLtec3/0MkdkLLUHlr/rt/K840egBZPPb2YnKwdt84Y/k4XErKmwF3kTCm8AEfRuyfrlyL5Cl79d0+b8RkPVMy3y9NXPC4QPFOARWFopBBLMBKsNM9rbxWx+CRSM4EKRvEgwPUSFSiqB4uB0vKlUOgF/7aaiIzFpMiepGOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jl4CXyGTgN2sWwAZiwSdPiNP9z4q3N6DuUwXJNvPzrs=;
 b=PITVD/QYa3c63G42hx2sIpxKXbO+tDHZx0E/eFxGWIY5faEloyiXsZH7IEAwgqq6q1ZtjgwLG9Q1KrbBBb/jLzbWmum67pIla1Y0AUFnboEcfLWC6a0eKRwRYql6qriZPfWx8tUWJyESry9fCAfBOT+5WOiwWMvQatyxyLMPQvdJDRVnIW+gv85HLLGDQkzeJPEuMM8Gj7uqjRr2cOcNuuwZFcXGYjx4Z2n4QaQhXnDOAdHdO8JxSRphMuGXq8P5SB5h7qNAlVhoUIfSIhrHIdbhk1M3bukiI831SORiV12BdT5d87gLDDGTh3MQ1Z9de1CpDsf4qx0hqXAZy8v0AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jl4CXyGTgN2sWwAZiwSdPiNP9z4q3N6DuUwXJNvPzrs=;
 b=ffptAbPMcMs1DxicoAwiK2lJQuN3L1PdmBQyGsfaNd5Z7mwRj0/mwc8o36dXTUrWz6goE8sKkjDCK6bQkZloH3jMIFKQ2y6duWtFMeID21e1PovRSkOanetCJQNNC1IruCc/zI6ewTyFgNTVMcT2QV3x2aSPvAn9J1cK/PA5TrA=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SJ2PR12MB7867.namprd12.prod.outlook.com (2603:10b6:a03:4cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Tue, 17 Jun
 2025 16:09:12 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.8835.026; Tue, 17 Jun 2025
 16:09:11 +0000
From: "Limonciello, Mario" <Mario.Limonciello@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Denis Benato
	<benato.denis96@gmail.com>, Yijun Shen <Yijun_Shen@Dell.com>, "Perry, David"
	<David.Perry@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 6.6 225/356] PCI: Explicitly put devices into D0 when
 initializing
Thread-Topic: [PATCH 6.6 225/356] PCI: Explicitly put devices into D0 when
 initializing
Thread-Index: AQHb36DqUlfu4tHzMUyTO010wCK/YLQHhRCA
Date: Tue, 17 Jun 2025 16:09:11 +0000
Message-ID: <2487309e-82a2-47fb-97cb-6401d5f6d186@amd.com>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152347.259467530@linuxfoundation.org>
In-Reply-To: <20250617152347.259467530@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|SJ2PR12MB7867:EE_
x-ms-office365-filtering-correlation-id: d4316641-d34a-4cb4-9465-08ddadb94c5e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bjRZdHdxZDgxTkVkaTZIUGcxS2FBa3p4NEtQYjNUTUsxRVdWWG53azdodHFl?=
 =?utf-8?B?dzNCZmN5dHlERXNkL2NoaGJyWGozUExmaDg4eDloTVV0M3l4V0RhWDVCV3Z3?=
 =?utf-8?B?aUVObEJNb1VSTkMvYzNmS0pkR2lLMExVYXJsb3ZCaTl3MnlVQzF6NGxXRnVj?=
 =?utf-8?B?eDBMS1hNcnpjdjl0WlhIN2JpQThIcjcwN2tKVVM4VGRuU01tU3N4S0V0eVpB?=
 =?utf-8?B?Y0xlN3hkaGtGV0d6U0g3VHp3MzgrWk9HandZdmdTVUZVTUxUZ09xbzY3V01T?=
 =?utf-8?B?a3puRUZhMUo5QWZXZVF6THB1ODMzVGNuU09ET0NvbG1IYXJuaW4xWTVQZjhK?=
 =?utf-8?B?TVpWK204Nm5uUnhaSjE2bzZqWTZwSDRYeXppSVlwa0dPckVJQ0RrS1lqTUtD?=
 =?utf-8?B?YjlvTU13aHZmZHpEUm1FV3B2N2xYaTY5YWV1UkhHSTlWYk91d241a3EvOThr?=
 =?utf-8?B?SGFQN2h4bEZ3WTVFMnd4d3hERG1GRlZHNTNDZlJrb3htOTlTakhueWl0bmZj?=
 =?utf-8?B?ZUxkc2dLSFhFVFFHelQzeWVkb0xmeWVRSFczVURIcmFRRmJ0Qy9TNlV5OTBP?=
 =?utf-8?B?MlpxaEc2M0N6MWJicFRPbUhBOUZwdG1NZHVxbmhnd3pvenJzYzI3dUFhcHlt?=
 =?utf-8?B?YWt4QThpOE9BZlRZUFRlRUVkZkhkSHF3ZUM4bWlwTldsdHUyN1N4dklYNm13?=
 =?utf-8?B?dmkxTEthTFk3OVVrNjd2THhQNUlpaXROSmdJMzU2bjBISFJNSVpQVVFXLzZY?=
 =?utf-8?B?em9jV1h6cXlQRm9DUzFiRllVWDA3b21YN2R3MDBxWVl5T2tPcG9SYUZrUWZI?=
 =?utf-8?B?cWNZVGFTNnRrdTlZOFdMbnZEYkh0QVhEcERjbzlvb1IyY3RTbHZudkVyZFY1?=
 =?utf-8?B?NjBVT1F5K0hrUDdoc01lTDJ3eHcvYlJuNmxQbnVVOVdNM3ZiMUJ6RnR6UXFC?=
 =?utf-8?B?TjMvY2RGbkRtaGNrTjZMZEpieU5VaVpxOXhIQzJyajNDZGYzTUNLMGJwdnRF?=
 =?utf-8?B?b0NQWnBLNUpPRHRKQW1iN0FUL1FrL2tieW1EVWJtaDRGTTlYSExtRU8yYThi?=
 =?utf-8?B?K1NCM3lSYlZsMElmcXNMVmZqNEdXdk4vZ3hQZC9rK08wZUVWYXVHdjQwV3FM?=
 =?utf-8?B?ajZUamN4R09FVlNEYWFRQ1BjcmFSKzcyQUwzR1BUK1pSajRuWWJqcjhMWTly?=
 =?utf-8?B?aXN3aXIvZkptRDRSdkJUbHBLU3J4Q1plOXNYazVPRFNtcmM5UDFRRXREM1gr?=
 =?utf-8?B?ZzRoeXlab0tjUm95bXNJTk80VFpaVDRkaXA0azlWajRFc0o1ODVXYXgvWita?=
 =?utf-8?B?clMvVDBPVXFsOTRtRGZxMjdOcXRvaUtJbmNENGphdWhjLzRJbDZYZmMzbzZ1?=
 =?utf-8?B?b0MzN0xlSnA1RFNFWG1Ib0ZsZ0x3eVE5b2Yzb0pFSURoMkNiWDM1czF2U0NR?=
 =?utf-8?B?cHBCV1F4ZzJlYi9KZ2JKdEpOVzZPYVc1dEd2S09WaEtodHpwcVlnMC93SFBp?=
 =?utf-8?B?WDJZYXFuSDM2Z2xuZEs1cC9wdmIvSkdFNzNicWIzV205REt0TUp5a3ZmVjFm?=
 =?utf-8?B?MGJjOHRWdjdUOFVvTEZhTHcvb2ZwdXNySVpwYTczdXN1TjJGeGRjRy9wVDRB?=
 =?utf-8?B?WitwR0FCVHRqelJvekJvMWYyd2FSYmdZeVpqOWsxMnIzdDI2N1hMYUVkdE43?=
 =?utf-8?B?K2ptMG5mNXlXMGlheXk0VFA3WnZQclg4MGZWWENjQURlak1TQkE4VEp5bmp5?=
 =?utf-8?B?bW82dFpDRHRpcTBkY0FJOUlEQzBxSHVFeHpWQXJlQWlka056aWNsdzRpc1Aw?=
 =?utf-8?B?c2VRWFRWbUoxRG1KclNIZVZNUW54a2JReGJrRHk2bzcyYnBScHBha0tPTXpM?=
 =?utf-8?B?ODd0Q2Rwam1SYzlxd0t6dHB2NkY0KzJPV3lPMnFxMThMcFJGVkE3UCtpRjJm?=
 =?utf-8?Q?I4ZFR0XL90i9n18hBjYt/s/4SZgFKa9X?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ODYxVHdpb0l2TDN1TFJLY0pHMmU1L3dvbEZYaDl0d2c0UGhjdDg2cUJvNTF5?=
 =?utf-8?B?VmQvd2tVWlY2eSsvT0w4TkN4dDFaQVVSeEh1WTZFVm52WUpyWlVCemlHZHdK?=
 =?utf-8?B?UkpvSmgvMkd5aEk2bkd4eGYwK1d2SjFRSllOQ2w4WEpCb2oydld1dDFraGRN?=
 =?utf-8?B?V0ozbmZCT1YzWnJBOTY5OXpIOUwwMWpFSnBXV3VJZUZpU0NJYnpZWDU5QmZV?=
 =?utf-8?B?YVh4ZE5lNVNZV0czaHViSCsybGprT0FNTHNtNnh3ZUZKV2YwZ24zS3pHV2E0?=
 =?utf-8?B?d1IzTDBKYUxQZ01GNnZlbUR4MDRsRDBoNmRvNVVFcisvaVMzL1FUUzVKcWlY?=
 =?utf-8?B?eTFvQUtNU1I4NGx3Umt1cHhxclE3ZXBrcUJ5VVFGTlpkUXZOSXo2RXU5T1lq?=
 =?utf-8?B?M2hqTFdsUHhCQ3hJNU9BdFlSK3pPMzk0SG1iMjN5Z005Z3BZMDJUVXpQdWc4?=
 =?utf-8?B?enk1QnNzN2hyUW5xcE44NldpTEZ5NHdGN0ZLRkVzZDlKSytsZlhUM2JTOCtL?=
 =?utf-8?B?WFcxbm9NbEgwM1BXT0E0MG5yQmViaWZjeG81eDJPKzIwRFVkQXVVVW9EQ0Fv?=
 =?utf-8?B?VEJIV0czbWhNVEFKS3V6dSs1RkZSRlkyL3NJTjZrK2gzV245QVFDS3JOeHE1?=
 =?utf-8?B?N1ZxeHcveFAzWkUwV0NMbUxyMXBDMmpMMmcxM09tckJTbW5KVGZET24zVTkv?=
 =?utf-8?B?L1pWUytjMmlFZGdtSXc3UXFXWWJtbTRtOWh5TmszaVZmcWZFVjdCUTQ1ZHlU?=
 =?utf-8?B?c0w0VjFLck5ERG5tSnd2eDM1T21QekU5ZHB3R3BvajUzNWJGcEwyU1ZSQWFQ?=
 =?utf-8?B?YnpCbFhlVWNsUlR3dFh2eXhMeEU4Y2szWDNPQjdZY3RqR0lqQ3FvWWJ3UGFJ?=
 =?utf-8?B?R3hvVm5rUE1JUDlkM0E1ZVI1dTVoOTFjYjZYdWJiUjArV2hoeEZTSmFLU3lp?=
 =?utf-8?B?K2paSnZoRDUzZTBlT0Y5OUxnUzFQQWZ5a0w4OS9iZmlEMDE1SklsUEdFVS9D?=
 =?utf-8?B?eWpLcXpoQWs1Sm1JWnIrMUpEcGQ1NmVEa1lVYkt3WFM1MnZMeElZTWVsV09T?=
 =?utf-8?B?cmNjWVlkdG1wV1hxNDBDL29WTnk0WWVJVmFpclhDSTBZMEU3TDFZanVqMzRB?=
 =?utf-8?B?VG5VNkVWd1RseVd2enhJeU1LdW14UVRiTU5jVC9YeVppdmF1K01JV2FqYkFR?=
 =?utf-8?B?WUk5QUxhY1FnTHhwanlyNzRPTFlPRDZVMnpjb2lySnNnYVQ0UDBmSGVuaFZC?=
 =?utf-8?B?b2kraDBmM0VENXBrVE9xVlY2cHpGN2IwWTg3ckJYNmNSVUlleTlySVNTSDNL?=
 =?utf-8?B?akJ4QjdzNkdqYllwdGtnTGRubURDMkNvQWxXa2ZhTmlKNVI0Y0pDeFV4dkQr?=
 =?utf-8?B?UThrc1JXTGhuK3hhNkwySHVjK3hWQ05XUG9JbG5TOHViY0FoU1hmcmFYV0VH?=
 =?utf-8?B?d1ltOXFUc2I0cWRWSW5yN016T2hBSDJzSVJEY1l5UU0zWHlLdWVOZ3ltMzJM?=
 =?utf-8?B?eWJiTkJ2QjJoaDhYTXd6UGhPZzZYMC9CbFM5Rk5oLzZQNHU2VElQcklueTJ4?=
 =?utf-8?B?MHBvN2I2ZzBQU1VFRWdEVHN4eVB4aUI0RDYvQXRJVmg1UTZWYmsrNE1BMnMv?=
 =?utf-8?B?cFczR2xhQjBIUGZ6TC9JRUdSd2pCc2N3eXdPbEZudDhNQlc4MzFaeWxlaVVY?=
 =?utf-8?B?ZnhTeHZQZXNYMTU4eU8yY3VNbHVEMGZGNlpNc0NHZCtsRmdGWWZLbjZpdnp2?=
 =?utf-8?B?VDBtNFBkV085ZkI2ckJRRVhGN0padGNzNVhFOUNUREk3UFhkbHE0SkZmUVZs?=
 =?utf-8?B?M09NdzlrVEl4SVZxbnhjK3dhcHRwUVAxU1ZZOGZHV2xkaExrY3BSVWRxcWw0?=
 =?utf-8?B?TmQ4aUF4c3Eyd1piS1dqNUp6Y1RWMWE5T1hjYkVpTmxkWEF1ODJCbTBqbTk2?=
 =?utf-8?B?VE01eTExeE02R0NBM050ZUtiOC95Q244RTlySkFQYzMrNHk0SnU1czRleGta?=
 =?utf-8?B?cklXc2NGMG5mWFJrN0xLQWpHS0F3WkpsQW5wV2I3NVhEWVh5YW1zK01mb1Y4?=
 =?utf-8?B?REVhVVR5NjdnZk9qeEpwWjdJcHBQUy9LWmVSd3FJSEU2TkdHVU41dzRhUzJq?=
 =?utf-8?Q?Pngs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <771B14860D0FAD42ABA98F98564540A4@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4316641-d34a-4cb4-9465-08ddadb94c5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2025 16:09:11.7741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nIcVXtSKRovr9nfhUUCYz7Vlfi5czDTVAY3FWRNnMuN7jQTVe+xDy6tzmuXH5UxllDh5ggXbBaTP+EMVV/zCLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7867

T24gNi8xNy8yNSAxMDoyNSBBTSwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA2LjYtc3Rh
YmxlIHJldmlldyBwYXRjaC4gIElmIGFueW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBsZWFzZSBs
ZXQgbWUga25vdy4NCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gRnJvbTogTWFyaW8g
TGltb25jaWVsbG8gPG1hcmlvLmxpbW9uY2llbGxvQGFtZC5jb20+DQo+IA0KPiBbIFVwc3RyZWFt
IGNvbW1pdCA0ZDRjMTBmNzYzZDc4MDhmYmFkZTI4ZDgzZDIzNzQxMTYwM2JjYTA1IF0NCj4gDQo+
IEFNRCBCSU9TIHRlYW0gaGFzIHJvb3QgY2F1c2VkIGFuIGlzc3VlIHRoYXQgTlZNZSBzdG9yYWdl
IGZhaWxlZCB0byBjb21lDQo+IGJhY2sgZnJvbSBzdXNwZW5kIHRvIGEgbGFjayBvZiBhIGNhbGwg
dG8gX1JFRyB3aGVuIE5WTWUgZGV2aWNlIHdhcyBwcm9iZWQuDQo+IA0KPiAxMTJhN2Y5YzhlZGJm
ICgiUENJL0FDUEk6IENhbGwgX1JFRyB3aGVuIHRyYW5zaXRpb25pbmcgRC1zdGF0ZXMiKSBhZGRl
ZA0KPiBzdXBwb3J0IGZvciBjYWxsaW5nIF9SRUcgd2hlbiB0cmFuc2l0aW9uaW5nIEQtc3RhdGVz
LCBidXQgdGhpcyBvbmx5IHdvcmtzDQo+IGlmIHRoZSBkZXZpY2UgYWN0dWFsbHkgInRyYW5zaXRp
b25zIiBELXN0YXRlcy4NCj4gDQo+IDk2NzU3N2IwNjI0MTcgKCJQQ0kvUE06IEtlZXAgcnVudGlt
ZSBQTSBlbmFibGVkIGZvciB1bmJvdW5kIFBDSSBkZXZpY2VzIikNCj4gYWRkZWQgc3VwcG9ydCBm
b3IgcnVudGltZSBQTSBvbiBQQ0kgZGV2aWNlcywgYnV0IG5ldmVyIGFjdHVhbGx5DQo+ICdleHBs
aWNpdGx5JyBzZXRzIHRoZSBkZXZpY2UgdG8gRDAuDQo+IA0KPiBUbyBtYWtlIHN1cmUgdGhhdCBk
ZXZpY2VzIGFyZSBpbiBEMCBhbmQgdGhhdCBwbGF0Zm9ybSBtZXRob2RzIHN1Y2ggYXMNCj4gX1JF
RyBhcmUgY2FsbGVkLCBleHBsaWNpdGx5IHNldCBhbGwgZGV2aWNlcyBpbnRvIEQwIGR1cmluZyBp
bml0aWFsaXphdGlvbi4NCj4gDQo+IEZpeGVzOiA5Njc1NzdiMDYyNDE3ICgiUENJL1BNOiBLZWVw
IHJ1bnRpbWUgUE0gZW5hYmxlZCBmb3IgdW5ib3VuZCBQQ0kgZGV2aWNlcyIpDQo+IFNpZ25lZC1v
ZmYtYnk6IE1hcmlvIExpbW9uY2llbGxvIDxtYXJpby5saW1vbmNpZWxsb0BhbWQuY29tPg0KPiBT
aWduZWQtb2ZmLWJ5OiBCam9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPg0KPiBUZXN0
ZWQtYnk6IERlbmlzIEJlbmF0byA8YmVuYXRvLmRlbmlzOTZAZ21haWwuY29tPg0KPiBUZXN0ZWQt
Qnk6IFlpanVuIFNoZW4gPFlpanVuX1NoZW5ARGVsbC5jb20+DQo+IFRlc3RlZC1CeTogRGF2aWQg
UGVycnkgPGRhdmlkLnBlcnJ5QGFtZC5jb20+DQo+IFJldmlld2VkLWJ5OiBSYWZhZWwgSi4gV3lz
b2NraSA8cmFmYWVsQGtlcm5lbC5vcmc+DQo+IExpbms6IGh0dHBzOi8vcGF0Y2gubXNnaWQubGlu
ay8yMDI1MDQyNDA0MzIzMi4xODQ4MTA3LTEtc3VwZXJtMUBrZXJuZWwub3JnDQo+IFNpZ25lZC1v
ZmYtYnk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCj4gLS0tDQoNCkkgZG8gdGhp
bmsgdGhpcyBzaG91bGQgY29tZSBiYWNrIHRvIHN0YWJsZSwgYnV0IEkgdGhpbmsgd2UgbmVlZCB0
byB3YWl0IA0KYSBzdGFibGUgY3ljbGUgdG8gcGljayBpdCB1cCBzbyB0aGF0IGl0IGNhbiBjb21l
IHdpdGggdGhpcyBmaXggdG9vLg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1wY2kv
MjAyNTA2MTEyMzMxMTcuNjE4MTAtMS1zdXBlcm0xQGtlcm5lbC5vcmcvDQoNCj4gICBkcml2ZXJz
L3BjaS9wY2ktZHJpdmVyLmMgfCAgNiAtLS0tLS0NCj4gICBkcml2ZXJzL3BjaS9wY2kuYyAgICAg
ICAgfCAxMyArKysrKysrKysrLS0tDQo+ICAgZHJpdmVycy9wY2kvcGNpLmggICAgICAgIHwgIDEg
Kw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9wY2ktZHJpdmVyLmMgYi9kcml2ZXJzL3Bj
aS9wY2ktZHJpdmVyLmMNCj4gaW5kZXggOWM1OWJmMDNkNjU3OS4uMjU4YmE5N2QwNzI0MiAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kvcGNpLWRyaXZlci5jDQo+ICsrKyBiL2RyaXZlcnMvcGNp
L3BjaS1kcml2ZXIuYw0KPiBAQCAtNTY0LDEyICs1NjQsNiBAQCBzdGF0aWMgdm9pZCBwY2lfcG1f
ZGVmYXVsdF9yZXN1bWUoc3RydWN0IHBjaV9kZXYgKnBjaV9kZXYpDQo+ICAgCXBjaV9lbmFibGVf
d2FrZShwY2lfZGV2LCBQQ0lfRDAsIGZhbHNlKTsNCj4gICB9DQo+ICAgDQo+IC1zdGF0aWMgdm9p
ZCBwY2lfcG1fcG93ZXJfdXBfYW5kX3ZlcmlmeV9zdGF0ZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2Rl
dikNCj4gLXsNCj4gLQlwY2lfcG93ZXJfdXAocGNpX2Rldik7DQo+IC0JcGNpX3VwZGF0ZV9jdXJy
ZW50X3N0YXRlKHBjaV9kZXYsIFBDSV9EMCk7DQo+IC19DQo+IC0NCj4gICBzdGF0aWMgdm9pZCBw
Y2lfcG1fZGVmYXVsdF9yZXN1bWVfZWFybHkoc3RydWN0IHBjaV9kZXYgKnBjaV9kZXYpDQo+ICAg
ew0KPiAgIAlwY2lfcG1fcG93ZXJfdXBfYW5kX3ZlcmlmeV9zdGF0ZShwY2lfZGV2KTsNCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIvZHJpdmVycy9wY2kvcGNpLmMNCj4gaW5kZXgg
NTAzMzA0YWJhOWVhYy4uODljNmIxNjFmODBjOSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kv
cGNpLmMNCj4gKysrIGIvZHJpdmVycy9wY2kvcGNpLmMNCj4gQEAgLTMyMjcsNiArMzIyNywxMiBA
QCB2b2lkIHBjaV9kM2NvbGRfZGlzYWJsZShzdHJ1Y3QgcGNpX2RldiAqZGV2KQ0KPiAgIH0NCj4g
ICBFWFBPUlRfU1lNQk9MX0dQTChwY2lfZDNjb2xkX2Rpc2FibGUpOw0KPiAgIA0KPiArdm9pZCBw
Y2lfcG1fcG93ZXJfdXBfYW5kX3ZlcmlmeV9zdGF0ZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2RldikN
Cj4gK3sNCj4gKwlwY2lfcG93ZXJfdXAocGNpX2Rldik7DQo+ICsJcGNpX3VwZGF0ZV9jdXJyZW50
X3N0YXRlKHBjaV9kZXYsIFBDSV9EMCk7DQo+ICt9DQo+ICsNCj4gICAvKioNCj4gICAgKiBwY2lf
cG1faW5pdCAtIEluaXRpYWxpemUgUE0gZnVuY3Rpb25zIG9mIGdpdmVuIFBDSSBkZXZpY2UNCj4g
ICAgKiBAZGV2OiBQQ0kgZGV2aWNlIHRvIGhhbmRsZS4NCj4gQEAgLTMyMzcsOSArMzI0Myw2IEBA
IHZvaWQgcGNpX3BtX2luaXQoc3RydWN0IHBjaV9kZXYgKmRldikNCj4gICAJdTE2IHN0YXR1czsN
Cj4gICAJdTE2IHBtYzsNCj4gICANCj4gLQlwbV9ydW50aW1lX2ZvcmJpZCgmZGV2LT5kZXYpOw0K
PiAtCXBtX3J1bnRpbWVfc2V0X2FjdGl2ZSgmZGV2LT5kZXYpOw0KPiAtCXBtX3J1bnRpbWVfZW5h
YmxlKCZkZXYtPmRldik7DQo+ICAgCWRldmljZV9lbmFibGVfYXN5bmNfc3VzcGVuZCgmZGV2LT5k
ZXYpOw0KPiAgIAlkZXYtPndha2V1cF9wcmVwYXJlZCA9IGZhbHNlOw0KPiAgIA0KPiBAQCAtMzMw
MSw2ICszMzA0LDEwIEBAIHZvaWQgcGNpX3BtX2luaXQoc3RydWN0IHBjaV9kZXYgKmRldikNCj4g
ICAJcGNpX3JlYWRfY29uZmlnX3dvcmQoZGV2LCBQQ0lfU1RBVFVTLCAmc3RhdHVzKTsNCj4gICAJ
aWYgKHN0YXR1cyAmIFBDSV9TVEFUVVNfSU1NX1JFQURZKQ0KPiAgIAkJZGV2LT5pbW1fcmVhZHkg
PSAxOw0KPiArCXBjaV9wbV9wb3dlcl91cF9hbmRfdmVyaWZ5X3N0YXRlKGRldik7DQo+ICsJcG1f
cnVudGltZV9mb3JiaWQoJmRldi0+ZGV2KTsNCj4gKwlwbV9ydW50aW1lX3NldF9hY3RpdmUoJmRl
di0+ZGV2KTsNCj4gKwlwbV9ydW50aW1lX2VuYWJsZSgmZGV2LT5kZXYpOw0KPiAgIH0NCj4gICAN
Cj4gICBzdGF0aWMgdW5zaWduZWQgbG9uZyBwY2lfZWFfZmxhZ3Moc3RydWN0IHBjaV9kZXYgKmRl
diwgdTggcHJvcCkNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5oIGIvZHJpdmVycy9w
Y2kvcGNpLmgNCj4gaW5kZXggZDY5YTE3OTQ3ZmZjZS4uYTYyMWJhMjQzYzI1ZSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9wY2kvcGNpLmgNCj4gKysrIGIvZHJpdmVycy9wY2kvcGNpLmgNCj4gQEAg
LTkyLDYgKzkyLDcgQEAgdm9pZCBwY2lfZGV2X2FkanVzdF9wbWUoc3RydWN0IHBjaV9kZXYgKmRl
dik7DQo+ICAgdm9pZCBwY2lfZGV2X2NvbXBsZXRlX3Jlc3VtZShzdHJ1Y3QgcGNpX2RldiAqcGNp
X2Rldik7DQo+ICAgdm9pZCBwY2lfY29uZmlnX3BtX3J1bnRpbWVfZ2V0KHN0cnVjdCBwY2lfZGV2
ICpkZXYpOw0KPiAgIHZvaWQgcGNpX2NvbmZpZ19wbV9ydW50aW1lX3B1dChzdHJ1Y3QgcGNpX2Rl
diAqZGV2KTsNCj4gK3ZvaWQgcGNpX3BtX3Bvd2VyX3VwX2FuZF92ZXJpZnlfc3RhdGUoc3RydWN0
IHBjaV9kZXYgKnBjaV9kZXYpOw0KPiAgIHZvaWQgcGNpX3BtX2luaXQoc3RydWN0IHBjaV9kZXYg
KmRldik7DQo+ICAgdm9pZCBwY2lfZWFfaW5pdChzdHJ1Y3QgcGNpX2RldiAqZGV2KTsNCj4gICB2
b2lkIHBjaV9tc2lfaW5pdChzdHJ1Y3QgcGNpX2RldiAqZGV2KTsNCg0K
