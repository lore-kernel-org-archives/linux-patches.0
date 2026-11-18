Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043640;
	b=VyAWuxaQKOxdjQy0vCc4fQbAm2ft8/XDz9M8adOSQWXdwvRidp8+wx1u2S10e5DFo7Fb
	 iXAuU7nPYSsPvA39+/hnw4WqG3gyBxyv6Cuw9Wu4tyIvvqRphm0RYSYIwd6zMWvFa4oxL
	 7utyyD717aUxFYnS+KY4q3z0DUFpXDxIGeieEUXGE6GHt0RpbTDSdydiGTyWtQVg6CUb3
	 gVqSTd+UDhYrYBGaDSKLbS1PDGzfkXxUvSQTOx2G1yvquJSuIV7gQPKUJkeKcKZZrIKCb
	 vlsoKPJn+9cIVk1h+UiqOTyu1npLjAh/iqyvNk4L+T6cPLBf5dEDcW+lWnu8v8ipMXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4jTeCdCTpBTURzoF3qcNAP0sOpaf8ezhhZIo7EwBe4o=;
	b=lK2hQ4M693ejQsdUT3bR1vgDG3jjTIQOMIcxZIMkjaedxtdQiln4ldCvzebqozn5i96F
	 SPSVHXJrJAx49n90QAOyvlfm8GgoEnK/buXfcIDU14pP8UciUgWaTiUA79ltMIhcigVQk
	 W29fbWRJSACXXv5Sn2dbbHQsUT4te9vHR+8ekGCGdvnOglC+gBzJrgWuDbDjXo64X0SSQ
	 pk0ZORbbeAmxnVJZBLF+vqPbL1cZGrUQ69XYrGdcC/dRSJb2z25eHeu6cysxAEI+iOfn3
	 g9SORsf6rpjpdC2q/cYNBJcVlwkCj9/zPZBOjwxXz6RpFkhjvc2aIbnxEH/T66Jwckg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iGAdIl9l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6039F606A32C;
	Wed, 18 Nov 2026 23:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iGAdIl9l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36F21F000C4;
	Wed, 18 Nov 2026 23:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043640;
	bh=4jTeCdCTpBTURzoF3qcNAP0sOpaf8ezhhZIo7EwBe4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGAdIl9lrV5k4WCYBmbS6TdyrwtBKX0ugzJzuHnolxwurzRY6dTLP9XBDSTCdqUp6
	 mELLPZL0lNqh/+DolyDq55lfBV3p10jLKL5ZKn+HH7kbEbG8yCErEJPtoBf0v5TXU8
	 oq3lodaqWt9S3FZ/utKY/jRnBMErgmR+8fbjoiX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Carl Lee <carl.lee@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0231/2857] nfc: nxp-nci: Add remove on IRQ error
Date: Wed, 18 Nov 2026 15:21:05 +0100
Message-ID: <20261118150209.773742805@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

[ Upstream commit 56345cea6a30dc7a1b036d5fb7900434b4a4c5e8 ]

Add a call to nxp_nci_remove() in nxp_nci_i2c_probe() when the
request_threaded_irq() fails.
Previously, IRQ resources were not being freed upon error.

Assisted-by: gkh_clanker_2000
Cc: David Heidelberg <david@ixit.cz>
Cc: Carl Lee <carl.lee@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Ian Ray <ian.ray@gehealthcare.com>
Cc: "Uwe Kleine-König (The Capable Hub)" <u.kleine-koenig@baylibre.com>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Ian Ray <ian.ray@gehealthcare.com>
Link: https://patch.msgid.link/2026070726-observer-fang-9716@gregkh
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/i2c.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 9b9ca3ced856b..5480cf6925819 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -327,8 +327,10 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 				 nxp_nci_i2c_irq_thread_fn,
 				 irqflags | IRQF_ONESHOT,
 				 NXP_NCI_I2C_DRIVER_NAME, phy);
-	if (r < 0)
+	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
+		nxp_nci_remove(phy->ndev);
+	}
 
 	return r;
 }
-- 
2.53.0



