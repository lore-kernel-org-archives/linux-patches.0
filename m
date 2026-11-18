Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060531;
	b=HOj6C1LypFVvttl6MyzhHYW41fZvWhfylBGh3NPuhHIx3pIskOwcZJKCNvZU7JZIFVpv
	 s2HA1aCXZwmFgmKT6vQQhq3FmE0FzxLD+r2dBDv+QZz+ackv1xn2U/3iDQUnJ40zX+isX
	 wS43ZfE1FD4xUmgdpc5hkv7K/AIXDB7uLjO9cf8ch8qoKywlA6D6Lp2pq0aZaigoZI6Lr
	 69DIJsxej5k93oMlyinrV799d0Y6en5HaftSyZkFaRfa7r5A6z4HtBECi6C/ocUmdOJvt
	 wkEZUIxr9jci/AjutfTEawdtYuf/ERujob45AVhFStO7FBR+cpQ+xZg6ffL9eBijlqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jwPGcyO6ugNDXQNODt3yrKjn2bYtVrtMQQItj4/cEQs=;
	b=bQ/LKaqcCTuyZpcseAFIjjG4HeccdZTB5014uPzPbvapo+7ukCxqjjwfLlVY/V9Obo1r
	 Ci4Obqw0TretLuJQExi4wpdZArPTLc+MqHR4aEWY2aZczR/9y7EXvKZvunt6uiMTbAaZ5
	 f3PKv6bcKRE/nNLo+AUA0KOeXxsV7XkJwaPhWLRVdvIzAuCNRtJYXmQpj2YBLUv9i7dyW
	 QWejCqQNTZ4LXZawiAgVPKZ/VR7BqoeQrnmiNa1y8PSiaqF6AcHAM58dK6sKbYq8hLMif
	 kVBVVfJzXM098Hc99LOY+xFGZQjV22U5iJTknN65khjwThQhFmFhS6snfR2QkA8ErZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IHTYlagz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64C8606A320;
	Thu, 19 Nov 2026 03:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IHTYlagz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8CD1F000C8;
	Thu, 19 Nov 2026 03:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060531;
	bh=jwPGcyO6ugNDXQNODt3yrKjn2bYtVrtMQQItj4/cEQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHTYlagzZQ6PAYumqYq6aIh9Q8xhpiAjyP5TCCr6GHFO/lpPMf5SZadp+A93Y9luf
	 1wUZRqmk6/x0gPPTItphMKyaBP0Pq6TlCzipYXGwpcqSPRi5HOFOMOPXJyowOaxa5W
	 DzugzDnR9paFRuQ4Oj+YBenhcZEDf+IeKPrQWQ8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1231/1848] memory: exynos5422-dmc: handle clock enable failures
Date: Wed, 18 Nov 2026 15:54:29 +0100
Message-ID: <20261118150011.424893051@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit cce46902ea9fcd585cd200fffa3166f63bc571f1 ]

Check the return values of clk_prepare_enable() for fout_bpll and
mout_bpll.

If enabling fout_bpll fails, propagate the error. If enabling mout_bpll
fails, disable fout_bpll before returning. This keeps the clock enable
count balanced on probe error paths.

Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/tencent_B0189529F550458590E3BA614EAB800FBF08@qq.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/samsung/exynos5422-dmc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index 5cec30d2dc7db..1c856b101e8b4 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1309,8 +1309,15 @@ static int exynos5_dmc_init_clks(struct exynos5_dmc *dmc)
 	if (ret)
 		return ret;
 
-	clk_prepare_enable(dmc->fout_bpll);
-	clk_prepare_enable(dmc->mout_bpll);
+	ret = clk_prepare_enable(dmc->fout_bpll);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(dmc->mout_bpll);
+	if (ret) {
+		clk_disable_unprepare(dmc->fout_bpll);
+		return ret;
+	}
 
 	/*
 	 * Some bootloaders do not set clock routes correctly.
-- 
2.53.0



