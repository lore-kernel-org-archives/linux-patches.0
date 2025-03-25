Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8166618BC3B;
	Tue, 25 Mar 2025 12:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906312; cv=none; b=Gw/7ZKUKoY5hjHtYgI7S3dOnY0imgjiWf3BZsngouvyIlvucI4r+9MnhX6RVatAcy3D44WwvnIKVZkBKrGeuQ7Ld2Aas/nOYtNqNNSz4hknrllDPpjnwvPsPDIsQMad8iJgrptt5Lro84j3SD+waY3vv1paa52Pf1aTat+hL5f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906312; c=relaxed/simple;
	bh=oySMQauBO1+9cllcw3/zeUjsYHCB9QewBOfA4MNYN7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yy1hxN0vAlH019JgXqbF+agv+i1GTSpByPgHRW2EV2GlWb1mAvrVEpEC28JtKJ7I0AMNuu2aEcrKVW/sq2TN39SH2mkJVbAWJQ4p7++t2vrhL3vPwQjtaN4kp91vEOY/NSRgcyEwP6C+JsjajVJUrcfxOWaeRrN6OOadCP++Qts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbHogtbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbHogtbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E29BC4CEE4;
	Tue, 25 Mar 2025 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906312;
	bh=oySMQauBO1+9cllcw3/zeUjsYHCB9QewBOfA4MNYN7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbHogtbJhgV8G1P0ilc6C0NwZXHES7FyUSGXro9knbXw4U2lzlCPFMAKc1eIYishb
	 +YTJRckv0zDXNAeC2VhSZ97UVMM/JlaHiYnsFvAfpTn1nsAC6CZdf2XTLCdA1c+0Qc
	 X37Ww5rTi59stWd/uBNM+FtJK1BBMdPwsg+Bnvq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/116] ARM: davinci: da850: fix selecting ARCH_DAVINCI_DA8XX
Date: Tue, 25 Mar 2025 08:22:00 -0400
Message-ID: <20250325122150.058274309@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 45d5fe1c53baaed1fb3043f45d1e15ebb4bbe86a ]

Chips in the DA850 family need to have ARCH_DAVINCI_DA8XX to be selected
in order to enable some peripheral drivers.

This was accidentally removed in a previous commit.

Fixes: dec85a95167a ("ARM: davinci: clean up platform support")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 2a8a9fe46586d..3fa15f3422409 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -27,6 +27,7 @@ config ARCH_DAVINCI_DA830
 
 config ARCH_DAVINCI_DA850
 	bool "DA850/OMAP-L138/AM18x based system"
+	select ARCH_DAVINCI_DA8XX
 	select DAVINCI_CP_INTC
 
 config ARCH_DAVINCI_DA8XX
-- 
2.39.5



