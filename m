Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015794;
	b=SrOkMBgK5nz8559x9FCdKBqYRTOd2g6meDGQu/T62Fqz0qtbPZXMdderzdSeDJg7KUQT
	 Y79M99e8JpZKvBD5qOeDUOnQ8TWLGkeLtxlKgQ1GNQxM9MLPD58jaqElLI3xkOkcBA40z
	 KB3elyZqbcnWgPIEHOmXD6Xl6/fr179MKCKOotNP5jebOol/T7Jd97b3kRmrk5jTl1FHp
	 BTpXV9qyMSle2YTrUy9smxmJ+CSyVcYb+1Hddkds61eO+hqrKP044rbD8wR5hKd4r8fH+
	 d5Xt3bunIh83+SN/WVv5mLyNBOYvNIB3Qh5bsHHmE5XYwIBej11NFyfI9x/QX585PRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=reCAWairWX8eGrlaKOKPf1GDD5bWjmfEPfp78LWa78I=;
	b=Zn2ikMI2pWQqpOSGaECWtnMfV4fevuUubFJzyNheuywIJUSSfQDahNuTo2zHvr+3xUQC
	 z+qaFT7MZE0EvjUjbS1Q4/J7qi1pIWGRdjNNdVBRSUcIui3fECXJePkNiL3hTZJHrslLJ
	 bh9/Yih8nd798ZWTa/ZrOmNY9rdT8Hl6BUWGmWKnLwZLf+2mcdTHYs+wpQhp08Ykv0U2E
	 PGZXM0utBHMb6t/mMdXRw4LU1/TJSqatsCjOtjC51FJBfvRRJhzWPiOxw/dV+AMUAosqE
	 kqYDIsXz5ksNnepVugHzVyG3nMD1YVsUJlxv8ZO3/1ry0tK4UR0DNl4hEjfy9wcoZAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UV7Y+kvI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F73606A320;
	Wed, 18 Nov 2026 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UV7Y+kvI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90751F000C5;
	Wed, 18 Nov 2026 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015794;
	bh=reCAWairWX8eGrlaKOKPf1GDD5bWjmfEPfp78LWa78I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UV7Y+kvIYk7AX/9Qiuq9TjroadkC7vybYWkLQhf7g0MIL5cFFNTNKYxz6VNFZXpNQ
	 L66N9nJpb4bVHC6BXvC7mXPapWAF5dxBRMiUKhFhOl28hB53QY3rb3b5D5q9qDxWLZ
	 XnS5+f1WIGELm4BbErpuEbZs5HvhoPM6yzK0P99g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0293/2651] spi: amlogic-spisg: check clk_prepare_enable() return value
Date: Wed, 18 Nov 2026 15:25:33 +0100
Message-ID: <20261118150258.453266729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Li Youhong <liyouhong@kylinos.cn>

[ Upstream commit c595dcbce20f55c98cd9b0003c26db3787e0ddee ]

The driver ignored clk_prepare_enable() failures for sclk during
probe and for core/sclk during runtime resume. Propagate the errors
and, on resume, disable core if enabling sclk fails, so probe/resume
do not continue with clocks disabled or report success falsely.

Fixes: cef9991e04ae ("spi: Add Amlogic SPISG driver")
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Link: https://patch.msgid.link/20260831094553.2247003-1-dayou5941@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spisg.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-amlogic-spisg.c b/drivers/spi/spi-amlogic-spisg.c
index 6bca2379e4ee3..6243b47b6e68a 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -714,7 +714,9 @@ static int aml_spisg_clk_init(struct spisg_device *spisg, void __iomem *base)
 		return PTR_ERR(spisg->sclk);
 	}
 
-	clk_prepare_enable(spisg->sclk);
+	ret = clk_prepare_enable(spisg->sclk);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -851,9 +853,18 @@ static int spisg_suspend_runtime(struct device *dev)
 static int spisg_resume_runtime(struct device *dev)
 {
 	struct spisg_device *spisg = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(spisg->core);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(spisg->sclk);
+	if (ret) {
+		clk_disable_unprepare(spisg->core);
+		return ret;
+	}
 
-	clk_prepare_enable(spisg->core);
-	clk_prepare_enable(spisg->sclk);
 	pinctrl_pm_select_default_state(&spisg->pdev->dev);
 
 	return 0;
-- 
2.53.0



