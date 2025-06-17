Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED2520C001
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179207; cv=fail; b=Z2WdjF4N/sR2kPoNYumEjqGNgBciNA3xWkQ7BYFTYioMLKLAEvNvUhxDPNvkOkW+QB/wRxffTBoPGByTviOOkGVmqXla2fBJar7nqZuWNYYHxUWOj4bGH75dyCHwxuRkWJuwcvSs4cNfJzPDu5SGOYcUHqo8Nw7BSBOmPIkGxVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179207; c=relaxed/simple;
	bh=IRdAHN3sfv0G3YnIX5jcA+v3qiL5mdsWKwJwnrHupxI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZYNkrr2Pzi6qmhRHVmFvN0UkkqoWm0kyWKeRHUQRYElrF0x3I4DQGifeJT2IuyIpGvl88HmbbWmMNdjQXzDsT/XBtdscwL5gLbhLJTEhdOe5GO66/3SFZdRlFafC6qK0VM9zzhUs0PsLoVHypgMT7x4qfKVngXbkTL3yjoXQ0Hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jqGmbOXO; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jqGmbOXO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gLTurKP8U9nNU9y9dbkFClgVK7zZ/hJ2xsyww5SOOcEn0PkwEq65a+5TYrNQi6JsWg63MYjiRQJmGoW7CSfRLTYE6hfruhmGkIA3A+wKTRHla9OTo1jLWt0RxZqefamkhMApN/3FwHDWUYeIt8q3kO7HmJcOBctyvLIIF/wGWL5s9+Pi3qvJpORf2ltKO52RMFTpXLezs4WzXSc1T9CRLKPersTOAwwKdHHqFBEkwxaAxruihGX8VYHlNzNc3ip/yAzUCGT2Upp6BFH7i9XCRABtZonFB95tJ8XzuFLaT2mFKFZo6DT4EqBq2wBBRtokS5bKnYEezjU1acB4aqwNCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRdAHN3sfv0G3YnIX5jcA+v3qiL5mdsWKwJwnrHupxI=;
 b=GPcV6R9CX+xA/Tci+wgf9qNQv/8/+UxIhVNvXj2RnNsucFXETMeizsb/kB4FkoKXFQQ8LbYcjjjK6+r7O4100auakslXTpx/qTn9GyPDW9SuNcJ5Gq3Q7OjRVeueeVTtSO4+vQ3OMurzS68Ccz+u6ReyXM2KdesNwiXdDNv3fhSSgz+yR3VOc18gFQCp363XQTq+BNq5LTcM65NjvJqWdrv8AcRBmn2L8ssSx6pWvOys33L2XG3lfNVJzxSRt5la+FWF/0aRi6+JXoDPxjcMXQ2Zv0JogwbxHuSG18gXk1NxSJtgEa9HmBTIFLpkXE98treHE50bCiacqbGqmX7Atg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRdAHN3sfv0G3YnIX5jcA+v3qiL5mdsWKwJwnrHupxI=;
 b=jqGmbOXOM4X3oLZJ958LtFKOzFIrTLhcnseHNGKbFtMn2q1CVkVh/xayypXvNNvpfoIVLcvhocHgxUQvduFG3tddC3YxgckVb+go/8IY8NNTmaz1U4Ta4H24eb3Pvt6qS8oDErXWmF5Y2M0xN7OzT1cence192d1T6nM1vAJgCE=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH3PR12MB8402.namprd12.prod.outlook.com (2603:10b6:610:132::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Tue, 17 Jun
 2025 16:53:23 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.8835.026; Tue, 17 Jun 2025
 16:53:23 +0000
From: "Limonciello, Mario" <Mario.Limonciello@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Bjorn Helgaas
	<bhelgaas@google.com>, Denis Benato <benato.denis96@gmail.com>, Yijun Shen
	<Yijun_Shen@Dell.com>, "Perry, David" <David.Perry@amd.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 313/512] PCI: Explicitly put devices into D0 when
 initializing
Thread-Topic: [PATCH 6.12 313/512] PCI: Explicitly put devices into D0 when
 initializing
Thread-Index: AQHb36PLVY/WXN/sjkObdMQRypRHqLQHkWSA
Date: Tue, 17 Jun 2025 16:53:23 +0000
Message-ID: <d031e9aa-583c-4152-9330-06dc02858e82@amd.com>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152432.297176178@linuxfoundation.org>
In-Reply-To: <20250617152432.297176178@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|CH3PR12MB8402:EE_
x-ms-office365-filtering-correlation-id: 2eca7eba-e2c5-4143-6a71-08ddadbf78f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QWNQT2pTMVUzaU9UbG5za3E0eEdDeW0yVFE4aWxvUi93M2VQS3g5K3FST2hJ?=
 =?utf-8?B?ZFk1UXpiTU5NMkJoR2k1TXJxTThaZkRVQ2o3d2RvU284NkFzeUdoWmtjaHRK?=
 =?utf-8?B?V0dRZFZoUGlFaW1LOFQvaWh0YnVUa1BlWDJtNEh2Tnh1aEQzWm1mbENTeDVK?=
 =?utf-8?B?NElNN3JYSlFUMU54akQvZ1F5OTZDdmFrR0o5T2llTDhUVXdvZzBPUlJ5WGpo?=
 =?utf-8?B?SzI3SU1JK2ZQdzE0MVc3aFNrODhtWkpQOVV3VVoya0NmUk9zcW9QbzBpNDBO?=
 =?utf-8?B?NlVnT3VWZTdHTk1rNlVxTEFpbi8yeEtLQ0ZyVy9GZHFEak5BSld5K3dud25w?=
 =?utf-8?B?Q0ZtSU9XNjhINVZMMHJjNm9mOTFxN09Xd1h6QmZrVjAzaXhUbHhsVWdXdnBS?=
 =?utf-8?B?eHk0ZEZIMjVtd0V6YnZhOTJ4WHI2aFMzTldlZkRMZ2lvQm55SFVVaGMzUHVW?=
 =?utf-8?B?WHZqOWZmTjV4M2w5bjlqQVdHNUM0dUNtTm00SUd6VmI1ak9LRGNlNmFtZW5R?=
 =?utf-8?B?VXVESk1EdnBHMXpsRDB4UUFKY3lCekxOOGhHc0wyVzNUTWFTbGZrU1BTbC9E?=
 =?utf-8?B?SGpLQndBMHZrZjdiY3pwbW5xNElORVJFODVScWhMdTQweGJwc2lpVWNsMzNu?=
 =?utf-8?B?NUprMmlxQmR0aHpRQUJTWEpkRWlIM2txM0dQeDBPNGFESFh4ZkVsWDVvUmta?=
 =?utf-8?B?dFpsMjhoWmNoOXFwdTdIak1zRERyRTQvV0FUUzdpb29zT1V5NXBFcW5PTmxo?=
 =?utf-8?B?aks4ckpUM1IrVytCUG55aU1qUWdMaHVTY0NFNEp0K0JGYkhCTXVRUTUwRGha?=
 =?utf-8?B?MU9vN013UkhhbEVQdnBUbzNydkI2TzRxMm5iWm5VZlh6a2thQW44eFJtdnZC?=
 =?utf-8?B?RmtVd1JzQkJCRzZUS3Ira2poMEU1OXFGeVllZW5oaDB0VVRWVUh6L2ZRc25Z?=
 =?utf-8?B?ZmdlT1J5ZThRalRMRDNrZ3dSUi9TZmkzUmI1ZVVzQjAveUl6YXpRWWM1dGxI?=
 =?utf-8?B?bmhWZXVIeWVKeWtPSGVjcVVtQjNaaG53K3ZmaWdHRTVNbVhIbFloMkZxekk3?=
 =?utf-8?B?Y05KT05zaHlVRjB3TnJibkkrZ0JSV2NpRDdkMEwwS0hqRFVEc2grL09qUTI3?=
 =?utf-8?B?bW9rUjVydldDVm5FanJLWXV4S1E1WVJlTDZsaDl1dDhvUEVLREZybGx3Tm9G?=
 =?utf-8?B?S2c1a1oyWXBlZkt2LzhaNm1sUHBFcG5WalI0YVNVakJKWHEreW8xZjJYVG4v?=
 =?utf-8?B?ZDJpNkUrUStOalJkQ1BDYXQyd0lHc0RacVVpSXhxVUI4ajBxK1ByOUNHT29i?=
 =?utf-8?B?dUw3UnlHVHlVQmxyQTBzOVdrMm5lQytXWDJNTExYRllBdUlRQTQvZStDWC9p?=
 =?utf-8?B?bG9sbHBSNFNXNFFaTjRwSGgyaG45RnJHdEpNSjBYdDRFQmJmMGo2YkhoelNZ?=
 =?utf-8?B?N2dRaEdWNTdDUVcvTG5qMmQxT0UrUEdmVzMzNzMwcm56TmhxdklOb3g2a25r?=
 =?utf-8?B?aUhRNXcwUERhRFVTaGxpbFRyWGsyYTZCSTNiMjNnRUJtTVFnQXVnN21obkN4?=
 =?utf-8?B?Rkp0cW1XZ3VBdHRvOTYvOE5tdmFOZEQxOUwrVWxyZ000R1BmT3VSOTlDM09D?=
 =?utf-8?B?YStuOHgvZnJlNzNxN1RBUW43RDVWV3dVdnJVMXo3bEJ4ejQ4UjFLQlFPSzNL?=
 =?utf-8?B?Smx4UjdNWWlXcmtTTW1HdW9YaVhpZ3RiVkROOWNwWWYwbkUvRm42ZEdoalBR?=
 =?utf-8?B?Vit4b09VWnJTNjFTbVBJUlVZcXRwbDBRbkJxUmFKLzhvZEtqVUkwdzBLZThX?=
 =?utf-8?B?N2JnbWlSUjdRSk8zSmVWYnczdDRObHlKRDYyYWhnRTlWd0pwZzAxay9JVWY0?=
 =?utf-8?B?WldzTUtYVHhrenNVV3RPeWRwM0ZENExwTHpkRjlidkpjV2p6Z2tFSi9RTW41?=
 =?utf-8?Q?EqIclIClO8ujYq8T13baX8qrlcyNIxgE?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dU9OanlsQlNFUTdrczl3dk1wL1VuaFR0bFNaZFJycnFWSFh4OXM4YngyRGxC?=
 =?utf-8?B?azFTNkdUbEZvaWRqUW5xeUR2Q2hSdEZybTdBT0NRNXBpd2RKZmFLVUtxM3RM?=
 =?utf-8?B?UUl2ZjVjdTlDdnp0MldhUWE4NG41b21BTVN0elJjNmlaUnpFQmpmc0ZrcUUr?=
 =?utf-8?B?VzJpdHg4V0xLbzA0eGo2ZGtxTXEvVnlOQzVSNGJ2VEF6cThFbVR3alNHcE9E?=
 =?utf-8?B?NDRMR2c4M3ppUnJRZDRTelNIRTdTcTNBSG51YVpMcUdDRDRxakpaWGFQSk5h?=
 =?utf-8?B?MUVhNlRydjdDUUU3WEtORWxNU3NVd2hjdXkzUytIS0FIMmdGTnhjYmZ5SDZV?=
 =?utf-8?B?cWM4VnBqbUVhUlJyTVI5TFFocG9EUFNBUUlKWVE5dXpwemFLd09WZHp3UnJ2?=
 =?utf-8?B?b05sdEttQ1dXcG80TEROTzFDS2RNN3ExVDAvRVdKSzBPRnVLVG5oVEhvZFRq?=
 =?utf-8?B?VlpFQU92Sk0rVG93SWhIdFo2VmNJVk1OT2hEajVqK0lUMlZTK1pjVFRIc1lN?=
 =?utf-8?B?Mzl2S1FMak5vcjFvRzkvNHlVc1F1bVpTUHlBQnZYWkpUNXRaSi9LSTdnN2VV?=
 =?utf-8?B?U2tQNG9mc3lYZnZmWVNYdTBiRmhpSXJMTlVIMkZZd2wyR2JnYkNlRUZvcXVV?=
 =?utf-8?B?QUF5M0Q3dmF0ZXBxZVZwZkE4SUxwNHFlSGgzNU92VVpBY1d1Y0gra05VYi9v?=
 =?utf-8?B?UFY3Uy9HTFBzVy9ZVzBJcmVlRDB3RHlNVFlNaEZ5MU0xY2JXV2NmNkNiNGFw?=
 =?utf-8?B?dzlndkREVG1wMXhOL3BHN1VkeklGa0YyR3RvWEVXMXV6WUowazQ1d2VTdTFV?=
 =?utf-8?B?MHdTOHFpSklCRnBlbEw1aU4wOVVXbFpLZ0svbXNzQnlvbnJmU01JY1FqRFNa?=
 =?utf-8?B?eXIwcDczRE9mQzI1RjQvUmlockhCRCtMbGhXTEtlVDRmUkFBbEZsUVR6WFpv?=
 =?utf-8?B?VSszZUdQc3UzNm5TZnUreFJqaTgzb1R2L3ZGWTIzVWtDS0VkRWtoWFVIM3p4?=
 =?utf-8?B?RHg4S1Q3Nnk4MVZyVGUwNUxSYXV1M3lQREh4ekhGdjNYekQwdkU5T1UvQVZm?=
 =?utf-8?B?UndHMitqM3VBRlBRb1VtZERWcG5nTU5rL3BMNys3a3NlZkY5TEdUNXBtQmUw?=
 =?utf-8?B?VjFndTJZMGxML0F0a2tGNW5qNGtxQmRHaW5WK0Vlb2ZoRnBFY2lrcTZ2bXBX?=
 =?utf-8?B?R0Vpb29ydzJ2YkM5VUtUUHllSFp4REVUbHZZc2pWK05sZnZBSFN0ZElOY3VC?=
 =?utf-8?B?YlRBeDBDOXRoaEgxcDJHL0h5NzdlaEQ0d2g5TEVRRGpocmUxS3cvTFNDYm94?=
 =?utf-8?B?Znp4ZHJEc3c1ZjE5dTJkaFNOSU1iSDY5T3MrOVB2VGN0L2Nvc3BOZ2VNZlBz?=
 =?utf-8?B?ZlBGWkI3N3hRU0JybmsxNXowazVqK2N3OXYybkFzd2sxZ0kyeVJMRExTeERh?=
 =?utf-8?B?SDJWL2ZkbTVBVVJ3WUZBTWoyQzRvbnFkeTgzS2UzemhJTjhMeXhPMDNyYUYr?=
 =?utf-8?B?aFBBNUtDVDM2NGsxN0k2TWcwVmp2TTNjbjRocHNTSklKU0FVOTA0MkQrRFJW?=
 =?utf-8?B?bEwreHZTc2lnY25YMDREOEExcEFBUTEzMUg3aVErQW5oZmZoTVpyV3JiaEVS?=
 =?utf-8?B?SnZuZ2VYN1RHL0R1NUE2NUpnSGEvTlAvOWd3YlAwaWRZKzl6WDVnQjNBWmRn?=
 =?utf-8?B?ZFliQXZBNDdYN1ZySGZ3d2E1R09YYi9DQ0FaZStsN3UrRWJBY0NVRVFJcHlT?=
 =?utf-8?B?Mmt5TWNRTWQ2YmFrVGp2bGw5TXgrL2dhNkFOUkRXcGtld3JuVEdZV1dWbm51?=
 =?utf-8?B?eFhUSDJaME5ISU1iWk82N1RTaXMwVGxHbnBiMzQ5ck9UdHl2K3lwekwwc2Mr?=
 =?utf-8?B?ZnJ6TEwyWnBiVjYrRFp3QVpxbjN2d25mak1uQ3liRUt6ZEJ2ZkJiOUh6MUlh?=
 =?utf-8?B?VlhZM1A4UFZFSkYxSk95UWNuM2xxRzF3cktWZlBQM3V1QVpLSTlNa3k3Nkt4?=
 =?utf-8?B?OThnbENsMUNORVZsekoxMVBOeEpZbm8vTENGTjNuUmhrb0dGQnZzRERGeG8w?=
 =?utf-8?B?Z3lBOGptTkdVUkJFNEIwOEZrNzlXejI5RTN3dCsxSWRUempRdHJYcFB5Qnpi?=
 =?utf-8?Q?W2pI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAECCE8DCD1690459A809A1656E3647F@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eca7eba-e2c5-4143-6a71-08ddadbf78f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2025 16:53:23.5959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l50u41wvLd04cutl5e7UYYfb4tHbLS7IE/xuHmsoIacVFVGVDkoBgSTEhSmlGE6akt5wD7nopHrvmPi+NYvAww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8402

T24gNi8xNy8yNSAxMDoyNCBBTSwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA2LjEyLXN0
YWJsZSByZXZpZXcgcGF0Y2guICBJZiBhbnlvbmUgaGFzIGFueSBvYmplY3Rpb25zLCBwbGVhc2Ug
bGV0IG1lIGtub3cuDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IEZyb206IE1hcmlv
IExpbW9uY2llbGxvIDxtYXJpby5saW1vbmNpZWxsb0BhbWQuY29tPg0KPiANCj4gWyBVcHN0cmVh
bSBjb21taXQgNGQ0YzEwZjc2M2Q3ODA4ZmJhZGUyOGQ4M2QyMzc0MTE2MDNiY2EwNSBdDQo+IA0K
PiBBTUQgQklPUyB0ZWFtIGhhcyByb290IGNhdXNlZCBhbiBpc3N1ZSB0aGF0IE5WTWUgc3RvcmFn
ZSBmYWlsZWQgdG8gY29tZQ0KPiBiYWNrIGZyb20gc3VzcGVuZCB0byBhIGxhY2sgb2YgYSBjYWxs
IHRvIF9SRUcgd2hlbiBOVk1lIGRldmljZSB3YXMgcHJvYmVkLg0KPiANCj4gMTEyYTdmOWM4ZWRi
ZiAoIlBDSS9BQ1BJOiBDYWxsIF9SRUcgd2hlbiB0cmFuc2l0aW9uaW5nIEQtc3RhdGVzIikgYWRk
ZWQNCj4gc3VwcG9ydCBmb3IgY2FsbGluZyBfUkVHIHdoZW4gdHJhbnNpdGlvbmluZyBELXN0YXRl
cywgYnV0IHRoaXMgb25seSB3b3Jrcw0KPiBpZiB0aGUgZGV2aWNlIGFjdHVhbGx5ICJ0cmFuc2l0
aW9ucyIgRC1zdGF0ZXMuDQo+IA0KPiA5Njc1NzdiMDYyNDE3ICgiUENJL1BNOiBLZWVwIHJ1bnRp
bWUgUE0gZW5hYmxlZCBmb3IgdW5ib3VuZCBQQ0kgZGV2aWNlcyIpDQo+IGFkZGVkIHN1cHBvcnQg
Zm9yIHJ1bnRpbWUgUE0gb24gUENJIGRldmljZXMsIGJ1dCBuZXZlciBhY3R1YWxseQ0KPiAnZXhw
bGljaXRseScgc2V0cyB0aGUgZGV2aWNlIHRvIEQwLg0KPiANCj4gVG8gbWFrZSBzdXJlIHRoYXQg
ZGV2aWNlcyBhcmUgaW4gRDAgYW5kIHRoYXQgcGxhdGZvcm0gbWV0aG9kcyBzdWNoIGFzDQo+IF9S
RUcgYXJlIGNhbGxlZCwgZXhwbGljaXRseSBzZXQgYWxsIGRldmljZXMgaW50byBEMCBkdXJpbmcg
aW5pdGlhbGl6YXRpb24uDQo+IA0KPiBGaXhlczogOTY3NTc3YjA2MjQxNyAoIlBDSS9QTTogS2Vl
cCBydW50aW1lIFBNIGVuYWJsZWQgZm9yIHVuYm91bmQgUENJIGRldmljZXMiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBNYXJpbyBMaW1vbmNpZWxsbyA8bWFyaW8ubGltb25jaWVsbG9AYW1kLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogQmpvcm4gSGVsZ2FhcyA8YmhlbGdhYXNAZ29vZ2xlLmNvbT4NCj4gVGVz
dGVkLWJ5OiBEZW5pcyBCZW5hdG8gPGJlbmF0by5kZW5pczk2QGdtYWlsLmNvbT4NCj4gVGVzdGVk
LUJ5OiBZaWp1biBTaGVuIDxZaWp1bl9TaGVuQERlbGwuY29tPg0KPiBUZXN0ZWQtQnk6IERhdmlk
IFBlcnJ5IDxkYXZpZC5wZXJyeUBhbWQuY29tPg0KPiBSZXZpZXdlZC1ieTogUmFmYWVsIEouIFd5
c29ja2kgPHJhZmFlbEBrZXJuZWwub3JnPg0KPiBMaW5rOiBodHRwczovL3BhdGNoLm1zZ2lkLmxp
bmsvMjAyNTA0MjQwNDMyMzIuMTg0ODEwNy0xLXN1cGVybTFAa2VybmVsLm9yZw0KPiBTaWduZWQt
b2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KDQpTYW1lIGNv
bW1lbnQgYXMgb24gNi42Og0KDQpJIGRvIHRoaW5rIHRoaXMgc2hvdWxkIGNvbWUgYmFjayB0byBz
dGFibGUsIGJ1dCBJIHRoaW5rIHdlIG5lZWQgdG8gd2FpdA0KYSBzdGFibGUgY3ljbGUgdG8gcGlj
ayBpdCB1cCBzbyB0aGF0IGl0IGNhbiBjb21lIHdpdGggdGhpcyBmaXggdG9vLg0KDQpodHRwczov
L2xvcmUua2VybmVsLm9yZy9saW51eC1wY2kvMjAyNTA2MTEyMzMxMTcuNjE4MTAtMS1zdXBlcm0x
QGtlcm5lbC5vcmcvDQoNCj4gICBkcml2ZXJzL3BjaS9wY2ktZHJpdmVyLmMgfCAgNiAtLS0tLS0N
Cj4gICBkcml2ZXJzL3BjaS9wY2kuYyAgICAgICAgfCAxMyArKysrKysrKysrLS0tDQo+ICAgZHJp
dmVycy9wY2kvcGNpLmggICAgICAgIHwgIDEgKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMTEgaW5z
ZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Bj
aS9wY2ktZHJpdmVyLmMgYi9kcml2ZXJzL3BjaS9wY2ktZHJpdmVyLmMNCj4gaW5kZXggMzUyNzAx
NzJjODMzMS4uYTkwOTkwMTU3ZTBiNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kvcGNpLWRy
aXZlci5jDQo+ICsrKyBiL2RyaXZlcnMvcGNpL3BjaS1kcml2ZXIuYw0KPiBAQCAtNTU1LDEyICs1
NTUsNiBAQCBzdGF0aWMgdm9pZCBwY2lfcG1fZGVmYXVsdF9yZXN1bWUoc3RydWN0IHBjaV9kZXYg
KnBjaV9kZXYpDQo+ICAgCXBjaV9lbmFibGVfd2FrZShwY2lfZGV2LCBQQ0lfRDAsIGZhbHNlKTsN
Cj4gICB9DQo+ICAgDQo+IC1zdGF0aWMgdm9pZCBwY2lfcG1fcG93ZXJfdXBfYW5kX3ZlcmlmeV9z
dGF0ZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2RldikNCj4gLXsNCj4gLQlwY2lfcG93ZXJfdXAocGNp
X2Rldik7DQo+IC0JcGNpX3VwZGF0ZV9jdXJyZW50X3N0YXRlKHBjaV9kZXYsIFBDSV9EMCk7DQo+
IC19DQo+IC0NCj4gICBzdGF0aWMgdm9pZCBwY2lfcG1fZGVmYXVsdF9yZXN1bWVfZWFybHkoc3Ry
dWN0IHBjaV9kZXYgKnBjaV9kZXYpDQo+ICAgew0KPiAgIAlwY2lfcG1fcG93ZXJfdXBfYW5kX3Zl
cmlmeV9zdGF0ZShwY2lfZGV2KTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIv
ZHJpdmVycy9wY2kvcGNpLmMNCj4gaW5kZXggN2NhNTQyMmZlYjJkNC4uMWE2NjM5ZGJlODFiMyAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kvcGNpLmMNCj4gKysrIGIvZHJpdmVycy9wY2kvcGNp
LmMNCj4gQEAgLTMxODUsNiArMzE4NSwxMiBAQCB2b2lkIHBjaV9kM2NvbGRfZGlzYWJsZShzdHJ1
Y3QgcGNpX2RldiAqZGV2KQ0KPiAgIH0NCj4gICBFWFBPUlRfU1lNQk9MX0dQTChwY2lfZDNjb2xk
X2Rpc2FibGUpOw0KPiAgIA0KPiArdm9pZCBwY2lfcG1fcG93ZXJfdXBfYW5kX3ZlcmlmeV9zdGF0
ZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2RldikNCj4gK3sNCj4gKwlwY2lfcG93ZXJfdXAocGNpX2Rl
dik7DQo+ICsJcGNpX3VwZGF0ZV9jdXJyZW50X3N0YXRlKHBjaV9kZXYsIFBDSV9EMCk7DQo+ICt9
DQo+ICsNCj4gICAvKioNCj4gICAgKiBwY2lfcG1faW5pdCAtIEluaXRpYWxpemUgUE0gZnVuY3Rp
b25zIG9mIGdpdmVuIFBDSSBkZXZpY2UNCj4gICAgKiBAZGV2OiBQQ0kgZGV2aWNlIHRvIGhhbmRs
ZS4NCj4gQEAgLTMxOTUsOSArMzIwMSw2IEBAIHZvaWQgcGNpX3BtX2luaXQoc3RydWN0IHBjaV9k
ZXYgKmRldikNCj4gICAJdTE2IHN0YXR1czsNCj4gICAJdTE2IHBtYzsNCj4gICANCj4gLQlwbV9y
dW50aW1lX2ZvcmJpZCgmZGV2LT5kZXYpOw0KPiAtCXBtX3J1bnRpbWVfc2V0X2FjdGl2ZSgmZGV2
LT5kZXYpOw0KPiAtCXBtX3J1bnRpbWVfZW5hYmxlKCZkZXYtPmRldik7DQo+ICAgCWRldmljZV9l
bmFibGVfYXN5bmNfc3VzcGVuZCgmZGV2LT5kZXYpOw0KPiAgIAlkZXYtPndha2V1cF9wcmVwYXJl
ZCA9IGZhbHNlOw0KPiAgIA0KPiBAQCAtMzI1OSw2ICszMjYyLDEwIEBAIHZvaWQgcGNpX3BtX2lu
aXQoc3RydWN0IHBjaV9kZXYgKmRldikNCj4gICAJcGNpX3JlYWRfY29uZmlnX3dvcmQoZGV2LCBQ
Q0lfU1RBVFVTLCAmc3RhdHVzKTsNCj4gICAJaWYgKHN0YXR1cyAmIFBDSV9TVEFUVVNfSU1NX1JF
QURZKQ0KPiAgIAkJZGV2LT5pbW1fcmVhZHkgPSAxOw0KPiArCXBjaV9wbV9wb3dlcl91cF9hbmRf
dmVyaWZ5X3N0YXRlKGRldik7DQo+ICsJcG1fcnVudGltZV9mb3JiaWQoJmRldi0+ZGV2KTsNCj4g
KwlwbV9ydW50aW1lX3NldF9hY3RpdmUoJmRldi0+ZGV2KTsNCj4gKwlwbV9ydW50aW1lX2VuYWJs
ZSgmZGV2LT5kZXYpOw0KPiAgIH0NCj4gICANCj4gICBzdGF0aWMgdW5zaWduZWQgbG9uZyBwY2lf
ZWFfZmxhZ3Moc3RydWN0IHBjaV9kZXYgKmRldiwgdTggcHJvcCkNCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvcGNpL3BjaS5oIGIvZHJpdmVycy9wY2kvcGNpLmgNCj4gaW5kZXggNjVkZjZkMmFjMDAz
Mi4uYzFhNTg3NGVlYjZjZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kvcGNpLmgNCj4gKysr
IGIvZHJpdmVycy9wY2kvcGNpLmgNCj4gQEAgLTE0Niw2ICsxNDYsNyBAQCB2b2lkIHBjaV9kZXZf
YWRqdXN0X3BtZShzdHJ1Y3QgcGNpX2RldiAqZGV2KTsNCj4gICB2b2lkIHBjaV9kZXZfY29tcGxl
dGVfcmVzdW1lKHN0cnVjdCBwY2lfZGV2ICpwY2lfZGV2KTsNCj4gICB2b2lkIHBjaV9jb25maWdf
cG1fcnVudGltZV9nZXQoc3RydWN0IHBjaV9kZXYgKmRldik7DQo+ICAgdm9pZCBwY2lfY29uZmln
X3BtX3J1bnRpbWVfcHV0KHN0cnVjdCBwY2lfZGV2ICpkZXYpOw0KPiArdm9pZCBwY2lfcG1fcG93
ZXJfdXBfYW5kX3ZlcmlmeV9zdGF0ZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2Rldik7DQo+ICAgdm9p
ZCBwY2lfcG1faW5pdChzdHJ1Y3QgcGNpX2RldiAqZGV2KTsNCj4gICB2b2lkIHBjaV9lYV9pbml0
KHN0cnVjdCBwY2lfZGV2ICpkZXYpOw0KPiAgIHZvaWQgcGNpX21zaV9pbml0KHN0cnVjdCBwY2lf
ZGV2ICpkZXYpOw0KDQo=
