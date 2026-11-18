Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029464;
	b=yWDRpcYJ1QWXM2AuU0qaOOijxBdcUB3yBRc1km2U5fCv/X5mKalXl1REHkoGKAspG9l0
	 xU0YlS7p4xd8ICgqpOnKBUuAAKMlzhl7s/DJRSvviPHXffTluWkwlKUHYoeP6IMY6nZ4Z
	 M6S6Ora80so7/YJWaKdZbJEHmLLtHp1Erga/oGiQpN507v/0I8fbSZBUAHI4t8TEa+mim
	 6e2VCVFQQCAuSF60JhMGbIZeLEm/TxkTmUCqF0xG4TskjXdV+rCHbpoKKa9VPshyK6PUZ
	 BlijiI23gHYdvI00nmfv/oZwkrc5DhKolKAX3t+A6EGPThVfo/0wIHRDcFhUM4pm3mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mUdwE5OK6N2vtKA6P6uv9wX4k12s/4Co2cWAE2WOIeU=;
	b=okPtPp5KCRrWMnjwkc+peGKVhRe33OOPxw7rb+Jyo8YyUJfxpJ3uja9J6JBTdgLTQCL5
	 NGYQxbyR5ueRj7TcS6NNMB5PYoWwtHwWdhvAGWDg0PpeW9LeX3zu/4JLEtqH12wFbUi2k
	 rcGyJrMnZSeOy1ArynFbR0Nao+QFj4sbRIvpHa9Ri3mgCEA7qtjvaGevZnFf9/7zH0s6k
	 6ImaycfCtZg773chXy/62iq5QWAVaPkZ9oCmzovOVyZTXwcngGGVY/lSShlIihUJznYp6
	 EQiEBeJh9u6WY0R71LjNlxT0J+csRwTMm1BqMW0+TD/yhRGDIblezLUTupug2Bwb+Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KlgCA/T1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51379606A320;
	Wed, 18 Nov 2026 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlgCA/T1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605B81F000C4;
	Wed, 18 Nov 2026 19:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029463;
	bh=mUdwE5OK6N2vtKA6P6uv9wX4k12s/4Co2cWAE2WOIeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlgCA/T1fSqNrQtWTNkgs2PyUrAhQqsD6qpaCxA1iaGcaNnqEtCtdZphBBMeav5ly
	 U+pnx9QDNeCNRR8e0Tl1xhf31Fg6mEMYT2dr+JhCqhN3lmntulXDGSlP2DGTqNIuc+
	 cdu8BVTRVp7oNMno3uWC/NuEt5KXUuglTQtl2sVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0358/1756] memory: exynos5422-dmc: handle clock enable failures
Date: Wed, 18 Nov 2026 15:41:25 +0100
Message-ID: <20261118150022.587753280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d80322754fad..068c68da09219 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1297,8 +1297,15 @@ static int exynos5_dmc_init_clks(struct exynos5_dmc *dmc)
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



