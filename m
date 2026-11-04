Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829703;
	b=IzlM8vB+P3ZZ+yck9uIFxrJiZsIWUTB058DJ8yNTANHMvY98ahGgtA8MrD1UZcLltVVt
	 +SyVsp68gOOfJBbP6AhXQ2XonCBm9WAbzBK2jbHPJuQRmC5T6VRQK9HdUeNxwWfuFQgDC
	 ftTw6ZOEs0T/rmIAayZx+bdMcnEoAxPpXu+btz7raeVbNSigBe63FXJAbdQzEE7caYYOX
	 LrPaRJUi17jHV055SKdmPR30Jf6fnLVazoCvHVBSSPoS+SpBO14RRFXgnUUAI5nq3LIWv
	 0kUQ1dHYRIn0n1x4wVFS+rhPc6ddAv/olAQk39svXYuzdlVuf0HGUE/LLVSA3eJMmsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w1oXIYBotT4utLkXjFpEpPGSWG/msF/777kruCsr42I=;
	b=Pl4ITICkQ7fGYv1BoBz6lK3dEA8l4LFTetq8+hj0Om2SEwJjXhmhxYfpyyn1RRlUCW0v
	 1Ky2SVPqQ2Y0VqYxkW9F/48mp3fmmCu5JFE44bMXP9AldJ3ZEv6y6oLCabgHhfys1/wBY
	 K3Y84eL6MBDb/XRkdCMJttpFX0B1Kwp4Z0zHVvp1NoH5Wdx6BVn6gEbrrQS2bsaTKMtfx
	 py3ZC/SgXpKG2WOoFnoIzudq9jrZ2UGaNWMrouOs+JPmZerYpemDcQekQ0yNdTyU6FL5L
	 tHrNuFzAtPwRPzbsMYhw8PAyZqZSe+uqkG/BH1+y1Mc2+cbh2lHkcxxnb1jG+oSOm8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLR3Ft8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DB1606BA3C;
	Wed,  4 Nov 2026 22:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLR3Ft8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE7C1F00919;
	Wed,  4 Nov 2026 22:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829703;
	bh=w1oXIYBotT4utLkXjFpEpPGSWG/msF/777kruCsr42I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLR3Ft8zoVvISvOqIYGEPt8DiRV8oP2MQPKQiFI9v0qaOigDZBAbqnlud/1rvl1rg
	 atHY28jr7HYa7lQjTiLv2f9d1aUmThAaYk2HceOkLPSQRhd9dWyTJvwKhGwYjU6c7+
	 RrYz/jRf1zIcIHFGU3ArjE2uOAUsHHCjwum4TEcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0289/1005] regulator: rt6245: Restore state on enable failure
Date: Wed,  4 Nov 2026 16:00:22 -0500
Message-ID: <20261104211052.001320627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e95a0a309ca02bf26dc937cdeb3fe2a235c65f63 ]

Currently, if regcache_sync() fails after the enable GPIO has been
asserted, the driver returns with enable_gpio still set high and
regcache_cache_only() left disabled. This leaves the device state
inconsistent with the disabled state, where the enable GPIO is low and
cache_only is enabled.
On failure, restore the original state by setting cache_only back to
true and driving the enable GPIO low before returning the error.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260729100018.66577-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rt6245-regulator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/rt6245-regulator.c b/drivers/regulator/rt6245-regulator.c
index 1843ecec19229..5c0ee04e97ac7 100644
--- a/drivers/regulator/rt6245-regulator.c
+++ b/drivers/regulator/rt6245-regulator.c
@@ -49,8 +49,11 @@ static int rt6245_enable(struct regulator_dev *rdev)
 
 	regcache_cache_only(regmap, false);
 	ret = regcache_sync(regmap);
-	if (ret)
+	if (ret) {
+		regcache_cache_only(regmap, true);
+		gpiod_direction_output(priv->enable_gpio, 0);
 		return ret;
+	}
 
 	priv->enable_state = true;
 	return 0;
-- 
2.53.0



