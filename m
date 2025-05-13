Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD7F2770B
	for <patches@lists.linux.dev>; Tue, 13 May 2025 21:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747173522; cv=fail; b=fkzRVG5o1GKCK+GUfWXDVjEKUoKm5YodlGV8whsFEen/ghNvCDGkfpR4lexSEvivd/JyXbhJSpHqiVd84IDcVTTgj+hoAeANoq3u0pMQ5chIBpQwe2f37oOBCg4GsnDMcjfJyPR69PE0OFueJLiT1aXDTRgblARxZ0lANYsjnxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747173522; c=relaxed/simple;
	bh=gt2OUGZUgmbYBTRs+8RX4DcgiJvtGczrOlsV9CfOMNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IoeV+I8FMTxQYGzfIeejncqpNmO30+71LBpoMvx2H8lL8UUlzwxlvfZcfTXoiOVOsVN0+xfrYupIt51PQmLNkLm6SUT1u960sKVayNzJdRCDuJgOjp86G36JQIRZq0AuzxU02BX5Sq/qGxVfE5yyx0EwL7leRME9D9CRUGniq3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RF4Vmd4k; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RF4Vmd4k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kvSV1TWmc+5z93eiOUg+d4+DaObCDIZjxJNt8zXBJaiyZClxBxPWuXfXmopjYSmsLUhAPTWW5V0/bVZFtaAsYmYKR8z6/mNJjfu6jcJTKL9LeP6C1lJgilY7NZxCeFiCeltLwy91rAd8t5IO+/LVaT0QRoIstC2xehgHOltZA9OddxdPJtQAIvRXt9kFFkShwJaLKsvIeoXyJztTSej1xlMw2WlwtH+rE7DypI6+druUFi6wlnuJcmk1V5yxfsdMhJSULOASKVuEqkbUG9nQ1B3kGNRsVVMBDlHow0Oska4+Y+pTC/O3e5WW4PcoCuRd4r9H99QNEnE27zXKxINiIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCCl41lEAVwwy1N3lcc5dEwA96cBsTmBYFhuGKdz+b8=;
 b=uuVn3uOUrzz0meW+qrkNkDFL314D1y+W2vrnErF60Rst+C+l0exS5dH9Ze2Q6G7bgGoQFy+BCUOwPXy1nJy08AY/QnzvLQrw6N7yRdirXGSkUuGXTQtWZx/EkftxcjIO3WP340zOSLWzypHWqDM6+tk0cS7GZeTCJx6kZsPN8CWeYte/gzb5meN+L02z1TE6MZ65vQ61OSyRA607ODIsTSKagK51+pfpYC1KpF2AfgnihQFsisU19BnazHbPK/ayfJrvXfuXw/hEkArBJGCfAxI3lsy7thRErtpOJLSxNSWhkU98kzrKdlARiG9hrNJR3wNMR2Qoj+t7HCj5Sa1wQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCCl41lEAVwwy1N3lcc5dEwA96cBsTmBYFhuGKdz+b8=;
 b=RF4Vmd4kAzXV4Z3y2x8k5Idjss/P8tCWnOIt7WwnnKmyCWBfryhEY45ecl44m8RhmPMd/8SRBgZoAl8c82oS8MWZz4vrnAXVakTraykBlwtTYv+86WtBVFicJ6JOVAGBcdByi520rqoPlqTuLbs51tC5wKiB/wWQQ8bC2cav+xBhdiKuKtNlpVw/5OSzBxQdM5f6ChW1Tcvh3z14wV8yToFMWy98ym/qErETfRNtVGw8tuYOmAPHDw+cPyavh+z8GIpzt4bnjRd+8qeNiTolBTOplb7bzSp81NhE2NQ/H3ffjX/9/CtACeW2jYmRXpvHnQvVo2TGaHOzjIrZpj+1Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7)
 by DS0PR12MB7511.namprd12.prod.outlook.com (2603:10b6:8:139::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 21:58:36 +0000
Received: from SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91]) by SN7PR12MB8059.namprd12.prod.outlook.com
 ([fe80::4ee2:654e:1fe8:4b91%3]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 21:58:35 +0000
Date: Tue, 13 May 2025 17:58:33 -0400
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
Message-ID: <20250513215833.GA1353208@joelnvbox>
References: <20250502140237.1659624-1-ojeda@kernel.org>
 <20250502140237.1659624-2-ojeda@kernel.org>
 <20250513180757.GA1295002@joelnvbox>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513180757.GA1295002@joelnvbox>
X-ClientProxiedBy: MN2PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:208:23b::20) To SN7PR12MB8059.namprd12.prod.outlook.com
 (2603:10b6:806:32b::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8059:EE_|DS0PR12MB7511:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fbc2cc7-2f0e-4eb8-a9d1-08dd92694f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9EO8A9mCZ0+d6C41zMY1RMG4UjaUaM1xt4Zm5DC0UW9DXmXp1E2YYEiWWZw8?=
 =?us-ascii?Q?pmm2YwiVnfqUBYVfXRo8jXBVbWqte4Pjk67xQsIFkSi23pTAA7Nxopien3GR?=
 =?us-ascii?Q?ZOG8AG3A0xbKwmk6wNDHf+KA3vQ7FuFyz9JqXUkdZfONkDP6Zm+zfulttnvi?=
 =?us-ascii?Q?CNpKu5EbzT2OZUTRKfu8jCm4BIq4376URlq4kQzCT0+RxvIGNRKRfJiuJmil?=
 =?us-ascii?Q?SQyqC4ci+z/1BtJdHbBJliK1nClSalmB1QRdDaahR+5g//34mRx55OAv3rX7?=
 =?us-ascii?Q?NGsaubGaSy8jlaZGUwjuoV+C9fR7OSgwSj/9DWLMWURWKHqaEflulg38Ydb6?=
 =?us-ascii?Q?Wdf4uTtmtGrhIORh1dnu1q8VxzAUdt2QteeBaYmc2NyoJX7C/BsXoPlblkJY?=
 =?us-ascii?Q?WAzxjL8QJHHq4vEPhLj0bTiN1JPzN2131IsA0exk1KTOnCjeC6MjU7r5EvMm?=
 =?us-ascii?Q?BAP/t2ajv9bRBLE9l4EoG6rfpcVvSNpI5FHVYCNeJKv8e+GduVeZRZc++0QR?=
 =?us-ascii?Q?qXiDl7QWDK8xkUC/2OZvQ52afzcSDley5UXYpcG/sazUXp/zf+3AaFEYXwCv?=
 =?us-ascii?Q?7qaciQ8kYZiukda0TGMgu4hIas7JLIzHLw8TLpoYI4AAbR5cvX5/gkFV4bfk?=
 =?us-ascii?Q?AGsxiRLavKECHGo1F+G4WNn2S1go1NTBl0ukPZIFAE8/IbQQd+Bo+n2A3KXm?=
 =?us-ascii?Q?n4vvWHw95JnViwUqCOCEwl1Y+AP3jJeHRB/kRpW2Njqzf2W022jjN0QH3aYN?=
 =?us-ascii?Q?CgS4aylB3beDkv5dqOWbjq+MD3ZMAJhLZ48R+Edr5mGuPPoC7OTXIFsBb1bW?=
 =?us-ascii?Q?ztokn1Wo1OUr8BHrKlE1zuwlc2RlP+FV/asmgS4ZGG+OjbbGzdYXjj8eyHi2?=
 =?us-ascii?Q?15yW+792S9YzAt+fdlZ93uaRhnJZNQSdn7U+3FPkcjrjmHnNtXZOvPo4rYEO?=
 =?us-ascii?Q?F18eSLm6iU+ZKuoN42/8zHxntRNy+RsIjgJiPs5pez65Xf+RLmgz2bUq6DBG?=
 =?us-ascii?Q?lo8XW8BEfW6KAYBXL3IUWymlgEugAeQDQ46WqjKkOxoeAwaVLLTiyqq4OZnc?=
 =?us-ascii?Q?cqsLaYYbYhcBbbcgbTVQA40uZX9+ejikf4sBzgzq0y7EtOJgb7l4SCTnHiLB?=
 =?us-ascii?Q?ODDuK3C13MlC+iTr2EX6JCyQE3pfVd3bzcbfIHdVEnaKeCYuPv/sPOzPp6V6?=
 =?us-ascii?Q?u+5rU3l98cfXCxjNhsuNw2Q7L/N4u/eowy3dCrwr25r+FS4oWOSkQ3GropVe?=
 =?us-ascii?Q?TaY/14XZnTVRB/MzEqfZ5ugkv8qvokSTecwqh18HQA+0l+KMCgJFoC/r3ID+?=
 =?us-ascii?Q?jWkHG/8tVQaOlbzEbRGmL9ZZyf3cR9d82Jo6TIVUVjX24kYsE3dWiOzbHvsx?=
 =?us-ascii?Q?yDp6Zvsat4QLmjM7hc5rEimSqCguZd8oyASkImvVATTyzZwqzjX4zV5bfN96?=
 =?us-ascii?Q?3WSEsbEOz8M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8059.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/ZkMEWE7kRRGbKaU97XWVR5ZJ5E0xhq2rzwMrV4yxP/3dq6p6DcwujbCEoAi?=
 =?us-ascii?Q?ArnFPNoTGGu8sb+Dgu6EyluV6yoKN54sw/5SFw7IGFaKxQhyyw/2sMVZNLf1?=
 =?us-ascii?Q?tLf49heiqm3f+v7d4PWz1BjGySbpP0QE3JvIziUOZWsQ1J7+WtFZ7aWZskyQ?=
 =?us-ascii?Q?dAdLUnVmnPF4kzTY6/UIA2cpOsqPfMvkH7i6tcSbIr974rIjMsdDOVkF2GXM?=
 =?us-ascii?Q?OPfgoA67z+95FQLEh8OV8G5bpGcpPB/20SxAxBka1Owjd2fVGA5ePyGcWDf2?=
 =?us-ascii?Q?8FO3bVd/J46eeoI4cchgjMOz05KdBTybF9ibxvzH5zFZfT2y8klOMX99i6j0?=
 =?us-ascii?Q?qhca2CRrLMKux74c2btS4RL+WuWupX0CxpcFdT+CsxL3yXc9+0GPRjzHRF0c?=
 =?us-ascii?Q?GZJ67DJUR0cLTKdywh+NHFzBjhSgpUGqZntjE3xmYpEQ8ptas3VSm9S7+ehx?=
 =?us-ascii?Q?pBdG+HRlypCzOlTfd6xMHxHZqlCajgXp2DLLXUZ6/4LJWNlx9WUQb4ngTQeL?=
 =?us-ascii?Q?RwjaEa3eg7yUEe1oYoyMN6cgSiM/NUhSCpn77tDw6gPabW66oOZ/ifCHa4HS?=
 =?us-ascii?Q?nkq8FbhfdAgbHiqsdxwEMooL5xPn1bncxo5mAtK6VGlCPTtNTaFVwXKcEh85?=
 =?us-ascii?Q?9W+IlVG5AtKMVW4rm4u4yErXa7riVa9jx+SEC9CTCpKElWWbZVJBYKtIBxSp?=
 =?us-ascii?Q?A+DQ5kStGVvQg+0zxHRhalgefZXZYofPTMOUzMQfGUItCoThdGcg8u6Atmy0?=
 =?us-ascii?Q?bfTN++cx46fA5CdY7629KA66ifS/Hjx3t7/M7+4GsXPqkRwnqL+0C1Wx3aVi?=
 =?us-ascii?Q?mkkFfvLhgJxA95B21dsjUG39eHAz0bTe3zaG6TwGyhY4PtOgmZ11s4oxj4n7?=
 =?us-ascii?Q?+/1tSmrFz6+tcNIij3dDgn0dgD0ch0efJGgmyaAfTArFGuSGSCxMzc8Z0p3l?=
 =?us-ascii?Q?iBJ1jAiKPlGvnvV0+SJ8ko13T9eflI0nXklgye92UqujBvaqtNJoPSzNDHYt?=
 =?us-ascii?Q?hwa4eF2ltpJJYveFyTFEo5KtauECOF8YactKK+5WC9cmPHP+O6QbOXJ5DcWq?=
 =?us-ascii?Q?gFNm4pKsXW16HP7srBNLRGl0YEilkcfELTD3K/YZfpdx8AvyNVOrv17w5KmE?=
 =?us-ascii?Q?WYlp7KqIhigUkj/tmLs+OP5EeB5tVz/gwiNY2RH6RiMudTtPsyiCod4pIe0U?=
 =?us-ascii?Q?tM7PyvOFzEVVGxPb/SLAmpXReVuBWAVi2R40Xr5MHJ+W6gjisvvpdiS07rko?=
 =?us-ascii?Q?1rLvhj/kJBfIjpnxf5iTyLgnkG8bo5hqu0yx8ej1ywM3SOcCCpXKiPwdtqGX?=
 =?us-ascii?Q?lTjnCTfOdv0O7tVH6uzt0mDnCr5VFhKrPWIiwhFxHGW0Qzxm8+ELVz2+P/b/?=
 =?us-ascii?Q?NPQkhCSnmHCy7d7b2qAaWpKDUQiGpXwTIgcgIpD3VoO73ws/6nKiUmjYL3R+?=
 =?us-ascii?Q?YtdQ27M/LKjtrsxM+HFhheQ7lB/Ou2xT/OL3X2CySR8OMtSZLHmY5OR45A2x?=
 =?us-ascii?Q?gJB9YYhXzJSuVeZSxwwEgFVgOSTrAK85Htv0/7wHE0fm8Ec8Rz7yRGrI7L7t?=
 =?us-ascii?Q?E/fPtPmUq5Cj7PZOAHubICf4qxrqXwBTdL9tq30T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbc2cc7-2f0e-4eb8-a9d1-08dd92694f5e
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8059.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 21:58:35.8869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ti74OyRQbm/ZfxjlfJugEg0OIyqhKRuZJ9z9f/qWxqKhf2doLCgzuazvpae9YAvx6TcJPZi5ywyugLGPEnYFug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7511

On Tue, May 13, 2025 at 02:07:57PM -0400, Joel Fernandes wrote:
> Hello Miguel,
> 
> On Fri, May 02, 2025 at 04:02:33PM +0200, Miguel Ojeda wrote:
> > Starting with Rust 1.87.0 (expected 2025-05-15), `objtool` may report:
> > 
> >     rust/core.o: warning: objtool: _R..._4core9panicking9panic_fmt() falls
> >     through to next function _R..._4core9panicking18panic_nounwind_fmt()
> > 
> >     rust/core.o: warning: objtool: _R..._4core9panicking18panic_nounwind_fmt()
> >     falls through to next function _R..._4core9panicking5panic()
> 
> We are seeing a similar issue with the patch [1]:
> 
>   RUSTC [M] drivers/gpu/nova-core/nova_core.o
> drivers/gpu/nova-core/nova_core.o: warning: objtool:
> <nova_core::vbios::PciAtBiosImage as
> core::convert::TryFrom<nova_core::vbios::BiosImageBase>>::try_from() falls
> through to next function <nova_core::vbios::FwSecBiosImage>::fwsec_header()
> 
> The code in concern is implementing try_from():
> +
> +impl TryFrom<BiosImageBase> for PciAtBiosImage {
> +    type Error = Error;
> +
> +    fn try_from(base: BiosImageBase) -> Result<Self> {
> 
> I dumped the codegen [2] for this function and at the end of the codegen, there
> is a call instruction to to the fwsec_header() function.
> 
> Any thoughts on how to fix the warning?

Btw, Danilo mentioned to me the latest Rust compiler (1.86?) does not give
this warning for that patch.

Mine is on 1.85. So if anyone else other than me is suffering from this
warning, do upgrade. :-)

thanks,

 - Joel

