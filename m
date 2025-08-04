Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A5583CD1
	for <patches@lists.linux.dev>; Mon,  4 Aug 2025 02:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754273725; cv=fail; b=FDIR5Yn49RaF+KaF1e3mXMmYfDA0ep8XNcKWmUyYdrimdjfHuvFDOWX/oweqxjFzMRhlOg+1q2Uu+C4UVkwW82hOwXWIP5tKqcTtJnmCebG6qh8RAvXIJ0tUgq6jPLansUtxIl6rJdu65U3YmXrgBYLKmby/PzR75mzuEU/F97w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754273725; c=relaxed/simple;
	bh=4iTmE0EDyDGJ9XuhsXvCiWuu/WKygJJXjIjd3DNwDVM=;
	h=Content-Type:Date:Message-Id:Subject:From:To:Cc:References:
	 In-Reply-To:MIME-Version; b=A9nDsf2MO2280LWFvVpsOmhCMPe6VBa+bt0k45ZD/L8051AkMZNDW6uht064TNbakrzng/HzXsLCUGw/79AnH+b8MwEsF39+cUjJXPKN1ceuL1kKK4t1Pd0f3wpGIEONDzj+4piwnx48+hBiTPmJ2ovgl4BU5OwZqN8lQQT6WTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=apWtXAHn; arc=fail smtp.client-ip=40.107.102.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="apWtXAHn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=StEJVH9vSOKCOWNi54ZXX61X6RvR8wCWjuGnStbgFt03Rsleb1MhUeoxNawZFuBv3brYnMFliGOd+pt5/GXpljjbteKSXQhftRNiT9A798ZYKoEztwmybpIFkVPDKLO76gl8i+Oe/o5avzvsp66YbKF5m6GcDX8G3dad737xff3PwnLmsKPCQvT1Fndi1gotCBBooPjHEas4oPxjA73ri2WZwiip9eGC+mrxIfF9uDfyJMEgomuEYrbBHEC53BYjZoEdKJRVfaQyC8uAKnk/3JLXRpay45VX8DexZZV7haBETB9F6twzabZP7C/Lr7WjYLU/xqnZE9w2ezRWrbqsmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pg6qyOM5SaOfzOYVSuk0aA4rokQRASRpUiBRGn2foAY=;
 b=wgAcG3P6KyfK3Cc52bDFx9A30iP9L+D2lCXxKdz6fih4POFXpFuC4xg2OD1bQoNHIN5u0ecCvwGC3AgYy77DJ5pzm7Z8IrP5EobK2NW/klGh7FnnRST7VgptHMVlby73jAsMHPWjnsJlbrXSf3xsWeBpkTOj4XVyS1mgKV+dHirpCBdiwfmGuvwqVf4PDVTbhdgAJJiiIL+X2yXnlzW2RTsrjNlIQfzDxhHOGsFi/D10nuIM+CaO/X4sQPHJgJYRtZ7U49/OWxdHR5QyoYVmemiu4v3hWTd4eDi0bNZdAVkyqACRqcUaCTmPkMulHWSsvd5haKVx8XFS5ZLT57owtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pg6qyOM5SaOfzOYVSuk0aA4rokQRASRpUiBRGn2foAY=;
 b=apWtXAHn8CVr9wSgH2YDJA3QIS0sjpxput+NToX7FVeTlAfHbjuCgCB1zJXfd+NbI+/nNJ3Y2eFqg0bRpQhHumZokjqByIwUMYOuJoS6KEHKcOfu4s2PK7ZoOYjFEmt7VL3G2JCBWT+R2MyzHojxFIyJqLzrWca77i4LYOo7/zQjpkOr2jUMPlg1/6vFHxQ5CntK9lrBIHn46Dvl76GIxgn+vg2asvudgQfGwe5E+GlSWqn91JJwrJJme35fid06RykAlIGTCfT306YXR4uqI1dIR+c6Iy9xHGFsjTkBYotq7HqoDrqUlincByfphWwaDhu5HF8/7YIQ1BE7QSJSmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
 by IA1PR12MB8494.namprd12.prod.outlook.com (2603:10b6:208:44c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 02:15:19 +0000
Received: from CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::6e37:569f:82ee:3f99]) by CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::6e37:569f:82ee:3f99%3]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 02:15:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 04 Aug 2025 11:15:16 +0900
Message-Id: <DBTA4RX0BH21.1KPTNB4R6SJBS@nvidia.com>
Subject: Re: [PATCH] rust: prelude: re-export
 `core::mem::{align,size}_of{,_val}`
From: "Alexandre Courbot" <acourbot@nvidia.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250801161752.443431-1-ojeda@kernel.org>
In-Reply-To: <20250801161752.443431-1-ojeda@kernel.org>
X-ClientProxiedBy: TYCP286CA0136.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::20) To CH2PR12MB3990.namprd12.prod.outlook.com
 (2603:10b6:610:28::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_|IA1PR12MB8494:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8071e6-ef0b-4ffd-ffdb-08ddd2fcc291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjZ4TVcwM05LMDhzWnRkK2Vhb3VISlJXQURDYVhvczBFZ09ScjljQ0JVblVT?=
 =?utf-8?B?RC8rNk9rOWRNMFlpcVpKR1FlcVhsVmxRRU05b2ZCMjgzbW9HMFZEcUhFNHhk?=
 =?utf-8?B?N1diT1ArTm4rRFMrb3FVTFBscitqV29ESzdObDRUcHVGMEpKSlVxdDhZYVBU?=
 =?utf-8?B?a3VtWXJEaWhXdXlycS82Z25ubHorN0UyNGNRQXhGQU1JeDdiWkpjdnVNRFlR?=
 =?utf-8?B?Y3JuZGM5cDIzanJkOFVzSGlwMjF4bVc1TXZyMHArVnBVeU04TjBmUU90MTEw?=
 =?utf-8?B?aEZ5SnlDeXJOMFdMY2U4UjRzaU41Q1dhR0ptcytqeDVrSkZhLzJBU0tuYlpD?=
 =?utf-8?B?R3ErMnNwTzZhdTQ0TVpUbzVyZnp4dit3UmFqR1p2djJOZXNEWEEwQ2s5Tnlw?=
 =?utf-8?B?TUFHNkRXNlJvYVMvb29vbTh2Z0VHMVgyQ041SUM4N2cxNG5oSTkzNG10WXhO?=
 =?utf-8?B?ZGp6TVM0cVR2c1F4ZUc0enpldVhHU3c4M3liTGhCT2ZQOWxERkxjSkhCQ0ta?=
 =?utf-8?B?OFJNbEpJN0xNek5IVzVleXV4ZkR4YXV5MHRGa2gvS1BkU1YreXUxck9Ya0d3?=
 =?utf-8?B?Rndta0Z1Wk1BRG02b3p4b09tK0h2aTRoWjVVMnFTaVJFVkwraGxUbVNFK0VI?=
 =?utf-8?B?RDhsdHlWWDgvbGlwVXM1ek5pZ0xHbmRaeHFEd1d1MzV2WVV4dnROS21scGp2?=
 =?utf-8?B?NW16d3JFb0UrVVZJMEZVRE9iREx6aisydXpTZnBxWGtNVWVTYnBsYUpHajBZ?=
 =?utf-8?B?WXZ5VXh6L3JxUmt6STIwK3VnKzhoL2g0WDk0K3doVlZ5NWtLdEJDbHNVR1Fa?=
 =?utf-8?B?Vy8xNGNrV2Z1MVJBOXY1aHBKeVFCckI1MFZNTUd0bWpnaWpCQUx5aGluNm0r?=
 =?utf-8?B?YjRTUHlackdScTNnNW1RRUxDeVZSNFNJQXJaNjhhdlhwTlBpeTFsTjQ5bk5R?=
 =?utf-8?B?cVcvcXZ4TVAxTlB2VW81UWNzTTJtV0VCYkF3VnAxNlpXUWVuU3gxWXJOSnEz?=
 =?utf-8?B?ZGgvSkgxaHpCNCs1MkwwZXB0blFzZHQyYnp0OTFDaWpMcmJROFVWRnIyQmx3?=
 =?utf-8?B?cEpOcFJXQVhQZ3EvN2NMY0JrSWhGZm1TWGRzcSt0OGwzaDJNZHRpc1BJeVJD?=
 =?utf-8?B?OFNnSEI0WWZma3RvV01KVjVwNnM3cjhTVExPbGtVQnJob0JTN3lyUlFaK0Fw?=
 =?utf-8?B?T2lRUkg1YmVBNVpYQmMwRkdsSnJ3TmJDR3pET0c5QTg1eThEajdaZWhHTi9W?=
 =?utf-8?B?emVWV2cyQlMwZXFHTnduY3pQZHpxeWIvV0toZ3duVitVYjdORENtcDd1MW42?=
 =?utf-8?B?RE1mb1M3MWxrOENoUmtyQWh0T09GSVBEYVBXU0FQV01LVmVIMlRUYUF4SmpX?=
 =?utf-8?B?ZFc5czJCU0lSd0lwZzdLTDlCbTR2MnVYWU10TXBLVWNUV3NOUFp5UjQ0aEI3?=
 =?utf-8?B?MUYvbG53TytaL0lhSUFsMk9hUFZTbGFPaE1Jc2VSZTZtUFR4dnZzd25wVURs?=
 =?utf-8?B?R1ZHRE9UMW5zTEw0c1E1RU02djFFZDJ3WDFPRWhwOU1BdmFnVVhFNzRKZ1dX?=
 =?utf-8?B?TVNzSCtTVzlKaW4zY0E0VWZCK1hmOUhZM1h6aFBYa0g0MGgyUmk5ZmlqdkhR?=
 =?utf-8?B?RzMxTlR2QS9GZytrU2QrVjJnSVI5blJPNkNvZ3pnaFJBN0FjZmpuM01TajQy?=
 =?utf-8?B?YW8zNzJRejFtYWVaU2pRZjAxbUVnc2Z5V2t3NnBjdDlkaEYrbEtjWXc1Nm9G?=
 =?utf-8?B?WWhVWFBXcitUaTNhZ09saEI2ZHFZczNTamc5Ynd1UnF2YmhQOC8wSEZOWTR0?=
 =?utf-8?B?RDZyWUxSc2hMZ1VZTDM1akJha0I5RDNUNFpNWmlxOXgveFV4SElVWWhSaGRn?=
 =?utf-8?B?WUdOYnhjOVo1N3R0OTQzZU80TWtKQ0I2dDRtT1BvYWwxeks5cEdQUXlBTGxU?=
 =?utf-8?Q?M7x9vM0rZXJ3QtIYdr4+6Bb2v8k52Sh3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3F2OWU4WGVKWDNDdE91SXI4M2g3VXNyNFBIcEROUUxOREt0N0Y0clZmK0xO?=
 =?utf-8?B?LzdhcVQ3N3NYSjZCVThacFNxRWthZjBYeDFVSkFEZ0dOYW1LdHhZNTYxdm5t?=
 =?utf-8?B?OVBJVlhZV09xWFM4WWcwL2dNeDRmc3hQQWRGaE1LbXFiMWxFd2xLQ2lyNkFH?=
 =?utf-8?B?bk5lNFI0OGpOMjdjZTczSnI3N2IrR1Jjc1JWSjZFVVdzWkFoZHRoTGFDUi9B?=
 =?utf-8?B?bzBhTUFkeXpmZGlkdGl6OVAyZ3lKaHdzemZKa3FkVFM3aTNtYi9icVZlb2wv?=
 =?utf-8?B?bG53K1NreHBXMkt0RFRYV0pHVm14alAra29uTGFJODBTbmRpMW9Lcm1XQ0F1?=
 =?utf-8?B?cU1qUkdDTVhFTHJUdFV5RjUzcVFKREZJNWYwVjhDNkdBZW5mT3VCbUk3OUxJ?=
 =?utf-8?B?MkI2RGtwVkRJdDFsZ0gra0l5cnliQk9FdzhhTk5WRmRuYzB4VnpNODBPNkVh?=
 =?utf-8?B?eDUxMWFmeXJSaUJSc0U2MXpQMTUwcGMvazdRZ0lTUENzZGNuZkNFWnFNcjNL?=
 =?utf-8?B?NXhIdGtZaUdJSi92Y1R3R0R4QVdLWFh0RDk2aWs2eGdwYTdrQ1B1ZWdyNmxo?=
 =?utf-8?B?ZG00T2VEa2F2cGtEd3l6dERSY3FVNFhwYm1tWjVKREQwVWFtWXNmL3NITzZS?=
 =?utf-8?B?YVpHSlNrcUFtRjJYdTE3ejBXSXBWL1VhNjVNcG85WDlUTFNnYjl4dVVGZUoz?=
 =?utf-8?B?T1ZQS0IvM0QweWZUYUZOVDdBY0tBNk8vUWQ5elJCRVZ6eklOSGgyemdUbXZU?=
 =?utf-8?B?bU04SGJsRUNFN2pCbTJtOGJCZUViMlIzTFo3NmRDT2dpQ2cvQlQ2a01DT1Vq?=
 =?utf-8?B?VVhJZ1orYWx1OUdtWnYzbk9QWE1QNkhhOEtjWU11cG5jNURMUFhML2FYZE5y?=
 =?utf-8?B?d050blFKdSs1dDd3QWNKYStDL2hzNUVHZURaTW5ad0pQVVMvdCt1WisvRlhi?=
 =?utf-8?B?T1RyTlRVa1BaVzFkQ1JuNGdUb3R6U2xlUE9xaVMzbCs2YmFhclVkbVNCemcx?=
 =?utf-8?B?cW9JWGhrbWpJWTFqNEFBekpoeVpTbU8rYWM1REVja1RTUXFnMGsxN2doNjZt?=
 =?utf-8?B?TGhhQVVKOHhxL0Qxa3pZZFRXSG4yaW8xcXhMbDd5YXNpN2MyZEhZUGc3a2E5?=
 =?utf-8?B?N2RpK21NaFRxR3IxTTZjUytiT1N5SmRmWXhwdXdlb0YvY2pJYnV3VUE5d0wz?=
 =?utf-8?B?ZklHS00yeHlMM2hSZEZKQ0xVNDVtODJWZklOWmROT3NiYmM0UG9HVW1ZamFW?=
 =?utf-8?B?RzJ5RDZmS1hBeFl0b3Npb1RnQnU3bG1FYWM2R3ozRWRjeG9wQnEybGJHcm9C?=
 =?utf-8?B?azQ1aDZRTFJabURMSmp1TzZkSUZHQVlLV2tHR05TcC9EQWQ4Um1tRmNaZzlZ?=
 =?utf-8?B?WkNjZm9KbVhCUCtVTkVaVFNGYVZpSFZGMElmWmF6czJRcTRuZjRXZkk4UCtr?=
 =?utf-8?B?Z3BzY3hlSEFsdlg0V2RDb3FDTGUraXN6S0xBSlpGVXFFTVFaOVB1M1VZc3Qx?=
 =?utf-8?B?UzI0b0dpZlh3cUJTMmJNRmI3eTQyTVlxRnVEb1ZqdXBKSHVzSnFDQ1hKZnBM?=
 =?utf-8?B?YWh5THZXd0czeTV2bmlGZm1DWWdZTyt0cmdpQ3h0MVFibUk0UWJhVjN2c2di?=
 =?utf-8?B?NVQ5SVFCTmk2STN3WUJJanRtRkxKUjdhUi9HZ2xSWWt1MklCdWlRc2U3YjAw?=
 =?utf-8?B?RDVUQ2Z6SnQyVzFXRDZVbmh3YTg3NDhhajBJQXY2R2ZjZnZyak1LVVpQM1BM?=
 =?utf-8?B?a1VHMVZVSjJHTUd6cHFsdytycG8yeDBoRUYxdzBCeUtNTHFrdlRzeVN4Z2RJ?=
 =?utf-8?B?T2dxWTJldloyd2RHK2xUeDJJdjRLVktuRzBkdXJ3Ulh6Z0k3Y2Zzd1E3Qjh2?=
 =?utf-8?B?TVBMMEg0WC82SXVZVy9wWVVWT2xGSnNDbW9zWXkvZ1NIOVJxRmd1N2lydGpj?=
 =?utf-8?B?dFkxVW03VVE1TllRUDhyT3FLYXJBdWRxWm5wa1ZtYSsyWkxZSFk0SVpia0RZ?=
 =?utf-8?B?NnpSVXk3TjBUMFBXTGVrWUQ2V2MwTGZ1MXNXaktrcGkxR0JlbWNnc3BNTGM4?=
 =?utf-8?B?U3A5aUdvazExd2tXMXBCU0FkUmhyUzM0VzJHMjV0OGNtUXhiaXAzeWp2OWl4?=
 =?utf-8?B?WWJMOHhpdHVybVlDL09zZE1OWGZ4aktiV3FmbDdTdjQzaDB3R2J3MEQwMFBP?=
 =?utf-8?Q?1nII+b2eGQ8sF7+FCZ8S4hlGP94qZYcIHjHKaaDJPXeM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8071e6-ef0b-4ffd-ffdb-08ddd2fcc291
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 02:15:19.6408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjByd2CZSkr5kljEAH747/oOpz58i/E7aN5+dRppDVEIgAlP5+ifRooX1Pigaf4JIOdI6wuZz3COV4qUKMb9OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8494

On Sat Aug 2, 2025 at 1:17 AM JST, Miguel Ojeda wrote:
> Rust 1.80.0 added:
>
>     align_of
>     align_of_val
>     size_of
>     size_of_val
>
> from `core::mem` to the prelude [1].
>
> For similar reasons, and to minimize potential confusion when code may
> work in later versions but not in our current minimum, add it to our
> prelude too.
>
> Link: https://github.com/rust-lang/rust/pull/123168 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72kOLYR2A95o0ji2mDmEqOK=
h9e9_60zZKmgF=3DvZmsW6DRg@mail.gmail.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Nice to have these more readily accessible!

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
