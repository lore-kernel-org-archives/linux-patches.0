Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032266;
	b=HvdnTRksz8Qwi2MboD0CHFtQLE4DoDzBoI+S7tQ6miTvW34y9xaTcLpoBPOM8MZXTHIp
	 DoA6fkFqb0Dl0sblkR/aNSJiqDNxhc8CA2opqTad6eUI6Y9wrTXfBQ+33zm5QlRCmKHVV
	 uUmhDVvJHQ2pnqbwi+JS6sIHBkas8nQJVZAnK4X3Cf/LHLfVi2R+thOcjVPoVD0MIFSZD
	 WC1QJWd33Z4sV/atmehvfwRvpVY8dfVDdJlXBpSp99AWzyrHG7aX6mGINX2g0uD1Lky3p
	 X2LvzbcruLqwfIcWjCM8tXMtfpLQl2ncb9Od7Ok4/sR1Z4YGWifP9dRWWNCAkFOIzOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KzhwMomOxvs9nco49dveGRqfqrDGylLKXyJX1rcF87k=;
	b=sQu1yulxRIrbexf7Y5rlHUoRaq2Id5aE5ag2a8XLFOHbn60tfqq/+wg91sjKoZKJSxVz
	 F3DqyUksL5AIA5ozYgT/48Pr7cSl5CKDcDw+FN4W7sDnLeILvbPbuMGB+6MXbzzTNLmpo
	 WXeSW/tNx2xBboFkUKzfBhWoySlvFEiTlGbUvxUkHDVpjI/WaoWW4qMTUt+O+xz8LkBDv
	 HujBHneO0I+P2mF3BA3a71Lap2JYLvFtaXKtpfAIi0giyWdCwkDGTHHz5CCbrkeKZNrI7
	 Up2OrDfjQO1XWbdlOUkUgOgYC7hefA93g/2OWFQh1wjKkUeLxtGsp5JiX51lqlnCYYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NG68hUc1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63757606A325;
	Wed, 18 Nov 2026 20:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NG68hUc1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68EC1F000C5;
	Wed, 18 Nov 2026 20:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032266;
	bh=KzhwMomOxvs9nco49dveGRqfqrDGylLKXyJX1rcF87k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NG68hUc19l82JrK9yxRgdkJ5gvlmSPuM1imHmV15tqIpI4rDi7dWPDFSoz8PoYYRX
	 YvqSc+6IB9S/SDa2cs7IQnm/1tyjekdIrN9fceNLnTMDgxm+TqPCv1sWAqiup8suRn
	 aCuwvf/hC0N0F+xs3XPKFiQmChG/obKcPtJU49aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1351/1756] ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 15:57:58 +0100
Message-ID: <20261118150103.098229206@linuxfoundation.org>
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
index bd8848ea1ec2f..b179f2495834d 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -464,8 +464,8 @@ SOC_SINGLE("Ch2 Tone Control Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_TCB_SHIF
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



