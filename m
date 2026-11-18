Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020750;
	b=GHiVONDy4Cqb0pYgRHAFg5TNIyAR0DXxRNpA/9LDF3XNNKWzfqq10BSlV+bU6jHWctva
	 d+5bJFoo7Nvm7Sd7Ny0iSsm9CH8rHOq8fEktLFcC7bEpFBdenxS576wLYgbdLr5eyulO5
	 9ZUIOzFTvConTxMpq4B1ar4iYbnW9iQ4MizomrdFTn+yZsR6f7lYvhbdhF23atUW1PSd7
	 Sg0I0pATT+0uIuGk4+Tc2EgXdgv66YISMf49HZhXsK+nVMhly6dX2iYTd5pIJ1KbMLQ3r
	 iN9sE0seNm8xlEFkSQSsw1BBdU/YD9KWkSCaYGJ4Af4uZuPOcJq2VRDnAqMs32r9mGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+b6aAkEmgclwzEL2/6K1lazgNJJu7fmeTqeQkOfLM8=;
	b=D0gTJRoEcAKZbcrS6aXJA1W4DM2ysi3BTbNGbvHkrxYlm4YzKqiNKsbokbSuX9Z6okTE
	 A7jeYcITcnO5motrifHHuTqI2mOVAI3Y6RvzcUw/fCjDzwTnhLkGpPgb8ws5Khy4nvV29
	 IxQz5IRLBUas9GQ1jswUZLGb3pnUWlbrABpSklCG2wFjabAW6JhfMTWkZHSY2zJIyCtNc
	 HJMe6AoULfO64K9wwHBbnZzBNPwDI1lmhmXPn6vFwaPhwO6EYCdudWv7BjHPyDarFWmcj
	 yH29weg+B7Z9VCLLIUosIWrrkaJO4L0gBEjHJiAuGMFBFqa7G2O1LV/kWN5zozeteFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuakLEAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63F3606A325;
	Wed, 18 Nov 2026 16:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuakLEAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B9E1F000C4;
	Wed, 18 Nov 2026 16:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020750;
	bh=3+b6aAkEmgclwzEL2/6K1lazgNJJu7fmeTqeQkOfLM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuakLEAmPG/k6Qtbd5up5gCjx2/YcjfAWJBJMgy40LB0/t7Ce51EokxFMF9BJ7vsO
	 AYs89Hp4ONMUY9SkmW0xtthQOaC7GuY825XyWQbgdh2M9uV+yrLF7/I4GKC/msu8D+
	 YhxEx1eWABz8f0znZapLELrIh5E5ElepuFd4KWbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2064/2651] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 15:55:04 +0100
Message-ID: <20261118150400.359419610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2ba35076732b0..464ef292c9067 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -477,9 +477,9 @@ SOC_SINGLE("Ch2 EQ Bypass Switch",
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



