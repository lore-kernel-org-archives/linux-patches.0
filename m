Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1FE187575
	for <patches@lists.linux.dev>; Mon, 17 Jun 2024 22:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718663303; cv=none; b=UZEs0AAyISh9adHB17aCrwhAJFVrV7NuLWDvJBrENJyc4N+olmuD0BgaE8c1XMYH2/H7Cv6o4yP9QEU1B9m34qVND/NYrPsS79yuUuluarZuBcZPq5AzUH+u916sPXFalUbN/mkq3Cfd7+0yQVrGvO1GEfGi188B3KzLyXyPuO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718663303; c=relaxed/simple;
	bh=M5mPEBHxUXC71s8UbBdBfcz9UQ7Q7t0HN+v9aKiwYi4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LlwkcjekoCIP78sziJIBmmHxQfpf7PYgN3sGDAmVD3w8Q0LOobKilDq0MQNG9MLt6xuWwOqKgoeOmUl5l+DHCWf6lYpmsKBZUdb4nMTTEKWpMgEYxlsefjpV7qTo9DZfU5bZBSrfM9alKY7XdYg0eSp+jn6m7JftfgfTLkxFKr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=nQT6fVqJ; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="nQT6fVqJ"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 9B1E945E2A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1718663301; bh=QNhCQNDYb81sDFgxQHqp+A9Oaw8fxbeY3/n6mh6XpLk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nQT6fVqJaYbTs/bT1Gb1G2xm8/OoQb568bJkU4Y1qlIpg1TLErwdR0Xq62/+ztQ/i
	 Ix5/8N2kx/qiOvKzljO8imT7t/QcrxVqbB5ukvIdJfyPtA09QZZep+cVdseVJavBrP
	 desjFmtrFCEHHi0vdI8QNV6nuYeg6GU9WyUQslww4I87thE7h/LTdeOPYntXNEeuDs
	 6TLfEGUWGkcMQSsgcukeNySSqJ4F+Ja12Rk3Zle7/sIPPTYkCgrAFZK02x+lgF0aLO
	 oHM+Izgtm0ckjDHDHol8D+/RsG16KBqZ5Hwi69LUO4GHBuc4Us/CBVHpAEDUugUI7U
	 AiNoKdrIlu9WA==
Received: from localhost (c-24-9-249-71.hsd1.co.comcast.net [24.9.249.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 9B1E945E2A;
	Mon, 17 Jun 2024 22:28:21 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 patches@lists.linux.dev, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] Documentation/x86: Switch to new Intel CPU model defines
In-Reply-To: <20240611204814.353821-1-tony.luck@intel.com>
References: <20240611204814.353821-1-tony.luck@intel.com>
Date: Mon, 17 Jun 2024 16:28:20 -0600
Message-ID: <87cyofgq63.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Tony Luck <tony.luck@intel.com> writes:

> New CPU #defines encode vendor and family as well as model
> so "_FAM6" is no longer used in the #define names.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/arch/x86/cpuinfo.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/arch/x86/cpuinfo.rst b/Documentation/arch/x86/cpuinfo.rst
> index 8895784d4784..6ef426a52cdc 100644
> --- a/Documentation/arch/x86/cpuinfo.rst
> +++ b/Documentation/arch/x86/cpuinfo.rst
> @@ -112,7 +112,7 @@ conditions are met, the features are enabled by the set_cpu_cap or
>  setup_force_cpu_cap macros. For example, if bit 5 is set in MSR_IA32_CORE_CAPS,
>  the feature X86_FEATURE_SPLIT_LOCK_DETECT will be enabled and
>  "split_lock_detect" will be displayed. The flag "ring3mwait" will be
> -displayed only when running on INTEL_FAM6_XEON_PHI_[KNL|KNM] processors.
> +displayed only when running on INTEL_XEON_PHI_[KNL|KNM] processors.
>  

Applied, thanks.

jon
