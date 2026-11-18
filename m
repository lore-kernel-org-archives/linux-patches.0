Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027179;
	b=LH+yldKZ1v0Sc0NDG2QpwqhpC2nl0nPCbCcnxk0bSdoY2zw+oBH1hbnQNbfZwfHqqpCz
	 CefyK0WgR+eU38oWDWg/BPfez9vgtbU6xncAmArJ96xOHMjA3KvXmeikhXHDXMH+28Mj6
	 wmoIu7/1y14yXSji+41aGhbsV07rt5jGb29NsIimPdpsIbzIbGuhG6UPUBvaFe+tUzAJt
	 qfVR7l7lOUOqq4ZRWB5ZFZE1hZPJpTSrw7HU/S1RCddER+eshD/Dy0hcOhrRV7enejuXk
	 0KtqgkC0Mr+K0WAfU+1uO4TxgTYkZFd7D55l4+0ulIVzis+4+afvb7SgfK2t6W4WTCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2QZC6okGPLcRsykAMu3XHcV9etEQm4gThoG59SMSDec=;
	b=c5SuI1m0l35fNjblZJ/YFiNC645WyRi1XYVfxS8wXdfaQ2bS7+D/qFMNnY5/0cPfEVcF
	 ubcrt9qvv6kxO4406ltKyWkSuTamIwkbiw5D3tVSC0PzK5V8jwe5N9mrAak6LbdJIysNB
	 9QryVgQVuwz4TXu6A6Bw0jXvJSi17ptsv8gyphHztD0vcYBtqIJ3k/rtuQ4QicnzACjtN
	 wdNzAimfLkB122pzxsVBcihUj696wggx/L1k/1aRjnQJyyPKYiKDgsjdMtM3J50mGZQ6W
	 EmAtK/Ve5/raLzaBxU9qSH3UTXszBlOYoETsSA01tYuiKfdGtjJGfEXxjHI9H3vUfbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHsDKI2a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C568D606A31C;
	Wed, 18 Nov 2026 18:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHsDKI2a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A281F000C4;
	Wed, 18 Nov 2026 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027179;
	bh=2QZC6okGPLcRsykAMu3XHcV9etEQm4gThoG59SMSDec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHsDKI2auDMN56gH3bnPuiI0YguPbLKkWiT6XIhJiipzLYelqdpm2qKZCvc9H0jWT
	 TVblE0r7f9wcYqz66zYtwKsc74aCEVjN8csD7hrf/tx/RJ4SannZRIVNmIqLqB24fy
	 L0r/iXsjzyvzcI4PzRTidKvrjZSgzoYGRLaZJXc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1699/2151] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 15:57:14 +0100
Message-ID: <20261118150223.717079713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d1450de926524..ee67b13ab35aa 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -481,9 +481,9 @@ SOC_SINGLE("Ch2 EQ Bypass Switch",
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



