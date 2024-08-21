Received: from GBR01-LO4-obe.outbound.protection.outlook.com (mail-lo4gbr01on2124.outbound.protection.outlook.com [40.107.122.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3621494B4
	for <patches@lists.linux.dev>; Wed, 21 Aug 2024 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.122.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254134; cv=fail; b=Ll36lV/1+CqLLdiT+iD5hGsT4MUXlCk7GQixBkiMnXZkdsgDYPuWTznC+wkk12r9Dbcq46Hgyr5RseVyeMJeFcMjv3NwhgTKQok8IAqAsMwFxbpmsGOX5TMvHHvZJlMqoEoALR8HyHGTGQD+pZvkRbwkJa/Yn6C1ZxsGOaSVLT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254134; c=relaxed/simple;
	bh=Lh1TJSX+heedhZtKLaG18g6jb3FQsx0Rt7WTJikzO7g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UjArxFrBrVn+P9ehVOPqYIDW2FFi0azk24wDg9BOOmpA+sBpfJfOIGqMpzrNZyzv57w4BZWJTfQHIrzBYoIvPDPLfxSdDfcTFoB2sqsh+vPYHzVcubfAOiykOqXaRSVZFSVV4jXfb010hmSVWlM8rvsP3XgkQyUH116DgdBAaK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=o3bYRDsh; arc=fail smtp.client-ip=40.107.122.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="o3bYRDsh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGiJQ3CGBEiRbsQV+tVv/DQYwl+8moNZlvsTxpulQOHY7TLcklGE3JvMHiObZ4XRC498dxjItP00d29Mu4sVV+fF3eads65+oh7J5Y7q90n/CQIgCd5If/wNu3ofTxQ1LlBbsmLMlTvdxS8bTCFvoY9LzU4J3acEVG1laySrrv+xspDq1k+DcrOrhDEXQiz0deW5AzRZT48+MxvgDPQTo/alJNXoPsyBgAhmhmFTYsQvPJZ2LQH9NC5RNRr44pZP/6l43H2YGV5S2yCyG2d1At6pXUex2rm4MdxtQA/khiHIysbMithz4kcHeZBxTvv7+bTAWXIw0glAIu/Q+JT/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTawsLwrHQjuLS9JuyRYrV+uQahpEvpFD23ifVUGdNI=;
 b=LwaGA/fcb81CA+yudBBvC+wfA8RfHUTu6FeV2KCDCv7q2k+3n5sl2GqPvDJIFbZ6zbif8WovD9CRhZqIjRdhrUtEDjCHeETZY41iKOhvXU1gj9W91OAMMXRna6hESm0TvZ2rG095XNVe5WbHOcpEYDjdca+A6HBVGIZ6v45X0wbkbJlc8TRujrBRHYuyjf4X7jz4CvmqwzRNFvs6SxN3K6u5FhDESF0S2U9gfVUwgJYugOR0Z4NrCTX3p6+ZMneHWuw2wlMMFbf4M9UGaPhkCgChc8q0i/DWyQ1LqBwuul+q0Lcwb5CloG/2kY/i/uH1Ajjr5Ovk54xNYuOgaUCIsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTawsLwrHQjuLS9JuyRYrV+uQahpEvpFD23ifVUGdNI=;
 b=o3bYRDsh+v5gtzonV7QMGKgB9XE9N6hiNoi+rATbxecqcFUqR0AAiEQTFKOySEe+SajWC/0sbb7WefnCKt42EdkOUIjy4q/RDNhdcnPV5tY3E+UgVDrTmdryMTwubCsqe/TgO8t5c1kQ+0M9/CU/jg9vFoUf2n3YfsBOHPfJLEQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO0P265MB5957.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:289::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Wed, 21 Aug
 2024 15:28:49 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%3]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 15:28:49 +0000
Date: Wed, 21 Aug 2024 16:28:46 +0100
From: Gary Guo <gary@garyguo.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier
 <nicolas@fjasle.eu>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, Alice
 Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 5/6] objtool: list `noreturn` Rust functions
Message-ID: <20240821162846.5f9ead69@eugeo>
In-Reply-To: <20240725083355.GD13387@noisy.programming.kicks-ass.net>
References: <20240724161501.1319115-1-ojeda@kernel.org>
	<20240724161501.1319115-6-ojeda@kernel.org>
	<20240724203549.2db3e36f.gary@garyguo.net>
	<20240725083355.GD13387@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0258.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::13) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO0P265MB5957:EE_
X-MS-Office365-Filtering-Correlation-Id: 768fba38-a5c8-4e0a-d00a-08dcc1f5f45b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7vgXb/dSgm1yaK1kzRUFOs425ZIdLXzbTfyia/fF4TXsu0oodYC5B/Ffmwlr?=
 =?us-ascii?Q?/ZUZUw4OQ+wC+Z7JqQEtPkrEm8VQzalWEJHCRrAQLQgu0P2Ct3nG0dm8k6W6?=
 =?us-ascii?Q?bmcQB0HxGTL7lRcHp3JeoTg4kLfyj7XxNzD6y99jFTGv7ZMcHULm73lx8auE?=
 =?us-ascii?Q?A2szb/iR3liaMlz2CstqPu5aK34qQgAAaN2sEiJMe2G38pNDnLuXvmIAFHaG?=
 =?us-ascii?Q?ECPsYGxSrLMraumJCoxHUoq2zDYwl+1Gx1uinPKlU3Mijwlgsm1I6s5loDTv?=
 =?us-ascii?Q?DoIsYm0lb5ppcmeCPhTD3AMnXWnoeogBY+m+VxVSAdeQyQYJM9rnuMRj2F0v?=
 =?us-ascii?Q?3qO0tOzp+QAbeqVPVZ33vMkxXxF2BWuEKquswjUv2zayLifhob0IZ+u8y5RI?=
 =?us-ascii?Q?wQG/Ebhyio+jl/xir7x/WyczDWlj4DpL+3UbVvo+JHGNSK4lfZP3d5+/IcDb?=
 =?us-ascii?Q?9gSVLjM2B+RJc//1VJwMjtA2MvFwUFA/4jbYd9B7WhlqWPhlSsnbUqzQhif9?=
 =?us-ascii?Q?wWOQ609qxN/ryyG2QEjZ6+vPNy0BcEAo5ZWHdqCEdjkdF9ec4s2vdmprCKOB?=
 =?us-ascii?Q?2ERP4DF27fulKl3VBqcSuMEZFXVzVZm2zXaWIgIvQ2Al3gY1vH9NaEWqKQLD?=
 =?us-ascii?Q?QLKZvJArdc4vK2BvInRAOY95X0MqfvyRPiyfRJ5qwx7Il1mDs7+sWowhbmRw?=
 =?us-ascii?Q?DAM0PuXPtQRAuGHKs5kSlsUjvwz4u0pxLyqCCuiM3zlqtZtKvaoOY4NmKnBt?=
 =?us-ascii?Q?ApQIycm+tDpKrDLQJvh6HAiwpzgwdkrAvzmVKOOSfS3urV7Wl6lYkGYWxZYN?=
 =?us-ascii?Q?Ta5EIg5sa2MTya/8J+zDa+58b3pUCV+hzVGKYPtdP9nUV9naoagu2cv/PCt2?=
 =?us-ascii?Q?NksuEn4xJeg4xQIARFN3lkJntQhFIPzWLTxwh+cN+q0M/Y+B/4yBfSDEPFi3?=
 =?us-ascii?Q?v6Xu8rbl0VKznn2QLI6x7m38A/jQR7gmeITwj2DWYUeKWXgN8UTdkPTGJcVR?=
 =?us-ascii?Q?LXfW+3habpj8qhMcs1Uo1LK3V9KIdcC1W2k2MJjP1NGEF6MKWrWoqM6OjH8M?=
 =?us-ascii?Q?sp4I+5EqXcdb+x0QjEiJ54nkoWPZ09YQGTj2xd/2VKOJj2uhoKvUI8u6nWsn?=
 =?us-ascii?Q?bZmMUBr1DBZfBvNgDoudIqAsC5rlWHCBvWa0ruu4RGm/0YlEF2KZhCJg7wGT?=
 =?us-ascii?Q?KnpJv5UfZC6/VRtYr3WaHW73kX6sOQ6a0AvsfN8OjWa0odpI/VYULNa7By/x?=
 =?us-ascii?Q?UaL1ppl03re2g1PrK9NHWGR/1BrDsjq0iZAO93zM9MkAdH4fNwkQAVgxKxUR?=
 =?us-ascii?Q?NcA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gdeMwS+jlBimXlIpI072w0xCv7MGlL2+/Zfu/sXHbGqbbo/TOKtaH1U+9q/U?=
 =?us-ascii?Q?4jmTmU1kSgd0uhEDgAZ8+RSYvv3Xu6FIokprVXILLJiHK99Pko/IiF2/ctKv?=
 =?us-ascii?Q?KyTrTwR4hdgFgh0HMxWqddm4zwMqHjbmWGm2F7sF9zLpYBBpZn4B8AzO31Ch?=
 =?us-ascii?Q?fbzVVRV9E1Yx+giNuY7DfGLc+uDVtYAIIuL2Uqglu8/UYH3Cy+qHVN8Rt0F6?=
 =?us-ascii?Q?nUQQHlejhWBR7XqJxACLunc23rnAuFUbBcGDVcb37OjaCp/d9OhHUfRJlYq9?=
 =?us-ascii?Q?MEedvqC5i5G82JASyuW7ZxGKSFJDpuvtfovsrmxWGm5y0Uecba6fogfm5duK?=
 =?us-ascii?Q?QBihiG/GVyVK+NniLRKq+095Etxm04Euney0GBMM8y9oalfeD3CuAq9WQlwm?=
 =?us-ascii?Q?QM0Ab7q0C/gznjrjkDJOBSRflDiUo8ul8W8ZUSZ7DKK1BwiMIt7yVuYneXzJ?=
 =?us-ascii?Q?CwLAJk1C2QAKvh3u1RL/jwirsYL7Jr/BoX8tuFX//ArxQifZ0zwFJ5Tv8wh1?=
 =?us-ascii?Q?+N/p1zCH40/n38Obbwsrvwh1cFH64Ha4ol6dCM4euGGroOQgW5KBj30G/nQu?=
 =?us-ascii?Q?CZ9oR/AakzExAwEZVx6qjfmDUuiOZmOdK6FkiaGvvNeQGemAx8+8cQ2T9OPX?=
 =?us-ascii?Q?6wlICn9T+fn33PqlAa4w0L2/bOqfiVa7b3S7cBA91WWVc4EQ0x6wU3/gSBeI?=
 =?us-ascii?Q?OSUdgfoj8ZyxjkPjRVXYhy9AQWQuRFvaG1rTnFyTrZAJK4baWbFd3kC7HnMB?=
 =?us-ascii?Q?cYGEpa5vFH17+e6zquqXTK2mY9/qKACPom7aV9mRBeaXRTzaEyKMfAUp5M+Q?=
 =?us-ascii?Q?0463Bacq9hhqPwtn7gHpOyzMtr0rnMoYDSWYQrPuWibSC1lSVI8fOH7K0mNm?=
 =?us-ascii?Q?S2TJPxsbAg3bG3m94KyWqVA2JlDRX++xjQ14TCanQKjIUFQqu7+uga1XUq/u?=
 =?us-ascii?Q?61jrJARqBepmkiaq9nJRRnCNSWen4EnKFPUx3PUNKV5OQGsB6TicInB4vYfT?=
 =?us-ascii?Q?JmR9RePQ6IGrDlW8icVvaXIGLz5yyf5XIU2KoOIJDhYTrGE/++cNWN0Vmk/7?=
 =?us-ascii?Q?RvLntqxf2eGvyxjCPrZ5tW0wVK1lhqlw6r2mCUahR0GBNzX7DnH8WONXgqQR?=
 =?us-ascii?Q?IMsCDXzvci81nfpPMWkVFb5jOETVIdgNvhTtV/Jtl21pKokNlMEaNTE6rl0w?=
 =?us-ascii?Q?sg/+OSMC/mqs7NEaB9ns5wkIAUlMtLFI5W4Yno5grIpWLt2jJYockToAOf6x?=
 =?us-ascii?Q?ItIdDOd27YcYEOlQ0/NZdBHy+z9el9UHCWSr+Zp8EWsdIX6bbMB+2j8n28SC?=
 =?us-ascii?Q?sUMU46kz2od8sKlRxSRqhXm//lV6Qz0j+rpQPSg3n0o7zveH5V2XCOm8gXpG?=
 =?us-ascii?Q?r9cMd7R0kQeERIa4w2FGTYJpHuEIK2BjWXDJAhfHK9eOq8QltgJhsAG5u4MG?=
 =?us-ascii?Q?HK4fmucXh2R7ywsSL+a4CHTrd3aRH34Qg8rDnTQBouurW7sq0/F8xxBLN29q?=
 =?us-ascii?Q?T3FpWAgzkDgo4a0NtUxmv/U5qguxwHnWZ5PPuSVaeR2q4DbjGjiFlDznrZXk?=
 =?us-ascii?Q?rozXy1LIk6v+Cll7WVMoqVIBuqQIPIwymjG1+3/s9T0Cvpjqstro18sqnxs6?=
 =?us-ascii?Q?ye2a7SXNpXZ5dXkvqKom5Yj1xldi+DiVS0t38PmCyUDB?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 768fba38-a5c8-4e0a-d00a-08dcc1f5f45b
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 15:28:49.2175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1SmsP2bko5iH9XTAv8okJhsDqAN51nfkTG5o0GSDzwqT+VzdzAb2Lx1Axhtsyn2BiOjj2GKgvHiyCx/l9/hmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB5957

On Thu, 25 Jul 2024 10:33:55 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Jul 24, 2024 at 08:35:49PM +0100, Gary Guo wrote:
> > > @@ -202,10 +216,30 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
> > >  	if (!func)
> > >  		return false;
> > > 
> > > -	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK)
> > > +	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK) {
> > > +		/*
> > > +		 * Rust standard library functions.
> > > +		 *
> > > +		 * These are just heuristics -- we do not control the precise symbol
> > > +		 * name, due to the crate disambiguators (which depend on the compiler)
> > > +		 * as well as changes to the source code itself between versions.
> > > +		 */
> > > +		if (!strncmp(func->name, "_R", 2) &&
> > > +		    (str_ends_with(func->name, "_4core6option13unwrap_failed")			||
> > > +		     str_ends_with(func->name, "_4core6result13unwrap_failed")			||
> > > +		     str_ends_with(func->name, "_4core9panicking5panic")			||
> > > +		     str_ends_with(func->name, "_4core9panicking9panic_fmt")			||
> > > +		     str_ends_with(func->name, "_4core9panicking14panic_explicit")		||
> > > +		     str_ends_with(func->name, "_4core9panicking18panic_bounds_check")		||
> > > +		     strstr(func->name, "_4core9panicking11panic_const24panic_const_")		||
> > > +		     (strstr(func->name, "_4core5slice5index24slice_") &&
> > > +		      str_ends_with(func->name, "_fail"))))
> > > +			return true;
> > > +  
> 
> Perhaps add a helper function: is_rust_noreturn() or somesuch.
> 
> > I wonder if we should use dwarf for this. There's DW_AT_noreturn which
> > tells us exactly what we want. This would also remove the need for the
> > hardcoded C symbol list. I do recognise that debug info is not required
> > for objtool though...  
> 
> I think the slightly longer term plan here was to have noreturn.h
> generated from a DWARF build but still included verbatim in the objtool
> source, such that it works even on regular builds.
> 
> (and can be augmented where the compilers are being 'funny')
> 
> It's just that nobody has had time to implement this... you fancy giving
> this a stab?

The information extraction from dwarf is quite easy: I produced a tiny
cargo script that would be able to extract the info from an object file
(Miguel mentioned it in one of the replies):

https://gist.github.com/nbdd0121/449692570622c2f46a29ad9f47c3379a

I think the issue is that the list of noreturn symbols changes
depending on the configuration, so it's kind of difficult to
pregenerate this information.

Do you think it makes sense to have Rust object files always have DWARF
enabled, and we check Rust noreturn symbols using DWARF, while keep the
hardcoded C symbol list?

Best,
Gary


