Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795217667;
	b=w70xaSM+RKEuvcPPFWTSiI1AZm/X0x1E6/SZ1zEhC8ePE9ZedSPtqp7sbru2kISDbCga
	 fPI9k7FhBkakplSS/dISYokqgpkemXlpN07XUzGU/YuqPMVmygffi010bLU4TyitVhs8+
	 LyLm1UWKiZixDjcz3WeX2JlO+7zxxMycKyVAHpKW1lC64oSzCYvD9N6pJKks8q4ZU3RWA
	 fFh195yMLYIJZ4vz1nna6CcevUsNwG0tGzNoXMCyVsseU86QPOQAtY7pHveSmEDN0kr59
	 afYkF+KnuXDVFIKL8RghzC8DHy+6VQOJdkAZ/XAgPgouMRdiorjtqmsRWmaARnliFVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795217667;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=d5UxhRENKrjN2WqdptUK5eL7RckbgwjJ8al7suyNLmw=;
	b=MJby/eB5tMHoouspTqU4FXOHwGUUyNkoFgVxnX1xhSx7jdmKQLWiZeHKZ8kd+ZR4LYx8
	 G2Td45pH4DbVaU0cA9qb3FKYevU7QFRaRIR9EA+Qko4ZW/ko8Rd9UMoFb4+PEPbUaN2lD
	 ucCuiJ9nqwb8WLzWSwhJjB+/FgpnW2aUQeSNPoVcICes3hOXuoriSHx0mFVkmb5lwTxx/
	 UIiQy9Y5QtRcR+LnLSC84lFGihcRxa9hlinrjSY1UfFUZwsKOGb2roIaqoPSYnuWmadUh
	 gY6b4spyew+NNhyIyDscOw/AyewHLcxVJK682VBMf3g900Ma8OKQuWvSAGezFW0LdPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kPrgk4/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9790E606A33F
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 23:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kPrgk4/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2D51F000CA;
	Fri, 20 Nov 2026 23:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795217666;
	bh=d5UxhRENKrjN2WqdptUK5eL7RckbgwjJ8al7suyNLmw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=kPrgk4/c9iGM7d9omUE7JaPkkuE4JeyTzm9y0r1D5O/JrECRYDQvPeP1BbMl8ciqk
	 8TCLIMZGVUGGgg4QuP4XMgmo64/zsUkKTewyF0A2dy1ssZ2HTqiGrd3V6r2Y+C2C7I
	 II/c0bF/VPCB/WbMMGSil6/nXU52M405WuoIaqVEJSLej7Ao1pCEB/0REFefZ5zH+d
	 ZdYPcwP5GVJDVYWxFd8iCyg9f/WwmGSjr+mrhKQDaHQB46TTVxXNvtPQXW8gdEA1tJ
	 3ed6bbLji/Tj4a6Ya8zgXPxTltDkg/nd+mS2SxxhMpjX/gEKMICeT/nXycy2mTnNc6
	 DBzTCnMfxQLfg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 93458198003A;
	Fri, 20 Nov 2026 18:34:23 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 20 Nov 2026 18:34:23 -0500
X-ME-Sender: <xms:-tgAa40WMd_EPWFNg07JZwyPJcDR9Hl4neZG2sZ60S43JjZakvJQFw>
    <xme:-tgAa94btA2FcjGmKSDp7fs53-xd9zJUgeojcI1BpmZaQ8Kz0eLzPAdMkS9qQ_7FU
    OZr59jIhg8MHlYyQnwbZeEYlF7PpV4Vxlr8KoLe3U5t0r5NWyCYNKk>
X-ME-Proxy-Cause: dmFkZTFL9seTInIL2hUW1OvhO1WNW9/yDQMQ3sNpaBykWH23VqJykrvUISWN+rBSHQ+5bq
    /JQwHxFYPIkL2Xu86dfOWtqtRPVNB/qIKe2+3mjFHHflxOdiuobuj78Hw/FMM8RVcs5xMb
    dS/DET/rxsPx6SEKm1JZ2K/buPZvqwh9FNjgcHALkKy/XLVkevo5sDDIARq2Z//kZnp9CA
    rSEoHmeWmhoezQror9Ty81ka79pfF/gOgXmZ1GkKqAi2/yxezmh6ijdV1UEGYFqsznmeWL
    g6Y1Onmgdfw7a6cltPUu6V6KYEQymMJvNVprAPmF42FlCo/F4k4Y9IbQe/ue2Z+ZHcN6bR
    AVBfQNgkF9KQh6PxBWA+qfee9aUYQOqptwYa8VjqHfwnjVYok5TV5bLTBLvGn0rIl/+57i
    WO2CFNlMLurWUHycX9pn9FDh03suHQbu/a60gn8A1Unl1x/x+0E2LPeaCXK7ov30TPL9HY
    o2ezFIxHQHCXTJI7edwpEegWtCs0Eg73XGWZUHhg6NY3KaNTAF6vI4OBcklGStE1NtEpHe
    N3vHrVedPTfuvnZlHDtl4lFSJEfm8EUJI7Pvrs07l9xMCrxgGBfUi29jmIbjOM3Gg8ZgCg
    sI/r+DEJkCrbUJ/3Cs8u1BxQF8UUwcuBBDKvKM9/eCBqk19JS3CGIDZU1VMg
X-ME-Proxy: <xmx:_9gAa8qH40BxQBQvJaXjFARB-PhdRsMar2JTklrPA3z4SJQHVTmxBQ>
    <xmx:_9gAa3xjvPAkaVp2Sku5NRZNcCLQid1uQn0F3mHKuHRTI4Ze8YW5dw>
    <xmx:_9gAa4fNmE8P0lI-MJYK8bBx9g6OJsEHDExPpHD4o_STbil2bs93ag>
    <xmx:_9gAa7et2LQJdchwIic0GV_SClr-FVPrJ93hKkhrIDg8-j26-Wdt_A>
    <xmx:_9gAaya0K8B0H7iHsoh_BofrwBklH8I5ogjHkW64OyKf3gN1PHCDP1na>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id CDCA4F80093; Fri, 20 Nov 2026 18:34:18 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Sat, 21 Nov 2026 00:33:58 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jason Gunthorpe" <jgg@nvidia.com>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Justin Stitt" <justinstitt@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
 llvm@lists.linux.dev, "Mark Rutland" <mark.rutland@arm.com>,
 "Bill Wendling" <morbo@google.com>, "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <ndesaulniers@google.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Paul Walmsley" <pjw@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Shuah Khan" <skhan@linuxfoundation.org>, "Will Deacon" <will@kernel.org>
Cc: "Jonathan Cameron" <jonathan.cameron@oss.qualcomm.com>,
 linux-integrity@vger.kernel.org, patches@lists.linux.dev,
 =?UTF-8?Q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
 "Ross Philipson" <ross.philipson@gmail.com>
Message-Id: <243c6d70-7c81-4ad3-9a67-eb8cfbf454d9@app.fastmail.com>
In-Reply-To: <3-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References: <3-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
Subject: Re: [PATCH v3 03/11] efi/libstub: Have efi_kaslr_relocate_kernel() handle
 extra_size
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Jason,

On Fri, 20 Nov 2026, at 18:51, Jason Gunthorpe wrote:
> extra_size is additional memory required that must be immediately after
> the image.
>

Given how extra BSS memory is essentially free at boot, is there no way
we can establish a worst case upper bound for this memory, and just add
it to the image unconditionally for DRTM capable kernels?
