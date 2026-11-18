Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051413;
	b=uCedF6R/ncWoXbloKVgqGA2MFKG0dK88td6Oj1hKcCWuwc8vfL2NAAqlZtuwxk2rIw8i
	 3JcytXHJ1qx55l85OfFLKBaQ5iSWPJn9hIvhKo6X9FUMSQ65Bso3qVq9qao1+0olWzFGG
	 lKqELGQh0TUCzTQUO7ZdfmeCh6yt1uwPZE9YGEgrevWlGPXDycJC66nZPjN23IMDJv6rw
	 M637bFJNOJmOVpa3co/DVDFaXnxA9qoSxEG1QatQSl/43kjZvdiB7uQjuzhYhmO+mTh70
	 hS80NueFHlv/ROT/Zsv9Iy7hXvQgotEbRH1L1xtis4SR8iA7XMnUR0NhXV2Q3lrarUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fZUpHls+Ov8OwQkOe97St1btwFkxOt+30KgrKuScy0U=;
	b=4n3YEqVP/BY9HjcaaEROqW1GExshxTKzVsBsibKQfZUW9t1h4jf1ELEMpAPDMhNNeUm1
	 +tNV4UVC7IreqBX+ju6F4DkunxOXjQCUslftfjZHtTLwrDHLnCdRcLYjzC7eTcU6cfVkX
	 YDpL4Uk+AflSp3h9jn1aPIXRlwGoCzC6g1jA0lqIo2du2iF6xNWdVb3cS9p+H/ylMpEoz
	 OyDPVGRyVgKiuGrw6dxw+OrhVhhS/wofSayzwS+N4yjjVxV5V/Y8tqNaJc34uUA9T8n9i
	 y4T7Aaop4ZRoVwiLfsC9S5iQWVJD9aggJ/gZr84j37DYBGt6r83q02JFj5Xc5OWgGfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQLTevCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E16606A320;
	Thu, 19 Nov 2026 01:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQLTevCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D09F1F000C4;
	Thu, 19 Nov 2026 01:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051413;
	bh=fZUpHls+Ov8OwQkOe97St1btwFkxOt+30KgrKuScy0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQLTevCfAyKQmMJfKOVN6xzNKmv/P8OC+9DH52fUw8CJptS2LpP4aHKtN92zK788M
	 iwrAYmJz/3sXXM8PiwDeB/pVLoZRntrLvypkU+wjnYHrdcGBF+1AJzen5D3AhOGPiU
	 evvFJ/dEgAn9FhaR6Pc+8H6StvAy3mbGC2qSSOf8=
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
Subject: [PATCH 5.15 0199/2214] nfc: nxp-nci: Add remove on IRQ error
Date: Wed, 18 Nov 2026 15:31:15 +0100
Message-ID: <20261118150018.181037437@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0e665f958c4d..0fdd6cc648a77 100644
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



