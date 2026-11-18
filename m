Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042038;
	b=rGbx02bTyPF7Brkuh/lne/oeuhsnUWkyoRKiqZU35n7Zt8iia9EKikbwXlDv2+u5O88T
	 enKAg3Z4/5z2mTVO8I3OKge0yXfrgtPYHR4gYX7VsL4sXzXdBjkklP/0kfzPvf086Y0OS
	 FP/QtX0dXiXxIaF+zH/0Eth7D+J54uLDmAHHSqKCHW2gb60sM5EKygdq4S1CETw5Y4m42
	 wLhAX0DHJgN5rUf0XuYA8iaRZEH00aNEQ9f+OxZlVi0vHUHIAd1U9X/Hv1btIzg9RR7gb
	 1Rrs8+4PqyFzJmwV4k+Jl9fUpqWl9Q/jpTIJnBwcNPZNdv19lgM0SvQQR9pAViaAFng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8VegpzzEanByx2nqxqGPXNPlHSGbEG8ekUUhJJh2yJA=;
	b=iKCtu6WT0DOIIrmuOajAgyXe+LoCjO9oFBwjz7cfFyHm0puNAjqyA9Pi9WFVUO3x+Uft
	 /RfBEoH2+m5615V+np/RhIYdDwMaM0u8YOwlzojaxQT5fzuRTOJeqcO+hpyfWznayYt33
	 jgl0snDu85mUSCJqEGGWCr7sYxnNiDG1ziHwB9BiHQDGtLoWP62vRjB+RSi3eOhnk9J4E
	 b0IXbW0LNPaC/9mUcx/abJsOgkNXWcZSxmNv3S8346YshY1A1wMQxVaSZyUXE8RWbhcGY
	 VqvqSyPgbx0/Hrkg570mdL19lur2yZNCkOa/eQoIZ+WTfQvhNMkgAxoFhfX7VQU/v1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CImUsJWs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4B7606A320;
	Wed, 18 Nov 2026 22:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CImUsJWs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD251F000C4;
	Wed, 18 Nov 2026 22:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042038;
	bh=8VegpzzEanByx2nqxqGPXNPlHSGbEG8ekUUhJJh2yJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CImUsJWsgqRGcAcaZl3ixpm2fUQrh1v6PRKir9HClu6mvLQ8pzt/4fxU9aKohicG8
	 DblzfmmM0oDLDyiB2qyOP3AOLndvzDbwtnl5v/63QScI9cRayO6p408A1xOoXk8hqt
	 mgOyOTgJFr+qs3Vyie7vYEHWiNaJU1tPzBZXImew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2987/3318] ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 16:00:09 +0100
Message-ID: <20261118150449.880687857@linuxfoundation.org>
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
index 34ffd32ab9dca..a15282b757787 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -465,8 +465,8 @@ SOC_SINGLE("Ch2 Tone Control Bypass Switch", STA32X_C2CFG, STA32X_CxCFG_TCB_SHIF
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



