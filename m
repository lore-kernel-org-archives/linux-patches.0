Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030053;
	b=C+mq2Onp2Tjqpe4Qb3sKyOO7hVwzZNqERYHYyQxlHiLJHLgexopHPR79V5f3blDY7VCJ
	 lzBVQogydjml/ZSuWkBhtVT/zyBJPcJkQz3KlgkktVlPjdjog1pdfxFMabKT2gahPjHYL
	 0UyY6T2cewN5dPyADliDsLlGQJxwoY1KobUm6wsLCtCK06fy8e+LE8CyGMVvHX6XqjYk5
	 UP+mHrzXO/cWeTTMwg8k8WPlP9Aoaqu8er/SlS9T3vKAcwUVTv0Q1Qn2sxUEzRBD5MVPe
	 liGI0U1oEgfW+Hb0LuxBNSRmtJxbs8nDuBDX5mu2i0/hVvfBF1KBXNKM5y629eVmKXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BAEmS1/v/6jHsCw66W4X2QOKTeDKzfe6aihYO9vNyNM=;
	b=IDgdCx2VxVpOgL67AIv5g2w3Yxh7QWzS8gclOpXMJAiRc/r7ZTamwQQ7Qo9j48EKWVPQ
	 5b+OnGib0xhIjvvGlsKWLhV8muozPZ7yU5EX4+PuSyvnPHMlXMw0pPYSXqcL8d4VHEOz3
	 ocaI+l4EYIg71xF3iH+v4w7GgBbGw8dxw2hcRdoVK92LC5OuSA56rQhbn1qPWbBu/bs/A
	 aidka0TjbO1cwgTPEidO+P3KpNijFCmzyx8V3toKquCrCHLAbiQNS3omXbiOrM1EPdjQ1
	 6S05nTMH9l/Ai6k7dU058JXSaI/KtlGzW2RmkrI+Vqi0BUmIoF7toyWa9zfTfjMhVzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsheuZvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE56360A3825;
	Wed, 18 Nov 2026 19:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsheuZvR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1765C1F000C9;
	Wed, 18 Nov 2026 19:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030053;
	bh=BAEmS1/v/6jHsCw66W4X2QOKTeDKzfe6aihYO9vNyNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsheuZvRPlowFy/8zYFsS8IzCZ39/+BLlEwY/ORgCrZil3r3a4V80dt1YocoNnlzA
	 LmP2oeyFQmZM47ewbNVOabRmbjwAMSjBZFjVBkl8Mla7BWPVBYKrVqZqqBMBIpCHqZ
	 MD0eAwIfWen6pmJdI6joYmSItNoySxW03gBzi2UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0569/1756] ASoC: rt1016: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:56 +0100
Message-ID: <20261118150031.718267578@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 98ace05793c7b80a9f49d92b78fcc88e0970f8e4 ]

rt1016_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 79a4b670b4b4 ("ASoC: rt1016: Add the rt1016 support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-8-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1016.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1016.c b/sound/soc/codecs/rt1016.c
index fed4da23cba23..587c12b154a97 100644
--- a/sound/soc/codecs/rt1016.c
+++ b/sound/soc/codecs/rt1016.c
@@ -570,9 +570,7 @@ static int rt1016_resume(struct snd_soc_component *component)
 	struct rt1016_priv *rt1016 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1016->regmap, false);
-	regcache_sync(rt1016->regmap);
-
-	return 0;
+	return regcache_sync(rt1016->regmap);
 }
 #else
 #define rt1016_suspend NULL
-- 
2.53.0



