Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049677;
	b=a5qiNLLJcnkEvg663HXTXahoCPeMb0X4QIvN7ZOdmhP5ei4MM7OnEBnM+ii2qYCO5ekx
	 XhuWlNKZAaa/nzRw2frwu+ny+aqCUMNxUo2LoqCSl5JIHOQVqvLoM//63/jteC+F1RBz6
	 z0lS/Aon8t3kifE8FU1UFIwyHyhK1yY+OcMcTKomZM2r25tcLDJuZQGh4aqzbu7nSxbTZ
	 OI2tP+vuNu5NTJzpdsQC7eYMRBcA3G63cBoDNTJA0wx/5QeFtObl55bSvaCC4l3K8jjH8
	 K3r9YA9faHTH01YojIEtx8TnvyK0Ngww4P9+LlYWgczxH8wWvSNcL+3PuNiEtaJBoDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jb/iQ5BfZQE+sJ7s9AbPeoyCKGpq2/JIJIZNj2xoJvk=;
	b=OF91un+gHPELFbd3fIxPR22++eNa8r1m6iw4dRf4f9KTqGidRSRCD43eIt50CKb97ZiX
	 QdajKyj6M+cAnqx3xoBDwAh1sEpiHzcnMUU0oInvEAKtluD/KqXTNzT78pj2QzmEvupBB
	 aD5VuYOJ2SbHvjhu1M29vFkyru3Abt8doKrOV0N8ZdB8YFCI4s3c4s0p1wlCMyLkaosG3
	 bLzpJgzww9x/cXpv1ZuUgY1W4L3ZtSkFt2GZ+it9GZqyoMwY0WB7DBO6yepXfpHNm7PJi
	 rh/WrYTQ1sno3WuLLzszcozD2yPimTcGLex6ry8V4nXdPDmBbJSnR8uJEtR3uZblv6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RxWwxOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F62606A31C;
	Thu, 19 Nov 2026 00:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RxWwxOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AD11F000C5;
	Thu, 19 Nov 2026 00:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049677;
	bh=jb/iQ5BfZQE+sJ7s9AbPeoyCKGpq2/JIJIZNj2xoJvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RxWwxOda/zN38Ho8VpHZEbTchg2+nUufGOUgvBHvaMQFfnIk90IkLXyFWM43dcwf
	 B2IR6U2iJ/Ag45byU9qv8eCcmhKeZnz40uI979/lQfKoy28IvDOJ5qQUnlmoOaKQin
	 rmYMmd7kiUsLBX7m7PMaj72CI+aSAjXqWXGsTQTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2436/2857] ASoC: amd: ps: Fix acp63_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:50 +0100
Message-ID: <20261118150329.282818193@linuxfoundation.org>
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

[ Upstream commit 172888114dda96492d40e4a6e0ed16146cb76e2b ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp63_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 5137305662ef ("ASoC: amd: add acp6.2 pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/ps-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/ps-pdm-dma.c b/sound/soc/amd/ps/ps-pdm-dma.c
index eea71a9d2ef1a..915218163374d 100644
--- a/sound/soc/amd/ps/ps-pdm-dma.c
+++ b/sound/soc/amd/ps/ps-pdm-dma.c
@@ -203,7 +203,7 @@ static int acp63_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp63_base = adata->acp63_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp63_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



