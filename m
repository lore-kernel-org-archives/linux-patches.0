Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060866;
	b=bH073Wslv3J0JuVooOf5N3FIx9cRODbi0LtGm8gXOCMr0iZFtl1vnML8t9jcar4tCxcc
	 0zrqsSGUslY/YpKIg6h8tUxn+kIjDiNc7W3toaMXoLofl+ymiAtzoxC1u38Up+8TUJsTJ
	 c8P8ZkfknJRVSXP3Jc+mqsa0o/leVpfQU4mF+bqYl/5zTg4clzWhHp+B3c+xSr8DwU1IB
	 7sS7SRYouSDTMMd1l1/ApBz7jcOnAPCa5taeg9SZXv13EuMuaLAj9tvpUytsdNO8A9On8
	 3DwXi1WNavJ8S3k0RvgB89LRWok8ij+DuKWiCbEEXoQ+Qrp8YHameZELAxziPVZCcOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNHssTfTldj/iPSvk6QB0GTq24J8ZXvBHRQ/fgmpX1A=;
	b=zlSZTThV+ylCbE6OPSD0z5EKocL5ZExyKD3XQgTilPkvZeSVGqRyYOMMb4HkhrFVpGv6
	 fnJtgGzz9a+Di7hWpycZnzcpx2If1YD2l0gwQyB9QCx01cSNapxABcCKb3vrfhHcNHMM+
	 zP7knGY3wRxKngjb8Y2Ahr/1bu525de7xIGzXYFO0EmS1wdx8ieH+9PgRm9MEY49X9+ou
	 7WR7drjzgHvmNgA8FH9OhAnMHWk4+D4h7LFWJHE8aVqz6Oia9FFFuFyDtW2HFP+cOc2xp
	 BCmfGLDojJdpT8z15GwEiINGNZsPZWRjwi0Zs9PxzRKkVlwBg0fz38tvBkYoAum1A/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evpxREf0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401A6606A320;
	Thu, 19 Nov 2026 04:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evpxREf0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E08C1F000C4;
	Thu, 19 Nov 2026 04:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060866;
	bh=DNHssTfTldj/iPSvk6QB0GTq24J8ZXvBHRQ/fgmpX1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evpxREf0LAkO+DZlme515kDfp3ZTDMkQ4MANEcS0ISrAA6UwZ0eJ8WI4yVvaVOKbx
	 ZEzhhIlliMiunpwarMxVxKMnrXXELQErDvwktQC+oFTGroW9OcXJ74eCNJwcp15F2q
	 aOcYLh0dLlgewjCsupFwbzz5+RDWpnAbyivWO48E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1352/1848] ASoC: rt5665: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:30 +0100
Message-ID: <20261118150016.238068238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 9f2933d9a437302d5ae32eb9022efef049d8ab22 ]

rt5665_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 33ada14a26c8 ("ASoC: add rt5665 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-15-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5665.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5665.c b/sound/soc/codecs/rt5665.c
index 8b73c2d7f1f10..5ca706a15d6fa 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4491,9 +4491,7 @@ static int rt5665_resume(struct snd_soc_component *component)
 	struct rt5665_priv *rt5665 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5665->regmap, false);
-	regcache_sync(rt5665->regmap);
-
-	return 0;
+	return regcache_sync(rt5665->regmap);
 }
 #else
 #define rt5665_suspend NULL
-- 
2.53.0



