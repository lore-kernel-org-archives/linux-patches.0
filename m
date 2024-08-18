Received: from GBR01-CWX-obe.outbound.protection.outlook.com (mail-cwxgbr01on2102.outbound.protection.outlook.com [40.107.121.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E910C49630
	for <patches@lists.linux.dev>; Sun, 18 Aug 2024 18:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.121.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724005189; cv=fail; b=cxB4CksVEgwgTGTeP7OFb0YYqXS2EXIwh8/eCAwXndJDW1pjB8dDT9n/vmU3ylk7Hl0T6o1m0EFiX8TxnNGfnMW36vA3RsLd6B5rOKfVlvLU+kPFjOzuPG2BbeurjNviT+gMyoDZSsKOtBiwTSZ5uC5JG1uvhrnPiiwgYsD7l9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724005189; c=relaxed/simple;
	bh=fR3fyksQYepEBgHey34TTvjqAwGVM1T8s0yTnrsAZuM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J12jYYBPprVMTbm2pFPMIYJRJMmky0QTrqfg8EgmX/P6qwD9kAy5PTMQBgB168sss6if3+r8JE9k5FJc9NNFER7+hmUC38grfIY+csAHHykAPxvyDWdnZSoKEh6KYVewRtfcPYbwehiqdIsm6WfCQKn0M2eeHosqJhZCwaJAadg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=UOFZ03Wx; arc=fail smtp.client-ip=40.107.121.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="UOFZ03Wx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tOgaY9woWIGODq+yRd+8ZaLUnocKnLlRa5AnoiwRIGcFAKUaXqZSSFdTTcvH3WXarcM9Tr889P7BGfSX24IJtFTqCzamrneOqgrrRC1+1cG0HIsT+pjWzSrD655Ma/PnUuixL9unKKFsfvZKO6N1RBf0/O5/urkqyJuUhTWbvZ7Tpd3fifOxn7HY8HNgh6VJm5uNO0Nflt85F4ZAFjsFjOMrG1yxfHEmrIf4wY+F4FcEG/jOvnK8su7xjOjjq/wILgvbuoecjPKihkyzCgf9rzrttOhieaSNT/Y8cBxLpfrVt+nU2ssK83G85ZvTM7uETSLo4H73ZXzrCvbsMdrvXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1qXca9sLc26HFmqqqh09+QkUkXj8uo4Hc89gSelHUs=;
 b=Vf85cqzG8diBD1swFPdIgu/X0Zf5We4X681j6dMXwaylu/tepXF5pRSmzPpLU8ia5mRzJ8lJN5AJc3kw2kcezLRM6AUtyiM+6JhlDk3HnrgahYrcZfGM12m9YOts3r2v8j2muhAUDChd5HScdnwGURxAJyYwvCWXXpgivJNTF8lwxOcMCM1PIhNyCD7OVsTH6EbW2aW90JF+77LsS4c5UDcGX5bFYPocChZLebDDNvZHK4O8As1r9QG3CqFfTiEkwey7WvjR+djpx1OCFxm6SvEibdX7wRdvKX/7grioYTQGWfcRUVYGHsr/ptafuvUFgwX4zwi52Vr9OPept0VUsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1qXca9sLc26HFmqqqh09+QkUkXj8uo4Hc89gSelHUs=;
 b=UOFZ03Wx+M/Ht3H/u4+vTamvHGxA5uPQFrzSq3DrjVnVo/RNi7uQaeJSzea937pJpQ+xCu0aHcGcQTou/pFAlQLzQGzvrR47OeZ/jX1cipivnJx7sAJXOV5Bk0GAFDsFMQxi/SPyekwv9t2Nvan1KynfHMbTnDLKFNZGtGuSATs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO4P265MB5961.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:298::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Sun, 18 Aug
 2024 18:19:44 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%3]) with mapi id 15.20.7875.019; Sun, 18 Aug 2024
 18:19:44 +0000
Date: Sun, 18 Aug 2024 19:19:38 +0100
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Boqun Feng
 <boqun.feng@gmail.com>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Andreas
 Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, Konstantin Ryabitsev
 <konstantin@linuxfoundation.org>, Guillaume Gomez
 <guillaume1.gomez@gmail.com>
Subject: Re: [RFC PATCH] rust: enable rustdoc's
 `--generate-link-to-definition`
Message-ID: <20240818191938.20ee1766.gary@garyguo.net>
In-Reply-To: <20240818141249.387166-1-ojeda@kernel.org>
References: <20240818141249.387166-1-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0648.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::19) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO4P265MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d00ff8-9e72-4d50-7716-08dcbfb2558f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p27yKzFfdUiX0CkGkJWvARigul/BotE7V8BCPa/V7WkaVZvkt64V/f/u4947?=
 =?us-ascii?Q?r0ReFxZvcIHWsvN74TATBPA4PLBo5I2GYLSCUB3ar6JisraK3gtrjasTtApC?=
 =?us-ascii?Q?IZ0KNCe0/RmHKeSd/ybg23q3hhMFzDDqj8Dar5OBurTxpgleliD8M7/UVpBD?=
 =?us-ascii?Q?Ih0nYmbP/a7N/TC3qm/el3ckjZoAUYW1MQNpjroWQZ9vnCWLYW3HkaCuh6EU?=
 =?us-ascii?Q?n7w1meSultYo7W+odu8EsjJk/v1QEDA2IsQDsIkEP6WRZTKhCOLgzJ68WdeP?=
 =?us-ascii?Q?VbFBZ5XBWHzj7EcJVUPyF9MG7ninafZ/qervHlbaswRFg1bf/82LZaVHvyRJ?=
 =?us-ascii?Q?eE+g5RFuhAS9tiR3BHGxlNSPlK22RyKSMVglfRl47xxHMbl7s9e5OPXP+oGx?=
 =?us-ascii?Q?i6K8RFGQddYk1cCpNqHdX1Pc9p15P07NakFn47epWuJrbg0NIRZ+93Cpiz1F?=
 =?us-ascii?Q?h8SgUrd+fHXmqdX9qjSCLrCiZqAC+hMtUSeud0RZQuQL6AGskRwbHdyRWxQL?=
 =?us-ascii?Q?VGQgJkaCziMMXUt7QKpNUV9Wv8M4X2D3Rb4L3jCw7tMhW7Qpo9vxEFsKpfpV?=
 =?us-ascii?Q?mkbHP8sgZWQHYAX2VjVY/xdLDOBFqKxV8KV80Q+ljzmOdkOoCuNhVS+Rgvyx?=
 =?us-ascii?Q?v22zuiJQKCFCfeyAs/7jw7biC12ct9Ky1Qko6NQzJxKFm3mQhR6p+76EXOCl?=
 =?us-ascii?Q?FaALtkXuukGDeLlM1RamqyPycqBCts+j26DxrwUvQ0nPhiryb/aMxX+KoZK/?=
 =?us-ascii?Q?bIdakC5Yjv7qS2m/EyBs838aJMJlxA/txdXAaYdPn7mc2JyCnjacWbaqxc9j?=
 =?us-ascii?Q?ooy6PFo5vygs69vU6n3Q5CM1x/eSKGtp7rtqxYibHbBN2ggbBA5GhS2SMbfm?=
 =?us-ascii?Q?2JMRSDf40dOFfUypEd9XHRhvuTGxgqBJG7Ar1uCHUQbnMcobJYCDIM6ZqmRM?=
 =?us-ascii?Q?cde3ofLmoBk3EZyp4S3xTQYfW9wraKofCazO9ALto1Ja8Vsp8Rl1F0V70a/4?=
 =?us-ascii?Q?KPtNPwFfux86UbZbl9WFMSSFg0KiO764qgyP6YQ/Yxor/wx/o4RUvfidL00p?=
 =?us-ascii?Q?OwUufR1LVJ5fBZgu4PmCwlzHajy3oMONmkk1vebkDBV31Vu84EX9b9B+8TZo?=
 =?us-ascii?Q?FePcrL0S1sKOLjFCXbD7pYZzd7dYHrKfmRxCBkWjlCd2Q7JW4vn5cFaL1sxu?=
 =?us-ascii?Q?DslTUXdbAmyCdMTvgxsH2xqs6kXmOm6VxJUeBgEsR9JEpsn9UY2iBbJIWGUJ?=
 =?us-ascii?Q?wv6vcJNRpvEncDk6zi7CeeeX4bTgSk1FzINn28nB3LdEmkrkSIvb3MwqfpEi?=
 =?us-ascii?Q?vsk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Re5EV01L6djnrt7wmgd2bYfJjx5/5BteqsN5qbPvvNvcpsNKGxbHuFUE+rnq?=
 =?us-ascii?Q?TQHP2KF7EsQIksaSOIUICJLh6VHwwRysGbrnzrOyrUzjZeiUO4CQJ/oBbpUY?=
 =?us-ascii?Q?26ao+Z8LXMDqSmNUTOAkxkz6NJipVsK9yE7wWIEnY1x/KYcZPFW21u2HkreB?=
 =?us-ascii?Q?Ps06685U1X0SdiQcHFTcaVOmlrOtnbP0up39kfB2zoMJoN9SMH0RWf712Ynn?=
 =?us-ascii?Q?DUTfBz55njnHDKBHGZPrnQkXNkMQ/qhAHRt20ilmHbMJCvCdeNmxM8trJlgl?=
 =?us-ascii?Q?QMcUCqPAStByJNRvQtcqnxwE0Md4Esf+gu4WKrlnUB8j8gEbbTOBBfkjBWfg?=
 =?us-ascii?Q?pT/vLakF4qyPWFHBhXSzUMWjeT4v0b+2OhYM5RXQRThq5U3TUzK0pRT6Ab32?=
 =?us-ascii?Q?PHzdIm8CQcBG0EhTtNuvPxe6OAC3jSt0g/9WNX9Hlgb6kf/WwOBehao3zQQL?=
 =?us-ascii?Q?aApqt+zeFD286bB3nQyMSO7Z9raSgnltZvJZDtrjT3TzU5kmo9CugUwd2/72?=
 =?us-ascii?Q?7YTcsjA/NAqME5IdtQHSN8jMO95PrvZTyC+H6GEStMGpvIcx3bm+nNaLd9ge?=
 =?us-ascii?Q?6wZHO42o+ptRZMXjFN6/J0OG6JNdKNyoOkb9GIoU5BY2nPEDGmWTajoasz4O?=
 =?us-ascii?Q?4f/QNUhZBofZUoReaxyUgBLvgwDOsIF4SIGdMOPh81px59wWQcv3CAL1iLY2?=
 =?us-ascii?Q?CavDbYBDBs6XSGxjjde5WJVrVmXIzXjCJQJsYdwO0bkyrgyiaH2kScoEhwG3?=
 =?us-ascii?Q?pIUCS2KyFZvSZz+FGlfYjfap/F9+tCKe56ISFizRbypqzsWkftO1PsKikfwf?=
 =?us-ascii?Q?Ma3/Ou+aUcpg+XaEpoBZNgqVS7bDkBZzk0kPqnQpaf3Lyr1hW5JnL6ltOxjr?=
 =?us-ascii?Q?ELn+nthcE+CufG94zQAeuX+Rbs2FcRsgj+ZE+Du9PR7TB7gPHjlXnYJpsnoq?=
 =?us-ascii?Q?FTQl7FhyLxafhSDPz8U/pqA9Yid2w4GkNaH9cHvlx7yNq0gETBubsqI+P6xu?=
 =?us-ascii?Q?oLHx0eBogqDOBBKEnJTHicfK42escpNOTEU/IUosRPI9REckI3rxSUTWWJW+?=
 =?us-ascii?Q?jVolTVV4BR0Jb1rVEYZC68TIxvDzAfo5afmG5IRoovjcxeIFD2gAC437Eff6?=
 =?us-ascii?Q?watdZXkXDBhA3w0WMTwqxzseOxLKQ7+y328uPc6ghU7W3KS31s2QjBzC7xXv?=
 =?us-ascii?Q?usA3VkV7fuJfQSwXBnUmhSBPVbwyNCPJRvPXjgdDHwXgJqZTNHjUDc+svwJh?=
 =?us-ascii?Q?fO+t2qLeXPXcs3s1lZAAUNzwBiE02dhYTaexP3jtDNoDdmC7TZOBT/1hvTVn?=
 =?us-ascii?Q?1xjTkzFCLkMD1UdoSdJespsHW5/zYPRx+O7vHj1R91FJgIxfbr9nyzhH/vSk?=
 =?us-ascii?Q?P5E4cTndIK2zpcpnzVH9jMEO6numtIqeGXOyZixiJtoYDP2I1553+KCXqSY8?=
 =?us-ascii?Q?x/yRIsKx88bjRmtOAQMbr8icbKOhqdpkaqNqMp7anXgxdkCwuj/9itYOLHTt?=
 =?us-ascii?Q?Lo0pPUFgAeIypR26m0XEhD+lTFpJxIGYkJheXaL6lbVCfRn5HpwfE5JSPTpH?=
 =?us-ascii?Q?kM0RJhMg3jfgoEkeAodC6xSKAGAFd5Lj1aVCr1Evttj1FIETQy0+Mb2KOY7o?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d00ff8-9e72-4d50-7716-08dcbfb2558f
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2024 18:19:44.1588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEcvlAaQirWMjqeuV5KbZBUJCjDKvdP1EcwvKj88TV0buzqhxeEY0ziH7yrYKxva4IQqiQLdAVLvSmviJ+xn/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P265MB5961

On Sun, 18 Aug 2024 16:12:49 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> In Rust 1.56.0 [1], rustdoc introduced the "jump to definition"
> feature [2], i.e. the unstable flag `--generate-link-to-definition`.
> It adds links to the source view of the documentation.
> 
> For instance, in the source view of `rust/kernel/sync.rs`, for this code:
> 
>     impl Default for LockClassKey {
>         fn default() -> Self {
>             Self::new()
>         }
>     }
> 
> It will add three hyperlinks:
> 
>   - `Default` points to the rendered "Trait `core::default::Default`"
>     page (not the source view, since it goes to another crate, though
>     this may change).
> 
>   - `LockClassKey` points to the `pub struct LockClassKey(...);` line
>     in the same page, highlighting the line number.
> 
>   - `Self::new()` points to the `pub const fn new() -> Self { ... }`
>     associated function, highlighting its line numbers (i.e. for the
>     full function).
> 
> This makes the source view more useful and a bit closer to the experience
> in e.g. the Elixir Cross Referencer [3].
> 
> I have provisionally enabled it for rust.docs.kernel.org [4] -- one can
> take a look at the source view there for an example of how it looks like.
> 
> Thus enable it.
> 
> Cc: Guillaume Gomez <guillaume1.gomez@gmail.com>
> Link: https://github.com/rust-lang/rust/pull/84176 [1]
> Link: https://github.com/rust-lang/rust/issues/89095 [2]
> Link: https://elixir.bootlin.com [3]
> Link: https://rust.docs.kernel.org [4]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Hi Miguel,

Thanks for doing this! When I visited rust.docs.kernel.org yesterday I
noticed that the definition links already existed, and it was very
useful.

Reviewed-by: Gary Guo <gary@garyguo.net>

Best,
Gary


> ---
>  rust/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/rust/Makefile b/rust/Makefile
> index 1f10f92737f2..d311bcc30226 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -63,6 +63,7 @@ quiet_cmd_rustdoc = RUSTDOC $(if $(rustdoc_host),H, ) $<
>  	OBJTREE=$(abspath $(objtree)) \
>  	$(RUSTDOC) $(if $(rustdoc_host),$(rust_common_flags),$(rust_flags)) \
>  		$(rustc_target_flags) -L$(objtree)/$(obj) \
> +		-Zunstable-options --generate-link-to-definition \
>  		--output $(rustdoc_output) \
>  		--crate-name $(subst rustdoc-,,$@) \
>  		$(if $(rustdoc_host),,--sysroot=/dev/null) \
> 
> base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba

