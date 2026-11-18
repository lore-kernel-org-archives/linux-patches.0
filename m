Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023743;
	b=jCTzVRpu8x5g8E02aiMT6FzLXgcM/U3YBGXnh3CZ2Oxf0+hJDTVkAfW6GZC7E1jxXlcq
	 WEwf7MxEztJrV+U+2RSNq46JafTJ8JO8vgsEFS844Eg/+90W36XeWNlb99mPWN4r5vq0z
	 S/W2cWe2QPgmN/cHR1xmDo14S/GdBJhErBIe7/6oESPMp17SlO49t5eWSk6pYY9nvNrCu
	 IIcHdg1epBws18UHdkSVIL2MWY26F3+HdoKC7zo66J+iDFgoPVCURb3njNzbFg05woqkl
	 k2ZcB1go7C4nWceok+sbwdhU/NEBUXpUm8UArdyy50xoj+lzfGndpvL3bqIrPKPex7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=awuUzvDuargdYxCP3sESj6FXa78SHlZA+V4dn0lNd18=;
	b=uDHKiUWOkwJiDi4XSxhYKGMKkxzrQ5JKRgEnu/lP+ffQ6wzt7TOMVS9rKTyQkh8E+1UV
	 iLhdi6mmLAgd6aqw5TArxoO1xlr6Axf17pldERgvLc4CtB97D2aJJyOj5qJ0HsVY6/DQL
	 LnamZaVzR2GvnPHjqKehEd6v9eO7MB/vgwwE5rt6o9rDnrR50Bz8LybqEX0XDhjx2Avwv
	 2nihPc6ptKImrTznBgZl2tRYkrGZEG9qQNImtUGynuJLA1lNCb2ZOGBokVcVxNiVbW2Tn
	 Qj6Nk95crH+K/bg8czqMecW+hPklmrbCv9fSRwBs4gMhkbysn7KT9+HnxIf6Xxbmbmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6wqW6kB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46480606A32A;
	Wed, 18 Nov 2026 17:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6wqW6kB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0081F000C4;
	Wed, 18 Nov 2026 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023743;
	bh=awuUzvDuargdYxCP3sESj6FXa78SHlZA+V4dn0lNd18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6wqW6kB/NuxrhwcL0ez6hNI+JVXvZ6GOTDmHjp6dxb8kw9S2otdNX3p0UiDhUF/t
	 0//npafLph89eZx7AvlU3VfpGqTH31H+wyP/V97AeYdaiKBp6lI6wxZQkvqYNLXGSG
	 LcPfqGR3k9Qv8sg2wX+yUO7murwRGuf45vxRkcZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0471/2151] pinctrl: stm32: Drop the nonexistent CONFIG_MACH_STM32MP25 from the STM32MP257 default
Date: Wed, 18 Nov 2026 15:36:46 +0100
Message-ID: <20261118150139.165508995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d6a1715230121..cc425bbfc996e 100644
--- a/drivers/pinctrl/stm32/Kconfig
+++ b/drivers/pinctrl/stm32/Kconfig
@@ -55,7 +55,7 @@ config PINCTRL_STM32MP157
 config PINCTRL_STM32MP257
 	tristate "STMicroelectronics STM32MP257 pin control"
 	depends on OF && HAS_IOMEM
-	default MACH_STM32MP25 || (ARCH_STM32 && ARM64)
+	default ARCH_STM32 && ARM64
 	select PINCTRL_STM32
 
 config PINCTRL_STM32_HDP
-- 
2.53.0



