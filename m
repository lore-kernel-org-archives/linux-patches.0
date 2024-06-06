Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A1319AD4A;
	Thu,  6 Jun 2024 14:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683039; cv=none; b=PCV7gWPU3kF5D87HiV66k9QDabol/Cb7CnbYsphHne7Av2NkkfrjOsRv5q9n3RXKp9N1tlxp3o4J0A6X5snSvw/0tUM7xk83yehZScmMlZVf8BIo8ce/yPKB5ghCM2Hcm+wlw7UatGlqTtPjJtqf+fadr/tE4wA7QeISACwV5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683039; c=relaxed/simple;
	bh=7WNxvdo80Za77GKtCti95/2mMl4FEE6Bv/TYYtY05aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONOQex5xr09a/2Gs3cE0ku2SL3JKzf4Ceizt16kpBwDAym4Y+7257y76BZyeFVrtHr5EN+R//ko+XIcrcqsaCqIABdrKJk2szfYNW76ciieRCozpz5cQYnWD6w9hwpltUcxMl5DGBHdeQplfdVusOCt6OdJudsGhGYOyOzaCbtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvKeZPEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvKeZPEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48F0C2BD10;
	Thu,  6 Jun 2024 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683039;
	bh=7WNxvdo80Za77GKtCti95/2mMl4FEE6Bv/TYYtY05aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvKeZPEA1YadxyuYeCtdwVEOEbcmBBciPdgsEz0U8ToV/H0xaTRjx5MQgNBXMGx/d
	 q361yCKMRx0y8GIOrCbPEZK4ppwtU0JIkGpzaNvx4SvfZ4wjP29mdDO709htix9lqv
	 lbiqDWbQcLSrxZR74I8Dz1JLcpFazb651MTcY0UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 231/374] ubsan: Restore dependency on ARCH_HAS_UBSAN
Date: Thu,  6 Jun 2024 16:03:30 +0200
Message-ID: <20240606131659.550081596@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 890a64810d59b1a58ed26efc28cfd821fc068e84 ]

While removing CONFIG_UBSAN_SANITIZE_ALL, ARCH_HAS_UBSAN wasn't correctly
depended on. Restore this, as we do not want to attempt UBSAN builds
unless it's actually been tested on a given architecture.

Reported-by: Masahiro Yamada <masahiroy@kernel.org>
Closes: https://lore.kernel.org/all/20240514095427.541201-1-masahiroy@kernel.org
Fixes: 918327e9b7ff ("ubsan: Remove CONFIG_UBSAN_SANITIZE_ALL")
Link: https://lore.kernel.org/r/20240514233747.work.441-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.ubsan | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index e81e1ac4a919b..bdda600f8dfbe 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -4,6 +4,7 @@ config ARCH_HAS_UBSAN
 
 menuconfig UBSAN
 	bool "Undefined behaviour sanity checker"
+	depends on ARCH_HAS_UBSAN
 	help
 	  This option enables the Undefined Behaviour sanity checker.
 	  Compile-time instrumentation is used to detect various undefined
-- 
2.43.0



