Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C42F1DFF2
	for <patches@lists.linux.dev>; Fri, 17 May 2024 20:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715978485; cv=none; b=hNAnoaN2zY2RGUnhu6Pw3GWG7KeSpIxcsn2XpQ1N+fMx1yZY9W6ss+xB8CTlqr22lB4++Mo8K6m2OhCxwrcsfTZ+y+usrZr3tFIxHRXGQhVVN1kSqsKwDKHC4kVftGdpYYdKkJyg5ELAs+z2RSd7K/ZVdP/dxLS1fXhs0RHO0Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715978485; c=relaxed/simple;
	bh=zyOuYSC78p7yIHSIK3YPMOawrAe8CDN7YBWgxS3A4DQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nqhASKkJkzxqMicawa0CmLJJAbfK6PDhwoekNth3mG0CzaKrAEWH1R0wJ53/NbN7bSR1It/OFBS4qAG58Gf63EeDZU3eGxetSpRfBo9T4puFNcvvtfimKHLzgcc1TuTu7BWtYCh2gGyoArUqWynL+cFydzkmJ2jKHhVXwCwWDT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=n0E5/zDO; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=55g4QL0b; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="n0E5/zDO";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="55g4QL0b"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1715978482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QZ4h1wQmVnSiPurtyO10mrFNnm7uledEHoSaoAVavPw=;
	b=n0E5/zDOzUr/2cjZmyqgrTpcWoh1DlfH4ji1W+cmuZgXmfqW95WmnY+F6sEDjnrkfFbyte
	c+ZxJJ7/u7RPWRShl81Wy8uLGeB+FswNIj5w/OYC3rW4p0FuFQ8aj4Gq9yUBgw0qGDmOCw
	5aPzMSXxziu9kRh2W1LI/AIBkn/cmvUtLmM4RYFPnd05GeZFd1ou6uVf0SkKReFoL0YzVZ
	9W+LlP3OWNQK/XfLt6IFvpwFd37rGSAIvTDUhUEWaCnpWqJR8nShglK/nFphstG+U2YCPv
	JN0XxScEjqEv9YPT7oyoI2EbwGJMCbfoKGfzHXw5tOKZWAkw5lOJIA9twvIr2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1715978482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QZ4h1wQmVnSiPurtyO10mrFNnm7uledEHoSaoAVavPw=;
	b=55g4QL0bLJxk3dZjc4ExSoZPUHzrPkGPNSdsBkZjhanf8L8la2xMotYhnf58itwaB0iUEf
	hwXf/NpJjRgo2/BA==
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Tony
 Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "Peter Zijlstra (Intel)"
 <peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
 <mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman
 <gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
In-Reply-To: <863D0F06-1217-4C94-B2CA-816FC4ABB103@zytor.com>
References: <20240516162925.79245-1-tony.luck@intel.com>
 <20240517144312.GBZkdtAOuJZCvxhFbJ@fat_crate.local>
 <863D0F06-1217-4C94-B2CA-816FC4ABB103@zytor.com>
Date: Fri, 17 May 2024 22:41:21 +0200
Message-ID: <87h6ewjhn2.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 17 2024 at 10:35, H. Peter Anvin wrote:
> On May 17, 2024 7:43:12 AM PDT, Borislav Petkov <bp@alien8.de> wrote:
>>And then do:
>>
>>struct x86_cpu_id {
>>        __u16 vendor;
>>        __u16 family;
>>        __u16 model;
>>        __u16 steppings;
>>        __u16 feature;  /* bit index */
>>	__u16 flags;
>>        kernel_ulong_t driver_data;
>>};
>>
>>#define X86_CPU_ID_FLAG_VENDOR_VALID		BIT(0)
>>
>>and then have the macros in arch/x86/include/asm/cpu_device_id.h set
>>that valid flag and then have x86_match_cpu() check it.
>>
>>Then you don't risk a userspace breakage and that x86_match_cpu() crap
>>thing is fixed.
>
> I'm confused. Why not simply use say -1 for wildcard vendor match, -2
> for no vendor ID (no CPUID or other known probing mechanism) and -3
> for unrecognized vendor (vendor detectable but not known.)

This has nothing to do with wildcards.

The problem at hand is about loop termination. Making that explicit by
having a valid bit in the existing struct hole is trivial, straight
forward and just works obviously correct.

> I *hate* these strings with the passion of a thousand suns: they are a
> classic case of how just blindly converting binary information to hex
> adds absolutely no value, and often makes the result worse than what
> one started with. And yes, I complained about that when they first
> went in as a classic case of exposing what was always simply intended
> as a kernel internal interface to user space.

You obviously did not complain loud enough :)

> This is particularly pathetic as there already is a canonical string
> representation of the vendor ID!

I agree, but that train has left the station long ago,

Thanks,

        tglx
