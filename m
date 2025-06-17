Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2055.outbound.protection.outlook.com [40.107.101.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB0028505D
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179141; cv=fail; b=JTTxo2PxHhD3LS1tgAQ6rOjJNadFG3HT5Sw3kwWiFtFZibNdzLyhtpX1mJ9u98aR8jwurwwLw69CFN4U2o4tXrniF6zZ3ET3d3Rh4UoP78ZaGpyMY0L2V4bdaZKASZUFDYFmI8VtLbygXLoghgyJNAMP+Wi/MutHUefo7tZyW/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179141; c=relaxed/simple;
	bh=gDr4x8D5VHz40S2u40d1vGqXpTpZkK6GBykbMBq6l3Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N7sb5v9KPH46H6ILIiSEhcCdkBybz3VJE+MdJ61qPaPOO8oK7zKg/fp0r+nKrMCg0FJAfnefcu2/OQcoxhKe8R3mKoY47SwCXUvemPF24E96SFJoq8S/xjEcjqLD6yNeI8rfjRS5rVD50oGg7OERuhFonTtg0NEa9epaN/hEh2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V4H6KVmH; arc=fail smtp.client-ip=40.107.101.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V4H6KVmH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mzy/lMALYtDYriEtWjO94rSfhNwpmyHFY3h4xxCJgobM0r69CIzEqSmfoZlIfRV8gmHgTZRBwlsJhufzl7cRPDrYrMLU+1q1TA1o13B2iAu8X14/DcbG414B6/2patBlqBd/9ObnhEghUyV8NM0+fjWdPI36hBRfF/Qr1bgNP14SUOuYScMrBcB9WOWsOOoqyDic6PE0xTDD4BBafosmYCmZdlzIdeqBsloKvIxKoUQOKh5c1iQWEnFhpcEDlF0q9fapymPPiC5ZlJ74hZAA3Pp+/5H7kNAhbVC3sw3kXqXNzbfYt3Q97u+8kWAuyEU2GxeOXtmW5ll3ExHXgrsECw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDr4x8D5VHz40S2u40d1vGqXpTpZkK6GBykbMBq6l3Q=;
 b=fD/M271NPfP6pz2UwdIiq+WyMn5kf9A2QpXKWkBKltAD/OEOD6JlbbyyjmEb8O8wNqRUxEm2BgcMS9QLJZEdpgTv4rCAnHOiR+SVNljrsIcUAt9Pk2KuUs+1cl+rWuaaApzdKRLziWlDQvfZSEQwpqeELHEnFRTN0pIFzc9KwyoYavNgaZulZ0WCEweYKArEdMz60Efp33QfnGh//wkFcTdz+Spc8Rl501QTOedi3j3DQWpPg9XYahVzCCt5CXfAqhKQjSb1MIkE/AxN0H1v3BG8PGC59NYIabLMovj9G/zcoD+Rm6CXkNbqNqTWm6KsUy1JhRQIP5ftHLk60wxidQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDr4x8D5VHz40S2u40d1vGqXpTpZkK6GBykbMBq6l3Q=;
 b=V4H6KVmHqXM/sVqHNqzmrv0lkt3lFiTej7UhPMBWQwPo/FD34NBeKhJpgHivoJqEKmst7XrtV/UrXlmCy+cy4pA8IImrC90JtvwpQYYVFtWxK1m4rjNhD8KRmN88/qdmvT3EStMYY0SM0hzsMmOCuEJQwHZ28+jrTJejwDy2P3o=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Tue, 17 Jun
 2025 16:52:16 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.8835.026; Tue, 17 Jun 2025
 16:52:16 +0000
From: "Limonciello, Mario" <Mario.Limonciello@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wu, David"
	<David.Wu3@amd.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>, "Dong,
 Ruijing" <Ruijing.Dong@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 399/512] drm/amdgpu: read back register after written
 for VCN v4.0.5
Thread-Topic: [PATCH 6.12 399/512] drm/amdgpu: read back register after
 written for VCN v4.0.5
Thread-Index: AQHb36UX70jycX0SJE2ezzg0pz6vOLQHkRGA
Date: Tue, 17 Jun 2025 16:52:16 +0000
Message-ID: <8327c670-2252-4b02-bab0-e0ab9bb47645@amd.com>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152435.755793153@linuxfoundation.org>
In-Reply-To: <20250617152435.755793153@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|BL4PR12MB9723:EE_
x-ms-office365-filtering-correlation-id: 0a58a003-b37d-43a3-c86f-08ddadbf50b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SzR3REFaL3BueHo4QUdSNGo0ZDJxcE1SUmVZcEJrczN3UG1YTUFFZGYrYUNy?=
 =?utf-8?B?MkNsK1BrVXIwN2pISm1mWWczSjZ5aDJ0ejNMWDJhZXJ0UCs3YzZOa21OdERL?=
 =?utf-8?B?L0VROTY1STJ2ZTI5TEp3cmw0bzFuTzY3VENHZGhZMFNGbDFQZ1d6OHlJWHNV?=
 =?utf-8?B?L0VUKytkMUhLejZJMnJ4MmlEVzBrNUhEUTh6a0dVRnhQdWlma0VTakdwSFND?=
 =?utf-8?B?ZFIrejZwSnZiSDV1MGJOaTZuWWV0czNpUXFJOE5QbEE0Q04wS0VwZWNaL0ZW?=
 =?utf-8?B?dUtmQkV3bmtMS0Rjc2kwU0E0eUZ4NUo4ZnZ4bzZTT0g5Ulp4ZWtIc0hQWnF0?=
 =?utf-8?B?MG11R1ZvSUMwOGN4REpuT1FrVStKczlnR2sxa3Z0RWRwcVk5TEhHdWU4TnpV?=
 =?utf-8?B?UHYrWUFvWjFsOEFLaXlHWitGd29LQnBWZlFRUzFNMTZmbTlKellhaUpMd0Fl?=
 =?utf-8?B?Ykh3QU1JVHlaUWJKMGVwZkZkUHN1U0RLa3o5MGhDeXRMaVZZemJYRXpNSFEy?=
 =?utf-8?B?SklHUnpJQm9kS3dqZ1RZRkltZFFqQXhCNVoxRnNkRzg5bk42cnZXYk8zWDlv?=
 =?utf-8?B?VWh2V2hqVFM1anJkWDRTMkF1RTBxbGxGTHZNdHdKbkhCRm5SZGZYcDQ4UmFZ?=
 =?utf-8?B?NU9YS0RKQnFjQnk3Z1ROTGZwaC92WStzd29UdUZNUFRLSzRZTVFCRjhIOWxM?=
 =?utf-8?B?dDdjOFZpaXhMMGhHZk85VDRsWk5zZWl3U3Z4TlpOeit5cGRtdWZNbndsdjZL?=
 =?utf-8?B?YytTaHZiRnptWGdaejhyMVUzcTVTdW9VV1RXdHdNNjBSZG1UUlEraHFmYVhW?=
 =?utf-8?B?TEt6NEZrVE9xd3lwa0pmV1AzZXI1MEg3YVVMakVJWUE0K1N2N3ZvdmxiUFk3?=
 =?utf-8?B?VHNXMEh6R3g0TUNRTFVpNUcyeHBIeGkrUHZuTWF4UDRIY05kbWI4R3JlR1l0?=
 =?utf-8?B?WWl3dXQrdFBkNkdSQzZLS3d4czlTNHNxZHZadVgvbWdVSy9pbGVrZHJOMndF?=
 =?utf-8?B?djNXYXROdy8xL08vN0E0NTRLZU9vcWgzTm42L1JJNTE3TVVZS21hQ3IyeDNL?=
 =?utf-8?B?NlBVZjU4dG9mSWZUcjNPR2pPUHhYTXBGSVFTdCtlUnNjaVlxUmQ5VVdsSEVB?=
 =?utf-8?B?YTFxZW4zSXJOd2ZGcHQrTmk1UFFRVUo0OXNDT3ZNZ2Y5K2dCQnVVejBNRjE2?=
 =?utf-8?B?Qm5mdmhYNU1ScE02VGk2bWJsT0diYmNxMjZuMGgydXdHMjJGSTEvb2drY3NN?=
 =?utf-8?B?WUhrRG9Sdm5Pa21Ucmg0Umk0NGhWeFZ4Yyt0eENCUS9MeGhKWklKbGJaZWRN?=
 =?utf-8?B?SVBxZGFocW5HTWdoQmkreFU2M01RSUh0cmMxNWZFNmFjN2tiWnN5RmVMdlR1?=
 =?utf-8?B?dG5Yb0Foci9GbTdYalVDMURUSjNpTENRR05oaExLWjBub1F1YWZMUkNOQUNn?=
 =?utf-8?B?ZXJ4UmhrVHlvVXYyUkFVQXBsOVoyZDI2UXBmOFdsZW1tRmYzVG03cExKdkts?=
 =?utf-8?B?STB6Zmd6cTR5blhjQ3VNMHVtNnd6Q2VtV1M3eFU5MUxTOU42bzdhR01BVUQz?=
 =?utf-8?B?UnMyWW9MQUVZVWNvVnI4Mm1CLzd1QWFTdTAwa2R2VGF3THRKdTRjWDB4YjhJ?=
 =?utf-8?B?Y1M5QTR3cnRqRWpCYm1sbFA4MWZOYmFRM090S1kzUEwzOVI5bGlTcHpyRVZu?=
 =?utf-8?B?dDc1dVlvcEw1ckRIcDErSDd0dDBnVXVtMHBQcHA2MitiSmF1WFFBaXNDRm5H?=
 =?utf-8?B?b2V1NitIbjA0cHNIa1ZyWDFRZjVITzNjc0xVaDZObUZzYStOSmFoaVo4a3JE?=
 =?utf-8?B?T1dMV0RtZFBzdkIxNTRCTU4rbkZ3T2VKcjk3RldpVWdNZ1NKaEk0TGJvVjlu?=
 =?utf-8?B?bitJTXprTzJDeGJjdTRabXZHcEZ2TmdSZFdYNWtla1o4V0ZKMCtGNlN5Q3R2?=
 =?utf-8?Q?nQ51S1HKYsI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MEhVRE11TjU5VEI1KzFGWkZnRHJGbTFOYzVTQVZ3bVNqRytjRG1ibE43ekxw?=
 =?utf-8?B?YVd6cHhMamdRZEVBejVCOHdtbmlsMXFUZWUxTlZMaWZlYzhxTVBSUzJsL2k5?=
 =?utf-8?B?ZDBKRm5NRER2SFhsSHRxRzFxY21NclB3Tnl2QTkvaS9HaVdjb2h1WkxzdWhC?=
 =?utf-8?B?VXJhQTFMY1d2T1VSWmZnM1pPL3ZtcHVjVERyWG5MRTdIZFZJMjIvMWNWT2xt?=
 =?utf-8?B?OFh4a3VoZW9VOHdjR2d0MS8wR1Vrbk9wNnBRVHY2MXBHQ3cxUEgwcW9JMFhP?=
 =?utf-8?B?d3NNQzFVekpGbXBESzd4T25LNjhxWVpqTDhFQlg1RVNZT2IwdUhBZnFUdzBL?=
 =?utf-8?B?L0ZuVVhUWnpYeE9IV0VQVmh4WURwUVl5Y2R0eWh6SytBMGwzU1FDc0xZUHI4?=
 =?utf-8?B?QzVielRmTXJ4Z1hPeUxKZ2ZTblBTcDdPZVBrZHFDY0NWbFB0eHFLbXhqc1Bw?=
 =?utf-8?B?eGcwNG0rOTZjeWxMeGdFWmVvbHQwSU9HdEIzbTBhOVpldWdHenlhRktPQnlD?=
 =?utf-8?B?S0ZNMUN5SGZjWnRZcjZBZVhPYXpaSnhOZXZZd1JQOHk1K3NwcTlLY1UyTkpl?=
 =?utf-8?B?MlY2enhIWXh1a0VnRkcyYjFkWmRCWFdQTXNtcTRmQVJNNk1aVk9sZVBaTitU?=
 =?utf-8?B?UkRZelE5UlozOXBmWU4vOTJWU0JOMithWkVhRHZqUnBHRDY1MTFSdGs3K1Ex?=
 =?utf-8?B?TjVRbXFxUTVyK09KK295Vnd2WHEvUkgzNWZpVml1YjQxZ0tmUTJKNUVyampO?=
 =?utf-8?B?bVc4alo4M0VoQzROb2tSZUNZNXlHWVkzYXp1ZHlwZFExMGJGdzV3TUozanJS?=
 =?utf-8?B?Snk0blF1ZXFRQjRlb1MyNzFsNUQ1azJDMUh5NksvV3VJeE5Wd1NtRWlzNmtD?=
 =?utf-8?B?bE9QSUlOckxmbXFoKzN3aTYwL2k4alhVZFVpalJsZFJGemVtUGs3NklIczlM?=
 =?utf-8?B?Y2o4cHg4MVpsSG9ZM0pwYnNZU2tGS1BVUHQ4eU1WeloyZ2hxVGdYblZRYVho?=
 =?utf-8?B?eVYyOFFhb2ZOYzNhSklWZTlFRjVtUGM0V1JKWFB6dlZNUWxFMmNaR0xVMHJq?=
 =?utf-8?B?RGRYTm90Nnh4bWt2N3QwQlpweEFVR2JXWnRJOVZLa2JkUDJnd2UwZFVHTitw?=
 =?utf-8?B?VDN3N1ZwQWRHbGlzOWJxS0x5Q1FxKzVBb0kwT2h3S3JDcUpTa0QyRElCdHI0?=
 =?utf-8?B?di93N3JSOVczelQydkRvTlNCUmc5SEVOS2Y3MktOcXZlUWpZNWxKV2w0RmVy?=
 =?utf-8?B?ME1xcXdUc0xpbjRhTFpvVVI2WTJvRGVFbWY1bDkyVDFad2lMZWtmQVFSVjBS?=
 =?utf-8?B?ZExpeTU0ZDNhazJiZVhFeDJkdWtnSzB5VkRLQlp6Ymt3YWdmUG52OTlyQWJx?=
 =?utf-8?B?SkVBa0hGZFhrVW95UkhXK20ybENSYkJ1NHhiaVRkTWR3dGh6OXk3S05MZm1P?=
 =?utf-8?B?SUtCTW55bVc0dkU5WFlNSlg1WTFtT0gwa1h1eWJWU29WV29rTldFcUFnV0k1?=
 =?utf-8?B?YmVXN2doVGQ2dHFtcDRYZDZqVjlBNGN5NXM1SW1yOHFQRmdib25MY1lsSTBP?=
 =?utf-8?B?QlRDMS9GZnZ5K1VaV1FGWEgxQmZSU3BtcUZ5Q0oyRStjYkwzaGJYc0pJanJx?=
 =?utf-8?B?YTFGT1BIZWlWL3NmUkZRZTNnVDk3V1hsM3FQZWNsZjRKVWhlNWNKY2dsY2s5?=
 =?utf-8?B?dU1YdEFDKzJDQnFvMjZWQm5HeGlXTWRMWW81b0g4NjJSZHR3VktIVFpaMEFB?=
 =?utf-8?B?cVdvUFMxL2lCd2RLcTJkN0lzUk84NGZhY2l3VDVhbnNNY0NXcHNUTFZ3d0xY?=
 =?utf-8?B?Rkl0K2hidUV0SFM5MExseEdqV1lUR3hiUlY5UHFOL0lwRXgvZTdGMHh3WUlN?=
 =?utf-8?B?K1NsSUFEclpKSlV0aU5adHNoSHVKcVFtN1lTT2hTVFB5YjlBN1lUWHZ2M3F4?=
 =?utf-8?B?ZFQzWElrSk5rU0hueXRGWHBOMkRld2hiQ3U0dGJ5Zkw2eCttT3ltMmFOK0x3?=
 =?utf-8?B?OTNzU2J1QlIxR0pzZm5sYjFnOU9jSkVkbUtBdGxjNTRsbUE4REFVSWN2Mkwz?=
 =?utf-8?B?WlhQMjgxM1JRRFgyeFZ5am4xNmdLVjBBcXBRWDA4ajBnMDdOaXZZL2JrUGQx?=
 =?utf-8?Q?j5lU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A70B293AA9A20A44A086BF28AB8A9096@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a58a003-b37d-43a3-c86f-08ddadbf50b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2025 16:52:16.0690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pmVzkRTlIIIy5gDkGaCCbEOovMGDrXriMq3zQox9hrArzT7WtqSNGr2HvGSaEcD15bJQOKi9lDC7EyQGNVwcow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9723

T24gNi8xNy8yNSAxMDoyNiBBTSwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA2LjEyLXN0
YWJsZSByZXZpZXcgcGF0Y2guICBJZiBhbnlvbmUgaGFzIGFueSBvYmplY3Rpb25zLCBwbGVhc2Ug
bGV0IG1lIGtub3cuDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IEZyb206IERhdmlk
IChNaW5nIFFpYW5nKSBXdSA8RGF2aWQuV3UzQGFtZC5jb20+DQo+IA0KPiBbIFVwc3RyZWFtIGNv
bW1pdCAwN2M5ZGIwOTBiODZlNTIxMTE4OGUxYjM1MTMwM2ZiYzY3MzM3OGNmIF0NCj4gDQo+IE9u
IFZDTiB2NC4wLjUgdGhlcmUgaXMgYSByYWNlIGNvbmRpdGlvbiB3aGVyZSB0aGUgV1BUUiBpcyBu
b3QNCj4gdXBkYXRlZCBhZnRlciBzdGFydGluZyBmcm9tIGlkbGUgd2hlbiBkb29yYmVsbCBpcyB1
c2VkLiBBZGRpbmcNCj4gcmVnaXN0ZXIgcmVhZC1iYWNrIGFmdGVyIHdyaXR0ZW4gYXQgZnVuY3Rp
b24gZW5kIGlzIHRvIGVuc3VyZQ0KPiBhbGwgcmVnaXN0ZXIgd3JpdGVzIGFyZSBkb25lIGJlZm9y
ZSB0aGV5IGNhbiBiZSB1c2VkLg0KPiANCj4gQ2xvc2VzOiBodHRwczovL2dpdGxhYi5mcmVlZGVz
a3RvcC5vcmcvbWVzYS9tZXNhLy0vaXNzdWVzLzEyNTI4DQo+IFNpZ25lZC1vZmYtYnk6IERhdmlk
IChNaW5nIFFpYW5nKSBXdSA8RGF2aWQuV3UzQGFtZC5jb20+DQo+IFJldmlld2VkLWJ5OiBNYXJp
byBMaW1vbmNpZWxsbyA8bWFyaW8ubGltb25jaWVsbG9AYW1kLmNvbT4NCj4gVGVzdGVkLWJ5OiBN
YXJpbyBMaW1vbmNpZWxsbyA8bWFyaW8ubGltb25jaWVsbG9AYW1kLmNvbT4NCj4gUmV2aWV3ZWQt
Ynk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4gUmV2aWV3ZWQt
Ynk6IFJ1aWppbmcgRG9uZyA8cnVpamluZy5kb25nQGFtZC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4gU3RhYmxlLWRlcC1v
ZjogZWU3MzYwZmMyN2Q2ICgiZHJtL2FtZGdwdTogcmVhZCBiYWNrIHJlZ2lzdGVyIGFmdGVyIHdy
aXR0ZW4gZm9yIFZDTiB2NC4wLjUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2Fz
aGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L3Zj
bl92NF8wXzUuYyB8IDggKysrKysrKysNCj4gICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25z
KCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvdmNuX3Y0
XzBfNS5jIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvdmNuX3Y0XzBfNS5jDQo+IGluZGV4
IGUwYjAyYmYxYzU2MzkuLmRiMzNhMmI5MTA5YWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1
L2RybS9hbWQvYW1kZ3B1L3Zjbl92NF8wXzUuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1k
L2FtZGdwdS92Y25fdjRfMF81LmMNCj4gQEAgLTk4NSw2ICs5ODUsMTAgQEAgc3RhdGljIGludCB2
Y25fdjRfMF81X3N0YXJ0X2RwZ19tb2RlKHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2LCBpbnQg
aW5zdF9pZHgsIGINCj4gICAJCQlyaW5nLT5kb29yYmVsbF9pbmRleCA8PCBWQ05fUkIxX0RCX0NU
UkxfX09GRlNFVF9fU0hJRlQgfA0KPiAgIAkJCVZDTl9SQjFfREJfQ1RSTF9fRU5fTUFTSyk7DQo+
ICAgDQo+ICsJLyogS2VlcGluZyBvbmUgcmVhZC1iYWNrIHRvIGVuc3VyZSBhbGwgcmVnaXN0ZXIg
d3JpdGVzIGFyZSBkb25lLCBvdGhlcndpc2UNCj4gKwkgKiBpdCBtYXkgaW50cm9kdWNlIHJhY2Ug
Y29uZGl0aW9ucyAqLw0KPiArCVJSRUczMl9TT0MxNShWQ04sIGluc3RfaWR4LCByZWdWQ05fUkIx
X0RCX0NUUkwpOw0KPiArDQo+ICAgCXJldHVybiAwOw0KPiAgIH0NCj4gICANCj4gQEAgLTExNjks
NiArMTE3MywxMCBAQCBzdGF0aWMgaW50IHZjbl92NF8wXzVfc3RhcnQoc3RydWN0IGFtZGdwdV9k
ZXZpY2UgKmFkZXYpDQo+ICAgCQlmd19zaGFyZWQtPnNxLnF1ZXVlX21vZGUgJj0gfihGV19RVUVV
RV9SSU5HX1JFU0VUIHwgRldfUVVFVUVfRFBHX0hPTERfT0ZGKTsNCj4gICAJfQ0KPiAgIA0KPiAr
CS8qIEtlZXBpbmcgb25lIHJlYWQtYmFjayB0byBlbnN1cmUgYWxsIHJlZ2lzdGVyIHdyaXRlcyBh
cmUgZG9uZSwgb3RoZXJ3aXNlDQo+ICsJICogaXQgbWF5IGludHJvZHVjZSByYWNlIGNvbmRpdGlv
bnMgKi8NCj4gKwlSUkVHMzJfU09DMTUoVkNOLCBpLCByZWdWQ05fUkJfRU5BQkxFKTsNCj4gKw0K
DQpUaGUgc2NvcGUgb2YgdGhpcyBjaGFuZ2UgaXMgaW5jb3JyZWN0LiAgSXQgc2hvdWxkIGJlIGlu
IHRoZSBmb3IgbG9vcCBhYm92ZS4NCg0KSUUgaGVyZToNCg0KCWZvciAoaSA9IDA7IGkgPCBhZGV2
LT52Y24ubnVtX3Zjbl9pbnN0OyArK2kpIHsNCg0KID4+Pj4+Pj4+DQoJfQ0KDQoJcmV0dXJuIDA7
DQoNCj4gICAJcmV0dXJuIDA7DQo+ICAgfQ0KPiAgIA0KDQo=
