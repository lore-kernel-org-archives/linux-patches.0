Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020088.outbound.protection.outlook.com [52.101.196.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B04C433C0
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 18:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727548598; cv=fail; b=q4+AxPOAPLUtAhNH3s8Xd8YDmCieD7C0QRvVTTgslbv9q0Qz5D2NsVc02LCr6N1HzytBgAg55KSod00r0vCOXuyRrL08kNgYpc9BwjJPAtOvsCLJYEeirQLPx7VOL2AM2MZydXnf3GzGPkOYjERU7UskWpT2DjI5J51wIcV1WIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727548598; c=relaxed/simple;
	bh=Hf1DW27HdGf+tHiEsZmJ548OnfhYjCd2PksZxBcUw84=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gU1iZysHtgWMnK9KKTqsJ/yZpFhsgSxWmDAipWpQy4Z60f5NZe6LqJryygOMiQCQ9xe465Ztq/r3oYDf/hl3H7H4gqeAZ6WJBBeDe44vPt0jJ+xfRHBpSoDon0LHABtuAth7B95bYLe9qcBCSx/VXF0BuKcVq65WWL/yhddIfb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=0QxONjMw; arc=fail smtp.client-ip=52.101.196.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="0QxONjMw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JyDe7za/+XVVPHAE26AHgBXf/umjog3UxSRV2K3B3hJo0PAyzgy5p3UeCICwXr5HVJUMH8zwn9Ddgfp4rcSSzdy6/jWevr3a/66lUTJh50id3/DK4NT5n65rWPzs4KmfddtFFxm9PwH24ykXGoNgxss4/bXr0OIr22/Wdg2H5YN2h7APxC6HkCfdFYL9OcUYOblj884S+dqsm2jDbKfjKJ3ThrMtlBT00TpIrgDTBAXOp43PoVBOtkdyJ3dfGYX5SP+D1nv0N+7xqbKBHDhv9aJix7/bxTfc5x/HJfd1x76cY5WcrXPDthG0UVrXH7y9U81lXef5V81bRVNrVEjqpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9g67crxE/PG6HoEiYw5jCbZYbhy74dIQ6DeicACCBE=;
 b=ChsGoVT1sJ0vh/O83PP78o2Hl/BLL0uJ2lhSW52cD2J5JYeimn2Iz1zgi8oISZWD0tnZSzFFdWnT0uNsXZpMmvldEqnhW/hbUK8ZNpcxatZ6lVeTyHREj67pjCXVmsgZhwWmMSf0+zhwqxDuvDkKDKyOyqMRGSnX2rlwZ/Sd5GNz3JOG9RpSF9IGRwSxVOfsZQKACMWWh1K2GhFyQfoV/jGLclP42JtH/SUqNJDhV6vyIAXEIBCPuHqFPs1y0t0SwceK+STbBYbO3RhRA6/9zfffCfV9TVHzRxGGFJCS0EbgB0JYPysSt3rVBj64ImWJd5rwZiVujsWfErwka8n2eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9g67crxE/PG6HoEiYw5jCbZYbhy74dIQ6DeicACCBE=;
 b=0QxONjMwwlEuTA+l4VOJRgR+xsUYrpTRMDn2lPKT7hYFnl4A5Zz4Rq9MLcl1RLVFU9XnqtiGhpsjkYsX6SWx8ZmF/Jrvkryn2xcRXTQ7O0QoZfwf/v9UEYImhGqQjvy5Mc2i+OT0Dlxt9eIMqdZ4QamhihPUXGADbPu2Lge9lBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LNXP265MB2506.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:134::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.24; Sat, 28 Sep
 2024 18:36:34 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%3]) with mapi id 15.20.8005.024; Sat, 28 Sep 2024
 18:36:33 +0000
Date: Sat, 28 Sep 2024 19:36:32 +0100
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH] rust: kunit: use C-string literals to clean warning
Message-ID: <20240928193632.063d62a6.gary@garyguo.net>
In-Reply-To: <20240927164414.560906-1-ojeda@kernel.org>
References: <20240927164414.560906-1-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0150.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::10) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LNXP265MB2506:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a73e1a1-e5a8-4ae6-b661-08dcdfec7a46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C8zIi03iLBZ4KDt1xUQbI7l3P0fPYmYFV1pOig5tr+Kctpr1iv7huUoOLUJv?=
 =?us-ascii?Q?fGrBWSIY+DhTUNG1sOz5OBkww0DBRPQVs5KlY+DqF+IEPMnrP9WK2w3HCAiO?=
 =?us-ascii?Q?VpfzsUxR4R/3b3PqwpgvSfPnfjnVG58J5Vw9Ze+TjfXVD11B/QszQxe4Lipw?=
 =?us-ascii?Q?n9/8EHYMHDo4kWYJNyOKLElAofkYs4bwu76+lAiFuozE/sHYSyJwVd77wX/7?=
 =?us-ascii?Q?LNE0c5rZ5N1mLwGsRmoaQx5gtq8b0p2lNuCTCSUh64+ckrGNbei2+SNJ928j?=
 =?us-ascii?Q?qKAabiyFBWjIbmXtemyVZYTZT81d5jjGel7AMHQF98PbPBUz7MRG6I0h+caT?=
 =?us-ascii?Q?nVf9GaaVjkMIHlH8DXITs5AmeJQC7IgmLLKyGGhZ8KADj3ekThDbby8dCVJd?=
 =?us-ascii?Q?q/nEdjUDpOxfbFpZj5yhGTJkvjUfK9QWFdzKBIFNLC1ZrltwrQapwr19E3mS?=
 =?us-ascii?Q?ScXz4QJ18cA0csIObw54WTn7EOj2JtMmRX7thLarDxikCQdN3CuYyfccnJle?=
 =?us-ascii?Q?e+hx9Dodm1hdNUY6z4whTm5b1pHjFm+hkskmCC5Kv7xCtaPyaEHTCa4+5vKA?=
 =?us-ascii?Q?L6PsvpMlhn5U1GfqUmG4bc1GW3csg0FjbE4S8XC+lPZ8RRMTre39O5tpnfgM?=
 =?us-ascii?Q?ihmWsWPPGu/+WjAlW8aYD+iUrYYK7rL6y6CH4kv0wHHEdwn9lZHOZJbaw0Q6?=
 =?us-ascii?Q?uFBYM4fGwUnfInbaHrshj3LGAkC1iaBMKTH/xFWnmmR2hlW0s+IAGKR2TqRh?=
 =?us-ascii?Q?furT9NqX1MrD4GSHte3saxZN58ittgr7Qkx4HJUpY3OzoC2Gj2sp4758KCmA?=
 =?us-ascii?Q?MN4mHp6ZIJd8zVEebUZ8h4pidPSRaUMRKxgHlGtNkR+12RstwYWlKyqZIXxi?=
 =?us-ascii?Q?Q/YKv+OJmrh8v+9WGCoLuYmwgUhuBCLwX5UIj1FwT8UKE0deFdct3TYZaDEG?=
 =?us-ascii?Q?RHS13EnagdjOoI+yNEMDJd4QVn+0uRFP90f1xClaIHCW8l7+1rs3Edy3AQA+?=
 =?us-ascii?Q?fyQpo1SDHgpsXB5jPZqY9xtNV8HCo885DsmXSsOdNVvNI2wPP8CaB7GblnYo?=
 =?us-ascii?Q?3ip+lc98LUUOqymjsAVGtRchYzVHK2sYhCFH/M3qPzpXAnzH0DL7oDKVWrYN?=
 =?us-ascii?Q?//Ii0dwoi4IXwv3XXoEspfLtCTVZWYR4HNlFnVUPiShMuZ/JoW3HAd+CHxz+?=
 =?us-ascii?Q?AGjvupvZcpJ6yzt03xygXjDU02xZTbbTl7kP+RwlEhldpEq/PbV6jQP2LGU?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o4UuShTGywDSuYj7iv6oU3FDxoydaOE9oOT8LwiMFhlH1DHWrLbQNUAnvfEq?=
 =?us-ascii?Q?HGMdF9J7MGZZKxkyIRLeWzIXOFY7S+gzNZBBhP4Arov9qdTD1623n3Wb8ARj?=
 =?us-ascii?Q?iDEvIqk0oN13VtfsR5EGMWjvx9FGxiS8JkpTIzEgeB30gYp6YOgsN0KGaFIK?=
 =?us-ascii?Q?dTKPThBbC87l9pKCal+heNWfN/4bDl/pwk9I1vbzA/nBlCvOfwlyT0M9NdSR?=
 =?us-ascii?Q?pzSfpNB3O8aZwnb6jPghnPis7ZyekcnGwP7guEMWu7gOYpNJfMsijc1pu9cb?=
 =?us-ascii?Q?C+QxwpamYRGKd4iThtxS8wIRtwcU3iSwPyLw6h858ahU+gff6qF2urrYoSXG?=
 =?us-ascii?Q?M2GIkWrKitG32SlvygqU0Nbozf4a+4liWPk+A6K+GrceVA4y1YDwXqhoc3Gl?=
 =?us-ascii?Q?syzb9W3qqEVjXlBiKzq6VoPGMhKH6NntSA90F436tdSDHbTJ0S0IwS53zSTt?=
 =?us-ascii?Q?V4BAYyo4y05N+4LsYsrHDtP0pPiz+/jOvNwekC9AHr6xVyje77LhPUnxM+6A?=
 =?us-ascii?Q?SpdFaXH1rTP5kJ0jyXogoAT1bOQpcnzqDcdXpGjpJZk21aqfYEl56u4x8pJT?=
 =?us-ascii?Q?VWd/9cpQgWTm2+srnFwCI2six6zj1UZfGxtHe6Ix0MbjqkfP3zMo6YsJSwF3?=
 =?us-ascii?Q?kdVJK+1CEOpW9689UqDaXyzKXo6p5cBLjK4oLtzXMj1gyol+e/Sm93UeCLGn?=
 =?us-ascii?Q?oJfFDVBzRyVJbBwfJRjvyRoya2bFHKn/GVlj+f90K1CRFSryFSOF7YC9xRmv?=
 =?us-ascii?Q?/pXpyGhWAf7yPscjKa/jrdP5PG7OwL0Ch5CpygfPYVXdT9mxIolBaCTuI7ob?=
 =?us-ascii?Q?eAM8Vzu0x08MOb/Qela/YMGgvj6iJtbkaSJXGd2zPlAGDVySvZLW3MsyLQSD?=
 =?us-ascii?Q?u2chnLEkV/Qt1skikGmOR+wqPAigSZFXinC+XunUYiDVmIbCytvOCHAJ9X/a?=
 =?us-ascii?Q?Cl4fAECF07vKt+6ftAxKxo74rRXLt5OYX8vhInBZ/kEVkt9PW7GgbUrT2Hx0?=
 =?us-ascii?Q?tAk6wTjdnvYM9IfFzKJhBMEuybLPl1J8e0UBcZU9Mxv+kw5AvLn3ekAIjvlk?=
 =?us-ascii?Q?oAsvG+S5uAPYTEUjf6EYmRJX4iht6JuCG2VONF/sko+H5Oi95y2BAzy9aNna?=
 =?us-ascii?Q?MqQNg+wu2w5Tq4/77+ZQ0AJuJbOgRc5XPNjLdgY3gdYpRUg2Jiy15ymwQAlK?=
 =?us-ascii?Q?5acKHKCggG+jXVuKBlvd8UciABSUU1QSn/CTXzKXzf941MHBf8qF+iKqTgyy?=
 =?us-ascii?Q?EPi4Q4DGQwQU3UZNN64pkIdqDgtDif9F6nEAiShrHmKj5NjBRy+0IKOKOZ37?=
 =?us-ascii?Q?OC3xx9FZcQpDh70TiJDS8klQE/+hZh/iUsNd2mVIsIKGjcrFu6+GngNYIZMw?=
 =?us-ascii?Q?d5NHk5jOQbKL5OnR2KfhzC591y9iPIR35j9Em9s+JuRsBsdea5vPC7da9DJ5?=
 =?us-ascii?Q?gfp4R0WsX3kcl34FrCBzls+dsicB5Syy9em/znDFVLFOJzhzm4D52QR2dLOf?=
 =?us-ascii?Q?smo8rnfUX7EospIJhByLAbeFXe/zbJaS4mVFn8yJy0vGXDrl+dWmSHdhnBQ0?=
 =?us-ascii?Q?l3JtB6Orq7SOg16LnJMTXVL48cefxhGCEiNBi4R3?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a73e1a1-e5a8-4ae6-b661-08dcdfec7a46
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2024 18:36:33.8035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1r+KYdpBw0pQ+E/QwoLK6hM3IYoadSxmxV9c1ME6ygAx6MvRIUMpYeA29TY6Rxexb+7V4pjAaPhtl0b0OyETA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP265MB2506

On Fri, 27 Sep 2024 18:44:14 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> Starting with upstream Rust commit a5e3a3f9b6bd ("move
> `manual_c_str_literals` to complexity"), to be released in Rust 1.83.0
> [1], Clippy now warns on `manual_c_str_literals` by default, e.g.:
> 
>     error: manually constructing a nul-terminated string
>       --> rust/kernel/kunit.rs:21:13  
>        |
>     21 |             b"\x013%pA\0".as_ptr() as _,
>        |             ^^^^^^^^^^^^^ help: use a `c""` literal: `c"\x013%pA"`
>        |
>        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_c_str_literals
>        = note: `-D clippy::manual-c-str-literals` implied by `-D warnings`
>        = help: to override `-D warnings` add `#[allow(clippy::manual_c_str_literals)]`
> 
> Apply the suggestion to clean up the warnings.
> 
> Link: https://github.com/rust-lang/rust-clippy/pull/13263 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> The cast could also be cleaned up, but that is already done in Gary's
> FFI series, so I didn't include another patch.

Note that the cast actually need to be re-introduced instead of
cleaned-up -- `c"".as_ptr()` returns `core::ffi::c_char` which might be
signed, while after my series `*const u8` is expected by `printf`.

An alternative is to use `c_str!(...).as_char_ptr()` which will
guarantee the type is what we expected.

Best,
Gary

> 
> C-string literals are available since Rust 1.77.0, which is higher than
> our minimum version, but LTS kernels do not have Rust 1.77.0. But
> perhaps for these is not a big deal, and we could also enable
> `feature(c_str_literals)` instead.
> 
>  rust/kernel/kunit.rs | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
> index 0ba77276ae7e..824da0e9738a 100644
> --- a/rust/kernel/kunit.rs
> +++ b/rust/kernel/kunit.rs
> @@ -18,7 +18,7 @@ pub fn err(args: fmt::Arguments<'_>) {
>      #[cfg(CONFIG_PRINTK)]
>      unsafe {
>          bindings::_printk(
> -            b"\x013%pA\0".as_ptr() as _,
> +            c"\x013%pA".as_ptr() as _,
>              &args as *const _ as *const c_void,
>          );
>      }
> @@ -34,7 +34,7 @@ pub fn info(args: fmt::Arguments<'_>) {
>      #[cfg(CONFIG_PRINTK)]
>      unsafe {
>          bindings::_printk(
> -            b"\x016%pA\0".as_ptr() as _,
> +            c"\x016%pA".as_ptr() as _,
>              &args as *const _ as *const c_void,
>          );
>      }
> 
> base-commit: 570172569238c66a482ec3eb5d766cc9cf255f69
> --
> 2.46.2

