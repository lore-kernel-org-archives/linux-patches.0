Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC851AA1ED;
	Sun, 17 Nov 2024 12:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731846337; cv=none; b=h7ZVYeBc0GEkdnoroRt39cE68u9QxWOmeZiG2jGNpbVHODopL7z2+RIrcpHlnNnSQe1qh9Ybzc+sk3x7JTRx9FoC33YvMY1fqVVfz91lwQT0e4myD8oDvzAgWfbDyH68omRlvme5ZJlmTuCI312+qE3gox4Ewo0A/mJLIBRKVVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731846337; c=relaxed/simple;
	bh=METi0w/NkMiw5z6lkH1cPvSH9klozqF92hNWDoxsVuU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cg3oyj13LvUUgR3g1vilpuDTG3L6tstKthOrPNRZwzBOCdiJww3lhGIOys/G0WBBiRFgQR1EICXrwOnhW1pt2g5LQaAJdYcxxQfz4h7M55zW2BmDpzMRksCSAc0vodR6tDzn5gz/VKxanuaviNdSs5E0O2+k5TQc+Pphc5Q309Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=jddM0Hic; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="jddM0Hic"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1731846332;
	bh=ivoElLl6v01dXn3j88D2JzVuA8zDCUIbPPKgg72fH4U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jddM0HicZ6glVWTVoexDcRGDtEPZfSdXC7PSUXrPxmgesfCZ2mwmnvfWGKtSBOGVE
	 iXieeSBAr/q0k6Bz1u6q7Sl+d815QqpV9yXMhzWX4UlRIVOF51A3kQHz44ZAfFWhC6
	 866nTk/LG/jkUUfdGNTEZbPe3tgAYV4aLpqY5YvZA2vyDy3xhK1AOkL1xpYhe998dx
	 hi5LceFRxk8yPcizRFgj9lgIMC9zNr8Jlc47ExTwxayHgrCHKVLsvYPWymHw6djMqk
	 /Zqc9VP5nVkoBikYSzX6kfE4pqaTZczuq+VWIoMn/vEEI+B3PP9V1nt0SeTZZ7kfoX
	 oZjVswpgJPv/A==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Xrqj76vXHz4xfV;
	Sun, 17 Nov 2024 23:25:31 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Michael Ellerman <mpe@ellerman.id.au>, Nathan Chancellor <nathan@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
In-Reply-To: <20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org>
References: <20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org>
Subject: Re: [PATCH] powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang
Message-Id: <173184539742.890800.7357374459961481947.b4-ty@ellerman.id.au>
Date: Sun, 17 Nov 2024 23:09:57 +1100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wed, 30 Oct 2024 11:41:37 -0700, Nathan Chancellor wrote:
> Under certain conditions, the 64-bit '-mstack-protector-guard' flags may
> end up in the 32-bit vDSO flags, resulting in build failures due to the
> structure of clang's argument parsing of the stack protector options,
> which validates the arguments of the stack protector guard flags
> unconditionally in the frontend, choking on the 64-bit values when
> targeting 32-bit:
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang
      https://git.kernel.org/powerpc/c/d677ce521334d8f1f327cafc8b1b7854b0833158

cheers
