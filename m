Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F08F7B;
	Wed, 30 Mar 2022 23:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90909C340F3;
	Wed, 30 Mar 2022 23:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1648683968;
	bh=GgLh9GaXBFfzZFvigI/FoQkf3w02HRSkun2SLU+RGKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOLS35aUbOhsV8s0ZpKxFUrs8U+D1Hh4dgnhfk3eufxMR5GOnL0m8sNkoUExtfZpZ
	 QXKOyJGaa0Ni2jFx6uH/hDmbzujyhPdi7CSZ5rc3X55EuMXIitMZDo9eELAvYbw7v5
	 ItxhzHRnWaEB4TjILQhK/bBc1AuuUq6OU53og5uQ52cjVlb31tO2pvr0DIQNplJSz2
	 xMihUHpU9ldtX7V91wFu9BqLYGjEJ+8uiTyigeix4zPJ+FQ4PUsqPDn/4GqWi3QOfk
	 f3iLZXjvlrD3MYFVlCHjUUJDL45Z+1vGc5N3UIUTs7iLVWMFFtZ/9C6v2pJ8KZtTx+
	 zpaY4C11rSbuw==
From: Nathan Chancellor <nathan@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <keescook@chromium.org>
Cc: linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 2/2] Revert "um: clang: Strip out -mno-global-merge from USER_CFLAGS"
Date: Wed, 30 Mar 2022 16:45:28 -0700
Message-Id: <20220330234528.1426991-3-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220330234528.1426991-1-nathan@kernel.org>
References: <20220330234528.1426991-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 6580c5c18fb3df2b11c5e0452372f815deeff895.

This patch is buggy, as noted in the patch linked below. The root cause
has been solved by removing '-mno-global-merge' for the entire kernel.

Link: https://lore.kernel.org/r/20220322173547.677760-1-nathan@kernel.org/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/um/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 320b09cd513c..f2fe63bfd819 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -75,10 +75,6 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -I%,,$(KBUILD_CFLAGS))) \
 		-D_FILE_OFFSET_BITS=64 -idirafter $(srctree)/include \
 		-idirafter $(objtree)/include -D__KERNEL__ -D__UM_HOST__
 
-ifdef CONFIG_CC_IS_CLANG
-USER_CFLAGS := $(patsubst -mno-global-merge,,$(USER_CFLAGS))
-endif
-
 #This will adjust *FLAGS accordingly to the platform.
 include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 
-- 
2.35.1

