Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016460;
	b=YQqfsK/sDRJs2MPH4jNOADkEFCdT29qQQ8W128r3cqVEjNKu+1ccP2WbnhbRZO+Ww1VP
	 TGyLZiGXDxHEVP9xl6jhPYRLtci0uJMRkuJ4V+sVNtSu+chr032+h4vxwFFXk9gHyL10S
	 7dMPFC0iZhvyRTtVVvbZ2iP4qBABtgR2TF1HxGJc+nSBeiFzywVLeKPZYvJo/WSmxdlSS
	 iwQQlHQuj/ol0CPSJlfoXJU+z5TqQN/JcRlg6C55bLXgGbaMXFQI9SmQhYLLeSEo+hRY7
	 Gyf3MqaEb0VOCQHHstF9FidhyGTesBaMn1Tsa6dAe+/gN/btHS3jT9NWzUCSD9dPbaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEqQD7VxChzEVt9q/kbAKp9L+cHtHvVusqBxa1W3o40=;
	b=3rV248a2rOCiIuT40qaYT523Oz0K5WhIIhQ6vi6AV54XeRwX1/s+mkNpT2HZtvCS653q
	 T2YUrRFqhLG2Sn3YXrSPWyFXkoySrMWtMUpcbGapv5wKIwiSXCFrWnoifI2FJmVuxAkKL
	 1odn1NQZKxD6vfd5LsSV1OXQhiCWbljogo66kLi8iyatwiDx+7200j7csDJj4h/hqcNRu
	 FVyRGvZ6VLrrzMLB+2P2qMEc/d4S9sVq3U9kadme5njHAIAwh56VcxPxfOCrXLUJ398bz
	 QjLjM5b1iIuPrVWLQ+qsG5Ob4HmozqZW/6m2PDatHS0zeOCEwSqe0O6mM+u8E9+46IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SIgTi5LI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CA1606A320;
	Wed, 18 Nov 2026 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SIgTi5LI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C251F000C4;
	Wed, 18 Nov 2026 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016460;
	bh=qEqQD7VxChzEVt9q/kbAKp9L+cHtHvVusqBxa1W3o40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIgTi5LIjjsSV8YC9JDhJvpz7+9LwXPA+R6Bhaczh1Tr4qPKJ1OjwkyahlXT56Kkm
	 YstslcQtWAXQHlbnR7YJrt08wRsrHft15c99pW8Y3ti/om4R5SP8oD5X/aPN8tQCOp
	 4kbt9z1LBdAsC2oQr3Zoc1knFul2WJpV7/HzCwBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0537/2651] clk: si521xx: correct the SI52147 OF output enable map
Date: Wed, 18 Nov 2026 15:29:37 +0100
Message-ID: <20261118150307.089796003@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7a4cc47d715f08309089d40b8c29fb0ba79917db ]

The SI52147 data sheet assigns DIFF0 through DIFF3 output-enable bits to
0x17 in control register 1. The OF match data uses 0x15, leaving the
DIFF2 bit out of the map, while the I2C ID table already uses the
documented value.

Use 0x17 for the SI52147 OF entry so both enumeration paths expose the
documented outputs.

Fixes: edc12763a3a29 ("clk: si521xx: Clock driver for Skyworks Si521xx I2C PCIe clock generators")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si521xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si521xx.c b/drivers/clk/clk-si521xx.c
index e3fb8df712eff..406cd154fba1c 100644
--- a/drivers/clk/clk-si521xx.c
+++ b/drivers/clk/clk-si521xx.c
@@ -374,7 +374,7 @@ MODULE_DEVICE_TABLE(i2c, si521xx_id);
 static const struct of_device_id clk_si521xx_of_match[] = {
 	{ .compatible = "skyworks,si52144", .data = (void *)SI521XX_OE_MAP(0x5, 0xc0) },
 	{ .compatible = "skyworks,si52146", .data = (void *)SI521XX_OE_MAP(0x15, 0xe0) },
-	{ .compatible = "skyworks,si52147", .data = (void *)SI521XX_OE_MAP(0x15, 0xf8) },
+	{ .compatible = "skyworks,si52147", .data = (void *)SI521XX_OE_MAP(0x17, 0xf8) },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, clk_si521xx_of_match);
-- 
2.53.0



