Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590671;
	b=3LprGbuo9RRUQixriWZYM1htvqeeU7rHlNn0BTdiIWz+HX/5aXvyACxTw9hDSOPXBE/y
	 3ygchz7L2h74zYo93wMbAP7AHRoT2eJ2qvlOSsS79WurnAYWtuWi8s5bf6xEBDnu01r/y
	 FA5l45wiLqWu2ehDbTa0gnUrXMilvFBvzFsKrrr0ItuTbDe30ARgNPVNdnBerB0VNkgiB
	 vfi6OCLNfnZXhSWxNUiehZkvj9kwSmHt+mBPknf/paLIa4K9fmYzbXXiaLHzs3m2V+uAI
	 GA/os5A9Sm/8f7KQhFfkqDKOGV7yUSA0dFaVu9zpZAABT3jDbPnJ5h/VN0lsQUu34VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yOCPhI357qczBAr5/58j0TEso4zqDKHgqVeNv7JIscw=;
	b=cp8MdUeVwuPLo8FTt7pepV8M2f1O99k4nS+6Q9+RXTC+hSSS9lEQwEqIBbyTQOUjHM97
	 uV+lNk6T0fxNSVo8PdJa/XACj/XhKJnhT9KS//edQiWYoS4rQqGlfQB5WnBbHnLj+q69U
	 bxDjmOJvrByLSRdzWowO0k21OlgiY3+bIkL68vVU+IUGE0far2THbhcZQHU2noxh5B+Lz
	 NeMZT8az5d8+V6SwbQugqcGLhuKuynOWw862CE/MT3OJhExdHbyBm4A43/r0Lv3+yiAzF
	 JMgPRfgznaEjscwdq7EiXCF/lrE8pFCnnsgrON9QlbasZdbII39N5trvL+9b839ZR9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJyRctc1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9560606B21B;
	Fri, 13 Nov 2026 17:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJyRctc1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5675E1F000C4;
	Fri, 13 Nov 2026 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590671;
	bh=yOCPhI357qczBAr5/58j0TEso4zqDKHgqVeNv7JIscw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJyRctc1yz0u4/H5ZXT4GRN1WtBWTQUQgh225IiXiF2BOzhGkZ6+//CmV04oGiOEi
	 LY3OQBD/DuVtnZitGrvcKfWHWNoGTarv7PBGGjU8PDV0Ji0B4qJn7z4MSiolv2wVYc
	 RSPpKsmpVLSqR9r4DNYAJ1ZCHjFcRZqBwFVja+nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 586/686] serial: sc16is7xx: add comments for lock requirements
Date: Fri, 13 Nov 2026 10:51:59 -0500
Message-ID: <20261113153841.670202491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 42405cb77fd35b5acc0e5a11d74eef68c2afa484 ]

Indicate why lock needs to be asserted when accessing
MSR register, as this is not immediately obvious when looking at this
register in the device datasheet.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251027142957.1032073-15-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c41d09dcd07 ("serial: sc16is7xx: declare MCR and IER as volatile registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 7cf3056b93939..b2d020a0b20d0 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -538,10 +538,10 @@ EXPORT_SYMBOL_GPL(sc16is762_devtype);
 static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case SC16IS7XX_RHR_REG:
-	case SC16IS7XX_IIR_REG:
-	case SC16IS7XX_LSR_REG:
-	case SC16IS7XX_MSR_REG:
+	case SC16IS7XX_RHR_REG: /* Shared address space with THR & DLL */
+	case SC16IS7XX_IIR_REG: /* Shared address space with FCR & EFR */
+	case SC16IS7XX_LSR_REG: /* Shared address space with XON2 */
+	case SC16IS7XX_MSR_REG: /* Shared address space with TCR & XOFF1 */
 	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
 	case SC16IS7XX_TXLVL_REG:
 	case SC16IS7XX_RXLVL_REG:
@@ -785,6 +785,7 @@ static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 	unsigned long flags;
 	unsigned int status, changed;
 
+	/* Lock required as MSR address is shared with TCR and XOFF1. */
 	lockdep_assert_held_once(&one->lock);
 
 	status = sc16is7xx_get_hwmctrl(port);
-- 
2.53.0



