Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C1669D2B;
	Wed, 21 Feb 2024 13:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521200; cv=none; b=dNldAWcDfcggGhhAK9hOufO7KjomGzJtYvpFUfDcw4WoIDLggZFmMoXmBmtJzAqSWxNKOTe/gwmUPaX0Ih0pbxMRtHpLRqiSOvMHVW+XRYuMjv8oMZy8SBq6BDI3JUErx3v4KSZuEcacf06R3cLEOqGLiWsdfZdQWn+2nlsGHeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521200; c=relaxed/simple;
	bh=XWphp+VEBVar9rl9cAKfZ1ZjCAGB3jfyJILwn1KX6LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxNIxgySNHeqB1z/0HBoVui8aVo9OLLhb08PjI4LbTaczf7i81JFWJv916zgI5k1u+JgpFRQBV/9zbQGBGk55PS1nNpA+cDoKN4Y1/a/PysQJf77mHlkHvHos5IwPyxJXfLcJnOdtfdKpbYnyP/yDdVGTrQFVJeX8HC4PSEjL8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJxox+aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJxox+aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A46BC433C7;
	Wed, 21 Feb 2024 13:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521200;
	bh=XWphp+VEBVar9rl9cAKfZ1ZjCAGB3jfyJILwn1KX6LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJxox+aZuzVy5KbzekN3IXlq4DiysfC2idJ8m/h2jbut+//TKSbu9sqFaOV6XC77Q
	 /qUo/1JWl4AM6+9JmsRJ3DXL5I4vfxcfRFkS81A4VByogMpdy7u97In2Wv38WJ5Rsk
	 L/uk8/HLE0eO1aJE/UjGE8f0A5a3wkKARudhkLuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,  linux-kbuild@vger.kernel.org, llvm@lists.linux.dev,  Nathan Chancellor" <nathan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.19 018/202] powerpc: Use always instead of always-y in for crtsavres.o
Date: Wed, 21 Feb 2024 14:05:19 +0100
Message-ID: <20240221125932.342861096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

This commit is for linux-4.19.y only, it has no direct upstream
equivalent.

Prior to commit 5f2fb52fac15 ("kbuild: rename hostprogs-y/always to
hostprogs/always-y"), always-y did not exist, making the backport of
mainline commit 1b1e38002648 ("powerpc: add crtsavres.o to always-y
instead of extra-y") to linux-4.19.y as commit b7b85ec5ec15 ("powerpc:
add crtsavres.o to always-y instead of extra-y") incorrect, breaking the
build with linkers that need crtsavres.o:

  ld.lld: error: cannot open arch/powerpc/lib/crtsavres.o: No such file or directory

Backporting the aforementioned kbuild commit is not suitable for stable
due to its size and number of conflicts, so transform the always-y usage
to an equivalent form using always, which resolves the build issues.

Fixes: b7b85ec5ec15 ("powerpc: add crtsavres.o to always-y instead of extra-y")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -21,8 +21,8 @@ obj-$(CONFIG_PPC32)	+= div64.o copy_32.o
 # 64-bit linker creates .sfpr on demand for final link (vmlinux),
 # so it is only needed for modules, and only for older linkers which
 # do not support --save-restore-funcs
-ifeq ($(call ld-ifversion, -lt, 225000000, y),y)
-always-$(CONFIG_PPC64)	+= crtsavres.o
+ifeq ($(call ld-ifversion, -lt, 225000000, y)$(CONFIG_PPC64),yy)
+always	+= crtsavres.o
 endif
 
 obj-$(CONFIG_PPC_BOOK3S_64) += copyuser_power7.o copypage_power7.o \


