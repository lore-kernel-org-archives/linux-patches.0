Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050160;
	b=u71YRIbndcHJdbuckV1oZeu/9QY5zfx5HdqA41yP3+8yz9GHLobwXW6lyOkJr/1wcSO6
	 MvbCXQ+W/dQorYEwAcn8/BmDE9OzFSvdkoixvZ9Uuly8f0TTfvOR7VZOQtUOGG9RDsHtz
	 iX60/hf6wb9eV619pU805V9XxKA81TThgnT+W0QG5VmOiephqj5m1b8A62DZP4KB6/0bN
	 y13S7rKqrkjb7++2jHE948T/C8mU+nYYBZ2+sZrH5qQjFV/LFh5KcLOlFYZWXcvv6k8+E
	 inF+lTkbrkemR9zaaf3XpY3eHmO+/SXb9I+JQ0ba986c0jm/XEbDLrqEfw8TLl3i90A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1nio1MXL37CK7aedQjKqt7TBAtHibNnLEaMgwxpZlgk=;
	b=BUBwiT+radHGt4dFSiTQ8gTHmKpbCA5P6E8qvNWAaXoHDrTg/KTkI7DMqJSvLa3jSA4x
	 +hFIh7sHfVybj0ZPaasN1ilJWV7veI3jS+JhZu87lNbdhmqWwi2kUQygzk8d45ZFizyf1
	 XE17VHmILEFSDQNtnD0uuzbpKlXgBFJr8dceqtKGOaMO7Uc/ReOKml5rDALLvg0yfW6M4
	 aZQsT0QHof6+cBgvmQm6fUXDGu88nhP/t2U7ZmlKk33zz+zxFl6va3hmFmE7eUVm+9qs1
	 dUy5dmkUyRtxEO8cQTd05APJUjHjwCja+/ruy1cRFpPtAw6Cr0qoP0L7gkZ5PNwiqMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2cyxiQ2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66A9606A320;
	Thu, 19 Nov 2026 01:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2cyxiQ2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F6C1F000C4;
	Thu, 19 Nov 2026 01:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050160;
	bh=1nio1MXL37CK7aedQjKqt7TBAtHibNnLEaMgwxpZlgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2cyxiQ2OpPgNSFQ971Rduw9yZVgDvcJtQvmNOQznG7X4fi6jya8LiuPJg1TJnOF0f
	 Z7IYdjkYQj5PCl+xXYmkIFq66rTn8c3y7jlvzOKwjH7+47dQ7BXv/kDEw9C5nDxY/P
	 Appk9AufloURObl9ZCoDnm6C4Sdwv5qyNiNXMc5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2608/2857] ASoC: codecs: sta32x: Fix definition of limiter threshold controls
Date: Wed, 18 Nov 2026 16:00:42 +0100
Message-ID: <20261118150335.476388873@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit e06bf60ee5bffa9eeacff0bf8b03d4572b04f67d ]

The limiter attack and release thresholds are the two 4-bit halves of
one register, so their maximum is 15, not 16. With 16 the controls on
bits 3:0 also write bit 4, which belongs to the other threshold.

Fixes: c034abf6e503 ("ASoC: add STA32X codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/179118fc7680b2b872d1f917b7fd21f54a73a6d8.1792135145.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta32x.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 8d2b1395822a7..17003e06b4606 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -481,21 +481,21 @@ SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter2_release_rate_enum),
  * two different enum definitions; provide both
  */
 SOC_SINGLE_TLV("Limiter1 Attack Threshold (AC Mode)", STA32X_L1ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_ac_attack_tlv),
+	       15, 0, sta32x_limiter_ac_attack_tlv),
 SOC_SINGLE_TLV("Limiter2 Attack Threshold (AC Mode)", STA32X_L2ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_ac_attack_tlv),
+	       15, 0, sta32x_limiter_ac_attack_tlv),
 SOC_SINGLE_TLV("Limiter1 Release Threshold (AC Mode)", STA32X_L1ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_ac_release_tlv),
+	       15, 0, sta32x_limiter_ac_release_tlv),
 SOC_SINGLE_TLV("Limiter2 Release Threshold (AC Mode)", STA32X_L2ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_ac_release_tlv),
+	       15, 0, sta32x_limiter_ac_release_tlv),
 SOC_SINGLE_TLV("Limiter1 Attack Threshold (DRC Mode)", STA32X_L1ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_drc_attack_tlv),
+	       15, 0, sta32x_limiter_drc_attack_tlv),
 SOC_SINGLE_TLV("Limiter2 Attack Threshold (DRC Mode)", STA32X_L2ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_drc_attack_tlv),
+	       15, 0, sta32x_limiter_drc_attack_tlv),
 SOC_SINGLE_TLV("Limiter1 Release Threshold (DRC Mode)", STA32X_L1ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_drc_release_tlv),
+	       15, 0, sta32x_limiter_drc_release_tlv),
 SOC_SINGLE_TLV("Limiter2 Release Threshold (DRC Mode)", STA32X_L2ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_drc_release_tlv),
+	       15, 0, sta32x_limiter_drc_release_tlv),
 
 BIQUAD_COEFS("Ch1 - Biquad 1", 0),
 BIQUAD_COEFS("Ch1 - Biquad 2", 5),
-- 
2.53.0



