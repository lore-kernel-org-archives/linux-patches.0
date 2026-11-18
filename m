Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056263;
	b=Koz/XaWkSL7hpBRnRidoRBUjZO5WbD+GirLV+//DjN6COXqXG88WSchZjNh1wg/LDHan
	 NR4I03c1ozeGbGwBKSOd7pYh/6IG+eXP7mMy55b4G5Me4q6oWMFdEAHpn3765sZ515Sss
	 GrM4IL5Pq79c971b4PxQJG+rwXvDLRG8jCyfd6oaBxQkHVFYPdeoRfFFN6yNtCAqA43c6
	 7zQRLVMnD2q8W8NQla2R/ItA8HWrP9TFFAJg8EnwpkwFCgYbwqlx2ANis1NyV6R7KeuKs
	 LM0dGNZqRASAC4Gh6L1d0RfQnyHUV9MHXYvGyVK3Cro4K5aWw2ZwhvsYQZ8ouRq0IUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GNJjTT/9PQsschV5t2Q8+hfgs7q2JTBMSSIdo2LbEjg=;
	b=UXXpHFVAg4pOPoG6AiShc7eQs8gPSecUYcXXWt9IkD/RTIsqLPTXVqXkRDY/XxmzfdHW
	 paXY2poVFZqu5lnWn2bl3CZ+NdWkDK3PFep626LlXLaUzbSvYW/2O4a0G9jAB/fMJNsIa
	 MLY6de1hYxPax9c/uVxX31l9bhvOX+GSr0DNtIM9RK3ZIzsQi/ivFQsgE6S28X51Fl6f2
	 8GYLuAe8CU2PIfCUkYjAd454EUHPhFbq/aOA2yR1zNPIMQ2/o0omYUHZaaZW9dUlNQMhr
	 NmuiYaqrhO6yC3wyJXZ92M160P1K1ghJIxi26HrwIfRYIAx//jct2TiJNCVBrwQkdtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OfTEzMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E55606A325;
	Thu, 19 Nov 2026 02:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OfTEzMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E8F1F000C4;
	Thu, 19 Nov 2026 02:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056263;
	bh=GNJjTT/9PQsschV5t2Q8+hfgs7q2JTBMSSIdo2LbEjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OfTEzMMZTlvpO36C1ZgYrWZgWuslxkQX1EuocauTVgU6NjYSsgvufdu4ZdNFMcvx
	 cQs1wvtHBSmE8fYAToqUFD5PLflMepx5F3/oCNv91oHB1NdbdRMY+Var22cPXX0lNH
	 FzP6IXjR83c2xhJpcyVneatQltsGDF+sJN8S4BmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1925/2214] ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control
Date: Wed, 18 Nov 2026 16:00:01 +0100
Message-ID: <20261118150128.043273617@linuxfoundation.org>
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

[ Upstream commit 8c299077c787c151c5c88928467d8e8d85cebdb7 ]

The noise gate type is wm8750_enum[7], bit 1 of WM8750_NGATE, not
wm8750_enum[4], which is the 3D upper cut-off.

Fixes: abadfc928a27 ("[ALSA] ASoC codecs: WM8750 support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/ce530dfb932d9e8def75059ab9d669360adc76e8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8750.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 9491817020d85..8ea0c039af2cd 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -171,7 +171,7 @@ SOC_SINGLE("ALC Capture Hold Time", WM8750_ALC2, 0, 15, 0),
 SOC_SINGLE("ALC Capture Decay Time", WM8750_ALC3, 4, 15, 0),
 SOC_SINGLE("ALC Capture Attack Time", WM8750_ALC3, 0, 15, 0),
 SOC_SINGLE("ALC Capture NG Threshold", WM8750_NGATE, 3, 31, 0),
-SOC_ENUM("ALC Capture NG Type", wm8750_enum[4]),
+SOC_ENUM("ALC Capture NG Type", wm8750_enum[7]),
 SOC_SINGLE("ALC Capture NG Switch", WM8750_NGATE, 0, 1, 0),
 
 SOC_SINGLE("Left ADC Capture Volume", WM8750_LADC, 0, 255, 0),
-- 
2.53.0



