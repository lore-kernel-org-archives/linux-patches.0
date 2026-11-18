Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039820;
	b=3dpVVtUISxDBE0WudKXYRcsXTah+HoGTr39ZWfLeJAKvx5Z0hx0qwkf3sder7v1sSQzZ
	 pzHamy/np+7d7CEkMqXADL0CdC/gg2nttuasSKaWMqBO2HAja8nkRFrSZdgX1RqjZHnVV
	 kmBkIIGHQdMMzYYSuoJxLSahJmvKbUJEphohzoW2YPtd0bFq0o9UGo+UHiFDILuOR1UcB
	 H448YAvfUeR++y4DLJ6zYZR4yPq9utU/z2Q9J+jvjb4DJtJywlxas5CdYgOL+YQ904eZw
	 5ZhKbIUc4z6zuUrEZTFjtifBrlqcGMKl3dJbNRraiXRevBA0lZAxpU1rUVlqSshjolA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ull2oKlfVUtuCqgFQGGVKbmJEPFXXmhfad+T/nNG9K4=;
	b=zG23q7ESp2/7tj8J7qY9U2U2UHqk+E3GjTtXii2bsliLA5ahm95v8lOSbGE660eDrxyS
	 PtVJUIm4MaTgx50EqH6e1RvKu3bvb5Yi9CRJupn4w4pSgknNvX3fpNgG94SGFhVe95WgV
	 fyUdTjfcVORRuh/nFvSfgkleZ+S34ZwDnbNoAlMcPAuGA5d3B6NTKNX8tFIEcI2H+rZhl
	 BaCDpKYIuggJnSUYHzZ8DmshGtHhai4KV9azqO5F2fVfDqChMIPTmG/f4sLpDp8fDyZnn
	 Kcd+YbAp9Lc/tw24TMQlXxRUpENlV7vZgybXHuFISr0/gb8JSwekp8eQYX3B8JEafJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kP67hzIi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB69606A31C;
	Wed, 18 Nov 2026 22:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kP67hzIi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B02C1F000C5;
	Wed, 18 Nov 2026 22:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039820;
	bh=ull2oKlfVUtuCqgFQGGVKbmJEPFXXmhfad+T/nNG9K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kP67hzIiKQ1WM8Cdv2rDQdo4fdOPcuGyNK1toRLEKo1g/6/ZhAAcmGNKULM1yX2AR
	 MEenPqK74qntMQtvWSfpOcyynLXzQ6Akj6sL0dURQzQ+b+ytXFWLP/7kwBimRjJCSF
	 Q+d3yyM6/n4GEcyIEjQ2xI23sImPrtkPVd7dNs6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2238/3318] pinctrl: stm32: Drop the nonexistent CONFIG_MACH_STM32MP25 from the STM32MP257 default
Date: Wed, 18 Nov 2026 15:47:40 +0100
Message-ID: <20261118150428.998184998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



