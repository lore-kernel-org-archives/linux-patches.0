Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029782;
	b=1vurx1YSLt+ehbEKYwRg0IqYhMWKA8AB9NG8ZsdnP0Mvsue5xrkFe02ewwwqkR3NnHpi
	 v4bKliY+X2WvfobUnrW+UzoYLuhyoESxB2nJkRj6uxXTKNCowCSFZigbq7kXQ/mji1afr
	 9o1BhmDHt06Lc0j0q5kxC9Hd678yCBOypsD4Sc7IFfwmpsd73mL5rZew9YAEWPI9lIoTp
	 X1Kd5gY8FMvF5Jhsut6GUum8c2SfF4bGPtCfJXhkq21PzAjY3MdQCLKgojPy9y0FqvRPh
	 GcZEgnEGuDqZcO/cZwwakg1qZQp+IN6CkTAn0gX9c1YQDnAStQ4ToEWa2RZo5U5VR2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FUKLbPmodP/wodE13+O0tB6DkiAPewrkq9D8yba8nII=;
	b=4i+yHNLKWNz0lk2NvWtYS/C7SUbMszRa4fYgbCBFZUriB9nOw93eCuiaAD7bxilKgVfA
	 akyNWdRnPWNhuUFfgGSkFx+xkl9SNK5CC7pH6xUTMK7W052m2468uNiBcvbHVC0fvzAY0
	 xKM07TvcpJKO0AwyqWVMmEhCD7sdAeuzDApUFU+yIlHjC3PmidRAedjDhMYHrUl1xKJRq
	 0ACqOJG7ErgW3KcmUSsV5eOaMtBJolBDpcmcUXVwEK1UVKTkxs00ys8ZziN+Glc4HPZrV
	 4uI8i3vWP3dtHLrZ1dbdYHuBLoayzKG9eFZcm9x8icdamF5q4zj6WU/Dwe6d0bxOHWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQk+WPB7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20447606A31C;
	Wed, 18 Nov 2026 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQk+WPB7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFBF1F000C4;
	Wed, 18 Nov 2026 19:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029782;
	bh=FUKLbPmodP/wodE13+O0tB6DkiAPewrkq9D8yba8nII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQk+WPB7Ue7qX7ElUhm5Hu1Ye3KyseylT/UuNuvSLKR0h+b00W9mPKrc8VTKXuhsy
	 Hd65SgQkDivdxP+JZIkakM2Pf17OjBBvooJBgvZvDyPyjF3IAfWowjUiUYTu5JdWN5
	 zjxERp8Wd5yx6973m4FTz7pGQXiO0wb6DdNxgwFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0430/1756] pinctrl: stm32: Drop the nonexistent CONFIG_MACH_STM32MP25 from the STM32MP257 default
Date: Wed, 18 Nov 2026 15:42:37 +0100
Message-ID: <20261118150025.872478838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 01f20711d044f35a7a89ceec33df30e097147e8a ]

Commit 619f8ca4a73d ("pinctrl: stm32: add stm32mp257 pinctrl support")
made CONFIG_PINCTRL_STM32MP257 default to MACH_STM32MP25, following the
MACH_* pattern of the arm32 entries above it, but no Kconfig symbol of
that name exists and git log -S finds no Kconfig file that ever defined
one: the STM32MP25 family is arm64 only, where CONFIG_ARCH_STM32 covers
it. Commit dba0aff2b89b ("pinctrl: stm32: Allow compile as module for
stm32mp257") added "|| (ARCH_STM32 && ARM64)" next to it, so the first
half now evaluates to n and changes no configuration.

Drop the first half.

Fixes: 619f8ca4a73d ("pinctrl: stm32: add stm32mp257 pinctrl support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/stm32/Kconfig b/drivers/pinctrl/stm32/Kconfig
index 297a2f088bc1f..e4c9b8a69a1a4 100644
--- a/drivers/pinctrl/stm32/Kconfig
+++ b/drivers/pinctrl/stm32/Kconfig
@@ -55,6 +55,6 @@ config PINCTRL_STM32MP157
 config PINCTRL_STM32MP257
 	tristate "STMicroelectronics STM32MP257 pin control"
 	depends on OF && HAS_IOMEM
-	default MACH_STM32MP25 || (ARCH_STM32 && ARM64)
+	default ARCH_STM32 && ARM64
 	select PINCTRL_STM32
 endif
-- 
2.53.0



