Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2E02FE580;
	Tue, 12 Aug 2025 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024089; cv=none; b=Q4JGiimGG+9SuIswGIU0Ko6LzbNUu4zagNSDwsVxSZsejSG6gj1kgvO64qE+xOK/7mAnP/vOcdS8mo01WLma05eG6exReFP7r4aSh2P6YBuzbcr2gIRFXy4rWfbc8vzCc1cGL6ioUXFL+4ggBh7aKgP2C7GIpfMndIqTIBgQfAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024089; c=relaxed/simple;
	bh=pAK3/ofzF+lVB2mmwp5Lz9pfahFFjo6Gq4m/wnqZoVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGLxuNhLQKdhOawpEDTS8XYXip6b6Yix6f1R/nY1XaTPKV1ete37HlfQKsehw4w8xchEEdqZpHYo2XgEUJ9m3kI/TkhHIij5X6Bi4LtWNwROO++GB4DzkEJXOwRtqK5yk3DYG+FYFUZHRMdHXBRT1SkLLCvFBU1PwRxEu43sKFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiQ1+3YR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiQ1+3YR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B853C4CEF0;
	Tue, 12 Aug 2025 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024089;
	bh=pAK3/ofzF+lVB2mmwp5Lz9pfahFFjo6Gq4m/wnqZoVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiQ1+3YRyBUSm+vFS3R9E0KeXAfzbLMkMyjiMLO2Kg5r0HB4WuP4nzPuWmeUj0+Bo
	 aGHbTayrrjiE47FtvZEJ5XhH1NI0TzJqa4OaM/pSlnk2hzZmRVXDvPitypOh52gck8
	 QRFtOyF0Gei+Mpji+pjA/vn4PyUEKjwYfQTYYqFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 269/627] can: tscan1: Kconfig: add COMPILE_TEST
Date: Tue, 12 Aug 2025 19:29:24 +0200
Message-ID: <20250812173429.541196205@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 5323af351e7524497930b7793153ff68ee5c0ec1 ]

tscan1 depends on ISA. It also has a hidden dependency on HAS_IOPORT
as reported by the kernel test bot [1]. That dependency is implied by
ISA which explains why this was not an issue so far.

Add both COMPILE_TEST and HAS_IOPORT to the dependency list so that
this driver can also be built on other platforms.

[1] https://lore.kernel.org/linux-can/202507141417.qAMrchyV-lkp@intel.com/

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250715-can-compile-test-v2-3-f7fd566db86f@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: b7d012e59627 ("can: tscan1: CAN_TSCAN1 can depend on PC104")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sja1000/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/Kconfig
index 2f516cc6d22c..ba16d7bc09ef 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -105,7 +105,7 @@ config CAN_SJA1000_PLATFORM
 
 config CAN_TSCAN1
 	tristate "TS-CAN1 PC104 boards"
-	depends on ISA
+	depends on ISA || (COMPILE_TEST && HAS_IOPORT)
 	help
 	  This driver is for Technologic Systems' TSCAN-1 PC104 boards.
 	  https://www.embeddedts.com/products/TS-CAN1
-- 
2.39.5



