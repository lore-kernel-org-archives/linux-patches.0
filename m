Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049688;
	b=nFm2/5t24z1BBlbxYpZrKl8Ki/H2ICRUUMF1uVn37b3cPAeuqYTzK6JdfeIQu9D7dW3+
	 5137na2rI3D5FxnevZg1j1kfBMeeNS+D/ZNicoiiu4cXpwSPh6xA4v1LkvGpGuCIvFBCJ
	 SJ5u6OJbZObm/GtL38SibKvRSDNd2RVmTifXAu56HI822Q7xCz8rm0pad9JbC1tuMwVGk
	 Xojl5jaZTGdAg7kD1+5BVNDVPGV0ONi/ZaXuygS8LGJ30pOI6UIxAZzGFDdDgALPvP8g0
	 hN0YZV1u+EPig/zNqMoAtdYISQFm6nsD+dZcZ5GKRJOgTwwmW6CahmszqnuTBcVJ+ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eygjGosGofArAGNrk+d72NRIznHTEoL3NLuuFMi8bLU=;
	b=vrqXsooUFHMmvdOMd4mwg3WfY0FeQiNU3hN+OgBDe6iA6FhTmmo1kvYK1Pt7LRrjAE+d
	 MUPc59puEbiyuHiQAr7vYa2UB645R050kbu2KcGYmljbCh20zjEDM0Do4EYLrQ3bCxnHI
	 qaSD/E6suNegDdnw32bPJO8IhOo+19q5QdY97vLMo6mKsloCgOjumzqqOz5LIJ0V0A4p1
	 SuDUBWGa/BVtQwVfsI/lUgmuIKnbPifSfC3JUQiyIpYkseskNX3Mp0J6UUp5Ai5WZoF+m
	 mu8HU/MdKiH3ord8UWjFe6u+qj2taPRImjJOxSsziXjvnYtD9/U75ESW+DXaa1WqgLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JxLVd37j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D37606A325;
	Thu, 19 Nov 2026 00:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JxLVd37j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38721F000C4;
	Thu, 19 Nov 2026 00:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049688;
	bh=eygjGosGofArAGNrk+d72NRIznHTEoL3NLuuFMi8bLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxLVd37jnzaRF8LDdjdZQaIIk6WfPfHv6lR1ZdwFU5rcvZqa3y2Er2bcAHpSF0l+z
	 mbgfQWRgWIgJNRQTB191nBVyvC7DhNGQkxRqaE3mxNttUiMY/IuxHBgJBMglmGBdyC
	 NJaD08mXIY+NHdVDu6JCIBYkWE1KEjU7brl6XyIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2440/2857] ASoC: amd: yc: Fix acp6x_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:54 +0100
Message-ID: <20261118150329.422582986@linuxfoundation.org>
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

[ Upstream commit 06654a3ef5137719be880a6cd12bd453050eafc5 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp6x_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: ceb4fcc13ae5 ("ASoC: amd: add acp6x pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-pdm-dma.c b/sound/soc/amd/yc/acp6x-pdm-dma.c
index efdd5c088b883..87b98f5415db7 100644
--- a/sound/soc/amd/yc/acp6x-pdm-dma.c
+++ b/sound/soc/amd/yc/acp6x-pdm-dma.c
@@ -203,7 +203,7 @@ static int acp6x_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp6x_base = adata->acp6x_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp6x_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



