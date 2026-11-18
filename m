Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041571;
	b=kHRHNQUUpifaMABaDjDYXvVomwg2KEzauNqIPQId9AemD1HBLcoj6mcT6b7KHCc9gTJR
	 U3jmLIvkDJYuJk6gHtcv0VqQBU9FE5tKQehGP123Id05WwdnR5xYZNuZj2H/12DSM7bnQ
	 b8BjmpP74sESrBnPVxo9cIVztnu/PzgokQpliv4dGPmUJgiyH4u1jvIYTx/5s2sJEiukE
	 TbMIZyadFJIUzRY7tjx09nw1Ylqo15QUenajWKtXrSDRptScmsINRupnkxUWv0jukN+bP
	 dHLUcoRzQbJdzN4bT2J26ZkaKhTxrZQ2U++bv1P4MiJnNJ8H0fobKiW2Y3DMytZ50yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PMoxX/NzJ4Bf/1n81GBywP31Xqg70uADPCJrODJaCqM=;
	b=gFMCcOULen7CUtEcffDCH8cY/72hSuEPe6Hz+Eynro7gDhmS3FGQXJFuup7OQUiiqtO8
	 AzOiqzH+MH/crcZiMEm8pJAn5xNDvyrBnH1q8sUaMByvTONUZpipZInR6uvGJ18nAZvB3
	 Ci2wqC9oDKhfgjQnkxpJuzj/mlUAjcl+4LaewSUbJSxUA/SzGFUOOAZ4LKVRF9Yt+RFhl
	 E8cLIAP173UCm9g4YWwciEdf2h6rBiuNL8tjldZpNDjwebnBLsyZsJJ3Q1l8mI12w1s0r
	 foKdXZL83073ZXXWzSGxyd4Eg5RqYWFBDUW7o5WkvCY06pIgoCybwhesUcQxzN1ZE7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wu7sei9p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C64606A332;
	Wed, 18 Nov 2026 22:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wu7sei9p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F39A1F000C4;
	Wed, 18 Nov 2026 22:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041571;
	bh=PMoxX/NzJ4Bf/1n81GBywP31Xqg70uADPCJrODJaCqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wu7sei9pTCrYiz5a4rMdMAEF3C7DEyc68/OZ1L7j598s46DZOQixTNbEOL5OUVs+g
	 TH0VH8+v6z0SbbbjqWuOwG9uSg6TkRY6Bj+WmSBpKNB1Pj4x8fRAj1hE+Hc0SZbFiO
	 wY46sGpGxCN0D3uQLK90H8bA+GQonY1gyCTyzFxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2862/3318] ASoC: codecs: wm8955: Fix definition of Treble Cutoff control
Date: Wed, 18 Nov 2026 15:58:04 +0100
Message-ID: <20261118150446.441500874@linuxfoundation.org>
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

[ Upstream commit 71911bf5bb3fe97da2124d17fc1dd3dbb9379e03 ]

Treble cutoff (TC) is at bit 6 of Treble Control, not at bit 2, which
is part of the treble volume (TRBL[3:0]).

Fixes: 54db41c116c3 ("ASoC: wm8955: Use SOC_ENUM_SINGLE_DECL()")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/b398bc6dcf8dc2b93504608cdf952823ca238cd5.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8955.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index 4f43383264386..e0c6362db5cc7 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -426,7 +426,7 @@ static const char *treble_cutoff_text[] = {
 	"High", "Low"
 };
 
-static SOC_ENUM_SINGLE_DECL(treble_cutoff, WM8955_TREBLE_CONTROL, 2,
+static SOC_ENUM_SINGLE_DECL(treble_cutoff, WM8955_TREBLE_CONTROL, 6,
 			    treble_cutoff_text);
 
 static const DECLARE_TLV_DB_SCALE(digital_tlv, -12750, 50, 1);
-- 
2.53.0



