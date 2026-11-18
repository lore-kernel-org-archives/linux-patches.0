Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056186;
	b=i+VkiqmQKmEk3spRLiD/HQRtvw3ixZ23ma4ecF0RX+F6CY/BlQkV/0NobxK0FZA7soDG
	 LpxTCKl07BqVaIxRgA83XW7moBIsHW27wZC5RW3OIhgXMI4AYVP/UJdaIvZg4XAX0vH9u
	 6RrXmGBmXJEbcjNG4I7/2uDk9i8u3uKAdoQQG7Kow5NcgPd+0KOHMQ4Q1E3Q/GycXXzCS
	 bgIjrnHW1vJ0RTDBP8rhOkHz9Oo/sNL6E7bmAida1nmNWlgNyRS9xfjOnB88tiyPgEDnw
	 Rra8GDhjA3Y12JFLHz3Xxkdk8s4N/JRr7qfc0EMgzb5xuobB8ZkomUdaWZWtl1HyT1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJe3LZQLdGS+Q0a2gFcfyN9eP92lGdm5fh7luTxAUfg=;
	b=HCkGu1ZbSDOe/LP0iERvs6OpSz/fjtVjxS2roqGHpF2IaP+nkgoWnKhfKxebDw6CLcbu
	 SZKVXcSoacSf8y/Fps8oQZDDlWHScvg9jZkA505ceS0fqYc1cRjcS3+Hqlp+M9JNcoiK/
	 ufhQ+8cX7vo94jpdDa0p5BYArsChHQb8IKbTVRAe2j+JYAEobBr2vEimWNmr18mucJcj8
	 Xwz7w2hklxFGpggf0zN7PhoSEY9xYcSfcz1vgOiM8nbM66LYcNwyLVW50vmH0VJPGxmrS
	 2+G00HRpHj8+i5VPzFkJhqH+cNIjrVkNtBFo4yhC34v4lPtO/cJCHZ+S8eIBAnjf8tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WfIvUoZW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48890606A320;
	Thu, 19 Nov 2026 02:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WfIvUoZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37B31F000C4;
	Thu, 19 Nov 2026 02:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056186;
	bh=tJe3LZQLdGS+Q0a2gFcfyN9eP92lGdm5fh7luTxAUfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfIvUoZWVqg3mPmneqe/g3bg8MKsO2ebs098RRFoo1QhSd1+YQkrS/WnMI2fPyLdY
	 /kDL5y8F05+Wc6t7tHtsbjrm2dDmB+XneHaXp1EISXL/K5H+koR45/Q2XtMkDoujtY
	 AcnZRqxi7XPm9QF9X4u6XCuoieyWIyko0ZGcxLYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1896/2214] ASoC: atmel-i2s: use optional API for muxclk
Date: Wed, 18 Nov 2026 15:59:32 +0100
Message-ID: <20261118150127.021225338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit be952abd69c1f2c845e42e72147751e4c910cd81 ]

The muxclk is an optional clock according to the device tree
binding.

Use devm_clk_get_optional() to handle the optional muxclk instead of
handling the missing clock explicitly.

When muxclk is not available, devm_clk_get_optional() returns NULL.
clk_set_parent() returns 0 when passed NULL, preserving the existing
behavior.

Unlike the existing code, errors other than -EPROBE_DEFER are now
returned instead of being silently ignored.

Fixes: b543e467d1a9 ("ASoC: atmel-i2s: add driver for the new Atmel I2S controller")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index cc447fd7bc842..c753d45ce9480 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -584,21 +584,15 @@ static int atmel_i2s_sama5d2_mck_init(struct atmel_i2s_dev *dev,
 				      struct device_node *np)
 {
 	struct clk *muxclk;
-	int err;
 
 	if (!dev->gclk)
 		return 0;
 
-	/* muxclk is optional, so we return error for probe defer only */
-	muxclk = devm_clk_get(dev->dev, "muxclk");
-	if (IS_ERR(muxclk)) {
-		err = PTR_ERR(muxclk);
-		if (err == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		dev_dbg(dev->dev,
-			"failed to get the I2S clock control: %d\n", err);
-		return 0;
-	}
+	/* muxclk is optional */
+	muxclk = devm_clk_get_optional(dev->dev, "muxclk");
+	if (IS_ERR(muxclk))
+		return dev_err_probe(dev->dev, PTR_ERR(muxclk),
+				     "failed to get the I2S clock control\n");
 
 	return clk_set_parent(muxclk, dev->gclk);
 }
-- 
2.53.0



