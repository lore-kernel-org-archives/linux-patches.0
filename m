Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040755;
	b=TrFFQuwx6yF8y+2dx4gndkxji0UCLQSmIwK5E1Ozyca4nRhvVn6jDYI+vZ4CTZfb5HfQ
	 qJ+asH2cidCcAJoSMDExKBytgrNgBqDJ3GvsQXYvgWopLz8AmcaZdVQYduj57xg4z1f2e
	 gsIk08p1t4De18HT3l300FqHi/edFnilG6ns2mAwokhKlujTOAK+Ap4aWieANxjl20Koe
	 8/J+T3j5R+D2lPFI/Ljw941hZQ9jr/G1YXGvW+odxU5ggMEL/1HB8WBZvHfUZFoQOiAUS
	 Cj/ECka8f6FXLJcXR+nZXIXv4fOYtOA/qkOIOmu3mgYtmD8HCm9+r9Mdem0wagq9B9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Id9MRS6+vnLs+nESchT5m1eIjYUjp/pXZT3OLebZzi8=;
	b=HkmoV6jrsOtRqG4dY4QDyw3Chzp1/MfYFKmUG1K/ou43jFeNN6GCYb0klShmxun3dEno
	 qnK1ZvkxdMxpPnVRjK6OHQ+4DRCj9U8l2Da0pfHOKsUM7pnr5fbTyimroQ00HsKtCvoVC
	 t/R8vbZlGn1yMWOeImDzzLr5uArn5zZFOH2WqDRu63KLCMgdUrYJJNS0Gm/iSYk1ZBuzO
	 Xn3l1Cukle7E+/gsdCShxDD0VzKeMs6YeqiRE0tDm6H5RRYNZfWRnmzhZxRk7Kzc4jiHZ
	 xV4JtPBkmnmrR7o6XC1MsTwj0qMXfzG1TO5fWq6cTtyAqAX4q6VHfBLHmMUSTzPEfjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1MfYhU7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25E4606A325;
	Wed, 18 Nov 2026 22:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1MfYhU7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176CF1F000C4;
	Wed, 18 Nov 2026 22:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040755;
	bh=Id9MRS6+vnLs+nESchT5m1eIjYUjp/pXZT3OLebZzi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1MfYhU7xgZaDeGDwZWXekyqZyNamBH6is/L9zcIujmLuIxpE0JIFsPChh6fs+luf
	 CfBZjLeJPUNXwM1JjB8uWnZrtWfv4eEVX0F+12u6tjvDxyzIe3YAG14EJvasShZX71
	 sJ+V+qDbIu15BBKKhB7h7AB09iP24ayZIYQCG0p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2569/3318] ASoC: rt712-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:53:11 +0100
Message-ID: <20261118150438.306381284@linuxfoundation.org>
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

[ Upstream commit c7d07df95ee7ce7859e6c873a76d19ea9c64b6fd ]

rt712_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt712_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt712_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 6c39710da75c ("ASoC: rt712-sdca: Add RT712 SDCA driver for Jack and Amp topology")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-5-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca-sdw.c b/sound/soc/codecs/rt712-sdca-sdw.c
index ba877432cea61..11c35ee334ad8 100644
--- a/sound/soc/codecs/rt712-sdca-sdw.c
+++ b/sound/soc/codecs/rt712-sdca-sdw.c
@@ -358,10 +358,8 @@ static int rt712_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt712_sdca_priv *rt712 = dev_get_drvdata(&slave->dev);
 
-	if (rt712->hw_init) {
-		cancel_delayed_work_sync(&rt712->jack_detect_work);
-		cancel_delayed_work_sync(&rt712->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt712->jack_detect_work);
+	cancel_delayed_work_sync(&rt712->jack_btn_check_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



