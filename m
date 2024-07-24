Received: from GBR01-CWX-obe.outbound.protection.outlook.com (mail-cwxgbr01on2101.outbound.protection.outlook.com [40.107.121.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9870C15EFCD
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 19:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.121.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849891; cv=fail; b=SwQ+SNjajAxUpHZm4XvPZsL64UbW4u0F+CK58jtjNaU2DkMRJnnkQpAyaXLh6S642csUfBbf9rhaNd7KBZBKDe3MNy5UHMMDyyaibs6q3oEFLZ9obrEryrntDbPdi3o2AY9N++FhP9jduP+OA8dKka1zF9UIz8zum/dhMTM83PE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849891; c=relaxed/simple;
	bh=6YMhu5tS/aQvO6rjiGJU80M+eaD1LHhmj8cbfB12EoM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pix87Xqs6/oQn4sAmJrlmDbtVGR80UqKkdm3dknDZoZin5EIOOZeoYIlgkHZgrBtNBqiv7TVPzepXxEJzPKxTqZ/ngq72coPoGOlzCwOLAFa/VQmCifDysbleIEPcB5y+B/p2ekYgEHDGlhpISkNlW275vUzdqCSMkR/M0Sx/20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=t7/dazgc; arc=fail smtp.client-ip=40.107.121.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="t7/dazgc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FSt5G7hYp3UVUb4KzmGe8wsSI8F5VylBicGuQZlCeo0ArawEXsFML3HQkiUd9KMtVvx7JoCIzRuGR1I80qNv65hMv5R06WtPJg2QJOGE1rkZ0yF2ZM4KzE8ZmxG1SwWb7S61l7OvvETfNZouSoeAXRoqfgdN8c0gfqLTQkrn63az4ECfo0kLMDpLxqCw5ej89lxz4BGpBV/UHAEvDAHOnZZl2ablux3HE2hLKBZpq4/HOMWHKOAV2zjNj40DhZEQEeADNxSlmqGxClSxqPfwrOreCku4TVlb+DP6q6r+IsejUzmKZDzvx2piZvNeDkQ+tKc4ieyY30z6ycwjmOhVaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Er1Vt0yNhn3fbwePWeBnqnCADjPHwtKkB16aVfzGhPg=;
 b=Zrp1OahS4uEfF5+USHrjJCYP3L6955kMJ6hJuAUV0quVVdZ9/xECs0j4djJJnFvAETkuQwFyin/uWRcuSZP/dRTQYfPxq6T+/btAxIvcdVCTgHmwvX4Qc6fACmLBCzp9wv/3K/6788GBjEFRLHrRvX/KlrOfYIINZpFDjOMNPzVH62Y+XHlUKTgVQMYjcEuCXj8q+yoJHVyTXhRq67U+2GhGHbLCJXJanivO3XgmFyJ4LaxoKYUnGC7792dQqk1d4ev9+QAsFdqZRYFZfpG6k307t6MCSArUzoE6zi/ks3kGhW/BRWlbdHkYSIbRYlwI5GOnf/we5MYfaTQPby68YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Er1Vt0yNhn3fbwePWeBnqnCADjPHwtKkB16aVfzGhPg=;
 b=t7/dazgcyS8fCMzDWSyNtGluOCK0Zr7h2RtnJtqOSE4lSGdwIIzPkTOpomsZ4sK6g0jxQCtDMguxVFrLY1PnM8WHEjVDj7Lj18sMzQg/vqcwSAcvFsAHsFwhaz3tM2kc/Y8uAsti+lTOcJnKnAXuohbOV3Zq8FXwAPjDk2IfRf4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO6P265MB7336.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:320::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 19:38:06 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%6]) with mapi id 15.20.7784.017; Wed, 24 Jul 2024
 19:38:06 +0000
Date: Wed, 24 Jul 2024 20:38:04 +0100
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
 patches@lists.linux.dev, Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v2 2/6] x86/rust: support MITIGATION_RETPOLINE
Message-ID: <20240724203804.194290c1.gary@garyguo.net>
In-Reply-To: <20240724161501.1319115-3-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
	<20240724161501.1319115-3-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0286.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::34) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO6P265MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: 3167acc3-edd9-4d85-fccf-08dcac18240c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y0AcEwxshY67M9eEu0RRa/ObmFZ+Sehz79td5fSfcok8Vg41fw6mLaZ0p16p?=
 =?us-ascii?Q?a8UPDKR8GdziE0d9Vw2lzi/nQ5aASzQpxyGoqB7col/E9SASegWxNcQO7gFo?=
 =?us-ascii?Q?Ma0xvabcSzBH8smDpZ5KaUeetXLXKdhI8pTbE/3Jk27YDWKauRWoZ7Use4NB?=
 =?us-ascii?Q?b9lPAbIYKjjvA/7gekAnXq5S3TGfuQHUqJj2l2Ga0KvPrjGTxa2Q6qC+QWKt?=
 =?us-ascii?Q?KbMMS4AY9uELL0e75WcK0+ZmraPxe3LiPcmbVwQY1sAm4II10YA9vTtpaTqG?=
 =?us-ascii?Q?97VNM7yMUIQMJHzUepSxNg2EjXxf+XulTGQKCY2VrLAh+DxyjcYfXzXIRX09?=
 =?us-ascii?Q?kwwffOLMwJG8p9jKaH5iHLAim243+IlLVj1OR3M9pngA5/4HGxZAi+Y0AoAg?=
 =?us-ascii?Q?6cPJQ4fOnN7xTuCaOytJtb3ZcHAwK+aqcSxOCucJ5D8p6cVEfbonXFAiGVNr?=
 =?us-ascii?Q?dsF3SAkPez2Y3HXKMCRz+qJTPATbolk2q+FGSkdPMP0/DgSxQOwRIol0ux7b?=
 =?us-ascii?Q?mYoJLytqSU2DuoYvphYKmY/kF0Vhh095obvMhYRgYMVTZAzxH73ZszhE6TAK?=
 =?us-ascii?Q?NTRf5EsqKy++ZZNVl1GjdbQ1GuWzqRzq9NAALgcdw1Rao3bAw8viXd8pxppv?=
 =?us-ascii?Q?B3+L5TsTF8TKRSSnBqmOICrk9+8oK2of1a07PA8o2Y8PGJ3qommCHBLKoAaZ?=
 =?us-ascii?Q?McSxMQI64oQH51obxQ2A5TIH4yztXBvQvj1XE3X1U/Uc39UwlurKd7mBCv5j?=
 =?us-ascii?Q?St4Vi7BxO5LM4RBv3gc7CyqaEX8Fjv4rRFRzXyWqaYQrBJqj8JBY0l6irh9e?=
 =?us-ascii?Q?ReXGrS3dJmg2M/SoPDGgYvGyvJZzP1Du2cNsJovrPNUahkzbxUYqAJJxYWaU?=
 =?us-ascii?Q?YnCQe8lqsG1ji2Wlubr6SlxOX0SR/P/WgH4yG6lJARPhQxgFsllQnjYcZmiJ?=
 =?us-ascii?Q?vKyy8Ipq5UcByh36dTUwTcFY9zW7x7ah19Be0+5j+KKRmuwGrYV4w5716yEw?=
 =?us-ascii?Q?CBK47gteB23vZQwGt5mSH8LUMYyP1C7Skr5aNmJRBI/mC2oat+/qfiVZnJno?=
 =?us-ascii?Q?Gxuh1e+/WlDPfIWkty+IHWBqm9BS171FqXUYOQL703ze01lLlb4JSaeIKIL1?=
 =?us-ascii?Q?n0/qAx+lgDSqFMN6EGOnrcA5jwt3pzb7Gh1XPy3sExdK9T/FuvzFZt1lhpdJ?=
 =?us-ascii?Q?MkXV0o9/jRvOasmT1wiqbgY0/gVeCjqaptg9h5xeEqiSSWcUsG6aV0h5pTWh?=
 =?us-ascii?Q?cL4vgjoYit4itHxWgXszIK00GTuFaWnfQW/JAmvD10EIq6say2rCK4pUZbDl?=
 =?us-ascii?Q?rQs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bCoiPqDtEx9NpykhnOcqGPEH5PijofgJgPbMFnXPhsrtUs3jQw84CcVadpjt?=
 =?us-ascii?Q?kBTEjNvN8JSD4RXmdVdzUNVLsDMlo6+rpJgOwZ6BHAhkfmx8fp3zOB+CIyf1?=
 =?us-ascii?Q?QapowDizSmdE1evTb1+//pkp3Mn7bd5GWWIejHjX2K3YT6AXi12V703TWK3v?=
 =?us-ascii?Q?i9xNxUwCNiZrVsFpNSqMYIx8jQT1nLjX+gkpTsPe5G+BE9iDq7bHl56QQVmU?=
 =?us-ascii?Q?73JXb2AMVNdz8/xQUWvMXH1TEZgXqT2pfHCa0na39e/lu0yc1jifexNja9y4?=
 =?us-ascii?Q?aGjUCZLbuNu1mu/PW6nT0xu9XR96EqNIAD/Wjdf2cMuACmyI8SiPseJ+rPLl?=
 =?us-ascii?Q?LaL10F8tKnKnyoBGhtqpG1UgdpQlRhM9NSSuHWJd8nTVe16heJRwIDLnt9U1?=
 =?us-ascii?Q?3W1t0XhgvDLJS09kBc7EmrBOnMYs34EpazlIGtPRX1499zR6OGoRTB9+j9Ad?=
 =?us-ascii?Q?0lNxYfXaaxtPESR7wrxCjgaY7b8cePP1UpAusZoh2euK2WrPu+HHhumOrtAw?=
 =?us-ascii?Q?W+vKNsCElzVa66ksd0FqMO0ZC5zSW7LSZNGiKI6FuMCTI8KlNZC+Yoxaabq6?=
 =?us-ascii?Q?ovwsLwQm8KTHtIVg/CajZfWcn+2uPM/A0epRHIIBVLEMAd7rPmaM0Sjuo7k4?=
 =?us-ascii?Q?FI/+qKzw2/lfAYGooDmeAS/6j0qmH73KPiAY1bWpLnt4IPedREc0ML2OWL9t?=
 =?us-ascii?Q?4267uoqyMRsmzLydFtXG7iVHd3xtaKxDbWsHPynjGzpHUfzMs8K7BU+usbom?=
 =?us-ascii?Q?vBlT0I2Qbqcp8SGg8IJd/j05FWZICiaSccUwEG6L9Z5wU7+h9PeWP4Gw2U8N?=
 =?us-ascii?Q?Pg/qwrJxtGtLDl8qDi9rPLsY+qWGQo3yvt+QC74XQL0CMlVDX4M2ZwiVZFDs?=
 =?us-ascii?Q?w2yX37syCRgL3RqjmhlPSH2q/Qq57Anumvf1CQPpp9J6/hl3zVynB6xnvPlV?=
 =?us-ascii?Q?pa2Nsui/P2kov1nb12ShR7uQft6heZOpEm2i4bBGlVjhLaihxdGIcVFA7cYJ?=
 =?us-ascii?Q?SWeaiuBAc3z61/CoFDGU/iiYzpMyiorONKCfnzF6n8VVeUTHW6ZS7cCXgbvB?=
 =?us-ascii?Q?JxybDihLVIpAoLSxDuyzph9WH5RX1+shbRA+3OWNoLf2hgfyZaP+RddO/IlM?=
 =?us-ascii?Q?ucrROnbk6bNZPcK40jy6XRRgVTiYQ/MXRgINFP/ElDOHwiSEgiAv9HjlIu9H?=
 =?us-ascii?Q?2X9jetp9vzAqCVTj6v9TUl006mko58AKdGnoCJ8qzoSbpXbGt6cjhktc8twj?=
 =?us-ascii?Q?rPSNdB/8QekyH0SunbWFXLrhKKUcoPFtl/wlR6WbkbHbnbCbe9RlpncZp087?=
 =?us-ascii?Q?S5d0KgV9mj91I3ATaHGHAirVQb0x5iiCRMl/9rzVh4h1svHAJscajoAwcFyO?=
 =?us-ascii?Q?xxfQOWjevQZTh5xmoFxWCahZFF95TwAFebqILoFL52w1tMP3c/uR29zfFsPX?=
 =?us-ascii?Q?DDRkzCQaRIg5jpQwO0OT/PKTkmynCaFNYmrBPOJtNDyfJ0h6k8u+146aKHKR?=
 =?us-ascii?Q?4WKMhNaZyWaSD7l8anYlBoluhOMLHonu/RGbQ+oFyBoc4WtTKgcmasNk7Yvj?=
 =?us-ascii?Q?4YC4Wn2YWHsP62qNZHXXvAeXcuYZZl4o5EPHuLGwiXpZ2Aj187NCtwSShGzG?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 3167acc3-edd9-4d85-fccf-08dcac18240c
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 19:38:06.5197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uVoY4Hvx9q9ZIZjTB0l7sx1rlXbIUnWsWB7BcDEUq/wYuV6GPVZWsIR1o/FWqytnSQkwJwV4Dqe4zBBG1ekZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB7336

On Wed, 24 Jul 2024 18:14:55 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> Support `MITIGATION_RETPOLINE` by enabling the target features that
> Clang does.
> 
> The existing target feature being enabled was a leftover from
> our old `rust` branch, and it is not enough: the target feature
> `retpoline-external-thunk` only implies `retpoline-indirect-calls`, but
> not `retpoline-indirect-branches` (see LLVM's `X86.td`), unlike Clang's
> flag of the same name `-mretpoline-external-thunk` which does imply both
> (see Clang's `lib/Driver/ToolChains/Arch/X86.cpp`).
> 
> Without this, `objtool` would complain if enabled for Rust, e.g.:
> 
>     rust/core.o: warning: objtool:
>     _R...escape_default+0x13: indirect jump found in RETPOLINE build
> 
> In addition, change the comment to note that LLVM is the one disabling
> jump tables when retpoline is enabled, thus we do not need to use
> `-Zno-jump-tables` for Rust here -- see commit c58f2166ab39 ("Introduce
> the "retpoline" x86 mitigation technique ...") [1]:
> 
>     The goal is simple: avoid generating code which contains an indirect
>     branch that could have its prediction poisoned by an attacker. In
>     many cases, the compiler can simply use directed conditional
>     branches and a small search tree. LLVM already has support for
>     lowering switches in this way and the first step of this patch is
>     to disable jump-table lowering of switches and introduce a pass to
>     rewrite explicit indirectbr sequences into a switch over integers.
> 
> As well as a live example at [2].
> 
> These should be eventually enabled via `-Ctarget-feature` when `rustc`
> starts recognizing them (or via a new dedicated flag) [3].
> 
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Link: https://github.com/llvm/llvm-project/commit/c58f2166ab3987f37cb0d7815b561bff5a20a69a [1]
> Link: https://godbolt.org/z/G4YPr58qG [2]
> Link: https://github.com/rust-lang/rust/issues/116852 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  arch/x86/Makefile               | 2 +-
>  scripts/generate_rust_target.rs | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 801fd85c3ef6..e8214bff1aeb 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -220,7 +220,7 @@ ifdef CONFIG_MITIGATION_RETPOLINE
>    KBUILD_CFLAGS += $(RETPOLINE_CFLAGS)
>    # Additionally, avoid generating expensive indirect jumps which
>    # are subject to retpolines for small number of switch cases.
> -  # clang turns off jump table generation by default when under
> +  # LLVM turns off jump table generation by default when under
>    # retpoline builds, however, gcc does not for x86. This has
>    # only been fixed starting from gcc stable version 8.4.0 and
>    # onwards, but not for older ones. See gcc bug #86952.
> diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
> index 641b713a033a..44952f0a3aac 100644
> --- a/scripts/generate_rust_target.rs
> +++ b/scripts/generate_rust_target.rs
> @@ -164,7 +164,14 @@ fn main() {
>          );
>          let mut features = "-3dnow,-3dnowa,-mmx,+soft-float".to_string();
>          if cfg.has("MITIGATION_RETPOLINE") {
> +            // The kernel uses `-mretpoline-external-thunk` (for Clang), which Clang maps to the
> +            // target feature of the same name plus the other two target features in
> +            // `clang/lib/Driver/ToolChains/Arch/X86.cpp`. These should be eventually enabled via
> +            // `-Ctarget-feature` when `rustc` starts recognizing them (or via a new dedicated
> +            // flag); see https://github.com/rust-lang/rust/issues/116852.
>              features += ",+retpoline-external-thunk";
> +            features += ",+retpoline-indirect-branches";
> +            features += ",+retpoline-indirect-calls";
>          }
>          ts.push("features", features);
>          ts.push("llvm-target", "x86_64-linux-gnu");
> --
> 2.45.2

