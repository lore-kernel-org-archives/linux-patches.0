Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039970;
	b=oN8dHCv2mwDY8L38DhBqY27xbReOy730ajoYAKw0D5Qz6R5tTpg7WkhcmfyDFyVzzsWS
	 m/0Ubq/NWJc8zbhqOtn/uHSzk/a7jvQBYUEMZ9uXqHfsRL3SNVdIDTlTx+Kdztyreeomx
	 psYoQ4gP3MNvi9E+4AmEzJRNsaysDyXUEIda6tWKP+voE+6QG8OAXzq+27m4w5XF5WWfh
	 WMZJ0/kXoQkBP5VB/gVb3l1GY0m/jmO/N9WQiCK5Q4gPvUZrJrGmcQ116e9dOXoIG7y9H
	 DyMbawEBcZKhiD2nETA1+JeEQKC7VJZd0aVxs7Q3leTMsMyUM6nuKyHSndX4hT9V1tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FTdpWx6OPSMw1ERK0kVBFSNSQQs1G5eqyFt7aZRHVvc=;
	b=DrHyBL8a/RQKff44/6eKMS7YLWmI4cdGDf2gP37AxdNR/6mmQclvQVVGIah9DMYrrFqY
	 wcyx901XWxvW9Cvkc9S0ZLrorjOFFzAD2zgSyPWuG1Ct4KAazm4Qc3Gc6L53BcKuBiDbt
	 PiLy5cWUZb/5/OSRe9nU00FGhZQNj9GwhAxUZq1pWvT2TplUlJXRU2mDLgata/StxABcD
	 QWuEO9h3aJVnpjwcdSI6eNt8PNkag4ZrpER9U+y9U2QAqqGhRfxEdAGMVdJLCK9iQgMHE
	 gltnC02J8SPAsWgm5ipuw12s0W59MOwddCizSpLb63qPhKqP8fewFrud6fiyLa/MCQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7vSOCHe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6080C606A32A;
	Wed, 18 Nov 2026 22:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7vSOCHe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE14F1F000C4;
	Wed, 18 Nov 2026 22:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039970;
	bh=FTdpWx6OPSMw1ERK0kVBFSNSQQs1G5eqyFt7aZRHVvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7vSOCHeD3Tls1lvnHyapv78teK2XmYTwYMB3CxP3dzqA7a52QDLFpkx2OaRTUn0J
	 681qiSYCCWiCPSCkcQOIfNASnDI2GprzPDkNkMYOGP8QZE2ddeqH7j1TttZbS4UQXG
	 1uN4BOIBeqypJu3DzYiYzD3dKcP1+YYtP7c6MAHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Gaylard <ag@ffroot.co.za>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2273/3318] pinctrl: fix PINCTRL_SPPCTL=m
Date: Wed, 18 Nov 2026 15:48:15 +0100
Message-ID: <20261118150429.978711050@linuxfoundation.org>
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

From: Andrew Gaylard <ag@ffroot.co.za>

[ Upstream commit 7dcf87d2dbbe8c9c1efb69fe9be728a3dfd51d3d ]

The PINCTRL_SPPCTL option is defined as a tristate in Kconfig, and the
help text suggests that the user can build it as a module by setting to
'm'.

However, it cannot currently be set to 'm', because SOC_SP7021, the only
platform that supports it, is a bool option that uses 'select' on it.
Also, the SP7021 requires this driver to be built in, in order to boot.

Change the tristate to bool and fix the help text.

Tested on linux-next-2026-09-14 on a LTPP3G2 board.

This impossible tristate was detected by kconfirm, a static analysis tool
for Kconfig, by Julian Braha <julianbraha@gmail.com>.

Fixes: aa74c44be19c ("pinctrl: Add driver for Sunplus SP7021")
Signed-off-by: Andrew Gaylard <ag@ffroot.co.za>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunplus/Kconfig | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/sunplus/Kconfig b/drivers/pinctrl/sunplus/Kconfig
index 4b5c47c193d97..a359fdbda1b3a 100644
--- a/drivers/pinctrl/sunplus/Kconfig
+++ b/drivers/pinctrl/sunplus/Kconfig
@@ -4,8 +4,8 @@
 #
 
 config PINCTRL_SPPCTL
-	tristate "Sunplus SP7021 PinMux and GPIO driver"
-	depends on SOC_SP7021
+	bool "Sunplus SP7021 PinMux and GPIO driver"
+	depends on SOC_SP7021 || COMPILE_TEST
 	depends on OF && HAS_IOMEM
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
@@ -17,6 +17,4 @@ config PINCTRL_SPPCTL
 	help
 	  Say Y here to support Sunplus SP7021 pinmux controller.
 	  This driver requires the pinctrl framework.
-	  GPIO is provided by the same driver.
-	  To compile this driver as a module, choose M here.
-	  The module will be called sppinctrl.
+	  This driver also provides GPIO.
-- 
2.53.0



