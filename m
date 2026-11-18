Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049782;
	b=O7W+xufc/cjjm86jKkg3B8ZgaPXoqddN0xUZVRj3DqLavOSM9Rh45/QSXqpA3V6OpiIa
	 xNJ8unV8kp4GYeVG7MIJbgAL1/kRoShBuQ2gYVgvY29GaycsxHXlClv/e5lSZ1zDJqZvL
	 EdOfzZxIHTJIji33adwDNhtVdfgo1VFCqXVu8yIqhVcR8kCHGzbaLhvYXM7EWsOqUCJH6
	 6Hs6nrg0sNs41+3nfZ2XcrTFfIh6BjND7IaM0oRGA9rvtS1OSGh7/R+WDQKbsIUShzo//
	 XjEDzHPMjI7bbRUkd3SBq+zB+Ey4uXZEypls8AArgJ3g45icuy9U/IO51NNqH0MRfqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsOk4fRlshchtbeXDO673fQupdnpfWmm6wrvAx6lQvo=;
	b=rJLyW4eH/dNCHTfSiyoKZxLOxsO40qjzXWPQmsR2ZEoV2Od/mut45YfLAf1uAAjIojjQ
	 brgPS3KsoYS9vtOHd6mwFg/k6GdbrrmiH0peKDHLK6i/pIYF8Uu0OY3WnaXLDNOm0g8gQ
	 duq01H40rmp5z+f6mi55EvvaCqF4klSkhhoHMZmPQSvKk2wexm1TrBIztpcvF69xsjytU
	 jMt0K67yU9qE8CJhGaPcGjVVEJYTIhJ75TmYkqy1Xog5MZTu1+jTzln5ra8ofNuMgRrMq
	 oP7YA2Bm18dkgTLOnbIcTpSr1qy4FO+1UmRv+3ORg0sk0UjLjdyPptUMyOD2koFttTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GheOpTvs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E77F606A31C;
	Thu, 19 Nov 2026 00:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GheOpTvs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A579B1F000C4;
	Thu, 19 Nov 2026 00:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049782;
	bh=IsOk4fRlshchtbeXDO673fQupdnpfWmm6wrvAx6lQvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GheOpTvsKp3WfWkFCCq+5hBdfvTY3ip3+xSzsG5PmoUQkRnaLWGyemtmYR7/YmC5b
	 IClIdSJpT3NErNSDQ6hz/ms1KUw16u4h7jV4/p4v3UBk+39J7eXhaWU3DrLWwzdL/t
	 zlKzKtfXnrmE20B9zR/K9OIDPWbp1eJ7VkF4hZX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2474/2857] ASoC: codecs: wm8955: Fix definition of Treble Cutoff control
Date: Wed, 18 Nov 2026 15:58:28 +0100
Message-ID: <20261118150330.640740985@linuxfoundation.org>
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
index 05ef45672ebc7..6fbe4e2b6f03e 100644
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



