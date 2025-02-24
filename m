Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD92571CB;
	Mon, 24 Feb 2025 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409105; cv=none; b=WSNNoboYQHcOm+DmJ7K4n/fMaXBodK57CmagZpTWgLNtV9cssauNAM0qMBzEyDDijAvMzVWHUxD+nwbj0ZL2+EM/XVwBkDQe45oeTVL4xe7DvGt4ADBGWoOEq02CArBQUfcswvvLVArwpWZynwLFYhPixQXPNkWNQojGAU74xpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409105; c=relaxed/simple;
	bh=UYTOT8nkdsYCLWo25fAMBxuRXhYFDMTdFvFhe0h6Q5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fe4N8wFSW4W0yR9sZBO0S8Cf+HvuNBgG2fJuwkYMm1lRqXD1opYvsiKVvUIAXLigw705/A7DPmUNI19Z3sQL+oqnC32eZZYxP9ua9/Z4+TfT6hq2a6t9MC1FsPkAZ76Xr6br/QxBS1L0fYRzlqYBsud+REVOKXs58fYpHDSCO+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcR671SL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcR671SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C0EC4CEE6;
	Mon, 24 Feb 2025 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409105;
	bh=UYTOT8nkdsYCLWo25fAMBxuRXhYFDMTdFvFhe0h6Q5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcR671SLEZBjsGMmTBfQQNm2CE4Z2JbohEcuIJEYBeUt8DYwQAzTmtFHzljwDms7d
	 ZfK92jKjXUlwNV/p2lPzgYtRdRuXHP2VHB870fQ2FHQ/la6awlV+1vMEH/0Gyf9IyB
	 mDZMOrQA912DrB2sE9e2oIE9ltbygdwZMEic49So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabio Estevam <festevam@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 066/138] firmware: imx: IMX_SCMI_MISC_DRV should depend on ARCH_MXC
Date: Mon, 24 Feb 2025 15:34:56 +0100
Message-ID: <20250224142607.071910585@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



