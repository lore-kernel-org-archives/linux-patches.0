Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018471;
	b=oxTeXX5dcAomowpXRAc9B5CCfSorHpJBMZhPkvVxontD0odPC70J2nYKysskZQSL+Dma
	 yLrHsYh0quLfkDpqzpho3a2/DByeIvVXxLpbOAJ0L9CX/Bz5kFsnlmz/+D13RkG8kmCDV
	 2aP2a1HLzLpnQGLX69Bq5xXBoEzZkeqSZPY7xy4sVJSSNvFjaPblpKdUiLyOTqOG7NnrA
	 L0zfESxktqGnD1bYSN4tBooCKlLRne/Bl6vpaiQKPTIUFVmshnU4L6XMEay5ULnIUTQ9I
	 mblVvr7O2R5ql4dcw8pqrh4i8YNaOdY6EUqdwP2yjOtCUlod2L0geyILJmRH9PxrL3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J/PXYgJ0+Wla9ADdawzg9KtvVN9McS4rUa9gXo0O3qE=;
	b=UOxR95Ma67EMYir092VKLtrsZrigDzBdXjt8PmBopQJtM+gjM5zPk9MzwakeUuA5Is3L
	 I26th4d/K8BkH61/pyrjKz8eOqZyXrEiayu8jeklCCfD5yQj+iF/cqoD2hOIkIfyqBRBa
	 ntrbV0TMbPiVl2pfd4fPdfMPnBrcEP/qYQk7d7bC4XPPOgnoaLqeVS29EayzzDddMr0E8
	 3MoWyzzoNrHZgiNc5m7d3bnYDTDiRnNmlFp55+r7OpUKdgmZyvbkIXeBMKB3lYaojpPRB
	 x+9xXcUyEkqPousesFTZFdFz/ckpBP5lMjoALxewLBYA/93RnZwCieryN8XUW3JdsmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hheosPqj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A7606A32A;
	Wed, 18 Nov 2026 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hheosPqj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C981F000C4;
	Wed, 18 Nov 2026 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018471;
	bh=J/PXYgJ0+Wla9ADdawzg9KtvVN9McS4rUa9gXo0O3qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hheosPqjscuxWc1phtN9uY82Y6/ne2J+9UJ7wyuya6uAwSyQ3c9aH2tD+8UffrdSH
	 LsDay0MKhRe6Z+5dvfFGVVS85KHVByysBk82+R6Qh06FLVHrB0FxcOXQzI4wbJCZCb
	 HJUbuw5picgQ1tQKGZJ92kurN91qUlfYmTRrl+kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1251/2651] power: supply: bq257xx: Use psy directly instead of driver data
Date: Wed, 18 Nov 2026 15:41:31 +0100
Message-ID: <20261118150333.017979600@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 1a64071bb30d97b75a1029943b6a3481098b254b ]

bq257xx_external_power_changed() is handed the power supply it is called
for, but passes pdata->charger to power_supply_am_i_supplied(). Those are
not equivalent during probe or teardown, and a supplier's changed_work can
reach power_supply_external_power_changed() when pdata->charger doesn't
point anywhere meaningful (e.g. freed memory during teardown).

Use the psy argument, which is valid whenever the callback runs.

Fixes: 1cc017b7f9c7 ("power: supply: bq257xx: Add support for BQ257XX charger")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260910-bq257xx-init-v3-2-4e219a1a04a5@flipper.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq257xx_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq257xx_charger.c b/drivers/power/supply/bq257xx_charger.c
index b735bb02a8e00..ab35194541935 100644
--- a/drivers/power/supply/bq257xx_charger.c
+++ b/drivers/power/supply/bq257xx_charger.c
@@ -1055,7 +1055,7 @@ static void bq257xx_external_power_changed(struct power_supply *psy)
 
 	pdata->chip->bq257xx_get_state(pdata);
 
-	pdata->supplied = power_supply_am_i_supplied(pdata->charger);
+	pdata->supplied = power_supply_am_i_supplied(psy);
 	if (pdata->supplied < 0)
 		return;
 
-- 
2.53.0



