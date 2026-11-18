Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056257;
	b=xfE+JXzriLv6V6ebDGfy1cEVvev0vb6K8J5mTVlUdYLnzyuxoZ50azR3ZjunqL5lklMR
	 YUfeFcNc9QGKSdPHQBBzY07fAsXLqIC3/A9rjkj2zYen2OXCsjSlKknuJMO8oeOhjnFr6
	 a8U5LIzBpbUKg7A4yZ+OChgFM9pp4qclQKpixtcrUudUae8Z4DKJDhw/qNYZQblMeealv
	 B0+v9JrB0wU3hduXaRSqK9EFUQc1NJ/4Ix6CyUNAFcLD6OJQz7evhHbAhcPDlS4fhS3fH
	 fgnbDmc5VXRbQcjCQWoLm1RcRUsJcaTg6gWESfK/oYqRS5PQZ9Ex5t4KwupyHIqfd3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1qa3KLdPjJGhQBFjblgtPq0wubBu8aSDiVtqEknWUUo=;
	b=R2U6NNiimWn1Vob7YT8G8nKuryfmOfQn25a7gTbrWOm1SeqIT5hxJ6zhBZb9vxb/a1MB
	 InQEEg+g92F4kegVmSWdq6GqR6+BzG2COMsrJhibo2XJ/IypO44cmsGH3ehB338V7Pwp8
	 o+dLR92OpuSLGWJniqmzcXkXqFp4RCUSidBzPSle7tnl9/IpcpgATvMzlr1++qrLRW6UR
	 RKVJeb8sxihFLfVa/4UWEf5CR4t6/5Iez51mgioAE3qDJdUFKHDEcrFZgN1787FRZQGRq
	 FtGaQX4FV8xc+C9FtPwW91EUEmd61Toj9Qn0zebE8KzPexFtg9oi3jR9ozEssyuzmpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="16//PZfB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C87606A31C;
	Thu, 19 Nov 2026 02:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16//PZfB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5F41F000C4;
	Thu, 19 Nov 2026 02:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056257;
	bh=1qa3KLdPjJGhQBFjblgtPq0wubBu8aSDiVtqEknWUUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=16//PZfBfQ8ziq8xahJtcJ7y0piNjFNptSveiMxD8XlZJe/kcIxiEAF3v/xM1BB4o
	 RmXNjV2hSiMXkIYDnqrYmpRDanVLeUhxQKCN5vp3johaCwsgsEfpw6YKIcTM0kLsSS
	 Pv9e4RXsK0hol4dkQRzSHKdrEKyFd1kkwuxqu+RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1923/2214] ASoC: codecs: wm8737: Fix definition of zero cross switches
Date: Wed, 18 Nov 2026 15:59:59 +0100
Message-ID: <20261118150127.977699916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

[ Upstream commit 121963197200ca89050f05a704f53c281702ec16 ]

The mic (xMZC) and PGA (xPZC) zero cross bits are bits 3 and 2 of each
channel's Audio Path register. SOC_DOUBLE takes one register and two
shifts, so both controls only write the left register. Use
SOC_DOUBLE_R, as the Mic Boost Switch next to them does.

Fixes: 2a9ae13a2641 ("ASoC: Add initial WM8737 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/36cab58287bd24955e73bfe3a6fb24cae8fad7b8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8737.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8737.c b/sound/soc/codecs/wm8737.c
index 7a3f9fbe8d53d..9156a28a548d2 100644
--- a/sound/soc/codecs/wm8737.c
+++ b/sound/soc/codecs/wm8737.c
@@ -149,13 +149,13 @@ SOC_DOUBLE_R_TLV("Mic Boost Volume", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
 		 6, 3, 0, micboost_tlv),
 SOC_DOUBLE_R("Mic Boost Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
 	     4, 1, 0),
-SOC_DOUBLE("Mic ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
-	   3, 1, 0),
+SOC_DOUBLE_R("Mic ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
+	     3, 1, 0),
 
 SOC_DOUBLE_R_TLV("Capture Volume", WM8737_LEFT_PGA_VOLUME,
 		 WM8737_RIGHT_PGA_VOLUME, 0, 255, 0, pga_tlv),
-SOC_DOUBLE("Capture ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
-	   2, 1, 0),
+SOC_DOUBLE_R("Capture ZC Switch", WM8737_AUDIO_PATH_L, WM8737_AUDIO_PATH_R,
+	     2, 1, 0),
 
 SOC_DOUBLE("INPUT1 DC Bias Switch", WM8737_MISC_BIAS_CONTROL, 0, 1, 1, 0),
 
-- 
2.53.0



