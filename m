Received: from GBR01-CWX-obe.outbound.protection.outlook.com (mail-cwxgbr01on2109.outbound.protection.outlook.com [40.107.121.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B741C823D
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 10:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.121.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723026276; cv=fail; b=Tz1hH0RAhzwkyoGlYRZga+W/c9B2pUhrZ0JEpjq/lFr7k3BAXr3crsaLoCJEDeHYVSHlLqBtHXTGgX7zxcnCPOHCk9oz94JT3xe7OFntUSfrzuLD7OJVXG7HJcBuD/G7GgwSIvSoBzE1koQPIWdmI8HW8f9OwUcmVXnowfnlRHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723026276; c=relaxed/simple;
	bh=lYtGQ0KtYleXsT/Vf3KLiMfcY2nXpAURUHFCZLDkBtc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e9vV7KT8S6dNKQdfS53/pyvrgVbp+slUpwK3qP8zNVKXITMtwjxL3O2t+XZeAsab5h9A6Oqgsa7W0TeTITKy5cUAIzPvziixjATLHxW8v5IeXfJ88kT0fCpt/IIMgSDDApII03CcmY1UsOiGqLsbTuOrQ6kjK8YRvWY+5MC9Xl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=ZkTR69t7; arc=fail smtp.client-ip=40.107.121.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="ZkTR69t7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ne7fi9AkfrEHFLKo94BwsQc+Xtm4sk7LW1D8hiilb8+10c/S8svuyNQo/4fzfc1M93hCA0Z5rMb8IYn+GAnaV256tivaxZDVSSiH6AWjvf6dyMvjLNfCrbtrU4mIB77hUKe2EQ6bnHvK2yJHK+gAXsAnDqXOyW26We4APgIbX5ux9FufD/sXFpEpK0eZ0A/WFz1QynE0+gNfymzqqOEqZxAayBGhVQG+/OWfm98Kq8KB/jhAxeOXbr2jRHWwm23nHXtzf1Ie9S7mzIerjeN1h9Ifd/hdPA9GsyHnbkigAlr5h70NyFGLdFlvxF7tGDopO41m1z2tc19g89XMBpYFuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsCRjh0cU0bQJxzUEr9YLKC6EYehMKZp71nf/nKbu+4=;
 b=QLbg9ZZHFgxmZWD3IjDPoP856Mt35YCqtNqVv4Rizbp6YnNf5II0ojX+SA6RoXziVO9LpUnYbR/icxFsPaiWj93Smk7fAf0Ropq/xk6GMi/+JLarIUSPXssj1m2nmpEEIbrvrLUoQy700vB4VeGTGTob4mloz33tTEk5jctNomxAaT1LhkGW9C+6hey6FcpscXVNZtJFNFRO+G1ZT5fEe6AGtkYeC5YrDcYsBukGrOQ5XW1SQlEfmrMmZqCxkEhJz5SVUe9hguitvbwBh7Frxcfy08IENdP/SXkmI4XRQ0/P8luTLFFp930+sU6HEJXTz8ogzyIhoWudTGZ6gWn1PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsCRjh0cU0bQJxzUEr9YLKC6EYehMKZp71nf/nKbu+4=;
 b=ZkTR69t7hsUgyOnWnbVaLCQYQPduaAF9c3HifzsJNLX0d2D/AZB/2JqrtfHJBFOQyGvOyZZMfue1bhr6qlVoaLMN8hggjoUtrH4l4BtT8pHli6FfslloEEozLaRuD93rFnP2Y1qikM4n6RmsvykbPNPbWW+TTVi/EVtudCfRA98=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO4P265MB6027.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Wed, 7 Aug
 2024 10:24:31 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%7]) with mapi id 15.20.7849.008; Wed, 7 Aug 2024
 10:24:31 +0000
Date: Wed, 7 Aug 2024 11:24:28 +0100
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Masahiro Yamada <masahiroy@kernel.org>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Wedson Almeida
 Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Andreas
 Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH v3 1/6] rust: module: add static pointer to
 `{init,cleanup}_module()`
Message-ID: <20240807112428.7620f5c5@eugeo>
In-Reply-To: <20240725183325.122827-2-ojeda@kernel.org>
References: <20240725183325.122827-1-ojeda@kernel.org>
	<20240725183325.122827-2-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.42; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0276.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::24) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO4P265MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: d77c625e-cf43-4bb1-9f51-08dcb6cb1fda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LUYcz9ayV7LKFeOIoSJrNU9PEKX7a0ZXTIu7snT6rmF6iC+d80p6UqcX2UdR?=
 =?us-ascii?Q?3f9jiwvzZAJ1Tcny0Bg2TQgV/qaxSh8OwoxsTfsfeQmlfzL4TQ5nfDzriOO0?=
 =?us-ascii?Q?pgTEIfDhyM2I09VZuso9ju54v/H5KEEWfW7XE4+obYWSHgzM/dGVwBlLFX7Y?=
 =?us-ascii?Q?z3ZsH+J5fvMhDk45SXOImhdeuLDsmCjIFC+oBkranmsncEs+gyCCRJBezpgP?=
 =?us-ascii?Q?4MIoewhAJhIyvJLdE/qNdWuIfojIl7kVKNH7Jld7JSf21aILhfHJFggdWDT6?=
 =?us-ascii?Q?DU+gPcY9Za/qF20kaXhQng9Ia2xKvLyncO7k+blXRP2cUC8l/6sWjMplkGfz?=
 =?us-ascii?Q?4Tt1Mqx2GQvYNvI0uT+6Y11AhoAGia5fqj2rBP2ML1pQ1lYZhl0nmC//1k4V?=
 =?us-ascii?Q?7NsJZkBg/rEXIII17LixVXxDkC4owADgYt6FRzcRkD/Y9T0oxANnYv3myIZ7?=
 =?us-ascii?Q?2ZLDgYDowHYOUoIKUVr6yNqewi228B8vy+68XLpZi8b5vdjGvp6K4ogSQf+r?=
 =?us-ascii?Q?nIPvA+n+cfN37dzFHGYGAf7iso+DcCVXekkNW9LP0oCeonDd21wxJ/Wfm/6g?=
 =?us-ascii?Q?bo5D4rQH2amY7wm31Lw2kKznC3uIDNzqILZKyE0cECFdeVCG0ZZGM99NBTBR?=
 =?us-ascii?Q?r0hejrK8WMhrIA71Cr739VdepTTrK7m0PjHXj8rYR8LpqGG9olPQQfHSnp7x?=
 =?us-ascii?Q?6+n+HmnceIXFlGgDDOjz8VTYkrhISdVr1sAZ9iVbmp6mqFV9GtJJ9XwGMh9g?=
 =?us-ascii?Q?pwRk/Z4Pw9qaBy6wrfTBDvSpxu16s3Leo3KYEZJh0Plblhtnrzoa083pSNlp?=
 =?us-ascii?Q?uXWmYbgR1oa6doO2EAqUlNkQBpE9Z/QyfKqAUCzxvqQMYf3y19SHqQu3WN3S?=
 =?us-ascii?Q?mh1U5v8pbd31nmF8S6yH6i5K2BFlFisOXtJJkAxIfbZl2U9BlBGtufjwvIcd?=
 =?us-ascii?Q?sUgHpcBCSgT05GJX/jdIpnbe0LBo5OBEW72329S70MVzPwNsfmhHpCgrkQb0?=
 =?us-ascii?Q?ZUQ/78eBG3qbjBxJdellY+kDzwwSZvYXuQSCGTDytz+kRXgJ+vqdb0N9XViX?=
 =?us-ascii?Q?60gCTlgAQmIa6XxcWJScu2kQrS0afDu4v+2mM80advYjnTOgXRbnxHQ7lAS9?=
 =?us-ascii?Q?4HBpuRs+Mwh3O7PEKSq59NdfijcpyPfih1odt+UFXoxeDgZRQGPPvSlQP8GU?=
 =?us-ascii?Q?rrNrhLnBr7VqOhQBK2Lq1igv8vAB2sCa3/P3w8JHixeQ8XG87n19/8LYXyfO?=
 =?us-ascii?Q?4XgWPyv1DDEtAQKGvvK9t9ZRQt8jX5SOJS+sycrGXw2SJDLCCPCr368N8dAD?=
 =?us-ascii?Q?4xjf/XgQDvIZsUL2ciqsSkTraBmaSO0fms1nFrPuv5R6hg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p7xy4kRKW5Mo/41Dbgf9vD3vpT2eFkOimm9U9NKpmeKYEFSunWz8j0PrH4z0?=
 =?us-ascii?Q?mjSAwXyxOOPi1kv9fVOmmvIfklZ/vBuA1zvDIBiW8T9jCrp8Geu1wIHKuBLO?=
 =?us-ascii?Q?zQ9vDqyETq9J6mUDJt58PTuuHQA2LR9Xpy84KicrA9gm8Y7YjWZMyVR3QSFz?=
 =?us-ascii?Q?beDCo57ZNOuhxamb+4YhRN75PJZk4OQ0KF/aexNrbg3QY5mgU1aeFRear5GK?=
 =?us-ascii?Q?wyfvL3MvQSFyHANxvJpgv9bojwhFGrSYzW4+90IZxmnje5oE/y4ONBCRoYUT?=
 =?us-ascii?Q?DPLg2ppqUSQ3asJI+5Nb/Sg6qMhgTis66wteOlGQRlwgFbXetdt4R/Cp4Wvl?=
 =?us-ascii?Q?HteBL5+zTidG+AD2nCWfJTTixmvDyHL34H1HnlX0YWaLEp1Ljvz93Rw5KhSj?=
 =?us-ascii?Q?hX9O68JiOcJ08wpWWJuhVi/lYmfzFFgm6g4me1jNJm5gXMgXAZKX0LbzhueC?=
 =?us-ascii?Q?2dbkzvNJFyYgeb9Ng+gTYJp1WBMzwnlCg9ybeGDHcXJk7/7HX5LZ1jpRt7gl?=
 =?us-ascii?Q?t9raeUKa1h8VJjiapP3+ncWjVrSORPFuVQClstg4x1uGeB+xCajH6XjRIAbP?=
 =?us-ascii?Q?tHN49hiH+eodSK8o5MP6GqHr38OwBUHNHANMx/41N3AYEjy3kig4creXTG/b?=
 =?us-ascii?Q?5D1PflGDyPr2arpS+LnQ+V51Q6AifJE74BkTaCigPrvUgZCzienJLGlb2R/X?=
 =?us-ascii?Q?9j4+/EgnAz2c4YxXtCSZfTmMAzlknczF5nGFsPG26axo4NbqQZaJ2ETxII99?=
 =?us-ascii?Q?Jl6Iz5FkvI/BMWdv8k3DLacAPp3wxz0w/rcSp2+l3njttKN7jXnZCATZgmRd?=
 =?us-ascii?Q?oXG6ihZ20aBqYpjfa4My1FPzhYSl2oP4SXzNveKlGBCpcw/QgGwOTnzDAPYM?=
 =?us-ascii?Q?0I901BQzpBLlRt7bgq8oGzYIbO5Wt3Cig7zawwhdaNi8VXhKRjPwwVyT8H9W?=
 =?us-ascii?Q?F/xL47AQcFTXaurNcF1lZYRQRtqj7ejGnW6mxsqB7CqKXa/eUFQTNh5JjnUa?=
 =?us-ascii?Q?jrIJo3ucY1obN0O436BdfyUE6B+QAcx5BrG45hLw1Q+K/vdTBMBexLUJ/djS?=
 =?us-ascii?Q?MPMfcxoFdATWmcciu7uQwJTjoFa36ts7PSkz3Pbg4IihUaoLVT2KkMkT+B+z?=
 =?us-ascii?Q?xQjcPSrtDe6OlxL59EjvvEYoNyLvvRq5/O0OgBgPSdCEi2q+2g5OY///5xZF?=
 =?us-ascii?Q?cX57uspr6m9s2a3uoGTPyPtCJhdgVuos5M7+RRwobGEfuzbjUG55U38sXk0/?=
 =?us-ascii?Q?WWDNMYFF/aoieX8HpRzd2EQuYy+K44E/BtMjEIYIw4dJRJsLu/oNs82v4Mua?=
 =?us-ascii?Q?4P0bNus0AHaCtJKH/sPQL3xgMGuMz/a3UKAwJz2rG+tPPVV7GxhS2RkKI1eS?=
 =?us-ascii?Q?RARUg0smZR+TXMhm0ARSpSN/vALvzEtHRZuya2KQGiXdxdPEP1NJaWffDu2L?=
 =?us-ascii?Q?hXvGDAwU8w8zkZIvAZzG7/9cOavCXS5Tz4R9lamI76/ulPNLYboKh0kbid2R?=
 =?us-ascii?Q?G+zUbWWwiHUhOQphTSpkIRpBvJhnmvdNWoKm+Dp/Qdita+C2ATz3UVr7u2lz?=
 =?us-ascii?Q?s0lpEemGM1K/s9xw3u8o9U4rXRC4T/kOILgtoV2a?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: d77c625e-cf43-4bb1-9f51-08dcb6cb1fda
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 10:24:31.0018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20b5wnlFrFfT6OsK47t2QhzYpLruILMgVUl5nR0rdU02epFBtzVUEsC5UEkwcBeEW+boWFr1cI/ZoPDaUKwJmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P265MB6027

On Thu, 25 Jul 2024 20:33:18 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> Add the equivalent of the `___ADDRESSABLE()` annotation in the
> `module_{init,exit}` macros to the Rust `module!` macro.
> 
> Without this, `objtool` would complain if enabled for Rust (under IBT
> builds), e.g.:
> 
>     samples/rust/rust_print.o: warning: objtool: cleanup_module(): not an indirect call target
>     samples/rust/rust_print.o: warning: objtool: init_module(): not an indirect call target
> 
> Tested-by: Alice Ryhl <aliceryhl@google.com>
> Tested-by: Benno Lossin <benno.lossin@proton.me>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  rust/macros/module.rs | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
