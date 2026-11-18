Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017174;
	b=tEksp/NHsBJOUn1UMnIiS5skqTn5bisCEYu2HH84j0Fx8daOk9x6JJuFHeQRq+wzDCKu
	 1y/3URQ1gRxAasgKhQDYzUJyggaqE1SuFub4mach2ElsorRgIC1gHAp2MKAbTCDNBM0DD
	 vofY3Ri2lnEPOGc7oGHCwiNOLoVAFpSdnmMilI+VYH7uQ4y220Jy93CSJVjquKvqmhPRR
	 xSLg3qtcQJDCvtWU57qhZx3rB4RmsmfY1REWpWfuMUuXUIrsit2bpWzCQAbQSMDCO8CsM
	 mPcbf361nnKX6J8KvvvSqwBIh1jJwiRlnkL6RTkgFIPAU8gCrQPm4vfL1p4AAf5Frag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nKuEMBEN0TAAacFrgOFU3RvhwABaPgGjf6xGkAwgazY=;
	b=GJkBgsaR+dH57W1PUSdApSdLBA6vl9tAy6knXee/5W1xvmXYCPNlEJobSSCV6iqws5S6
	 rYYYIG1GVfFuDn3wm/pLaKm6+Wu70KwlIzAsWfcmYpDGEvR1QGp9DsfQ90M4zyF+vkMVV
	 BbdQ53h4hCaWZzmWsMk7Bld1GUtt6PVhuwxZjZRlwm486iEfjqS84GxcgSWygMMYjIlg2
	 JfHp+QwJHokWEOmavUpuj7S2WJ5ikyAd5b/Ezxn915hfYOs2cyQcZkBIoyPTYDhrip+MB
	 T1DpN2QINXBplDfJBRkKLd/94U7k/ufVQKMykOBy8yMXyrWSUa1IU3CGmvF42tcIJmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9PQ3szs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17719606A320;
	Wed, 18 Nov 2026 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9PQ3szs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663081F000C4;
	Wed, 18 Nov 2026 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017173;
	bh=nKuEMBEN0TAAacFrgOFU3RvhwABaPgGjf6xGkAwgazY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9PQ3szs1jM6MCq2jFFD3gi+iWRRIUwNT/7AXf/6W8nMDCrelPylf5myJen0T6kiB
	 J3cFVnTtPz4xWgKcas+gRxZ573yap7/d6FR7GYBZ778CrRuv3G103udsjEs45qXAbN
	 oAPyycYhCTd+k3lWjxDlj9KYKF4SrDtCEUcTdJk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0791/2651] ASoC: ak4642: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:51 +0100
Message-ID: <20261118150316.361299307@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7142c34ed92fddca7038787b8695d22c661dc6ec ]

ak4642_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: a3a83d9a7cb0 ("ASoC: Add ak4642/ak4643 codec support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-3-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4642.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 08ec2035b2705..37ac298835d64 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -533,8 +533,7 @@ static int ak4642_resume(struct snd_soc_component *component)
 	struct regmap *regmap = dev_get_regmap(component->dev, NULL);
 
 	regcache_cache_only(regmap, false);
-	regcache_sync(regmap);
-	return 0;
+	return regcache_sync(regmap);
 }
 static int ak4642_probe(struct snd_soc_component *component)
 {
-- 
2.53.0



