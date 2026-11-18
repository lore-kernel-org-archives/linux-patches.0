Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040750;
	b=JJAZw8WQZ/rgrR5OPRWoXoxe1o+L3vcuSiEjkp2rfHyecY9XpOCEaQfz7VYOcIlNsrHP
	 zClmDq9mNxPrDpn/dvpwpVNsE7CHuMZO1EA/3hqpdQSByaG6gffiATOPe5E/EeCNfcEs5
	 +CHqlQEXL0o7nVuzdwcs2HkHwULyYVJz2GQQrqZIUM+JusGaYR/zwvQG+8J8f7G5Vy3GL
	 RDAhXP/nQFz0QBU3SPk6k4yPenulAtSCTg362rKFarZ5muqPzIHRimUSWgQy8fku4sq0k
	 vhzdy9i1I63HU30aHrg33nvrcy4MoMi5hhsBSe3pr5bbvwFo2Ngu+6DolSD+9qn7L5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fEQva2uB0Tq69uLsXCrvcglKDfnVTYyIllHzhkxarPg=;
	b=HH/a7kmzG8rjF3U/JN38zVGV8lAmZ6TgEm5sMuEsXycVHfPYCQOI0MVD3xdDlHXbsnR4
	 1baU3kjNYss/ujZNYti27jF/4M7+c+cQTtZhkC6E9gjoaXj/G5kGx34aeJ5lv2CbuJAWx
	 ppOrDzC3+e2YUFKtt9x1OwYqBbiecO3O+UP23y7jgLykPnEg0oB9kVJfpQw4ZVmA0kQR0
	 9dGMptUqz5oqJd7y3/HV1F55v4CAnEbAEVCn7haan9tpmoQdCLRcxADXSnq4qKLPIsatH
	 nCAvYXJUWSdR54j1JSON2V3XiH50D2UyRAG1MKKZF5iq1hY532grrecjnF52JzIHgdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbsfMBud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5473A606A320;
	Wed, 18 Nov 2026 22:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbsfMBud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FEB1F000C4;
	Wed, 18 Nov 2026 22:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040750;
	bh=fEQva2uB0Tq69uLsXCrvcglKDfnVTYyIllHzhkxarPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbsfMBudSv2e48aGjgAfJBlQ8X51uuAqr0IqUU6wgjaAxu9No50ot7Rlei4I+uPHE
	 DvDhPZgoA1gwIUyhSl8Lv2wo3oZB5x7yjkpCY3Pf2kisHNksa9YFZWrelcTzEsuEIj
	 SCkajkKItoEaDIMnsrNjnxPUcOGD6k/bx8S6nfw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2567/3318] ASoC: rt711-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:53:09 +0100
Message-ID: <20261118150438.251635539@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 4bf78e3d9e324f9f2e39feecedd4f70b05baeb16 ]

rt711_sdw_remove() cancels the jack and calibration work only when
hw_init is true. rt711_update_status() clears hw_init when the SoundWire
slave becomes unattached, but work may already have been queued by
rt711_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-3-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdw.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdw.c b/sound/soc/codecs/rt711-sdw.c
index 988451f24a756..582678e76c559 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -460,11 +460,9 @@ static int rt711_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt711_priv *rt711 = dev_get_drvdata(&slave->dev);
 
-	if (rt711->hw_init) {
-		cancel_delayed_work_sync(&rt711->jack_detect_work);
-		cancel_delayed_work_sync(&rt711->jack_btn_check_work);
-		cancel_work_sync(&rt711->calibration_work);
-	}
+	cancel_delayed_work_sync(&rt711->jack_detect_work);
+	cancel_delayed_work_sync(&rt711->jack_btn_check_work);
+	cancel_work_sync(&rt711->calibration_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



