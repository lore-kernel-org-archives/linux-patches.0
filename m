Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4677A11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5F7C433C8;
	Mon, 28 Aug 2023 10:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218538;
	bh=OHa23mFkhWrGNiMfuBvGDpTGgBimV7q6YJ1b1KTdcIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bh/n0zcwVGVT0lEHz+PH590vjt6+gXmCoA+i50hdXHUoVeYpWDmldE8P/CrEUiWXl
	 sJS2vPxzNDBlX00N+LbOQZOLIfpHltFGCvJm1/z2f/PbWQE1kqOPWH3qlRXlu8VVj9
	 C6e+S68hEwGyHMiRcKZ/Nq9N+WUz9o0NwLEqEK8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/129] powerpc: remove leftover code of old GCC version checks
Date: Mon, 28 Aug 2023 12:13:08 +0200
Message-ID: <20230828101156.783686338@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit bad96de8d31ba65dc26645af5550135315ea0b19 ]

Clean up the leftover of commit f2910f0e6835 ("powerpc: remove old
GCC version checks").

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Stable-dep-of: 25ea739ea1d4 ("powerpc: Fail build if using recordmcount with binutils v2.37")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 4cea663d5d49b..2fad158173485 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -429,10 +429,6 @@ stack_protector_prepare: prepare0
 	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
 endif
 
-# Use the file '.tmp_gas_check' for binutils tests, as gas won't output
-# to stdout and these checks are run even on install targets.
-TOUT	:= .tmp_gas_check
-
 # Check toolchain versions:
 # - gcc-4.6 is the minimum kernel-wide version so nothing required.
 checkbin:
@@ -443,7 +439,3 @@ checkbin:
 		echo -n '*** Please use a different binutils version.' ; \
 		false ; \
 	fi
-
-
-CLEAN_FILES += $(TOUT)
-
-- 
2.40.1



