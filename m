Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4AD18BC36;
	Mon, 24 Feb 2025 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408610; cv=none; b=cv1NrQSA0/xaSwMbmleDCOEeOIBDU83pWqjZlSBQsDbqEos5FwHofURdDmSz3lJvxtoLkkefVxWrTw0M5Ocnh6+TXvMt1ZxUdebl2mAJ5nXNXGOF4T0u4aoh6aGg5wCowdIfRPaOvJ5BJrPrYjNaw8xUZ4MD6khZ/Qtd0vfxoJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408610; c=relaxed/simple;
	bh=619182//C05fMuBt+GQnG34ODCRX3YYRoUrRkZPEwQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5G6CULFS40RktQQhIl6kJiPZbH/5GbbvXXrWVm1pI+5JeL3Q6gjtj5dG1CZv8wLzUxJCW8QMU0sbS0MPYa7aDzlqU9N9iFjtiPuLynVc/FbzWG9BfxkgrnF6i5iIOVkTaBb4Abxu0014+dip+i3Jut5fxcUwg8BZLjTsn0Ai5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpTjLvIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpTjLvIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D42EC4CED6;
	Mon, 24 Feb 2025 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408610;
	bh=619182//C05fMuBt+GQnG34ODCRX3YYRoUrRkZPEwQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpTjLvIy9B/FZbROZQWGOoa1+TetKycUvhSEKmtiRgashE9TNbpOmQy7qYTMb3yha
	 cAB6v3NOorfAGo6zpUyR2B1Mvxycj7OLMTjHGObBprC/2N8p2rD1/8YzX38S/XGdIw
	 fzq0CZ26tRwJO5MRhOjw0WA1rAzviVkc45KgTVnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabio Estevam <festevam@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/154] firmware: imx: IMX_SCMI_MISC_DRV should depend on ARCH_MXC
Date: Mon, 24 Feb 2025 15:34:49 +0100
Message-ID: <20250224142610.596192917@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit be6686b823b30a69b1f71bde228ce042c78a1941 ]

The i.MX System Controller Management Interface firmware is only present
on Freescale i.MX SoCs.  Hence add a dependency on ARCH_MXC, to prevent
asking the user about this driver when configuring a kernel without
Freescale i.MX platform support.

Fixes: 514b2262ade48a05 ("firmware: arm_scmi: Fix i.MX build dependency")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/Kconfig b/drivers/firmware/imx/Kconfig
index 907cd149c40a8..c964f4924359f 100644
--- a/drivers/firmware/imx/Kconfig
+++ b/drivers/firmware/imx/Kconfig
@@ -25,6 +25,7 @@ config IMX_SCU
 
 config IMX_SCMI_MISC_DRV
 	tristate "IMX SCMI MISC Protocol driver"
+	depends on ARCH_MXC || COMPILE_TEST
 	default y if ARCH_MXC
 	help
 	  The System Controller Management Interface firmware (SCMI FW) is
-- 
2.39.5



