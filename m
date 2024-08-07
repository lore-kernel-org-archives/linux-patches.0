Received: from GBR01-CWX-obe.outbound.protection.outlook.com (mail-cwxgbr01on2092.outbound.protection.outlook.com [40.107.121.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83BF1DF666;
	Wed,  7 Aug 2024 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.121.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723035838; cv=fail; b=Go0JhVKdfdftBCeu9p6nuA1k41CCXPeHiIOmcfqOqS5mpDSDSIPUA8XPfgOAJw+rLst5TAaW9PAqOvayKTnRtPLNuItm1rUpsNHQ6MCUKopcYRkQr4K2G8b7jJ6EXFHoRyTSb8jShEmkgjwwZ4hCrmOvqW7KoPepX0WitdokMXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723035838; c=relaxed/simple;
	bh=m5aa/cXnNGotUsD6xGeKBE1gOIPzCBgiNRJECh+SDt8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FR8Gh0oBtTsNim4P3Yosh8rK9p4k5QDOLYXZokA9uh3LxX8i4PBJtI+aTtlLXljCkWtET7+b/7xUcbXvcnrpEeZE1fANAKLeEI3xZ+6b3aIJvE5erWfGLZ4r+gy1K81EUtadD6AAj1labKY2vhD2mtdmJQJ8q+y8pcHCcnJRkXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=eOqttmCe; arc=fail smtp.client-ip=40.107.121.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="eOqttmCe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2X1ZUpEXyAPz6/tBs5EYppdZ6P1XLzkWwxlGOBmnZo4CElAlHdpKQRYDM9j5JQ0NLJSZNj6aYgUKyz+ryoM7X+VWVkRjk/uz6TXO6NYxZUCadUjiOM1FVwBcw9Nlt+qOvw5aPNJccLdkx//gNrQc+dqGKrxQlDfA380u8s8++ehnuHiI1Jsm4By53EasrvEpFvTyGzIrlEIRp5/sVOrKPLP7wioMS4KpIvVAk7h/hF9BxaX4JBC1yLxhs/vm9Q75+qbwWKFej2giPVl8VIqyH1AGd2vYt5J868WNzcDZZ3l5EQA7VxhjCw9HMfr0lZcz3KDg5F/1/7YY9VvsRt/sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0kG1PA8SwmVwaYvEAA6QEA9WCCZK8nDO6JzSLD42r4=;
 b=nJHdahp8uBKCRNt56lCRy/mJ78q1HcTnfPd5j8FY11E2JK9lR/MVSbQ3ZR4A03NnwPOgse9PfzcQDAutb5MV015ubkwo/l3ewW6N2u4D7k3xjxyR9PlA/lCVuzErz854QMpGZXkVxwZhplichkokWf4XPB/BBLrCb4y1iz+7cSE3ZBMDtYZwd0X87jwfI60aOMNYQn1NXfFbCJ47vHWXx9O7buNVN4HAkZgt5ZxxAQ0BUW3CUaBbasL5Wv0XYWNn6Wgk5e1RGtFzsLmE6OepU8h7Hzt24KDPv//Y7JEf4N2omyjRQgrIQDalLIi4pbEzRjMxJbNORmk0veS/3SEyVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0kG1PA8SwmVwaYvEAA6QEA9WCCZK8nDO6JzSLD42r4=;
 b=eOqttmCeAJ6r59Jed7Fq7upueb1xyLQxatqnuxCvWUaGLdhKWF8eF6e9ylshxltmX4TGopcrAAQVs2EIxAKP7ong1SytMzaIdiShpVK87FJ4mUetdYfdRW05yJveYYGhqWCDL1YqD/CCE63edeIXg9y89Z76nbSc+HdSEwRNsBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO0P265MB6146.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:247::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Wed, 7 Aug
 2024 13:03:52 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%7]) with mapi id 15.20.7849.008; Wed, 7 Aug 2024
 13:03:52 +0000
Date: Wed, 7 Aug 2024 14:03:47 +0100
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Nathan Chancellor <nathan@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Andreas
 Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 llvm@lists.linux.dev, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: add intrinsics to fix `-Os` builds
Message-ID: <20240807140347.1fafe382@eugeo>
In-Reply-To: <20240806150619.192882-1-ojeda@kernel.org>
References: <20240806150619.192882-1-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.42; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0034.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::16) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO0P265MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: 85a15817-a192-456d-af2f-08dcb6e16218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PTqeXAMoJUkV1DgryUlawHrGmmkKqE7LNP+xLr6GkeaMwoePzaHSmFQ6BFty?=
 =?us-ascii?Q?JAgPWzVv0Zy5MkuMDIUvjWwiFRdp55AuPciOHVyLQS9Wd7SJsXx3Dzh/EF6G?=
 =?us-ascii?Q?VYFQNxnFsHISAdDO+8WFgltdbafBgS52/xyMQU6O2/r8sfQk/zzRfU8AlXo5?=
 =?us-ascii?Q?QYwkiC+fBzvuNuV7vXAuruBdZ9lLs+Euc8xoJHTRjP+Lp1l3K9at53rize+A?=
 =?us-ascii?Q?4SGSvyiyoWQ6Mn8xx08en3PIfM5WVBxPWtZ6TAkcFQMppAsFj5e0oPu3OkSX?=
 =?us-ascii?Q?eObsgf01PtycoeFb/CvPTU+uR9yf1fiMzsC1KjXYAmqAt4uzjsgYhnW0W0RT?=
 =?us-ascii?Q?UmNAw8TyoYvHc8sUXzmIG7KJmGguQ8wiHcNfiBCWAe8T7nYjq+De0Q4bBd76?=
 =?us-ascii?Q?TDZrMgnyJ1/m1HrwGvtTFo5uC6hKxrfo7vgDhziC7BO7kZDQFDvSZer5/0Bw?=
 =?us-ascii?Q?ouRasysdcOkxP52c6ba6rSGpNsd48PdvdCId81bttKMhaBpX7fMfg1ghxNZw?=
 =?us-ascii?Q?uLcCHbiAk7NTZLXX3KQDEnFtCpra+pV5Rop8rdDqWrCsc9GjegYOndlgPOAT?=
 =?us-ascii?Q?e0oSOWhcuXjjYVTQhQvztx/67t0Yhzl9htFBx5DrhMhaawHQCi4n0NB8zkNo?=
 =?us-ascii?Q?rIS/ojCUvFr33gRD+QJHd45CF9m10HyFEza4+cyUXAd6FG9ceM906DIWy8tX?=
 =?us-ascii?Q?rY56raipi07YFtdv2w5xUiDPc+ZjvcM7je+HCUyfMiADxsdU1dq/BMy5owwz?=
 =?us-ascii?Q?aVRcUmYUjcKpizrexzDJ32J7i4jOwaeJMBZXNeLj+iyZ7C9z+n46Y/m80+gV?=
 =?us-ascii?Q?TOCzDDcgNf0CrjMjY1Yv6Etw+FRgp0j7FYvre35hKVApexDaInNxFEf3AjLk?=
 =?us-ascii?Q?+rbzFqKxIqjoDHKS/V9TzOhH06A/fXLrdehEep1S8xOs7oARMdxfMpsydKI3?=
 =?us-ascii?Q?CZlFhs4ubJNXZfQuty0xmC6R2v5pfkW0ln0aGzLACqIkFiRMlLixdq99Jzb1?=
 =?us-ascii?Q?gVgp44qXisYmazDqeO47h44b4v5XdpBTdpkaPb98/A1lBorgE8eNo4qczONT?=
 =?us-ascii?Q?8EeoXOoDo2RJpUYaBmHJaVmNKIWKQ44uS+4OOmqbCRDr5G62XR13jhv0KGuf?=
 =?us-ascii?Q?6a5viElBLv5Y8I/zdHeZzMzsOd7iPBm8A60sGO8q3k7mc5LxnwqyGe2ztYUZ?=
 =?us-ascii?Q?apFbcWYvSdZgbdjPPYtGQcAppvd9MRgaE93jZB5DF9kaXbVzQjeIL+Q0bfea?=
 =?us-ascii?Q?CW33+AMzEfDDCzEqU2kfFUSNy/8Ha6S59FzFZZ3zJ8l8W4odj7mUyfWdMH5v?=
 =?us-ascii?Q?BEg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i3Hna3A4E3Rw2UxeB354gXcJWIazxcPaK6utK3JwNzVoyWIONdiaHeitmRH4?=
 =?us-ascii?Q?FY+w6TAYvWviM3aGkJ2XcWajnZKpkEKW9D3F5RYn7njHJu0dnpWalG8BKHe7?=
 =?us-ascii?Q?9pHy0mq9yilrzTLbXsRYFKTAsrBF57teq74LWIrtJ1JCKTwhg4B/Zo/YCzxG?=
 =?us-ascii?Q?Q4upAaJJyZjIBetbcgCex2VvfLOyXJDTsHxYDhpFs64Rf8/DmqY0JUVuhQ3d?=
 =?us-ascii?Q?2MKR431GJAMPvfRZYauy3wpNIT1zOG62dTiwZ5VBEIJsVcFbn7G5vqqklamX?=
 =?us-ascii?Q?ihqXXMBeHLaHMySINg36svzUwRTZO+7MAEM7BCjf8BX4I2qLZQXM1VZ5HyAm?=
 =?us-ascii?Q?iK6v5lftXWv8Foupx2HWoFJBXx/0WtolDnuz1OJgJ1QGGDmB1D3Xg5wOLgbI?=
 =?us-ascii?Q?XjoSYl4wRiQAGwLRTrDoCK47e516jdR4EsFbPidbXDlAtdJJIKJOz+6XeMWT?=
 =?us-ascii?Q?Mlx3iriEydUj7ywJWI038j1riRA3V5+DH+W54tCvryK/3Yn621gPkmRuO0m3?=
 =?us-ascii?Q?OExFHOCwAcA+Pgd+QxIzZuIvPQaVFFRarAsSPk4EGEPEBC1xbZU/akqbU4lZ?=
 =?us-ascii?Q?WNOxvW+1x8zDtIjfS681VH8lOwQiUHrefgrb+GEgghhI3fjW+w6/0WK+mp/N?=
 =?us-ascii?Q?PGu7te4nOY9vQcbTlqabr0+Rm0cMCgZ22V9F6oH56Zrl3zD4V61cslhVZHQm?=
 =?us-ascii?Q?jULuXWPSW/2n4CsBnaLIgZv5D3rvxI6orQhYt02DwOQ0kUwRG8KEzWVreaDn?=
 =?us-ascii?Q?mwT8zB1ajC5WX+8DSbbAXbU/s8V94t5II3YY3Rqk148oOuBaL67mBkKMRBri?=
 =?us-ascii?Q?iXHM1AWgDoC9kTQk6JwtM9fRp9yXlQaOtbTbWP/EGBLM0c4r+vbetrCRP1nu?=
 =?us-ascii?Q?tdjnH8QRxEvUYdzuMe0W4aPee5YNg8rH4SO7QlneUpAfMAkr5raeyVhHbLsF?=
 =?us-ascii?Q?BgJveGAwYaeN6Dg8u2qrxco/Reu+EdO5thdtpJJAzJ634Mkf+uKhLbiK3wKV?=
 =?us-ascii?Q?ss3XuI2NatW63voUOlKQZi1/hQpzmLVyYrd7MwELtRWiHdkdsT76B2wWj3OR?=
 =?us-ascii?Q?Tm0lxfqvUYCwyTNng4oQML57eWnqVtwCFGTChrSUSPEDWvvBQWBy19SLg+Ma?=
 =?us-ascii?Q?n0iYUP+F1m3ggJlsd+4efDklvEV9Zr0UbhH2tKItB10b3aE/g1tyFC8s25dg?=
 =?us-ascii?Q?UQ0aWkBzuMInQodrDhOzMKHHtYjnkwKFuaepOGlX4ACKP3PgGZoNaRU12EgF?=
 =?us-ascii?Q?9P1m0qPIQ8e1tEGOlI1vOe3Z3n1AyVxTqvEJevYMmbHgRwHFhKwpKK7LqVfE?=
 =?us-ascii?Q?NPz3h480Q883hJtb/KzilZW4Cmm9WsGNpb6AmSUpX04wneHsvBcXF6nE23hk?=
 =?us-ascii?Q?QkYbLQqwAQVqvtLI+J6KpY4YQmVLSXDdHt0gfQNErgs8aIp2JxdCdjm9NAyH?=
 =?us-ascii?Q?IOTRzDci/kijT9dl/uJ89zdY2eoj8XOBAmRrW0eMBo/sh/nHuEtfKXCWRAwv?=
 =?us-ascii?Q?frV5g8uwPBhHcfil3LbA2ngYlrrZKdwY0FGlgMhhoJYycFkK+rFiDSZtmOMZ?=
 =?us-ascii?Q?FJ99FRD/98/hntg7z6dMlNNmWYirM/NoG4Zg8keq?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a15817-a192-456d-af2f-08dcb6e16218
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 13:03:52.1710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8K509Yjvx/QTsOTHDkZ+N7sHM2TivHP/9tE21vWDqJDfos8F1V2QAK9lrz/KeLxmcop69fWJm2rwEEW5IT6ArA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB6146

On Tue,  6 Aug 2024 17:06:19 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> Alice reported [1] that an arm64 build failed with:
> 
>     ld.lld: error: undefined symbol: __extendsfdf2
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a  
> 
>     ld.lld: error: undefined symbol: __truncdfsf2
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a  
> 
> Rust 1.80.0 or later together with `CONFIG_CC_OPTIMIZE_FOR_SIZE=y`
> is what triggers it.
> 
> In addition, x86_64 builds also fail the same way.
> 
> Similarly, compiling with Rust 1.82.0 (currently in nightly) makes
> another one appear, possibly due to the LLVM 19 upgrade there:
> 
>     ld.lld: error: undefined symbol: __eqdf2
>     >>> referenced by core.20495ea57a9f069d-cgu.0
>     >>>               rust/core.o:(<f64>::next_up) in archive vmlinux.a
>     >>> referenced by core.20495ea57a9f069d-cgu.0
>     >>>               rust/core.o:(<f64>::next_down) in archive vmlinux.a  
> 
> Gary adds [1]:
> 
> > Usually the fix on rustc side is to mark those functions as `#[inline]`
> >
> > All of {midpoint,next_up,next_down} are indeed unstable functions not
> > marked as inline...  
> 
> Fix all those by adding those intrinsics to our usual workaround.
> 
> Cc: Gary Guo <gary@garyguo.net>
> Reported-by: Alice Ryhl <aliceryhl@google.com>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/288089-General/topic/v6.2E11-rc1.20doesn't.20build.20for.20arm64/near/455637364
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  rust/Makefile             | 4 ++--
>  rust/compiler_builtins.rs | 3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)
