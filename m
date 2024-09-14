Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021113.outbound.protection.outlook.com [52.101.100.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF55823D1
	for <patches@lists.linux.dev>; Sat, 14 Sep 2024 23:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726355995; cv=fail; b=T731e592P9Z0hFSa1rRF0e6tJHOrPREvA/EjX20suk++YBdvTwT+h8m12NTcIXwClzNWdgJlQ/pI58Yz5XEEPGTSkPhyWEVEABbr2BaM9NgtNEBUX/qwGrv0lElDApZ5Lm3K22lDdqAjVCYfvuYn0pwZ7jEB+KBWsq78nSoVBeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726355995; c=relaxed/simple;
	bh=VvpRFAPecFCQA5Q+A6XX3CNUld3+eQFfNE7yutYwxgA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C1d1/kS1sl4hfUFEfdnVkM9yUjg8EX7rr3fY+9UweCXiXFIXvEynh/3Bhcztof/J+oVchy1MnsUaxkVrUGwfBcj1BPLOcnC9Z1iYodwp4d2JlC5mPA88h+ezRwSXFMbQtxK0wST4NyK0YWnzcpVZAWBPMYBp+dQQyQ+c5Om0igo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=LaP7xsDn; arc=fail smtp.client-ip=52.101.100.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="LaP7xsDn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xue9ct/8x/q1tNy3oKtcKNhSLbNwikNxqF84dl3oeTE6ZAnTgo58KhK4YW28GUMQbQ/Em9quxqCnX+jbfBw/CCxtOecW0ZESxeGYut6EwAhc+BeW2Cx8edOn3LOcPBNnBu7r3M8/PkXySRO1nvXK9YyxBKf+tRQGfg7cGTBPchZsvpEC3RgD50JsrqRkh3+Nt5E17lkSAZ4tsOl+FMYlU6YLHLIWM5sCgtyEudLuJzI5OFlSs6ku80WzTwT3Ac/IW1ETn1aRJj4iS3Z4p6La7iDakUg/Rl4koRymxwQ09SQUzktMm6u6qLxGuN6cTw5QvIEbO58rxuUrUIETedC6kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Env7/7i0CW6h5lSuMNL9vRJh/CPv2YtIko/pljOtXGA=;
 b=TSRC/bsUj/rAQtiTbB0HkKrKMJMOllb3YNc5BkkAUQ13n3WqKvjcMrL3ir9YiDuN2zRNXLZQa2Sibjd9TBhSvbi0d7WLBKoTF84n5zXqinQfdSgoOXxL6EiXO2KLjDt0BrlU1iLfD0eowgIoOmI+eVn+i8CfYSP1dvyrf+ygo++D9bimX9LYlPbxzo/i+aeMg+2bY+PDL3nKb61mz5xtgzgH8mU9Ex99TLtiI65Bk3svvVGO51jb6eNN6YeMhYSpPrVq4RQHU6XvJ2MPzSZ5HTrdaO3AAwK3RdIQj/C6rRMNCBM7/xNLwd/GPPCfGVyslb8dDWOw8lFfhczaHeqTMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Env7/7i0CW6h5lSuMNL9vRJh/CPv2YtIko/pljOtXGA=;
 b=LaP7xsDnmX0DC9/YmbFNCzkvDgCcZJ62+ovDYlmDAirgU7Eq5OluAv6b3oht7iu1alAnjxlQ3IN4GJdvOHsoCgLRt8EJWMPTz/w5oL9TabpabUeYPTLymtVz1CkGdIcSN2zf9tk08Bsp1G1eQdmY2My6AZlxYMQtT/UqRNmkjHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO6P265MB6720.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2fa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.22; Sat, 14 Sep
 2024 23:19:49 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%3]) with mapi id 15.20.7962.022; Sat, 14 Sep 2024
 23:19:48 +0000
Date: Sun, 15 Sep 2024 00:19:46 +0100
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, =?UTF-8?B?Qmo=?=
 =?UTF-8?B?w7Zybg==?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 00/19] rust: lint improvements
Message-ID: <20240915001946.2cf237cc.gary@garyguo.net>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0029.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::17) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO6P265MB6720:EE_
X-MS-Office365-Filtering-Correlation-Id: 45711d0d-5e3e-42d5-1b2b-08dcd513ba46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UeVBUnBkz0NXsH/4osDQSbCuuSjolpuHCRJiUC0ZKAcTGI9Nx5QmBKH78cef?=
 =?us-ascii?Q?8fKEtEa+FzXE14hYnFxZj1AEmxDmWOAZg55+kfS+2cwMjNTBiWKHrfJUBziJ?=
 =?us-ascii?Q?G2KiGeoxfH0D9AeylnEgeibS6KAjVjDibOIzx6TLjlvoNZQli48ykfwg+GXV?=
 =?us-ascii?Q?pH24VXAEb4ylNVC6+ZZIbVHhua5tBqxlyoawbcSgBQNor3sBi+Vpzm4qwNDn?=
 =?us-ascii?Q?PmH+iUgIrEnqrn+sFqp5utdfAkmKWh4wurQ87+EdXo+ir3wEVhXKu+T1IcXj?=
 =?us-ascii?Q?Ymdniv89EkrWxLW7j8YFk1/udxYE14VlowF2JIJ5wH9kSwsp0Ez5bN7TRyBf?=
 =?us-ascii?Q?Si1yUIeXSaHyvf9KhGmDW/KBxt5R/1oKoLIWHITRMcvgxGDy+nB905eOiJ8H?=
 =?us-ascii?Q?FKsq0oRneRQKF4+hDGocD3QKTP963MI1mw7wnQypZM/8wuQz7DkuGBxdsdTN?=
 =?us-ascii?Q?kvy9USDGU9Itn063tc10Hux0WLaYpv0t84I3UpBp9IBf5rWgqzRRCUHQI66f?=
 =?us-ascii?Q?qrqwpJlFpC4qb8WqJYJ2QOBrR5UeUpIvgjwuG+NsAW2MFuj+P8ESuE03h4F5?=
 =?us-ascii?Q?zdLlisIDXrxwgLXpMYgDDNCiBPPbruG1xWLsd5inR/CGjch6opfnwhakw4wH?=
 =?us-ascii?Q?wsLwkxqoDgHnxvBnpT9kA9IFQaqnIFQ8h91IZx4NecxjFh/33w0wHAzPmpmt?=
 =?us-ascii?Q?iLk90CGBP8UJhiYFXalinbwysCgo6o7J4ZL6SYqo7ADbJhj6iBOXXCWw4Tg1?=
 =?us-ascii?Q?2//EIgwLjFbzxAiEDxkI+lZuvM7dnIErf0Ix6aPmx8/3kCPG53P9yeZMc/P1?=
 =?us-ascii?Q?RlR/4s8gbB4oS7pYWPnPKsXOPi5bEe9LOx8est4MVD8w6WB9uEcO4H6Fee7n?=
 =?us-ascii?Q?XgaYySFHAZSUJDmKyVV0HFRcnfiGneBjof7vqrBqt04RMUzj845YHBFx/ll/?=
 =?us-ascii?Q?Nk43LLt1vDdGp9oIhcYkNNmCeOMDLCG1qn2jUhY6fOdi0S/W8l24rh/8y+6p?=
 =?us-ascii?Q?s6zlR1J+pZDnjwg0Ssjf2saAnTO7ExDHZ8HUlbUBLS2gbw02zq5nhbaFD4BZ?=
 =?us-ascii?Q?838XXuPoihAlk41zOmngNyWQQkKsxeDt0gG7YnvkO6A7Vuo18UjytYPgBQJ9?=
 =?us-ascii?Q?pvqrGIUgEzk3kFEWkK69V4EJo49FhLn17pNvlX656v0YgUUjXACGnuLjzVU3?=
 =?us-ascii?Q?2sEu6RJu/DTPpmkVPH7np/kkbn66OxBxW/T7EdX1vWBJcWd2tagxaPo81Ywe?=
 =?us-ascii?Q?CpXFkrt9dckmjB/jtDW+cRy0wyB27GyGOPZ5upHtubop6nhvsr+fwdf5JgX6?=
 =?us-ascii?Q?FBzkrRSk+Emuts1CWA4XPNZDOY9r7rtEMQxot8vs80zxFg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TQVqdjpzt/1xnnqS5pgo+YYBKemQWYMd6EjBKmUtTAEeelWKj0Y8O3azT7g6?=
 =?us-ascii?Q?FHf2ySfmD7CUdnKpeU6vLfhdYveY1zEXgo8Ha/+j5KP9xvnSvd6kZtgNNibH?=
 =?us-ascii?Q?HjVhhcdVcJ7ns6dKfxQJINqd2cCeWmDgEgn07Xvwp8oS8+aY6YJo11mWmdKB?=
 =?us-ascii?Q?MKUwWVa+lHh9GJwCI/1bPZi+uvU6KmqnzwpF8xDOAEW0rA9B8vwm6L13yjdB?=
 =?us-ascii?Q?cpT9cRylR6zr5I4C2qBDr108gdoALRvuiSkhR6vWXx/kW5c66yJTqzLQKrIk?=
 =?us-ascii?Q?bO8CLvhuz0nBPEVJercq4IEgmoch7Wo2VDlwqyBoVs8IBt5uKQotIGkVgLIx?=
 =?us-ascii?Q?ALyClGOBoN0EpHXUnjVONaFPVe4+vjFqZkkr527Ajlbmp8BJN5F+HprNDVdc?=
 =?us-ascii?Q?Nh/R1QTXVLdwEBKqfbF+Oae63QdoXFIlJnc5tkrCcQr/eRLgfj9xkxD8xrzn?=
 =?us-ascii?Q?4GE1wHB/yzcy62Hs4KX1XGdbqE4akNDr5p2ry4sGlzU/FQXOWFL2vS4IFTVG?=
 =?us-ascii?Q?hF0BG92ePT0guFmDt/F8HQVyiqdrOQm60rGF9cEo8GLSeWglNDOgb64mnFjS?=
 =?us-ascii?Q?QXgj19cdG8+1d3ASu8rdnp6hWU/tG9ATYdttRQ4zmv3stL+e4OVD9JsfuK9T?=
 =?us-ascii?Q?9YFv5EFw19h/6xMGcGJ8YkkxRD2DStkfh7aFPCN5NgyDmw/AWTAAqTepX5CI?=
 =?us-ascii?Q?O/oBs575pspWirLY2iqZZctQSVjEzDxuKrHKZIXuyMQ02YedtLt4zb+851dE?=
 =?us-ascii?Q?fPriXYg8ExTV1DjPn5pgKF5WdKQ8O859W/iT1oaAL2xX5dr9JBJJtTBBtgxC?=
 =?us-ascii?Q?MHPtZlNZZfVK3ctrz/BfAI4USSog5phokUj1roHmdqFwGoCy+IhePggYa2RY?=
 =?us-ascii?Q?C1oalyJsRUKQoO9ehiSdSs1bnPD5QdBN9rrBXoh6z2Cvs517aRntolVGw+HY?=
 =?us-ascii?Q?opn47g0JbaTuVz0zlFoQmhg1s85/58BOHv5vPQi4jhPlD0WRWYDXS4w+wcmN?=
 =?us-ascii?Q?Pb8AY8EEhapSSHXmrB4TO4e+s5cxE2MsGDq3VyrCrLFa1FXduEHJR9ZznxaS?=
 =?us-ascii?Q?x5bUpzthVR5cid5Nuo7Uv3cQQGtPFfPCSGrtTnxm6ptu0Gditul218aUYIwa?=
 =?us-ascii?Q?HrGpIgN0VSzEuCV1APiGAzN0Eb1HoPhbPvg9G5l4m65V050rAiuoa+EDp36s?=
 =?us-ascii?Q?nfOBPTrSUpb+StCotcDcPJdaJww3C8sSV4qc9sRB2ZaqitelwFv5yTSeMou1?=
 =?us-ascii?Q?ai+HaRztRCLYQumt1A8cRp10BijRxBzm6uhexBdJDyAzeMOQ78GaMEwP9YAB?=
 =?us-ascii?Q?aXYDtF3aNohukFCQPGcumh9EA+7Vqezs8JhCz+yS4nw4jF8XIW7Tl9ykK5dx?=
 =?us-ascii?Q?ik8PRG9dCDdysTGGOztx4AdLc9aYK1VeyOshu4ZM1BUE2U3mrdovD0cSq/Vk?=
 =?us-ascii?Q?jdp1QbzH4z2JqNXtbm31s2hwZZZhYv+3IbYxicgZ33w8XDoHIhqvqqxX0B4G?=
 =?us-ascii?Q?cLIXZ2ja1cV+IweLGV3V9UObZP4zeiZPQ7wqTuJJrgNA3XC8MCtukWVYK2cr?=
 =?us-ascii?Q?5PAdhFQl6zwxOHYwRAvve3XfGcI3HZC8pwTQbe3qZTqk8jtrCHwCr+rIebym?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 45711d0d-5e3e-42d5-1b2b-08dcd513ba46
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2024 23:19:48.7411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 673dELZo/C3fzY/iPfo99RAoDM8PmO6IDz3x4bjzI2Yr50As2h24zUHMzI82sbm5YbMsGZIaiiN0IXrL2GWZ4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB6720

On Wed,  4 Sep 2024 22:43:28 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> Hi all,
> 
> This is a series that contains a series of lint-related things:
> 
>   - Cleanups and other improvements and fixes, including removing `allow`s that
>     are not needed anymore for different reasons and a workaround for
>     `dbg_macro` detection.
> 
>   - The enablement of some safety lints so that the toolchain enforces that we
>     write `// SAFETY` comments and `# Safety` sections properly.
> 
>   - The addition of `.clippy.toml`, which allows us to take advantage of a few
>     configuration options.
> 
>   - Start using the new `#[expect(...)]` feature and add documentation on it as
>     well as lints in general.
> 
> Overall, this should improve the quality of the code and documentation as well
> as reduce the time needed in reviews.
> 
> I want to mention Trevor's nice work on lints from a while ago [1]. I think we
> should still do something like that: discuss which lints we would like to have
> one-by-one and start enabling them (and perhaps have a file like Trevor proposed
> etc.).
> 
> For the moment, though, I am sending these, since we would like to have at least
> the safety-related ones enabled soon [2]: now that more code and developers
> are joining, it sounds like a good time to start enforcing it -- it should make
> new Rust kernel developers aware of the need of writing them, which has proven
> to be a common request from reviewers.
> 
> If needed, the series can be applied partially or split, but most of it should
> be fairly uncontroversial.
> 
> Link: https://github.com/Rust-for-Linux/linux/pull/1025 [1]
> Link: https://lore.kernel.org/rust-for-linux/CD29DF8F-7FF3-466F-9724-BC92C14A68BD@collabora.com/ [2]

Built with clippy locally and it's all clean.

Tested-by: Gary Guo <gary@garyguo.net>

Apart from one `#[]`/`#![]` modification - which I think is fine as
long as it's intentional, everything LGTM.

Reviewed-by: Gary Guo <gary@garyguo.net>


> 
> Miguel Ojeda (19):
>   rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
>   rust: sort global Rust flags
>   rust: types: avoid repetition in `{As,From}Bytes` impls
>   rust: enable `clippy::undocumented_unsafe_blocks` lint
>   rust: enable `clippy::unnecessary_safety_comment` lint
>   rust: enable `clippy::unnecessary_safety_doc` lint
>   rust: enable `clippy::ignored_unit_patterns` lint
>   rust: enable `rustdoc::unescaped_backticks` lint
>   rust: init: remove unneeded `#[allow(clippy::disallowed_names)]`
>   rust: sync: remove unneeded
>     `#[allow(clippy::non_send_fields_in_send_ty)]`
>   rust: introduce `.clippy.toml`
>   rust: replace `clippy::dbg_macro` with `disallowed_macros`
>   rust: rbtree: fix `SAFETY` comments that should be `# Safety` sections
>   rust: provide proper code documentation titles
>   rust: enable Clippy's `check-private-items`
>   Documentation: rust: add coding guidelines on lints
>   rust: start using the `#[expect(...)]` attribute
>   Documentation: rust: discuss `#[expect(...)]` in the guidelines
>   rust: std_vendor: simplify `{ .. macro! .. }` with inner attributes
> 
>  .clippy.toml                             |   9 ++
>  .gitignore                               |   1 +
>  Documentation/rust/coding-guidelines.rst | 139 +++++++++++++++++++++++
>  MAINTAINERS                              |   1 +
>  Makefile                                 |  15 ++-
>  rust/Makefile                            |   5 +-
>  rust/bindings/lib.rs                     |   1 +
>  rust/kernel/alloc/allocator.rs           |   2 +
>  rust/kernel/error.rs                     |  11 +-
>  rust/kernel/init.rs                      |  30 ++---
>  rust/kernel/init/__internal.rs           |  11 +-
>  rust/kernel/init/macros.rs               |  18 ++-
>  rust/kernel/ioctl.rs                     |   2 +-
>  rust/kernel/lib.rs                       |   1 +
>  rust/kernel/list.rs                      |   1 +
>  rust/kernel/list/arc_field.rs            |   2 +-
>  rust/kernel/print.rs                     |   5 +-
>  rust/kernel/rbtree.rs                    |   9 +-
>  rust/kernel/std_vendor.rs                |  16 ++-
>  rust/kernel/str.rs                       |   7 +-
>  rust/kernel/sync/arc.rs                  |   2 +-
>  rust/kernel/sync/arc/std_vendor.rs       |   2 +
>  rust/kernel/sync/condvar.rs              |   1 -
>  rust/kernel/sync/lock.rs                 |   6 +-
>  rust/kernel/types.rs                     |  74 ++++++------
>  rust/kernel/workqueue.rs                 |   9 +-
>  rust/uapi/lib.rs                         |   1 +
>  samples/rust/rust_print.rs               |   1 +
>  scripts/Makefile.build                   |   2 +-
>  29 files changed, 293 insertions(+), 91 deletions(-)
>  create mode 100644 .clippy.toml
> 
> 
> base-commit: 68d3b6aa08708bb3907c2c13eaf4b3ccf4805160
> --
> 2.46.0

