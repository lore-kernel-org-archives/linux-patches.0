Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6227F19AD8B;
	Fri, 15 Aug 2025 01:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755221512; cv=none; b=kf6pWEmPBZCX+GjYHL0/c4Pc/MdLELYXrybshiaa2nHXwwCGGfiSY0PfMcHJEucOWXZHzFKthQxAhFyIPV/bSkx8PoRmAELOgx1FxA6lggjIqo/ea6kGX5j/EQLrk3tdbxtwjOzOr9VI7/PtH9Z5ZO6xEKIviiPCRGQ0s0FpNe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755221512; c=relaxed/simple;
	bh=X/zutVL5lxxntjtByHEizcL/TjX/yUfbMYCdIp0zOCY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kUJzSPIIh/JDG01cA3JZEOLRWNOBKXuTdXslpZpTKloaT9kH6JXnq6hyVCWpzzinE/l9SoTCTMGW8Gyr+dK4CDYRFJAha+KUXHuYV7nDYzdiv7939ThcwXn7ZAtWy07SgNF4xbJpPiR+Q3wp0xIlipaNNFJdMzTP0O5oAJpv19U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aV3WhqNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aV3WhqNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B686C4CEF6;
	Fri, 15 Aug 2025 01:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755221511;
	bh=X/zutVL5lxxntjtByHEizcL/TjX/yUfbMYCdIp0zOCY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aV3WhqNxNJcmTUyRmvYM6XxdICA7KHoblr2D+lexZomSOnzEAzEQz9nJ1uxbeq175
	 1b7kKVluGxZnsN6iYL7quT7JT0urfxd/NmDqzy8IjVDgXtYy9I81A37p8mOr/XD2Pk
	 ve1JaZbaZQI0pUsr9DayxGXzPwoz7TTfQ65B9cj0q1cLChsKMcelxjZxsL/5Mk+29E
	 E1FDb2HdBSAmu8AHvWRcwVk/Cny0ZZNkqiwze9nXRk3VaT8QnDOz+os17VfOmfhVMJ
	 0eyVgG3ImrMerPfgNh2+xzq+L3pachVPRu3PtO4Ap9RKcbUwaMnMkRspH5d+S9mHW+
	 2tFHayjdbd61w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Aug 2025 18:31:37 -0700
Subject: [PATCH 1/6] x86/build: Remove cc-option for GCC retpoline flags
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-x86-min-ver-cleanups-v1-1-ff7f19457523@kernel.org>
References: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
In-Reply-To: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1317; i=nathan@kernel.org;
 h=from:subject:message-id; bh=X/zutVL5lxxntjtByHEizcL/TjX/yUfbMYCdIp0zOCY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnz+phlmipn/lmVtWL9uW+BlwJeuQpkNDK0XeWJ0fRSC
 wr5wHKro5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAExkaS/D/6JHXE5dSjq2u253
 n994zEDY2vdwvOx5nunzJ+a0WcelvWFkmL50cW/cDh7nD8Vvtn1mKTyi6fKpJaBrSm3F51VO9Vf
 zWQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

The minimum supported version of GCC to build the x86 kernel was bumped
to GCC 8.1 in commit a3e8fe814ad1 ("x86/build: Raise the minimum GCC
version to 8.1"). '-mindirect-branch' and '-mindirect-branch-register'
were first supported in GCC 8.1, so there is no need to call cc-option
to inquire if it is supported.

Link: https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=da99fd4a3ca06b43b08ba8d96dab84e83ac90aa7
Link: https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=d543c04b795f8af4ebe5b3d5f38156ef4e5734f1
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1913d342969b..ed5657395d6a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -13,8 +13,8 @@ else
 endif
 
 ifdef CONFIG_CC_IS_GCC
-RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
-RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
+RETPOLINE_CFLAGS	:= -mindirect-branch=thunk-extern -mindirect-branch-register
+RETPOLINE_VDSO_CFLAGS	:= -mindirect-branch=thunk-inline -mindirect-branch-register
 endif
 ifdef CONFIG_CC_IS_CLANG
 RETPOLINE_CFLAGS	:= -mretpoline-external-thunk

-- 
2.50.1

