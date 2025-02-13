Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021097.outbound.protection.outlook.com [52.101.95.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282571514F6
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 17:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739466764; cv=fail; b=RBJqKDOIVnNT3iG8fOFvMshc3ecYGUMcHsUvAyU78sUsLqcGSBkBHNh6PXGm47GryTsJq8yOzApC9+saXLeCSJfWf9rejd4Ypi2UfAQHj76RSkm/9XdpcVepN0p32Z4dJbXQx1qSe0BNKOJz6wUCgvf+hy0d8JSochR5t6o9IwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739466764; c=relaxed/simple;
	bh=5QeAdDnr3Pn6drCN8L9dyUZwFsveu8A4SxB3u9hZDOk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eZvzyV4GcqDB0/VqBHeSChMMED6Duh+2+7jExnjHFmGrs09Ioy04vxd9hBA4vZ27097sn/SoSZ2dnljvYkCtZFaZ8z+vGL5xBpGmpql+luQlStXXCx9WqIXNUTp+gJSx7UJBAJAEA0VDTrWDa+Bv+Q81psHJWUF1RZgi4wU1Eb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=LYSm3GUj; arc=fail smtp.client-ip=52.101.95.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="LYSm3GUj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FhKqf3HMHYrwklHmQKwk9VUxge7+FxKauCPEGWvOzp+PMY5nPIzUOrgUDHagNb1OH/wvzZCyezBZXa80Tjk0dEdyqIDnj465L1wxcOwP+9vwbsc9Dog+Fmuo52vMg/wysdiZ6pZx76g7pBZAAMOfw3YZ6H6tTPfPQn30t8wnVhkHcxDBF0KfZF59wwmAV/mmExPRoY2r2c1tRTJUXTGwUita0GuQewrS8EmoAjcKdiIyrbuQQeuMOueifBfmnrvcLWdJRcj5d8wf+Twf2cX5n60tyPmSJkwyubumA4eHBEz1Fn8xSczwjBx+ZSXzIy5EBBmLZdg0NGKCo85Rq6bRuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1CFBB5lObygAbTUsnAuTUNPnz4g5goUevyWdUtQNYNY=;
 b=FzmVOexjgII1quq1oDE4x1oFjSgNg4SAFOikDZgtfsOVn2qBKK0D6TlR7ZOXZlqkuJ7eXtxLSjawjWq1kEedHUXfCuzCJnkSqx3ldnXJEf71rnywdW4JkvvzWSqr8zPnYg37iEWoty8RleYK3AC0SEM+hJiUaZJ5t1ZtbMbxlB2uGMuhZkkGxyyRU2BYW5/tC2ox+R5kptaLrBtF/Z96GEjv+52EQV7jVzgmAOHFMC2oRSe4JP2o46PAVEr/y0OjlmfgByRI1eCwIhQ+cICDhXpEufCTbOaW8TbSV5SjbgyW12wzu7w8mTqrdm1sTaNCeYW3/pSGyY3jIpRHpK1CrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CFBB5lObygAbTUsnAuTUNPnz4g5goUevyWdUtQNYNY=;
 b=LYSm3GUjmyJHh7j5BpuQmuSaaapRc/WeoxfrvCdMRi9GkBhXGk5Ndb7Ylnx4eBgBnJsWpxFLKrjvhXLD0l+fnlMEywR4bWk0Y0kDkMxjmdVKqQvOG0VSGTi843Y1lAdQbcTBTtA//7uRDBm2NRJYwhL3H/j04v5Oq6zleg4dbCQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by CWLP265MB2787.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Thu, 13 Feb
 2025 17:12:39 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%4]) with mapi id 15.20.8445.015; Thu, 13 Feb 2025
 17:12:39 +0000
Date: Thu, 13 Feb 2025 17:12:37 +0000
From: Gary Guo <gary@garyguo.net>
To: Ralf Jung <post@ralfj.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, moderated for non-subscribers
 <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, stable@vger.kernel.org, Matthew Maurer
 <mmaurer@google.com>, Jubilee Young <workingjubilee@gmail.com>
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat
 target
Message-ID: <20250213171237.08e0edec@eugeo>
In-Reply-To: <9430b26a-8b2b-4ad8-b6b0-402871f2a977@ralfj.de>
References: <20250210163732.281786-1-ojeda@kernel.org>
	<CAMj1kXHgjwHkLsJkM3H2pjEPXDvD80V+XhH_Gsjv8N4Cf6Bvkw@mail.gmail.com>
	<9430b26a-8b2b-4ad8-b6b0-402871f2a977@ralfj.de>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0329.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::29) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|CWLP265MB2787:EE_
X-MS-Office365-Filtering-Correlation-Id: 1862812c-3366-4604-063b-08dd4c519e62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pIpMGcGpDiOHnjkan3y7P4yXOvw42Cqv/tS6gQS95aovnITsl5SK+IF+EcDV?=
 =?us-ascii?Q?fIO70xpOJjbJbHar2qDrxyy+V8/ZrLsu4WviPGa4BOMnT7UP02hqlUihN8Bn?=
 =?us-ascii?Q?BNHcp38auRM8+B0dyvA4qJ4h2oPwz8BJhZQJIbsXUcaB2SDU/aOzGUZnyvLm?=
 =?us-ascii?Q?7CgqgqA80JavHEpUXOvoLEkpuKQSK/N4F8NOCig1XzfjX3PLVxH3AHWFqS8N?=
 =?us-ascii?Q?MQzhqLHy9Qy+IhcePTfykK/qAVhdafoMT8156PQuBwU3lkH/pVnjlXnH1o5F?=
 =?us-ascii?Q?3+yW465BcCfvGoehvF50ffHkLLrzKUMlz5ConrIOi8j2Y2u/YEM9smp/rP8A?=
 =?us-ascii?Q?d9t82lLk3BHDWnJkAncS1XC3zxCb9OljcU2Js+2T9KNY2+t5OKtksDLrSz0P?=
 =?us-ascii?Q?PBUFARSnM7Z6QjtuG4F7WIECFimWodM6GmgUsZ3eSVukN7TyX4ptbEna5pwi?=
 =?us-ascii?Q?fDUDuSSpFN/PiKTGmvW3XNMJNgYkq1Jbi54dSYxN7EtTcJ1nKdo1eYxJ3gZj?=
 =?us-ascii?Q?t49OAqY5rDfmmR4jrTLewoVMZxyUKy0DC4VfDXDIXzzuxRwgiV7tHGPCupZ7?=
 =?us-ascii?Q?NAjDPQ6OAjCRtL1e8pxJmhYB/sy61ZqcuaA8UKIQgWx5dOCLgm3IO7G/sInJ?=
 =?us-ascii?Q?8KbTKeSg1ddrOIIUegmQYxFLv+xct3HnCwWUtVACy0Tba0BF2SWicRtf7nd8?=
 =?us-ascii?Q?L0HKQu8mjuwiJXmPnCuWC2pqnA5bAic/KkmAXF48RxWUQTTHW6Rz5RM8+Z6z?=
 =?us-ascii?Q?iTGvJZxSrMJkVWNCOboG1mEXsi1EMES43MxW4CASmBN0VYI3CM5UL1r+Cftw?=
 =?us-ascii?Q?NrgCpLdAfdEfW5FkKd+RNTwAlx0XGMu/YYyv+Y/LKjPMqMyUNQuVCsyNCtFm?=
 =?us-ascii?Q?YLAloeTKmKLPoTo5kBXgW/iFCAxmoWxUCbHQiXnWpkQ2fkncQ5MgU1GvB1mF?=
 =?us-ascii?Q?6AOwAujNfy68ojce4DViGdHQPEBIkjTt/lQd1MczhtGjG00IFBq7+4tNn/jP?=
 =?us-ascii?Q?EWXeiERypKy3+TyqV7hj3DnpT4YalaPsus1LIMJXLjauloD8mc7Cm8LOVkCe?=
 =?us-ascii?Q?+pHX9s4MOkgdhZtKIPhMJjHKTfi1H80RwF1WtZUaiyNFtBHE1VHx5WukBFjS?=
 =?us-ascii?Q?1fjW8/K1eUPJnkw+w8Ie14f2Ts5+H67Jc5qOrz25OkTdrn0mPficmyPM+2tg?=
 =?us-ascii?Q?3BswkhXmX/sCE9WbAz+rDfc+I9CoPG8JB83oFNcUxxvcVMybl81NYWHME+DD?=
 =?us-ascii?Q?kYwXQ/2ONDBvDep8OntXLRK5rIM+fTeADDmuB0agHrfpMiqme34q8WePgxst?=
 =?us-ascii?Q?SpCl2eiYZRHfimmKlfoLnVgrix4e+lwx2tVYqUCVAkgjjnj3L7DcwjgsvisI?=
 =?us-ascii?Q?DSB4ATS/yvCnYk/jDL6zOA9wxYLv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?npybuBDwlPeLUwIouI0XB8B9Guc/xAEyu+L4+sgbLSDwyeRj0jlKa+edsxCH?=
 =?us-ascii?Q?HmnOWnkH9f7CE82lEabqsQHONR3ZCdiN9pTfuYa7+Jw4Oxk4PF45nwlH1qZL?=
 =?us-ascii?Q?BKKohNftwvxmNmTVcAxzajyaaXEddNpHIaJ9pMBl9VBulQO1jrkB9rnZ19bc?=
 =?us-ascii?Q?5cejU/zA9zjS3UL6wPsBjrqgZAaJl83iMyMDEpXhlsPcm+pwnyMHO1ObUih9?=
 =?us-ascii?Q?LNyKgSZQJ6v954tach5+jvkMtsAU5VI9G9hGD/PU65dRmEwqDOOrLs5928MP?=
 =?us-ascii?Q?UTaSSGH9OXJciVyoGk6n0uiIwe3zSbjVKTNxD3I29d47xHD67mhND6zhtdAj?=
 =?us-ascii?Q?OkxTX7yccB/0EVikx/JMeDIbkGo84hvFdamhM+yuzml4jYJX6xKCU8NEBuq+?=
 =?us-ascii?Q?nUqa25A6GtXtqeSJfk/UjZi/HKoOLVGrkOkGg4QNPUzx0LDaOafETJo5BW0D?=
 =?us-ascii?Q?ZH84WNdXaBICAux0kyor811XShQeGRYpS8xZZRCxq9M867/FoXWdoNzb3aRc?=
 =?us-ascii?Q?vAUbbaldcOT4UjhBnx0qLSchW3oF1u5cs7BB4jpY2Wvk7MnNb+bgMoA5WlyH?=
 =?us-ascii?Q?6wZuoMAki0jlLtX3kp5zB8Z0KUUWEhDNyMkciE6RDXUPX57fW/0pUJ1Vhk+f?=
 =?us-ascii?Q?t5gy6KVcfn0aOiF8rtoFmpd17SXKCKJ8q45UWy3CwnCpJSYt9jnj9i8gOfka?=
 =?us-ascii?Q?MPmUNbpqHZVDZqGcKLMQswuLO4rK+8weesgAJQ23Dy1zoRpHwHw8RbBV7Mm/?=
 =?us-ascii?Q?Y3CIgzPihq3nMlr1l57Tw+s1OQnI+DeIpB2GQGqbUJQ4WavLsQ8cwpaC23Rr?=
 =?us-ascii?Q?9A6cLH4Jsgf7QSmI/ig+DBSCKoVq59ABgkVqcJ8lilh25vH2lpjv6oDTbKDH?=
 =?us-ascii?Q?HRvDDO7L63Vu5/NXhWaZroOCbG2Nzk2XLJ0Qb18YfX0HGoy9r6Lf24UjLtL+?=
 =?us-ascii?Q?495rj2+NTLLhgejlz5MLA+ikRMAv+scMYHOhl37RJvT7isMyVc9E53v8yrhp?=
 =?us-ascii?Q?zgH8ubvasor3X+9ih4H4uSGHBVNzbVcise0aya7Y6+rKAvCyedOtmHC2mRsq?=
 =?us-ascii?Q?P0QNuJi1EGgj6ue/67kHvY1gy6hywZZq+oXTNrThUKksTzgKlZjtPIxgPubz?=
 =?us-ascii?Q?UjmNKK/SBpY55Bbal8M41/mdVpJ8ZnBJVmWoRlKpI5xveKF1sdtZ/7U5s4e+?=
 =?us-ascii?Q?lMjWjt5Wdxv6pQRO7GpAadtVisKVVEkatUVlHHdsLBHQqOQZl6q/lqQ7jGvn?=
 =?us-ascii?Q?vUDHL6v9VlGnKwviO9DVvzryJhYisY3+xUvp6XXykcto0Mv8loZROZooCKx+?=
 =?us-ascii?Q?X+1rwNaT6XHEd2cT6BhRmkIp4Yl4OppGxY2IlPW+R4hTUfkgKxJVbJ5QKRmP?=
 =?us-ascii?Q?MD2Pl8EMuH2Wy5q2SQXbwXTNO2HSCLBzErMHFhif65nuhfYoC+9SCZJ2Oz43?=
 =?us-ascii?Q?TV2TM8tI18fl222awBNGy/SA8dp8ag4YyCTx57G8M1klkAwN7gZgOnk8Tbyd?=
 =?us-ascii?Q?DQBkuo2QNitFmEjJq441sylSOWOy3ILD8CPzr6XQBboEdrr2SyHaZDR5Uf5S?=
 =?us-ascii?Q?ZoeL2q01kHLrfpB7k7CJ2UHl/avusR5fdamx9MN1?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 1862812c-3366-4604-063b-08dd4c519e62
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 17:12:39.1664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zO/Aqj0AskxAtRdBjxkPhazyAb5+he31RDPyMPSlEImsHWF/KafA3A0d+EtHggYihPfkLksanohcr1i0A/CHWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2787

On Thu, 13 Feb 2025 16:46:22 +0100
Ralf Jung <post@ralfj.de> wrote:

> Hi all,
> 
> > We have to carefully make the distinction here between codegen and ABI.
> > 
> > The arm64 C code in the kernel is built with -mgeneral-regs-only
> > because FP/SIMD registers are not preserved/restored like GPRs, and so
> > they must be used only in carefully controlled circumstances, i.e., in
> > assembler code called under kernel_neon_begin()/kernel_neon_end()
> > [modulo some exceptions related to NEON intrinsics]
> > 
> > This does not impact the ABI, which remains hard-float [this was the
> > only arm64 calling convention that existed until about a year ago].
> > Any function that takes or returns floats or doubles (or NEON
> > intrinsic types) is simply rejected by the compiler.  
> 
> That's how C works. It is not how Rust works. Rust does not reject using floats 
> ever. Instead, Rust offers softfloat targets where you can still use floats, but 
> it won't use float registers. Obviously, that needs to use a different ABI.

That's today's situation, although we do prefer to be able to turn off
floats completely (and also not have to compile parts of libcore that's
related to floats).

We mentioned this to the lang team a couple of times, and they do
acknolwedge there might be a need for it, although it's not something
that today's Rust can handle well (i.e. no feature disabling for
libcore).

We have also listed this in
https://github.com/Rust-for-Linux/linux/issues/2 and
https://github.com/Rust-for-Linux/linux/issues/514.

> As you said, aarch64 does not have an official softfloat ABI, but LLVM 
> implements a de-facto softfloat ABI if you ask it to generate functions that 
> take/return float types while disabling the relevant target features. (Maybe 
> LLVM should just refuse to generate such code, and then Rust may have ended up 
> with a different design. But now this would all be quite tricky to change.)
> 
> > Changing this to softfloat for Rust modifies this calling convention,
> > i.e., it will result in floats and doubles being accepted as function
> > parameters and return values, but there is no code in the kernel that
> > actually supports/implements that.  
> 
> As explained above, f32/f64 were already accepted as function parameters and 
> return values in Rust code before this change. So this patch does not change 
> anything here. (In fact, the ABI used for these functions should be exactly the 
> same before and after this patch.)
> 
> > Also, it should be clarified
> > whether using a softfloat ABI permits the compiler to use FP/SIMD
> > registers in codegen. We might still need -Ctarget-feature="-neon"
> > here afaict.  
> 
> Rust's softfloat targets do not use FP/SIMD registers by default. Ideally these 
> targets allow selectively using FP/SIMD registers within certain functions; for 
> aarch64, this is not properly supported by LLVM and therefore Rust.
> 
> > Ideally, we'd have a target/target-feature combo that makes this more
> > explicit: no FP/SIMD codegen at all, without affecting the ABI,
> > therefore making float/double types in function prototypes illegal.
> > AIUI, this change does something different.  
> 
> Having targets without float support would be a significant departure from past 
> language decisions in Rust -- that doesn't mean it's impossible, but it would 
> require a non-trivial effort (starting with an RFC to lay down the motivation 
> and design).
> 
> Kind regards,
> Ralf
> 
> 

