Received: from GBR01-CWX-obe.outbound.protection.outlook.com (mail-cwxgbr01on2118.outbound.protection.outlook.com [40.107.121.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1038715F3EF
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 19:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.121.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849760; cv=fail; b=Vh7iWyZiPKrAw2fFzB7TMgVtPdKM3lGhIbBLyUu63xxXF2EsxJWo2/EP1fHkp5S3wZXZk8GWAwco5OZFb46PVZUtCG3UyMQdRxdnczUvyT203Fb4H/FdJD/+3bRqYr2DUKPR7xL59N73OdI3wPEuxT5NHbVrlGT2JulHrlKEc9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849760; c=relaxed/simple;
	bh=z+1rttXzlBaOjDt1ZQdu8p8FJaXOVGfRCdYFg75YuR4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P+AQ1WeTivKQNyOGtYtfCz76UgbqUAxu9D+yGkaXDTnpethFeSVoh0pKER1lKkn9u4JhlSiIjVXcB6qEDdMuhf7/aQWGAZwcBut6fNkdjKXVzUSgozm7HpoQMcACQGwRST+eVWP+E+KMeprQX0K1aTQ6KVAWcetnw5gCIbBSHMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=t3Cdozav; arc=fail smtp.client-ip=40.107.121.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="t3Cdozav"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BBZgErFM0ldNPAXt4E7xpqalsZRSJ9A23jaNizP/jC+Kzt4QUv9RbW8m0fCqoaMdW47snNmXZUfYeLjda42HwUK0csoO2j6JXPfbXNzHt08aLhEI27uDRieVhY43BLqCvbtZDVlFAwjGA3jZ7Fqo9Kv9berGEbQM7ucVWkg7Z0X+EKeF2ESLKM+7zGxY2cvaPI+peE9tUcUuKaRady5kkpFCvkkluMkI0/5K/EvYMjFYHV2m3HhdkWgJPp9SY45NJsN/R14MSHUGMssiINbU7aaZIvaGP3CBbHYs5cxZUVsewm7xvE0ATzzK0gkn57peB9NJIFYjx9WPlOla7Lll8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB7LqkkQL4Zb7VeKY6z8XG4D9QvfRERbPwdNeAFvAjQ=;
 b=gqbOneD4VAzMyeltFPpYTwhzTMgHrsPIR5WdZ5hdFlddd2MnZXcmJgNw+7FhYn6yG3e7z6Tk5T+DJu+/GE4qPNxt/xE6uEN8MXXD7x6+H3LeuVNT7L8m5ZDJiYICx9aldZZZytoGRY8zByc9vAIbfyFfShY5mSPH99GPniJwViCcvbc9/BP2c8tigUUUThwpzvgLhUvnpK/JUAxuIeygBntCL0q9m/beffMTtmZ8zyhVu9IcYUZLevyzQxMigId/Mx1fLM6PNeig2yOyc8wxxn7mEO9df6DugDDDPMZ3J1pn1UQtgO8whWpoVc2Ibkaza+GaeisFIsUPXrdffWJvjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB7LqkkQL4Zb7VeKY6z8XG4D9QvfRERbPwdNeAFvAjQ=;
 b=t3CdozaviXkCKAWjBh5Fo3lqn25XWa5qxd9rPLDnpfw0demZ9mal+fsdLnVowkHhczocbxb8gKTgc11euNkFL8k9WG1XMzvf/RnPtHHZ4qpkPrYLgmDiniKC+XyRKExRtAsL3eUaEKqfLPlgELc+usLm+I7wROOixRfLQoeN7bs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by CWLP265MB2993.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28; Wed, 24 Jul
 2024 19:35:55 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%6]) with mapi id 15.20.7784.017; Wed, 24 Jul 2024
 19:35:54 +0000
Date: Wed, 24 Jul 2024 20:35:49 +0100
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
Subject: Re: [PATCH v2 5/6] objtool: list `noreturn` Rust functions
Message-ID: <20240724203549.2db3e36f.gary@garyguo.net>
In-Reply-To: <20240724161501.1319115-6-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
	<20240724161501.1319115-6-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0305.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::29) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|CWLP265MB2993:EE_
X-MS-Office365-Filtering-Correlation-Id: d44eafe0-f676-4a25-2d43-08dcac17d596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Feb8xVI3djNoYeyLuBS9q7BCkQ4Oh+vd059rvJUiHyF0O2ppD008WS73IvfG?=
 =?us-ascii?Q?jfZbW7V7C+zuBFkXNgvhhhdsfr4BkBY5BNg6PGf9/sKiI7hh9io/mRNCrJr8?=
 =?us-ascii?Q?2GTLcq+kk6Nl2BTB4vpeJ/PKW+T5VwUix4NfExKuMRxwBVZNGMHXqHZ2dTvu?=
 =?us-ascii?Q?/TNdWljdyCYihi6Ct4UM6MzEv+ixOEofWt6Gbv5NFb3eSKdJ8/fayE758Ulb?=
 =?us-ascii?Q?Z3OlF7uyNUVl/ESSQuspfxns9PORIP5cCUXPR1XQpVrlSGTUw5AjSmxZSa8y?=
 =?us-ascii?Q?5pACYaFCC+2RRULUB3PLPZRkl/Ps6u2hq8kw6pkcH8eSTsig+CZu5J5lx/CO?=
 =?us-ascii?Q?WaYJjs63TrIslOs76UW7D/h6vbsyL1EU4tC0jgyEVOLE+y4c1miEvd4iKotX?=
 =?us-ascii?Q?SqaFwY7dFQLpk2b1144f0I5RQQt8gfyDKyzYuWFxtmoc6ha36dLB8lb0g6Rn?=
 =?us-ascii?Q?wsGdthtTqmtifyqKcdbDjtwLTqayNzKmf/x7/O0yETTpp8tKX0QkH+R9EqIH?=
 =?us-ascii?Q?tSmftWoNEhyooT4t51JYOcgBofcWtX79kVdqL7OXvbgyWKo9GOi2rK+pLZvi?=
 =?us-ascii?Q?ECl1UJBVuPhyl6NnSYe8qEBog784bCQwcbHzOWjHfjFiUf1RU3q/nnoXCYKR?=
 =?us-ascii?Q?Iua03u6xofp71+lVjs/lqW+lVLOYjwErcYtOGUYSM+X35zLlVDKHeusfgCMN?=
 =?us-ascii?Q?1vUiT50Mf777RCRuLahEVMYGhZFGHDL5EJPDOL+3/ZZEZV/WQnxf/SapmoEM?=
 =?us-ascii?Q?fOeudxLaL07Xohw1WmLfAeh4G3ZOsgyiMwqlXUH+mxkaorfizbcKIwxn/lrb?=
 =?us-ascii?Q?A/JsLC9MtFMAwulXElbaT2rcmhroxxhVAMGx95QX2/+ISL2WvRfyCLE1LpqB?=
 =?us-ascii?Q?9wxt/i1zreME6G1QHXhk5qdH769pkTTwuIGjsR9cgbMJUthfhGWIMuRNWDxs?=
 =?us-ascii?Q?Xq+Rkd9FcgxJU1dDwbmjHwzCl8JRyvvPV3GRd+wwBd/H1p72rYSygVfiySgY?=
 =?us-ascii?Q?saw+R0EF9rTyQu4U0FLWHOxFPAkrP+Okg7OhIztrzKNJBEwL03z+YYfLkDC9?=
 =?us-ascii?Q?mcrDw1hImQc0Gvg3c0tmOz+vi6xeYvkqRcn4OHrQCKHTzSQtG5DrsimX/zBL?=
 =?us-ascii?Q?BlC8WkP9qcjbW2DBCeV7Rti7xOg0DLx1+xekDUaxD5rMsyy9RoJAdHXaDR8V?=
 =?us-ascii?Q?t0utgXmoze3x37Qwz0JbPz/rR/sHWF08X8LkantV/whzCqq6O9FDgNIDADi8?=
 =?us-ascii?Q?6RjnMlVZvsOWGxLOVFXK4u47v4owuARlwUuiaDf8ThUqL5CFFNXJk78dUl8Z?=
 =?us-ascii?Q?Rvk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J3JoBbC4oW7WEByh9sef/e7sNvdeIsOvD2juqDm5W0B2ezyTjcVLb7ZbfS0i?=
 =?us-ascii?Q?9N2gq0+KH6u35w9YUK5N/LXkkNQAu/Ius2y66HZkdJ6rHx8lqqhHxYwdkhl4?=
 =?us-ascii?Q?FWLQ/ceMz/EP/ky+yck0JEertdCW4ZhzrWtjM8B0an9x50MAS/Dw6odICzMd?=
 =?us-ascii?Q?qCzCEZYx1WFfqw8FbzuwlQ4WCxu7IBzrfEGlKnzVV+fv8ZSkEZm0k8d66jgt?=
 =?us-ascii?Q?FRRyWyTwU7q86Jg20vlCboF7ORxwdRZQv5Z2EBa4VPDYvSZKKQvZxTuxwrLl?=
 =?us-ascii?Q?tZOJvTl1xO/vp/2JY7KnxYpR3xTa2xXoGDHsMMIZxB4IF50ZAGUWrIeZ0Bcq?=
 =?us-ascii?Q?UUCvFv0PDt4dLChz+yc/jkrAlgl/7s+dYxM6yshKKjLjGwtiH8vV4RoAOot7?=
 =?us-ascii?Q?FtqgjZf+YzXvYcHFSjui+ZbnpWODfEjDu56NllPfOscpymGzVwYSPubnHstN?=
 =?us-ascii?Q?IGDAH36bNJKWOPUCpfUT8BF3uMtUkkyjvR7+GjDJcljcruBh6PXn7ytxEp4v?=
 =?us-ascii?Q?dGdxeAoOv5TiipTJw2obSWF9nJnTPwdOj5f+/43DRjFjiIlnGYfW9zKD6HgF?=
 =?us-ascii?Q?cqwB/pdJHOIwy4pAONgwPML8KCL/503k8CdIjQ1QnclT5T90HYfQG+4QCyPl?=
 =?us-ascii?Q?RNUgBPSmoIZW7MD6H9Cg/ABcyRKur15LquDiaIece9vEzkeLw1mjZ0RHzWBI?=
 =?us-ascii?Q?UY5BhIPRxfMNQJZwfOcVJLHMK9ZkElpy+uy93BzZi9YlG+TU0LOHAFKFj8rn?=
 =?us-ascii?Q?TuW2cruCnoQUPGSb12ZFHY18GdsiV00Y5Fc/RaK9+sgPPcyZnGRDJubag3pM?=
 =?us-ascii?Q?8Ewd58Hr6ggNYSByvhSJoYF4R4OlF9yDnlJrPlcwK1uBf2unVbaKUN6UyrcJ?=
 =?us-ascii?Q?lQhM4iDhvkpyzmz6bbMS29x6/3a0Uf6xKY6FKCfUBiwM4IQSSuHfB0D/aJf7?=
 =?us-ascii?Q?SQGuGV7Ng1DO7SmUnxH0RB+SzIUh1tkycZ21gSrfyqpVGu+1EI9IpiwYlWuL?=
 =?us-ascii?Q?CSalEMkVenMnD52CjweYJdWrVtDhZR/InvD/yIs6cekYXkVhDqICP9y1ygUc?=
 =?us-ascii?Q?t0KQXbSXuNGscN+6OOTEHMeeNmpWcvuf58oPY5C/NTR1ml+Jkit7e7C+SfFU?=
 =?us-ascii?Q?7VqPgHUIWwig7NHPrCZhA3Y0IN0vcFSFzWdtSfdzFy0ATORHpeb8tTlFeI3r?=
 =?us-ascii?Q?RS35cXwvZnIfaVVayIrmG97yaF3rWDxkg6836Mb5GpIfBIO88BIxi6VCs8q2?=
 =?us-ascii?Q?LaEutJNstb68mgszzlll3qP8FwFCBSdgdwtRAkCH6JUN2knjChSc5P0R6Z77?=
 =?us-ascii?Q?NKrAWg9A8jNUEAPqlspLcnACMe1RFkwTV4gPpEgsUuNqsFzBj15U/PurBzel?=
 =?us-ascii?Q?z/IJnnLb/joYfYVE985M7+pJim+XwnepCLsv88TlGCjECnIbei6pfLRQqjjE?=
 =?us-ascii?Q?4YQ885K/dDnXUIwNncy2s4lC5SfCQCqAPtLSsHkPgKXuFi+nbXYgAvuhzB5Y?=
 =?us-ascii?Q?v60t2z+9+1wa1mfegIXEgzhmWB1PRDc+X3GOwBijBNlK4DaGVAGZnVDjjd22?=
 =?us-ascii?Q?blT4fXb2EtC8ExkjMSmSy9SUcedZqgB7Hro5ziHh?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: d44eafe0-f676-4a25-2d43-08dcac17d596
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 19:35:54.8735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9sYT91z/k+MQMecoqazy/aqsDIDCD+UrZWDoO+rhU1Iv3p80eecEpsCTKTBovDwSQnYqpzJ/wdpKE/DwAI+cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2993

On Wed, 24 Jul 2024 18:14:58 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> Rust functions may be `noreturn` (i.e. diverging) by returning the
> "never" type, `!`, e.g.
> 
>     fn f() -> ! {
>         loop {}
>     }
> 
> Thus list the known `noreturn` functions to avoid such warnings.
> 
> Without this, `objtool` would complain if enabled for Rust, e.g.:
> 
>     rust/core.o: warning: objtool:
>     _R...9panic_fmt() falls through to next function _R...18panic_nounwind_fmt()
> 
>     rust/alloc.o: warning: objtool:
>     .text: unexpected end of section
> 
> In order to do so, we cannot match symbols' names exactly, for two
> reasons:
> 
>   - Rust mangling scheme [1] contains disambiguators [2] which we
>     cannot predict (e.g. they may vary depending on the compiler version).
> 
>     One possibility to solve this would be to parse v0 and ignore/zero
>     those before comparison.
> 
>   - Some of the diverging functions come from `core` and `alloc`, i.e.
>     the Rust standard library, which may change with each compiler version
>     since they are implementation details (e.g. `panic_internals`).
> 
> Thus, to workaround both issues, only part of the symbols are matched,
> instead of using the `NORETURN` macro in `noreturns.h`.
> 
> Ideally, just like for the C side, we should have a better solution. For
> instance, the compiler could give us the list via something like:
> 
>     $ rustc --print noreturns ...
> 
> Link: https://rust-lang.github.io/rfcs/2603-rust-symbol-name-mangling-v0.html [1]
> Link: https://doc.rust-lang.org/rustc/symbol-mangling/v0.html#disambiguator [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Please let me know if there is a better solution -- what kind of solution was
> being thought about for C as mentioned in `noreturns.h`? Would it help for Rust?
> 
>  tools/objtool/check.c     | 36 +++++++++++++++++++++++++++++++++++-
>  tools/objtool/noreturns.h |  2 ++
>  2 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 0a33d9195b7a..0afdcee038fd 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -177,6 +177,20 @@ static bool is_sibling_call(struct instruction *insn)
>  	return (is_static_jump(insn) && insn_call_dest(insn));
>  }
> 
> +/*
> + * Checks if a string ends with another.
> + */
> +static bool str_ends_with(const char *s, const char *sub)
> +{
> +	const int slen = strlen(s);
> +	const int sublen = strlen(sub);
> +
> +	if (sublen > slen)
> +		return 0;
> +
> +	return !memcmp(s + slen - sublen, sub, sublen);
> +}
> +
>  /*
>   * This checks to see if the given function is a "noreturn" function.
>   *
> @@ -202,10 +216,30 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
>  	if (!func)
>  		return false;
> 
> -	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK)
> +	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK) {
> +		/*
> +		 * Rust standard library functions.
> +		 *
> +		 * These are just heuristics -- we do not control the precise symbol
> +		 * name, due to the crate disambiguators (which depend on the compiler)
> +		 * as well as changes to the source code itself between versions.
> +		 */
> +		if (!strncmp(func->name, "_R", 2) &&
> +		    (str_ends_with(func->name, "_4core6option13unwrap_failed")			||
> +		     str_ends_with(func->name, "_4core6result13unwrap_failed")			||
> +		     str_ends_with(func->name, "_4core9panicking5panic")			||
> +		     str_ends_with(func->name, "_4core9panicking9panic_fmt")			||
> +		     str_ends_with(func->name, "_4core9panicking14panic_explicit")		||
> +		     str_ends_with(func->name, "_4core9panicking18panic_bounds_check")		||
> +		     strstr(func->name, "_4core9panicking11panic_const24panic_const_")		||
> +		     (strstr(func->name, "_4core5slice5index24slice_") &&
> +		      str_ends_with(func->name, "_fail"))))
> +			return true;
> +

I wonder if we should use dwarf for this. There's DW_AT_noreturn which
tells us exactly what we want. This would also remove the need for the
hardcoded C symbol list. I do recognise that debug info is not required
for objtool though...

>  		for (i = 0; i < ARRAY_SIZE(global_noreturns); i++)
>  			if (!strcmp(func->name, global_noreturns[i]))
>  				return true;
> +	}
> 
>  	if (func->bind == STB_WEAK)
>  		return false;
> diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
> index 7ebf29c91184..82a001ac433b 100644
> --- a/tools/objtool/noreturns.h
> +++ b/tools/objtool/noreturns.h
> @@ -35,6 +35,8 @@ NORETURN(panic)
>  NORETURN(panic_smp_self_stop)
>  NORETURN(rest_init)
>  NORETURN(rewind_stack_and_make_dead)
> +NORETURN(rust_begin_unwind)
> +NORETURN(rust_helper_BUG)
>  NORETURN(sev_es_terminate)
>  NORETURN(snp_abort)
>  NORETURN(start_kernel)
> --
> 2.45.2

