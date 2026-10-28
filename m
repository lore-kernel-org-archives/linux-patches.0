Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207810;
	b=IqU7oTYIW1InToVIE11jQW89+xRFDfueQf5q7mSpfIoZpL6bh6TuN5ARyfNBHc3uer32
	 VHGa7Z7Ry+manDBGmA9FABJlNPh8AI4OybVu8fgafuB3CmKcU62s6w4WU9bmf+nGcNNZz
	 1NKUwxzrw7hBm41Glnzs1Udrc0keKaUQjoJ1hNUttsEjmfThe6A82DdI+qRmw9noMu55R
	 at5r5fgyRxC/wus+GXiWQ0iCqULyJXivJzEZQ01BuQHHT79YMJDOuVCc2eOHB+5J2uGzm
	 udpBGOnjmpipjBFcJtx6oThPPhmSdfTMRx6XhbGND5WyPIIC6Nw1OH3aSk9PHZxDOMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVgCw1SmogznHiRiFS9hxyzGtKfUSi0YdXA9wsqcp+Q=;
	b=gXbocAPphswEyr0z00O+TYYAPnemBnIK2n8G9YiMprtP2PQm1cBjdBjI4A7aXJGE7ssn
	 Kfwiw1L8fG0EIYFwHGKdXNqjqX29DGcnEPnDN8j2Sop+Y5OUfRsPejh2xzoswBBz9xSPh
	 Zgl1gK29a+cACyrEt3pOwl+ArmxzZcFN0+lN+hYnlBpdV0rt2AFmTEkdEItQJ7m603q4p
	 ygj0RTol9s7ELxUCpRLbXGAfkQYWEAYpM0HvCy/eDN//uj8qhEOWrJPJHsFD3q4YcQOlI
	 w8EnfCv6Xp27b6+WSeRnIlX3a/UTKyyo419439gO9QRVZLLBaBrHt0VQmk2GBqNW1dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V+EkRw74;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE6A606A31A;
	Wed, 28 Oct 2026 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V+EkRw74
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199701F01825;
	Wed, 28 Oct 2026 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207809;
	bh=BVgCw1SmogznHiRiFS9hxyzGtKfUSi0YdXA9wsqcp+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+EkRw74sDc8/Cb7Nyl9ZW3DclLpPD1axAg8Zf88F6ahR+zn4yaI1W+zWykpKipHp
	 ly5231Ct5nkBO+EUko6SKQB8Q33BEfTAqKpBKcVJDHApueShKhRM8ORslnKaG7oDEQ
	 BaouOYrqLuuDBlQ7khaUvAEXgbuIyFp3f5T/S5OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Zanda <e.zanda1@gmail.com>,
	Andi Shyti <andi@smida.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/247] i2c: viai2c-wmt: Replace dev_err() with dev_err_probe() in probe function
Date: Wed, 28 Oct 2026 17:59:10 +0100
Message-ID: <20261028165950.892608887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enrico Zanda <e.zanda1@gmail.com>

[ Upstream commit 3b7d8d151a7ebebc5257766110c102ab173b5844 ]

This simplifies the code while improving log.

Signed-off-by: Enrico Zanda <e.zanda1@gmail.com>
Link: https://lore.kernel.org/r/20250513210246.528370-2-e.zanda1@gmail.com
Signed-off-by: Andi Shyti <andi@smida.it>
Stable-dep-of: aaabefc79b0f ("i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-viai2c-wmt.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-viai2c-wmt.c b/drivers/i2c/busses/i2c-viai2c-wmt.c
index 3415683dab91c..133dc41fe387b 100644
--- a/drivers/i2c/busses/i2c-viai2c-wmt.c
+++ b/drivers/i2c/busses/i2c-viai2c-wmt.c
@@ -44,16 +44,13 @@ static int wmt_i2c_reset_hardware(struct viai2c *i2c)
 	int err;
 
 	err = clk_prepare_enable(i2c->clk);
-	if (err) {
-		dev_err(i2c->dev, "failed to enable clock\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(i2c->dev, err, "failed to enable clock\n");
 
 	err = clk_set_rate(i2c->clk, 20000000);
 	if (err) {
-		dev_err(i2c->dev, "failed to set clock = 20Mhz\n");
 		clk_disable_unprepare(i2c->clk);
-		return err;
+		return dev_err_probe(i2c->dev, err, "failed to set clock = 20Mhz\n");
 	}
 
 	writew(0, i2c->base + VIAI2C_REG_CR);
@@ -121,10 +118,9 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 				"failed to request irq %i\n", i2c->irq);
 
 	i2c->clk = of_clk_get(np, 0);
-	if (IS_ERR(i2c->clk)) {
-		dev_err(&pdev->dev, "unable to request clock\n");
-		return PTR_ERR(i2c->clk);
-	}
+	if (IS_ERR(i2c->clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(i2c->clk),
+				     "unable to request clock\n");
 
 	err = of_property_read_u32(np, "clock-frequency", &clk_rate);
 	if (!err && clk_rate == I2C_MAX_FAST_MODE_FREQ)
@@ -139,10 +135,8 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 	adap->dev.of_node = pdev->dev.of_node;
 
 	err = wmt_i2c_reset_hardware(i2c);
-	if (err) {
-		dev_err(&pdev->dev, "error initializing hardware\n");
+	if (err)
 		return err;
-	}
 
 	err = i2c_add_adapter(adap);
 	if (err)
-- 
2.53.0



