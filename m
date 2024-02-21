Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAEA7EF17;
	Wed, 21 Feb 2024 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524982; cv=none; b=jt8JeRiWSeQvGF918JXx1V4JdO3QQDY0zBfLpFQZIygKp9F5/mZ2+zqJOXkg1cOZAhyC7CxA9Zw6PTUpjgTHZEkdd5Xymky1cmLawa/tdu2LtTD/e19B1931mGCYTcryUXP0KTVV51DMkn1HMgrBVzmgWTJPd6dnslPryonGlDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524982; c=relaxed/simple;
	bh=Te6fQEzLMKMMq6fSXrbW82K2VfWSxRjGJY8RqIDRK5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAaSNx/1twB5uDfMVeijNPX8VbM+Op5k48RF8jlJ3sC3rurnYLc/35qOHOedokSWwzd1o4dXS1EXweTxHi/Kgr9hbf3dNkAX9UbjHbPx/FwYhcsofYpKJEdwHwlcLZA2gh1VKURQpKle9grnmUKodBpz4eTwl7pLr729rwKI5AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqa0B+L1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqa0B+L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF441C43390;
	Wed, 21 Feb 2024 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524982;
	bh=Te6fQEzLMKMMq6fSXrbW82K2VfWSxRjGJY8RqIDRK5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqa0B+L1r0O3XUJyuVEvkwvEy6UTT+x9ZHn698KzXSarZqRZFC1oTszPx1rHWd902
	 VO/XLMX6eqPij7SySHYtF9XOGV5+X7wF2DcQPGas2m/d0LwV1qcoBYXVlhUuKYiLoN
	 CKYkxwoGkgxFCSgbefzcD/yLei++A519h2FE+H30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,  linux-kbuild@vger.kernel.org, llvm@lists.linux.dev,  Nathan Chancellor" <nathan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 024/267] powerpc: Use always instead of always-y in for crtsavres.o
Date: Wed, 21 Feb 2024 14:06:05 +0100
Message-ID: <20240221125940.809177172@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

This commit is for linux-5.4.y only, it has no direct upstream
equivalent.

Prior to commit 5f2fb52fac15 ("kbuild: rename hostprogs-y/always to
hostprogs/always-y"), always-y did not exist, making the backport of
mainline commit 1b1e38002648 ("powerpc: add crtsavres.o to always-y
instead of extra-y") to linux-5.4.y as commit 245da9eebba0 ("powerpc:
add crtsavres.o to always-y instead of extra-y") incorrect, breaking the
build with linkers that need crtsavres.o:

  ld.lld: error: cannot open arch/powerpc/lib/crtsavres.o: No such file or directory

Backporting the aforementioned kbuild commit is not suitable for stable
due to its size and number of conflicts, so transform the always-y usage
to an equivalent form using always, which resolves the build issues.

Fixes: 245da9eebba0 ("powerpc: add crtsavres.o to always-y instead of extra-y")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -34,8 +34,8 @@ obj-$(CONFIG_FUNCTION_ERROR_INJECTION)	+
 # 64-bit linker creates .sfpr on demand for final link (vmlinux),
 # so it is only needed for modules, and only for older linkers which
 # do not support --save-restore-funcs
-ifeq ($(call ld-ifversion, -lt, 225000000, y),y)
-always-$(CONFIG_PPC64)	+= crtsavres.o
+ifeq ($(call ld-ifversion, -lt, 225000000, y)$(CONFIG_PPC64),yy)
+always	+= crtsavres.o
 endif
 
 obj-$(CONFIG_PPC_BOOK3S_64) += copyuser_power7.o copypage_power7.o \


