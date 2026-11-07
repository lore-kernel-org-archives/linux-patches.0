Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064055;
	b=2quUJf7xsY/41GHUSPLk5bGzxrTMI1LFMgX9yO81Lr9hmR+hZMchHJdM2IUF1qfmrA/d
	 3ybWocb9T1lH6Gxo4W7TB5eI2MbQ9kxQZwdIGswcLFPKQG00jZvWhZohjqTvZZfj2SJn2
	 Fkkv75QTHMWCJOXNiiKqny5JaaWb3jQQaHW3WG7Xg7yGKLQ3DFT0xKqUDuXMjkt/VS5Ob
	 TU7PWVuikZLyn1elNTS+Kb7vNV7wo4Pf3iDNLInhnpira+YGUpBLXqa4P0XmKSSISkSDa
	 ymeN1GZ6lZIYFceXWA1swHu6GmuCPXgjBJjJuxB7SzuXsTn0kqOKpBW3bHlPOUGch5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6s1gT/reJhcJ5qbRHrpei71Y2fPvmclakFo4zg86wdY=;
	b=IAbyvwuC+YoNxHEXF7wzKAlpTFhtyPYn3MnBv/VNmjlKt9gk6BnqaSa+hYuHeRy1UXO0
	 LAnQ9ZPPppsnfuntigYeyRy1OQgD0quf79imXLlVQhqkkaH1QAqHX39+Uq+rZ9xHPzPbl
	 ud4aHLkArl00LavxaS3VrCMzZr79gZh4hIfOYhYKKiSnJRC7Em7qbA3FpWwR1qsW6Y1Xi
	 gIuAcGB4kjG1pP4OU0zeRi7hiVNiUFt2qJljK738Kv1gJ5dlb8PrR9ZFkbPreac6tBbZz
	 kuo2V4YLzSHaedE5xfJhhxbhOGx5+SvPQ2/RIUAtj6t5pSH+9jd0UJnISKDQe3zAHeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hM+FOGdc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66672606A9D4;
	Sat,  7 Nov 2026 15:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hM+FOGdc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E9D1F008A1;
	Sat,  7 Nov 2026 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064055;
	bh=6s1gT/reJhcJ5qbRHrpei71Y2fPvmclakFo4zg86wdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hM+FOGdch/IBVEsxH23xaUr+2qWJk3+wxLZet8n6pp7kEduq8tci0HAA23d9R5irn
	 DdWe0emwNhw784mWJMxd7Op1midwNft4lxgYA4T2guJlxq/5CyTBBya8XS4l0AGIAj
	 57oTm5nlA2faLG0baevOwXjop6gZ8eIl3kqdyaK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0209/1257] regulator: rt6190: Fix runtime PM imbalance in rt6190_out_enable()
Date: Sat,  7 Nov 2026 08:41:45 -0500
Message-ID: <20261107134945.314897396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f2cd9540038d9..21ced348a2cfe 100644
--- a/drivers/regulator/rt6190-regulator.c
+++ b/drivers/regulator/rt6190-regulator.c
@@ -108,19 +108,27 @@ static int rt6190_out_enable(struct regulator_dev *rdev)
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



