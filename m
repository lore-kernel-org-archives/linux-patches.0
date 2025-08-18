Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDEC3218B8;
	Mon, 18 Aug 2025 12:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521832; cv=none; b=TFr3IiJ4qRt1fKc8Dm4e2jWIxhhg/FTfHqhmnY2UQqNSK9RDZsANeHepwwy+A3+ggLv1zkA9bZOej8K5C2WmOMDPYPI5vqJv3Ptpdz+CoLhO4r8hd7/kjWVT/ek5yQ0LWT/xmhDtLL9zmIXVQmcW0hlIXcDbpxs8aaertVivVn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521832; c=relaxed/simple;
	bh=iVLcUCYjoR5woagI9IKC/kY2S+jZCM0BV+Fd3vJIkCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3Ga01V1mmbpYQAm50om8Zj13Gy136dYzW0AvgZZYj/no0ud2UTtCSJLToLG8Y5GfSGUJARx1wY2t5WXZIkrueRtaF9F0hqhTDfkeApw+dS94EIcJbOjUvr/j3ZDDQjewQZL5N8gAviAxiibeKUnDwafY9XZIazDiasUBfb9u/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZYBZkp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZYBZkp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2E9C4CEEB;
	Mon, 18 Aug 2025 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521832;
	bh=iVLcUCYjoR5woagI9IKC/kY2S+jZCM0BV+Fd3vJIkCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZYBZkp651B7+cMFGAarJw6Y9UtZiVRUa+pHBTFX093XN7g0PyTAStXa6EqQU4app
	 DgMgZmZfArQSpaENtrTCM1sLpSHpO8DKvggRVxUVfyQoPbOvweql9Frhpqu5+fR2v+
	 Yc+NvslfIZg0juWQxO6Qu5mHwo1/6K8FBwpPA5xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/444] reset: brcmstb: Enable reset drivers for ARCH_BCM2835
Date: Mon, 18 Aug 2025 14:42:41 +0200
Message-ID: <20250818124453.972177765@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 1d99f92f71b6b4b2eee776562c991428490f71ef ]

The BRCMSTB and BRCMSTB_RESCAL reset drivers are also
used in the BCM2712, AKA the RPi5. The RPi platforms
have typically used the ARCH_BCM2835, and the PCIe
support for this SoC can use this config which depends
on these drivers so enable building them when just that
arch option is enabled to ensure the platform works as
expected.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20250630175301.846082-1-pbrobinson@gmail.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 5484a65f66b9..1cf577e3223b 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -51,8 +51,8 @@ config RESET_BERLIN
 
 config RESET_BRCMSTB
 	tristate "Broadcom STB reset controller"
-	depends on ARCH_BRCMSTB || COMPILE_TEST
-	default ARCH_BRCMSTB
+	depends on ARCH_BRCMSTB || ARCH_BCM2835 || COMPILE_TEST
+	default ARCH_BRCMSTB || ARCH_BCM2835
 	help
 	  This enables the reset controller driver for Broadcom STB SoCs using
 	  a SUN_TOP_CTRL_SW_INIT style controller.
@@ -60,11 +60,11 @@ config RESET_BRCMSTB
 config RESET_BRCMSTB_RESCAL
 	tristate "Broadcom STB RESCAL reset controller"
 	depends on HAS_IOMEM
-	depends on ARCH_BRCMSTB || COMPILE_TEST
-	default ARCH_BRCMSTB
+	depends on ARCH_BRCMSTB || ARCH_BCM2835 || COMPILE_TEST
+	default ARCH_BRCMSTB || ARCH_BCM2835
 	help
 	  This enables the RESCAL reset controller for SATA, PCIe0, or PCIe1 on
-	  BCM7216.
+	  BCM7216 or the BCM2712.
 
 config RESET_EYEQ
 	bool "Mobileye EyeQ reset controller"
-- 
2.39.5



