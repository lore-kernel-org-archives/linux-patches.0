Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019244;
	b=i38fVk9X+MRC4iR6dFOHHiXSNzcAx1zG1+wX7JG89Ts26BI2EzrQaQOK/QNvZXdTKbvs
	 Q7AdvhGms+4u69AjnjSLumpjZ2UeCvsd/JqaaGJnBbIa7m1OtYMwFHWZ7A4bCMfWfG7v1
	 KkqeUI+LabMiRbBvfZCX4/X2kK8DRTQFMi8/24FxUzBZqgECQuBetpeFn5fKeFsZqCnPN
	 Oq3iQNr9DlCt+X2fE0i/s0TlRfdIR4g8PQMX3l6QqWBLs5ovuf9kkEzNvfubP4w2cyPJY
	 aU8jJvMdNBaRDLDzpyGcnRh83l/g1bt5tSBs1my08yxSygTnj2gx9bmsDXAcoEb8gSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6cTg5ICb3P5Ca0KYcjXL3gwCWdRztSmtTRWH1O75SQw=;
	b=5CKX/8xbxglUcoT5PaHj2daw4bSUQu/l9Cb8rXAQk60qVR2l9vkmZu1cR8Ol9Jrz3gFz
	 CuMyv44ukWrWBa22dG8RY08M5a8opdT/9cJMvwp4srrFlKjAiQCPfJ8linMxYoVQmbQWl
	 6jp6+yXO8Qoa6b0+SHWWraI0Q4EWjUze/GNTIRW18h1cJTrewXseesYDG6G75CV7raISH
	 gxwyXw0zP16eyb+qjEGREHnEL8kv3P41EmBGAVBAz+499ZKuLllXqPKha9ee7+YNrts64
	 1IGAofpyfFFNLZY9YtxIfzE3YcxWQo5hThjk4ODoKlrFN3P+UvYHDke8e8K/x0Xa1JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keQLQX4Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070D060A2618;
	Wed, 18 Nov 2026 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keQLQX4Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2361F000C4;
	Wed, 18 Nov 2026 16:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019243;
	bh=6cTg5ICb3P5Ca0KYcjXL3gwCWdRztSmtTRWH1O75SQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keQLQX4Ylb9Dw7HX3vUQWBzeYqL8Os4Mvj+A6WYhTQ5QJnVVx6U15qw24ZMaEKWEv
	 FVLrwG1/vUdnO+N+b4UptWl9GLrPQ3QHgzp1etW07gMrcGBSSJpWlZvwY9b5XiZyJ+
	 D3YqprhZrDyMStP67ZDaIC4oEpxWuOJQuTriQEbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1486/2651] ASoC: rockchip: rockchip_sai: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:45:26 +0100
Message-ID: <20261118150341.515945794@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 39205bb7ed4fe74f0b5df58d9b6529ac2690303f ]

rockchip_sai_set_fmt() calls pm_runtime_get_sync() before accessing
hardware registers, but ignores its return value.
If the runtime resume fails, the function continues to perform register
accesses while the device state is undefined.
Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() and
return early on failure to avoid unpowered register accesses.

Fixes: cc78d1eaabad ("ASoC: rockchip: add Serial Audio Interface (SAI) driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903112739.373621-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_sai.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_sai.c b/sound/soc/rockchip/rockchip_sai.c
index 30b5e71d09375..264a99e618a5f 100644
--- a/sound/soc/rockchip/rockchip_sai.c
+++ b/sound/soc/rockchip/rockchip_sai.c
@@ -487,7 +487,9 @@ static int rockchip_sai_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	unsigned long flags;
 	int ret = 0;
 
-	pm_runtime_get_sync(dai->dev);
+	ret = pm_runtime_resume_and_get(dai->dev);
+	if (ret)
+		return ret;
 
 	mask = SAI_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
-- 
2.53.0



