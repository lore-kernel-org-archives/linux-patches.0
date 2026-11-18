Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030820;
	b=YJGhl9emCS2hMAJARGg61fK8972ZxKkQPyKh4DJ4K9ivp5FVg+sTsHgyO5Nl37xrIUAO
	 SAugyLnElyRv2H0lvGLpVFVzEsrwKaHxa0mcqXFYoTvUapNDt2U3Oe/zVVmrux28yWSLk
	 7MGHDJeSXBPUfAdc+oiI6P2+yTvLfNwWL0P/2/5lE9Jo4Ny+wPPcTsxq9m/dghgYnamTv
	 HrLFccqjJFc5K5OVWoLISv2l8JYMeLeC2RPICfZKZTd4TGbWUaoVhdXFd8FODqK8yNg3e
	 6akpXUn+vLXTIxl+IEb4Dd3abvD7c4qPy5n2isnbnX3Oy+5sELMD6yDbgYF7zlKZRTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JuZ6O/ysJM9B2QdgyLdiGf0vPYlXHXiG1vlR8m7Y/ZY=;
	b=3JuYz4zX1+AGWwqY2mtjiAncuE/WIuYhUiozWjLESFuiqiiH7AGRI6FcYQiEX5Uds6/U
	 MP7++eaCsgvMXIH2Bu4q9/Npt/EngQCfRRIq5wi+oWsP07t9BgnGxmzioERRqPh6oRPGe
	 CU4Swhffs1KvA0iR0VreKU69fSNt0QxroJVqNrmL387l/EilaG7RTKRBjrQEsZxtE9P5C
	 UH2A4QC9mR24ujIUQJtSB+eUd0z+qv5LoiGIo9hpLn98RlZZ9zAuA3hGNUrcGlNYQXrXW
	 7uB802keCzu08fuEAMBly0w8g2/6imMhrSX6PUuyWJxamy8Y+W+aPTGLXlVI+fMo4IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAuEB3oh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3DB606A92E;
	Wed, 18 Nov 2026 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAuEB3oh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2441F000C4;
	Wed, 18 Nov 2026 19:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030820;
	bh=JuZ6O/ysJM9B2QdgyLdiGf0vPYlXHXiG1vlR8m7Y/ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAuEB3oh7pApwQHvskaoVR1Efmm2GgIl7dguwf2F3xTKRGccab2eDDjBKeEyfQitR
	 Ofs0w134M+xv0BkyWSqjzcW1KD4Kw8mai3aoiTzO03daQ4UOQakEeP+ptdM4bFD47w
	 V8db33cXQjuXSoXRiAehxj0R84xmhrioYGAoUb0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0841/1756] ASoC: rt711-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:49:28 +0100
Message-ID: <20261118150042.922396788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dfda6bb5c6f8b..f2e662c210d2d 100644
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



