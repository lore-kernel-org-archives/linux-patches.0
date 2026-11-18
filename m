Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040730;
	b=vb01wRrrUvtayK3ZIrNlu5n2hcPgxxKEDObGQSlqh+8aTL/zL82u7VSchcFqQaLDvelm
	 BXigEGOh4PPnum4Hc5ivHIZDOyZJs6VkrrLexkY8nzkOjVZ/awkFmr9v0QuYqcbclqGsr
	 3fkUzfYFL7SP1wh6JKhFTHbepdzIbpJnhVaHgQFey4g1BgqcXRTNfgYHbBhOI1xnABd4Z
	 mm7ePKvx2rHibP7sCRL0fuTxTlFA8JDxCeo8SxC6T4ASHlL+gAHrt7YwgA+wxPGLM67yI
	 C3nrsiRRyKJVZvmqbskWMnKYzEjtDxsSr/js77oSmPD96uwHmtsgL0d8lljc/83JRCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ja0XBNwIIgQxV6epj9EBzqCZxJyf1DNpHnsg1p7tWW8=;
	b=FD7keZWe2qTyzDQ5J0Wbnm27xYYHbPwuU6MGy2+odTUAUHO6itMSERvOz6V6HozFVLgz
	 Ij0HFpHlFkHaZHiGtnD0sBe9/sJCRvNcbrh3qWGmFcDK0N3/epp3glspmuy1s7eEi7usG
	 Lwv0QnaVhWx+8TlBmSvJ1BZOGTkmKcPqEm4P7mJtHVLqmmrXwqrPkedX2GeEHGYw7JW0N
	 GIJqNKinPVx5Ug52FsX9J0UBHqaL0cTZ5c0iumVYxE60IjEGsApAxnPr8wjU5mzSU30B2
	 FxPmFJhs4CQOfL+uSMLDGfIiBgkOKWu2/qWLFOaQpCWqqcBr741yjm2+uE8tc+5gqhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NESvhpwz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93176606A32A;
	Wed, 18 Nov 2026 22:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NESvhpwz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1C11F000C4;
	Wed, 18 Nov 2026 22:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040730;
	bh=Ja0XBNwIIgQxV6epj9EBzqCZxJyf1DNpHnsg1p7tWW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NESvhpwzbNnTkzlTpbja/LQ8ohv4aUrFv+ew2k2AVSZEOXWnixli0mge5ubNo+EB/
	 v1it4SHs3PMr/O89ldHydTrI1hJTpIcn8cD9auQwjhJPHteDs5EdoZ4LLJKz5Gfb8z
	 Nmm1E2RzP2Qbdco66nfIcuxKri9wS2ThWlbQbNiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2561/3318] power: supply: ab8500_charger: Skip absent AB8505 main charger
Date: Wed, 18 Nov 2026 15:53:03 +0100
Message-ID: <20261118150438.087588183@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 52c8cdcc1146d86fae524a589d4512c8d59ea8b4 ]

AB8505 contains only the USB charger. It has no integrated main
charger, main-charger status register, or main-charger interrupts.

Avoid reading the missing status register, requesting the five missing
interrupts, or disabling an AC charger which was never enabled. This
lets the driver bind using only the AB8505 USB charger resources.

Fixes: d4337660d069 ("ab8500-charger: Add AB8505_USB_LINK_STATUS")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-11-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 32 ++++++++++++++++++---------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index a53fe0fb1a408..fb7ef9a36d127 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -680,16 +680,19 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 	int ret;
 	u8 val;
 
-	/* Check for AC charger */
-	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
-		AB8500_CH_STATUS1_REG, &val);
-	if (ret < 0) {
-		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
-		return ret;
-	}
+	/* AB8505 has no integrated main charger. */
+	if (!is_ab8505(di->parent)) {
+		ret = abx500_get_register_interruptible(di->dev,
+							AB8500_CHARGER,
+							AB8500_CH_STATUS1_REG, &val);
+		if (ret < 0) {
+			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
+			return ret;
+		}
 
-	if (val & MAIN_CH_DET)
-		result = AC_PW_CONN;
+		if (val & MAIN_CH_DET)
+			result = AC_PW_CONN;
+	}
 
 	/* Check for USB charger */
 
@@ -3489,7 +3492,8 @@ static void ab8500_charger_unbind(struct device *dev)
 	int ret;
 
 	/* Disable AC charging */
-	ab8500_charger_ac_en(&di->ac_chg, false, 0, 0);
+	if (di->ac_chg.enabled)
+		ab8500_charger_ac_en(&di->ac_chg, false, 0, 0);
 
 	/* Disable USB charging */
 	ab8500_charger_usb_en(&di->usb_chg, false, 0, 0);
@@ -3713,7 +3717,13 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	}
 
 	/* Request interrupts */
-	for (i = 0; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
+	/* The first five interrupts belong to the AB8500 main charger. */
+	if (is_ab8505(di->parent))
+		i = 5;
+	else
+		i = 0;
+
+	for (; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
 		irq = platform_get_irq_byname(pdev, ab8500_charger_irq[i].name);
 		if (irq < 0)
 			return irq;
-- 
2.53.0



