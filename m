Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A53D27467B;
	Mon, 18 Aug 2025 18:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543472; cv=none; b=AEcfLcmsX0lnxP+ZaARRvPqcgHEd2yQ3waM0/1km+pOQAwtwS90BlkaGU8Qjqqu1o4EfqLQ/cunMpNUMKmUnigT6RqMXIXVjsZGGdDxvh2EKwDbH9XbIYKG6+8pdIp9z2d2TalrG+k+bNe2axKyylf4gygGdVRRygJps4TGD204=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543472; c=relaxed/simple;
	bh=nxE7BPv67vk6+O2NN512KZ/22Fu2rCuKLzKSJq7gvSM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EtYWA7is4wex4nLQ5ZniGoPtLVsRUim5CwRW/RUWAJPvnlJpdQ2Mw61FPOHvP70H+vZBQk7S6AEZRmoscUJTeUHqkzGecjdIHotXAUMQvW7vBtAxqVVG6donr5n56buoIvvI1ebGeEOb8p8GJpK20c42GnDfkOSWiZC3T1ijRUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sbugmBn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sbugmBn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EA7C4CEF1;
	Mon, 18 Aug 2025 18:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755543471;
	bh=nxE7BPv67vk6+O2NN512KZ/22Fu2rCuKLzKSJq7gvSM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=sbugmBn57cQ8lbdaiAd7Gnq66RWDWOqKkW5DIdjslI9YoYxtUjGmaX+o3UbKNnVfp
	 3H59+D4rVbVntzcMomi0OTb1kyMSqTZqnaXCoT+EEqVURgwDZ7Le6w9rPk614A9cBE
	 0s/7azogaZGyZkPHExvPlqwzrK3IGuQPUpYnl//JiQsNFEdFDNo7cxvNnOFk6pz2Jq
	 Yu4S/0610rNjEUnXaGRaBCbdf00ID0/QHYN0V4Qx49F32ObzsUtfPWf45Mz5tsoDqd
	 GmZAc8pnH1+5yhqI85cWTUSlQORL09qxaT0Bh41+Y84tj2dT9gk524+6NHKKZ1PuW1
	 IvKf7NL8HUN5A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 18 Aug 2025 11:57:18 -0700
Subject: [PATCH 02/10] arch/Kconfig: Drop always true condition from
 RANDOMIZE_KSTACK_OFFSET
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-bump-min-llvm-ver-15-v1-2-c8b1d0f955e0@kernel.org>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, linux-hardening@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=891; i=nathan@kernel.org;
 h=from:subject:message-id; bh=nxE7BPv67vk6+O2NN512KZ/22Fu2rCuKLzKSJq7gvSM=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmLyxfyvjymodS3fOtqrmtvYv1tZyowXq8yXmSW/NT50
 up0FduWjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRxe0Mv1n39k/csUPrn8aS
 69sbPJibF686X5br/LNnwXn130JLbJoYGX5HbqvwvGWRpWb4S0Py/v2rkX5Nohr/lSSeHtqwkp2
 7hhsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, the second depends line in
RANDOMIZE_KSTACK_OFFSET is always true, so it can be removed.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: linux-hardening@vger.kernel.org
---
 arch/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d1b4ffd6e085..4935c4c26f09 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1475,7 +1475,6 @@ config RANDOMIZE_KSTACK_OFFSET
 	bool "Support for randomizing kernel stack offset on syscall entry" if EXPERT
 	default y
 	depends on HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
-	depends on INIT_STACK_NONE || !CC_IS_CLANG || CLANG_VERSION >= 140000
 	help
 	  The kernel stack offset can be randomized (after pt_regs) by
 	  roughly 5 bits of entropy, frustrating memory corruption

-- 
2.50.1

