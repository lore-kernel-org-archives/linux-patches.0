Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062147;
	b=NEsSefyj/M87gVhpPVX/JaQ4YTI3TjZlLDhh10gFiuh9CKDKNbQnTGQQAJ6sgNHJTWGR
	 /iQnGvqA9FLT5bSOpmpyqqbKpt+M7CL5q8nWm/ESlrinV54lzO3/fS3fA/iIWgglKU0ql
	 TLlqqpzdWXGjfoc/gm6wqctU98w9U2pkcdLbqCYW4ovpJZ6a5rqgbtfO40HG+qaYPVk9F
	 AwgK/2rnd8a4gqAzwQPgwRpWeZyHlwalpG+0429TWtFCTJ/M+jFIl8YNGP5gxA3EyoZZk
	 O7mYx+N/nPViGP/k5LIjqsPO22dFuYRWtTNhVbkzyurNdB/IJTRaWtgs/XgOOJ5fv0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KkTmWadQ6LtJ0oae/1rFlC/5dgIDIKnlK8XDW0xAp0k=;
	b=S1XVCTaLvfu7xN1ebx7EwP9hl94dQXkvpZE2cQvmGn+BVuOkKQK6+uOPqfzaEgGv8yv4
	 HbjCFJwiLaPFbaTGvXH0ibI5tM4WEtfdVhM0gCBjN8n5xu4tgNgnREaRZmT4pRxPCUkuj
	 sZl8zFP/8trnfZS8cryb4nRUnfFfdqshL1uPZQ+pXq+x2ZUhUgqdoytW4RYI9p7fq9kmF
	 wKKwwq0aqZXVNxcjznA1KLOd+82qGtXFeVmKFcT0R9I9ryVLhfzywanXMawh+BjWyh2c6
	 W875zhfeyufo5io6AhFGSxGms9qtjlkn4z20jXVQVW4bzAvMv/Smrg/i6JKKnpU8+kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QE5zi6is;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23356606A333;
	Sat,  7 Nov 2026 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QE5zi6is
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7B11F008A3;
	Sat,  7 Nov 2026 14:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062147;
	bh=KkTmWadQ6LtJ0oae/1rFlC/5dgIDIKnlK8XDW0xAp0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QE5zi6is69k1rfEILh7a1Vjp2fUFusarZGW8i4xgfghvt7SpoeOvfKd9kX2mdjCTq
	 Zx1b9L5MFw6Kfh19R8ep501wHf0oeZK5MHvUmh/wEwwtUang6PUa5qYKqCy3SK6OTu
	 CNVdo9TAmPvmYOMEUs5vF63825T8m/u5qH6AEObc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1110/1536] ASoC: pcm6240: do not free an unrequested IRQ
Date: Sat,  7 Nov 2026 08:52:06 -0500
Message-ID: <20261107135028.882763579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 995b96380ba5d98131acc162608da3538e1395d8 ]

The driver obtains an IRQ number from device tree but never requests an
IRQ handler for the PCM6240 device.  Removing the device must not pass
that number to free_irq().

Leave IRQ ownership to a matching request path if one is added later.

Fixes: 1324eafd37aa ("ASoc: PCM6240: Create PCM6240 Family driver code")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929095920.2092147-1-runyu.xiao@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm6240.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/pcm6240.c b/sound/soc/codecs/pcm6240.c
index e59bb77edf091..b2865b38f99b2 100644
--- a/sound/soc/codecs/pcm6240.c
+++ b/sound/soc/codecs/pcm6240.c
@@ -2035,8 +2035,6 @@ static const struct regmap_config pcmdevice_i2c_regmap = {
 
 static void pcmdevice_remove(struct pcmdevice_priv *pcm_dev)
 {
-	if (pcm_dev->irq)
-		free_irq(pcm_dev->irq, pcm_dev);
 	mutex_destroy(&pcm_dev->codec_lock);
 }
 
-- 
2.53.0



