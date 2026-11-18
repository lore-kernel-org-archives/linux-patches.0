Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061939;
	b=nZdq5Jf/rTe6iNeQeH2RMhkHpLGMmDxzkIRfP4CFrOod4y0v2yv/AegqWQ/JxSmCi+ct
	 nuDLcp9USzde9/uf6r/RKfvXt+A/9AbShkoYNQNTcZXDPr22jB7LPAddCgqV78iXLJGiu
	 q9mF6svZS7G1yYWewJaVWW2kLa3kCE8udth3j5+x+4SL6KMPm6hrqY5/eu21cMY5w8HY5
	 /fHtdhBsV1LIOKD9/5AcOOkBSuCu2+S7dazTBvMG+o+DzAUYAV8UTeV9IOyegnHVSkLZl
	 WIrW7ADrpT6uxl7/NdKIHTqkutMwHPL5e4Q4a0htjdPDopAwyEZk7v46l8n0em4jaow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xgxrJM4PQBqMPyOjeU6G9AkAY5xzu06hhp5vMsS1WTg=;
	b=oirY8tCKXp1RxhN3jD4P309VG3R1BKhCp6F+ueFXg2dnaOEoBsfNKhY9WUm9vlfyykXP
	 C7EpbILi9emD/ZlcDN+119n0OGFyZacmsW7u3lnH4qh6qotgcYQpJBLvjG79fLyJsMyfy
	 yuaU7TGMz7wTR032PPEh8NuF9c1qgss44NQUbv2M41a9+5YLxv9bQL1PCY7eFRHBNZriX
	 a8aUaKRwGXZ1danV436G8P5+M/ehNzwmq7a0hjWOXLVfnsi1ShGxFpYBM9e4XxMgAXTJ4
	 avAF/fyMKg5tk6CS9ODoHh+waKF7YQA2cD2P+jzMcZ1pt7x1S9IbRuGX0FMkyPe1Kpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xloAukgt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE927606A325;
	Thu, 19 Nov 2026 04:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xloAukgt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7C11F000C4;
	Thu, 19 Nov 2026 04:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061939;
	bh=xgxrJM4PQBqMPyOjeU6G9AkAY5xzu06hhp5vMsS1WTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xloAukgtqwhJh+d6qqKsPQWDMuOK6d/NE1viXHsRwpLbXLwa3ObRzgDJXZI3VP1Is
	 0SUM9zyl4+/3qltBpMOd7ix0ZC+RrBWu30RJ4Q2QBNqvnttxv1/GUYMybEuDp9AbDU
	 iwt7N4WJq93maGU0QfDMquRVkZYdiGuLhZqNLZnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1691/1848] ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 16:02:09 +0100
Message-ID: <20261118150030.578293952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ea53ab9003d8655cf7e94428de3006e86fbd06a0 ]

Each channel's master volume bypass (CxVBP) is in its own
configuration register, C2CFG and C3CFG, not in C1CFG, which holds the
channel 1 bit.

Fixes: c034abf6e503 ("ASoC: add STA32X codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/8576f091aa0fe172ce43f28dacd6a1bf638258c6.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta32x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 86528b930de89..add3af887515f 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -468,8 +468,8 @@ SOC_SINGLE("Ch2 Tone Control Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_TCB_SHIF
 SOC_SINGLE("Ch1 EQ Bypass Switch", STA32X_C1CFG, STA32X_CxCFG_EQBP_SHIFT, 1, 0),
 SOC_SINGLE("Ch2 EQ Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_EQBP_SHIFT, 1, 0),
 SOC_SINGLE("Ch1 Master Volume Bypass Switch", STA32X_C1CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
-SOC_SINGLE("Ch2 Master Volume Bypass Switch", STA32X_C1CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
-SOC_SINGLE("Ch3 Master Volume Bypass Switch", STA32X_C1CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
+SOC_SINGLE("Ch2 Master Volume Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
+SOC_SINGLE("Ch3 Master Volume Bypass Switch", STA32X_C3CFG, STA32X_CxCFG_VBP_SHIFT, 1, 0),
 SOC_ENUM("Ch1 Limiter Select", sta32x_limiter_ch1_enum),
 SOC_ENUM("Ch2 Limiter Select", sta32x_limiter_ch2_enum),
 SOC_ENUM("Ch3 Limiter Select", sta32x_limiter_ch3_enum),
-- 
2.53.0



