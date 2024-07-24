Received: from GBR01-CWX-obe.outbound.protection.outlook.com (mail-cwxgbr01on2121.outbound.protection.outlook.com [40.107.121.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6725E15ECC3
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 19:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.121.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721850415; cv=fail; b=elIInuOWBRwTeoXv2VVCYnE7VpHLBl9m4/WFLGFbSPSfJ9IkPAXa1FwlfR6iNMFORhNtO+zL8xsFMO94Y7ipjSAZY7h3Yu4zCTtzW3Wu89eYm1Y/BlTbrGVAevu6BZO//5nRCcMNdwmJ+RAFEj9NJriEHBsQJ3TsnqcTZ7vMTQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721850415; c=relaxed/simple;
	bh=aqaFUlxiDTW370IOSob6XeTVQPNupeeWI36vBcDOIvM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YRrvBvQkzbgWxaMTjtUHalYWXs/MyYyP+RtfWnvyFWLnSOAUglnbs446CDWfC4bepTvaO3/vA50tmNyz1qYZ1i9ZNbVeW8qSlrjzGMj5lR53hSRL8oDku0WeIw796CeyQBQSPV29lBn5v5BRt9BRehClbbEXZ1gBFK9FUPNpAsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=IEuVs3MB; arc=fail smtp.client-ip=40.107.121.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="IEuVs3MB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jxmq1dVJTxVWat5Tc5mA/NsQXsyC0o61fpZbXwDXzlVDrIVKrm8R6t6y3K+MPQBhsJx1myeWMeLDsUAwem06/qxERMVMt+IWUtroFWrTTR/w0UWHlL9lZn+0blPwjn8JR6TNFZUSRSCWU8hVzu3hc24Sm+LOQW/U7A89+m7CdDAu/qD1L2zSblwHEzsDWG5Oswua3DT8b/EKlYFxM0d9wasMs9YzeMNg2hxBq7+83mKBxUGFjVMQV6ITN/B/2I+7zYtZB21YMqBNpS557LfPQN4TnN/Do8ZEmHHleJDUP4IejHcl9L1zgyfE7G4bL36e79gK3Cnu9DaojlK6GybKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZNWJjx0Gk3KjaKucJpq1q9lM9D0Me8WxEtZVAKh3Fk=;
 b=Mkrj6pV07efsdtR33sJGLALR4psNPpwOFVxUxc2ZZSPcVzdmh1BAFHNpiGW7T6D8+LO2tFW8iLzV9iKxjWWignuvNfaIKMeNT0Yt9eNDgNB2LMMXir/+Y9Qr39UOhXsQ+TLhowzebDR4tyyMgUXJMvvMoYXrXkTNOfo13AW8TwMqY9P+m1yN5V4z32/OniwpNnr9PgZVaryZFK/1bju/X6hy4y/Fk480hrVLLWWpKSxfWkQTXmGA4dgzSOsdf41XEnnMzsuP43tLncfZQ1mJcPaaBZTF8l0vyj18RmaVxKVU68UzJ37JGBGYXvDrNgVqTd3McWlRUzsfKLr75wDH9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZNWJjx0Gk3KjaKucJpq1q9lM9D0Me8WxEtZVAKh3Fk=;
 b=IEuVs3MBJpJIWuMRldeAMlMYkfNfc70hNnbWijon5lpFoHeceM1nKQPAStLA8DwaOPwnHDGdBSKXCo9SciY1LwjcyME8me7Xj2/jO3Zj5EFwK4GSUPCJoVS1M3HvPjdkwlk750FOJT6qSdJmUj8kuIjDn2gMvEN+4J/LZLnxmDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO0P265MB5957.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:289::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 19:46:51 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%6]) with mapi id 15.20.7784.017; Wed, 24 Jul 2024
 19:46:51 +0000
Date: Wed, 24 Jul 2024 20:46:49 +0100
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
Subject: Re: [PATCH v2 1/6] rust: module: add static pointer to
 `{init,cleanup}_module()`
Message-ID: <20240724204649.7de3ffed.gary@garyguo.net>
In-Reply-To: <20240724161501.1319115-2-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
	<20240724161501.1319115-2-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0112.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::15) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO0P265MB5957:EE_
X-MS-Office365-Filtering-Correlation-Id: dfb3222f-b9ec-4f26-a579-08dcac195d0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hMK2kjvcZav5mlz+Nm1VTzbtetyKpmMqHVw54KYlX9goUsir7yxlEtPNlg/j?=
 =?us-ascii?Q?LA1ZWW/FBibGQ/23auvHiprogAn656xmdRlCM5BMElOjguwyh2suw4YYHp8l?=
 =?us-ascii?Q?n9Hz+ZIrk/Ab2xm+OYl+nEPXlP7punlo6rdVCXaGy30+Wb1cNaZQmh007w5p?=
 =?us-ascii?Q?cHhxeo4gu7m+si8l0tT1BZPVolZ07oU59598VcMg2YZf2ZrtpFny6FHVOxal?=
 =?us-ascii?Q?o3+sMHEpbCvZJJEtONY8vlaREEvV+0JCcfTkNP8HL35XFURCtWBSH/Fr1d08?=
 =?us-ascii?Q?puo2oDgjlVlGoGqusyTKRI6ap3/21s23p4giaDypKwoc0KsksCEkKFmf16uh?=
 =?us-ascii?Q?XAsO5H8nKkJctDWiRvxwYK/49UgiIwQBsFYeQUJEjc+FKm7pjNjPH67fclVg?=
 =?us-ascii?Q?i9NKFQ4SlKlHEEzVkJVuSJRoYhMMxRMupFeGa0PNDwXX7EbyJHabzSZGzgDh?=
 =?us-ascii?Q?ut2DEcxvN6PTPiRmL/GQ/Sti9nyhoxNrP+z1nWWVxtb4ELGg89bF+rlMPO98?=
 =?us-ascii?Q?Hf8pB/ZCOhjQLergRsy7hJldaqds3IXfWrL0zB4NS8VWtI4rSZOuZR5jOq1Y?=
 =?us-ascii?Q?ef49cNl5PUDUNeaDYlm7bM9ufn7ULuPlca1VJhImUpcReg/g4RSju3fNAepy?=
 =?us-ascii?Q?NJmXvj13bUxSY55NbYGrjtIPcgScW9PNFuyDFJ5qQqk0yXju0PKo3oqy2iRy?=
 =?us-ascii?Q?jRfkegceimdx9kJGhQUNOj/iRaiLCso3gIVzbg1ltBBMAbwy7n+TjjGP17Xk?=
 =?us-ascii?Q?C3QXiOEPe3Kv1tPnfIuLtUfD+EHgfBtzhe6+fdagMRH9EpRQTN0tNS82A06Z?=
 =?us-ascii?Q?S5oVjVTO/NaRz+uGGRaUF6mz7O1pxEm3GRuMxBdMyVrV3Hz09g1R1VzNgw1Y?=
 =?us-ascii?Q?srq83bzpBElyF0oL/PjI5M3cn5tk7qWYGMmNvK3Z4lP78DH6BO9L1WMOeex4?=
 =?us-ascii?Q?Ajy2kIydIX0q7rtKRrM+h4zFaDZRRwlDxJ7wulafSF90QwFcT7/5c4kUUDQm?=
 =?us-ascii?Q?IdGcVxrgjNFQu0PVMT+6Yj0+vgxzo878xPxbzbL8OxJhiPeWgeHDLF39dEcz?=
 =?us-ascii?Q?jfLenmNqd64PjxdjM3mpy5gDazD1BnIrPS5RYQtG/hIr5Ib/YVg8Nj1VCYrd?=
 =?us-ascii?Q?acpCs60rBXum40mKg8s1MBqXNNyLAylq9npWGR6tx8E47mZqIe1aO78i5gWa?=
 =?us-ascii?Q?oaSp8M4NvU0ipPG4Xm2CO6OdrRznJJ2/W7iESV4h6celTVRw4ZRj9iUzpC7R?=
 =?us-ascii?Q?YIl3NgT4daGkEQ29AGnEU+YdVkkOZD4QSao80Cf0idtneOg6TGXWyo0uitKu?=
 =?us-ascii?Q?FVtzmsX40p6LdEwrBltmEol5DxlYd5QmxkihmB1cOdK3cQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9ZWhq+1MabZgu9edHyzovCODG570h5g+YvHn01ojuYfM0xtbB/rPPtfKMIYx?=
 =?us-ascii?Q?9geSYzd1zKilxGnEclz5S22o53qpiVOrhBmeatuLECzDoLHBdz5wyx/dfg7r?=
 =?us-ascii?Q?+NIKmhCi9oKPEszlfGFuWIGbn4SY6gUNfUlTCfsrk4rzFSaUaaAmhxdtCR2j?=
 =?us-ascii?Q?0OPEiFsi7GfrStYQtUeXm3Dcu292VvliauPOunUTYJTNtn7CNfC8sB6VeuNg?=
 =?us-ascii?Q?NBE/wg5JGkxAPbHQa/NET6EqVsjX3YTcu4rN1IbSlP9Ct4VxkXJn4DHAvbME?=
 =?us-ascii?Q?Z6SQwpy4Nz8Wtt17N9e2VcmS2XFVn5LT0+E125ceKLEIQ3agh93bOazXJARi?=
 =?us-ascii?Q?6hygwB+eReOGZSgZbxbtlU18cIxJi438uNOMhisARZ5scHe3qQOtm3RyUKJA?=
 =?us-ascii?Q?wtNKXdrlHHyk0n0i3oZkihp7dKcasuja+FFU9Mlq49Ims9Sqy17dykWqECvs?=
 =?us-ascii?Q?mgaI554kPzzMBDilMnY9hb303VTOzi7lUdoaLgsqHvR0fxLd8OfCI3Xz3V3v?=
 =?us-ascii?Q?vB/1Bb951MWGLPVL9/Hpsafih0RdVyS2eLis16bQy03DLRIfgm4bKUGnAp/f?=
 =?us-ascii?Q?jrOxf/PzKWWT2mFbrXesq0n1zfZzDctT3sHycn2zcynwdF/gFvrxK+dWtDUy?=
 =?us-ascii?Q?anbOnF9+pg1vSFqyYUo7HwC+n2TDqrBZX0khVVWpIrRy/p1xId8q35EauV9t?=
 =?us-ascii?Q?3xZeK7tvBREbczTI60dQ2zGhvoMqNhG/nlBrgRC4O3KIQpYm06S9e8+TtlJJ?=
 =?us-ascii?Q?aAZAXPab2QcazjEowEsMHsFfMEUJzw0XKbUU1xRRs+jIHtZ86Z7XE5bhGoKD?=
 =?us-ascii?Q?j142Ds4JV2+/EYF/zSVklZzKpZCX7HM/fvbwXZSiKlnyx74JjUK+EurOdcAj?=
 =?us-ascii?Q?Pj4xhB7KbEi0PM+Jrr29A4/cDFB8ru7tH9wdADaJ6DfRqb0D+OmRpbhk607A?=
 =?us-ascii?Q?CHRgvBQgbyilvm/+FXakM827UAjS2H4Wb42+V9j3eaaGXDsIQUylmAZRknoZ?=
 =?us-ascii?Q?UqMaNDQWC8e89JM0sp9Uaa1hWRuzZ+bzIZ8ktI6z4BNwKK1r/MGqIOlVaZe0?=
 =?us-ascii?Q?tcez9XAp8swMPji/FrTDxrx2JTPUfUbiZdMcXSvmU2lO+ONjr4Mhfp3v0Ed9?=
 =?us-ascii?Q?g5CIPV71sIUIou8vhV+datqsdctlx6kijBEKnxRhv3k9MhfweoitzRgl6iB8?=
 =?us-ascii?Q?3PbTtGG9cF2EWG2AIva95ZkegCyWpM3sKFoYIC8aF2O/k1SIGeo7Yy2z+roB?=
 =?us-ascii?Q?bFaXpKiNDxwxmGKCc43qoqBC3eG8S7sA/YPgSPqJnKL25iiOpxy+wvBQrD0X?=
 =?us-ascii?Q?DV5D5m+Kx/sWuUlyxsyfR0hvOOuqHPRBRk29S61mYtlbTOoP7sIRZAX5AO5G?=
 =?us-ascii?Q?/9Mh3yXJijhRAwWNlPm5HBUWN2RduZ+pl/CvVd7EpdHfD9hdDGSrXgEbgxL9?=
 =?us-ascii?Q?tTXBUuougzgGY7iz5jiI3hEMo+kZpovCArbVKZ+puuwG2mRcSVH1Kv108j28?=
 =?us-ascii?Q?mtpOE47Uury++0UYDn7KHbrpla5GX5ZQSlAAimncJYLrExK2vVg9Z/q7B8j0?=
 =?us-ascii?Q?ejq1BPttBkC5RhWfG6bxnHdSjagNoLbAl6QeQ5Oy?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb3222f-b9ec-4f26-a579-08dcac195d0a
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 19:46:51.6904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qohSXwbkDd6OwB7dOLC8dwtcys2kFVImQYmXRzN31TwfE2f/gd6Zr8M8/TLwUUfxDbWsLOsphnZhwbBtELlbfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB5957

On Wed, 24 Jul 2024 18:14:54 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> Add the equivalent of the `___ADDRESSABLE()` annotation in the
> `module_{init,exit}` macros to the Rust `module!` macro.
> 
> Without this, `objtool` would complain if enabled for Rust, e.g.:
> 
>     samples/rust/rust_print.o: warning: objtool: cleanup_module(): not an indirect call target
>     samples/rust/rust_print.o: warning: objtool: init_module(): not an indirect call target
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/macros/module.rs | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/rust/macros/module.rs b/rust/macros/module.rs
> index 411dc103d82e..571ffa2e189c 100644
> --- a/rust/macros/module.rs
> +++ b/rust/macros/module.rs
> @@ -256,6 +256,12 @@ mod __module_init {{
>                          unsafe {{ __init() }}
>                      }}
>  
> +                    #[cfg(MODULE)]
> +                    #[doc(hidden)]
> +                    #[used]
> +                    #[link_section = \".init.data\"]

Should this be in section `.discard.addressable` instead?

> +                    static __UNIQUE_ID___addressable_init_module: unsafe extern \"C\" fn() -> i32 = init_module;
> +
>                      #[cfg(MODULE)]
>                      #[doc(hidden)]
>                      #[no_mangle]
> @@ -269,6 +275,12 @@ mod __module_init {{
>                          unsafe {{ __exit() }}
>                      }}
>  
> +                    #[cfg(MODULE)]
> +                    #[doc(hidden)]
> +                    #[used]
> +                    #[link_section = \".exit.data\"]
> +                    static __UNIQUE_ID___addressable_cleanup_module: extern \"C\" fn() = cleanup_module;
> +
>                      // Built-in modules are initialized through an initcall pointer
>                      // and the identifiers need to be unique.
>                      #[cfg(not(MODULE))]

