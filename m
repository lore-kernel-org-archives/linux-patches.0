Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034152;
	b=13BhKUPJxlpU0QxEmYpBJYovIrYwc58lV8VKenHx3amn8EwPVCOR63024aDtlXjBl3hl
	 dPG5MzfVfK7V0b0QHR5R6NxXdA2mqIDrDrjjmysoV+UmO4NJNDASRThI82ZdBqqM1JoY9
	 UVet/26bWW/LvacUjuK7pIy019VVeQUasVl6jv1t4bfJal3FXwTL0fAvWbzfTmujOnk10
	 /b/3dH5otKuSqP2y+xD+i8Ha/JYrnncI+J7Q10pnTEjutfJnPMHnLeAMzCe6gaBO6b4ng
	 bKqJGSCgOs6ELid00MDNEAl234d/n+32wNDehvaNJS4sdWbSJKe/qpmOz80anAg/Zvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y9rXK1RGQqwXQxROFMwJR3/6lgQFq07uB7YbV6Maam0=;
	b=tfeSzrHhz1FGC/uCEl0fbqq83pC3ioVzVAICXIoCweAT1VtYD0sea0ragCPHe86xaSzE
	 J28GCCl12I9QsEa1iELB3dfUy/SGUVqexMP3zGeGfU5ILvSaQmCfC6J1QujVXutx6MvjP
	 K7g3cOFaNkeQi5GYX1EU6BQhzFsVAZoeTlr1Z9qMZs5l/wGXyFHeX8ffGG5vgL3lNkgGi
	 LjQmEz2KO0TY+0zlupJPMu/6LWSd82gcsbtvNLoF7JDTrbGW9AXto+NJmXTLgjYI7+tfx
	 bbWxr98+hvyb0Tywmg9LClfBqPBrThSQpcAc0eLP+ZInKARx1gFdEY6Tda3lLlYAGFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1rZRndW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252AF606A330;
	Wed, 18 Nov 2026 20:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1rZRndW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784A51F000C4;
	Wed, 18 Nov 2026 20:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034152;
	bh=Y9rXK1RGQqwXQxROFMwJR3/6lgQFq07uB7YbV6Maam0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1rZRndWl+N5S+n3bgFdh3NFNczhVgoeHU54482LWy4gZmiEBQQOv+6lHINT6h2fA
	 Ar+5hFjT2VfMdPGCQw2AePN8ncgz9aKQxOE+EUVFmv4EtlwI1TmOmSVrshu/tUUgCo
	 q1pKRNx04aMX9asTDHv/aXrbPP4f3tuDRs1fk5YA=
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
Subject: [PATCH 6.6 0268/3318] nfc: nxp-nci: Add remove on IRQ error
Date: Wed, 18 Nov 2026 15:14:50 +0100
Message-ID: <20261118150323.463672892@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e80ce1b97bccc..fac1a9093e046 100644
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



