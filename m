Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C74C28727C;
	Thu, 21 Aug 2025 21:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810960; cv=none; b=OrU9jtgH5bCFln34wbmQUU5eWXdcxXVnPFjYV7JNLwToi/7DQBIJXwoqBk/74sbp13KbWOFAptWxR8odMY4DFE91dTGB0Uc7/dj0T6fXqEL8qyLLV3eQQQFYZ/BGXDG9od39EQRIPUjMFhXOCavSeKztceKFHRVrbs6dOCzLGaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810960; c=relaxed/simple;
	bh=4LtsjHz9BcVqdxPkFUx7SaoCYcFLL8+ez7eFd3R308E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YwRTrstxbqaAxfQqrSEvBrR78ClMr/BOkftXXeeC4l+u4pO9yeOXSqgs4m4PzaO50JcnfUAa3vcYv/4IEcJQQhDB/q95HYpKLm8NZ9uxv6EKVmSMilBG1Gq1H6ELQUoXw4/Ej8W0jChYf9K5EvmDAJkcv9qudoll6RdEnieVnsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYpJcCs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYpJcCs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17A5C4CEEB;
	Thu, 21 Aug 2025 21:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810959;
	bh=4LtsjHz9BcVqdxPkFUx7SaoCYcFLL8+ez7eFd3R308E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kYpJcCs84Ml5F/mOSa5JNH7aoT3ZCEwJwZc/Ft+KJ6l/cgxUrSPBWmHacFdassTrT
	 PYS55nFl49ygm11sjVaLE87javh99kop8ID2Zpw61yKCn5766hIatJRgdmMPYxrso4
	 OTgkdB2R7zq2M9vECMMgS51TeE4rKClLvVzV0dPYg6eObHf7Mvb1wT8+EZF5a0qHE+
	 Wqn3tH0U/Mj38R5vcmdp5Km1gy6RqLWT3unBfN9YCprM1vdAcOQMLPGADx+4u2beUX
	 5osQGNRSv0XKh3s4UPIPDXRjtEjTkCT3uxC+TBEVFV2Rq6BT0P30OTwMAZiSNm7lNj
	 9ixGcBru3AhVg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:39 -0700
Subject: [PATCH v2 02/12] arch/Kconfig: Drop always true condition from
 RANDOMIZE_KSTACK_OFFSET
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-2-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, linux-hardening@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=933; i=nathan@kernel.org;
 h=from:subject:message-id; bh=4LtsjHz9BcVqdxPkFUx7SaoCYcFLL8+ez7eFd3R308E=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe5ruzi1g+azLzX49b6aHFffSpQ+dmi7zKr9UsPe3y
 3gxWfBbRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIrgzDH54G+8fLrug+fCYV
 zRGqkTt9en08a/tLcWcR811Hn7PNn8TwT43z6Dn37X+vOi15w3bFyPGaruYjoYsJGdWzX3K7uNR
 /5QcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, the second depends line in
RANDOMIZE_KSTACK_OFFSET is always true, so it can be removed.

Reviewed-by: Kees Cook <kees@kernel.org>
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

