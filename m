Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020084.outbound.protection.outlook.com [52.101.195.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154DC12C465
	for <patches@lists.linux.dev>; Sat, 14 Sep 2024 23:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726355444; cv=fail; b=jH/B9UXYi11LPz0zCESW6sPPjGQrCmhrOGGoXuUwQ9G5M2hJCEBTTdO9e9q2WqW7/nNAIUzTPsdX468i5W70BQs34xsD42ruPhb2gtetm2tFCBmVpl/RQHBB/b1IVEA0TzusNCvlpmgV+3/mfNbn/uutP+nyOq9IU9wjpgT7Suw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726355444; c=relaxed/simple;
	bh=pM7JhtR++M/6RZedHK+OJ8DlLqCo+1zYBFvs+Tx2Gdg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m1Px3sRRt0xkUjVow1Fzurx6YHlbgX3eNDNF38lhrMohUd9HSfPB8VSNrUYjxOGSZS1M2l9ewWCPl4Xxh2dW+1GbQEIVqzKjgOeA++XYuq+qRnuJxATtOmJ2K8gUKLJIddowdml2F3RlBqSAJMV3aJpvfBfcLO6n3Dv8sIXqc0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=PkJNCryG; arc=fail smtp.client-ip=52.101.195.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="PkJNCryG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PjWOVFgED1Sb/RRz1wnGQMwcCU7IM2RFDIaO4gFWC2lXYXoghcAeTdt50lx+qLBQhWdPhN8hJlpfRC4n/hwdhJZvOSY4M+Amz5k4saoIs/YsZO0u2WSflGxbYJJ3UHNhPhacWfoFYxeoVh5wHvcdypkmvGiSYNeCiPMmsDbhGJwcgDYlblhkVnWnoicm75nEBCehEFPT09CTJg3UzdAcHQSlRWZ6BExhpA/Vh2su3R+lWJ/Te/2LL4xGCxCFKAQunZnVOwBZSJ0Dp382D4Ghvt0lUbsF35EJHW5y1gCot7/s2yk5KCMZ5Zb4TAbFRCw119h7ftWU2KIMpOoVjdy3Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4x4twgSz8hB3x0n4r5G/vJFy/zZuJCSSzwNu6Z3MHqc=;
 b=i3W+FcGb2tlJ0w00d6EYMd2EnxtOPfv4x7bb0SRNSSWDhLyr8m8vLoZvRcROeA+2H/SQBrZEddUDgl9F9976qJ4+ih2OCSDgXLOA5iXgagotifFkpYpogWKr39Z2JTvMDwDyvS7ByubbJ2dwcJBQxwuQ06N5IDqup4aXXhJGi9TL4sWH/RMNPoWz/qWZFgFwnPvTa30aBOBP6tSRWCjWg5rOWqAsOpuBBgzRedr/17nozUjmsOgPQ/RFM4e8qCA03HzKEw38xRKearUjsFNAye8/RRMFD7QtAT5eQyfoFsdLnsc+OElJpDpD0Az7/Zoh/1DWD3yzYlfWFCZej8fpfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4x4twgSz8hB3x0n4r5G/vJFy/zZuJCSSzwNu6Z3MHqc=;
 b=PkJNCryGAghOyEb6j668eLdmRk71kc8XzK7/+XG6MMSUX4EkWOEO87gLF4XWKKA7EaAbrNLlbhM5WjxA2kUJZVwTw7aVQK30ohsN5Ts5ICjKQic/1xehSRp4IoFY++JW505ZgDQNMuLvPdEwrjSL52ZuGhzljcKpWK4qyeA5lVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO2P265MB5629.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:25d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.22; Sat, 14 Sep
 2024 23:10:37 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%3]) with mapi id 15.20.7962.022; Sat, 14 Sep 2024
 23:10:37 +0000
Date: Sun, 15 Sep 2024 00:10:35 +0100
From: Gary Guo <gary@garyguo.net>
To: Geert Stappers <stappers@stappers.nl>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Andreas
 Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 12/19] rust: replace `clippy::dbg_macro` with
 `disallowed_macros`
Message-ID: <20240915001035.5fc4d4a6.gary@garyguo.net>
In-Reply-To: <Ztk/rn+wztXYVTtd@gpm.stappers.nl>
References: <20240904204347.168520-1-ojeda@kernel.org>
	<20240904204347.168520-13-ojeda@kernel.org>
	<Ztk/rn+wztXYVTtd@gpm.stappers.nl>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::9) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO2P265MB5629:EE_
X-MS-Office365-Filtering-Correlation-Id: a96efd0d-37a4-4821-6877-08dcd5127198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C2nBzHeHIBsfOPdFvJlSuNkM7OeTcqqfa5+D2ZuCyrPWI9TkQqvuIS8enOzH?=
 =?us-ascii?Q?Ag0iKBCf/vr5Ee5kJok4ZCRDZbUxA/kcxaIUCCIK0OFsI4wFOOQT7CJhYk5t?=
 =?us-ascii?Q?MDVIPNeN53Gb7k2gShUfbYDO/ustF1QwqLMIurkm61TLemc7VapGEPwS6elN?=
 =?us-ascii?Q?FP/GlMGJGNJZcssJxt1w4Dd68reRaXXzOlNCIcc8ZsHXuthxL1rR/oUicIfX?=
 =?us-ascii?Q?52wOyrKme5W5tCtrJNibDEYuYLZsr/vNbT9KApsd1uXsBffEig4zMGvL5jSI?=
 =?us-ascii?Q?BcxK+LFyfTdWAIl3C/p3xq/dCh7g1a25MsAzGm/7BZvVvxN5V/tDu5JPgcx0?=
 =?us-ascii?Q?CP2g/Rhk38OuBTRQpJ6nsEO92K0m2Gr2zTfCE3wD6bpC39IHPJHWbd4cb2Xt?=
 =?us-ascii?Q?/AJf6Y5Ts+WAMiXZBhcCrzGmok2TUngcaWWZhqwz4bSFZq7jyTX3vx4wkBPa?=
 =?us-ascii?Q?dtuvDJj3cgZIZmwNwvk6lcwOh9vUoaL/SMPK/dvJe5yLOKz+fenzroi+C171?=
 =?us-ascii?Q?8h6R4LcqzOFwpMPCARuT3anznHhz0V2W+3Yk0h6sdsGOJFLTlxV8UQpN3Jrg?=
 =?us-ascii?Q?6s0mjzdwW5GI5NuSHVGrU2yYydEoB0rtzdmbaoFvpgxQKhtNBg97JoQeth41?=
 =?us-ascii?Q?G8GeFCV8qMWES9VeoNiaiRkKiq8ULSbmQ0DXbCZwRdcGDHYHMOhJxJBGS7b4?=
 =?us-ascii?Q?Ua+UjFXOYR1NLWsmmAKFfrtEsnxu4NcfwyEWWNIJoi6ZYB1l1/74ijPKmjVC?=
 =?us-ascii?Q?SUJonrQCcAN+DTnLY+rc43bpSQ8PyypC2JlAxHVRnhsCQ2XpW4LNlra+H1PF?=
 =?us-ascii?Q?/djM2pCHGLk9MaacwxXYz/eHxnhhVWCB62wuB14nKU/2f4Qdv8REZPuhD7AO?=
 =?us-ascii?Q?VG6SflFdNQOEF8Wei/HTo9B+jY0Hyq4PAEeg74GFrlJlyhkOVsSfc8COwJ9h?=
 =?us-ascii?Q?TTh0Ud3gt/7JldKKrljjhnDl84EF29i3zFCkAl0s7zwvl+qMJy1Gps0xxZqM?=
 =?us-ascii?Q?EMdEBScjIOZ6jjuodE5BEm+x3f+zEahaUgdpXQJUxuJBRg+qwTYwRYZi0x75?=
 =?us-ascii?Q?fojpm56lHATgY57j+fCXmRZLKRM28jnjaXZViMNKcmHxX0Eri8nXv61Ak8Tt?=
 =?us-ascii?Q?+K0gzU8b99uRZRWRrUqlfW20KKWcvM/RZRtQPLM8emNJFkKOLI466oAve6Fa?=
 =?us-ascii?Q?halWBhN7t74chwLKzzkp2HZSbxLeXm/rI79klauuIT8I0EmnBAm8CouBu5Ca?=
 =?us-ascii?Q?YAsRhxW6lP+JOfQFB0f9/VIg+m3cFhbhiIHBzT+j8nVD2mx9tbM3E22myNtf?=
 =?us-ascii?Q?iaw03vTkaLj6TOB9GAzKrl4/pnPgxE16pMFzd6z/g9G1wA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YEzzDS/d/sq6csTFaRNA3P9rHHTEcS1rv2zyvOtwncZ9Ng6+Nlnry6nqWYJo?=
 =?us-ascii?Q?jp7K7ggb2PyHAqHyqJ+Je1HtJSmuLYqgdukW9qF9fRFf8sNhaL4uIMTVO+Qd?=
 =?us-ascii?Q?TVqVeIoGpDo+NglR8li9UdZgxJvYReBkT8Sis2/N7bVmVijXLEp3Fj/0Z9yc?=
 =?us-ascii?Q?ArgUfb+TO3/CWq5kSTxzgkXLIHNlONf88LKn8j21i7V666gqzmTgROMNQDJ1?=
 =?us-ascii?Q?L2NdS9l0UozEkLkKvfZj0tHAlMs8Wc0WSfL8mwh1OD0b86wIHL4po6wbS3jq?=
 =?us-ascii?Q?FeguwNlQBs0GdZnF5+HEp5LPg4Vyvwjo7ZDByWNX51gdl1/ntg2abiWhZ8vS?=
 =?us-ascii?Q?B4gTmYXULGpaQkdQWHeUro/JJsFi/H1CI2+pYtI7y8DjAJjt9Ax+o7ZcY8Hs?=
 =?us-ascii?Q?3Vs0bdiLmB44+E+6P5hAN5snmMH6/dDvtPo8SqjBJ0rIG9lUe4k2KZLpaS2u?=
 =?us-ascii?Q?mPlX/bHimZ+TpsWDtpGbS8/drtYrCOmzaa0BC/x9hU0hwXqOWQ5nC4BDm7lo?=
 =?us-ascii?Q?D/+nbQpxtHU23H8dtVQSdkQr5Ft0z4wLFXjo3GXTLbAEG0znP7lOE0vQUYSu?=
 =?us-ascii?Q?Ngz/XsXqUZXny5lNh3FnnHGbYERr25uwMjZKJHizTUpOUyFHyJS0KZcOzSis?=
 =?us-ascii?Q?XVEjbJXSpamRbrz1i3qtZEMgWUkHhNUtFJhJI6z81Vax1tSzyt8mQetWNALG?=
 =?us-ascii?Q?6P3XYu03QUCv3pVdooWbunYA0X6SVZg8wODZLo12BcrquxxYb9G39fN8uqOX?=
 =?us-ascii?Q?YPKrsSBGGA1apoz+En7jhPG3Bh8JuqHZhalQipaHys6YFx5Mtf2cr/IwjhFA?=
 =?us-ascii?Q?AKmV2aNhxk88kAjUTE48+usZtWFQhIYSUxPVOtuHZF7cwzLpFXH/mL4d8yIz?=
 =?us-ascii?Q?cmhTZ36Eyz997yqj5NWIYWz8kqPR1VNLIxkU0VaoJrIfNUUFkHI6Ey1NE+wf?=
 =?us-ascii?Q?p/AM27rIJdIHcLbyNF5w3HJqrJOw5Fj8hMzx03SvfkWoJTUk8xaqORBhJSLU?=
 =?us-ascii?Q?86QG3hM5Y7PG7SHhr7nh2omQPl+BdxosRhaIi+gEExNLh8YF9XMldxuaITT9?=
 =?us-ascii?Q?w61SU2VR9uKijNoZQ5wo4ZfgGpZIn3Q4py1GAvMi7+HAo0svXMinYRmblQv+?=
 =?us-ascii?Q?qcOTlA/EZGf5vDiJ5DhzRGB73pWtybrhjy3yVReW2++Wa3E6tr4HsnRIcwb4?=
 =?us-ascii?Q?SOSaRr5wNOcwzdMM1SlsNWDVdeQ2zqRaxFXfJA69new+BD5cOTHg3D7Re66U?=
 =?us-ascii?Q?NVjxsTS+m1KJvIQH5bg0wKxFjk7+GNTOFP69Klddb9Pbn5J3uIyguOBJOdNQ?=
 =?us-ascii?Q?iA2EVtiXzeoVwM2SEDcGDrpSRdTjjcBHk2JfhQp2KIZXbu4cGbuYBL+zZ12k?=
 =?us-ascii?Q?woP+xngspFXFJfRvi33V0sbA983frOYZ4lDUSj4x2if8YFjZnYUw5YXiTYEn?=
 =?us-ascii?Q?TvOC+QK8fBRjx3GtHxdGm++vVDuJcF7bD5yu6ugjjp3dbTAWTEXSJW+koyFD?=
 =?us-ascii?Q?RAJyDZzGhy+OjcIDXPvzmOXLmAZcvx6H36PdLpGRYVAgpff9iw0wuq4CiSKV?=
 =?us-ascii?Q?xijE82Yv9aK+pRk87JT5YLWAwlFN3Dw3tBItn3Uv?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: a96efd0d-37a4-4821-6877-08dcd5127198
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2024 23:10:37.2950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rdnUlXKZooqU4ySXLDYy3G+382RR/IE/0k2F9SsPMCzDLGUVdP3kGP2kOhTBDcHTM2DMNkxkC5Nuvc92ozxbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB5629

On Thu, 5 Sep 2024 07:20:46 +0200
Geert Stappers <stappers@stappers.nl> wrote:

> On Wed, Sep 04, 2024 at 10:43:40PM +0200, Miguel Ojeda wrote:
> > diff --git a/.clippy.toml b/.clippy.toml
> > index f66554cd5c45..ad9f804fb677 100644
> > --- a/.clippy.toml
> > +++ b/.clippy.toml
> > @@ -1 +1,7 @@
> >  # SPDX-License-Identifier: GPL-2.0
> > +
> > +disallowed-macros = [
> > +    # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
> > +    # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
> > +    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool" },
> > +]
> > diff --git a/rust/kernel/std_vendor.rs b/rust/kernel/std_vendor.rs
> > index 67bf9d37ddb5..085b23312c65 100644
> > --- a/rust/kernel/std_vendor.rs
> > +++ b/rust/kernel/std_vendor.rs
> > @@ -14,7 +14,7 @@
> > -/// # #[allow(clippy::dbg_macro)]
> > +/// # #[allow(clippy::disallowed_macros)]
> > @@ -52,7 +52,7 @@
> > -/// # #[allow(clippy::dbg_macro)]
> > +/// # #[allow(clippy::disallowed_macros)]
> > @@ -71,7 +71,7 @@
> > -/// # #[allow(clippy::dbg_macro)]
> > +/// # #[allow(clippy::disallowed_macros)]
> > @@ -118,7 +118,7 @@
> >  /// a tuple (and return it, too):
> >  ///
> >  /// ```
> > -/// # #[allow(clippy::dbg_macro)]
> > +/// # #![allow(clippy::disallowed_macros)]
> >  /// assert_eq!(dbg!(1usize, 2u32), (1, 2));
> >  /// ```
> >  ///  
> 
> For what it is worth, the exclamation mark did surprise me.

`#[]` would apply to the next item/statement, and `#![]` would apply to
the surrouding scope. In this case there's just a single statement so
they should be equivalent.

Miguel, is this change from `#[]` to `#![]` intentional?

Best,
Gary

> 
> 
> > @@ -127,7 +127,7 @@
> >  ///
> >  /// ```
> > -/// # #[allow(clippy::dbg_macro)]
> > +/// # #[allow(clippy::disallowed_macros)]
> >  /// # {
> >  /// assert_eq!(1, dbg!(1u32,)); // trailing comma ignored
> >  /// assert_eq!((1,), dbg!((1u32,))); // 1-tuple  
> 
> 
> Groeten
> Geert Stappers

