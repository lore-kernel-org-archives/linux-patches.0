Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830952;
	b=x4mA6sN1S/HBUmIphW/nlTWtQ8f3zEqr/MVMyZERkzesBO5uLC4cGMlP+arm1dkYfntC
	 QjmrVM1YDMdAbX639Di5XC6zToiYcjnZI1IxXPCgFo2ht1IoLNimjS9V33LtJ4sSFEdXT
	 Nz+Pb7kxZjRUldQL9cEMHP5oqbkdcNd9V8yqwoIZAgXkWHTipFfqQ0uvAqWV66kmzbtR5
	 XN6tX55txbPu/S54GEzMMom9i7SzcQ+iP5UPEaqtmKlSV7fedwt5Ass/uZKw4y4ee3SvT
	 LqnlU71Ywtcac6GjlYbbi2uwuVmdOrVw+VB2MEHsILnF+8Sad4vf+SkVcw5yNvB5jPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=d8Nc2f0uoDYHumJItDmVIPDzOqF6gy3zy6A2+vYC5BQ=;
	b=ZkDDeosogBUzDu7RvNg+UIdmeHiogIoIeruIP+unR5DecbfuHZg/r+IqPq64kTuMAVWD
	 fgf2T9wlDuG3G6DHI+cl775CftvKw71RRRZZTuIQpLz6lFMZiAYMCwpj+sz41Zz229lVx
	 OPiDuVZxSBacE7EgAzQpgS+3CImIFaCJgMNFqciJ6ljhGhNV6iWDvyOPgpYMRE9nlkHSw
	 7RUmEGKtBC3k/7dthQrDcu7iSbHxZ8JHhQai3NECwdtNw2H5ybj3rxOGqRAGNKkLe45zk
	 xo/0iNlD7aD9aL2qMYUmfkN0GpzmLpahILBl5/isbO2AgcPW+ZJhLRfYNaDmoQTc2tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKoM729h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A49606A844;
	Wed,  4 Nov 2026 22:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKoM729h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F011F000C1;
	Wed,  4 Nov 2026 22:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830951;
	bh=d8Nc2f0uoDYHumJItDmVIPDzOqF6gy3zy6A2+vYC5BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKoM729hevte51z18pjXyVtfJRcvWZ0PsEJ+aVDSCs5cE6dLyosph2YBqnNWi7LPZ
	 vl1/4OojRDBFMTVlb4F0xF8ZhOkRTkB15DqvfMLWG6r0pmz6PkMG4A9cRBOMdSJe3p
	 LxeJ+Ls4n5KlqQ/Dn5D8s21xtM0phd33+Y2zSRQs=
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
Subject: [PATCH 6.18 0383/1005] nfc: nxp-nci: Add remove on IRQ error
Date: Wed,  4 Nov 2026 16:01:56 -0500
Message-ID: <20261104211054.823047733@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a6c08175d9dd9..213d3eea7dd04 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -326,8 +326,10 @@ static int nxp_nci_i2c_probe(struct i2c_client *client)
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



