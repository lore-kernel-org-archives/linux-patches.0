Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212621;
	b=xCpnJFcwdez9AjuYwGE9Z6tPXNvJ/y8J7F5eKIsktaNmNXth3dQbEP3qLGoNUoDJyuJS
	 hIw1NhPdvHqUzB+dfTzsXBdzZHPcThxd0zPQAy95SMZEKLjF11piKCXfDLVO0IistNvPd
	 +MPCt+vDP4G8+ULuxfA7zRWaTAa+4nBFwba417NeOdYhsCqaw5ea/6P1CSWBEPpH4j9iR
	 57GK9CJBTti205y7NMTXUVyJouT2F9jdRr0imgd8jsKrDd8kD5Qy3LcgczVCrpLX8eOXE
	 XadWVQcy82CC9YyL8+v6HESPVxOasnMvqZqhR6wRK8rIuaQpt6KEEFvF3GsKafFeLwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rpwbee0U/rNXpxgFgtqO3i+pQ1PVzX9+9Jo6veC7JGM=;
	b=O2l9O/3U7rtG+8o/O3qmrk3ckH4RejVhuFr49+9qdRgIPL0YCeQI5NOOT5a5ql+2u5TK
	 5U9UvdN8UbbaC3Cc31UtERmltsICfU2xIdUUFraKx+3ytJQsxPRy8pEF8Urs06j63SEcF
	 Wh5XVAkomLt47iPP++9ZV+rrl21y0GX16XJ++C2veZx4hXkDoUaxmQW9kP8ywr0W3BKMJ
	 DaDzy12gnxWpcVxZYyfW7Qovr2Smm4FKbobXQ/aibztQfk+7ICd0dzNv5GFZJcPjq0FlW
	 A0hVlv8RJIu0v1osA8Vw4NtlYAXzLnnb02qAv69iDWFLBGUqoiKxImkJcpDk4uRJ+xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Md6Bpr4I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD05606A320;
	Wed, 28 Oct 2026 18:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Md6Bpr4I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413E21F01825;
	Wed, 28 Oct 2026 18:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212620;
	bh=rpwbee0U/rNXpxgFgtqO3i+pQ1PVzX9+9Jo6veC7JGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Md6Bpr4IkDCIpi6qJU7zTXSb3q+7jlrF69VCdb6wLy5pNYXexrbteFOSrt/GxLV8h
	 Yae1ZYVwd7rHvncILAjfVoI89/vlMjqQpCYSJHmEQ71D4gtsct72m7DeNBkRrPNruT
	 efZlV7kGggSJdSiYQb/lqem4GtJUafrtvpPcwiTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0219/1887] ASoC: wm8903: Move the DRC QR threshold to the register that holds it
Date: Wed, 28 Oct 2026 17:38:35 +0100
Message-ID: <20261028170504.214880133@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 41346e5ec5ad4..aebe47e9dc0d3 100644
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



