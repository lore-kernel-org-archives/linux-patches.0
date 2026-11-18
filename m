Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018541;
	b=FKAMC+G0xl80I/DB0XJSocuuytdq11Cf3Jr11MptFp+hn7xqCzqSRJvBHasrRmlFxhcZ
	 jxZwQXIjWX6uvwCyDLivOkSzKVwh2VL6dRSUmf3Ns8okQlfk/TVDZvTRHisXzNpOCWPfp
	 HG6Ortg6um1B/+YrNwHx3aRFMerJeSh141bYIjXGGMA4UKYdc5Oe7BH5w5JQMpVCZ35bW
	 70oJ/ZP1lcg+EK3ZCyQTIFDRUEkHu8o06JdoEUzwSiSjhEyyEQIuIF3T45Kdin00XGN5I
	 ZCDcuqo/9BYjemXhMsSVGGO6cMWtWtDaBaAyWk9Y+MZbgRwaCwvbns65KHTqsHP6Ckg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KK8ANL4KgdV+7yf4c43C0GDT/O55W5XBn7qMR+F4OB4=;
	b=yrFMaryqdjQfdxbqglAbLjHhXKEaDQkg/1m1NkrE+pzTbZQVXUiO6hPXjDS0vS3TIfMe
	 6gYK/fRYSoPNgeaSBUOAEnnaJQ4y04klcssRodf6c57fGpjkuRoZnwfec+vOSjpDK6A9G
	 eo3Rqbb7dIE6VOaUWhLcuIA1iRKaJ6+8kB1S8zkBCOtBI1zDH7obu87i2DpxA8WbVB6Dr
	 uTG5Iq5CZYpkc5lw5HEYDjZJ1U9mE23zeiqAZwKoGfIrgqzqUEYwiv0yn5PERBvaC15VV
	 saTKO4QsJeDh8HXDjutrAYXzXoFwZCTTeTB+joqIpKjP8fT6Xp+747VcjwcDhIe/z5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ykjVFTlo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A96606A320;
	Wed, 18 Nov 2026 16:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ykjVFTlo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088D71F000C4;
	Wed, 18 Nov 2026 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018541;
	bh=KK8ANL4KgdV+7yf4c43C0GDT/O55W5XBn7qMR+F4OB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykjVFTloKO+J9MwhRTte7mG3xiziLxuuTqlCT+HkUSCHQben1aCKyBbEyOqDUFK1b
	 6J4FjBVEJrgV1y1YN9JRgeE84hOGFXqjGQgKhZRJXD1QddBKw9OrEqF3Vlr8h06FiY
	 MDEp5k9qgnZpgrIQsj6rpwcNc+SG7m/IexOV/qJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1278/2651] ASoC: rt5682-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:41:58 +0100
Message-ID: <20261118150333.954882747@linuxfoundation.org>
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

[ Upstream commit 9a98f7e955d35e0831fb179e88e98cf9bc0e001e ]

rt5682_sdw_remove() cancels jack_detect_work only when hw_init is true.
rt5682_update_status() clears hw_init when the SoundWire slave becomes
unattached, but jack_detect_work may already have been queued by
rt5682_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work object is initialized during probe, so cancel it unconditionally
instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-2-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 23c7d2a9dbeeb..5f2897c58ad7d 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -704,8 +704,7 @@ static void rt5682_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt5682_priv *rt5682 = dev_get_drvdata(&slave->dev);
 
-	if (rt5682->hw_init)
-		cancel_delayed_work_sync(&rt5682->jack_detect_work);
+	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 
 	pm_runtime_disable(&slave->dev);
 }
-- 
2.53.0



