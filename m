Received: from GBR01-CWX-obe.outbound.protection.outlook.com (mail-cwxgbr01on2098.outbound.protection.outlook.com [40.107.121.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5453D613D
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 19:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.121.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721850148; cv=fail; b=AmSCPp4g0qcwA+PkLAkdOuVk9fYtvShAmZEmumueenvVoSldPuS3nJeXUD6E+C/U63EF+F5oS7TqfO9gukVtdifghK6NFtgWGmYBGA9hbrgvWuQkpW6syIT+1mNeP6hnRMaC52q/TFF/XPGqKQAOV6JgBcOGkK04YPt+BvoFvsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721850148; c=relaxed/simple;
	bh=sVORmB2y6klLuH74FLXloWuQ2aczqoSTLEkSoYAc2Io=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RdBR1dP18hrbNjjm+AM19qdIaLwc9byu6HcItc1Mi1m6vI7parLQdNUE6D3/4mguzOTICW8kbmSOf3I+loh3HffnEwf2usj1qKP7S9bGYMtNU5EEpMEyBahbUK6orhxVqGCeg2MLwYVNVvxuPLLRQmWKcfLwckULB0GI86VWG/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=z71S1CZ1; arc=fail smtp.client-ip=40.107.121.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="z71S1CZ1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+8veLpLIdV0/HVNnkSmL2id1z9adA8B16brHvaOCUL5VVAN5WE/G/4TQR1bghAzPMEFMdzNtOXj4pVBAFoROjdLSWGakqxn2JDCJm0oNPpiU8fUBm7kiqACjRUqjLnGnuMujDXrdYF01Q9YiVD9vXK2dxlBzb6WL2+H843oTbDiXknq/5os4esZF0UHFLqINunVblR/bIWb/8/EqAJbpFS1fCVIljqWC+XpNrwZdabUTJNlFvs9wcou+M5o5+BlI5eom1Jxx0DpuEn1ATGgEC3yMN82ebaYU3E1l0/5bJ3QREEn1BRSCLn0I5w8mE0MLOu84FUjQch+CcobmnzjKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVmNiMWY/FHzsWWhvclZblZYUMGIimP0hPweRm56i58=;
 b=HZwsyZxMz4xyGwvQ8ct7L2l/NgiBXU7hN8LiG2rq6Ae3oZCSO6py1+Zf2UmUuNChEenp3OIzR/yu/UK0GM4kCvABhozDUFEYvcAT/OtsYlwztLxtF2cWuPBsbOr0MnWl2Tq9srvNIOZmSzAouXTp3n6NxZyZrX30KWyvk39tuk5/YTsVfwfyLZCSWD1oZsXC4SgiCfWfmoO4/PXkx1iMnsjeZT/44vqNer7QdeuzeVm2k1y3eggZyiN8hB52HvsLH0cZeRk4SPwvhAGTXRA92qVAK8PT2JXYRAfgxjdxNWAHqXefyt6cKOh1ni7ekA4P6DOCcxRRpFdQSZBMWy5brA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVmNiMWY/FHzsWWhvclZblZYUMGIimP0hPweRm56i58=;
 b=z71S1CZ153yF4wJndh9hobGvl8gLMP3tLu+soYl3HCttLpl3qKYqwKpsdJwnD+IGY+F2uANALc2HGDVGStfzG+60w6EMN/DMPrk74K5NflV60e4cZwdEi/LSFdf76pZC7XiaPzDcf9OaJ8M0Yxj7Si8ZiQ3aAD+M84+xsOJqIkw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO0P265MB5957.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:289::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 19:42:25 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%6]) with mapi id 15.20.7784.017; Wed, 24 Jul 2024
 19:42:25 +0000
Date: Wed, 24 Jul 2024 20:42:23 +0100
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
Subject: Re: [PATCH v2 4/6] x86/rust: support MITIGATION_SLS
Message-ID: <20240724204223.114a1a73.gary@garyguo.net>
In-Reply-To: <20240724161501.1319115-5-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
	<20240724161501.1319115-5-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0026.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::17) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO0P265MB5957:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e17cd7-518f-42ae-07fa-08dcac18be11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aYj5GolQVcd1h6yPFZc/AkhoaNUYxP5Fw9sQ0vQFnzOuO9PRUE754FSMcOkR?=
 =?us-ascii?Q?FIQX1kS6nd0aPx163KGhcjp/LUgKD9k+LdWp/zSANP82J0PrYcqZOMOYlZLg?=
 =?us-ascii?Q?UkQawhk8fHw2pOC95kl9gklKL5nVtoAsEDuA1qNIqStp9PewxQRkCbAPdWci?=
 =?us-ascii?Q?K27LlS+70EeOxDuAvAIWvOiixRYotYybrBuKgZAESW4YCeXTJB7cwbVShRf6?=
 =?us-ascii?Q?XkcZ2JiMYzhXcB3TaQW3xCaS5N58t0DNRS4fThmmGnHSLGil9UA04385kNZD?=
 =?us-ascii?Q?Wzl8SP3LXwsHLB/mbpib7Kp6FixWC5pZ5Xpi1rWzrCW4Vxcno4j2ewjqQvnd?=
 =?us-ascii?Q?2YPqFjCbj+cUWoOYsngjKuhFC5X16I3KVM/QrARA0tt519i4S3Wg+5Azckjy?=
 =?us-ascii?Q?2K/WR5p14LHmsFfGLEVQxigoXZT5avF5T4I9sTMsOaElghlNGE3Hw0Tlm1zr?=
 =?us-ascii?Q?j/dAa3kLqV104d+4d2FZ8KtxprPYxHdseWAW6zhrZJ8viaO2rvu6FhHlCGd5?=
 =?us-ascii?Q?6CwInLWEKYVMd/nJssgP9OYkRJlMbwv/GFWCeNExKmdh+i4Cw1bxkRdoHufr?=
 =?us-ascii?Q?Enm6xgC2VpwtohF40//9plPjxL00cltfZN0njkE+x5DovTVv2ws+6Skcn1N5?=
 =?us-ascii?Q?FEymfXFyvgjhGV55gvlfVjfhCyF+RzYtPFusVl+ehwg3JevtRlWaI7Hq41Np?=
 =?us-ascii?Q?2192nf3RHC8lTvX8BwQkZe9p2ksLuAIIP9AjiXUzjmaTyR8c9b7Psx5tNPNH?=
 =?us-ascii?Q?RTZ9Th7qH72mWZ2x9C0gPFJ9o2G8fTJtOwUAMUU1WK0AekxaTS0CAIg4U9or?=
 =?us-ascii?Q?eoTXrhTw5KmT65IY4lJN9/YVjY+cFrw7JePnlU7UoOpphriJHKR65PuBGE+L?=
 =?us-ascii?Q?0RbCu4qHFKgbLyedw+W2f2WvSxLdsE5pUZdW6VqaD9ZvM6VEUMRU96j84smO?=
 =?us-ascii?Q?Ikp8mNsqyvhW2ReCA8ztZw6triDZaF1Wjj+dk2iTKZS+JP2wLCkKVvJ1Xghs?=
 =?us-ascii?Q?0NIWrcqUH60Nv+gJHOQBlVhv+2ppkbGg9YMX2IR7ulEivC0iJMK2Rno8Bybm?=
 =?us-ascii?Q?QrSLUVpA49yldLSDE58V0KXfFsFSYIZys+hEFz78pqf9kIRdX1Zn6Dq0fLJw?=
 =?us-ascii?Q?LAGisxBbLPY2yvGp2FHr+SDWllTw2rpgy93yTfWwSOl30RgoEpc70rP8Jn+b?=
 =?us-ascii?Q?6bwqgffz4UNFvLyWM3X3Ry6Prg14BWzvdUPqAeDOBpoEKrF0+XuGqDMrkgCa?=
 =?us-ascii?Q?ncIQuOHwomB/RRL6phs2gA3gZAcm2HLxj/p2ToeEl0j1NBGLbTALVLTDI4gK?=
 =?us-ascii?Q?GLY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B81NuUrP5xp+NMFpXB5I0uyafjMYsc8iYBtALgvEr6WPU3tUUG8V0FkQRVp5?=
 =?us-ascii?Q?Xt0SEKp2gijFDM7oME6kDkkZM5GX/YdppEi4pm9wKymt4KUjsFpGWBcpnKSe?=
 =?us-ascii?Q?aH9obYrG1av3J6NxgnTjpCE16CvONkPMlfobuBb4RHbKnZeq9DjAOiZs27fJ?=
 =?us-ascii?Q?m4pCnjvIL9QdBzDIAEZ4CE3A83Wi2Ks27ULUFq3pFFNOVk/f9xnrN8aRkB3X?=
 =?us-ascii?Q?VfQo/Ccz8M5qXnimRTtn1MlR/vMkXTMaNBvyIIjzq0gW4+KmMb1Bz15LKSJc?=
 =?us-ascii?Q?pwdIXh4RqXuNx8qZLKGlwJumRKV+HS+Rb17y5S1+fAXYapGMIr41tBGoZ/eJ?=
 =?us-ascii?Q?f/MR6pTLHq+a16ZT2i4Q1Fb9zwtRc3MXsqkWYKpiL748XuaF77FHWwE8itN1?=
 =?us-ascii?Q?hcyALEo+H/BxjofxjRXWQ5OP3chZiF+IwF0sS7zib5x5RprQ0OGWa2qrkaSi?=
 =?us-ascii?Q?lfHShR65Ie9vKr6LYM0H9yWeIlseJFjkAd0INOrHUTDeqOPKoUU6MGmXLxiD?=
 =?us-ascii?Q?hWUPM72vywI2Ohjkn/Q0Woh3f3vfL5j1PGrOStg91vj4RTBK3et9/sLml8qA?=
 =?us-ascii?Q?N3Rnkg6GgvlFmRYudIievn3wDeZds8bQvYmp54AeY0OJD3skhXyOnFlwD/32?=
 =?us-ascii?Q?+134m9+jmTtiXtYlDRWEFrK1Hb/QzpXzPm5kvkthOuv3MDEpIE6Ek3FF8bKr?=
 =?us-ascii?Q?VlnKZij/LSTgJ32pDFDNUryXoWS3ZE/ahoZDisKMG8imFsbpDeULCrSu95RA?=
 =?us-ascii?Q?y/u2qNWTp4+a8X1BhAw1GDVpRvhY0Pe9X6ReU71nCjsJAiSwMf2fdmgzbHuj?=
 =?us-ascii?Q?KZ79K1qOgxZX+fwDN2A2kCoRHRgVIMiHkbJXWsF2XeF3rtBnfWr1f5axkuLD?=
 =?us-ascii?Q?z2kx6cASpdHKSKHHW5lwJ8q1FaH2u+5boJpZt/uYa1+1mqwUJ6+M3nChqoSQ?=
 =?us-ascii?Q?WtySwTWXezxbxhJZ43ei0eG/wzYdjH863a7NbxUiOW8f88EdFU6spAHfwo2N?=
 =?us-ascii?Q?1tajzWh1lq658FBcACD6b2ZD3hJ+aRro2xs24lF+GWZvpmsKXW+QIFnQhjEY?=
 =?us-ascii?Q?hhbhKXRM9WWMZCLjec0CLQcy9A0xkvSV08KKHdW1lCy7GWdepaCDqqtn3uZ3?=
 =?us-ascii?Q?V62o9GLwvwRIff/3ZkcY1MRSkjs0ElazzQT44Ol6EUszcuuwXIv/l5hJmKIc?=
 =?us-ascii?Q?Lqa3dnrF4HrxRL1VZPRzIarHC4Fqz+TPnj/0dF5ri+4sZIpqkRRQZqWnS7Wy?=
 =?us-ascii?Q?/llgNxAlyEW4WEnjSLd4gONDWYX56qTdjNi3GrK49zzjdkuC6wIOanXePEng?=
 =?us-ascii?Q?ep4TA25S7tQxFL0djOlOP0HofbSHgDgqhuVV37Fa2E1/tblg09tjpPfWSPIS?=
 =?us-ascii?Q?ukAzvT1i2G9A7hqSaXzslg8B0bdN4LQWC7JGpO566XKd5dFG1T2PC4WBmOS3?=
 =?us-ascii?Q?30InVRlcIb5C74ZFjLQHjukNmbMMDx56mroKDxu4U0hi2UVxqouelKqDr+od?=
 =?us-ascii?Q?uoN4CqhfTYCfmp5uxqd0fteSsUUY3+Flz7UI/OL7T72+6Ti11J44P0e+gaCK?=
 =?us-ascii?Q?R2rgvCp7V6ryTRhhDa6oSlYQPVbad06dAFcLJDe1?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e17cd7-518f-42ae-07fa-08dcac18be11
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 19:42:24.9804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNHpMsO3QUxVTfNP6R0BpxkbCkKHoX2+8mQVOfils/8BO8KhvYel/qY0q6IlcRMzVDrdthI2rXyppcSafqm+jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB5957

On Wed, 24 Jul 2024 18:14:57 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> Support `MITIGATION_SLS` by enabling the target features that Clang does.
> 
> Without this, `objtool` would complain if enabled for Rust, e.g.:
> 
>     rust/core.o: warning: objtool:
>     _R...next_up+0x44: missing int3 after ret
> 
> These should be eventually enabled via `-Ctarget-feature` when `rustc`
> starts recognizing them (or via a new dedicated flag) [1].
> 
> Link: https://github.com/rust-lang/rust/issues/116851 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  scripts/generate_rust_target.rs | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
> index 44952f0a3aac..ba1bd455e160 100644
> --- a/scripts/generate_rust_target.rs
> +++ b/scripts/generate_rust_target.rs
> @@ -173,6 +173,14 @@ fn main() {
>              features += ",+retpoline-indirect-branches";
>              features += ",+retpoline-indirect-calls";
>          }
> +        if cfg.has("MITIGATION_SLS") {
> +            // The kernel uses `-mharden-sls=all`, which Clang maps to both these target features in
> +            // `clang/lib/Driver/ToolChains/Arch/X86.cpp`. These should be eventually enabled via
> +            // `-Ctarget-feature` when `rustc` starts recognizing them (or via a new dedicated
> +            // flag); see https://github.com/rust-lang/rust/issues/116851.
> +            features += ",+harden-sls-ijmp";
> +            features += ",+harden-sls-ret";
> +        }
>          ts.push("features", features);
>          ts.push("llvm-target", "x86_64-linux-gnu");
>          ts.push("target-pointer-width", "64");
> --
> 2.45.2

