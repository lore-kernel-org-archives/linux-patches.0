Received: from r-passerv.ralfj.de (r-passerv.ralfj.de [109.230.236.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EE015A8
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 07:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.230.236.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739346191; cv=none; b=iTN8otZVNO0NYAF1mQVikzWsx0R7B2OBVHpjmKGyp9zij0oGxC8uWBlWMnofKaHeikLc1+j2Krta1W+k3Mw97aK12oVJpITwdzu/xkiEGww0EZVw+FedB+BV9Ei3dFM124NcfR9rV1OdCpohIFBl6ZWUgrX6XErxeg3Gos6PcqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739346191; c=relaxed/simple;
	bh=dNEJPQCFXFXFYv8LsS8D1rVs3y39N2Beg7o2UW6ryMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k6G4u5zf0vGAQrVeco0BReB/LQAJkw1A3HC3znKpX40pIeIEYx47qJkhIF14EqPDrUmxnBz7TmNUhRnSS+4lRs1AnadpDwMeBYci3262KkAlS71i77fqXfNH0XqQUAuHNd/YpQ8u5cCYR6jk5e0VLmLeHJRP4SygP/AYjuzqRBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ralfj.de; spf=pass smtp.mailfrom=ralfj.de; dkim=pass (1024-bit key) header.d=ralfj.de header.i=@ralfj.de header.b=H/hn7/sX; arc=none smtp.client-ip=109.230.236.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ralfj.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ralfj.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ralfj.de header.i=@ralfj.de header.b="H/hn7/sX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ralfj.de; s=mail;
	t=1739345687; bh=dNEJPQCFXFXFYv8LsS8D1rVs3y39N2Beg7o2UW6ryMM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H/hn7/sX5xM/uw2kg30IfwLHDywFTYAajrHTQq3WN22+Jmf6LCU4Po3PR5oZVnBu6
	 KDSBUlfksxwBNExOvWdUR3v9Wt3mNE5iQg56I3tYms3SM0yOIExAka4cfZ/ZSrx6gU
	 NpSnAI3A7GGQgE2vW16DX7RsFEuqEmSF+XKvA7X4=
Received: from [IPV6:2001:8e0:207e:3500:4ab6:48fe:df57:b084] (2001-8e0-207e-3500-4ab6-48fe-df57-b084.ewm.ftth.ip6.as8758.net [IPv6:2001:8e0:207e:3500:4ab6:48fe:df57:b084])
	by r-passerv.ralfj.de (Postfix) with ESMTPSA id 267B22050FE1;
	Wed, 12 Feb 2025 08:34:47 +0100 (CET)
Message-ID: <1cfca789-bbb9-4899-92e9-94ff78d07c50@ralfj.de>
Date: Wed, 12 Feb 2025 08:34:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat
 target
To: Trevor Gross <tmgross@umich.edu>, Miguel Ojeda <ojeda@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, stable@vger.kernel.org,
 Matthew Maurer <mmaurer@google.com>, Jubilee Young <workingjubilee@gmail.com>
References: <20250210163732.281786-1-ojeda@kernel.org>
 <CALNs47uBcyTmBdTBAPXiBcAkE0-4tih9j=VAv1rRcTcf_c2yTg@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralf Jung <post@ralfj.de>
In-Reply-To: <CALNs47uBcyTmBdTBAPXiBcAkE0-4tih9j=VAv1rRcTcf_c2yTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11.02.25 12:10, Trevor Gross wrote:
> On Mon, Feb 10, 2025 at 10:38 AM Miguel Ojeda <ojeda@kernel.org> wrote:
>>
>> Starting with Rust 1.85.0 (to be released 2025-02-20), `rustc` warns
>> [1] about disabling neon in the aarch64 hardfloat target:
>>
>>      warning: target feature `neon` cannot be toggled with
>>               `-Ctarget-feature`: unsound on hard-float targets
>>               because it changes float ABI
>>        |
>>        = note: this was previously accepted by the compiler but
>>                is being phased out; it will become a hard error
>>                in a future release!
>>        = note: for more information, see issue #116344
>>                <https://github.com/rust-lang/rust/issues/116344>
>>
>> Thus, instead, use the softfloat target instead.
>>
>> While trying it out, I found that the kernel sanitizers were not enabled
>> for that built-in target [2]. Upstream Rust agreed to backport
>> the enablement for the current beta so that it is ready for
>> the 1.85.0 release [3] -- thanks!
>>
>> However, that still means that before Rust 1.85.0, we cannot switch
>> since sanitizers could be in use. Thus conditionally do so.
>>
>> Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Matthew Maurer <mmaurer@google.com>
>> Cc: Alice Ryhl <aliceryhl@google.com>
>> Cc: Ralf Jung <post@ralfj.de>
>> Cc: Jubilee Young <workingjubilee@gmail.com>
>> Link: https://github.com/rust-lang/rust/pull/133417 [1]
>> Link: https://rust-lang.zulipchat.com/#narrow/channel/131828-t-compiler/topic/arm64.20neon.20.60-Ctarget-feature.60.20warning/near/495358442 [2]
>> Link: https://github.com/rust-lang/rust/pull/135905 [3]
>> Link: https://github.com/rust-lang/rust/issues/116344
>> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> 
> This is consistent with what has been discussed for a while on the Rust side.
> 
> Reviewed-by: Trevor Gross <tmgross@umich.edu>

I don't know the kernel side of this, but from a Rust compiler perspective using 
the "-softfloat" target is definitely the right call here, at least for now 
(where none of the crypto/compression code that needs SIMD is written in Rust).

Reviewed-by: Ralf Jung <post@ralfj.de>

Kind regards,
Ralf

