Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410B1E51FA;
	Mon, 23 Jun 2025 21:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713867; cv=none; b=K5QQIPTSrtmTPLpfNnnjJ0erjpA31KYeUcKg+7yx6XWnOWFe3nQDR0Lt7VaCKRl5LR6ntp7NUSSXGNXsBr4XLY0XS/FTqCOhlLcu6+qnSpmik5Qv31jT8xnOy5fmK2dXVOEIyN2KI3AE/sOoBeMMreueEMb5hkSO1ZvzTdPmqLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713867; c=relaxed/simple;
	bh=ZYen/0EebK4z1OxkvbWv3NQ5TtyWGtAPK0ZkgZYBXjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuKgd1NGAqhZwWzpC+jPxO2i1MSJ5pWEgKnSLyS47G5dVIM6NXwO8pramkdQ8OZHkl8Kznx2swAF1uHszV8AuJJNX4m4TV+vhuI2h94wKe22sGgk8+S4Mhmi8xQmoHnATduR8Tc/9y5NjqcZ1+H3VG6O3BqQ51zUny0GmYTS7CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4XEfxXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4XEfxXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C424C4CEEA;
	Mon, 23 Jun 2025 21:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713866;
	bh=ZYen/0EebK4z1OxkvbWv3NQ5TtyWGtAPK0ZkgZYBXjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4XEfxXh/HrxrViDlVOanfiwugmFSlq0Lj4RQqRuDO9VPq8MoPb9TgJZpa40AZsQI
	 a2RiIyYPi8ZGNbLRrSf4pPEBphcGNFLdtouaIpT9f3RlHi0hsMfAVZp2Nm4xDEwUAq
	 0BGskoEzk9YhYEBqsO/duBkBOsMUusXv8GmjAAks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 172/411] drm/amd/display: Do not add -mhard-float to dml_ccflags for clang
Date: Mon, 23 Jun 2025 15:05:16 +0200
Message-ID: <20250623130638.021494118@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


