Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A5253F3B
	for <patches@lists.linux.dev>; Thu, 15 May 2025 22:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747347763; cv=fail; b=iZdv5AOu3RkJvpQrspCB295vgaYcKevkkLN6IwAwJN3b5NGgddel1eaj2hDQq2EE1cIVCCPB5fvlqOwEf97yxniVptHaK9ZQPhI6mAQwSDBXCUPZKoqlqohUo+EqLffcP1zep3OfU9+5/xkAhJd7L9LG/IggSc01aRH5LLyv1bw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747347763; c=relaxed/simple;
	bh=AJqyZlW9xLSGXPoHetUVhHUeogpLP6TFhyTqby3jxN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HqO4lxYCAwEqYrXal0P+2wASglCdwdk8fzvTu5HvEAATzt0XG0WOGAseYVS7MmvSLbJxDVQQBipLpbVDArH9uDgD8ZZEi0VyFCdam64ATPu4Z7TLCYcE4IZK4zGTvkHyfubqJeeJYXVjt4P0tkFQEg6E509+SpkomAxR+sTUUOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uAT1Bana; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uAT1Bana"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yN7mJaNE7pBezXiJxDS5ZGXmYOG9Xu+7Xxw4die11Gl1QucNWDnc3Vjj4CYcOvO9nmxIOdZ2J5CbaRWAGs3fxVm3rzFvuCYNyBGRqW2m+peGcv2VhjSnRBk75gCV2QbPuPZBjbi1xgJAQcOmx1MUk82ZdY4N6tay3GhnJLZ88hJXC6r4m8IUAEcki+4QFYaS/mAv5gqzRpQS6pZj45/2b0oPKoMJRQUswIQscIBIlexbgTHJ0V915ZSztAuYHCMXvnzNZz3TQPqYRKbS0FofUpBrrc7HhBUxDzWE9ud8eaUGSXJt4d9bOK5rlUWOZoWYo9MRK34qaoFgaokceNFR9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJqyZlW9xLSGXPoHetUVhHUeogpLP6TFhyTqby3jxN4=;
 b=kG4nduljBZvfhaHdwrWvyOF8w6Bl6TTlzxbOh0IxzfR2zuKpLL/z8NmzRr/PV07IQ/PhQwxwkUxB+cOddylSJkyZOShyoUTQLZFQZJattWwNiZg3OEQPSaisbNImR5/2gevMJGrOaIU3lnT81XMVW1E0ScnK4neBjqph1nKITkWC1dvTOzo00nr7DyuYsLVQ86+F59d3PJYlpx96BqXuqqQ7AalOzfkcxdp+TAWA47/J4lovvFszofpXhf6MiFYLj+/auMCr/I5JdD8DC9F/yyzrDIuox5nOREpy2N7/q5s9FZvluHr2PgY3ngmSPbERIIlbl7js8ER7XF/tBkNyQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJqyZlW9xLSGXPoHetUVhHUeogpLP6TFhyTqby3jxN4=;
 b=uAT1Banan3OyLq1PYna1lS1IfX3/AyEdcGn99Jeb0o5MuOGxiIVNCJ2Eg50wLRJTlU5bxKpjyG1GjvuxmSmPh9FmRPZnA3ZmRYh/U4x/JwUDwaU752/utnFZMnCEvQA3IfINkVjsBlT4cIPgOE8Y9V6+E1WsXCbfyEci43RU1I5Bi6/vpJedTqAW1b2bngqRbXFj+KubWvC1e6mdUfqof8nguTAZ2Em5T+e8rrObzHZTlDpnXY4n8Ivssv01cwA9mRE68nH5/CzNNVr3nNvbb1Mz6CUB10BKAJbNBNWVQZR2gCOv4Axe+kRvTYI0STQP3+q0jXUmQ56oc9W15XXcZw==
Received: from CY5PR12MB6526.namprd12.prod.outlook.com (2603:10b6:930:31::20)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 22:22:37 +0000
Received: from CY5PR12MB6526.namprd12.prod.outlook.com
 ([fe80::e420:4e37:166:9c56]) by CY5PR12MB6526.namprd12.prod.outlook.com
 ([fe80::e420:4e37:166:9c56%5]) with mapi id 15.20.8722.031; Thu, 15 May 2025
 22:22:37 +0000
From: Timur Tabi <ttabi@nvidia.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>
CC: Alexandre Courbot <acourbot@nvidia.com>, "a.hindborg@kernel.org"
	<a.hindborg@kernel.org>, "ojeda@kernel.org" <ojeda@kernel.org>,
	"boqun.feng@gmail.com" <boqun.feng@gmail.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"tmgross@umich.edu" <tmgross@umich.edu>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.gaynor@gmail.com"
	<alex.gaynor@gmail.com>, "benno.lossin@proton.me" <benno.lossin@proton.me>,
	John Hubbard <jhubbard@nvidia.com>, "rust-for-linux@vger.kernel.org"
	<rust-for-linux@vger.kernel.org>, "bjorn3_gh@protonmail.com"
	<bjorn3_gh@protonmail.com>, "peterz@infradead.org" <peterz@infradead.org>,
	Joel Fernandes <joelagnelf@nvidia.com>, "aliceryhl@google.com"
	<aliceryhl@google.com>, "dakr@kernel.org" <dakr@kernel.org>,
	"gary@garyguo.net" <gary@garyguo.net>, Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
Thread-Topic: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
Thread-Index:
 AQHbxDH3Ep6RzftN7kiIvL2+4bJBKrPRG/KAgAAoPoCAAAXLgIAA7TOAgABJQICAAAkJAIABWCcAgAAu04CAADUYgIAAAcyA
Date: Thu, 15 May 2025 22:22:37 +0000
Message-ID: <901cd0be7099cf06415f6b4e5bfb245cec7b9dcb.camel@nvidia.com>
References: <20250502140237.1659624-2-ojeda@kernel.org>
	 <20250513180757.GA1295002@joelnvbox> <20250513215833.GA1353208@joelnvbox>
	 <38a7d3f8-3e75-4a1f-bc93-9b301330d898@nvidia.com>
	 <f4c946b2988d63a26aff2d03fe73fbfe1f52f31b.camel@nvidia.com>
	 <723f7ae8-bb36-4a4c-a1d8-733d131ca222@nvidia.com>
	 <grdfkevm4nnovdefhn7thydixjtdt2w2aybuvnrtot2jolyte3@pmvcv3vbmmll>
	 <554965650ac2aaa210028d495b06e1ede6aab74d.camel@nvidia.com>
	 <devk5empq6e3fy4vp5mhxaznzrxfso6d4bqqzpzachlwy5w567@32tvtoddkn6p>
	 <097a4926cebc9030469d42cc7a3392b39dfd703d.camel@nvidia.com>
	 <i7he6uxzzna7abu46xl3la5ix5t7psodns7k44bllgcq6lusty@wlcjvp7rhoo3>
In-Reply-To: <i7he6uxzzna7abu46xl3la5ix5t7psodns7k44bllgcq6lusty@wlcjvp7rhoo3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR12MB6526:EE_|IA1PR12MB7520:EE_
x-ms-office365-filtering-correlation-id: 9d8e09ab-789a-4704-996d-08dd93feffa4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZkhlVzZzNTh1ZmJnZ09hajVudnhqTEZINWtIdEEwb2xFWWd5cHliNXM1bUVq?=
 =?utf-8?B?bUpENEkzTFlLTlFYSDAySHdqR2p1Y01GbXBaZGVEeVVLVFlOL0hjYitYK2dt?=
 =?utf-8?B?aCt5VGpZVkFvZmJ6WUxBWWZVQ1k0cmQvUkxCdkRkYUVuWjZBdVZGUERqODJt?=
 =?utf-8?B?VGRzUzJMTWVFUVF4M1NsZkFPMG9wTGJGZmwxcHd3WmJhSlpma3EvQUNxWndp?=
 =?utf-8?B?VjF3L1BvaE5lbTFycjZ2RG54Mjlld2ZadEw4WTM0Wk9DU0g5VGlpbi9NYSsv?=
 =?utf-8?B?WWhrYzhEcnQ1Wm1SN0pESDcyQnFJMStNZVgwVnZTdG9sZmZCaUMxb3c1RUx5?=
 =?utf-8?B?eXVjV1hMeVE0RVdDRWRhVFBnSitzcWVZNzdIRHE4eFZhM0M1OVB3cEZWMGha?=
 =?utf-8?B?cFEyeFUxTXBNNEpodDRKeWlUeGtlRXhXOEVoaDBYZWhac01iUEprb005aTFV?=
 =?utf-8?B?TEdWMzNyK3puYVNWZmpRRFB2bitTQ1pkdkFtRUhSaFkrMmxTTHp1eExlVm1n?=
 =?utf-8?B?TkRMZXIweisweHhMVWlMQWRnZC9xenFQZVorTHk0YTJpL2wvUkJieG1wMnFa?=
 =?utf-8?B?NGxWaXpuc2R4QVd2eXJ6ZlBkb3lwN3FnR21WRWNDZnQwU2pkbGI5NGI2T3c3?=
 =?utf-8?B?S1E0N1NiQk81MkRRTVY1clloTzEySFJobERIVXpna09PWW5KM1JVSEhxczRi?=
 =?utf-8?B?clJKUndtNHh5R1dkZkh2OC95RHBiVjdQT3Q0VnRYbEU0akl1ZFRmL1pvZmg2?=
 =?utf-8?B?V3FDckplM0psZE56SWVvcjRUMEh3V1A0NkcxZTJ1K2tYUXFjWFJOWGJXUkFK?=
 =?utf-8?B?bXZNS2RnUFJERFg3dzhBVTh6UC9BL3NZb25RaU1Cby9GT0ZCQjlYVzNCQzR4?=
 =?utf-8?B?OWs5SFRRK0l2Y0hoclltM29hckJtNTQrenFCY3N6M3lFWGpBeFVsV3Jwa1B6?=
 =?utf-8?B?dXp4UUQ4VEF5OE82OVdCb0ljWTU3dWdBaXJDTXVRTEJCekZqR1VzOVd2Wkc4?=
 =?utf-8?B?QWhOOFh5cjBaS1ZCVDF5THFtZW1YVXlpSGVhSUYyWmRxRGRaL3BkOWNlOHFH?=
 =?utf-8?B?ZXM3aGFydmk5Z1ZKdnhySUdxNUhoSjhNdVQxMFhFbllJcVFPNXZMSVVndG1F?=
 =?utf-8?B?VFN0WFB3UWJyd0ZtUTUwdFdsMm10MzVoUU8xQ0FTYXpGNjN1Nm9CYUg2aG5Q?=
 =?utf-8?B?Wnl3V1NqZjVLRmgvYmY3SnU1aXorcUhRN0p6ak9ReVY5RitJSVdpVll1VThG?=
 =?utf-8?B?UU0wNExBYzhwVEVEYUxvckM5Z0l3cnBJVWQzYWFranZ6d1BmTURtZGFIdDlB?=
 =?utf-8?B?N0J0T0h5QjIvUlhsOUJQYTk1bktBTzh1REFLQkxNZU9KUUwwZXlqWEk1UEZj?=
 =?utf-8?B?UzFOOWh0VXZKT2hjSVZSb1pvQUlsZ2pHbHRGN2JsK0tlQStmT25RQ1V2SDdz?=
 =?utf-8?B?cytDcU0vN2NocWFIaGp1bGt2cHRmZG5jV0FUZnFnWjRGRHg0VEpFYVU5enQw?=
 =?utf-8?B?OTBadGQ1OGJwSDZQaEh5MnpuVS9KS2ZJVjhMTWJBNHBVTk51SnBsT1FJM1Mx?=
 =?utf-8?B?QkdOcTkwb1RQYUR5UHVNdzZObVVlTzV2K0NLWVlSbDhaRWlVSjJrNzlsemdv?=
 =?utf-8?B?YzVIODNyYlJKL2pGMEZUV0x0VWh2TVg4byswSjB1VFRvR3hST21Ccmdyd0Fw?=
 =?utf-8?B?dG5kTHVydzJ2TEZJbmkxWnVZVEZSK1hUS2ljQi80WXkzV2IrNHBiam1YcGFX?=
 =?utf-8?B?c3E5N0NiUEVOWjBTanR4eWl1T1VkZ2tTU0lhS3VJbVkxSDhyMjdCVUR2M3gr?=
 =?utf-8?B?cUFmRlpFdFpXM1hXUy9VRi9jMEJMNnEvYlkxRy92Qzk0eHhraFBnV1hsTlNr?=
 =?utf-8?B?bWo4REJ6Nk9sazgzK3R2UkV4ZVRkeGJHTDdScDIwcWUyQ3RjWXJxeDJqMG9X?=
 =?utf-8?B?OUN2ZzhCWEkvVjNOOUdvcGlUdE5XTHB0UzFUU2lkWkloTFdpdWtHbksvaE53?=
 =?utf-8?Q?c1At12rqhFOczAPWYvkt1/a09LMag4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6526.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Yzk1TG5tOGRnUkJoa25iaTNKT0pCQzVqV1k5eDJveHdHVmJsTGhMYmtJRjZz?=
 =?utf-8?B?SDVMUHJuaUxHQVpSRzhucVhYdFMvcnBJbmJZaUdCME53S2gvSEY0Q3R5dldG?=
 =?utf-8?B?MjZOZUgrQUx5TWErcVZEcFB1Y2FKdFloQ09peVJlL1lKT09Xbzk0WktpdVJl?=
 =?utf-8?B?L1ZGU0wydzZ6YnlCMEp6K3ZLOHVpSnQwb2tTZjdwSGVyZzJhamdzMDM1dkI3?=
 =?utf-8?B?MlFVOVZpL1NJQ29qcEw4WG5RaVVSU0RqRXA0THVqT01obHdOdmU5YmkveG8x?=
 =?utf-8?B?aHBURDZnc3ZTMjNqQllEWG1LMFF1Q3JadkNNZElqRjBjRDE4K0tTR3VsZzRP?=
 =?utf-8?B?VnpFZytzN0R6WFRwOVRCVUQ2Z21rUmN5TG1odDNzNG5mNWlYODhQVVlwNlVZ?=
 =?utf-8?B?RXNSWXpqUllYaFNLRGIxTGlOeXRXUVdvcHo4TlAySmFJMmhiTW84QUhOaEY0?=
 =?utf-8?B?Tmc4NXhHbUtKMGsySVZWUFFkNmJNelFWc1RTQzhaRVp0RERvNUlFRitsMVRR?=
 =?utf-8?B?cjd3SkIwV2h1Y2RtbTd2MjZpM3VrUnN6ZmVmWXlqMlFFbVNzbFAxWkxVbm5J?=
 =?utf-8?B?UEVqOWdUVVNZcERXOUQ4MlVCMVFvS3RtWXN6M3h3UFFaT0cyd1UwZk9sK1lX?=
 =?utf-8?B?cG9zYmtMb0VLRlRyL3lqNG5WdlVRK2pqU1grenduaDV5V0E1RFNJWFhwOHEv?=
 =?utf-8?B?eDdNcE5TTVJ3NW1DZ292ZXJDbERsbzVEOXRkQTlMQjltTzFwZVJCWVN4YmdZ?=
 =?utf-8?B?QXBKVUVNb01YTHJoQ3RYTlNoRy9sNi9FSUdacU04N0M3SG5EZHZTVnFXNXdN?=
 =?utf-8?B?Y3RBT1E4VnY1d0ZCSnJNN1gyNExQOUN5cTgybUw5TVdzbXY0RUwvVVV3bURH?=
 =?utf-8?B?QlQ0NEY2WC80MUw4aC9XUnVieFhaREZTZnlBYmV4eFBXb1JvK3phaTVrMWNo?=
 =?utf-8?B?b0tFWEVUTW83cXREZDVaRU16aW13UEJJZGZhc010U2lUNm5ycTNHUzAzVUJW?=
 =?utf-8?B?bmZHNHJ1a2xIdGtad1AwQmJ1R05MRTE3Q2pVdXJZOG1SUm5NK09SQ0hSMzZ5?=
 =?utf-8?B?ZmFHRlB1Sk5XZ1crYWpqYUU3dnFWZTB6SWs2QTNuY0NoUk1OYzVaQ1V0VSto?=
 =?utf-8?B?WDJJS09tUnNtd3hYUEZNalRwdStkazNFRnpKTUhwQUZPdzVUTk1STkpCV0Uz?=
 =?utf-8?B?a2FjM2FjL1FObVg0R3NtZWNiRm1TVWFJY05kWUNzaUxJaHNjK0V0N2hiR1Zk?=
 =?utf-8?B?RTROTE9zdU5SeFhnNUFpanJqK2NHQ3lkK3FiQ3hpczcveEdMb2c5ajlFVTU2?=
 =?utf-8?B?emdwUlJJckpuQnhKUENLcklvc1BTWktXQVM5UDc1bWx0QjJNWjJQUCtiMWZw?=
 =?utf-8?B?SU5BVE44L2h1azhFZDF0R2dYWFAzWllxZHJOSFFybjlSc2lnMGNHUDVwaUxo?=
 =?utf-8?B?enVPU3huMzZHMnUxR2Z2cXZNWEpOa1Z2bEtBcFVnWVQ0USswTnpZRUJvbW1T?=
 =?utf-8?B?U3VJMTlEaG12bEt2ZGhlaHE0N2FEZy9KSUhvZnRoTWRSRFFqWW5Pdm1QWThn?=
 =?utf-8?B?My9XQk9Fdm1wUTNONzQ3RTJpMk5EMnlSZC9hMkpaT0xUcEF1Wk5NM2lZMTlI?=
 =?utf-8?B?ZmphUFh0ZG8zWnFZejM3OHhzb1hOa3FHUGlVZ2RScDR3RmtGNWJDREZzeFU5?=
 =?utf-8?B?M24vNzM3c2FQUStWOVlKdHBpSDJ0MXVFbjFvbzB3YzI2N2hRWW9TTDBJVkpO?=
 =?utf-8?B?UmtrNkkycWNITEI2N2Y2Z3cwSllCK0N1MUduVzBwTlRtVG9BTEhIOVQzMmZU?=
 =?utf-8?B?b3B2QVdCbnpWVVFOYi9vWi9SUVl1WkpQUjVqZzlYbWtoTGNrWFFtYUh4cWZp?=
 =?utf-8?B?NEE3N0g4ckU1bGxDUkUwSVYvWHlzYnUrc2RsUXc0Yzh2dW5MeURGK0tJMXFo?=
 =?utf-8?B?R2w5L1FvWHhFYjNSMWJ3N0o1VTVsV0VvOWwrMUthMzB6S1R0WnRNVUVHM1Js?=
 =?utf-8?B?OTNtSUdxNXZNdWQ4RmRjSlVVK1dEUk94R3ArQmV5bmhRUmZrZHQ0WDJHT1dy?=
 =?utf-8?B?QzdsUm41MGxNM3JzS3cvZ1ArK245ZGQxU01GYzVQanpwbmpEa29xMk1WWHR6?=
 =?utf-8?Q?1sUF+L6BN94sQF3k8Jkgvk9mv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C7C40F2FA9D7F4A81C7FD6520F845E7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6526.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8e09ab-789a-4704-996d-08dd93feffa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2025 22:22:37.5840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: drGlusS1Y7qZ1i1twfMjkX6l/sWMoFqj6fX+nj7kYjkOg9fE2Mz03064NunHrAwi+AiseMZNoPpjbKt7MaMnNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520

T24gVGh1LCAyMDI1LTA1LTE1IGF0IDE1OjE2IC0wNzAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gSSdtIG5vdCB5ZXQgcXVhbGlmaWVkIHRvIGxvb2sgYXQgdGhlIHJ1c3Qgd2FybmluZywgSSB3
YXMgYWN0dWFsbHkNCj4gd29uZGVyaW5nIGFib3V0IHRoZSBDIG9uZSB5b3UgcmVwb3J0ZWQ6DQo+
IA0KPiDCoCBkcml2ZXJzL21lZGlhL3BjaS9zb2xvNngxMC9zb2xvNngxMC10dzI4Lm86IGVycm9y
OiBvYmp0b29sOiB0dzI4X3NldF9jdHJsX3ZhbCgpIGZhbGxzIHRocm91Z2ggdG8NCj4gbmV4dCBm
dW5jdGlvbiB0dzI4X2dldF9jdHJsX3ZhbCgpDQoNCmh0dHBzOi8vcGFzdGViaW4uY29tL0RZdWlm
blRCDQo=
