Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ACB31194F;
	Mon, 18 Aug 2025 18:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543491; cv=none; b=hf9/BDt0fOsH8IxYoqpXSvwX/w56cULjeYKYfw27olPZzFSmHyM29H9j4j6cFNZUis7aobChq4Fo4+2jN6gozfNI7h533ymHr69Dx0iZGZst4ZraI1qWssxLO8iPzqWz9qs1qIfbXMUCr1dotsmTtcrnCFoZ3JWLAAxRQkq9bZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543491; c=relaxed/simple;
	bh=M7pwhNxCVOya/FEJUeoHG2+tlSnk7hue7j0+oI5FSes=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iwTbPta1rRx2OQnDknYfiDy/FINGaAPUDomVqut8VGqbuFhEAkBM2hqKAC+h9kEQljLknUAbYbwmhRcQDX4Dq0f56duB/LBpJpyc2XDGOkn7HZ0MhQSXl+hQdL8imnpcdnu9Vl9xGHlerWLQi2HpF4YONJcLeEzYPzKNRWRBQf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcZszBqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcZszBqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004C9C4CEED;
	Mon, 18 Aug 2025 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755543490;
	bh=M7pwhNxCVOya/FEJUeoHG2+tlSnk7hue7j0+oI5FSes=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XcZszBqTQSI9U0izHghXtPTm01qvcyqpI6XxESO74RDeKwTArN+yWXfiiTvcXy9K0
	 a0uOzmyuLbQRLfUPz/SakN/17S1IDC2JJKmuZoE1Tb1YNNm4xaKUuZwF9W7XJ+J9P6
	 lc1Q/umsWencaQEl6vHPtm4BBYiO3yLz6HBgjEZ+HxU4He5xNOxAdgUTB1IJIeu65y
	 ugUL+SQxCkgzVYo4i4cfmyhnkoNxRnSFif8rgbx57JV3K1AolZKTVGNmTuA7vddX+8
	 o0WZvIWmLzfog5A/TfFmkBCgNRu2U7v2o7Nmlmi2rs8eyBBJbJURmXk0j+y+tNVnJw
	 ZRzE3gtOonnhg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 18 Aug 2025 11:57:24 -0700
Subject: [PATCH 08/10] lib/Kconfig.debug: Drop CLANG_VERSION check from
 DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-bump-min-llvm-ver-15-v1-8-c8b1d0f955e0@kernel.org>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=998; i=nathan@kernel.org;
 h=from:subject:message-id; bh=M7pwhNxCVOya/FEJUeoHG2+tlSnk7hue7j0+oI5FSes=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmLyxfNTHpakhl4xvZQm38yy/+IB/enTE6fl85WsDy0R
 v0WD1dLRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhI5XlGhrW5E9ek/gp73JrR
 Vj5/zffgf4t3LjwpsTnpuGn/zQMS1+oYfjFv+Xn5Ieufq81fN/xUX5EawmE3Z9NtOZ98dgcd35Q
 lAQwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, the CLANG_VERSION check for older than 14.0.0
is always false, so remove it.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dc0e0c6ed075..6c12852e77c8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -259,7 +259,7 @@ config DEBUG_INFO_NONE
 config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
 	bool "Rely on the toolchain's implicit default DWARF version"
 	select DEBUG_INFO
-	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
 	help
 	  The implicit default version of DWARF debug info produced by a
 	  toolchain changes over time.

-- 
2.50.1

