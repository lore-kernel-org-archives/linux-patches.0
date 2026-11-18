Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031953;
	b=qFlLITFk287YQXx1VJSpPwGiQvCUojr3TtwVDA8KFe6QJBzwBWGawl/wxtpJUnGHMEa2
	 yh4iRAww+KIn8m7M0MW84FKk7E+Mgg0tX5AEyp9niPc5tsEZk03iepvqejMoYt3H/E/lu
	 4VVyA3ck0yuj4kRUKme8mgMKEc2fNlj0eRKQ74ptw8jEMekYKbIppK7uy+Hb3UX3moLMl
	 +ayYNVyJ1usaIjNxocscuw3Oa03QTm3c4CngX9g3Pd79QddHpRjNI6el5DjUBLFFDzvZx
	 BTV6kH9kAO0qc5MiU1Rak7QOSp+DSueiS1gBFCd0/DPkT7zaevXrIVsLqf37NehUlzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AEAZEnAkmhHJqXUvPC5+Ufgl/y6CxIhSPR13TfrrXcU=;
	b=gbGzby84lVk5UuDC0Uw8nVpy8UsE+xW8vT4rUom6Zfa/1ykt2zgnqZ1P1oK6HgVX1zhe
	 ruKuNWqs/hieV+UO+oTZohCeuIijSqDvmG9pizLR+ioTh9qdUA24rewYrufgPXU5L0LSG
	 1ahjFoyhP2EYdYNaIY+7JKizL1ClUPLaymxKE/jWjo7FcTpOZrv+xo/vV4bzbQIi/deZS
	 Vfiz10N86Nuupw0jgzH2DKVMM0gHOVXquyuYq6rnT90YkM8C/onXXddMeTcz3oF2xTff9
	 W74YUpEaP5O8lx+dX8K0Awcrspf3obdKKxHUXBqftHCnruV8Cr+ZjsXhZxt6m5XGq9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Afhulf9n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384E606A320;
	Wed, 18 Nov 2026 19:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Afhulf9n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BBE1F000C4;
	Wed, 18 Nov 2026 19:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031952;
	bh=AEAZEnAkmhHJqXUvPC5+Ufgl/y6CxIhSPR13TfrrXcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Afhulf9nMk9jIj7H4pZobnLfPgj2D9s5it7gCTPnRG8gHtKmKpzX3YfkfCX/U3QE3
	 er6NaK0oL9xkbIeB+cpU8A84YI6y32DRMzMwBbKa4tqkBrXBKWBpPMqwrVIHtzqWDp
	 Ss0dE1rbENXxnFl1tSwlt13LP9EJMRqO3EjZjGxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1198/1756] ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:55:25 +0100
Message-ID: <20261118150057.543539235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit fee722db39c2a1f18c944f747271fd1e131910a6 ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: 203db220718c ("ASoC: WM8991: Add initial WM8991 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/c6e230b0e7d7e3db2136cc751e0b563030dbc16d.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8991.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 5ec1d8dc908ab..9d89337b19921 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -184,7 +184,7 @@ static const struct snd_kcontrol_new wm8991_snd_controls[] = {
 	SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
 		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
 	SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
-		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
+		WM8991_LLBLOVOL_SHIFT, WM8991_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 	/* ROMIX */
 	SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8991_OUTPUT_MIXER4,
-- 
2.53.0



