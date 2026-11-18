Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018547;
	b=MhGPigK8YvCuxVXNRTAQwtHGqxo9Cog/xDZilZnSQyoL+VTneB7hF5yzJGCuxg/+4Z3r
	 +lAqCMqJPZRKuvBEMWdkDqO/TscED5Sv8699ZFfv153VA9pZohinbq1SfEuxLEyVw6NhG
	 FwC82MijTkMqE/ln52xaTyjqvmUTFQXzTVRxWGiTqOTBNY3MIHRVPXt743ow/QBuSHvVA
	 pu4pOt+Pl9iav8BiD/0IwyaDgve0XDL7QdUEHzfKoBGmBtowY+clNWEPEIT8kVj6Gukxv
	 BYYjW/WrBnW59943EOga0/4DR+3Igz2xh7b3dCzM1RCnQkPlq8j6bsjBq8SkaebtIug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PHbIx0I5ZOuYAUXiPafUe4JdFd/9aynsClTSZ/fJn1I=;
	b=xP9T57Zq1yy0T+9+wS1SjqMNrltBAWnLcQs0THBUETakjl6kuqLSzJQ/5KnLhZSATT9E
	 CyshmR9rAIpdjiOC3gbEdV6/tZEkvhI98dZTKfI5rR1seq0KmGBSaMRLnrDezitYjzyJw
	 hYmg6zaP2yu2giEvJcfjgrTPpclStXz/zfaJVBKt+mF55AMxaK1evkROjOnfeZe/TQLUp
	 cSaFIzp4OQNtBnGl5mrgliDXTnaAamrn/3fgxwWKtng6WXvuGATZgkk5uvSD453zY8vds
	 tLIr0+PurGW78XMw44ja0JKlL4Y2xji7WT0EDODCNLGmkcDWy8RMEZ+hOOSMYg+C31w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOz4KZVd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7FA606A320;
	Wed, 18 Nov 2026 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOz4KZVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C882D1F000C5;
	Wed, 18 Nov 2026 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018547;
	bh=PHbIx0I5ZOuYAUXiPafUe4JdFd/9aynsClTSZ/fJn1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOz4KZVdAleH0qgO0eOb7DbhxiIHTWm9OnEFAv80GfKnyE/GSWqjn4yp2HGmWaLrR
	 +WJ66YglcidloYB8ObPMVUeoxByJxcct/4cLs3fSiSbve4IDbukfLtLKb3m/gUYjID
	 t+lzb/V1ZPDZkUQwR4SLcYxdv7UVyQuCwVN0CUpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1279/2651] ASoC: rt711-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:41:59 +0100
Message-ID: <20261118150333.987730380@linuxfoundation.org>
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
index 4ad2b1da19544..798d181d5c902 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -461,11 +461,9 @@ static void rt711_sdw_remove(struct sdw_slave *slave)
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



