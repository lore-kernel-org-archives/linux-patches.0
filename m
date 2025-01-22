Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020133.outbound.protection.outlook.com [52.101.196.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410F3212FBD
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737563904; cv=fail; b=Y2+56Q1PMFmR6LnNM5nycVlz1JlWbfL28/uRtISQxiAIYyTEWavqnNnHlvCFpMIcS8duHj8dddkESvlN9oxmTUYkBxp6vSTFZFx7O0pGBRsO4VUm11iZ4tp0mQQG7m1Y/vfISi2muT6CIFzH54ctyQgAbmV+PI39qXqPbA+BidU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737563904; c=relaxed/simple;
	bh=qYUZ3V4EeUw1WxJdjfiVMquox4HFXn7e7lrChGXZs6w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XmRN606onMOeYH6Hj25jpQGrNGa3uhIJwGdpSAD3XjE9zYIjhJbTSxj4IU2AUD+8DDF8bx5dsSgzou69DAHPX/FfDnEXPEExcu0kmX8ME7cB6gbQTvc+hxw0Jr1pXOJf5IAzlXIuBoE4EGgwZYqNQ/Bu7sql0dwfzImdRmqVjpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=X9aYd/YL; arc=fail smtp.client-ip=52.101.196.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="X9aYd/YL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2uwMWy0AkX19BDmolh1v/CErExW1+Wxuy+xGpokkw/ihXTGtLP8xQrFJBfHRxCaKiMz1lTsatvZUa5H7EjStECaPtG2PCAxur5pP0AV6LeKtBUs+9/sHp78EIFxu4H6gOfeuo4DgyyQU3DsitW605oNRLImQ3606h9uGko47OmOl4Bz6jNkGPBtMAz0iqXDJpqUymzZxBpD0iIFmPhNadNHt9tiYzy/3BKqKzDF2Yd4/4r2jGL3n+02o74FVCn3WplfZSEttG/td1bO0QZdzxHPOZkd8h3iXEwiVvYHFxYIczIiPx9KiyLSXAwkSMWciPqC46JJ9m7CEsRGXd9dnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiXxHfmaylWghROeU4fvSHWiQxRYOjIWWk3d71l5lko=;
 b=LqC+/MCfAxy/qslRFHx6HdBSi+KzZBJN8z9m/6IbNRn9vvHGQVhhdsF6HCQrxY3Uwfv4bdOicV2+SEd/fhvqiyidg2Sgd80e8nKtsJl2phj/msuOuieUHr7lxm9BGVoxWd+0QXw+ceQRPBLbmKszYH190xQP+XDxTCdaF128hbyXfQmMEJKqAWszdi6QISCq1BR4a5kXW+KEVcTpmXv3HqMlKJdu57Gs6zOe9g3Rz5TGk0pfN0gFuNYCZzCoIT7TnvjGDoN6AD2aDXq+sERqltwcMEgxnRLdzTNdNjweRgg89kpbHT0OOlBlGCrNOPcdBn+Hl0HkwDaqFJCTa/X6KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MiXxHfmaylWghROeU4fvSHWiQxRYOjIWWk3d71l5lko=;
 b=X9aYd/YL4/prQ+9DIJTYhAMqO3uLAjVknXT2bnGyGP+ZJJUFOVzCUfAWdHzPdkkE77Su9KV2I3/flQdfxUjL8Fbm+iEyItr0ddwntaydQU0sG0oE1ryybY7FxHsDUeyZoRg0xFxqMje1CYz9YfQC3vsDdLT0xi1tvuo8RPsfs6M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO6P265MB6031.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Wed, 22 Jan
 2025 16:38:20 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%5]) with mapi id 15.20.8356.020; Wed, 22 Jan 2025
 16:38:20 +0000
Date: Wed, 22 Jan 2025 16:38:16 +0000
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH] rust: init: use explicit ABI to clean warning in future
 compilers
Message-ID: <20250122163816.4a8e987b.gary@garyguo.net>
In-Reply-To: <20250121200934.222075-1-ojeda@kernel.org>
References: <20250121200934.222075-1-ojeda@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0059.eurprd04.prod.outlook.com
 (2603:10a6:20b:312::34) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO6P265MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: 11df45a4-e4b0-484e-2cbe-08dd3b032e19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N42Iz7enHjd+yNl79qFig3vHG7NyA0uC/x2wAWiml/5K5uXN5B1NEqPafprg?=
 =?us-ascii?Q?n/GR36zrU98T4d4r3XD9/rZcjjt9q9k0swRtZcFLaFbsYo2/7VeZNkdXA5gR?=
 =?us-ascii?Q?o++Ox/JJeEz2yRnplFc27J4KhnxPB2/k57FYLvOMIR3stihmwxrUffBM0Gi3?=
 =?us-ascii?Q?+IGfBHbKdfl4elYl14NBOEn7Z7JGOluFTcOMrVgHn76smHOb7INlgJ4cmJcw?=
 =?us-ascii?Q?D1xjqqU0LJmoRIRRfEdl5TmXSLpq0NZStHhk7E3YEv31COmfytL+VWwSsUcH?=
 =?us-ascii?Q?2RFxHrpSHp0LKnngyEjDw4zeLBdwmSNN+K/nxnZghCHKl2vYbPxBX3ZU4Ecv?=
 =?us-ascii?Q?OzKKvC8e4t2PZLMTzE7Q4QgPvkc6y86X3MtMIjluPl3cPkUviiqHBpZ1fSOm?=
 =?us-ascii?Q?T5edVIS9HI3QQcsl5UbaGJVTTfHTZM3WojLbFo25ozMrH/GABI001a5AEApo?=
 =?us-ascii?Q?K7tniXXsWzK2xuiMxWK4cK7I9YPIRSWIoq44xQUAWmeohFo5lJJABL4oODX/?=
 =?us-ascii?Q?D+jKRzfz4JYYiM3J1uWi2u1EO6ttAm9PlcqGexJvBb/rYdZ02sNjVdIku0tc?=
 =?us-ascii?Q?AVpebCLCXec3RqeOIZ3sZZbLbMfONVROX47BRgV4xREqb3ZEixDMQSXt2DOR?=
 =?us-ascii?Q?EbkjtkADHc2kYvFUKjt2hZ77wFtchkjXmM9Jh17ojyCkGEyD+kwu7FyMmu3U?=
 =?us-ascii?Q?un+b2dnDnKrY90AuIv/ghMuoH/vtmI5h/MmLSflU3WZ0zfFJlCtTZrlW0uh0?=
 =?us-ascii?Q?Oa+fbU+v9IHT17/JnaaS27IOuhYRaa8V06s21f+eWZmpLxLBcERRqWQZhbIR?=
 =?us-ascii?Q?QqP41hESUAYN25Y5ffdz3qXXUitcmcaRBX7Qs1DvxptxwZ7px8btOstrULoi?=
 =?us-ascii?Q?6JxkYVnYyOqsr8oPHriFFqyd8owQxQs5R7IOd0EilntuK2OHNtjqP7fbVQp4?=
 =?us-ascii?Q?010rf8SHitfa0T6X1PD8YFK62L0gn+dlXaSGq2d33m79AInUNtfqrjErxf4c?=
 =?us-ascii?Q?jcdlsc5TUB6EWiMsfRulmqrUe/NeBTa7j+eN8PGDw79mJgqECqNTURv8Z8tZ?=
 =?us-ascii?Q?VLlgM3Ja2uEo724wccd+VKmnjSbFeGargIOiOSF7TQ2k841jZlMLFed5OOuV?=
 =?us-ascii?Q?xWhFJBHubVcqOAopVht5juuT6F42fja5YkvQH1yGNdLgN/40tBx74p2SESZp?=
 =?us-ascii?Q?UaUlzpptOczW+wpk1sHplNkDgFXPOhgj2i1vARjzUs3clUUyK5bpSp+yvD1o?=
 =?us-ascii?Q?HRXoKdj7hmQhiCKTolyfX1l0NbxATqcjqisp6WozeXWcY0J5+5pRcuwHd1en?=
 =?us-ascii?Q?MdHlcVAuupth9bB0NzIcdaj7s1alznlg9cCmWhp2ddHHnoblJvPqdbUhoArN?=
 =?us-ascii?Q?LLFZWCjmUUOnfCclrX5DTp0H9Lit?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iMi+zPG7qMai0n+OqTbgkg0bBweJnELJyLAfpGfnRexvdUngx8k1uA3VN5B2?=
 =?us-ascii?Q?lKHVkttNoycS2nho1hNaZ1445OtFEJJcOYrh1N29fSFiXGhjM3enLZNdyoUx?=
 =?us-ascii?Q?7seWSZcBO329lHZ0vXT2XNPwpeiXk0AQ5N3hQQ2fdQNKVx7/BIJrd/HH1xgf?=
 =?us-ascii?Q?Db0pwxOngMrfGJklAHsQ4ebG4C31PpkLSr/Sb0IBadNHmMK4xo/w08SbjrBz?=
 =?us-ascii?Q?7WuijufZ6WfbfgDoeRMqMsm/fwmYWF7ZTxpfKqrwuP0mi71HZMVWTnkX5ZEP?=
 =?us-ascii?Q?j/P5Cwaia1Je4LcAUCepj55dxpGVhEYA7uvhzN+hTVJi5PDMsldRFls8HLxS?=
 =?us-ascii?Q?2ZWMGM3WbS7ffyVFB/PJTGuE8aij5qSMeci6iHc6N0SBEaokJx9/ZsjH9M1u?=
 =?us-ascii?Q?/Mn/GiVARr/6zp0yX5Brg4EIUxJFkU7+mD5DCNKD+UzDbOxQZTO6skSs/5OV?=
 =?us-ascii?Q?5b4gh+qCZ1zJ6Mp5vULOwiJxWKyt574NHQEJxfYYN5Gku3KJ2ZcO47txUu96?=
 =?us-ascii?Q?zQGzMd/HnzMFomGvJKVnSnjsOP7G6wbei5HoJUhBwyzAMlD+rwcgQIJU89jp?=
 =?us-ascii?Q?QLQWC70+KNFXK9hVUchRsMpj9yqn4Gp8cbAJ2WGO1il0wEuZq4/cbE4iBuRU?=
 =?us-ascii?Q?8N/4XsGZQfFOozrRto40foZGAkK1zasypP5Z94iLoJq1MS2kjhr+lKIpU0y+?=
 =?us-ascii?Q?xMQ4/zUkELEmluccvVve33Qm2Gf29D8+KdzDRInncLkwIBymDQGk03gx8ItR?=
 =?us-ascii?Q?bR5awiHAGUCFHsuYBGPu7OylYNR3el7puXxPfIRQI/cQf6dQf29khLKwN9ui?=
 =?us-ascii?Q?3J5fOJfn++Gn43MfP2YTMIlbdf5mxqqu78yajVl6PagtpA94s5uTA73fvRek?=
 =?us-ascii?Q?5dufdvyqkiukcdf3JeX/PN5mCrE9c/tGHxw48pUxWrOQ1/YXUbKd2OTndPnk?=
 =?us-ascii?Q?FDkKrJJeTWsYuQbxI9TTNwCC2P8qnycOUqD/AXw5ic9DN5rkAMIyEN/6nwh0?=
 =?us-ascii?Q?lMu4B/7k6whSbluzIEOTU6FC3FkkvrpjfUfRGoZABSvX5kfmsEQ21l4FPthu?=
 =?us-ascii?Q?YQsEELDdqM++IvRGxR/smjfvc9c1/ARGe0vOYTBHqYVKE82NBOjz2i68vbUR?=
 =?us-ascii?Q?VmwOPu8rLi7QYCwl1KCtY4DBv1rVEykPGp0SAA7FIoxo8AFB7lfGVhesYbJf?=
 =?us-ascii?Q?sRzs9TENdgcf9zXFeJEiXvUznIy7b8Dfhxqdz/tXrxhlB+Rmj1noyLjqfgn7?=
 =?us-ascii?Q?AzPgS8UN1/r8v3TD7g0yb30hJRs7yYW8GUO3ZV6rXmxx0RTiQDIgUeUf1MQd?=
 =?us-ascii?Q?ry+A32EXoDcUtgwwF44wmgzt83CpyINnD3B94IK88ylBoZgrGSZn/JDvuvG8?=
 =?us-ascii?Q?x72KcF2NHFW5K9kUT8P/rXqx0rxywSZz9nv8zThRoHLQybdakjOweLx0BXVZ?=
 =?us-ascii?Q?LCcXNmZcLoTiTOm4EOCzTu9VwH4GdNoaNbsfAsQW6LPUubpj9e/5l9xxUUjz?=
 =?us-ascii?Q?f9WjpanH+zEnk1EEqEn/3MV+VZ7joheyMoOzpd3YxtFfIhP3hNgbt7R1ofgq?=
 =?us-ascii?Q?gn/t7pjK4hbIqHHtNjcSIxAyF6uZ++nC5y1l7rse2ReSLG1ZcBg6IGBEJueB?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 11df45a4-e4b0-484e-2cbe-08dd3b032e19
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 16:38:20.2513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wPFWwQcqz7AAD0ycCW6eV03bSFmDtK3NpmB6u2Lhi05GQ+xJQ2YA/sjSZpjhYrD18Z1bmXE004zyFDCn7kUexw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB6031

On Tue, 21 Jan 2025 21:09:34 +0100
Miguel Ojeda <ojeda@kernel.org> wrote:

> Starting with Rust 1.86.0 (currently in nightly, to be released on
> 2025-04-03), the `missing_abi` lint is warn-by-default [1]:
> 
>     error: extern declarations without an explicit ABI are deprecated
>         --> rust/doctests_kernel_generated.rs:3158:1  
>          |
>     3158 | extern {
>          | ^^^^^^ help: explicitly specify the C ABI: `extern "C"`
>          |
>          = note: `-D missing-abi` implied by `-D warnings`
>          = help: to override `-D warnings` add `#[allow(missing_abi)]`
> 
> Thus clean it up.
> 
> Link: https://github.com/rust-lang/rust/pull/132397 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  rust/kernel/init.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
> index 347049df556b..c962029f96e1 100644
> --- a/rust/kernel/init.rs
> +++ b/rust/kernel/init.rs
> @@ -854,7 +854,7 @@ pub unsafe trait PinInit<T: ?Sized, E = Infallible>: Sized {
>      /// use kernel::{types::Opaque, init::pin_init_from_closure};
>      /// #[repr(C)]
>      /// struct RawFoo([u8; 16]);
> -    /// extern {
> +    /// extern "C" {
>      ///     fn init_foo(_: *mut RawFoo);
>      /// }
>      ///
> 
> base-commit: 100ceb4817a2ac650e29f107cf97161ce3e2289a

