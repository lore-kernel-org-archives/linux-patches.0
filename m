Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015831;
	b=4OV5vX7p15oeWhBMI3pqNJ+trtv2u7WdvVIoRIotxFf8EDmSM2TzaXMdPeXCx3b3fi5B
	 BrfxTD4cpxG1pq/YUIym3NXX1yt6u3Q7WH4FaKq1s0dLaadclfEcpWkCX/6dZNTTaS4D+
	 hq7O+0pfu7OZtMSm+nsk1klbho1sFh8C7qiyOLvIjg8cACZO5kHGWDgyLgeXDANYhQgdY
	 8XhqBt17EmcRv2IDYlbOV/D8IV4cFKU+RqxTLpNobb8lMgA7On6BtsSln8PUJ5s1su867
	 KwtO7NjTPhqCMN4oxskDYjsRFvyNCpdJF+9hneW/Nyc+p2PUrvcBUSCpciBuIeaXexA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/YHzInVqNnYJiO5BLtedYH7yYsJsEOCGOaq6ylf7w2c=;
	b=2BqhEgtAoQPC0WBMkCIrN1IPkJYwwZvarg1PTmdIM9uEw5ocBofkthOpq6+QzRgn5rQy
	 /msVoNTvvq+GEhnFiYZIdl3lhSYrL9aus4RxOQK9Ykv4otX/TwOtF6lVXmNCzLExMradj
	 d2zu9NYTyj0MPyKF4qGoR+TYtOnglDeXV0OQPRArJ9BpSohW4JMvt6LLjYieC5O59JvbA
	 aGrPuoX4indRrIaZzSKeT7je/iVt0NEF5rzXK0dw8fEVDXQgP5uv7ALdffgme7iel0PPq
	 nJ56sR2QJzPyqqUx+VnTg64/b5c+ffp4T4oA4AklO5whprUIjbHL2iqfRuvStLFrxFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nP5APk2c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE2E60A2636;
	Wed, 18 Nov 2026 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nP5APk2c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35FB1F000C4;
	Wed, 18 Nov 2026 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015831;
	bh=/YHzInVqNnYJiO5BLtedYH7yYsJsEOCGOaq6ylf7w2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nP5APk2cHc3a/gHFmZIBEC32IMwMM/c6aQRU1W/CnNjY9/1y6DBILa76RA339moX5
	 H6IWA0rYY/a6+EBVHlK3qLYctEimzadCzfyfg8/Hs+d62IYbjBD1RGh5lKBmRfq02Z
	 AsRV1zRzqCPjekWto0hG7kTt0wQ3ly/TYUJSXE5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0313/2651] ASoC: rt1320: avoid re-initialize in advanced mode
Date: Wed, 18 Nov 2026 15:25:53 +0100
Message-ID: <20261118150259.157266904@linuxfoundation.org>
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 04c3ee0f5d158f6e2027c7ef617044cb649ab4ab ]

On some machines, speaker protection is enabled.
We call this advanced mode, which loads the DSP firmware and changes settings
based on the basic mode, including blind writes.
The amplifier can retain the advanced mode settings until a POR or power loss occurs.
Therefore, the driver does not need to switch from basic mode to advanced mode
when the system performs a warm reboot.
We only need to check the function_status to determine
whether the system has undergone a cold or warm reboot.

Fixes: 9b30521074f0 ("ASoC: rt1320: run the initialisation preset on the first hardware init")
Signed-off-by: Shuming Fan <shumingf@realtek.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260909091806.872977-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1320-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index 72af413306fa9..444a91755be98 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -2470,7 +2470,7 @@ static int rt1320_io_init(struct device *dev, struct sdw_slave *slave)
 	dev_dbg(dev, "%s amp func_status=0x%x\n", __func__, amp_func_status);
 
 	/* initialization write */
-	if ((amp_func_status & FUNCTION_NEEDS_INITIALIZATION) || !rt1320->first_hw_init) {
+	if ((amp_func_status & FUNCTION_NEEDS_INITIALIZATION)) {
 		switch (rt1320->dev_id) {
 		case RT1320_DEV_ID:
 			if (rt1320->version_id < RT1320_VC)
-- 
2.53.0



