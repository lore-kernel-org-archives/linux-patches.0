Received: from r-passerv.ralfj.de (r-passerv.ralfj.de [109.230.236.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570A824BBED
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 20:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.230.236.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477877; cv=none; b=A5Cnn1ROplDuAj4nSI13OutN3idlCyVr4SjxtAfPxFMoY1aipUIEBMlG+omrjeHQ9OBONYqfNTLX6cZqXsK/G2Mmp03lhrm10Fw2vm6hFzj5Lk/zTuUq/2OBnaMkuORwolt4KWwI+8ImTP5t5ZZp8fzbr23g2ZlvjZnwTPtVIhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477877; c=relaxed/simple;
	bh=Z4yIAvWFLDmP5unflsXIbZxV+qfHdE5ANG++IPeu0go=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=laT03xzFs/Hsr8cw6lzlOmgGKM1sO5beGkTELNmAZ4yE/ZpheijSGWqy1TeRAgf0L221sMpRkM8pVFnmkjRVJmGAiXwl1jgcTkcEC5OL+XzgGXmrVv6qkinUdEfOe6t5aAfM6YFFNvU4AB6kz2BNQe6rtQHeiKUv/8grp1HBmlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ralfj.de; spf=pass smtp.mailfrom=ralfj.de; dkim=pass (1024-bit key) header.d=ralfj.de header.i=@ralfj.de header.b=kSEyVsSI; arc=none smtp.client-ip=109.230.236.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ralfj.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ralfj.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ralfj.de header.i=@ralfj.de header.b="kSEyVsSI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ralfj.de; s=mail;
	t=1739477872; bh=Z4yIAvWFLDmP5unflsXIbZxV+qfHdE5ANG++IPeu0go=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kSEyVsSIqGpEfeTGb79N8VOeKWuLNrq2ZkXHhj8qfTXa/pAkZXjj2qsIFhss6os/7
	 lDHsgi8p4VERW+drkEcJ6OOEi26eLzxN1/fueHiUgOjUOJ5CjGPIubVbO/SmILDvOo
	 /tMx/qn9RIEn1wRyJLH+SZT1Cda3ipsBFsMZnaZ0=
Received: from [192.168.110.172] (unknown [178.197.218.240])
	by r-passerv.ralfj.de (Postfix) with ESMTPSA id EC8E42052A91;
	Thu, 13 Feb 2025 21:17:51 +0100 (CET)
Message-ID: <9b9d53c6-7e37-4af7-878c-a1c174b04491@ralfj.de>
Date: Thu, 13 Feb 2025 21:17:50 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat
 target
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 stable@vger.kernel.org, Matthew Maurer <mmaurer@google.com>,
 Jubilee Young <workingjubilee@gmail.com>
References: <20250210163732.281786-1-ojeda@kernel.org>
 <CAMj1kXHgjwHkLsJkM3H2pjEPXDvD80V+XhH_Gsjv8N4Cf6Bvkw@mail.gmail.com>
 <9430b26a-8b2b-4ad8-b6b0-402871f2a977@ralfj.de>
 <CAMj1kXHbXfDz96C3ZPyyXB_dSRyxbc4BP3qNN_oemG9T68eTsQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralf Jung <post@ralfj.de>
In-Reply-To: <CAMj1kXHbXfDz96C3ZPyyXB_dSRyxbc4BP3qNN_oemG9T68eTsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

>>> We have to carefully make the distinction here between codegen and ABI.
>>>
>>> The arm64 C code in the kernel is built with -mgeneral-regs-only
>>> because FP/SIMD registers are not preserved/restored like GPRs, and so
>>> they must be used only in carefully controlled circumstances, i.e., in
>>> assembler code called under kernel_neon_begin()/kernel_neon_end()
>>> [modulo some exceptions related to NEON intrinsics]
>>>
>>> This does not impact the ABI, which remains hard-float [this was the
>>> only arm64 calling convention that existed until about a year ago].
>>> Any function that takes or returns floats or doubles (or NEON
>>> intrinsic types) is simply rejected by the compiler.
>>
>> That's how C works. It is not how Rust works. Rust does not reject using floats
>> ever. Instead, Rust offers softfloat targets where you can still use floats, but
>> it won't use float registers. Obviously, that needs to use a different ABI.
>> As you said, aarch64 does not have an official softfloat ABI, but LLVM
>> implements a de-facto softfloat ABI if you ask it to generate functions that
>> take/return float types while disabling the relevant target features. (Maybe
>> LLVM should just refuse to generate such code, and then Rust may have ended up
>> with a different design. But now this would all be quite tricky to change.)
>>
>>> Changing this to softfloat for Rust modifies this calling convention,
>>> i.e., it will result in floats and doubles being accepted as function
>>> parameters and return values, but there is no code in the kernel that
>>> actually supports/implements that.
>>
>> As explained above, f32/f64 were already accepted as function parameters and
>> return values in Rust code before this change. So this patch does not change
>> anything here. (In fact, the ABI used for these functions should be exactly the
>> same before and after this patch.)
>>
> 
> OK, so can I summarize the above as
> 
> - Rust calling Rust will work fine and happily use float types without
> using FP/SIMD registers in codegen;
> - Rust calling C or C calling Rust will not support float or double
> arguments or return values due to the restrictions imposed by the C
> compiler.
> 
> ?

Correct. (I assume the existing Rust kernel code contains no float or SIMD types 
so this is largely theoretical. But I'm a Rust compiler / upstream dev, not a 
Rust-for-Linux / kernel dev, so I might be entirely off here.)

> 
>>> Also, it should be clarified
>>> whether using a softfloat ABI permits the compiler to use FP/SIMD
>>> registers in codegen. We might still need -Ctarget-feature="-neon"
>>> here afaict.
>>
>> Rust's softfloat targets do not use FP/SIMD registers by default. Ideally these
>> targets allow selectively using FP/SIMD registers within certain functions; for
>> aarch64, this is not properly supported by LLVM and therefore Rust.
>>
> 
> I read this as 'this default behavior might change in the future', and
> so -Ctarget-feature="-neon" should be added even if it is redundant at
> this point in time.

Personally I think it would be a breaking change to start using neon in the 
aarch64-softfloat target, for reasons such as what we are discussing. (And this 
means we won't do it.) We have generally, but implicitly, understood "softfloat" 
to mean both "uses softfloat ABI" and "does not use any FP/SIMD registers by 
default". But I don't know whether the Rust compiler team has formally committed 
to anything here. I can inquire about that if you want.

OTOH I cannot see how adding "-neon" could possibly hurt, either. It's juts a 
NOP currently.

Kind regards,
Ralf


> 
>>> Ideally, we'd have a target/target-feature combo that makes this more
>>> explicit: no FP/SIMD codegen at all, without affecting the ABI,
>>> therefore making float/double types in function prototypes illegal.
>>> AIUI, this change does something different.
>>
>> Having targets without float support would be a significant departure from past
>> language decisions in Rust -- that doesn't mean it's impossible, but it would
>> require a non-trivial effort (starting with an RFC to lay down the motivation
>> and design).
>>
> 
> Fair enough. The codegen is all that matters, and there are other
> cases (e.g., spilling) where the compiler may decide to use FP/SIMD
> registers without any floats or doubles in sight. In fact, there are
> swaths of non-performance critical floating point code in the AMDGPU
> driver where it would be useful to have float/double support using
> softfloat codegen too.

