Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2236B195B18;
	Thu,  7 Nov 2024 08:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730969107; cv=none; b=pPK/rRGchdw/GbtHwW3WA6zQG1ZwQ3sMRtM85vWK1Envra10vZlHsErN76hADPbCocsBESH+bK99iBl3ahSuTo+vaIoV9nKgMEmA8fc5U/OOobg/9UaVZmPDKS7CwVd+kf/gjnM4fDgPnwPSdifgjd29nAhRqFtxYHekGVZKlkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730969107; c=relaxed/simple;
	bh=U+nLWayBgZ453pBfHpZ4axu4m9FMdz5QY/yaatT2KNc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sUCxLpxRocHP/7zw8OpUzn3VwKzWCzSzMbspPJrnVU234loF1PDanlqVO0fmFTdzMtyHNk+2VQXmuV7huMy9/XMZ8+GQzBOyKJKRYPQw6tp+A+E1WMO5z/n27suTXsZ5s63exnyTuBG8STWt9fNp8WrXm1T4LkhbqK74Yp366zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=f07FxH7f; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="f07FxH7f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1730969102;
	bh=v2eWMiptyDtzPkjPBE+lL4CiTwJcR2mPcVzcmcVQwG4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=f07FxH7fhzQx2+i8p2lpvbpFrg9vJisXSrolMJLtXR29iZy5cSwJSmTG/i1QL/FUA
	 tPmnvtW79vy3noD04AD78xOyb2eKtjcgIondWh9rrYxDHQa1VyeuhzcJaiPvygmtvT
	 nd8W4I81NYn+O5CJPIb+E5GGBZnxqy34YxI4pr6MPlIyw3nSPBRG0ojGUnmwmxkd5H
	 E703KTbvhw2gXUEqFhKZCJtrqbCwI/mVY17YNjZCMNUp7J5MogtnXloj4qj9NIXfWc
	 IghDWxBmo00S4Q68LaCagMVJCJvoVpo9FNRo5NuBZe6J/Vuv1IpXDpCN8vMTqSMA6q
	 AH8TpX+qHNZMg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XkbHK50pyz4xG0;
	Thu,  7 Nov 2024 19:45:01 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Michael Ellerman <mpe@ellerman.id.au>, Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
In-Reply-To: <20241009-powerpc-fix-stackprotector-test-clang-v2-0-12fb86b31857@kernel.org>
References: <20241009-powerpc-fix-stackprotector-test-clang-v2-0-12fb86b31857@kernel.org>
Subject: Re: [PATCH v2 0/2] powerpc: Prepare for clang's per-task stack protector support
Message-Id: <173096894645.18315.12963917579657771949.b4-ty@ellerman.id.au>
Date: Thu, 07 Nov 2024 19:42:26 +1100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wed, 09 Oct 2024 12:26:07 -0700, Nathan Chancellor wrote:
> This series prepares the powerpc Kconfig and Kbuild files for clang's
> per-task stack protector support. clang requires
> '-mstack-protector-guard-offset' to always be passed with the other
> '-mstack-protector-guard' flags, which does not always happen with the
> powerpc implementation, unlike arm, arm64, and riscv implementations.
> This series brings powerpc in line with those other architectures, which
> allows clang's support to work right away when it is merged.
> Additionally, there is one other fix needed for the Kconfig test to work
> correctly when targeting 32-bit.
> 
> [...]

Applied to powerpc/next.

[1/2] powerpc: Fix stack protector Kconfig test for clang
      https://git.kernel.org/powerpc/c/46e1879deea22eed31e9425d58635895fc0e8040
[2/2] powerpc: Adjust adding stack protector flags to KBUILD_CLAGS for clang
      https://git.kernel.org/powerpc/c/bee08a9e6ab03caf14481d97b35a258400ffab8f

cheers
