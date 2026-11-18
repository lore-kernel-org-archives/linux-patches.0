Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026586;
	b=VMg8/X0adUEEEhzfARekLhDnlBRlXhDsZVL5BuUfsEAL8G8NCe37LXONfmBlGW4T+YkW
	 NuG4ieJ5CM8NwOJm8hcTB6GqADdUL0gYP1qEVKuEOzUGuyKUHGsLcJJiScJt6jIuQ2Pvn
	 2633cogLTpNMLzBO84lPGn/i/ADkcofBxv4BgsAChZyrJVnwMWcuhxMY0x6zIBq9YZZdC
	 VdFNidRLYKjYXrTnYgTlbzZuFNo1lxsw60CTP/mHFtCeNJTAofqPmcUmuUdlp/HP5qbtT
	 0UG3XDnseL7fF25aUvAP4NZqarD7PHqpOpz4TXnl0GzN6Fn+r5A6y9ARBiBkNEsoliA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8h+wv3FqBs6jRGvCkHrCBAcdRmTyr9tcX5fI8cmqcT0=;
	b=f3aumCj+CinNQ8R8XQf4TzLkkJpl3EMcu6aNYwAUzs6kKAdWUqpxQ22v8pIJxQSlhyQY
	 BzBo7ZB+HGo2kW1XamiseJKtfpJcxEbWFwezPwZx3hAigWm1RW0y0esqYRrRj3pLZBQuL
	 0aYVbof89YGteuEd4bEga40x19bo/7WgJYwkvqr6k3Ge8NoSFA25ylXgly5lOl9HojUVz
	 3JnJup3gPTWRMzJ3HHsc11AO08qR4rd0Ajj1v9q8XRjFWmYGYdbnQiPVGMH8cMlyR6vZI
	 q1HnOBfsc10deFUzZ0hpO0DX5CY4gSrI5LMTP06r5EX4uvkJfCgLYVywa0EiBGY2BEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYQx5lys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03873606A320;
	Wed, 18 Nov 2026 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYQx5lys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151271F000C4;
	Wed, 18 Nov 2026 18:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026585;
	bh=8h+wv3FqBs6jRGvCkHrCBAcdRmTyr9tcX5fI8cmqcT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYQx5lyscv5i2IJFwKWxBJZCglK6cgkv06JmhvdVHK23oAxhmOlSaZb8M8aTImgCK
	 vK3LAaU5cqJTPU+YnlTXkCqlqTeVK89nLQt0AEXlL7xgcC3LmFfOp8uBGu2/mWL35E
	 JVISve1Yci4D1ID4oAjz/9CWgZACIlO0usXIfsyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1488/2151] thermal/drivers/rzg3e: Propagate reset assertion failure from suspend
Date: Wed, 18 Nov 2026 15:53:43 +0100
Message-ID: <20261118150216.083845522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 2dc1f296b5754dd2441fc8b6613a362a47f6b98f ]

rzg3e_thermal_suspend() powers off an active sensor and then ignores
failure to assert its reset. System sleep can therefore continue without
the clean reset state expected by resume.

Return the reset error and, when the sensor had been active, try to
restore power before failing suspend. This is best-effort recovery:
reset assertion failure may leave partial hardware state, so restoring
power is not guaranteed to succeed. Preserve the original reset error.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: dc67521c20b7 ("thermal/drivers/renesas/rzg3e: Fix add thermal driver for the Renesas RZ/G3E SoC")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20261014031814.7230-1-hppiscas@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rzg3e_thermal.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/renesas/rzg3e_thermal.c b/drivers/thermal/renesas/rzg3e_thermal.c
index 94ac1935c64d4..057303a244c53 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -501,15 +501,19 @@ static int rzg3e_thermal_runtime_resume(struct device *dev)
 static int rzg3e_thermal_suspend(struct device *dev)
 {
 	struct rzg3e_thermal_priv *priv = dev_get_drvdata(dev);
+	bool active = pm_runtime_active(dev);
+	int ret;
 
 	/* If device is active, power it off */
-	if (pm_runtime_active(dev))
+	if (active)
 		rzg3e_thermal_power_off(priv);
 
 	/* Assert reset to ensure clean state after resume */
-	reset_control_assert(priv->rstc);
+	ret = reset_control_assert(priv->rstc);
+	if (ret && active)
+		rzg3e_thermal_power_on(priv);
 
-	return 0;
+	return ret;
 }
 
 static int rzg3e_thermal_resume(struct device *dev)
-- 
2.53.0



