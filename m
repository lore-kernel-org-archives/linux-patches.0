Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049691;
	b=igWIwFywKckWuHFuuaM/X99Nm/klrS7huVbKlFjw4+a3RxHzVuVc3Z/ObyNSoRSQLENv
	 fflJFfoB/1yM8ZcPCvvqe1o4nd1PQSef3jF3B6b3gxOyZfttZlndOVNFz7NlVnwMF+0Pm
	 s0PhUNYtr5IHCUoNPCLh0R2NtMyxHlrcitKWqQaVjCGFF3DzExUUPjo9HYBu3jMUNU59O
	 IP668E/MexHG1XEyoaxug0Moi0+8nu/J13ft9AKSOjYLN/ruuaVENSFW1uxTDxscF8gK2
	 rjyvcu+PNQ1jSzjrMyAnzBIbVCoA8WmkPbU4VUWxev9PKGV9YxRiEcFu5tjL950QygA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2yxTh9Ypmp5t10y/kFrXraiXVupd8ImnynxlWYRYp+M=;
	b=wQ1vf3ifyeW+hOVW0FG9Wo84Pd6RPEwmmpyj77RoZWTumexG3pEiq8vjxa3aD8jxeOa/
	 TL6/An0Xd/tA1oDwoYhegspUrI1EHKaVYUnw+ZRghlzDDQ7cjIDOnFn3MEYe8WQ9JFvpO
	 Zh+R5xjnuB/ShyQ0uZm+3orx4DSgJwqw5TWJg6N7MixqIqxC6noku0SlcsNKTy2y3Gifw
	 DtndQF/NMGCUbhr4P0RI/prJXzc/VWdKxmZh2g8cXs3uTYjnQVMp1LA83hkY/Sw+NXGg2
	 KHJFOxLlxxFXZK+DwGJf71xl3+mSmYCDR/6Wusckl6l6tNJkXKS70KSxphSFD7Zu/0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JODSmiP6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363C7606A31C;
	Thu, 19 Nov 2026 00:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JODSmiP6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EDC1F000C4;
	Thu, 19 Nov 2026 00:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049691;
	bh=2yxTh9Ypmp5t10y/kFrXraiXVupd8ImnynxlWYRYp+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JODSmiP6O4vBt9dM2/MHVxP/6A2jryDGrqRxdMTWp/r+SGbEe9hULd7LRKy9DfStU
	 pSZIvi0WL5joq6T1AWTTP30y4thrsK6De69igQKfmEMpEQ1WMwtIvgrmZhS2J8PTU3
	 3F6zOCdiZQgfwbZJoVfqSu5c0aa/y6RJHkw094TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2441/2857] ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:55 +0100
Message-ID: <20261118150329.458815786@linuxfoundation.org>
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

[ Upstream commit 50aaca643038774b6779c911c4f96bc7e0d607e9 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from atmel_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 92dfa6198623 ("ASoC: atmel-pcm: split into two file")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-pcm-pdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/atmel/atmel-pcm-pdc.c b/sound/soc/atmel/atmel-pcm-pdc.c
index 3e7ea2021b46b..df5d5e8230203 100644
--- a/sound/soc/atmel/atmel-pcm-pdc.c
+++ b/sound/soc/atmel/atmel-pcm-pdc.c
@@ -295,6 +295,8 @@ static int atmel_pcm_open(struct snd_soc_component *component,
 	}
 	runtime->private_data = prtd;
 
+	return 0;
+
  out:
 	return ret;
 }
-- 
2.53.0



