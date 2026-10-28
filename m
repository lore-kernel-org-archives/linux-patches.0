Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207511;
	b=BQ4YRgz5D915fRR/SqrQPCaLrC4nvPtCkV56HZBaD0MvffFO2niDFUgYF0T6laTUqO3R
	 z25SqcLcKhRiJYaorwsSsCuxhF5XCb/MhM+SUBQvR0CuehO4QyK5i3irM1BzpBDa//j4O
	 Rzx2Rtg7yzlb5q1egMNGTcntd7iRVMiTVHa9xlP3vffRsQ32Bndh1LERQE0w674Bw0izd
	 wnGoTmsFnZlrZtoggdSfSW1UiJ1Q/f8zpKZdeitkBr0qapfULYOcxrqRtloDvcIvYyYjq
	 TySSJBJqXEP1wml9O/DgTYnJo3/9kqImIMglVHwX4jMp4ILdHMLLfhDEGcyYPNF022A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5aWLLmF57AkPk8sjY1SclMTfcdJ/iHBIKZmmlsFU7z4=;
	b=XQggsfy3doJBpVn/MmbRZ+ccYGKD8CYeCmDN/bBcqC2Lf+u9VzmFMDTZSG15bGYqdnkT
	 kuMIo0xKJgZC3JbEA5DHpidca11K9uKF9ai3/aB3749KF5X8p5Zs2SF5cQcLp1GoppEmi
	 Lc/oq4LS16ohO4Cj1Q3/WXMhOwUnC79F2YcXGz0JNGkPMzrGUnXRFvtYmDilO6wTVF+dU
	 lFbdIDZyw5NOzzh4SeYwwy97QIoyLY/KHhKFmNrDJAoUX0QAmH4X4OQ4LVVfFUFRpZrxq
	 5itshBo22taniFy0uBRXFxnOvzBLgFaZjFMTnYRofK90zrfzw8gI8Wxqk2E/xNrMiJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UieVEAgX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3190D606A320;
	Wed, 28 Oct 2026 17:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UieVEAgX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D0E1F01825;
	Wed, 28 Oct 2026 17:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207511;
	bh=5aWLLmF57AkPk8sjY1SclMTfcdJ/iHBIKZmmlsFU7z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UieVEAgXZR06S2F61YpGGjuclC4tXNYTlgTFROkrtj3cviG78bR/SZVxDUrVSy6m5
	 ZsAmjPzD9gtQxt30jhNd52rlCnsFAEciOr/gAB9B0cSgQ7ocSKIcvm9cXpf2eCMxFc
	 atvv2noUkKxeL9flsLMdH12QKQkTZRy1SCWiJFU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/247] ASoC: wm8978: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 17:57:18 +0100
Message-ID: <20261028165948.199258164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

[ Upstream commit d0567ca9a2faa33efbe5ae84ef7b86423a93bffd ]

The DAC and ADC 128x Oversampling Switches use bit 5 of R10 and R14.
Table 66 of the WM8978 datasheet puts DACOSR128 and ADCOSR128 at bit 3
of those registers.

In R14, bit 5 is inside HPFCUT[6:4], which the High Pass Cut Off
control owns. So turning on ADC oversampling changes the high pass
cut-off, and the oversampling bit cannot be set. In R10, bit 5 is
reserved, so the DAC switch has no effect.

Use bit 3 for both.

Fixes: 823dba519122 ("ASoC: Fix broken bitfield definitions in WM8978")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-6-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8978.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 40d22b36b7a96..a80538722dfdb 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -255,9 +255,9 @@ static const struct snd_kcontrol_new wm8978_snd_controls[] = {
 
 	/* DAC / ADC oversampling */
 	SOC_SINGLE("DAC 128x Oversampling Switch", WM8978_DAC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 	SOC_SINGLE("ADC 128x Oversampling Switch", WM8978_ADC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 };
 
 /* Mixer #1: Output (OUT1, OUT2) Mixer: mix AUX, Input mixer output and DAC */
-- 
2.53.0



