Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038D518C22;
	Sat,  3 Aug 2024 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722705602; cv=none; b=CRCn8YKSGgRsUi2pN1nqcygiIf4tfyxBJEmtceYM1xYcwUDz2Op3rWtS1rMHGOrz7AX/fqbRd3Jvb3CpLmHuqJRPJwlMq8pdU1mGlplgEaI2YxG0xxhpz/CrW10BEd2CIutumAnQPdz2MEBzujLvqEVWVirgMgbbIZPXNsSJEjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722705602; c=relaxed/simple;
	bh=n89BHmAiPEa4wPUDINCWZSKQuwV7c/HkN8zbZq7gZy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlkeLHnbuq4vmSt6SUa4CYvwqo7+9dcycWHQtMiU7a+Fo3BwiOQrd5/2ryb2dfPvFleyiW6ggJPUn9onl5avq2Fb+LMNk71WoaqJpfKibuecLwRj/otDDWVk98UkYbNV1QI/EgrPFP68XgBm5JL/NprO54otgMVwy0LrXkEGaiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEm8D9Bi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEm8D9Bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7F1C4AF09;
	Sat,  3 Aug 2024 17:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722705601;
	bh=n89BHmAiPEa4wPUDINCWZSKQuwV7c/HkN8zbZq7gZy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEm8D9BiFzPdXYiLC7M3AFr954cmgdTU6khg1AIposldaQP+PccOXmcnlkDzmUkEh
	 Jyj/22dcoXPV2ozykScjk8QVZUn1WITgHgz0urRRmTE203blDm32wwwkLS/WyB6jFg
	 Nag2DIrfDzQzT7oaIRv3bDXNxuDR+DsQ3LBJnxnzbv0ov30HzLxU8k6ep4hjdqExRa
	 SZmQHEo/qZ6S/5jkoLtFG3RrlCFxNgkzAmDx4txt992BJX65EX3PClOLSXLsRPQFTr
	 StQIxulePau6ynU+tlTrK9ue1w2QG7vS4tErlglygFfr6HkzQsIfAYYuNDSEltUqS+
	 7VhCtm/NwkMlg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/5] Compiler Attributes: remove unneeded version comments for older LLVMs
Date: Sat,  3 Aug 2024 19:19:30 +0200
Message-ID: <20240803171933.483316-2-ojeda@kernel.org>
In-Reply-To: <20240803171933.483316-1-ojeda@kernel.org>
References: <20240803171933.483316-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel upgraded to support only LLVM >= 13 in commit 9c1b86f8ce04
("kbuild: raise the minimum supported version of LLVM to 13.0.1"),
thus remove version comments that are not needed anymore.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/compiler_attributes.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index b658136e6cda..5d171a7f8cbd 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -256,7 +256,7 @@
 #endif
 
 /*
- * Optional: only supported since GCC >= 7.1, clang >= 13.0.
+ * Optional: only supported since GCC >= 7.1
  *
  *      gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fprofile_005finstrument_005ffunction-function-attribute
  *    clang: https://clang.llvm.org/docs/AttributeReference.html#no-profile-instrument-function
@@ -275,7 +275,7 @@
 #define __noreturn                      __attribute__((__noreturn__))
 
 /*
- * Optional: only supported since GCC >= 11.1, clang >= 7.0.
+ * Optional: only supported since GCC >= 11.1
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fstack_005fprotector-function-attribute
  *   clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
-- 
2.46.0

