Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059842;
	b=VA2O3nQx69NZJiTBoxr9Tm2ROiTHdsKkEairLunuDLO8KY9H6/y/4ej+vkYEYyES1Izb
	 t7zt5AaVb8lXHU6+Xr5etawLHwrIZKZ2iJHz4KGtB6dqDYvc31exgjUSLHxWB1zhJVTdK
	 zCum9P+BXf5NNX4Bc22pWpw71Cxv867FP4frZyRAk/XPE4Cz+MqaGjkhjo/GZ3rh7twOV
	 iA8ffUO3HTDSS1jkZDNvTQ1U6zXqHOPcqa/iDacl3T1cYwV/36MYVC13HGhpokhuq/7xs
	 YJA5j4YhFj9eZrER9RLuXvnHrZl0sUbKpUWKpW/xebUPptuVwmWG22ihUbnalY3yI0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DUCMgcj0+vB1MB5VbWPiiSTUIOUN1HPDME6c2vRO0GE=;
	b=QmfdpHEmCfUzK2dLXlP2zVAr7bqf4qKPNC/KslT6OLo2k3p1UhNlBrFuhTeawe9rNNXg
	 bL88HL5VcC9NElYYohBzdriOAoRDaKzoMSoQUsOn3mVLR2L5Bs6Oucvk6uQr+f/LNRjnk
	 9s3k7f5o3ll0eY6phVeiQWh9iR99nR9p1dssiTa8PSi5qZ8Fb/zmBmeP8ib5/QfmoIgbI
	 he02djA7uR6otrcsgVUS+gkDnPaCZ44bTHvRQDGNvGVkEAVl8GhMp3WpubOf5nLM7vj+a
	 nRCw+KMwRQVPrhp5LZS3A+94natDH5pu+8OvIXLHWZfVKeMTo4ZuUzQUSn0A17px7sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0fo19lEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB62606A325;
	Thu, 19 Nov 2026 03:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0fo19lEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABD91F000C4;
	Thu, 19 Nov 2026 03:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059841;
	bh=DUCMgcj0+vB1MB5VbWPiiSTUIOUN1HPDME6c2vRO0GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fo19lEZJoZPu2pYdCyb9FNB9MRuL8UMZYHYoR3Uf4nrm/mY7ZLemrS8IFt9Ig8S8
	 xN5xiy8j0RTCTrePlRfwnBRbClW6wD06MgYHYiT956X+1bnPZkY9MC9iXOjtidFjWF
	 NjgwjYXu2N8pgXqRgnWLTlECXOHXAtlgocs6DsUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0987/1848] mfd: wcd934x: Fix an error handling path in wcd934x_slim_probe()
Date: Wed, 18 Nov 2026 15:50:25 +0100
Message-ID: <20261118145958.207849927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f190b4891a3f9fac123a7afd378d4143a2723313 ]

If devm_gpiod_get_optional() fails, some resources need to be released, as
already done in the .remove() function.

While at it, remove the unneeded error code from a dev_err_probe() call.
It is already added in a human readable way by dev_err_probe() itself.

Fixes: 6a0ee2a61a31 ("mfd: wcd934x: Replace legacy gpio interface for gpiod")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/02d8447f6d1df52cc8357aae698152e9a9be67c6.1684565021.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index d725e7fca392b..83f84f929a405 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -255,8 +255,9 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	usleep_range(600, 650);
 	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(reset_gpio)) {
-		return dev_err_probe(dev, PTR_ERR(reset_gpio),
-				"Failed to get reset gpio: err = %ld\n", PTR_ERR(reset_gpio));
+		ret = dev_err_probe(dev, PTR_ERR(reset_gpio),
+				    "Failed to get reset gpio\n");
+		goto err_disable_regulators;
 	}
 	msleep(20);
 	gpiod_set_value(reset_gpio, 1);
@@ -266,6 +267,10 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	dev_set_drvdata(dev, ddata);
 
 	return 0;
+
+err_disable_regulators:
+	regulator_bulk_disable(WCD934X_MAX_SUPPLY, ddata->supplies);
+	return ret;
 }
 
 static void wcd934x_slim_remove(struct slim_device *sdev)
-- 
2.53.0



