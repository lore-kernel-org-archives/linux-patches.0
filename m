Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025528;
	b=K+uffTll2M26huewvth5lxJSOV9/9BUOxqbWu2meIhBSUcrbk1RenHl1lSbU9uSOloCK
	 eBxsKsK6zJ82MA3ubEtHmg5gSV+vQBlBojmQ/LcQ8e92e2vl50R63J6FVvDhPsdz0BV6Q
	 zj2Mm2/xr/ugryFA0nCnjz6C/UD1JinGI5ehHUmK4zDzRCb/tjWkSPOSAUnr+Tf1uyFvc
	 wzDdz9Z7N3ReacGkV9YUbQIBh3MmSh5hUR2udkXAp+wR3McXOzLNLNDUIKUCz9pf/MQmZ
	 +S9jrBOzGIGbTvl4p/wn/tS0fcWZ52NsnboZ/u67vtEeB7DKo6iCrGlDEzhNClLK2qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/xji8Ra/gWckYG0ThmULvYuBmCZOn/ATodjbPqrZhuw=;
	b=zmycRpdljunPkiTb64s0thTRsiUy+tgELBNPpcwJn/BoJgu6ejeQt2XTvXykAhhsnH6b
	 Xdaqae4Kei3yWPmDNmCCfjFYz4q7s82V0jco+wKvv7vB4EZd6YJk1rWLOVdxB/qtWfOwj
	 nENTxCchtjaHkcagI6FrdmqqIKiuSIgWrMMp9RBTeA40ifO1CQVCEUQ+I0XFBbfSnqIcF
	 oqJYP9mfCEhcQQ4zoyUQLEIuMnaRtmqrYYnAx3z3gONOod5CE2zeuQ0297KJzeSMnVoVn
	 MVPs03NRLxkTT/QTe3kXKDxEyn6z+DiNtUh2p5lcdFb+Lm575nefax6fMrUPIz7dnFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iXijK+3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563D3606A31C;
	Wed, 18 Nov 2026 18:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXijK+3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A949B1F000C4;
	Wed, 18 Nov 2026 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025528;
	bh=/xji8Ra/gWckYG0ThmULvYuBmCZOn/ATodjbPqrZhuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXijK+3/CPh+ZI0KEWk0Nv6gb/Ttfn6ciNosftA9K9peYDZkKJwz+lJ6rf6Gh306x
	 +pV11YMYie8bGO3CAae5gnsxKmRrQjXOMXh+4NqLVDA7zvi7n76zKloeIiXjuh/WsF
	 ACwTX9kdu578u2T0a4YjLiQG6Uzp2gwkOX2+uKLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1069/2151] ASoC: rt711-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:46:44 +0100
Message-ID: <20261118150201.232355241@linuxfoundation.org>
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
index 93a5a89a96b1e..18ab47f86262b 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -462,11 +462,9 @@ static int rt711_sdw_remove(struct sdw_slave *slave)
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



