Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020075.outbound.protection.outlook.com [52.101.195.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08341991B4
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 19:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736969160; cv=fail; b=FBM/OOflADW0hepW4yrMfy3L6bGvCaF6ZMZPG9Uwhf9MAAWHZkz/Nj65D3EJnpCdlkcoaspTuRGH+tQ3dBPE7+eehc4G5jEpofiETLw+TaSvfDjHNg5pcJEI76ijoZ1Dr3xC1Ku+UvMKIQ5YesOpqyC8sRzHBVjjguP79DNUo3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736969160; c=relaxed/simple;
	bh=KHl8tAsnI+3Di8g3J4iJXATz5N5wvUuFb1ZzLDR5zXs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tPgJTcycjjEeSaEjp5Bj7usjD75qwI6/yfrCW1oe6wMFmf7FaLWfYvkfVkHro+cYBFS6+Eu77twlQusCO7ssO84pOGNuJDYd2ki73RSBzmlAq8KGCyUEJNm5miqiSSF5HT5r0+lmitB7w3E4t6hsS/vW3uUmnlI2P/VNTYE+fWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=RjTCu0zy; arc=fail smtp.client-ip=52.101.195.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="RjTCu0zy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0c34Ifymvi0vznXDZXtw6rft59dV7b03G+9rkf/b+5m8i1UpCbEMnbZ8Wwii5B7e2gotY82gSOK2mzE105ut6RPqtsutZZPl0b/mARELWn7u8d3h2XdTZAvX2y+jP+OeO8wMSqWlnv489vhjy8ufxahTCSGV/kJCi0+zFPhq6+M/UNY8ZurZDho73tX+/jrlI8OUfavflZCwnKLIvLq0SPiZ6ZnBX0RmYIYNslQnoLloEuS3//7SKvYW+OQBUpV8aLYpzyvQB4/pmQcp28XwS8rK+RJk0bfmNuZ27G7e04ngbFbkEMp059LcIK619CrpLmx6UUPu/2TJjUBwNwjgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHRcNxbdI+7sf+0gnBdpNedM2OvxNk1TxAje6NzIOLE=;
 b=LVl4hkTlThJ/oXlMmWfKYiLjLsmvT3duZAOrq5jYsQxXgx9zWQXnZ8Nx1J2BLM0BwZpGwnoGn0cdwaG5ageTwoCvxVotOCRi3f9SeHl2F2ad6HKLJ3BlNDQzSDaiV5+R/NwC9mibj4/y5piwSjvTfUNNQNq7dvEHE7aMdX70uuJB5PJe6D460SnOEN0/owAsH8jXoFGRM+GOidmukPyhJfGhSkYYf+CLg7BHaaYWyNoHlq2yVvmmglX40nRZBwJ0L4V51lYZIj+Ty8PHP5TAtjLr0PECLQ+zzp/x8VM0T9KWwk7oKV8fQ1ERMKtZl1gr2pScmuZzIaXOq+4TYklA2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHRcNxbdI+7sf+0gnBdpNedM2OvxNk1TxAje6NzIOLE=;
 b=RjTCu0zyXCVzP0cO2LAY5q40EkV70MVR8X9g8OJ5MmGHSdzyElvJMFRZH7pjzh5O8toJysdkaRQ16lAJjW+hsvCHTt+ayrp/ObwLO7ktjxyTdVSZbCNldCy8e283TOKJJvrtjrFAJuMOILdBkT328wxZPFM4nbDMpLiZOjFqQew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO3P265MB1849.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:b7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Wed, 15 Jan
 2025 19:25:55 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 19:25:55 +0000
Date: Wed, 15 Jan 2025 19:25:52 +0000
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Andreas
 Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 stable@vger.kernel.org
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
Message-ID: <20250115192552.434f0ea0.gary@garyguo.net>
In-Reply-To: <20250112143951.751139-1-ojeda@kernel.org>
References: <20250112143951.751139-1-ojeda@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0337.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:39a::9) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO3P265MB1849:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a31158-f78e-44de-3e7e-08dd359a6e6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h9BiXAl75FMIuDC6t4FLa8DyB0tGQR0o+HjZqtoklcl/oOAjTiR77r/Kdhhp?=
 =?us-ascii?Q?O7YgVIH6dzEgL4xXZaivx62/hOE5E2D9xOv/4NF909xMkXFln5hyYbVz99OH?=
 =?us-ascii?Q?TwrECPKr6uPjPuQ8UyMV1h17zKhP7vvDuzBXxngnApmEeThV8stbqPiTgSNu?=
 =?us-ascii?Q?9PbLXTuHTfaE6h64LBnK4BD6Ef5eXmmsrrfQ8DFOtu4v6P4r6HRMCYbmAKgW?=
 =?us-ascii?Q?pFYPkpEXt/Ky60Ho0ZoBVKS4LsIX3Mwvc/meBkpIBUePD8T3fkWvpPWEvvdB?=
 =?us-ascii?Q?bUJu6sbvScDUPT3T9a7ZEXStaaeDtreDcNifJ5dgmhg0qgdTeBE9ckOBG/m1?=
 =?us-ascii?Q?pdJTlegFrPq9Hgz93CrrUfe44FfjPB55PeGJUwuDkKX+ee+CiUSwk8fPfoUU?=
 =?us-ascii?Q?Ou+q7adtMzB2rJRzOBLUP58bW7NmkZhz6edL2tg6fzRUpdlNX3yzzWQVVcHt?=
 =?us-ascii?Q?rrgEyRI6dqH3eCSd1mytGqVuCXFpoGbGPT2j8hFGmRV4GUEKZrAM3leVF+sj?=
 =?us-ascii?Q?29uAGcLea79YhPJq/NSDcKmeBKva2ZHMeQbA8Vr9DO81EICF2KD1CU9+3Ad4?=
 =?us-ascii?Q?KEV/6X8vf5/P3qXeMrmoZtmKfVEPBOWi012H8jZJouxeGD6fs2tVkDAx8+BD?=
 =?us-ascii?Q?Wvs0d7aMkgPszAdWcuhbsDcQAZaIxnhFPIqrxMwZFB5SgRQm4lBFR6oaNCKi?=
 =?us-ascii?Q?HDWiDwzFknfYaxgQiOXPHOqlATrsZVGe+dcOgocH1CazCuZlxBm+ITcchx2S?=
 =?us-ascii?Q?ahzKC2wN0Bww952HHFtZB/xXnUIYBLR7lz7Zzr4rBWg9xTsCFUFH0d9et44U?=
 =?us-ascii?Q?9qyUm8mtg9SHrrBLa6nKLfwA3i8Ow4pauGLHjIo0eiEt7YTj0lAIoJ90V+he?=
 =?us-ascii?Q?/FV5e+QVGtuojODFIopAzKYra7p306NF/jF4nJKIeg3ZQHljvcVTnKZSGgl8?=
 =?us-ascii?Q?H9w55ywYLHRYGQ4/ncIlKFDsrxWSTLwPk95Tujoe/O/6Mhrooe0bJBj6TO0B?=
 =?us-ascii?Q?SjQlmVw4CCnRTQnx/hK9jF0MpSpvn78NAIs1glWiTuJXbLjyrx9NBwMUhFKl?=
 =?us-ascii?Q?j/mPjVMe6alPRKh6BUyj3UsXUU8Wk3mZ86TwT0lXUFucgFNoWqDQjJFOmlE8?=
 =?us-ascii?Q?bQB+bI1UpGvKE8uJo+MokBcQGFTllc8ID/NvJwh7Jqrc+6+9uQfdL/mnFrBu?=
 =?us-ascii?Q?11fZSwP/kbA7O86TdZ2XFc/6lWbJzQAPhvynPXA4hS7XXqo4izw704BIMLcb?=
 =?us-ascii?Q?ItCZIEVoWWcixaXUJUhqu1by2aI2ytxH8UnQfMdYgjw33kpZdhZBI8SCVIuG?=
 =?us-ascii?Q?u0Z1zSRpZ/Fao+K/ZwNuKc5xpcsWSb9+U83lU1sCFuZ47ktpHikbM15Yk0zV?=
 =?us-ascii?Q?G+HMK0BVM/r/+QzQbQPKhRUVo5Fy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lmyOkFcEE9PrXtPgUP1nBoTrXZmFkpuadfejOiFWfdBTckidHzALzE0r8lAI?=
 =?us-ascii?Q?5/fI3IpB04cs59ewGRN1+RMTNsgXptdY5zdiuS9LKsxTPlSV80XWqeSPx5Rn?=
 =?us-ascii?Q?uI9/tEtAj33e9TMx8tZnqbawY8pU6Ewd+jli+3cI0LQNLJrx4zkNCJfnUcX3?=
 =?us-ascii?Q?jYDMdXLQVxpGKZBfd/QYSu56qAomJy3ckW4S2ellqmxWHJ+ytUDqpQnY69OK?=
 =?us-ascii?Q?aMVFDUgn9I/XN1a2UM3OL55TOt+E8bKB1DvdPq64v5YM/ly5pHMhp5OeTBMT?=
 =?us-ascii?Q?iqgFn4vdAfx4Zrg5hRDhHh0l4uk8owI5i/XSYE/Y/cJwCMMPRGlwn825vY1P?=
 =?us-ascii?Q?ILSd/6sqd+JfQKAOu7gzLGMootro+otltGENTVKf54A2ZORaInrXGy2cZTP5?=
 =?us-ascii?Q?HnEwfjXyCgMoIsUVVz3qv9RM8bOb5SEeqZaLrCX+y2Ql7VY3TtdU5hXEpScv?=
 =?us-ascii?Q?QqREOs78Sv/cvyjnXkD++EjLi3UQVDP02gucEqOSkV1Mm/tzH2Vod4vfykHP?=
 =?us-ascii?Q?6lP5XUExx3LGO0uZyGrTmIiCVK29oyh4w4Yxdx0H6oOVajx041/9jmmhE+FT?=
 =?us-ascii?Q?qq7/l/BnMF3XIvg9MkZbms5SRM0xggRTtSIsNoIiWslkRT0Z4X3/Xi2M97Lu?=
 =?us-ascii?Q?MO4WiOGsUizMe9a0wBErDmFjGxM16KuCdOlvL9WCrHSenMknl2sA4UbFJd8Z?=
 =?us-ascii?Q?ja4uHjqD0mnpEzgtv03jce+F1lFANmCjzS/oyZ09HoSWik0kHjV26egOCOkK?=
 =?us-ascii?Q?Y8drBomnTiqupIcXQLTE4X+ZM8f99i0Q8fHjcu4ok+nDn+tg/OpaglFBOn9C?=
 =?us-ascii?Q?fjvUxdUHEQSEkpood3Y8keVtOrTW4cJ1XeEGxN3fU4aNbMnjANviF/DWK5HO?=
 =?us-ascii?Q?IrPhvs+7vRdR2SvvcuS2Rriib0RkZ2D4Jkz9Upxry3wI1gOLf/Zh92Qkb04B?=
 =?us-ascii?Q?tPYfY1TOE5EzzW+wWdA2diFA0OfGH7TKdSYQaU/NQZG6FvV7xYj4pXQrRS3e?=
 =?us-ascii?Q?1M0UNFGkSQPKG20VAjHyGYANHLyYuboz5ecV/ermWkbqQfPReoq+5AyRe1l5?=
 =?us-ascii?Q?OsA2LpgsBHhYUcqj1/YS2G9/NqZH+77izbVQFnL0jqtn/fgNY/GlSBOxvEyq?=
 =?us-ascii?Q?WO6TrAnqbr87r5u1btpO7mkDmMTit++K/WJ6e6+vp6peGR5z4Jk69BaYO8E1?=
 =?us-ascii?Q?splo2uCNVdOvF4NvQlYoneQrPxyRmPK2hnyNjG5iXSaFjJiuYsBfsjE0UbQr?=
 =?us-ascii?Q?qfsEVa5ASicFYygyf5ph0+gdkZ6qW9ieLb7trs5hYuPNHfXa8/ZZPxZZ8Lhl?=
 =?us-ascii?Q?9RmgoxX2ATNCrcsxhm6+I0fqEnlEELVgY5iYEeIjFZP7OgN+AVHMKxzK5+YM?=
 =?us-ascii?Q?Sd+OsTPf+bO9Fc5cH7dmmy6sUcOS9Cz5imkpyAl0GB8Jf58bBRVutZsSObH3?=
 =?us-ascii?Q?REs0KxFhl7LOUbdRjRoi9IwgwHXcEIoC+BDmJi/T0MU+v8JtxcWjqev6YEaA?=
 =?us-ascii?Q?KxdhmZ6r6LumGzzUAxbQkjPFr9xMF0R1pDhugsCiKkSBMZRsgJuvL1mrdjIg?=
 =?us-ascii?Q?bnmjeQsfeFOGQtfbk2CObiBl1HfH65yNzH76xTuA40ErH+6zIQrEALaf+Ldj?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a31158-f78e-44de-3e7e-08dd359a6e6f
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 19:25:55.2056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T81jkbmk+NMi+EusAapmLzXTkJhzHTzD/BgWXOZFMgoAptEzlOCPC0DtUJj/BWBd5dNTrfhh28dzwUhG7d19rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO3P265MB1849

On Sun, 12 Jan 2025 15:39:51 +0100
Miguel Ojeda <ojeda@kernel.org> wrote:

> Starting with Rust 1.85.0 (currently in beta, to be released 2025-02-20),
> under some kernel configurations with `CONFIG_RUST_DEBUG_ASSERTIONS=y`,
> one may trigger a new `objtool` warning:
> 
>     rust/kernel.o: warning: objtool: _R...securityNtB2_11SecurityCtx8as_bytes()
>     falls through to next function _R...core3ops4drop4Drop4drop()
> 
> due to a call to the `noreturn` symbol:
> 
>     core::panicking::assert_failed::<usize, usize>
> 
> Thus add it to the list so that `objtool` knows it is actually `noreturn`.
> Do so matching with `strstr` since it is a generic.
> 
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
> 
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y only (Rust is pinned in older LTSs).
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  tools/objtool/check.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 76060da755b5..e7ec29dfdff2 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -218,6 +218,7 @@ static bool is_rust_noreturn(const struct symbol *func)
>  	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")			||
>  	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
>  	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
> +	       strstr(func->name, "_4core9panicking13assert_failed")					||
>  	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||
>  	       (strstr(func->name, "_4core5slice5index24slice_") &&
>  		str_ends_with(func->name, "_fail"));
> 
> base-commit: 9d89551994a430b50c4fffcb1e617a057fa76e20

