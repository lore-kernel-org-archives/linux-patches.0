Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041585;
	b=sB9u18m0LlqdiQz4Yb4fBkeD5eqtrTktFbaBSzLj702GIAQgp6zS3QKpJjrvgm2ed+xi
	 r93lC0kilGAzZDbg67jKVfK+FQ8nrFNB4/XQ/O/Xjry8fIKNhFRsw36EPTo6ymWSXDNcv
	 6DECJKO/Fh70NfLLvI1DO9EGFhO8gsjldFodySn8gqZ+wPiuKpItFPaqHBvs3MoP1ryZB
	 iqmmmEh02be3Ru/8ziFtwInH2Qe7smjDgaQlaKp/WdUJVKkW+Yo5PLYcdR53lhtLWm2gN
	 uU2nuqQn+GCBy8rd2DqZNWEwav94vpi8QTTTpOFNpa5DFhJOSwAFILsT5V1YqMgtmKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R9fTLJOoW03fhgaVHK4af/n4zW5YPld0bEqCk70t6TQ=;
	b=Q52YXvTJCMyo3Q4YkeeDNRmGgbiXfHN65a2icGtxddSNijBhkLCvSE2Fxs0ZrIS96qCs
	 57dsxoL3xukRwVRYGXJGmRt0/8DBNNzClgljvsoXwxx51IZOTdoxvMThmffkWK3Ck8LS4
	 1H1WB1jAj4OkCBf+I4x69+m1RJVv7xCaajE1+e3KlAZuhNIvFUEQdefg0LmRlGv+cWqo4
	 s8jKU20msuKVY1k7ySyvQ7kad/w6vySSnQVtu3wqrJgg5DQnLyABtZSciJDB2xBYpbGvK
	 5DqUmzdrFocYBGCEr8jhDRKNf6pxLpxE2fMLthaKeGe9gNRiU/4F0/qHgysH8LZFGMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTLoASuC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B396C606A6D7;
	Wed, 18 Nov 2026 22:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTLoASuC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137AD1F000C4;
	Wed, 18 Nov 2026 22:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041585;
	bh=R9fTLJOoW03fhgaVHK4af/n4zW5YPld0bEqCk70t6TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTLoASuCSOO36OdVopJwF/LzQobLKohBL4vZk1+JMjRMb41wqcRm6HweakWHhmGPZ
	 DyLjsevoFq6WUns4AOTHWP0ivkdvNsIUjXIYQpru3Lj3b0rjudhoEwl309GXVdtxTc
	 WUxL1Iu2SVGr98nD2R4EhoCdAWahjDYrrboxisAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2866/3318] ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control
Date: Wed, 18 Nov 2026 15:58:08 +0100
Message-ID: <20261118150446.551382316@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 8c299077c787c151c5c88928467d8e8d85cebdb7 ]

The noise gate type is wm8750_enum[7], bit 1 of WM8750_NGATE, not
wm8750_enum[4], which is the 3D upper cut-off.

Fixes: abadfc928a27 ("[ALSA] ASoC codecs: WM8750 support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/ce530dfb932d9e8def75059ab9d669360adc76e8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8750.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 2d2feaf95e495..a9e55439a8224 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -171,7 +171,7 @@ SOC_SINGLE("ALC Capture Hold Time", WM8750_ALC2, 0, 15, 0),
 SOC_SINGLE("ALC Capture Decay Time", WM8750_ALC3, 4, 15, 0),
 SOC_SINGLE("ALC Capture Attack Time", WM8750_ALC3, 0, 15, 0),
 SOC_SINGLE("ALC Capture NG Threshold", WM8750_NGATE, 3, 31, 0),
-SOC_ENUM("ALC Capture NG Type", wm8750_enum[4]),
+SOC_ENUM("ALC Capture NG Type", wm8750_enum[7]),
 SOC_SINGLE("ALC Capture NG Switch", WM8750_NGATE, 0, 1, 0),
 
 SOC_SINGLE("Left ADC Capture Volume", WM8750_LADC, 0, 255, 0),
-- 
2.53.0



