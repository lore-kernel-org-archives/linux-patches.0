Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048580;
	b=vQbCdSI+vxUexMKm8ilCYnsmePYRJh19W+LeZBDhshmS5ITTUi+tdveu845D1SRL38vi
	 SbG9B1JVk/pJ+upe9ZMClEELn0JlzLdzsBM37PSGn3Wncn/eBJsBm+9o4/bgRfRzL84am
	 j9Ha/eSVuGktU2ujNBd0W7LjNd/P8jnJ4bB1gtG5ZFN15ZfsLVvdMd+yMwxuDyOlqA1Jk
	 rgKFOa+RVcWCwtYUYJdMisaVw7CgkkF5ko/pCGAARferaGDJdNU26JfdugwMEzt4YXIui
	 0RpVLtnbBlMm/1g1VpnSdFsBLBHG7nVYvKAPhhAkipnMglplSpy/onVSoLYqaz9wVfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=omL29TZI2WF/7p1dOZ69HXCse53EHF5jZZ2W1ijvQZQ=;
	b=jkBgKOmLoziT0HsMUPWm+Y92N5FveVnNuuQmNAgnTNAhsURnPeuT67vD/V/GzMD8LIrg
	 sdIecdVqMpBUu+2QlGVyLYdl4Eyk8+jlNntlrEKWowYRESPJXbnK7TIywDT7cj3/18dXF
	 oyqO3izCyVwxZEAnnrOT7LohD09P3gsvreLrzze2adVbqs2aTey3gg4cSFzEQy2TQqwVB
	 BgOuHfoutiUPQQ7a7BpN0rme5e6fvS7XGTmHYBi8TPtXcFxnzjbj4d66GBWtsA+c35u2M
	 V8tOwsQMMhzNpSkPmAAXI4grLezVRlW3VPXoZFBRLKDuGU7W24KudpwSoWt6zHbKIRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlFAcTQ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D772606A32F;
	Thu, 19 Nov 2026 00:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlFAcTQ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9601F000C4;
	Thu, 19 Nov 2026 00:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048580;
	bh=omL29TZI2WF/7p1dOZ69HXCse53EHF5jZZ2W1ijvQZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlFAcTQ1fVN4G+uH97hJAW8u+cXXsCRjW00xXN+4i33wRlYjdav+XVTJ4SZERmgP8
	 XnU6cLvQtthF+EJf3HYZDNHDFZ5A5Fr9cKJ3YKSM7lHxKgsvCFjw7XT9j3SKAylXfZ
	 9F5djHZZsmHy16tan/mRfGVYUb183MtZJVDvSoWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2046/2857] ASoC: nau8540: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:20 +0100
Message-ID: <20261118150315.085105201@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0bf2b3411537e8e4d9c03702646a9fc87198d4b1 ]

nau8540_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: c1644e3de45d ("ASoC: nau8540: new codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-6-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8540.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/nau8540.c b/sound/soc/codecs/nau8540.c
index 0626d5694c224..f68edefd321f0 100644
--- a/sound/soc/codecs/nau8540.c
+++ b/sound/soc/codecs/nau8540.c
@@ -804,9 +804,7 @@ static int __maybe_unused nau8540_resume(struct snd_soc_component *component)
 	struct nau8540 *nau8540 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(nau8540->regmap, false);
-	regcache_sync(nau8540->regmap);
-
-	return 0;
+	return regcache_sync(nau8540->regmap);
 }
 
 static const struct snd_soc_component_driver nau8540_component_driver = {
-- 
2.53.0



