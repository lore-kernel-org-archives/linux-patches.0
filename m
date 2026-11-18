Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050158;
	b=KxLTtEfIpUx4v+q4tppE5uRSMo5TYU7Pa+P+OMywD3OyUdr7KC+IW88wKJCZ8h/snJuX
	 CNUKMMEfF0CobMK+d52Vm3SUYHgPO5qNigaFc2u2VyxGicrG7IP6R4CxfNmfSkIMuXEXe
	 mcbO15utW/9z+KXaFpVntmFcy3chtzK/wUjknCzubxtWJCBnEOPJSWBkbq7EgpMpk0udW
	 UPISTThg37+5ep6999jpLstXhTcKrOvZlBuvRk3lySZQSW6nt4wdEqzROc8Kx7DBt+RfJ
	 qKSrD06rSieAeYf+E3KctN5GhMRXtsrxW+X9DSR9dcwOfAkIDIMZAE7WPypY86bUKPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rGB5z2rWFni+8VH65aK+PeqGiswE/5AzlUMSK8YlUJM=;
	b=b90zpSDyNt9j6/oIR2C+vCbj7Iv4KKcmett/bKPuGhuZ7RRCgnm4lrnYDM/IBb3fNO1j
	 MOksCCUgkM809D2KbmROGatAJZjw4AiMjDHQuMGCStjjm1mGpRNiZInSZ5FHt3+x9QrFv
	 AmL0LRhB7UPil8KThtWhMtCGSzxRU0cmPEc4dozXoaP5RlCUy79M8uwBjIiEy3KzA9bK5
	 PpADO62ASG8X/CG+dfYbjzAS46feIv3VU8SImZqlo0Ol7uIS1qTz2ZDRf6ydyDsye0kzP
	 TINyXvC4dJbu0HRoTL8jFiKnUjNu4b7nmI3a7wv/MevoFX9NDDq82q5WzMTltHzuXRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMHCp5dB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023C5606A332;
	Thu, 19 Nov 2026 01:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMHCp5dB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518791F000C4;
	Thu, 19 Nov 2026 01:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050157;
	bh=rGB5z2rWFni+8VH65aK+PeqGiswE/5AzlUMSK8YlUJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMHCp5dBXya6+UVPbm3wAqywgGXWGMklSmiCfOaG67/qYp7xLyoMB35IwP5mZrqtH
	 +G+EKSVWJmmJEa9Gh92PQDhkxup9obU0Rl9DHKnDkaAICBU9LueiewrlwGyByss+fM
	 wt3VudYoDAOmaFQ/iyYdwdrD8UqF5LZuJUXiqMVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2581/2857] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 16:00:15 +0100
Message-ID: <20261118150334.427458717@linuxfoundation.org>
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
index b033a5fcd6c04..b64ef956ef778 100644
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



