Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046969;
	b=wqdN4Mef9AuRsj+Cz/W37JJ+JBT8n+yMxVfdGCTHbQjnHVkX3UGWITYcZ4Tl7JNtDI6N
	 Muz8893Pa+/eadtLptkfCRlff3A2ZjImLbgUwVHzT3s/s09nZw5Ckt5rkO2txf/ow5OKW
	 6sH4m1LWYGgt0+8ql1Pq18VW9O+kWDSwnTfOhOeWDgusb2Uu022JBxFXADR1YWv7MBE+2
	 24AAjITF7NJKUfrbSXznWzshRpc0pz+8E6KxBeX83yJmWhKTgBZBuh7pbqRdiWIazKB5u
	 Ju3ofiqNJVDkqV/oeEpwnOv70NjNWdRKNTQRrnvLlOvrWqAvBjAz83zsanVVcLQQGkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T0q3A0webdV+bBNvXxldaKvMSh5Z+MCqf/Gj27JsZPs=;
	b=WxEmeP+ULyxHV6/OtDRIYYupL8MqPQRt5ej3DLxlnZUkgkF3l8OyFN6+GseSXEesC5Q+
	 sZYR+RuD3ysuKMWGmk/IFy32n2dA26pmBuwWSXatJoQGmiV7D/6SFzPIvMRhES7IdtV8b
	 xL376Lv6HzLy2mUFbZksAkmUp0E1KaHej7Yj4EguMGvRfzPI2WDSEQCpz4FANoAhnCUi+
	 aFMmgTZHPBm951/PwWkyXKRMbnJZbqanirMy3oUGSxn+akEg7JZ6XBFKU3SaUqcAz4P+X
	 ae5M0be5Q19CjHuJq1nGrLEewuXBAPXFURBZk4vyc98gstGrSdj69o1H5Smlsiox86Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iEK0tlwz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AB9606A320;
	Thu, 19 Nov 2026 00:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iEK0tlwz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8491F000CA;
	Thu, 19 Nov 2026 00:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046968;
	bh=T0q3A0webdV+bBNvXxldaKvMSh5Z+MCqf/Gj27JsZPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEK0tlwzev2sR6bIrqVdc/7pqNjT+NHBWpSAFGeNIFeyr4KNPbKb8iFrnSWGiw/QY
	 NqLV7s3TekI0GEDrGRwlk04iUBjvCVkh0E9Ws9qfCM8XSKb7ARXbSZ0qD+mtNschPl
	 DUUhn962jYup7GjTlefh47XZHySmc8ZUjWbZEXy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1464/2857] serial: sc16is7xx: add comments for lock requirements
Date: Wed, 18 Nov 2026 15:41:38 +0100
Message-ID: <20261118150254.027124299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ccac831bc69e2..c55cad61ff0bd 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -530,10 +530,10 @@ static const struct sc16is7xx_devtype sc16is762_devtype = {
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
@@ -768,6 +768,7 @@ static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 	unsigned long flags;
 	unsigned int status, changed;
 
+	/* Lock required as MSR address is shared with TCR and XOFF1. */
 	lockdep_assert_held_once(&one->lock);
 
 	status = sc16is7xx_get_hwmctrl(port);
-- 
2.53.0



