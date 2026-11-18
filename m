Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026670;
	b=o3Q4AajO5dpxXD0pcRubFbHHlCciTzbTb1DFAoGu76rtWk6sFmdmDMqWxNfttpyZVIny
	 C1IaxrGGTw0L2shE5+dAGgzOrXgBQLqAquC0o4YqhXN68dI42RIx//naMGepffM+0+/K5
	 yaBqUPOIOnNukHviZ8iiQGee3zGEvRKXsvkmQsUzreYi66ZubB0EZE8czZIubLixWphQP
	 IArQt8TuqeF/mq78ThxeuoyxtesqSqEWtc0Wx1K9AqItrQ/NWkkSB/ifHK069k3fZ8nnW
	 rld9Nc4s5qv43qhu5AiJ2Wa/uxVZxPNsUaeUrQOY8i4KkmrN82zNcQDj3fZ5B6nTb+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9QaYR5sb/blJBs3ZQEBTferhCTNf8IGGicjGwL8+6lw=;
	b=DGAeLNSKPgUUJBibUPDAucf3SbcgA9piGVj3ya67i5YFBKJn290Dtfh4sEEu8oSd89hI
	 mOIFyaHx6oCd+71/YfHsrpQAWFCGzWbTwbEMBNKu5BQu5G97lV1dXsZpMI/O3FxE71L42
	 O/X0v3m+b2q5W7Trdd/rcWNX1a+CxJp17LYgMkxV8ttVRiDSkxVYpC3S0beZ1pSFLVsGl
	 KM3Sju0f3BmqRZa8rBHRWnyyCYpg1EJToi8Wms1GEErpN8wjBBlFSuBk7f5nXPYK3bQSx
	 UkXOq6d6f2DIwsLzlx6hVeIJ1SzGMGSsA/4Sx3alimEvSJUQqtdcMn6rxfv0UzexGeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d3YlwG4w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B34B606A32C;
	Wed, 18 Nov 2026 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d3YlwG4w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728C11F000C4;
	Wed, 18 Nov 2026 18:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026670;
	bh=9QaYR5sb/blJBs3ZQEBTferhCTNf8IGGicjGwL8+6lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3YlwG4wzXft0G7PAQn0B7aMY4VGJdsaWkn1Av8OuJIh7GnEr5+LwX68MlbAJoyYt
	 StRT5xM4gYVqhe8g8V2b07tukvh1vaEYHev/Il5ooo14iO673X4XqlqXYKDLfVMKzI
	 hS4KFw0glDXJ6ktuUBLPdEj7J7+mX8PwaFFotc7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1510/2151] ASoC: codecs: wm8955: Fix definition of Treble Cutoff control
Date: Wed, 18 Nov 2026 15:54:05 +0100
Message-ID: <20261118150216.861195018@linuxfoundation.org>
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
index bca83410b4327..c03fc48c6f6b5 100644
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



