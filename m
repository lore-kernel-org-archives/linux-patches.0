Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DE11C862C;
	Fri, 15 Aug 2025 01:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755221518; cv=none; b=f7X7i5KwKthVYyId+xaf/Aunj47z/V4t86EOOo8tdTgzY7YQIxX9S2cJ8NyrMLyAMgj5RvdKccBZGmY8bn+x6v+5UXiut0mPpKp0dNWmJyqZ9sj4aLPIhUY0535xfS8ZHjFE3RYWm3KHALkGhQgUj2q8ozW0C9jET1UXg1NyTho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755221518; c=relaxed/simple;
	bh=rX1yO3lw6hmqgveY9Hg/MQWB/db5ofT9N4FvgY1/6P4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=INKHdTdM6Aus7zI5TABXzUpU4AWz27oW+NM/JdcD7WvWcu24cwb3JRYEe6vtr6epNXHwkvIKZnamVhf8OeUCDKLgMmJMwjYPwwUqKHPV2J1l+uk+fJrZLyiUUBeNiGUhf9dbUJM8WcWt4EPTkTgxtrk5nUbKJoeS4ovFRCqsPjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JABKOMnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JABKOMnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFBEC4CEF5;
	Fri, 15 Aug 2025 01:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755221518;
	bh=rX1yO3lw6hmqgveY9Hg/MQWB/db5ofT9N4FvgY1/6P4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JABKOMnXvolAoK0Vu/DNyXoGCjzGupBYhxBPbIiwLEsTUgGUj1F9E9dsZsUbo4iQQ
	 o/vQiUpGOeQGu1qBxu9r0JkWc6IyOZZhg2wKNIA0FRn7gi32skbboAakuXb4ExoNbX
	 sg3IU5CR0ulLoNPlllz+adEsVpWkoAi5FkPvHNYf1dURI/6soonZiNxFTUkBZxgsOf
	 XR3s0Of5W21l+w01vtbpcDjNc241yAXBOyhTKuKMsBLm4I9vfaAmz+aL5K2P18+TIs
	 WlxU+3+5++at1Q1g/tJCKKRgmKyfXPU2Ph7u/yJwD8npbJhy+7rb1oymm56geWk2yu
	 aDuYwCtVJUr0Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Aug 2025 18:31:40 -0700
Subject: [PATCH 4/6] x86/build: Remove cc-option from -mno-fp-ret-in-387
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-x86-min-ver-cleanups-v1-4-ff7f19457523@kernel.org>
References: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
In-Reply-To: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1097; i=nathan@kernel.org;
 h=from:subject:message-id; bh=rX1yO3lw6hmqgveY9Hg/MQWB/db5ofT9N4FvgY1/6P4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnz+phnXmBmfsK2cal3056we2wzP1n++aLTuvDP87y5P
 LyB+cZWHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi3GyMDPuXXd1sFl2w34Ln
 kqNV+YJwxxbmckmerYqs4j3FF73WXGP4K6FYstU4T+aw/YlT3XdN7O+rH88QzLssco753mrJ4i9
 9LAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

This has been supported in GCC for forever and clang gained support for
it as an alias of '-mno-x87' in LLVM 14. Now that x86 requires LLVM 15
or newer since commit 7861640aac52 ("x86/build: Raise the minimum LLVM
version to 15.0.0"), this flag can be unconditionally added, saving a
compiler invocation.

Link: https://github.com/llvm/llvm-project/commit/a9fba2be35db674971382e38b99a31403444d9bf
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 0c82a610fb54..1bbf943fe9e1 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -148,7 +148,7 @@ else
 
         # Don't autogenerate traditional x87 instructions
         KBUILD_CFLAGS += -mno-80387
-        KBUILD_CFLAGS += $(call cc-option,-mno-fp-ret-in-387)
+        KBUILD_CFLAGS += -mno-fp-ret-in-387
 
         # By default gcc and clang use a stack alignment of 16 bytes for x86.
         # However the standard kernel entry on x86-64 leaves the stack on an

-- 
2.50.1

