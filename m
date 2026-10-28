Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210845;
	b=c9ggZKGRAAb+vX/puEXRtMOUUVCtgebotnfVBo0Zqv/fMjEh3+W0g2tUc1skYJDbGqMF
	 rpyAAnSZzos/ljP1MMtLicziNprUfOxWqk84qK8DS8Xc+MdsUf0Ulf/G+EcmqyRK0XyE/
	 8I/RSHSUcrVL+aEpnSNtWV2eIfa4PD3SsKdAynYe85ivYFJCzI6VOw0auXzkEEQqVi5kH
	 xfBEyO6QRYngW2An0r0imueZXw/ODb+QpiEgceTvXJg5fYbjRb0N/KY2cNzYc8ZfCRmLh
	 j9swSu/HPPR1pS0+z2gAdXlxW1vpUsMUK+IM2gnOOYFDA4q2IS6QHo9JopD/0py93YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4wZCV2LYE9ZUy2FGCnrMnIlkLkK8sEyvhO/ERAcPnI4=;
	b=u/fAO0wrObnPTnwdF/BM+K0mduLV+x9iLgl5zuCGAQL+n7Ho4CIdpWiJTdgH7NWBY+fC
	 pXL3faP1jlGuLgmGTkAFySIYZG5kPdqtdTnQJ9wrnOYAqfiHX9TzXPRCXVn23SYO9A1ua
	 4EoaNlFS0mgefugeDwTAD1rH6V72Axfnl+M64S5Vm0q4nPHljOReGIp0JfjtIU1lGz6Qb
	 qqcO0nyLMQAzfsNCFf8a/8LfpajvRV+qTnXKyzxItrV6QC8oDsx0JVqnNfxpSbkYoqf6n
	 syktL87jaljH+XEXJgfZxuIO9qCBLFpDXky8+8OL3/suiq+yL9gjYT7urxIE97xJ/oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tkj2+ep0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946B0606A32D;
	Wed, 28 Oct 2026 18:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tkj2+ep0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46991F01829;
	Wed, 28 Oct 2026 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210845;
	bh=4wZCV2LYE9ZUy2FGCnrMnIlkLkK8sEyvhO/ERAcPnI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tkj2+ep0BjJKaxupNKT4VVq8CdZfmgaawGy0vNFGsEy6YXch6raQpZHEKF7hQ2zhW
	 2SSOrD9ke1JJ2gJ39XGkUkGtdZqhMo9rCTHz1luJZC9wlQlRlLxpe48o9WXoTD1tP3
	 eOhDDmMwIczHpnVGSlQ0IdOxt+JxxCK1sdm2ZPm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/571] ASoC: wm8903: Move the DRC QR threshold to the register that holds it
Date: Wed, 28 Oct 2026 17:55:14 +0100
Message-ID: <20261028170011.977933076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit e31ae4aeb049983fe3be0cf1e12c8074811a7685 ]

The DRC_THRESH_QR field is bits 7 and 6 of DRC_1, but the control sits on
DRC_0. Its shift and max are right for the field, only the register is
wrong.

Those bits of DRC_0 belong to DRC_STARTUP_GAIN, which "DRC Startup
Volume" claims as bits 10 to 6. So the two controls share bits 7 and 6.
Writing either one moves the other, and the quick release threshold is
never reached at all.

The six fields of DRC_1 tile it exactly, so there is nowhere else the
threshold could live. Point the control at DRC_1.

Found by a sweep for two controls claiming the same bits of one
register. No board with this codec was to hand, the register map is
the driver's own wm8903.h.

Fixes: f1c0a02f32f8 ("ALSA: ASoC: Add WM8903 CODEC driver")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260920135327.3628704-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8903.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 75f30154c809f..168d4f680a654 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -678,7 +678,7 @@ SOC_ENUM("DRC Decay Rate", drc_decay),
 SOC_ENUM("DRC FF Delay", drc_ff_delay),
 SOC_SINGLE("DRC Anticlip Switch", WM8903_DRC_0, 1, 1, 0),
 SOC_SINGLE("DRC QR Switch", WM8903_DRC_0, 2, 1, 0),
-SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_0, 6, 3, 0, drc_tlv_max),
+SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_1, 6, 3, 0, drc_tlv_max),
 SOC_ENUM("DRC QR Decay Rate", drc_qr_decay),
 SOC_SINGLE("DRC Smoothing Switch", WM8903_DRC_0, 3, 1, 0),
 SOC_SINGLE("DRC Smoothing Hysteresis Switch", WM8903_DRC_0, 0, 1, 0),
-- 
2.53.0



