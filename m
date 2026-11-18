Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042041;
	b=Tv98YNV/L8cNQQs3yDBwpjjgApQEnvi53buU0UnqQYEKWPioymMStMz129P4STJtO8Bq
	 4xGs835gOpOIhEErhSVMzxCsCMVi6wUtqscS3xvx3+Rl/v0TpnwaS90YAn2RLgMq5g/y/
	 R3qa09kOESoEDBQ9tV9i16oj1gu9tJb7Y7m4kjtnFgAW+PMpct5p0F+bWMrS7Mbbdbt1X
	 nLCfKNrKC8CwNfx0CKUsL8qYtgf8w8NjJwAJsBtsh5Q66do7vv4yQy13389QwF99zps4c
	 npNcPfnMxcy3+ihE1EBsL2JjHsKaID7Gequ0jYcsjTR0wquZFaMZKDoqX//9WxZzWig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RCbYFuVbQdxEQ5M8H4yfulZnzTfWQutBpXxHqR2N+uM=;
	b=G5JOFrRoxelvfxwfbmJOycK8D4vnH7VK1BPuLA6jzslU/GjGCzou8UwLqVYmJW1Y66d9
	 eCGWoL2v7ntPQ6ZwnplDxx9fO4EoGpKiy9YMJm9N8if2qDEeoCp1m6uXr7Y0+K57XtBSz
	 4JR5B4X3fswccQZaI3/ZeQi/CGEtMWPzlfVFKeSycTR6vtZ0aoQIgUVZmJM8r0u5StuOP
	 vH5CVn+mGqYL1nyQY/yJ7pa2h5/6m3ylcTDrSR+jPHgN9LrdUihg5tLSsdQfXdDpzru33
	 BQZsjHnVtqFUpnjdIbW6CI8Dq3ipKSeThhRZlihqHp+IsVG19mGmkJARll8q8Ij7faw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRjPnqBT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A60D606A320;
	Wed, 18 Nov 2026 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRjPnqBT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31671F000C4;
	Wed, 18 Nov 2026 22:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042041;
	bh=RCbYFuVbQdxEQ5M8H4yfulZnzTfWQutBpXxHqR2N+uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRjPnqBTGPeEs7d1j5mPmQoCHn46TIbo+6EkDt5I0wHClfgxaw9hxjf0j9Eoh3Exi
	 hksiFc8xJJHvNDNhH4IG7PiU0SKYIDRHsIblfCXLQmKBn5DUkc3+7PjhdXmSGamYN/
	 lWHdMmFapYZ2JTmqSs40s4/j/n4IKRU/Q0bEqgIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2988/3318] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 16:00:10 +0100
Message-ID: <20261118150449.909937937@linuxfoundation.org>
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

[ Upstream commit 7308ce7c8459e994a36a22607e974e3e132a9275 ]

Each channel's master volume bypass (CxVBP) is in its own
configuration register, C2CFG and C3CFG, not in C1CFG, which holds the
channel 1 bit.

Fixes: 2439ea1f0f8f ("ASoC: sta350: Add codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/1107a42a563459b26038bdff4d8f6e2423816d0a.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta350.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sta350.c b/sound/soc/codecs/sta350.c
index e4a9e9241c607..c3d407b168539 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -482,9 +482,9 @@ SOC_SINGLE("Ch2 EQ Bypass Switch",
 SOC_SINGLE("Ch1 Master Volume Bypass Switch",
 	   STA350_C1CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
 SOC_SINGLE("Ch2 Master Volume Bypass Switch",
-	   STA350_C1CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
+	   STA350_C2CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
 SOC_SINGLE("Ch3 Master Volume Bypass Switch",
-	   STA350_C1CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
+	   STA350_C3CFG, STA350_CxCFG_VBP_SHIFT, 1, 0),
 SOC_ENUM("Ch1 Binary Output Select", sta350_binary_output_ch1_enum),
 SOC_ENUM("Ch2 Binary Output Select", sta350_binary_output_ch2_enum),
 SOC_ENUM("Ch3 Binary Output Select", sta350_binary_output_ch3_enum),
-- 
2.53.0



