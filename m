Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026482;
	b=BvtLy4/bvG8TMJH4l0oEg6hLUOj/v79uI8rMBI4REAX0+R47c8ZevU20ww2S0LTYTyhr
	 AKPwDXssFkwnOaLrLxPFTX+M5d6wHjzm9gCKSSNRTPqr44Mb227BkSKD+Iq3cVaLUwxb5
	 3UFKz3uKon/itWjL2VaX/VWZFdu0vvG4sS6g9EWKCTeN4ttCFIoj+E//4QN+Ti4VFdwfj
	 hScLDsyUxUJ3L50s3JajfWW9xeH2f+ROzb2bTiBkjLlid8ezNGTma1yovaufDzmgVlppc
	 BkZisfUpnSmQPi6EqboxmY6U6kYZ8hmcYRncQYh6kNDss4RgQ0t1B5ebdrATqUPIKCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MXjNqFRPtTXgcCzpsbMwK8L5+MDGp8vp06KZQ16++r0=;
	b=cYcQGjNlyozzzYOxCeCqQ70JH2nilRJiPzBwh3CzbWwQqhwkWdacGURLmTM+NXTGaOYp
	 FXIOMKrBcoiSCXbBKtsZiEeOvqAkRL2mvLY9NAQxQXDKdxSnOBbJ7bIbM/Q9FicQ7Iw3i
	 vALCHetZJaxr7X71yzNTjWISdmh24LjS5GWyNYOI8rW/aMCVYNvZIJ0jMZ0gK5uNWryxF
	 Pa1i2vEHtYBO13urKKcymcBpJUMwIlv/8AHFGNbq3H8Rm2g4EYeZ8vQBNj2bWqWJFYqKe
	 2CD6uXowxoWwdwEaEzmn3nyjUMIF/4PvoJp2o871guM4WBsjiKl9oQkgpisGVQQFrqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOiLjA1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CC5606A325;
	Wed, 18 Nov 2026 18:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOiLjA1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AC21F000C4;
	Wed, 18 Nov 2026 18:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026482;
	bh=MXjNqFRPtTXgcCzpsbMwK8L5+MDGp8vp06KZQ16++r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOiLjA1E/8i8XFcnqLYlXfxd70iQQsOpytKhnZ60FqBIowOWrhxmOBbwCYF8B7Tb5
	 EN8ycfgNWj80pjsxIMeI8EtMcOEHg6oT7UQDilytdTOJiVd38/FbLvQ81h8Ex1IjRI
	 Z/MJYeQRclVmFAFBwleu1UbN6OefJCs7fMJJ1PMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1450/2151] ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:05 +0100
Message-ID: <20261118150214.742639341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a92571113ef297840270e4d8d4263a842302c9c4 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 4a767b1d039a ("ASoC: amd: add acp3x pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index ecb4b79520135..f89ba818075cc 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -233,7 +233,7 @@ static int acp_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp_base = adata->acp_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



