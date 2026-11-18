Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055840;
	b=LDP+hCCquhim3fliWh8xG8Ok6d1tmX9E4jiokST2AbLeJ6yHMLl+1gZOrIUdPvYpcMma
	 7a4uUkxJLvMjx202Y8QmYEJElnL9sDcEosK3VMFaVGwtrxLJoN48IhGBEqekbxyqEBnd1
	 IQSlszx9KlVKbCQGCzPMgIGxkdw79aB3jERC7WQ+3BhqvkDih5wpOPLOxcr1OStIG0dI5
	 M516ZsvjR+5aiCStBz+G+icJwkxitLI83rJgrnwwxgBEB+JCVBe+g4Sp8nmr2s0QwI/SZ
	 8dP1oYX/XlEh3I0mS8Z4RVCz+u8ALxTvHDoYdtoOOUNQ2SfTwsUNi6FYE8e2JfCFWCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5g33Sco1BNVE/f1JIj/gQlIgo5G5i7J+4uEdtrC1Y9s=;
	b=33RM5uPaz5ha7UqukHir46Q7mBAfCifKkCtC7l7c0OIzArZjA+AaMG9hHDL8XGszn9PT
	 PPBdzn+eCQbofaHDlWfWwLx/6DfuMG4ZYVcJQSTX5c9ejH1jsh+diwO+Vk5PGFIW2LQ5z
	 KNylXXZaaUYE4rc6hhU/u0mCKyOhr4XAJ21acNH2kKa0/3/91S/bVa2VddlYrk2Wo40fW
	 vQBpHj3dFh2iWTqxkOQwP2po8+0/1W4dA6wx02v6MldRSfC6xgkENzXA4oCIRToCKR7A6
	 wL1VB8HweN9Stt/NBy5KUPVCAgEA0WQaYYwCj7VKZxM6po2nO6F4005iVnFsb8U4tFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCLhdBBX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2822606A32A;
	Thu, 19 Nov 2026 02:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCLhdBBX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000811F000C4;
	Thu, 19 Nov 2026 02:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055840;
	bh=5g33Sco1BNVE/f1JIj/gQlIgo5G5i7J+4uEdtrC1Y9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCLhdBBXCKraUQb+gecf0E7FLphtZeIKKPulW49LF5qp1TIod4Kbq+ue/XT5g5EMC
	 f9/116uUqxytmG91GsTOe3EK/EbBGB8mW1RgnP86lkDiNSYjMQ6YROl79qpK/QhHW8
	 DE8kKxS3CKlapRsGl57PcdhwR6JShU13Sx9vs8lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1733/2214] ASoC: rt711-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:56:49 +0100
Message-ID: <20261118150121.005909257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



