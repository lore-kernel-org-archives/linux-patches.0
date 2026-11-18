Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025418;
	b=1OV9gOnfiLnDAM1pXP4rExsp3g4ZGaG+Y1Na+C8PMUn3h8wmdTs3tt7KZoLH1UTew+KG
	 NN+YkJZXyY0YerTsElV7OlL34gOMKPjOL1xhTumqOT/J6PtN5EKQBJq2MnU2jXKrQJRwD
	 qY2yw7d64W9M6PP9HKlA82MGkuwO98GFXyv+PAFBOTHl4HUGt6LVHMKnMI7/zh0eDbsfE
	 +SCe2iuvCAHD0QAdf5F8Wnl8fievQjvXS7qG/HvF+/JeOUiVQkjQC6HYz2RuCEIXmv5mE
	 19wZ/VJ7SRztfwte6/UASY6goHseLTG9gHTQs0rCvoGbVtPiR83V0OoBznIyDvpfmVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ubHARC92INwXaPE5r9HEPOUn+EAG8FROS0h3WIvKwnE=;
	b=abOIhHORX4YZIcHVzaRZOJwoiXP+mLFvn2PpWjXiHSGMjmsjHqM3f5hIQx5r02zAJ/ee
	 j/gQBeeGKhEcHXr5f+Z3bipGJz3k72rS2dUGrJPYBj+yR7Ua2p//UWHs3IZ6nNSgEviEd
	 SZw2ZWXrxM6b9VScWtaCKvD0gfDS83PkADHZc1KnqBPsvWOHS3ZcYj960aidJ4/5Yn56X
	 x0Rxqj451XZwaE9LAogBPqgSI7t0wc297w1VCU2Wf6XtTt8wCBaw+QQtoSk7dNHju+yfO
	 yh7uZR0TIq0BSUhB0XKHlbINXhra5ScI6dL09WoyXrydmCUqNhrPSbLlP7FUdrZ/6tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lV57sWA0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F5F606A31C;
	Wed, 18 Nov 2026 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lV57sWA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC2B1F000C4;
	Wed, 18 Nov 2026 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025418;
	bh=ubHARC92INwXaPE5r9HEPOUn+EAG8FROS0h3WIvKwnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lV57sWA0LZ3MyAGgTVNQ4qEdbwcNkaN/tmLKHIT6rjkrJy5xXbfHkCOHyfGuYeX3e
	 64QhNhzdPS0JIp3cH+qa09Vy1GgEjBfTJ+hzAseBj/YDxXWSTUKfzvsk3Wj0ag7Pl/
	 nW6NbJitLuIbvho169a4oIukZm1lwM9aqjQCxczU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1073/2151] ASoC: rt722-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:46:48 +0100
Message-ID: <20261118150201.370122811@linuxfoundation.org>
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

[ Upstream commit 9d29132d81a7f269177be676c3b81cc575899975 ]

rt722_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt722_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt722_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 7f5d6036ca00 ("ASoC: rt722-sdca: Add RT722 SDCA driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-7-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index 5ea40c1b159a8..ac33830598c84 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -430,10 +430,8 @@ static int rt722_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt722_sdca_priv *rt722 = dev_get_drvdata(&slave->dev);
 
-	if (rt722->hw_init) {
-		cancel_delayed_work_sync(&rt722->jack_detect_work);
-		cancel_delayed_work_sync(&rt722->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt722->jack_detect_work);
+	cancel_delayed_work_sync(&rt722->jack_btn_check_work);
 
 	if (rt722->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



