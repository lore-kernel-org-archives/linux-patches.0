Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057551;
	b=RbnRkbdhWEifaUOgQSSY5K7XS75IR31Bfol2mKcU5zUCCveO5K5h7SNu2Ie93HleN9nS
	 Z9WUqpGBsQsxbLGckLaYq1y4YBx7aQl5Te1eEzGqJK643txd2UZ/7m/N4jVPhDv8msVgN
	 aDCkh1ZZfsIHa3cxCZvbKo27AQL0+AN1F6vVJBBResCLGztB4w0KvJDss7pUczSjv43BN
	 ui2RYgdXPBDFLEDbND53Azw3VFNRatpydTXeLq8Ba9GaHh3RkYtiuAu36d72fhkses1Wp
	 i7Dm4AVk66SZarZcVp7qZPmkn1UB3sum2WUQ8wXSn4MRSjJiv7TWiEurAF4Td7hkJRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BAz/q34GOA83xCVCZ2FABTASJ8KWkedQnPQ6yRNLydk=;
	b=vTlBYGrWIs3rzaBpnignZSru1jOKqk26/DprGwwvuR5BgCtxKuaJRjt0u2vWBcS+pjgV
	 TlYv62f+74IT7yOsONGvjd+pWQzPHSNXXa5y0iep4/lSSMsY4QHXPYdrg53mbtrhOSV8/
	 u49LTpuci3K7gj7NGqzM1Agrjv+RSt7PrcGEdDA7I3HYSMUPZDiBdcIK6+ChZnaoKqGYL
	 XMSncT6YL6861CCWp7K9EYeYOByvrwSOdIAw8OSvOqfI5tHEb6g/jeb6YxOwWq2yekKUQ
	 hp7bqaygJZo5am4Wy28P0ugPLGmR/WTInnTssH5JtLtytQxZ5ENfq5yMR0K4mrqerWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQB41yNK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18D360A2602;
	Thu, 19 Nov 2026 03:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQB41yNK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAA01F000C4;
	Thu, 19 Nov 2026 03:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057551;
	bh=BAz/q34GOA83xCVCZ2FABTASJ8KWkedQnPQ6yRNLydk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQB41yNKDXY17nxqLoK0RzpwsUg9vaZeKirKopc3TVVobPkfYU0iWUIrqnYjtxn5g
	 Z5JFiQqzf87FoI76FTTvvZhFEPedOlCwPepXHtonQHFg2ILZiIh/VynF2EFqI9g0w4
	 CJgmFqFwqyHQbn0+fK2nU4nev0BQc4LMgh2IOBXg=
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
Subject: [PATCH 5.10 0169/1848] nfc: nxp-nci: Add remove on IRQ error
Date: Wed, 18 Nov 2026 15:36:47 +0100
Message-ID: <20261118145918.686767890@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 989b4a0e5b198..d90fb2f7f210e 100644
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



