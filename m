Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041453;
	b=fLmc0gz0Qq2L2xwaMru9h/La/f2lPg27lkuEsgc5EuDm+0rimOW5oRfSBoNg5s7z6OUC
	 HqEQIzTkbBW1FXmLU723WzmWRTL0J4gysBiSdswKbkRiyvX9V9nTI6RhM9lNgO5AQvzzE
	 kQgkMrr3Kh9OR4qbR9LHLP+QYIvJAmxmkYbzpzRhDV7WID9DKNQ9D8d8rqYBEcLbSY875
	 VEZ2NYRH0HgkQ4gKHVHP99UjTqCI9/OGUjm7JSmy/5O91lNkD9AkWMNdP7uGF5sHNf4w+
	 ccl5GwV6WXnpZpS2q+OqB8pcKYfmc/xw+gKYUrUKsjWldIIWpinTj3Xrr3ibHl6Xvdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qZ40UVHIPP/pUoCkAl+6M/l20taiUSuKTT0ec2XmfmI=;
	b=p7TBYxIFjI0l5+ZYBOICah/Eb4AH13EKttnHExbVDXPvn7Oel7/14+u+OI1/QJB00ENb
	 IQYKVwP1CNo4sh1fqgJwhbPEqCpiFRxkpyE7DBdB0VAz5EB2Q5d66bbyTmUMcFc+v9XdZ
	 pYOoV1M2RNmxLLo3E8ygyx2lxJudQPE0TWa4yeHEJXRlPvq62Sq1lxaBVNYs24wFjt72j
	 XQ5w2gIFqO7oiakUSTQaEqCLXIyufPMlpYVEjZGz2EQN1/3emzDNmmzNagd435Gzij7bx
	 oxfZCLGDuh7UxRmvVEe93B1Vfzp9mONUZj0rLIJ+Hu9OwCtEUUMU7RqjCGcFwkYAQYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b3Hfxzf+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8E4606A9B8;
	Wed, 18 Nov 2026 22:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b3Hfxzf+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB4A1F000CC;
	Wed, 18 Nov 2026 22:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041452;
	bh=qZ40UVHIPP/pUoCkAl+6M/l20taiUSuKTT0ec2XmfmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3Hfxzf+HIIEfBAQXi9yXSZpYwfvWYvqeryfXXJCrwDn7BHvqTwv7DE6f2zN4C1Ch
	 I0RKELmafGOsjjtFL3svXz66h/1HM6fG0o13T4sPS1Sq2YzdZ1TLy/Uj6ArMrW/8Pj
	 xJu9MLA2yt6dtfjLW4m5QHrRp2FnoMh1EliycZ+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2820/3318] ASoC: amd: ps: Fix acp63_sdw_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:22 +0100
Message-ID: <20261118150445.247370175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 45dd2b22ea8934ed69dd05e6ecbf3c66ac3baebf ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp63_sdw_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: f722917350ee ("ASoC: amd: ps: add SoundWire dma driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/ps-sdw-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/ps-sdw-dma.c b/sound/soc/amd/ps/ps-sdw-dma.c
index 6230d1b122251..a98402986b14a 100644
--- a/sound/soc/amd/ps/ps-sdw-dma.c
+++ b/sound/soc/amd/ps/ps-sdw-dma.c
@@ -243,7 +243,7 @@ static int acp63_sdw_dma_open(struct snd_soc_component *component,
 	stream->stream_id = cpu_dai->id;
 	stream->instance = amd_manager->instance;
 	runtime->private_data = stream;
-	return ret;
+	return 0;
 }
 
 static int acp63_sdw_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



