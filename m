Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061942;
	b=iNJTf595KCA7yhA9FMvBs6tbuP8/FJzISj5IVvE12eGH7lszxY6/a+fZDTVfsfumdEVO
	 Cbsj/fQnXH+6w49v0kQkrBMryYxW7cZC9l2CV3Mz4dA6tlvDHGB/6e+Y4fgGhEHBEZgKB
	 YpUQJ8c6UvgCUfmhZPVu19EB1Rc1Qcg96lLjNFM/EdKl+97X+LdGqkAUpwg+ZKDFqewU9
	 wU/gNKej7lTqefiN6DFeuxyXC9KoGa6Yca5kRlmlP7EnCKkajM/nRyQNZnZOD3QIlssEh
	 o0FW+0Qq1dvm3sYD7jOwy+qc6H3oPb9EO8Hpkqcr2nUmWuIRQcaaM6upZC3Glal+vXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qnweFmhGNMaYo43pM2T7zAIxLFoH3y3/oQe2uKsrDJQ=;
	b=lQ8q/YNH0sJWtF+0e64vPp9f33yAiHVSS9cvB/tzHRIDa6zTARHLu8aL6BgO0UrSQ5fU
	 YPXauJRqlqv/P7TC03OL+Ob69DZz4Fj7in4tHGyNamXFXa5Nppxo1U1bC+pDM9RcgY21U
	 qqDBOb1LtEmYkKkIfTmk+Qti7iMOnBCW7cPurVm+J9XMahV4L7RIE35/DKo0tK7ScoSlx
	 HQRPzW/sg60QSGWj40HyvLDLpzb9wWImtjOoKFlH7qcVid30Nv1B+CNpfi9z+5WcYa/O9
	 fJHslolFTOISCAxYKdg9+vnP3SMnn0Z22exzYkAT0LKsVqKC6QnapluXmahD9tbcNpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7xxgmC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC16606A325;
	Thu, 19 Nov 2026 04:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7xxgmC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BC91F000C4;
	Thu, 19 Nov 2026 04:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061942;
	bh=qnweFmhGNMaYo43pM2T7zAIxLFoH3y3/oQe2uKsrDJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7xxgmC5mfvifQmaTXNL7/7knbxD7cUudSMgiAsyY8NP4/IL5/QSVseP6H6FSZlyd
	 bOE2Tg3CtAV9f8w5zMM+ihNHdJ3hVsXULO7TwnKKhWRSauLuK/pi7OcIP1txjTP6oT
	 JErcVtFHLXeK5bx7Uz6ApzaLlw/pTFFkeFdil1YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1692/1848] ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls
Date: Wed, 18 Nov 2026 16:02:10 +0100
Message-ID: <20261118150030.614075866@linuxfoundation.org>
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



