Received: from GBR01-LO4-obe.outbound.protection.outlook.com (mail-lo4gbr01on2108.outbound.protection.outlook.com [40.107.122.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86912613D
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 19:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.122.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721850073; cv=fail; b=W5MWdfq1pnAu1hYy5eA2AssUlbwogDqk4m9JyjrsofkCb3aSpMHbCzbQg6/dGLZrF5b7FtInHgOP5T+zQrnCfB7WYNKJVAYejAu107PXxVsdGs7+ST7AxJpKdyBOaDJqAd80crQjaG2JyThq0qt1hOTd5Y1xJ+8eP1bpxL9MvIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721850073; c=relaxed/simple;
	bh=jatk2gPTzsYtsKo3LlTEVVRHAY6ekA18SuMjQg1niFs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jL6xE0ZYhg6iD2H6oMxip+u14MWsUIlEZSCdqC+zw1m1WMozMMRCdGPze2q20WvfO8QJeRXAZIc0iq1ZqYQ97ajAfX9+bya4CLVX3aaeLwUEgmB9at6+15FC9crMaxUYnVQi/RU2HHIhsx8KCpJd4YdSDCNMJ8EUCvxilOGZwYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=BTP7BTnp; arc=fail smtp.client-ip=40.107.122.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="BTP7BTnp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dcmXihvqy5ZbzFrrFjQqhnuNhnZrRblF3PDmXuKXrJMag5ea3qLAD9SH9AQ2vnotxXZdR2Tg8EavfLbxIncP7xLRU11wEeB+X231jvK3QyNA0oaxVHbEoSxdAFF1itnYwjaV8j1Igs7rlLlk2X/iZebxHgBbHIs6SLnEVaFQ0mOt4bod23QC6WMxiJE/O+agrJ0giakazQ2ByOkP6t5blqN0HRkNp6FDsvjIFqr/eGH6HnnKKdseGkNZOnofLjDnmr3IkcLX01MhJkmDRQeHY0A4u7jZH4suCb719UvXXCet/bel3ZIcnjkw1J6JeuH0takJ6/VHK1vtwqNoU91baw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skxDchtmHhou/3/9gCCPW239wMsuFcuW1lQIqcV93u0=;
 b=f4znirh4INLvyT6UqyWsQtuJhN2m8Sv/TpqF6guI2m36jJUI+HqOhx6f0l3oW0NNUlscVb6LJarG//3dX6NWkqxhJeB6XDN6C33tJ/gbhXTANdmwX5qXF08RkRsnbw0Xk3v9VC1SmvroSfFrF1646t+copKNPMkpsenRcHmgsfhcRsHTlrxL43qLXg9mUlaiL8wfF17HFF502iFsisfWIBJv93mXrwmj+II1d8qvCbQlb6TAFNMsqL1lDxU7+mVLNdkJD465plJlwlpaX/1zwj4Jpg5qx+C2L3X1QLrYvr/yjWNeiY3RI81IsNYUtXM0Wjkbjeq9QCh93l0aPiWeRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skxDchtmHhou/3/9gCCPW239wMsuFcuW1lQIqcV93u0=;
 b=BTP7BTnpRwCx1QlmUthSZADuTcyfdGwux+1/5l1gJ0Yy/mrtUlkuhh8we1j53VLilEUO43z/aIwD7PjlHYz87EbqTn9IyLx7sQVczCgtqzJiUB32ByGe730Nb2MtpZ22Wid/1fD41PnvBn6pUeWTIO0I8Up74T5ogSGQP6zg5dI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO6P265MB7336.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:320::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 19:40:57 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%6]) with mapi id 15.20.7784.017; Wed, 24 Jul 2024
 19:40:57 +0000
Date: Wed, 24 Jul 2024 20:40:55 +0100
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
Subject: Re: [PATCH v2 3/6] x86/rust: support MITIGATION_RETHUNK
Message-ID: <20240724204055.3250c1cc.gary@garyguo.net>
In-Reply-To: <20240724161501.1319115-4-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
	<20240724161501.1319115-4-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0246.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::9) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO6P265MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: ab668dfe-0807-452e-d473-08dcac1889ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yzxe/0gl3X4IhFdIf8R7M73RRLvBcPM5QQLoO363x6yVOMz0LI/H29+lm3r9?=
 =?us-ascii?Q?0naavyxLLoyjRhu0p7rCGlJjvrpGgo834Me34p05nOy1RkM+GZ74CU0y82Xi?=
 =?us-ascii?Q?XeS6g0DgbimqdlxQG5YQn9OZlZNtwbzGRhQBFyaMzlGlAsEmP4/cCC0t0KL5?=
 =?us-ascii?Q?Y2D9Vmx3vuutXAZZuiRUoWqPf34dY3hN8PeDH73aY2S8hlBAQmT8ufOAD7Q7?=
 =?us-ascii?Q?l72lmHAVO7wkodf2Do5WqKMA/PR69L+8YZSKRditJ8Md7Qi3F8tE9Fh5o14R?=
 =?us-ascii?Q?r57vv8NCBCLcDFtbtFV5kJfreqbAf9GoQB1547xRK4788Etqu9NpextESxVk?=
 =?us-ascii?Q?oei8BhN/FXUpgNxLe+PXvFjTglcDzYMtt5j48fDJ4mKg6L95ivd4FImbpU9c?=
 =?us-ascii?Q?tIbEFwPBA6IDQgeYY+zWTwNer1YuPAyVVQmUby9OIV47GYOQy/S8fmxd0RgP?=
 =?us-ascii?Q?ySqTFMxfkMLk1ebIcWRzioYK6qIih4kY5OYnVXuuuKeQ1XYeY3f9icVuRM9x?=
 =?us-ascii?Q?aUxUYX/o6ZEfrq8fSPeqj6mWfEzjx0MD9LScarF4BJgJNdgk2I57gPNyAS3X?=
 =?us-ascii?Q?hfYnGGvddzcoeZBKuogGIO2b1zS2UyfyIBqnUUP7f7+O3OWN4epSOqMTrYTZ?=
 =?us-ascii?Q?VlTJE+y96VitFVR4Hj4fJVu1SfW4Y5TAPQOcztj0vZ2ao7hs5krQjdFakITK?=
 =?us-ascii?Q?GSBCuAqln//+Ib52LrVNhWA4+LiIo0J/d7Z0EhqWD45PxH/ShxMa5UCz1NQl?=
 =?us-ascii?Q?L3TRbN0wfgepi00WYQRaIgnDr2eWdK0SNcpXXQc0fcx1XfBDFgPK14AjVNcZ?=
 =?us-ascii?Q?ifo0a42oWunUfSa36zxv0ajLMFDm7JnuLCyyNT27YBRdKW+3X4A6dTX1sCqj?=
 =?us-ascii?Q?dat6ibNpL4Ex/GlVax/StY7sFzFfj1d3gCbBu/71QLDEgFQ5P9UlVQ78hnGI?=
 =?us-ascii?Q?c+lgfXCEIchhKcBbsAnFTg6shnHGsLQM/BTFscliD5m4AcXE9Xz0A87DpDSF?=
 =?us-ascii?Q?RddcoHV0EMhaHnzdSAzOXg+HvHtOpAekE/s9GoJvMxr0Bj39Vz5ntwOZuA28?=
 =?us-ascii?Q?bi8zkP8X3R8/n273WIUTCSoDYVCyvr+xcPMH/J36Ka4ZAPxvoQ5RqtewpNTl?=
 =?us-ascii?Q?q5K4WvYWlDx3TkuPuZO8QeHcUyMHOwsNCGT/3VVBkX/SP169SeZ2v7daaO3f?=
 =?us-ascii?Q?NniRdT++nh4qaggSDQW00AGEhdGLi8KlUW/Z09rV23H08SAORFOpA5BWmDMB?=
 =?us-ascii?Q?YYoCcTSWFg51ZvLmYavXxNWGlBTStZ+sLbTE6SlQjoHsH6sJ8hCK+EL9Nm5k?=
 =?us-ascii?Q?pyo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yz6UGB7yBUqK3PmarRjxe5TAdaN1ZFYUUlWYovzkCVFG5UltB9t/wVDUc+Ok?=
 =?us-ascii?Q?ATBnK96QeNMO8NWbqxe8o467N0a4GP/kHELS5c0DEvB3ZcJzljZdqRpN44I3?=
 =?us-ascii?Q?UVrXoStDmI/qNExg+8giM+JD9f4aIkuvYolaGamEJ3nvw530u/7xmhoNAEXO?=
 =?us-ascii?Q?nO8PB5zBXfMngpXHefTYZAQBARYP3epD+/v6/saG54F8hTuQP7dID9OxRqGP?=
 =?us-ascii?Q?DAUtJKOwp+glT1/1eN4mf+u4vQfbNU9jNz+/g7Wlm7qgVFPh9E9NCcxGggmJ?=
 =?us-ascii?Q?M0rSbOsUK0p+2x4CQE7KLhk99Y2rgQN7/YMfT2AtTnZHCDxBCTc6tFDpemJl?=
 =?us-ascii?Q?y1f2We2asrfJvjF6CNlZiL3YPhAJKqajip/crRErhoerlG+XoWQc8QR0l09y?=
 =?us-ascii?Q?6K8lR8aylbsYU2gfVjSFD0ZQFdD5k7kDlQKiSZTy/fQNpIVZrYqc5+mt1dBQ?=
 =?us-ascii?Q?4sUXYXsvpkgwGbv3tRC1aYKfF0FMd/pRf/9RQCDGCDqLqAs8cqp0GhehLV5b?=
 =?us-ascii?Q?Zyh1Fyoc15/QMsbI4s102k23zJckQwmTcC4tUl0fUvWl12y08dVkFOPclHlD?=
 =?us-ascii?Q?H7V+4N7i+aC+dLHFNSEB6vpaeEqpItNAHDgI1eKnDe3DZsx4dM+NITS62Wng?=
 =?us-ascii?Q?pQ/xMv687SdrW2FWA8fLSkd9a6Zuk+ZvqDSokh4fsC6+jOElZCK4NwvPgR8d?=
 =?us-ascii?Q?TnfEez4+5y2AA9qPJlpIIeEwvHbXecN+9baE2AcKG32l0Z3FZiX2/AIIpDAY?=
 =?us-ascii?Q?JSB7Vqnr/7RYaqs8gZccfIyrtcREgTvrpK8W0CiGEh+ORWgU9JsMWFAcOnib?=
 =?us-ascii?Q?L4/ChpCOxdNm6NrA06W0SZ1iEOV2iexGDAvzodjbCO30ecSPBx66gk+1Jbx+?=
 =?us-ascii?Q?XCan9Dq4EeYWNBCzMWmv4cdwpClN3JRtZoYc3NFjMq0Xd8EfBIOKY+/iWCTF?=
 =?us-ascii?Q?Jz9sjjnaaL3C33zY2DXHKy1t6WeJ7xMa2/P/P+byEcZ4kTbBD3ZTgsaUqpza?=
 =?us-ascii?Q?REKJXy6BtEK4LFxHqqjS6dQuUFzs3us8SomMFNc2ljpTSCHjDJRRxSvpvuvV?=
 =?us-ascii?Q?WjpxHoJgAWET8Go5TWp5Jl7mutUgiBjsHaiVl8wHu4SsmUyj/lZ4eGoJL9ga?=
 =?us-ascii?Q?VQwcwx7B7e6vBOI7xKNBwikR7RSCtDCvROvm76+bA42llCeRISsMlNnndM2M?=
 =?us-ascii?Q?/O0SM3H0W7JKITLbM21YuZiGqgjGY1osMLGHqUyQCtKXiphRn/R7kxmKzwfw?=
 =?us-ascii?Q?s6Am4BEjSxFVJfmaI/ZVsaXKXmuGulyZjBKu64+jIBdsx3gDr9BQph0EvfCB?=
 =?us-ascii?Q?TOQYP++087Sr6jfXIgwwdqvtc7mhPLs1TgfqinfMJTthmVW4FJPc0+R/8zLt?=
 =?us-ascii?Q?VrOehPY55Dm9xCJpWP1ea55QtSuxw5rT1pf7eV0TwnYdEcjnxAiVhNJqEVxh?=
 =?us-ascii?Q?3LFHxGRQ5IvTwxi5DRvd5JnPSoYLonazCs1goGAdnzo+QdN1OslbwQ1f8S8N?=
 =?us-ascii?Q?C7uBYkLjNp1VINVF9eldSH2y7vR2dRlqLbxvLYOeUMpYbkl6m26KteS6uCxd?=
 =?us-ascii?Q?0a42Phz3/HujQPI7WnOZJXyaNnnCoVbrcSUBt+8+?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: ab668dfe-0807-452e-d473-08dcac1889ae
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 19:40:57.0232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZCsYLQNLk4i0DQqXogQUcEEY6CVKii2zcqXmovZuvmd63OLczK8TKOk0LQmDUuSMU6wYnBsqnvQ3KBKL0xCFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB7336

On Wed, 24 Jul 2024 18:14:56 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> The Rust compiler added support for `-Zfunction-return=thunk-extern` [1]
> in 1.76.0 [2], i.e. the equivalent of `-mfunction-return=thunk-extern`.
> Thus add support for `MITIGATION_RETHUNK`.
> 
> Without this, `objtool` would warn if enabled for Rust and already warns
> under IBT builds, e.g.:
> 
>     samples/rust/rust_print.o: warning: objtool:
>     _R...init+0xa5c: 'naked' return found in RETHUNK build
> 
> Link: https://github.com/rust-lang/rust/issues/116853 [1]
> Link: https://github.com/rust-lang/rust/pull/116892 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  arch/x86/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index e8214bff1aeb..a1883a30a5d8 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -24,11 +24,15 @@ RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
>  
>  ifdef CONFIG_MITIGATION_RETHUNK
>  RETHUNK_CFLAGS		:= -mfunction-return=thunk-extern
> +RETHUNK_RUSTFLAGS	:= -Zfunction-return=thunk-extern
>  RETPOLINE_CFLAGS	+= $(RETHUNK_CFLAGS)
> +RETPOLINE_RUSTFLAGS	+= $(RETHUNK_RUSTFLAGS)
>  endif
>  
>  export RETHUNK_CFLAGS
> +export RETHUNK_RUSTFLAGS
>  export RETPOLINE_CFLAGS
> +export RETPOLINE_RUSTFLAGS
>  export RETPOLINE_VDSO_CFLAGS
>  
>  # For gcc stack alignment is specified with -mpreferred-stack-boundary,
> @@ -218,6 +222,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
>  # Avoid indirect branches in kernel to deal with Spectre
>  ifdef CONFIG_MITIGATION_RETPOLINE
>    KBUILD_CFLAGS += $(RETPOLINE_CFLAGS)
> +  KBUILD_RUSTFLAGS += $(RETPOLINE_RUSTFLAGS)
>    # Additionally, avoid generating expensive indirect jumps which
>    # are subject to retpolines for small number of switch cases.
>    # LLVM turns off jump table generation by default when under

