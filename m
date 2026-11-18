Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048583;
	b=UpzfXsabsVbirw3HpjkdiTn8nOx8BeM4z2bpXSOTU8E9tTBe0t2ipfUKHV7/luRG6JBG
	 xjaJBPNXI5sDPI8QsPFAcznAzFxcw/hhm/vPTW/7+4Eql8vfy+1SLxadF1b5XiIPLIPJr
	 PI6yvoCt+KIUXanf0l1DzAJ3w1qYW3yhVq8cNWzdgkC3g07KBnnreMcLfYqXFa0DPxBMJ
	 cCjJFShuQq3BXCyByNIVLQTtrfzN2S3gQljpMpkLfrCFRL2lyX3HXEgLzUr4piEoRRIQr
	 UQfhrWarCNi3jPDeRG6tIwR8v5VOSiEfPRla+qn/Z1iPjw4uWs8/bq9/EXsURS5fUyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q6/KKM0Mb/vAW7WngIJQtjRKwb0tH+nZyHfOL7x4Kag=;
	b=KsvU+RSMFbNGdYVfmFRQvYktOeN2+KckXh8Y3IKKRvXE/QMDuOeG8MmprVgHUHdQoYSn
	 1KaB3QvmLqHopwO9aHafaobQu/xRlj8pAkVO2NmLxx6GTc8xEhncv+ALktfuZKXY2Bfye
	 Ax2kLT54hXy0UXZ45yOGUM7jiNjyQPtDWgEt9fXgaBmXgDSRHVYvPr0ewSZ/pP1tdMhTk
	 nZuBiakSwZOMgYGrWADjGj6xIfwtt5SbIQzQQs27PIIRR/RBordYgGhhB6A5yoxg7HQxo
	 IA3/VcK/x/qihGRfvNtekPsmxl/rH9gKaFWHhXH0w4qbIveARV7UNfO6rGqhOs0L9DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ub0P1rrq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4855C606A325;
	Thu, 19 Nov 2026 00:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ub0P1rrq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16EF1F000C4;
	Thu, 19 Nov 2026 00:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048583;
	bh=Q6/KKM0Mb/vAW7WngIJQtjRKwb0tH+nZyHfOL7x4Kag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ub0P1rrqI8AHJMjmejvFw+Zy16RlLFI9XQXlGdQrfv27QAf2gb8y0Bp1dhYguaney
	 gaOWdKWenxt7SQselVUWd1OUbsPVYtn8Ra5nuLrlv0PJHZ+hZndI7r/K7PKT4TjYBg
	 G6mpExnlHDcmWr8ccThzD654wvSPflacxIhgAP0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2047/2857] ASoC: rt1011: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:21 +0100
Message-ID: <20261118150315.123420728@linuxfoundation.org>
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

[ Upstream commit 432734a00bfae17baeff1a83b61bfc9c2ab20c12 ]

rt1011_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d6e65bb7ff0d ("ASoC: rt1011: Add RT1011 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-7-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1011.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1011.c b/sound/soc/codecs/rt1011.c
index c1568216126ef..2494c1c13b3a8 100644
--- a/sound/soc/codecs/rt1011.c
+++ b/sound/soc/codecs/rt1011.c
@@ -2101,9 +2101,7 @@ static int rt1011_resume(struct snd_soc_component *component)
 	struct rt1011_priv *rt1011 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1011->regmap, false);
-	regcache_sync(rt1011->regmap);
-
-	return 0;
+	return regcache_sync(rt1011->regmap);
 }
 #else
 #define rt1011_suspend NULL
-- 
2.53.0



