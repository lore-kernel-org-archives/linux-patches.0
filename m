Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035973;
	b=pEiC1mWrTl4EBmu+vs8k9dH6zhtT6HgJq5d/9OiIUGnLnAt3OUOxh306EAy+iMNKVhKS
	 MZIAb4quIVDDpF+upkq4XijVxUGl3RLyUde1szaAcEXFuX6cuVC+KNCkw5RDFTLyJKUz1
	 96MZB3K13O6PCc+ABV9lOf4jw/qg03OUvAQLDTEp1yR/FziJ6vSeCKE//LYIVIOZkthAQ
	 Lftf+Go39qSPkgR9tL/DGo3jTNm0zSpaoYojKiwnI4upr8Kb+CrQwhuFskL/ljvuxoC/i
	 nOyKgjX8msusuJbw8wSE7URB4a3Qm/wm92T+bw+R3vq6XXidY+kHGNazU9PZznLFqyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgkISV3Oq02XW/4cLWdOzbS9YJUFbVTrHrqucre3rls=;
	b=RDx0nmer64/wIcBcH0q9l4CJAWEXgCKiJ7Cj4p2h0VciGSO4wnZxjhlLU9JxAK/3Z1lx
	 oMr5X3YT1zn6RwnuSmPfyc8rlxkQJtSJtBHa+a61t2ck6OeoK02f78YYM+jwigLSctJ6y
	 3oLfBnUkKp9UuX6CGkcqtqy2aDppThbaHC5x/x33EZTTXZjsIbB41FX+jRs5aBe+nQdb3
	 FV8TKsViKTqHgrWmeEh+zedsLLNtFURAaD68cufNtn+PI9yR1Nobb+abRbFrQgvIcmc0v
	 VrvhNsqlemaGZ3w4jLdyXvktobpeBGqKeLy8FIbvh9mFfcz2N6pbSPfcOiy8/DwOBBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuX53Fwp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4633A60A2615;
	Wed, 18 Nov 2026 21:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuX53Fwp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9614A1F000C4;
	Wed, 18 Nov 2026 21:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035973;
	bh=ZgkISV3Oq02XW/4cLWdOzbS9YJUFbVTrHrqucre3rls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuX53FwpoRut7gFVCWOJEdGr1iak1LxMlleTE96CaKQ9vRbxDcDmdHsKuGVvQUJ42
	 p8ak38tjiTi4q1KqFv7lx9QjdJ4ZWx1xPYUbLZHz6BtyiLFIKs1qlah8wN/K26noQN
	 g+DPNW4y3smU6ALvYJpoxzVzyd9p+Y8gxRomfKDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0894/3318] regulator: rt6190: Fix runtime PM imbalance in rt6190_out_enable()
Date: Wed, 18 Nov 2026 15:25:16 +0100
Message-ID: <20261118150346.263722819@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e0d673e5a5c4084f0da90c06ed3b0bc45e47d679 ]

In rt6190_out_enable(), pm_runtime_get_sync() is called at the start of
the function. However, if any subsequent regmap or regulator operation
fails, the function returns directly without dropping the runtime PM
reference, causing a runtime PM reference leak.

Add an error handling path with pm_runtime_put() to keep the reference
count balanced on failure.

Fixes: e6999e7cca7e ("regulator: rt6190: Add support for Richtek RT6190 regulator")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://patch.msgid.link/20260916072541.1968033-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rt6190-regulator.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/rt6190-regulator.c b/drivers/regulator/rt6190-regulator.c
index 3883440295edf..bf99e18f6d5b0 100644
--- a/drivers/regulator/rt6190-regulator.c
+++ b/drivers/regulator/rt6190-regulator.c
@@ -109,19 +109,27 @@ static int rt6190_out_enable(struct regulator_dev *rdev)
 	ret = regmap_raw_read(regmap, RT6190_REG_OUTV, out_cfg,
 			      sizeof(out_cfg));
 	if (ret)
-		return ret;
+		goto err_pm_put;
 
 	ret = regulator_enable_regmap(rdev);
 	if (ret)
-		return ret;
+		goto err_pm_put;
 
 	ret = regmap_raw_write(regmap, RT6190_REG_OUTV, out_cfg,
 			       sizeof(out_cfg));
 	if (ret)
-		return ret;
+		goto err_pm_put;
+
+	ret = regmap_update_bits(regmap, RT6190_REG_SET5, RT6190_ENGCP_MASK,
+				 RT6190_ENGCP_MASK);
+	if (ret)
+		goto err_pm_put;
+
+	return 0;
 
-	return regmap_update_bits(regmap, RT6190_REG_SET5, RT6190_ENGCP_MASK,
-				  RT6190_ENGCP_MASK);
+err_pm_put:
+	pm_runtime_put(data->dev);
+	return ret;
 }
 
 static int rt6190_out_disable(struct regulator_dev *rdev)
-- 
2.53.0



