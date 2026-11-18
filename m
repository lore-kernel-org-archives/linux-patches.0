Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018634;
	b=ZEifEeuB/aB3a2Q2bO79hIr8bC3NbNbz10JaYD5+IZxY4VucU8Aq//t5aul7Ojecwwsz
	 vJ07cLYf4nMKo0qXwYKJ5dVHTXTrR9FBuKZr/mtC2LWH4/+INQSDGc2ZwfJgorNS/fNWp
	 kN5UXqKRwfsBYaflTqpPdxj8zRGLLlYc1k9UTK6D1jwtKXR2mxg8hdGQecVK8OezoKu4S
	 K8f32Kgvs0lSE/ibRj3xeO18pX/K3ANNtHJMXhe+SLd8mzD1vRatN1KuPSjqcumA7MsSR
	 GzUaQtGhML8BqXYsdZNuaDr689KA0Ud3fXVzcvJ8HtpqASGME1GXl7DLaCWDDC3zMkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F0b4TPZTZbGB7vhs+zMTYp1N6QLP8kFuPxj0l17/0R4=;
	b=39dsmU+yFi8TXxM/ySkwj0rq+mfB5CQ3MlClY4t2tliGRUr7DT03ELeEyFaXhfuu0kp8
	 znDPT6Kdo4tSHxqB3XcxHmEtvSXxhUrdVvVWMdzUjyOBEB3LHMJ38+3IYNy61aiubYxk3
	 pMkH636qZ3N2qs8B8jmLOLAMoE9Nj/gOC8Zzz9/ip4Tq9BINR2QnGBjgb3NZlQ1NqHi/i
	 duo6y9n1hjkl1YHjPvL1ea+RYLlCxTOvGAH2KSzU4cxEhJhFEjnj5j6QLXxgNVli7mT7A
	 aXB8IqklsXzINHqsyg7qwFE1YlrUUuib4/uIU335SX2RQxHxXxupSO5rrvPhgIPkRDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8hnKAJN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3922D606A31C;
	Wed, 18 Nov 2026 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8hnKAJN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4371F000C5;
	Wed, 18 Nov 2026 16:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018634;
	bh=F0b4TPZTZbGB7vhs+zMTYp1N6QLP8kFuPxj0l17/0R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8hnKAJNUEbg4gYZgnvlR4Gg80jxVOkm2GmVrXpGfs5Oe4FPIySc17PdUYw3fg+oV
	 dbndlJGmOOaW+pWn7dLy/ZoyAqX0p8BEbqrz3C7q/7J96yzPXzNQUNGgg1AVGdbQtp
	 rHmep5AIMiZvikyJfbXralNYAktkfp06NAP6c03o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1268/2651] power: supply: ab8500_charger: Fix AC charger re-enable
Date: Wed, 18 Nov 2026 15:41:48 +0100
Message-ID: <20261118150333.614877010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ff38254d06efb..b966d2e4a39f8 100644
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



