Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018550;
	b=JF2taHZY2A34ilfY4kitRHLTmMm0Mi8nQog4V46l6r7kGsoPfWzqx0PNyFy/Lsl54WRa
	 rN7lGg+UQ7GKLE32XdsGLKQa5zED9V51pJZawaecvQ+aIQPWlIGu0YdCx1uKuTxzdMfe4
	 OtEHDpU+PZaijH8h9UNfS4yxvhbQ47waNKt0lOdHJxl4riRRU1+HTYJ1yz2VQdTp0zxqH
	 BQTh/97ZNBCiOxbQiXmZO5WH6GSwDv7yj7keMGNOk9IhVtnLlzT0TFifkYfT5rHaN/X4e
	 4ivMz1a3A5rWc4M7Nt0UQidvurHuJNjRj6ww+Hikq9jYUfRn4bQnZQ1/d/G0512/Yzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iVjADsVXq/nJRA/RJyx0EWkpM7BEEpiEXrDueI5llMk=;
	b=sxzg1ij8fRsIjKDpMZVl8om34a4J73RMK/Z2m9Ve6Kib2Mhurfw0Nl8tM8wzXvNNX1AE
	 gYvQnuSQjc8hzcYXmnmyuSQEtHeL97ajedSgim0ryY1eOwlBaVDTNPSVdh9rnhVdif01S
	 NWxsFO0xoDdthLw575iNoK2fdaj441zrn2WoaAEOhem7IbCxRXYuLn56pKDmiL+zmkMVw
	 am9t1oNHtgraYM/e5qvGSdSukFV+r5FelvFihO9l7xEeyjHXAvsBY7hdQL0IgH4yJQjMM
	 tIOvq8QgxUJeMc3rI+zrRAFNlMZx7R/Tu+0GDw3GzGZz+ILmmZUMiS4QFLmfBLCBvKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D51slvq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340F8606A320;
	Wed, 18 Nov 2026 16:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D51slvq0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7481F000C5;
	Wed, 18 Nov 2026 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018550;
	bh=iVjADsVXq/nJRA/RJyx0EWkpM7BEEpiEXrDueI5llMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D51slvq0AmiX/q7wDO+0qgTBCTgNp+RdrExOY/EBc5pKBNYooDcSaytVo80MG0afk
	 0i6UVJKr9B7wq1SFq2ifgB8nmBZWEBWlkRqh8l4rQch3mTPSeEZDI4D4TT+8Hc4G0v
	 zMpBzkoawTFLJZTlcW3BegiNdr86vZL7GJqcjLwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1280/2651] ASoC: rt711-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:42:00 +0100
Message-ID: <20261118150334.020984418@linuxfoundation.org>
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

[ Upstream commit ecc2fca6decefe27d8cf40a4c9815798eec24d30 ]

rt711_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt711_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt711_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-4-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index e292b28b029e9..f74b193c720d4 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -369,10 +369,8 @@ static void rt711_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt711_sdca_priv *rt711 = dev_get_drvdata(&slave->dev);
 
-	if (rt711->hw_init) {
-		cancel_delayed_work_sync(&rt711->jack_detect_work);
-		cancel_delayed_work_sync(&rt711->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt711->jack_detect_work);
+	cancel_delayed_work_sync(&rt711->jack_btn_check_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



