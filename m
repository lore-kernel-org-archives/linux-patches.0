Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212647;
	b=Ix1oTtLGFk+WTELh8SyrCaOX6Xgsf+kX2PeEfxI9DKcde7lFPVYoMO9f7XTiFn7o5j1Q
	 GtdnYkm4n6N9kdW8KFXQO3ooo/LbKs+k/aUWWq9fdWd9u+1Kts3OJtZn9hUFnG0+3779U
	 +aFlTposXR35LeelPFcURJdlwx4gvlcqQu0HCtNj/+00o2OorZ0SETuEnBBtZVAf1CObS
	 u/Gp5fYXoV24XKhrE+en70WVXVCOVBKN9XDoGiaVIExITw4g3ZPBIQULRR4CVRqtZ5vzh
	 IdEweukXjF29NvlS689vkMg86rAyweA5a9VCYXyHBDnd1El8cBBoVKq85wQW2yBH2pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=smul9c2fCvhiYcZx5t/8N4yJqC7E4WdtdD1gQHgtEtk=;
	b=YmHVyIXylguw3xCx4vzMQ5WE21/pOuq9zP8nlp95VouBXRba11AKd6rqXSwkHR8nU0qx
	 sjUXiHyC3cDAzwwU6oXTaDNo3eCCkv2DWRWGFx4VJ+l93y7WUQ6+LlZLnP0MUddHoIX65
	 JoRFsOmjFmwY/0mAJBCKfzkT213b+EFvEugv37lgumkCbA8CmD4HXVn9yTqFaBjhi2Qr+
	 M12Z57vn+/R73qj2VFDoT7njtzd5ZDhh/GKLQlOpQDFqXk+1zdVEkWldSq4FlkcIhnynq
	 5xApoyoub7zllG8ItNcti6JcvPjYKTuLT1tVHU9wlitGFByiivX+5W0MhVk0kDTSEjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cscKP+xy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86DE606A31A;
	Wed, 28 Oct 2026 18:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cscKP+xy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D218B1F01825;
	Wed, 28 Oct 2026 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212646;
	bh=smul9c2fCvhiYcZx5t/8N4yJqC7E4WdtdD1gQHgtEtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cscKP+xytPPiGw5cCODCLLmQvMVdITuC055P9LaH+vSyHGTZE9KV9PSpwaeIw3mxL
	 8UkWK3fhJTjon5l4bi0HGNJS66wd3gFZx00jZjD60xBE3rEZ0QkIEK0nJaz5Q8bXEw
	 EzmR5STnqZqC0taON5t3qDSyfADceGFKHx9KxZXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0227/1887] ASoC: codecs: rt274: Fix format setting for 44100 rate
Date: Wed, 28 Oct 2026 17:38:43 +0100
Message-ID: <20261028170504.400282010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 6eda8938a790f65bd24fcfaae7b40ad4613fb7a2 ]

As per specification, Sample Base Rate (bit 14)
shall be set to 1 for 44.1 kHz.

Fixes: c7e79b2b2d2d ("ASoC: rt274: add rt274 codec driver")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260918111745.3589393-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt274.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt274.c b/sound/soc/codecs/rt274.c
index 4667bf7561b13..f664a6e139239 100644
--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -619,9 +619,11 @@ static int rt274_hw_params(struct snd_pcm_substream *substream,
 	unsigned int val = 0;
 	int d_len_code = 0, c_len_code = 0;
 
+	/* bit 14 Sample Rate Base, 0: 48kHz 1: 44.1kHz */
 	switch (params_rate(params)) {
-	/* bit 14 0:48K 1:44.1K */
 	case 44100:
+		val |= BIT(14);
+		break;
 	case 48000:
 		break;
 	default:
-- 
2.53.0



