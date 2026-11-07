Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060962;
	b=TBLspEa9asdkYsfGyWqwFmVH+QSDbeyyxT5s/cY/ydTRhv8dhLGHL4gkySYhpoDLKaXP
	 KtP7NCHHvUjsz04SsV2LOqthAnoBlPH7Ee5JLQo2wc6G0zEUToMQUDDLxefC9qvFAEpiD
	 scq4Vj4UUfato8SFWuXQY+mfKdpm3dCR/q+eVcA+MstntY7gRzQL+DenuLpuaA9Ewg5Vi
	 +qlfJ3B0gmnWmvXKM+bScMk942LxAtDiRyfZ9frvue3yvWwOupwOwzqZVAZm6Kire33Gn
	 Stekj+BYyfmn3KUNbhhXdWHC5sFf79qSZCbMs7wcyIGhJOvWrgVWURBJC22Nv6CcJOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Q4o+GO2nCTSkwLTMzYSKIJA/8S0JP7b98IG2xkRE5ns=;
	b=T+EYvmJ6gXwDtra0Vy+ShJQdkxFHSII8YJZJkIxJcsfnAAj7nRt0X9G9ys86NpIzvvpm
	 kICoYPTRux84+0UelipOEw2OT+yQZpn0EhSz9tSruHL7oiAr35eQjIPpE0/yjgikp7RmU
	 dyDmUw0bwC9lS6tO/C88UqCZCl8w9AA4axFdm8UYY36MltEuLJI8aL2ajKUZyHPaR2fCP
	 GZfJu1g5hLTvgQ07DlKiGjKUkrUDFDlSyoI1qbkCs9Vk3DP1J2Fjog3JO3JG/ITknwKAa
	 MVaWNIeb1zWwSQMW0fMWRc0agHbtVxm9x5MqGynd1Ra2SKTHHantZj/clp0h5hM+yRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/ciw5YY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3712606A33A;
	Sat,  7 Nov 2026 14:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/ciw5YY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AF21F0089F;
	Sat,  7 Nov 2026 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060961;
	bh=Q4o+GO2nCTSkwLTMzYSKIJA/8S0JP7b98IG2xkRE5ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/ciw5YYy20nz2/He3dcHmsXaKy/dvg+ny0C8oCa1dQEVBPy83sckrb8vI29GYMIt
	 dFrIa6GHe+y9OOdhodoPYJbcnwYrtQuKsbJVoMCnWAQC+3P2/Wr03Xk66IocnoUhej
	 63cuA1WHOjMYogR1AKXPbvVXqEWKhRfdZnVSX8gE=
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
Subject: [PATCH 6.12 0318/1536] nfc: nxp-nci: Add remove on IRQ error
Date: Sat,  7 Nov 2026 08:38:54 -0500
Message-ID: <20261107135006.653455653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



