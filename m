Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049067;
	b=eOdYBFwGi83eTdghwo65LzC46MXiTrDxpTL1yYlKj5S8R5wwsWZYNZPb8/cNEU9d+eKS
	 yW9rV8C9wO34cTGxASuq2d8942PoLIdNGXB2cneCm5vubSzn+vDdFLtvGV+5qrlMx+Vr5
	 pvF4M9+f62KcEPIGFiERz9KcMAcg0DD/P85w2gKhI51cEUHHnOS9mLqz+xIvbKqc3j0IM
	 5zVPoSd7NTEh+ZPSKQxUMOGHxAuBTwctUpipGQY+ADE0GjcTXm5qrnCkrNs9vCa2Uw3GI
	 dciQgy69OAb7nY7ffFNr47p2+tU0h9RuH8D8dWDjtYbW0isOvE/xgwwaBgtd6LXSzyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jnPajr/zctp4AITDpXqN9PoMDanr6H1TJCYvxX8AQJU=;
	b=bGHmOcSbA5r4g1icPf+hNTyof5a/mcgbfL2EGUC+pVzV0wxYrikqzRy+IWNjWjJoGVx1
	 23R/pXYKux36DoIyWEE/PDMFD0c9EtCEeTEQScDH42Kl6yfrcQqyVF/yTbP+1v5vQBwMf
	 PgXH2a8T6HPQIirwgp0FxvuPlquWqnvK88VwCuCyZz/MQtPwhOo8EeXK6A7Kf3w1z4KEo
	 O6meiRcc7EOtzavswaIP0VtcRbKhavqUFZNcre/wywY/cw0k62fJJ1a4e+9StVa/y0C06
	 y4+a46DwMaxaKjhjX+UsLKxEHnGGaEEdcABZPaCsmhg0eArYEqkpsg4/7t4m12ndGBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieKopThe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E142B606A32A;
	Thu, 19 Nov 2026 00:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ieKopThe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C64C1F000CA;
	Thu, 19 Nov 2026 00:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049066;
	bh=jnPajr/zctp4AITDpXqN9PoMDanr6H1TJCYvxX8AQJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieKopTheQKxQR3n0pY1ByOmyV3gYAVi/oGXrou+EVOJYkXTl/tDnAQ8pVHBkn0fnJ
	 RVp7051RinfyFfU4Ch7C+XpUH4ByhGKhPfKaT6nWujVjr7w2pseSKYTeEKITI6boCI
	 ybDcIa9YixfdP6q9CxVdJL6CylvfSooRX/s2izIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2218/2857] ASoC: rt711-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:54:12 +0100
Message-ID: <20261118150321.278282143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index af7a0ab5669f4..104749f6dc5a5 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -465,11 +465,9 @@ static int rt711_sdw_remove(struct sdw_slave *slave)
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
 
 	if (rt711->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



