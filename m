Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024022;
	b=I1Zlwue3C1bP+XlfhXkkmO2UHDkHIKPXQOtXIY+OPioXcsraOlaWNoaPJAwkh9LLknRL
	 dyhpjP8ItCoOxnS3d4U3XZUrK1TRJ28hHF/YpYHULe99ITFqXhRiE+cdGZMuVmV62Fv4M
	 vzWKepdFFl+cGjS+IZ5axsU0DHFe5quGrhxqfRNUmzlMuunrZODbZdKmsy7rM98qvIKVq
	 kxidiR2b9qh9b5hiWchi2yRwOEtULSGEU6ctWQGQ3wM7dzsW1mD01mEWJq4hp5GMK/UF0
	 fKC5bEr1Bp7u/7oGOZkmDGwRSWZZlAJuCncV1qzTM0gYwPKyDe5Z4dWDHOEPSurNTuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jxXxzYsDHOdk7Yzi1oVcUVQCOPt1+v1mJ/fxFsP3xMk=;
	b=W5+TvJPaNUNyCrLgY3smGOSfM/TUCQw53MGEcJIOdo/+kNEQTD7dmTmTIewaHGGfldlr
	 16Iie7P656X4MsM6fZMEmaewZi5YHUFdQyzUVbLuKqXU9prvCq6cjYz/Ab9P5jgEbIEgK
	 GpcWhOTs9I1O6mAswxmOY4/Yp9TcW5yjMWWiWpWufNjVw3F7uYCDrlIcb9ADU/MfPa8y/
	 Us6fUw1e5ctxarMLTTmq1i1SO3kKsktO1S2l56x2P+gAs3AWuOKomPTP/ZYFqp3dmnjGI
	 l0/YuPUmBUD+B8uZJ2+PVAGy05qIsbhsI/bpIuK+d6K9tUx5sLKmeS7TOgjSBMFD0Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA17XQW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2653606A331;
	Wed, 18 Nov 2026 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA17XQW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C44E1F000C5;
	Wed, 18 Nov 2026 17:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024021;
	bh=jxXxzYsDHOdk7Yzi1oVcUVQCOPt1+v1mJ/fxFsP3xMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yA17XQW9fPhyjpy/SYKQIUtaUr8mK2oGeMNzX5tCAieZO/D2FuYjyhXHuhjJXSTjX
	 E3IeFFyGXr+AF7153IJCVxfnYZDrXqE9PpifUcdb2JH7Jv9CN7WxX6OaQRCFkVfXPD
	 GWOzhfdH8kg8gE/E8/6pJg+3ml37OuzhnHScXHlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0560/2151] thermal/drivers/renesas/rzg3e: Fix runtime PM handling of compare irq
Date: Wed, 18 Nov 2026 15:38:15 +0100
Message-ID: <20261118150142.354139529@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit aa1bc39e45f29a4f56d7e6be7164e100727df465 ]

The TSU hw is limited in the sense that lower and upper trip points can be
set, but the hw cannot raise interrupts on its own. It can only signal that
the thresholds were passed when the temperature is read, either during
polling or on a manual read. Therefore, the interrupt enable state
configured by set_trips() must remain active for the next read to trigger
an event.

Currently, runtime PM autosuspend puts the chip to sleep and clears the
compare interrupt that was enabled during set_trips(). On power up, the
compare interrupt enable is not restored, which means that it won't ever
fire.

Fix this by caching the contents of the SIER register during runtime power
off and restore it during runtime power on.

Fixes: dc67521c20b7 ("thermal/drivers/renesas/rzg3e: Fix add thermal driver for the Renesas RZ/G3E SoC")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260916120003.87018-3-ovidiu.panait.rb@renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rzg3e_thermal.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/renesas/rzg3e_thermal.c b/drivers/thermal/renesas/rzg3e_thermal.c
index b797c367ae44f..423e852f4cbf1 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -88,6 +88,7 @@ struct rzg3e_thermal_info {
  * @info: chip type specific information
  * @trmval0: calibration value 0 (b)
  * @trmval1: calibration value 1 (c)
+ * @sier: cached interrupt enable register
  * @lock: protects hardware access during conversions
  */
 struct rzg3e_thermal_priv {
@@ -98,6 +99,7 @@ struct rzg3e_thermal_priv {
 	const struct rzg3e_thermal_info *info;
 	u16 trmval0;
 	u16 trmval1;
+	u32 sier;
 	struct mutex lock;
 };
 
@@ -143,12 +145,16 @@ static int rzg3e_thermal_power_on(struct rzg3e_thermal_priv *priv)
 		return ret;
 	}
 
+	/* Restore interrupt enable state */
+	writel(priv->sier, priv->base + TSU_SIER);
+
 	return 0;
 }
 
 static void rzg3e_thermal_power_off(struct rzg3e_thermal_priv *priv)
 {
-	/* Disable all interrupts */
+	/* Save and disable all interrupts */
+	priv->sier = readl(priv->base + TSU_SIER);
 	writel(0, priv->base + TSU_SIER);
 
 	/* Clear pending interrupts */
-- 
2.53.0



