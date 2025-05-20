Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C08F2882D5
	for <patches@lists.linux.dev>; Tue, 20 May 2025 20:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747771856; cv=fail; b=JX4fXI5TYjgqzDrxwHgsuRCVoHAjQ+Omixe4k9ANP1alVsHMus+1Ev4f5P2vVb8OrmrgmkPmlY70WaJ3pDEEDbWk8OcghZRHM6bWNFx0IflIKPj97nsKY0M5uuvq62Twgp2dKbs/tbntlC2Zrs31UPCv3cERjXPEo5Ni9Td1G4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747771856; c=relaxed/simple;
	bh=H3uNiNVH4G8ixJeGHpxyoUSLgVpBWHw5chpxhe1mUXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dLGKj06Xd6JJOedVQTJ/dYoVwQm9rbbIp/waZFlbZ+h0DHscoPUtr9N0gg/e7fAXZ0FFjv//Ue5Hw47W5feA6+AfhBDNldMFYR4j+Ep3FzEUCGhDr71L+9ERPl6We0O37+ZtAWp0D527vYQK7/GRU3Fp3GBEXnk+SO44naalMoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fXe2/tv6; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fXe2/tv6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H/vwzSSI049x425e0xwFBVKu1eruGl3qHgswOpNgmPrtFBHuBEBGID+y6ibyv6rh+EABFHRlX5kt1SyvY5v6ByH2XPzdbzJwLFPX9V8RdzqyExvWYO6ov/7fNNoQEU0pV9Jo05g6Ps1IRxGP9X8BkvPJBiuvzKGdUHhccC4fzhGaB4UMUKkhBxXYGPTmCmjXi+VxWQFNQ1POCFyRjSDdo4IcLh4N7I4hS7M05vXu+BflsSejZUnROTzasBp45EFrQXYrarheWO05qpy+cu7YVENKAq/NbVpMfVpmIxXRDae5xUe+dqoM0h2BaH2d2zH8Xqih6lsTsQhxvQIJdmPzHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnorzDaYndn/gYmHd6dHKYT3tOYVS/WnBik9MAmAB7s=;
 b=aVvk41i6FHj4PITAfLVr6OItoamttXSRVvMdRRylc+7lm7OZHgmkCILsyCMgaLvb0Ers7hWir7doevpsazLfgn82yEMsRm+qdQzcwN6nz6/OCczfmUXlQFtucRSCKk32iMpeMT9/ExdtFSpJOHg/9kj9brbZRva52DPjjAnmdh37ROT59sCHGajLGWP4/rLtto02CAWaGhrxieKnz23AHwdlYy3zv+pZiHnSoPmCuwgOGP1DczeyiQrNaZ4j46FPCxHnlCy3+yezyrV0BzD2RuGUL9X/J2J4weqwMmEiAZT5b2dWDc7OLUvwMBHZiETCJMKDcgKCI0dLOJ0sPR2Nxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnorzDaYndn/gYmHd6dHKYT3tOYVS/WnBik9MAmAB7s=;
 b=fXe2/tv6KQeQ0AcMNLSgtL4p4wK0EjESKJitsSl4hb7YLl5H1PytzmqYfPpRrh4F9Dh+6/Qh82W8rcKNYrbKlZLW8UxzRlOd1r+OsVj4jiFOsxugmhyVxCMvIoFxF2vpPYsHbPYRgdVb0bsTPLieYySbK5Cew7rnJBPTCvQ6ZyMc1MQQZV43MddmUPVeUCX5J77cQiCJ046ybRsLM9B1WenibENMqAnOcdTRl8RAWMTAuiwnMtszDnVFG8RIRKAwQ8vB6j0s2YHpNJUJ9YYufiXAeqCSg2rRKWt9yGqylXNw9sGACZAsg5l7TpOqV+XbP5K22xEv+CcyqSPkDG1+UA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by SJ2PR12MB9242.namprd12.prod.outlook.com (2603:10b6:a03:56f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Tue, 20 May
 2025 20:10:50 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%3]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 20:10:50 +0000
Date: Tue, 20 May 2025 16:10:48 -0400
From: Joel Fernandes <joelagnelf@nvidia.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	stable@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
	Timur Tabi <ttabi@nvidia.com>, Kane York <kanepyork@gmail.com>
Subject: Re: [PATCH] objtool/rust: relax slice condition to cover more
 `noreturn` Rust functions
Message-ID: <20250520201048.GA3979982@joelnvbox>
References: <20250520185555.825242-1-ojeda@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520185555.825242-1-ojeda@kernel.org>
X-ClientProxiedBy: MN0PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:208:52c::31) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|SJ2PR12MB9242:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a09c0de-c221-4470-ba0f-08dd97da6ab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2kP1B6OGE5ErxS1qrFATHKw+o1onsI5YVxRgMWD5giManb0JMZ9KJdERzh52?=
 =?us-ascii?Q?465cQeYkpxBOlS4ZOkFBfbY/l+y8X051Ivz7S2iK4IhCgbBCBehysDkOg1Xf?=
 =?us-ascii?Q?WkZ6n15rVoFQuKL6mYQ1Bk2y8dY/86Ekvu6d+UQO2ZoZO/qDSNUyVTpRouRl?=
 =?us-ascii?Q?3ypX2PE+VWWrMLh/ETjpphbYAcaLZHDwrikUNxV27uof7j7eRfezOfG5KSKv?=
 =?us-ascii?Q?E/bUPrU/53DKEZY/oVkX2/MLIJLMyURJAnDRorlXgw2+u40j3h678QTP+EjU?=
 =?us-ascii?Q?j55vGPKg5r873TL2BzbwUweudFDjr9/FQBWKTV9hNIFuNjgJgNTQ63UDSizZ?=
 =?us-ascii?Q?EP+YIQN8YGZESRnddg4SXnHwqlIl1uX6WV/5VFjTCg6zwGKfdga8MV2vn0Zd?=
 =?us-ascii?Q?hAB4Ei4tsVBexjFZs0CsWS7Enelth2OV7t6NAKh2IzNRnRsqrLEAMNH2cKi6?=
 =?us-ascii?Q?97+elqlFjxb6zXaJprpy4HjWshAs7ad77QDCO6JOv8JK4fL4Fv/oO6E9EhMU?=
 =?us-ascii?Q?BTTg1HKpNxLFMCLYy4prmi+rcKuOR+etaC5eFq3B3EsT7cbEhNtiJIhHTwf4?=
 =?us-ascii?Q?LrrCoJQED2N2JvfJA9ndbtRnkWjfATsD52p1raFpzRfzZqG9g/Z1UX1VbAXA?=
 =?us-ascii?Q?WkbFifMrMAn8oxhmaq+Y5hMyyDAQEcLcas/p9yq7DUVzNXcR6hLOALc1S2Xv?=
 =?us-ascii?Q?qfJrJSC+D9bNPYDFn07nN9QwOtcNRukSjS4paoUAvdqgYsqAYPT4f6m230Tc?=
 =?us-ascii?Q?YROLC7EGP3q9YMOgNWvlPy7e6zye8b726tA17cWOW69NpeiWr5F+VhuvPDL7?=
 =?us-ascii?Q?pKq9wK3DKk7iQllUXe5J3aPjP0St2VC2r/yEq3SndthfE1nMF7WFXLIXZivl?=
 =?us-ascii?Q?7S+GCzPATpq7s0o6BKJHJnD1E0HTJFnRmN6eSv/EJTsVMy57ogs1cSnZ4cMf?=
 =?us-ascii?Q?LZBpTGSPN+iwv2f5JkP2Gn6mx3FDtW1T/WXUmOkf+X+dbV9ZJVJUE60gHDAo?=
 =?us-ascii?Q?njndgrOHVoLAAe9Cjy4sHiJOYFM+YHDjox6ewthQYOi+aLXAJXYkjNSALDBX?=
 =?us-ascii?Q?T02yb9rt0vep6PEt3izC6cQAWeEv5MKGGQfMsZLpB6JBGThQLzWZdjyE5EWE?=
 =?us-ascii?Q?OedizZyfUVyI9dw687/d9e81kbFPJOABMRwARWrcaiTlCK2KT6sMoU0FwmWQ?=
 =?us-ascii?Q?Da6CckqJCx8S9gmydnuQnDTnf8SS5HOEFfc1wDbVGhPzdI56vdAStaYd1tQ3?=
 =?us-ascii?Q?70mSNLqGvMXiWgjsl/mJ215GIYFDxlBuNUVZeHdVSpkIJP07I3pqiqrJmAgi?=
 =?us-ascii?Q?aTodo486siTssqW7gDz1A5kFJ9D5AA9kAlzTBzK6XXr6USXgtuHrl3tAr3M7?=
 =?us-ascii?Q?KClKpvkVhY9WRwtdZLbBJm9kYLDjPnTs7BdeaDSilmW9EYtez/SLKDz1lSCu?=
 =?us-ascii?Q?uTkf5Ouku1I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aL8kHYXKYgWXzsJTWW++RATXPDjYRYpPgiVJgDqMWsb21dmWwUhvgBnh4jMF?=
 =?us-ascii?Q?ngBY4kN5agKWpuzJY8LAesLmvby+GgaCvvV1e7NUca/WRoSIJc2mG0usIVj9?=
 =?us-ascii?Q?jYj5Ir4m1uspHFetB/x6dAonDrzyY0h+FAHq3yeUXjXHNKyrHvxR6RakArzs?=
 =?us-ascii?Q?leepM/78mFxm2/71RsBRSDHfa3xOIIUOxDtYIOHdk+s2zH8SV/vslQz+efKD?=
 =?us-ascii?Q?c0DA21rEaHgSBr+XHZlTZTWB86WqEpkcfCwzrQPVwPX4kw2JqlHtM9Kklp05?=
 =?us-ascii?Q?lY548uNdV/tnclrQJQRbZTmIuESa4OJ1AyzforFRKjLQKR7FG9OTZcd74b5c?=
 =?us-ascii?Q?8ZGf7UtOzS7HocFidGq0kcGLz4+DQ5WRh8tADX8gHeK4yfT5HjVPHuCakCyl?=
 =?us-ascii?Q?7YvB8OrRJpnFtG4ut+A7d1wJaHDRHt2+VVhjcfoUhh20cA2DuCRdBrhQZ/Yh?=
 =?us-ascii?Q?73+6FbziSlFTBx/MeXSpy34IoOJkXIZ4YVXbNPuC6gCL9bJ9rF0HXTVQzOKZ?=
 =?us-ascii?Q?EcxphsseMrvuPUX4OtgvS6Y9UdsW7Krq8NIM4rpivoLmP/PG07AujaLvmDBW?=
 =?us-ascii?Q?GNA7+r5TV6E5A40IO4df3uIzF3j/Xtl8Qzs8bEbCT2NHtwd1Fekx84I5X/+/?=
 =?us-ascii?Q?ZHWRMfNV6hA/JoRx8Lhh5bZCifBqDMoW/zhJTDlwqKq78TNx7oNEJ07omQpK?=
 =?us-ascii?Q?WMGUJ5N+AkvBdgKMU+xc6oNFTpTfIbxodKJ6zbx6uzX6ei8vnAOmTNLYzsvM?=
 =?us-ascii?Q?wgzzAVHy53boqopAm89Qno5jVFR21Zbn6vJ+q7M3VYWOnYkLSHF2Tk0X8Ffm?=
 =?us-ascii?Q?W/lUv2cb3NeIXgpqukjuom2bQS++9kaoAhwSDdp2+5pih3s3/Fw19Pmv3aQl?=
 =?us-ascii?Q?VveNIpl5BxqbCrKQx10ZskRbZ9Z8Ny7ZlyUQtk6U+m4vkj0FIlsp5L9ebpua?=
 =?us-ascii?Q?31MQozpU4chou9UDFQvTw8iOSwyyyuwICJQL1+cUdhx1WZTAvod2O0EBvuq5?=
 =?us-ascii?Q?/UayHPqPyXWiQVU5t6Yh0RsDe/auheGJW0lbGpEGFWxbc2FNB7FU32yMhW3q?=
 =?us-ascii?Q?eJIXEMRN+NFXDfrvofkAVaW294JzC9pqI5lOBSTdmPrPOChCSrCAV6+j1lay?=
 =?us-ascii?Q?x2zEPqhL0LEYgnKKlaPc5xAS90S99f4zUwSWnE+1Xwptud6giGoW+eUd/tTn?=
 =?us-ascii?Q?MaCZO6GrXe/xx2pyzTcyJo8z6IXQjs+9p4nmGmPq3FlQVDOQ8ryfrZ4mC1f5?=
 =?us-ascii?Q?w4EXr3KLmf7pF0UVsxcXgecT2reeH+77IgaBGe4W9aflwzMXMw55HGOZg5wb?=
 =?us-ascii?Q?lkotv2wRFqCjM8FKAW5UbfcpLhSM/SEhua6AArqx03ku9OF/DcQTSgjgZXQU?=
 =?us-ascii?Q?Y/HyoZ+mcCsWUpinebLqaWBTU00wSkm5+1A8gMvPhj5Wdf2XrRIISQ7BBow7?=
 =?us-ascii?Q?YC66F3SUA66d+oZfit2P4w+QTqjpZMEYYsQBfzRF+aocjwUkZFLhdlQJe0z6?=
 =?us-ascii?Q?Bb4LqdZlVXiojZjbAr0xF18KBxaa+SObyw19t8XDZt0UWETzHvqc6AhmK6SQ?=
 =?us-ascii?Q?+a2PMQxGdeqflr6C4Ryv1V2yNzWV8nZuprHnjG1P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a09c0de-c221-4470-ba0f-08dd97da6ab8
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 20:10:50.7143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +GSZkzA4cdhpGdtboT1wOImHaAEgzojY91X0DElScH4a8LMPdYoyMFoDg/rBacF8RlHfcwmrGDhg+YxFY7tqsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9242

On Tue, May 20, 2025 at 08:55:55PM +0200, Miguel Ojeda wrote:
> Developers are indeed hitting other of the `noreturn` slice symbols in
> Nova [1], thus relax the last check in the list so that we catch all of
> them, i.e.
> 
>     *_4core5slice5index22slice_index_order_fail
>     *_4core5slice5index24slice_end_index_len_fail
>     *_4core5slice5index26slice_start_index_len_fail
>     *_4core5slice5index29slice_end_index_overflow_fail
>     *_4core5slice5index31slice_start_index_overflow_fail
> 
> These all exist since at least Rust 1.78.0, thus backport it too.
> 
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later.
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Timur Tabi <ttabi@nvidia.com>
> Cc: Kane York <kanepyork@gmail.com>
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Reported-by: Joel Fernandes <joelagnelf@nvidia.com>

Fixes our nova-core warnings.

Tested-by: Joel Fernandes <joelagnelf@nvidia.com>

thanks,

 - Joel


> Link: https://lore.kernel.org/rust-for-linux/20250513180757.GA1295002@joelnvbox/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> I tested it with the Timur's `alex` branch, but a Tested-by is appreciated.
> Thanks!
> 
>  tools/objtool/check.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index b21b12ec88d9..f23bdda737aa 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -230,7 +230,8 @@ static bool is_rust_noreturn(const struct symbol *func)
>  	       str_ends_with(func->name, "_7___rustc17rust_begin_unwind")				||
>  	       strstr(func->name, "_4core9panicking13assert_failed")					||
>  	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||
> -	       (strstr(func->name, "_4core5slice5index24slice_") &&
> +	       (strstr(func->name, "_4core5slice5index") &&
> +		strstr(func->name, "slice_") &&
>  		str_ends_with(func->name, "_fail"));
>  }
> 
> 
> base-commit: a5806cd506af5a7c19bcd596e4708b5c464bfd21
> --
> 2.49.0
