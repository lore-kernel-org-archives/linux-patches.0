Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC624CB2B;
	Wed, 13 Mar 2024 13:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710336481; cv=none; b=LVShHHl1PKRxqZP7bYvpQ7F5SDws0t0bzQxYtbIJS2zGmejlU6Fu/NA8eBPgzLF0uuRqKKGNrPD15mZn5U6BwAqGNkJQ9nGKXQzV82M8R8iy4BzMadh/BhBymV4k6sv9xrM7nUOFLHCYBQGlxETmd6ybup2HPAHLTxoPUbQLBlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710336481; c=relaxed/simple;
	bh=HH5xOjjzuWHjUVAogbuOFuoQ89bDOK0DQRoj5Kg3v/0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NhOLRXXhqRXBhFmcJn9LO4qDEcpdxun53TpB/QrmvGFQO9OI3uh8nF7KvMg1iwJen/e/AWwImIhf+pqJSgSOedzvGNMpwa9FgL1tMDnR1r5pTjrOm4au00zDKlTresv8eUPKRUKIsfjLu1HaKHYGpbdpbiA8dfjaZ2G7cmA6oyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Tvrt605w4z4x3k;
	Thu, 14 Mar 2024 00:27:57 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, morbo@google.com, justinstitt@google.com, linuxppc-dev@lists.ozlabs.org, patches@lists.linux.dev, llvm@lists.linux.dev, stable@vger.kernel.org
In-Reply-To: <20240127-ppc-xor_vmx-drop-msoft-float-v1-1-f24140e81376@kernel.org>
References: <20240127-ppc-xor_vmx-drop-msoft-float-v1-1-f24140e81376@kernel.org>
Subject: Re: [PATCH] powerpc: xor_vmx: Add '-mhard-float' to CFLAGS
Message-Id: <171033598345.517247.13813107624896171770.b4-ty@ellerman.id.au>
Date: Thu, 14 Mar 2024 00:19:43 +1100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Sat, 27 Jan 2024 11:07:43 -0700, Nathan Chancellor wrote:
> arch/powerpc/lib/xor_vmx.o is built with '-msoft-float' (from the main
> powerpc Makefile) and '-maltivec' (from its CFLAGS), which causes an
> error when building with clang after a recent change in main:
> 
>   error: option '-msoft-float' cannot be specified with '-maltivec'
>   make[6]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] Error 1
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc: xor_vmx: Add '-mhard-float' to CFLAGS
      https://git.kernel.org/powerpc/c/35f20786c481d5ced9283ff42de5c69b65e5ed13

cheers
