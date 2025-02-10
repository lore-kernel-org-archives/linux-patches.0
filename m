Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADAB2500B4
	for <patches@lists.linux.dev>; Mon, 10 Feb 2025 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739207068; cv=none; b=Q9wUg5Uwpx4BzmwcHcPYxAftn2zsm3vbpUAeSbZBDLxxm+t5KMItm5jpIYIy6GTXjwkyOjf9IT6Hj8ilpOijYsfNZn4uHsqZ24+2sUjBsv0D3andyOi99fEttnfHBy+koEP0z9PVdVqP2FrHAIpxIj9ypPNFbdzZMdMOwy9qWvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739207068; c=relaxed/simple;
	bh=5VAiCu9wsbnHuDb91xBNptjwUNAtJkr4ewb+2CdrpF8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MuAIVJY/L5BiRVlvCWSlFXeFBGNd6jUOozew7T8GmaR+mw5mFVEv5CYkyBJKB4CBCWaOySgFI+cvvOt2wh4fuBcjXy2xil9Ri0h0fQM6/SWVYSi9mGaLTnYWJAZvAqYt17X+gxHVMm6w5taCruIpJECQjA2tOw8Zra1D60hYleE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=jdYuO2hG; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="jdYuO2hG"
From: Fiona Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1739207064; bh=5VAiCu9wsbnHuDb91xBNptjwUNAtJkr4ewb+2CdrpF8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jdYuO2hGhDTcdQKHK8/9grPS1mwoWTu786nKEmDrhgHW2Di0MGIN6zOrh4/TDYSVg
	 7R+wdKMiV1irQ86ZcXvZpluCO0bxtkZDkrXPLRTrIGp0wdgmh8Ni3eTW90+/ugLc5s
	 5EwprOknit5+ZtGbGdOKPegpDsQxwh8VkrJ2B1j0=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,  Jonathan Corbet
 <corbet@lwn.net>,  Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Alex Gaynor <alex.gaynor@gmail.com>,  Nathan
 Chancellor <nathan@kernel.org>,  Nicolas Schier <nicolas@fjasle.eu>,
  linux-kbuild@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-arm-kernel@lists.infradead.org (moderated for non-subscribers),
  Boqun Feng <boqun.feng@gmail.com>,  Gary Guo <gary@garyguo.net>,
  =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>,  Benno Lossin
 <benno.lossin@proton.me>,  Andreas Hindborg <a.hindborg@kernel.org>,
  Alice Ryhl <aliceryhl@google.com>,  Trevor Gross <tmgross@umich.edu>,
  Danilo Krummrich <dakr@kernel.org>,  rust-for-linux@vger.kernel.org,
  linux-kernel@vger.kernel.org,  patches@lists.linux.dev
Subject: Re: [PATCH] kbuild: rust: add rustc-min-version support function
In-Reply-To: <20250210164245.282886-1-ojeda@kernel.org> (Miguel Ojeda's
	message of "Mon, 10 Feb 2025 17:42:45 +0100")
References: <20250210164245.282886-1-ojeda@kernel.org>
Date: Mon, 10 Feb 2025 18:04:22 +0100
Message-ID: <87y0ydafzd.fsf@kloenk.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Miguel Ojeda <ojeda@kernel.org> writes:

> Introduce `rustc-min-version` support function that mimics
> `{gcc,clang}-min-version` ones, following commit 88b61e3bff93
> ("Makefile.compiler: replace cc-ifversion with compiler-specific macros").
>
> In addition, use it in the first use case we have in the kernel (which
> was done independently to minimize the changes needed for the fix).
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Fiona Behrens <me@Kloenk.dev>

