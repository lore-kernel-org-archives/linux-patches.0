Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062019;
	b=HFpd7P3IQxY7h6B7iu6QO1wuXvAwAlIHQCl+NYo/Ejbv7vXcmJ6Wa7LVlQFJ+YqhTloB
	 vQmFT58SzpWLPO25vLiiJB1XGRjXSVEGCI2A4q4FL+OWP2nKTYXQDtyVyryN6vK05NLRe
	 K6fkCftF3zLRYHRZjbCL59TXvOuudmcO7k/NgrqMqemzOF58MRlumtyOEMcJQO5JFqw1E
	 FbpPRwGRnU5ytONWX0wRQoE26SFQTPlK4rP4RrwHloPaPaEcY1xkH5+gUy+ab8B4SxKJf
	 SG/gPoSt+A0TaqOIBgaLRBTmIrotgpolUr31ThntUk4h5K2CvnopQvwixKUomBs8FIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GeqwkizjiTcXzYtfKtJwQp2Xnf+Wu2DcUlKide0kkmA=;
	b=l8y0tGji+EmNW98xUoX7ooCicG4DWsz9CiVyAxRX2y2FQNaLIRPUVuylSbWo0EkSh7Au
	 3uAD3xromKoMpyEIf/Ccf6qFlLgp+P3mjSOACzbAby/lY8OM0tWUEPq4o0Io6+RRPxcuJ
	 5WbHZ7BNtrDouQqbybA0nxe1jvaPjU2TXP6dhNX35WpIpMyc/26XH/U6pt95ojqHfe5kG
	 NsB5W9khF+Z30SIx+OavLQL7D8xhsHWTaWrqhERsbvmZHR3Ce4MG2Z0HmEtm+xeC6U8aK
	 4CEnwwkD91SE6LOvhfD8zamva8fimtASW41i3/gDV2McpwfNnG13JROBpCxIa8TVvzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqUoe+AR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DADA606A335;
	Sat,  7 Nov 2026 14:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqUoe+AR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F9F1F0089F;
	Sat,  7 Nov 2026 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062018;
	bh=GeqwkizjiTcXzYtfKtJwQp2Xnf+Wu2DcUlKide0kkmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqUoe+ARRCImdvIUp28ng/7j5uPYeXa7HfqWkobQsHtz8dVqT0s/2hEwZwZsK26OF
	 s+gj8XDlEZ5cfPAGPrSPx/Xph1x6zA2WOHs86t6IS5U8xiYHwSP4Vi/gNsh1EXKZMR
	 g2bGwzA6KR5AqNEG0B2Otga5mYzr0FXbKsCDI7Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1007/1536] regulator: rt6190: Fix runtime PM imbalance in rt6190_out_enable()
Date: Sat,  7 Nov 2026 08:50:23 -0500
Message-ID: <20261107135025.955675702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



