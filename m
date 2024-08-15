Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021096.outbound.protection.outlook.com [52.101.95.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6C4558BC
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723746278; cv=fail; b=A8QECpZg9znuv2yNb3qhR2041r6AM1AEu+Rqd22jbKAbinhcQ6WBkhuuyy6/dGTm7LnG6hMKbUKTbg/0FIC+4oQVwieZJQtAwEl7V8ORPa9/hdCdIpjeU6413BAm4F7EZngtooM+aTePE9TLFNfcQvqKF8j3m8vLsv+NRz5Zfnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723746278; c=relaxed/simple;
	bh=qAk7k2Q5y1M+XcyRZpQ/LK9k8QrW7TLJu2kJ1AGFqzk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q6KTkGs5S13UP5VLFZKmxXJTVMBqfn8OzFm8tAhpQzPLmgOAbVeLtkPclYBHyODV1wcvfCiJ8NUn8KbRT+1+HLvASCLcM2VLcPAfCjCQe5iLw8K9ycByF/lpxRfhJctCb1ZKFDHeEkYv6TLLf39zgpvHN2VdjEbupFcoO4MLimw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=DZsIrNWK; arc=fail smtp.client-ip=52.101.95.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="DZsIrNWK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vakgLnqlYaM12JjXgBBC/+k9YVU4Z9Wk8hcA14eeeQH9359AFoIUgwv52q5CifoLk9OLpEOgmtZJVyXdiRa11xV477G0WMqZx8cOOd7kPxr2jdUiY+VzE/GC5/g7e+0vXKeu1ncPMNtqI/ZKJXWT/s6UMIR/l9dyN7FQ2n5I272xWcK6i6U+CHGVsHywXopNe/eQbT91VQJ0wHePN0kT2R9r2X2Bs7ZuLdw+eoTCEAfzONIbvWznLgRRK/vW919RgrnV9JFrSz7fKST9OHGx0RsG0BEgnEgm+gmQQu/DNLVHImlR3R3FR1PUWkJcJbY2kVSwMdQ7m/FRaWwzIqsHHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsW0Ai4Wk1GjxCW8Yrc6/D+5oE8ikNIOvwund2vsJ2Q=;
 b=AdYvvAqwfuXsJzIKgKISlUMBwSiSF1yJV9N3K1V/Y7V9aYMcFkkpIYrjXftIUOtc+9J1FJhtnShCHHzEkTk+bNio+LP4BBQcB2435F7UI6/a1+Ut9xLP4IqMpBntvi2MLf1ltJ4lDpW8FClyIabilYc63h+E/VIa9Ur3374ZkGdk795Z7SAe0cCVb+M4RVGjeFucxnapbqOWsyqiUgSqfnaXLsrlCF5K7/GlvfMRrA5wcWpcTbB/kPTxjplUDSWsWoVvOLL/ee7w25mef+3tO7mFtOaP7fGyzHP5vNxpifXNTt/ZDi77syDT1qPkV/6qKgK8wbWNm4nZhqRwT1EQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsW0Ai4Wk1GjxCW8Yrc6/D+5oE8ikNIOvwund2vsJ2Q=;
 b=DZsIrNWK9txSr10FRHObG7/7NkdbuQudmz+FmJIRmn7b09/eFScnt3MfT5nIuazLIUqiT+Z52h0XI8qoQeJ8Sq1Mp2yrtRSnzvQTsoStQrvOlMTrYAqdFpHETlFPFtTfTlc48FXwZFcl5n+35LmbRvik3mQQcRgkWdfTMCq28zw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by CWLP265MB6151.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:187::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Thu, 15 Aug
 2024 18:24:34 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%7]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 18:24:34 +0000
Date: Thu, 15 Aug 2024 19:24:33 +0100
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, =?UTF-8?B?Qmo=?=
 =?UTF-8?B?w7Zybg==?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, Alice
 Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: enable bindgen's
 `--enable-function-attribute-detection` flag
Message-ID: <20240815192433.68d97420.gary@garyguo.net>
In-Reply-To: <20240814163722.1550064-1-ojeda@kernel.org>
References: <20240814163722.1550064-1-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0033.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::11) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|CWLP265MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 925441ce-34e7-41f8-270f-08dcbd578365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W06t7VSr0lKfXxKDVbQnFORE0/TBrmyaG1enHHMZIqdAkJ32YQLI8eUr0PGk?=
 =?us-ascii?Q?AOcDDgSiksq1Wo1njByor5XLXAmcTBvG4JB1/m328RPTiwE/n0PPoNzd8DTa?=
 =?us-ascii?Q?S4ggnIvLocXR4q2CKcKhESnxIMKq997ZsRrek039YNzU2iVDuJRuIv0RhPcs?=
 =?us-ascii?Q?/q/lW1RciIoRfQLl31sAwxIADKv/kscGwgaaihf6ll+ZWKBsIEnRv+hTmvCY?=
 =?us-ascii?Q?1a42wQKkT7gNIcxcbdty5i6PjzKAplxfyEC3f+5ZzzGWIaDVtcyDjmFTaILF?=
 =?us-ascii?Q?Zr290yA4BRGD6RAHTmt9bY78RN5ObKplPtm7Wm1unFEj6pgoDvQV4ZKRDqWw?=
 =?us-ascii?Q?qoudjehLEu1glsPvkWg3EMfit6TVAAMSQrT33Aemdkmk/z3LvFe1k86uhA1z?=
 =?us-ascii?Q?BEPnaNhS0pSumgvn+F4SXBbrO1WZ1PaUsESPRNX+RuKxbGlrYD+8yGDJOjnE?=
 =?us-ascii?Q?G/FvHCxtb0SruaoskLkMoQq5C2cJJL81onGkF9iB+V8zUiKVMk7GekvSKk8u?=
 =?us-ascii?Q?76q8DIlbgHGj3h0rMUIjlqCvewQpbBAEf/ZSYFSlYw4oY2/4+Trzm20JHqjH?=
 =?us-ascii?Q?rYO/sYryx1v7ss4+UuyKfD3aLonu4NIW+VC4+lLvvbXGzAUfqz3w7wclfXdA?=
 =?us-ascii?Q?+uX25h3pYzg6t8TGI29qLxQiUi3Xs4ZSBZg09Ri2ea8knzCwqNZHkkL69lKt?=
 =?us-ascii?Q?aB8OwWs50Dwl45kwfwQ8H8bOpi3f/2/x0uBTPLWg2YMBq+IsxjMpV/23DFrx?=
 =?us-ascii?Q?zUSUlb2sM1veXdAC55nRIzn514DYujh61kqYBVNstwE3Tu3palHyrhJ6ZvkJ?=
 =?us-ascii?Q?yogvd3gXv5shW4OmZqT/BRvoeESlwfXaGzTx77VvNjN3UevY7QG4hUQOUvA+?=
 =?us-ascii?Q?ETUO6FvrqCVVcTXg7Csk+qZm1isvyYZdcTaQ8wHvTgYKTwAYw1rmcnS6Z7XU?=
 =?us-ascii?Q?9kyYu4eVj25vOjIrdUJr367fEJrs0iKB60t93Us72dafMDNlx1+Keu8hq1zg?=
 =?us-ascii?Q?Dtrq456MBJ3ornInMH6LiKwVFtmKp2X4r0F2ybV9BfjuytEh4JTDIaeoZe/+?=
 =?us-ascii?Q?/Tps6tTW8MrK6+lGJXCi4T6cEOlxC5eoNsEz2SMqAx6dItMZmYvwQZ5BFUvp?=
 =?us-ascii?Q?3jxx9MomTxvEjfJTSkbFLLbA+TLVY8KupH8dzg03CVxkDTN37qxTj1g5wyEn?=
 =?us-ascii?Q?4wVzb5YypT1pAVJ6ID3h6DnsoKjP/GbJDVLMI+zbREcvcO+vLnQxkI1kTg3A?=
 =?us-ascii?Q?eHdnbPEoKtbbcp52vXt9+Ny8ZHjwOQLVvFe16wsiGI0frulZwqWbZvJcRbAb?=
 =?us-ascii?Q?xZQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EwPjKVOX9cE5v5YY1LuPY9C8eNYBMbhsrowS4cUjayM4k4dwNCbC4Tqg+7Vo?=
 =?us-ascii?Q?KvGxUEjIvGJhBx8x9V/+4tUDDmlAW33Zkc1L93YF4GdHRutJrdrtkqI1duRQ?=
 =?us-ascii?Q?OQ3IsGBmkBPLR4gRH5ENSvMM1vO6qOst7+ks9omf9oga1R09l4yRGC7ViMUK?=
 =?us-ascii?Q?SmeFoJBrJTflFvsbIpC12xKY7J6rr2YpbnsDQCrAZKSnzoTcO+93W+m8rSNz?=
 =?us-ascii?Q?qPS0Growd4uYKPQJBBkkFe2h4mmDsMtlb0W2Su5WByUcbXETSVCL+02D1O6W?=
 =?us-ascii?Q?Vi8km3pH2tDncuX+6gXwJqUJSl9UFsh1bbRji78d/hhKyWQLAh1nhDdN6FT9?=
 =?us-ascii?Q?S8yhMae3vXYemjolNQrf3KdvWeaxcgBu6IU/tKl8U9OhjsO/w85pZolFnzrz?=
 =?us-ascii?Q?rUR8BbxsqqRyQ90vorYLxiJ4Ruwkc0MxRs94ZLNdIjnFidECGB3NyeKAbH7O?=
 =?us-ascii?Q?A3NsbTsQ/MZomXWrnuQ5VwHti9fApVragwSEitI1qnT3BvccjpktON1VhnFw?=
 =?us-ascii?Q?W/u0uZr+ZvPmBKJ+DqkXEF3DpvodEtUmEtmLRzBFDzaUeHgcbfE+Fm/ljHYw?=
 =?us-ascii?Q?qUg8T3ZJGdgo20XsnRe0UqUfTIdkaTVk0UZG+VOW6xWWdpNM9BNPynr00tBu?=
 =?us-ascii?Q?DLglKU3ZAKjY2bkQVcdQ9do6srMJrd85gVrettlUqAGH7YOG1tTl2zIEKkku?=
 =?us-ascii?Q?GsJ9/LsGAicsVSfc/B20/rAxlhLuhvhTs5Ac/GX+ISX5KSnq1wWEhE9OLWTs?=
 =?us-ascii?Q?CBQwVjCFQGOV2A/PFTopvLuvza5vajH+3fHeGrw+o1TgCnq0Mw2tCzdVRti9?=
 =?us-ascii?Q?zsI9S+7rRtYSpW2hgzHi0WfYAZubiNfw3C+ILPVBUpTWnoVLqW1ZRPMGdvYi?=
 =?us-ascii?Q?CroX/FTiTxpaIBQJ1ivmJGpl3K9LylI99FHd+k4a5JJs5df/eFNkZk5R8frn?=
 =?us-ascii?Q?pf2VYvGemXo1MkY4aJ0XQot9MXhUl+OoH9clO6Y0uQ7+UU5HKtQYM4U+QZ9M?=
 =?us-ascii?Q?Hw0nkA+5bjJnOVeSMfYDXi+ekZ4ZBQq3xO6GqDlwFrpBk7L36T4Ajnd8ir3o?=
 =?us-ascii?Q?XYLxxEbkYxfB2Fe0I/JWQF2DZLAdsro8DfwBEnTi5bOicSlsMwuk5FanAymS?=
 =?us-ascii?Q?EmZU5jEo56JNH/9aP04u8ImdJzKzY0YhTbNwgg3EXJCMnrh1/P82Guw9WnOF?=
 =?us-ascii?Q?3mIG6ft8HxsfsnkAIqPd3kTdhHH1XyEwYgkb12fL8sRY/0z1PbBRxquIcT+f?=
 =?us-ascii?Q?MvxXkDaa8E/XptcO4IAsvYb5Ltz34l3ueqcrg8Uyrr1/s9e8aBUYS8RKPS+o?=
 =?us-ascii?Q?xW4ePbrNVT6wpylqJ80hOKBi/oHFWWXdUTb4jaKRxh1bZproFk0twJ01LW3W?=
 =?us-ascii?Q?2D5P8VlQNCnqDGvDMiR7SxmcVmd8WcP84oYl+Lq2GT/g75QTPwNwsfG2yPre?=
 =?us-ascii?Q?xdc8ajS8tBCpQ5/c2QFYoFWnap2etYEFeMLegaWjOYvneBRaPRKpNKpQQOyj?=
 =?us-ascii?Q?cYONYEx/0RbRDaygYAwLDAGiIW89xZE6jkR4AV5Mnp63U7gsGHUGQNWrUsFh?=
 =?us-ascii?Q?vjhfKDnESFYIgHl/nt++gZaaS7/zIilFaxEpfP6w?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 925441ce-34e7-41f8-270f-08dcbd578365
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 18:24:34.5197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +vk1ittp8TkQjAuRh6VB1TALsSX/1wKWFz7/3aJFpK4hlpXPARwGgzuW5DqI9yjTqdcl5zWezkd+4LcAPLso6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB6151

On Wed, 14 Aug 2024 18:37:22 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> `bindgen` is able to detect certain function attributes and annotate
> functions correspondingly in its output for the Rust side, when the
> `--enable-function-attribute-detection` is passed.
> 
> In particular, it is currently able to use `__must_check` in C
> (`#[must_use]` in Rust), which give us a bunch of annotations that are
> nice to have to prevent possible issues in Rust abstractions, e.g.:
> 
>      extern "C" {
>     +    #[must_use]
>          pub fn kobject_add(
>              kobj: *mut kobject,
>              parent: *mut kobject,
>              fmt: *const core::ffi::c_char,
>              ...
>          ) -> core::ffi::c_int;
>      }
> 
> Apparently, there are edge cases where this can make generation very slow,
> which is why it is behind a flag [1], but it does not seem to affect us
> in any major way at the moment.
> 
> Link: https://github.com/rust-lang/rust-bindgen/issues/1465 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72=u5Nrz_NW3U3_VqywJkD8pECA07q2pFDd1wjtXOWdkAQ@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
> If someone notices a major performance difference, please let me know!
> 
>  rust/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rust/Makefile b/rust/Makefile
> index 1f10f92737f2..c28b81e2a5fa 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -270,7 +270,7 @@ quiet_cmd_bindgen = BINDGEN $@
>        cmd_bindgen = \
>  	$(BINDGEN) $< $(bindgen_target_flags) \
>  		--use-core --with-derive-default --ctypes-prefix core::ffi --no-layout-tests \
> -		--no-debug '.*' \
> +		--no-debug '.*' --enable-function-attribute-detection \
>  		-o $@ -- $(bindgen_c_flags_final) -DMODULE \
>  		$(bindgen_target_cflags) $(bindgen_target_extra)
> 
> 
> base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
> --
> 2.46.0

