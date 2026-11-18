Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056517;
	b=ROEUQxkMtf7nAyqOEfaDHKfn3Sn077aW157B7ZQTrpavC505sxQ0y/yr4ulb9z697dNh
	 k42HYt9gZrBzILM6zGsq4T5gUMxa1rScTDRjys7wvSC3AqbJ9NWli3KTba2RL72wWgoD4
	 wrJU5XrfGga9r606dGy/LdqHFz6ns6qDAQHWSBDmBgSAUj9W6jFSnZrJXajOyTAqVyXxe
	 +DMEzjKdqx1ItK8qBiDzwufmdrDtT70SMgJJjTEgw4vrD7wjVdJDwqkY3wBLXlMwx6jBm
	 cQ+73/sTOfR/GrE1PQC+zEcEFzUs4V3FlgYN+5r14YKqsQahnEZNgU+NsfjHkGjfIUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bh/yipLbSq7kJfFt1zXt87lKkz4UKiMfn0QHIya+B/E=;
	b=Bh7hLJAhxuWdy8FiiW8TumsCrWoGeMyo18ENYWTgH34iwN5N2c39EfF2Pt4MP+jcZC63
	 +AzbJ/SdLga3uZmxaf6JYGQUvLiLKFxi8EJckkIXtfA6gKsb/MHfFAQSaWukI2OYZdUKd
	 SWYKEXPg0JJ8Wk0bwCeR33SjGhCFzIZhIBhFCVy2dUvdGxhoL9HAKww4s4pYwUglDiInJ
	 uKBACjOUQvyfP3P0MozgOL22IGf/70q2jdLunkGPgUsXOmsL9D2aBWcytVkc79rtNOHTU
	 FbX/NaZ2OIQimfLYfM35/sQiFyOWqge5saq1czHugTSx2FJ84viF6i/n5G97vjKRnnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JtZJZMvP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8B5606A336;
	Thu, 19 Nov 2026 02:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JtZJZMvP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50CD1F000C4;
	Thu, 19 Nov 2026 02:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056517;
	bh=Bh/yipLbSq7kJfFt1zXt87lKkz4UKiMfn0QHIya+B/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtZJZMvPAXwV2ja3ZZM4KgE24zU9+tMp0+VCUE/nO+C0mBeoL+YfyFEfCNeDB415F
	 TxL6dNBpqkfYmHtbttb7fIuKLwGazP5E82ss0h8XoJeBuj3tGa3ZzKC/VwSsoIVSSu
	 frZ7a4NTzXItBTa6KdMDsRWKrz5MKTYbo4jBzaUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2016/2214] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 16:01:32 +0100
Message-ID: <20261118150131.383918186@linuxfoundation.org>
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
index 75d3b0618ab50..cc9c64bfd4147 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -485,9 +485,9 @@ SOC_SINGLE("Ch2 EQ Bypass Switch",
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



