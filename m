Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030944;
	b=Qbght75UbldTCh3pX83ulntmzWHzRFqvbRGZ2uOGhbdnZ5JKlFC/9Qg3prdn/oPV6Nqs
	 7OvKQbnFrTZsGKFPCPG3XqXjcX6gO6//Zq9NXJ57idofXZ5w7vO3yEK3t1b+Er+2OrDCE
	 ay2lhoyKM7DANEOjTTlVCl6Kn4k57wuzwl3P7aFLWIHUa0Nm8dYrbzHYhb5CNqhDTdPt8
	 S2vHK1dGl2Htwgmkt9ohUiU2e81N8m4Fh+9kBda25dMgkHxtysvrGI2x/6o+CnFWN83o3
	 okgtxt1HncdwNq/kokqdSaZ14luDWnlQKi3vwLz7Sn3MOt5xdQX3yjPMqHewLeUFoEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P8ZTy7fyTeOfEX9y86dSLfsUXn55SeehUOz6F1u0P9U=;
	b=J2/c+BPZfIELfvyLhjQbHUOtBmU4dD/t9pkoI9dVdxmuQIJgeMrUIDHWEkMVKSnl8NNB
	 eUC1+q4YB+u6UkfQfPs1aywX8ZClUzzJzKUd9p69qek/ZzCCBbiSqSZK56cox0G4vt2fz
	 sXiIH+Xa6DoDRxdhQQdfba1gG6PFweZLQdEPMZa4MByVb3mbW2M+17yL5k8Fv0h6d2h/k
	 rXo9O73xMPEGW7I+e7GMAFX37L/qDGYy2yOjSsOU7zk8eAeJYDiTKz2o9fW5nDyQ+S9jM
	 Hzpxia5LvKxo0g31iXY3KC/nHSKQAiy7JeXHrhtWYrPcGpGG/yl9FHk9hHsv3VUNcTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KynLVf8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A46606A325;
	Wed, 18 Nov 2026 19:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KynLVf8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B911F000C5;
	Wed, 18 Nov 2026 19:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030944;
	bh=P8ZTy7fyTeOfEX9y86dSLfsUXn55SeehUOz6F1u0P9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KynLVf8pUlHJGxn9VSoiIcSwuFb7yg2kta/CYv9MMmy/75g+8fp1GjqBShbqDkzNz
	 aHMw4Wn3HHIMy/rt0p1s5TqDr0Mdbzm+SPNjzr5yyaFnQ8xky1YB8rl3rGCx30ZgY7
	 kuV93qWViyoyyoM1rNfWt7iRwnz2vxo8qi5USHzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0831/1756] power: supply: ab8500_charger: Fix AC charger re-enable
Date: Wed, 18 Nov 2026 15:49:18 +0100
Message-ID: <20261118150042.582354465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 3e1d2517347f6bb72f74e63ec77d1634385fbf21 ]

The AC check-enable callback passes the embedded USB charger object to
ab8500_charger_ac_en(). That helper derives the parent with the AC
charger offset, so the wrong object yields an invalid ab8500_charger
pointer.

Pass the AC charger object when re-enabling AC charging.

Fixes: bc6e02871402 ("power: supply: ab8500: Standardize CV voltage")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-7-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 5da3b12d9f0bb..b3b1fd7f82f2b 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -1778,7 +1778,7 @@ static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
 }
 
 /**
- * ab8500_charger_ac_check_enable() - enable usb charging
+ * ab8500_charger_ac_check_enable() - enable AC charging
  * @charger:	pointer to the ux500_charger structure
  * @vset_uv:	charging voltage in microvolt
  * @iset_ua:	charger output current in micrompere
@@ -1817,7 +1817,7 @@ static int ab8500_charger_ac_check_enable(struct ux500_charger *charger,
 			return ret;
 		}
 
-		ret = ab8500_charger_ac_en(&di->usb_chg, true, vset_uv, iset_ua);
+		ret = ab8500_charger_ac_en(&di->ac_chg, true, vset_uv, iset_ua);
 		if (ret < 0) {
 			dev_err(di->dev, "failed to enable AC charger %d\n",
 				__LINE__);
-- 
2.53.0



