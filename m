Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139652AF1C
	for <patches@lists.linux.dev>; Tue, 13 May 2025 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747159685; cv=fail; b=OAMTdn4jdh0IfQSppz8rWu1ZSdKkxHUJPpxzEV88XfdZpgBidrwvOC/SF3ZgNZN3ZUuYjhWNuqHI7iVxaOy0WTGDDgwHdOR/0/ENVyZRkJ2r2hya+1ltzyoQWk9vIcOkA1y8v/uSfKP6sjbr6+BUjL43ddJ0WDMa6DHYhVWRi+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747159685; c=relaxed/simple;
	bh=DiVLv+CSvvDcBHzAG3fHCH4KWWn0H2YJ7pROAHmfZB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gGcey0zG+psh/U0mORWJ9iwVLDVF3UyJX2XX6cSr5ANogm6wnPqlc5Vhv5wyQnHN6UCkgIZf77dbbmF/35LnKwJq//bUu7Hs4VjK+w6Cn4TdH5h3Q/K3uXCGyfp2o3b44U+3JFRcvkXje6AJF5//7bIJkzYJh7Xkvy6lR3hEVIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H+85oZrd; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H+85oZrd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dFyA350pd+xJ1898x2N8XfkdBsZuidIaeVWh8p2lWkIctNdebaf2zy+DSINMCFifsjroyvAmVkSIotK6qVDCO5aDk2riOlPFKuvVCYDWy+n4gBo78teNxGKfgmOt5we9k53+MPx/GMaTIv8il9iCoGnxDMI/XDWOXpWlNEPT9i0CnH41xI3SkQlUc9Z7A14lI9X4vu3CU/Q9sjvhWHqAMUsd3rRJzapGFjHkEmw4M7tYheIwm7bbDKX3++YpLOh8qlXdaiqBehmdAruRuLhLrQIY4Dqxc1Afq6/lnsdqg/Z2vm/Zx8fp+VDAFysb+zWUuSwhjskttEz9A3LYotundA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBBm6Yv/AfS4cDh/NLwLrtXaosVnqfDThvjk4GNLciM=;
 b=L+Ind297TIbb9pLg1k/oJ9XkN2d02Wdykrn7Bueek4BDXfgSD22HV5OHS44bYvmVPRMcYDt3qNgEXxcExR6K+q/rob80cW7sSRLevFzIH/WYH8ExEnMD/c3EzH4dpByF5cacNPXQQXlSm0DDc7TdxwVdBXiS7B53zGn504NJJrL1Owi1buzGbr+ieHKLfVrKqay8xoiUpqXunNQmiXd8sdCphYZDdHOdhY8lNzdWVFaCkQMrrj4rf39ysrCymU/2akLy5lFDN1oLL6FLxuQOI5cApfimGMexcV3jMaxwyNMrPAk5GZQAGG/CK+5c11Qw8J2V+whc+dxIa8x3fgIbuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBBm6Yv/AfS4cDh/NLwLrtXaosVnqfDThvjk4GNLciM=;
 b=H+85oZrdxGfvzEG4TF7AX7fJDVBNimzYeE/eyIGKKqHrzXqN1qvY5qKwFLilyzVhVRiRLXbSGnGm4JKZx4ekgU7MhjM68qCzX6ykKILlMsSRLZaRzMOmkimNmZ41G4qHthBlP/TGVNY17AL80yWbcTyFfNEhbQW9PxNqNm7YZa9kt27O0Yw458NR3xRAjSQgV23O9z8BnWOcP1lv/Kxe7134OV1kTp2PjOXl8GgQCiC+6tqt20yOKGl/Cbchhr5zj9Qfpwu3oe5fHe5XR4h33NIX5Jay7b06rYPC3P6wwNylAfuQtTtvEw3fCOt603h+rnnngY/cOvLECUsuZ+1Gvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by MW4PR12MB7240.namprd12.prod.outlook.com (2603:10b6:303:226::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 18:07:59 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%3]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 18:07:59 +0000
Date: Tue, 13 May 2025 14:07:57 -0400
From: Joel Fernandes <joelagnelf@nvidia.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, ttabi@nvidia.com,
	acourbot@nvidia.com, jhubbard@nvidia.com, apopple@nvidia.com
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
Message-ID: <20250513180757.GA1295002@joelnvbox>
References: <20250502140237.1659624-1-ojeda@kernel.org>
 <20250502140237.1659624-2-ojeda@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502140237.1659624-2-ojeda@kernel.org>
X-ClientProxiedBy: MN2PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:208:120::28) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|MW4PR12MB7240:EE_
X-MS-Office365-Filtering-Correlation-Id: 39ed9f64-3ed3-4e61-2a89-08dd9249181c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZqQHIcZEZs8n132VToEW8Ds2IyzTkqSPi/QeCH0ZNJpQesClN39Y1NaE9gYT?=
 =?us-ascii?Q?SjI8VFi2S+cVGhO1wD1vBcwp8QkH7Z97KM3ECouQ6FbhV3M2s/dfBJq3ktbP?=
 =?us-ascii?Q?HpkPI035pwS3RGDa2jpzhz3nW3CYiQSVv8PJ9hFpQmf69rJFF7TvBeSmQhlN?=
 =?us-ascii?Q?ir9OPn+0Oa+QUO19zjmGmoJvDeZq8IxiBUfDl5XNTAXsO15/X7WPXgBbJFCB?=
 =?us-ascii?Q?01fsSt1GAi3i9t4JVv5GuctrNFJdo71/q0qo14U7Yimi2vY7NLxkCpL1IKXW?=
 =?us-ascii?Q?7DWMazKgl/Oro7+vuzx64y3o/nDm4ytoVsEQFJIRn7aC87i+PgHbwQ4QXA3e?=
 =?us-ascii?Q?2gdiAesPECkgM8fjMrcKEzXjUrxrGmcIcWLe8uedWSdfXsePCvkGUi8jz3dI?=
 =?us-ascii?Q?qgwzbVAwWYcp7zfEwDN57MY2WZDLJ0GJzjV2RcZo4jFoXhmjD/s1M2Lz/22f?=
 =?us-ascii?Q?j1LrfRVn0JVf/ljrm9oEFT/ByYhmmPKIuW+wHZZoiVWC6qxkKsH11mdfdRlJ?=
 =?us-ascii?Q?RbKb/+qTmETsaveCZPolnyGhcBmARlqN0YCyv2qjlcnPqwQgVfYdeS8vnLVB?=
 =?us-ascii?Q?1rocxjV3wW7AFalTXN1XOCzQxE9CfW5E53IlQNsfN6jDtzyQUxtSkDZ6MeoV?=
 =?us-ascii?Q?OFgTdtB8azWmBZ9XSTmQKqBayjYTF+vykryzB+SEKDEn3/I6PrL0Ok7yrnVw?=
 =?us-ascii?Q?ZF5t0MdGepbvAJ6UCUuiVzlHZGZ3xe7VRhWCPSc11niKNF5Mn7NuXFyEF7mn?=
 =?us-ascii?Q?hHmga34G0WoRLor5GdkVq9epE5kJHMPAh7uPo199+amhds5d6WTyr9v5DfAd?=
 =?us-ascii?Q?7ByDZoBWm1gDLQ3LNNMx9PccaqLAJL+oywJqqT75xV09u1gFlItZh65OhudF?=
 =?us-ascii?Q?DeIozsnIDvYZ+w30vSyvYo/X1lIF1QyisS+GoJ00bL+2j6Y/okRNZfVQGmIV?=
 =?us-ascii?Q?BQztlLm6+giOIjGYbvC9fmE3Bp11VLOFE6t+MIjHFpulbBT0GwTa2k9qO9uj?=
 =?us-ascii?Q?RCAhYn3M3cTW4PI6smJAlFOp/izIJ9w4ND8VZo1xX7GfY+iEhV9HKEwZFuzn?=
 =?us-ascii?Q?Ax65IxY7juk9JJByYaQoxgxirxreNTSXjcxcKej5qC2fEFPrali3nd+x/S7b?=
 =?us-ascii?Q?Yvx6jakGlWNgZ3S3RIirQn2YUsF5QvlI1SWKRLqdjzcxNepC0xIF/4oA5GnG?=
 =?us-ascii?Q?Ikb3VigiuUH8K5fN+kwx+6WqN/ObBvjhucTeC5au0pAsxJflK4NOaaBgcgER?=
 =?us-ascii?Q?Mh6Q6yXYK4BsfI0t7FNWMTROMRn6Q9mXNtPIIekBmw1YxwZHdFTl9ec8xnw9?=
 =?us-ascii?Q?tlPsClcrIt2nn3dLvCsA9YshXqVE7oGRapYYEtL3UXPwYeQudymRlWiBxcw6?=
 =?us-ascii?Q?is3nfvIpXTYXFhEmoU4uLprZh3Pu2n57tTsF8P8jRdaFGSzzXveneb3K4BZf?=
 =?us-ascii?Q?2u7CMFfEJz0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KcA1i6RksMvuYXQzUuBnB1hLNOR9xVCUwgGINVjHCOJE7cwvCZHAwUERxGkV?=
 =?us-ascii?Q?K46ermCgIVaP1WYBt2xlWaHDCApP86TWao2l11MtnqRRSWgO9gaY0Ed//fad?=
 =?us-ascii?Q?rn2fLMsqYIrT6ahJPJEOKe2j6ASuoVl6l9Jff7a3njDqwIya2zCgxA+qQWhp?=
 =?us-ascii?Q?mO/RvhSAFFHxcTqKKPQSBsqbmykvbI6S2/JWQRo8osIaHVrsxEy58O25czJR?=
 =?us-ascii?Q?L66U/3mggyjjB+nLwlCUj2eKVlgmtc3MVNdwsAnWfoYTEs8tifnBpwG5Hz7d?=
 =?us-ascii?Q?7bn7287pc9u1xdU8pt9Jnb8LF06lqpkSBTj2ogQ4zkc1PnLAuezV2oo9dyhC?=
 =?us-ascii?Q?/1J4uZ9K0BDmXdc4ZgtRlVNPO5lrfbqjcXlZJnfeJH1zwEMyRx9iF6qYlmnz?=
 =?us-ascii?Q?UQN0qnJJ9tXHPmw94HUPqq/wPulYF4ohcKfbHJX8AD95dgcbeoc7eovS4SYo?=
 =?us-ascii?Q?ekFpdBH4ll8DrGYr+y5ZkjW/jGYhKeQ15As/BmLN9NpJ5bJ/ZM1zs6Y0w23u?=
 =?us-ascii?Q?6cGktpYO3Shgeb7cvQJbdtollE9reOoP8VqWfjcujjW/tlms3XXrCrXRPu7G?=
 =?us-ascii?Q?YgtMtCT5ms9FXuqwI+sLMKph4rtiKBi6K3Pk+LrUn3e1TXissx+m5Yjr4Chd?=
 =?us-ascii?Q?3j0E8QI1W1eR5bdAS+/ygWH2FRzWbJ2K2+9SQCQSQUFptbuE3pBzdklqvPao?=
 =?us-ascii?Q?s594ebyoOKLc6vML+ikoAsFlzprOJ3NEXwi+BeOEfZJBzrN2S3a5kgckDTK/?=
 =?us-ascii?Q?tnrrBB/PwRZg21jcVkMYJGbKg/4tTfZEcSLXfST/juqkoEc8qbOBmtNzeYZ6?=
 =?us-ascii?Q?jrNMHiZc3nL6EpJWxhVnkKYDetRFmuHeOQ1NlJ7Pi5ABweGlWWpQGPgluG4G?=
 =?us-ascii?Q?19oQpyEc/7YJj+XWz2JU2DbrdoAoGQ9Rd1x6oEqlsTYP+jh7oKJRxh7m1FT2?=
 =?us-ascii?Q?m3KdHaHMiC4UkfQJkAbcJveKyw/uL2DGVdT7EPBQ5TyoXNGj7y3IqNx+XcQI?=
 =?us-ascii?Q?F1I4MIv6ao3Hw1wHQNKtoxvTErMPfFsQirwKqtNjsLNLHOP98ccPY5U5pbDK?=
 =?us-ascii?Q?gmlAk2P2dLCism+TP2Qmh13qb/ruxrHX6sfTE/x+FMNdZr8xTfeJXH15uG2t?=
 =?us-ascii?Q?JiY6CSS415A/KOOXd4sAhKFgekn2l+msTWGw7NbJUN4pZtVsYoxSXGEKOpXZ?=
 =?us-ascii?Q?Tx5gs82kI2frDpLr5Jo5U9MdWeQDuX2+ejW292HvxNuemACkqZml+Txn29o/?=
 =?us-ascii?Q?jm3vpeCBCsG0V8/684iYURV9y/PqE+ItuKhOuhFoTCa/WnIpRkCtwnDyeOKz?=
 =?us-ascii?Q?GnSOxO+8sxng5ZSpGJiEOg+5pZ9UGiRYinrVXNGOi+x337fUtMjox1MWDM4Y?=
 =?us-ascii?Q?Dl5eZ/FJduO+vTU0hgcj3aWU6jzHv1Z3YQPxgzu2EjPgCgTn+Y2v+demTzBC?=
 =?us-ascii?Q?HYQ7FrUCoIljOp3oAcEZoJceJFUYXYzFo5R1oS6foX1Xidk/xaVpPJcirKb0?=
 =?us-ascii?Q?8t3fWwlI/wHTOlqLn/A1X+fvy5Y/rYerBu3rZJGQKU3rkPv4Vdn10wP8omEq?=
 =?us-ascii?Q?ozibz+Nv0wPOWk1tSrQiRce6oWxWhHAkY40C6bhU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ed9f64-3ed3-4e61-2a89-08dd9249181c
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 18:07:59.2981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXASC+rILuoL1VjrLD557BnYhvOITc//O80VthKHcH9CO998Rc0yQt5o/oZnTWUA/mDzgHG8AvnHSRbCz/ysFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7240

Hello Miguel,

On Fri, May 02, 2025 at 04:02:33PM +0200, Miguel Ojeda wrote:
> Starting with Rust 1.87.0 (expected 2025-05-15), `objtool` may report:
> 
>     rust/core.o: warning: objtool: _R..._4core9panicking9panic_fmt() falls
>     through to next function _R..._4core9panicking18panic_nounwind_fmt()
> 
>     rust/core.o: warning: objtool: _R..._4core9panicking18panic_nounwind_fmt()
>     falls through to next function _R..._4core9panicking5panic()

We are seeing a similar issue with the patch [1]:

  RUSTC [M] drivers/gpu/nova-core/nova_core.o
drivers/gpu/nova-core/nova_core.o: warning: objtool:
<nova_core::vbios::PciAtBiosImage as
core::convert::TryFrom<nova_core::vbios::BiosImageBase>>::try_from() falls
through to next function <nova_core::vbios::FwSecBiosImage>::fwsec_header()

The code in concern is implementing try_from():
+
+impl TryFrom<BiosImageBase> for PciAtBiosImage {
+    type Error = Error;
+
+    fn try_from(base: BiosImageBase) -> Result<Self> {

I dumped the codegen [2] for this function and at the end of the codegen, there
is a call instruction to to the fwsec_header() function.

Any thoughts on how to fix the warning?

thanks,

 - Joel

[1] https://lore.kernel.org/all/20250420-nova-frts-v1-13-ecd1cca23963@nvidia.com/
[2] https://paste.debian.net/1374516/


> The reason is that `rust_begin_unwind` is now mangled:
> 
>     _R..._7___rustc17rust_begin_unwind
> 
> Thus add the mangled one to the list so that `objtool` knows it is
> actually `noreturn`.
> 
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
> 
> Alternatively, we could remove the fixed one in `noreturn.h` and relax
> this test to cover both, but it seems best to be strict as long as we can.
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  tools/objtool/check.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 3a411064fa34..b21b12ec88d9 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -227,6 +227,7 @@ static bool is_rust_noreturn(const struct symbol *func)
>  	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
>  	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
>  	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||
> +	       str_ends_with(func->name, "_7___rustc17rust_begin_unwind")				||
>  	       strstr(func->name, "_4core9panicking13assert_failed")					||
>  	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")			||
>  	       (strstr(func->name, "_4core5slice5index24slice_") &&
> --
> 2.49.0
