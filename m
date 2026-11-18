Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049685;
	b=sHfMQzrsSTYiB5n2wznI5oLBNxizwUwxrR+Y7bUu+Z+eJbeSLlHvd6mxA9HHXGMuO53F
	 j8b08Vr+6KwmhduuKmqiDAzNwjkynYEIexIdWB+3T5HzOfbzFh3WSwwwp5w05V0MMZ/LG
	 rLyX+D8EWDujmXF3uQa2T6nIJdQ9e+BKm/YxttOWNbMZ3wVPctofcgJXIHg6sD29+dNb5
	 AL5OWg5SEo4HM7IQremVwq7liV1R7dGZwHVEZfgugw/FT+NjU2oPgjdfTdBzaSkLuVtHC
	 EGlMolRTsLV6G3CnOW3Wy4jOKLiZrqywY52c42HKATgvnV/mSsVjBgP3FHRiLBQz4yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5onL+PlPuk13BWDSMVlSV48/QxyVlAGCdTjuznarBM=;
	b=CPj/Uul5BIhVK5JETApUjNPbq5MncUIGLmG1j4GdPPWSDfO9rZtJqnJTYGiuzswP5Y62
	 RPVT4+hy52ub4lD9ggBTR/HVl0R13+r5/SqU6lYRaSyorwxStBqysIVtTwp/wXiZtVTkD
	 sHQy1aPeiRN/SAg7Z2GpyxIb4i/q6q1lpXk5Q+q5IGc2hJ/clDBa610a2iuTd/8oPwIrB
	 KfvkcR0OPIZDrMSYFIZBviiUMHwLOnr612sQSyyInhzxprtBVuJu8H80awbK3YLzGPv8v
	 8g6dGD6z3kvpe3UnreqVoJbTLKuJl0sjzDMSVdjhPWkfjbBGnad+uJ6gf6WE8RQPQ3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4c30ODf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ABA606A337;
	Thu, 19 Nov 2026 00:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4c30ODf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37321F000C4;
	Thu, 19 Nov 2026 00:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049685;
	bh=u5onL+PlPuk13BWDSMVlSV48/QxyVlAGCdTjuznarBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4c30ODfpSrc+e0ZDSK4g8Jh8DTsjdW7YaXF2fAKR3yssEKSTBclikU629r+M7jQy
	 peVXrwQD6vBrCKKMzNewRQxGRiQjYln1mPfAej9rn97u/4WsUU+TEpR0PpE4U9XHA4
	 OMhhY2YCY3TlujGRTgqhoNZL5TPQZx/WjjOJ24MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2439/2857] ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:53 +0100
Message-ID: <20261118150329.388776910@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 38559fcd1c518a33055ef0a2cf7c04b57bfa9215 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp5x_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: cab396d8b22c ("ASoC: amd: add ACP5x pcm dma driver ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-7-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/vangogh/acp5x-pcm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/vangogh/acp5x-pcm-dma.c b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
index d36bb718370f6..4888a943137b8 100644
--- a/sound/soc/amd/vangogh/acp5x-pcm-dma.c
+++ b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
@@ -231,7 +231,7 @@ static int acp5x_dma_open(struct snd_soc_component *component,
 	}
 	i2s_data->acp5x_base = adata->acp5x_base;
 	runtime->private_data = i2s_data;
-	return ret;
+	return 0;
 }
 
 static int acp5x_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



