Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3481ACEDA;
	Mon, 23 Jun 2025 21:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713099; cv=none; b=AGTPbkpXGhyiq78yOWRzkJAGhGbL+9ccy9YfJRGBK9dHatrrNPvBdfPRpdri3Oyv2bKkp6+3l3Akkb6pO6YPYV2BRhvijaj1fZfScRu5j47AYV/X6COEYxeLUub7Gxv9+4nmPRmytuUwrwSUJmilqy3+ojsKpedMUcP2k9QirrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713099; c=relaxed/simple;
	bh=q1NAvCfxOMHaE1mPFmcG3nOu05BvI7CWNysTNqYzXp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L319/fC8MUN2qP4+kIiGOPtwC0t93rhUr3PxEfE2PgXefykQ7atUtzvD8W7cT66xp/ngsU86TJRo9hIv/8w/X6jJ8Hl/CFehGAo69xo4JEXWVSYNqYeZWYyWQCulK2qiKDjoaXugjGBDatn3Ldje590MyYttPwhn5h+VFiE/yVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzNYonly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzNYonly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE2CC4CEEA;
	Mon, 23 Jun 2025 21:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713098;
	bh=q1NAvCfxOMHaE1mPFmcG3nOu05BvI7CWNysTNqYzXp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzNYonlyXW21RErTvt8zfM4JbI13N7XyERwmOd5FW0RwjGzQMPi6V0CaIa1/A2WGP
	 /t4zSjSrdE2cfrzmzYAdMoi8XjkQ8lsPm/dZNWK3cnyw/hTC9JpTqA1pkP5mGdHjoH
	 bPZff0r+62m6GFzbwB6CXqj9soPHRbu7wOTPHQAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 145/355] drm/amd/display: Do not add -mhard-float to dml_ccflags for clang
Date: Mon, 23 Jun 2025 15:05:46 +0200
Message-ID: <20250623130631.068243045@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 7db038d9790eda558dd6c1dde4cdd58b64789c47 upstream.

When clang's -Qunused-arguments is dropped from KBUILD_CPPFLAGS, it
warns:

  clang-16: error: argument unused during compilation: '-mhard-float' [-Werror,-Wunused-command-line-argument]

Similar to commit 84edc2eff827 ("selftest/fpu: avoid clang warning"),
just add this flag to GCC builds. Commit 0f0727d971f6 ("drm/amd/display:
readd -msse2 to prevent Clang from emitting libcalls to undefined SW FP
routines") added '-msse2' to prevent clang from emitting software
floating point routines.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -26,7 +26,8 @@
 # subcomponents.
 
 ifdef CONFIG_X86
-dml_ccflags := -mhard-float -msse
+dml_ccflags-$(CONFIG_CC_IS_GCC) := -mhard-float
+dml_ccflags := $(dml_ccflags-y) -msse
 endif
 
 ifdef CONFIG_PPC64


