Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEAC231826
	for <patches@lists.linux.dev>; Sat, 30 Aug 2025 12:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756556288; cv=fail; b=rwyGSRtFOR7Ft9/6+4CGtwlXnPyciz2zAZ60mBuCKYFenj98Nk3/xX5Tbr4RuFXLDNsve4FboZZ2gfAn4kXMo7Vf3HT4MTERWVMGkTKweNHfBZnjtWJwk+L76S3bk2lNzOrW1essTd3BcBbCPCcOsRvkMpF87PLgh6eHGNZ65aM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756556288; c=relaxed/simple;
	bh=7q6zLHhhA62f03CgK7atpVfbKvYiL8C/vMGbPTvoUEs=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=NQd1RH9bko7wZXN2jV7AZoTRBHU3L1D/BXdgLUUp6U5jgn8YPmitFGLJWEX+YXS5G4hFAfJ//pcIHxYpHhB/IMMiLOyNwAd4KRjUtwbzkUE8VGFUqhcDsp1+Jv0eNPk4HIBWZ8OiUG+74OlTwJ9qfPGkTdBPwlH8n4DgNqnuuVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WxhfiyV4; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WxhfiyV4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PboBigHT3gIxa8ZZbekP+c+83zREllVFYtlAfUN07/k9DzZiO4OVDwn1tgdJ9QXWoJSQW/SLKLVofdX6PtO6dAxrAijYP0cuKPevn5tTiciZmAYMtuJHMT4wgVdjCxRFshshLjzeqDPg5gnCRtM0KZNpjhROK+ozh/GrLGFuZF0evN3VQHK5HnhNHSQ/1gacOxYTi2GsOGkjW+1IXcZ1f1a/RdzOtDSI+IxLb6MKxJCWt0UJTTrRwoF0yxqRVq2RqSpBl+eis1LxQoEoUvlSwHrwbkRBllP2D1k+YphIOawOaFX+He3EJUtlv86pfU/kdoT8gNoZSHu5LHxT6cqmSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Ys+DxUaeqfu1lT9m9ATj7KzEmKQMcZPYnu663JjCUo=;
 b=Q8tJwSjo25o+b6eAUKVb5m8m76zLhbGeIe3l4nsyrkde0CDs+F3CTKSkryeOBz5lT+PuCoJ3Fj2FxaGL5mXOHOsBJKPE8Ill0OY3U229ccelgYYAa5UrbdRo8PCHhvDV2w5IdHlduvCqPp9jsFHH0dBG5fLT+CJNxwSOojkTxiVfROUlA9hKk1MpjifsQTKikIuwWdP1ORcS2EsCBXVtXh915r/q7PSYGBIM1oXLz7+K1A0ZmWn2bgvzUlgSlAFQbjccu+61K9AX9d50ZjRhd6AgI+qZwDlLgEWUh6sD0Q9Dc4v87SOVYvFTaGxNfqSfeIHNHr7cZjWEwNVQb2LrtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ys+DxUaeqfu1lT9m9ATj7KzEmKQMcZPYnu663JjCUo=;
 b=WxhfiyV4lRJzx1MNHOr13pmKplbxcIKWHPxsdMwTPIK5IVooOIVfzQDTiYY0mGZwtMtoiuR0eI+woF7K6SJHkTQuhfcC6Cco918tYHZW92gqvrZtZeThx65MVH1ZA815iBVngKXifjo+iuq/b6TG6t7RQIZg5ZDzH97sVC/2IlP3mDvehPs15IThKKNPtgSaDZCBS7cU+9g2o7D+FKYNStHJZYTlJqLrzPClY2aXAvtW9KSBaa4TQI7hr+VzrQ4U7Fzk+bQ3u0wYeNzdjh4oqMqHZFUFxiCDPCdGJl1thWFDZsDC4M9Wy4Bg3GuqVITUmOrYdxtghjBWErmpLq6IXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Sat, 30 Aug
 2025 12:18:04 +0000
Received: from CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::6e37:569f:82ee:3f99]) by CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::6e37:569f:82ee:3f99%3]) with mapi id 15.20.9052.019; Sat, 30 Aug 2025
 12:18:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 30 Aug 2025 21:17:57 +0900
Message-Id: <DCFR8DTO39D2.1RMIDS2RUJ3H9@nvidia.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 1/3] rust: error: improve `Error::from_errno`
 documentation
From: "Alexandre Courbot" <acourbot@nvidia.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250829192243.678079-1-ojeda@kernel.org>
 <20250829192243.678079-2-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-2-ojeda@kernel.org>
X-ClientProxiedBy: TYCP286CA0180.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c6::13) To CH2PR12MB3990.namprd12.prod.outlook.com
 (2603:10b6:610:28::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_|DM6PR12MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: f59be51e-2239-4463-d978-08dde7bf4316
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmlOQWtXYjJJc004UWZaUnk5RkkrL2lxYXA0T0ppR0tKRFczUGdUQUZHS3NM?=
 =?utf-8?B?RWhiRjhOUnJzY3VBYTcyOFhKd2h1TTNRY01OdHk3OE8rNE14ek9vQTZhcGlt?=
 =?utf-8?B?eVM3ZUVTb2NKN2ZsWFZCODNNYUlwRGpCckNuYnNjazF1Z0gxcGlDT29DdEFH?=
 =?utf-8?B?L1VKaUdFbnBuSnJhVkIwK1VEbUsrNTdjWXF0aFlCTXFIY1lVMTZNWVZWVmR6?=
 =?utf-8?B?S2NoZFRKNENMN1JVeVh2YVhZYktQTUgwcGtLMzRHOEpmRWxPaytSUFJycmg4?=
 =?utf-8?B?TktZREphUmdpTm4reWVBRXdiTFMxUFVIYnVJZm9aaFRpN2NwQ01RSjFxZWdO?=
 =?utf-8?B?R2ZHOEdtRjhheWZCdmJBT0JTOHZFSkNxUUNscVc0VzAyTFoyR3JsZmFodzJE?=
 =?utf-8?B?Z2RsWFM3cmpBWnNWZXdRZVJPd29BYmlwd3kxdXhUU2N3TnVPVEV0SHhkamdC?=
 =?utf-8?B?NnJuYlVKK3lCdjdEZDZsVVlYMDF4YXoyeXE0WUVJK3dVb1R6MTEyZllTcDhs?=
 =?utf-8?B?Z2hQRW5CbFpTZ211RHZzbGxhalhabGEvaW1DMkx0NWFDTTR0UUsweE9QenpT?=
 =?utf-8?B?cnVrR1NSd1Jmait5eGx0Z01abXptRlhNOUF3QVh3MDVnUGhGQlBpTXNnKzRK?=
 =?utf-8?B?YUowS21lbWhTdlRHWXpkb00rRFFXTmNwMytjQ1E4R2dESjRQTFp3YUo1eTNU?=
 =?utf-8?B?OExtVitYSWJoUG1VUFVmUzlidCsrNStWUHJtV0ZYb2V2RFJHMGRkbktKSXZD?=
 =?utf-8?B?UGlBM09ROUhzbnVyZnVHUmJTaWMvdTQ0Nmg1YnZ4YUVTVi8zcjRFZGJkNmN6?=
 =?utf-8?B?eWh2Nlcwc094b0ZqSTlRRXNzeThKUW5GZk80WUtzNXkvY2NnZG1TV0U5WWNG?=
 =?utf-8?B?MC9hR0V2VElvSHd6RkhQV255ZmVzVVhaT3UrNEVmVU5kNHRCaThaN3M2TGZy?=
 =?utf-8?B?NlpTU0w3Qjk0TE1hbHFnWGVHa0pTb2VxZ0l0ZXVWaWpsbXMzYmduR2ZOamRq?=
 =?utf-8?B?RmIrbnZxdXVzZHJnUHVJbVZSeDQ0RDRGNkdjOUZDQ2VEN3dKdE1RTVhFZXBh?=
 =?utf-8?B?c1h1VjZndVpFU1BmeGRaalhTeVFWMkgxRnFmRXpjTGdBQnM1T3EwaWh1T1Z0?=
 =?utf-8?B?aDg0RkEzSk5jRk9sVm5LUTNxaDZoS2tmdW9CRFRSTVNLOVBndm5CZFFKRSs3?=
 =?utf-8?B?OTlYTHMrZjBIei9EZE5aU2lpUCsyMlJsRFFtdFRBcFlKM2RnbVNYTXdJenZw?=
 =?utf-8?B?VU00eHllNytENWFuamZTQ1dRRkdnbkhkSXZhVC9PNFVwRWVNWG9lQnJKZ1FN?=
 =?utf-8?B?MGllTEF4NDVhSncxQ2ZlSlB4M1dnL0tuZHc0NDJCOWtMbTYwY0FPcWg1SHp3?=
 =?utf-8?B?a0ZleldQeThheDFqTEZkUmc3NzlpNk4yL3JzS3FlczhhUEtCM2ZLNTVPbzdV?=
 =?utf-8?B?OWZOL0J5L2prai9Kem5IN2d6NDVkS2xlR09IeW5QbGIwTTIwU3lkTlc1MjJi?=
 =?utf-8?B?Ty96eWg1LzZkV1VhVldGcXVUZW1vakx0TXh1TkhsTVZEWEhrYUFiUEFMa3dy?=
 =?utf-8?B?ZmZGUFJPdFRZNE1jYkRPYTkyejl5aGQ2NVJBd2poSG5nNlYwRWN0L1VYQWZz?=
 =?utf-8?B?UGFlOUYzenZkc2Y4MjhvUHc3VUZ6ZzVHMXBLUjdvYnAvcndGSmFWeVRHSkVx?=
 =?utf-8?B?TnYwVjE4ZkczUHZMV00xd01vSmV1Q2tpd1lvalk5WjNFbjgxcmZVdFVYY3dq?=
 =?utf-8?B?MzhRa1RZRWoxRm91SEloU1o5R2ZJaXNJS0JSejFTRW9KWG00V01BaStmL0lB?=
 =?utf-8?B?RzNrWitqc3Y3czNnK0dSdG9kMzMvajJUN3NpT0N3N1BhMDJBL1UvUHhFeUwr?=
 =?utf-8?B?aVNieG4rT3hsWHhCRGJ4Uks1S01VekEyaHdZUFpKOGFNK043ZFB6c2dXdVUw?=
 =?utf-8?Q?OGbX01g9b7Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3NkV05SWU5lNGcrNG1sQ2xNeFYvZnRtV2VJclZYZDJ3WXYvT3U0YjhUVDI3?=
 =?utf-8?B?UDJ2TEVZMExHeVBsV3NYeHljQURBWnBGRTJSMlc4N0Z6K1BDSUFZK1J4WVFa?=
 =?utf-8?B?RjQybkEwVkRxcVlzcE56YUYyNk5ldXBXK0dJTm14d3BPS1RwZEpUQy94NHl0?=
 =?utf-8?B?WTFqTExqVXVZc243MStmYzZ0SmpVSno3NDUzd3VGelN0TW1sMlR0Q254K0hs?=
 =?utf-8?B?bmtRR3djc05HSW5lRWdGZXRiWlRqMWo4NFQ3SnUvdmswTm5OSkxmc2pVR1l6?=
 =?utf-8?B?Y0RnLzgxc3REd3JKL0RaSGo3UEoxZU56QjVxVXc1Q25rckV0OFNBZG5ZcmdU?=
 =?utf-8?B?TExPWWhVenJhckEyTW9NRE1MKzI2NHJQVGNsZU8xRlQ2S0U4YytCdGNmcjFo?=
 =?utf-8?B?dzFVa0FDVFFVTVI1RHZxbWpaTTV5VEpvY1AxTGpnOWtTK2NtSGh3Qng0Q0cw?=
 =?utf-8?B?VDByTURWWXVvdThIRExwai9SaXZQSCtSQTlaSmpNYVhWai80bml5WHJFTk9K?=
 =?utf-8?B?SUc2alJMaGwzaWUvYmFFQjBocGRnL2NJMUdWbTFablRVbFVyaDFJUTY3WVdO?=
 =?utf-8?B?ajc2eld1VS80dVNaaURFaXBscWQrOTNvNm81Y3FPR2o2RUZhdlhMS2VzVHVO?=
 =?utf-8?B?aklicUU1N2Y1eGI1dFlvdDFDQU1CWlhTTGNsSXpiNzJKQW9mYnhVSC9ZdkZB?=
 =?utf-8?B?UkVYTm9zMGwxZ1dyK3FIV2EvSHN4VDVpU0VBcEMxVkJFZjVyTEtWQlF4Z05n?=
 =?utf-8?B?MW9DKzN0TEVhRjNjMlp6T1h5VEpCblVHMUxWYWFxelRJTXhPNm9uMDA0NmlX?=
 =?utf-8?B?VGVIUGtSa29XNGhaeVhvNlhsUGZzLzZHRXpJMTlvL1FRZERmQlgxcHl1YmdX?=
 =?utf-8?B?akZrQS9GOFZsY1B3ZjZoUVJsRGUyUUlwZzlqcUZxRTJCcWZNVnl4MlRXbnVj?=
 =?utf-8?B?T2xJUHNQZ2s3dldFSjBlTVdReHoyb0Rhd0x2d2xLd1loSUxGUlRJNlVob1px?=
 =?utf-8?B?Q25vYjhGTUFqVHBUeFFtVlF5WXlBZ0NVMCtDdGR0R2U5MGRubGRNZkliYkwy?=
 =?utf-8?B?KzdJUW5taFRTRXhRWmgvMlZmWEhHcERKTk9IUHk3dktoZVVyUFZKSmZjNnhy?=
 =?utf-8?B?dlBxQ3hPK1Z6d2UzYzArV1VwNUZaM0dpdU9wZXdLQjRRNzdqcHUxeWxaOHkv?=
 =?utf-8?B?ZVY5Y3BOM0kzaVZyeWdkODNJellvSWhpNGNaTGRhL1Y3YU1wa2x3Q3RyYzBl?=
 =?utf-8?B?VjFPd3ArbnVpTHIyQmVLcU1qdmFvSGEwSVJQaHVhRDFUYXhrWjBFeEk1VjBi?=
 =?utf-8?B?MUZvclFxdC8wN1o1RWRrejN2eFZWdzQwQTY2TU9BYXBORTZBTVl2RTRKckRM?=
 =?utf-8?B?MlZaRUhpRDlucTdSM0laUjBQVGtUcGRJOHd6Ym04UEt1cFh5YmNCSVhOTXdQ?=
 =?utf-8?B?VndhSW9uZEtLb25MYWJ3cG0zS2ZCcEQrcTVRd1JiVjRBdDZrNVE0dnMwZmFP?=
 =?utf-8?B?UEw3RXN6SWlJWk1INmJzN3hwRW82K1N6aFUrV3duN0VseEdBNThFVXdtMjBk?=
 =?utf-8?B?UnZUTlF4QjI2aG4xc3Z4VHJkTjVJVGUxQ2M4c0J5blNNWHVBckdBd2Z3U0FR?=
 =?utf-8?B?VmZ3S2NkbjZUdTVTZnFybmlOc245STBtdzBlN2kwOEs5d2RTN1NVZTd0YUhC?=
 =?utf-8?B?Tk9zNGYzeUR6YUhhUGg2ZnV5NlFUalJWenFmVzFGTnV0cXNENDhodFh6emt3?=
 =?utf-8?B?N3dweEdZeUFxWU9KOEtWUms3Q1grZU9ETGN2YndvNmJkMS9rc2xkY2p2NHZz?=
 =?utf-8?B?d29CazVLNlZ2M2lGTmdlb0xmMjVHNEowVjczZjJTaEorWlFyY0JMRm53NEwr?=
 =?utf-8?B?VXNlVnp6ZEpYVFV1TmVSeEVURE91bmNGYVEzeGc1Z1hCR1BtR2ZvU2E5akF3?=
 =?utf-8?B?UnFzMmRzMjBDZGFUcWt1UWVKT25tcDNDM0pGNWU0OTdSc2pvYzdVRUJEU1pj?=
 =?utf-8?B?em1GbjR4UWVEVXRwdnZTUFVyT3FnZ3l2cWdoclF6SDM1L0hJSEdhWUQrcHNy?=
 =?utf-8?B?OTJpZjhEWnpnaW8vNHdjY1paRDBlZG1kUHVGQlQxSllMTFllR05JQmI4bGha?=
 =?utf-8?B?MW5iVnBWcUdGa2Zjc2pZMUNhYm55UCtvS0VOSStRcDNGa01vWlk0Y3gwdFcw?=
 =?utf-8?Q?ZuUCA8aaVpTgou0JJ8qIKaxfloOOoDF8ICuYmjRn263z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f59be51e-2239-4463-d978-08dde7bf4316
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2025 12:18:03.5110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Agxt0LAx893In039pyiDSLJgQGHDMoI4YBEN3LLYt976XgfjeuEDeOHuYhHpg1gAgEugbrAqSiyXvdQoQfQGEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235

On Sat Aug 30, 2025 at 4:22 AM JST, Miguel Ojeda wrote:
> This constructor is public since commit 5ed147473458 ("rust: error:
> make conversion functions public"), and we will refer to it from the
> documentation of `to_result` in a later commit.
>
> Thus improve its documentation, including adding examples.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

This reads very smoothly!

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

> ---
>  rust/kernel/error.rs | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
> index a41de293dcd1..c415c3d3a3b6 100644
> --- a/rust/kernel/error.rs
> +++ b/rust/kernel/error.rs
> @@ -101,8 +101,23 @@ macro_rules! declare_err {
>  impl Error {
>      /// Creates an [`Error`] from a kernel error code.
>      ///
> -    /// It is a bug to pass an out-of-range `errno`. `EINVAL` would
> -    /// be returned in such a case.
> +    /// `errno` must be within error code range (i.e. `>=3D -MAX_ERRNO &=
& < 0`).
> +    ///
> +    /// It is a bug to pass an out-of-range `errno`. [`code::EINVAL`] is=
 returned in such a case.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```
> +    /// assert_eq!(Error::from_errno(-1), EPERM);
> +    /// assert_eq!(Error::from_errno(-2), ENOENT);

Small nit: this leaves a tiny chance of misunderstanding that this
function actually expects literal negative integers. How about using
e.g. `bindings::EPERM` instead of `-1`?

