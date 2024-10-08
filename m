Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBAD3C0C;
	Tue,  8 Oct 2024 04:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728361356; cv=none; b=AsvgOCIdIbknMJ4mwBbX88X9YcogZ+Fs+OFgbeVmvvBODg6HzppemhhOhQ8sm7EhyfLANYbRx0inZbcSXqJGm6t0sm+nBIr1k6c2yC9OtyzPs19s3tqZj6eHgGpsaPTQ+S3o638aflNOFM789jdCw2esqPz3hBYnM632wUbvAlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728361356; c=relaxed/simple;
	bh=bAbqiY32v7W3t8ENtyeNXoNDZoMAvxzj5ilcMrs030c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=adebmNvh+QE0NmyQadQyFXFw9uSGw8bx9heCom+n1mqVeg7mP520W97q7+Gf6G2ol5nbtT8NoWbjDmi30sSb/nANyuglvBfLYgDiwHAol4wJ3gAVCYGQLClWnXkWmrTSD6m9F4NoXt+Gox17y7CyjxzVx9VZfy6wx2LWz9osFvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t3/ahgYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t3/ahgYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB305C4CED2;
	Tue,  8 Oct 2024 04:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728361355;
	bh=bAbqiY32v7W3t8ENtyeNXoNDZoMAvxzj5ilcMrs030c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=t3/ahgYVqgrS38jTqFNgc4fqiVpnurVgv7wdV6tqQRLfO7qvLMVz/7HLUQEjwaGSS
	 BrH6ux0hqBACdDo/ySV/ZL1EPbXzCKuE0y1vlU2oa/hJ2+TYT2htjJjqpefPlPGQE2
	 dz8pJOXGC4K2WfR7KuwEtijLlDKdf1fMtvNfjRsdTGUrbGHEiyE4nq5R41z0XBPKmu
	 do24h94dnGGpwSgvp05yfu1wO4FRzoSl/6PKwk9WAy26j7N/nbsqP37uHAR3d6Quqe
	 ntFoT95EOKIUlAmr4kYeRQqKyy6ZlA2maqw3uOwB4GG3rLe09NDtZ1P36wmQfoyzW1
	 +ZuZCUZyDyLnQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 07 Oct 2024 21:22:05 -0700
Subject: [PATCH 3/3] powerpc: Include -m32 / -m64 for stack protector
 Kconfig test
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-powerpc-fix-stackprotector-test-clang-v1-3-08c15b2694e4@kernel.org>
References: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
In-Reply-To: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2034; i=nathan@kernel.org;
 h=from:subject:message-id; bh=bAbqiY32v7W3t8ENtyeNXoNDZoMAvxzj5ilcMrs030c=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOksmzucbknsuGt+8vSkpw9S2TY0XJnaPEcpIde+44/In
 fK5QYyXO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEgpwZGZ6muuw0WezcPZ9L
 4eDcpKkP/Z/8mlBQdP7s3s2XK/Z9ZrrKyHBSxuZRVOVcpsAdYnrzpq90udaXoT8pq9th+pWNi/1
 q3/MDAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Kbuild uses the powerpc64le-linux-gnu target for clang, which causes the
Kconfig check for 32-bit powerpc stack protector support to fail because
nothing flips the target to 32-bit:

  $ clang --target=powerpc64le-linux-gnu \
          -mstack-protector-guard=tls
          -mstack-protector-guard-reg=r2 \
          -mstack-protector-guard-offset=0 \
          -x c -c -o /dev/null /dev/null
  clang: error: invalid value 'r2' in 'mstack-protector-guard-reg=', expected one of: r13

Use the Kconfig macro '$(m32-flag)', which expands to '-m32' when
supported, in the stack protector support cc-option call to properly
switch the target to a 32-bit one, which matches what happens in Kbuild.
While the 64-bit macro does not strictly need it, add the equivalent
64-bit option for symmetry.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index eb98050b8c016bb23887a9d669d29e69d933c9c8..6aaca48955a34b2a38af1415bfa36f74f35c3f3e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -275,8 +275,8 @@ config PPC
 	select HAVE_RSEQ
 	select HAVE_SETUP_PER_CPU_AREA		if PPC64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
-	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r2 -mstack-protector-guard-offset=0)
-	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r13 -mstack-protector-guard-offset=0)
+	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,$(m32-flag) -mstack-protector-guard=tls -mstack-protector-guard-reg=r2 -mstack-protector-guard-offset=0)
+	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,$(m64-flag) -mstack-protector-guard=tls -mstack-protector-guard-reg=r13 -mstack-protector-guard-offset=0)
 	select HAVE_STATIC_CALL			if PPC32
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_VIRT_CPU_ACCOUNTING

-- 
2.47.0

