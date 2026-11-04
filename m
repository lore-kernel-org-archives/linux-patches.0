Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829387;
	b=QQqjTW5NhOvF9ZNeXoXVu5p1Gp4JO/IsWHqTNiK7+s0yBOP9tN6GKkiSmiALkNDIoBR+
	 VSZkUjmljgLPCMW53CpM5Ck+JtY244tG2EAUEtWTB0IhkN0S4yPgv+86okxy9kM4L4Wqt
	 MGGTzGL1vDsJbWxbWs234IZ5DQOCZfdDnZzovC1N+vJHj32PAeS5UGDK4x7NT/rmWL/dS
	 Y2c57d89gOrFvzCfVtpQ8Ft8KhiCAwQNTJ5WiEb+hmyU5I3MSUjHUblzZrnf/Ik3MifP9
	 1u+a82gN5xTydXuhCHzSIEVr/1ey724nDQQJt+XeSLP9qA3Qck4IjS3JMV00iLCu06w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zEWwLCDRWGKliiEM3NZL+vj+5Yk5ytcSLns+alfdO9o=;
	b=zmPEzkLhIUWSo38IoowNF+JrOiguCzDseGEszlJemQUqMlPyNi9fHEq41d8KbnbEptYr
	 2tNqdcl3h6A+JTIVJuiv6JXMVYMnFA/oehkSJvKSTvQfbPQcMSVclTkz/ZLYtx7nwVfAu
	 IZ7STaJLrSceVGfVdM8NY5h9KhVCocbARQlXs6WXore+LW0cnDf19xWqHBFP8yGxOwoRe
	 L2qMdihFin9hvpW54kPvgP7tUud83KSGxXeI/RBC9Hsu95mzvALCNFft89ovrBMKCWCwn
	 gJHPue63UuD/iiUid40ldIHfuiSjZtW/qePYaYSc0Tnd1lYh92gtYGOmvFlGIDFGbnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNjrABBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C42606A865;
	Wed,  4 Nov 2026 21:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNjrABBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E661F0093A;
	Wed,  4 Nov 2026 21:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829386;
	bh=zEWwLCDRWGKliiEM3NZL+vj+5Yk5ytcSLns+alfdO9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNjrABBij2HAV5WjOqS9puI4xaREJpHSzth8/xgM1MpA2CC19FTH2Racw7k0n7oYF
	 K6dsg3BfN4L5E1U+/t85lHrzIDyFFpKYxczgmfB1DNOnhYgXF0HM1IBv9FsCmOkTy+
	 EFgaMETIDDIBd9pXhs1/W5Yf2rEmwvhtrkmSXlak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0055/1005] spi: bcmbca-hsspi: return error from failed controller suspend
Date: Wed,  4 Nov 2026 15:56:28 -0500
Message-ID: <20261104211045.132175392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit faa878d4805ca375738294bc52eae310eb287b16 ]

spi_controller_suspend() can fail if pending transfers cannot stop.
bcmbca_hsspi_suspend() ignored the error and still disabled the
PLL and core clocks.

Return the error before disabling the clocks.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_54F5634545908FBA724E758054BF03953808@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcmbca-hsspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcmbca-hsspi.c b/drivers/spi/spi-bcmbca-hsspi.c
index a1ff33f6dc095..50beb8443ea90 100644
--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -586,8 +586,12 @@ static int bcmbca_hsspi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcmbca_hsspi *bs = spi_controller_get_devdata(host);
+	int ret;
+
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
-	spi_controller_suspend(host);
 	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0



