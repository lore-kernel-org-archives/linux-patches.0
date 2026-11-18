Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025318;
	b=E0cVI9jxlP5rMMb5Ggtto0c0CK3aoDTqEg9+hiQWIvqg8FgTIY733e57f6jwMGYxAgSK
	 QLSYckkljWFS+2cVLyaO5BH53SE0Fw4CNrL3/0aYjIjOR9wDFiEBCC+p58fdvIPqCeSYr
	 dFWgnlLXMlA8ZHpDXCkOirGlhk/HPHSDgWIDum6sGLuEslOWXJbq2ttUPyBGmqk84EZK/
	 RL5TNxSfMvravfix3HIIVAeDVSPzYhfmf6bb0ONzmuia7BpPyCNaomLCMVeuwCEqNKODK
	 yab02ZdJ3egboa1zjiL2zyuOVKxZJmijW8ylPcUzw7PYJATlio/zRFz8S/ZpgjZYDWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+mNVN1JXyZfyhnUxtYvBn6dLSsNp94YGwLd5zQY7GVg=;
	b=y3pZ6SX1uFq70+Q4Wck5Gah+Oow2sXHlpEwFcPHwXSG73+733CCC54AH5GRbeBvEsFXD
	 4l2Zt3n2gMNZpuzdIDDg+A/RHMLa4FO/FlixAVUovUjYo9JcM7Q7SIxKkvdIeESCLLAJL
	 z8QoupNvOYgoCDkAhtgtToFPtSWHJyaxz8qjYoYcQElX4hVxyCh67Y87KMzVYjw0EEJah
	 ImRwtEaVXlQXd0/enOOsmfLCDx0E9OGHoBRSkmpa7IeUyrymGKO7tpSUzW7DteIfCo1Xa
	 g9UWIjLaZdVh2EpC4DSepI7+FanjdLAGTUVqS0QbEUvXg1C+QdE2gTZ1QzPaRNxlang==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irIm4w2Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562F9606A32A;
	Wed, 18 Nov 2026 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irIm4w2Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FF01F000C4;
	Wed, 18 Nov 2026 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025318;
	bh=+mNVN1JXyZfyhnUxtYvBn6dLSsNp94YGwLd5zQY7GVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irIm4w2YfLxh3/oK9m1hkrHxNQGXRKUP3MvcDVqamxAdsd1q8eSc3Vue3EsGXDi8l
	 W4moqubAQD8gXJb6C3t8afB7A3CPK+bQTF5r2tRUvwZtDFNxjRsLzHy58INMVm6aRE
	 kpzk49c+oD44QbZ4LRJF3275Jq+iAm1Gf0Rk4dTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1037/2151] power: supply: bq257xx: Use psy directly instead of driver data
Date: Wed, 18 Nov 2026 15:46:12 +0100
Message-ID: <20261118150200.125712572@linuxfoundation.org>
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
index 7ca4ae6109027..b0164813808d2 100644
--- a/drivers/power/supply/bq257xx_charger.c
+++ b/drivers/power/supply/bq257xx_charger.c
@@ -564,7 +564,7 @@ static void bq257xx_external_power_changed(struct power_supply *psy)
 
 	pdata->chip->bq257xx_get_state(pdata);
 
-	pdata->supplied = power_supply_am_i_supplied(pdata->charger);
+	pdata->supplied = power_supply_am_i_supplied(psy);
 	if (pdata->supplied < 0)
 		return;
 
-- 
2.53.0



