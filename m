Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016368;
	b=GMvA8xQfoDeTjBn6sjvcj82ozaEY6fiHZjAqoJghuhZIRV9ZmQk7xZbOlXW4uk2OZIOs
	 gHH4Ye0/KeniAAqRRIDHzrHBMc896wwr7PKxlMg37NlpLunMUTdHe2tHFtaPXPmixpkKW
	 TXS0erk0rX5sFE8HQptw3iBP/p27BgnyWICkuUe9Mrfkaa7pfFo6vrlat1gK6NABK102K
	 h+cRkg4wvawUJVyyoIlHtTcr1STDq/2RCQgjbmCoitj22PakCmExeMCkXLqQ5qgi89pSK
	 NPuhmrCHhmVruRJqxl2b91DXAkvWCh//JJKn2gb4HBsPqGW/kfSTvAveAT97jHd7ttw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iDqZ7Ku+LAxEGLM/IMuVfYtaMxm0r27VesA0WnfZLFg=;
	b=G3y/Ns37ZiidFpUZNxdfiqERmrj32cMxJXd/KKz/jFquewjLwtU4fkqrfUJe4bnd48am
	 JdmHj5ocwFtPVKcB7B5npnAkkZGs/KFPMSwX6UgM2BSvho4PTeB38m3+6KqVXUt/iLsuw
	 Lf8LnP6azsiMSMtDeohu5ctcsshfpXpGHEz+IgByQdUxOt3D74J5m3adWOKU8uiS98jy7
	 6/81AGDZin74exxC2EYTOzAz3b/XEarICPbTwQhpRWuH4ER9nXLDcFnAUkoRkOaci84tC
	 fnGx5UrUpqcN5F7htuPjjJFLgMrqadrGd/6/ruTCmfZVnjaYM5p9dHAZpQnHzMgM0sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvebUDED;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBD160A2604;
	Wed, 18 Nov 2026 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvebUDED
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740261F000C4;
	Wed, 18 Nov 2026 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016368;
	bh=iDqZ7Ku+LAxEGLM/IMuVfYtaMxm0r27VesA0WnfZLFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvebUDED9Mt6D1TpaHOBkWpTycX2NAo67q81SumXJRipJlPdVwVL+MwtHP1cU+06N
	 1RVe4uBbs9IHjKRnJ8WwcPAaPuqr8Rv8fNhOH8zwzjNgFVwuf8fLcoatlZwjoFWqJR
	 qVAkCdnijDmUW9ZlWOS2xYeqq/Zcx84PADUmhFM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0503/2651] pinctrl: stm32: Drop the nonexistent CONFIG_MACH_STM32MP25 from the STM32MP257 default
Date: Wed, 18 Nov 2026 15:29:03 +0100
Message-ID: <20261118150305.871859945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



