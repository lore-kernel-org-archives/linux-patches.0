Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023305;
	b=cKqIfOR3HtW34CSxQrf14qSwHQLVjJKiMiKPb1jRjinNpjAft0VGYhbe5x8M7eG6e5dL
	 2C8V4jHY1OqmYRAizK/LO9zOaJLTGHVVAwJuWRYh1XGG+dW+le+1aNSH63TEjlMG0UY/P
	 7DZokHx2DL/bi4bSSc4sIZ6Kffy3v6Zo2s78//xcCdynlMKuEFFSK4zbGTAt+R/weTK/v
	 PjjBfpGFGbkDwHKlz/r6kd6873UUWGeEsS8sGTcV1xFL6LgTHAFIozpKP/6QbhdlgMEvW
	 Tt1186ilYts719ZD7EBqnNxoKgD3+Xwl1ZCGqP5+0cOOa9SO1w+1lUl44M0ofZkPm0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tDmsr6vutFJJ3otbotC30PQl3i3I0tD8kG2YV4EUiEg=;
	b=cmgSrnt92IGd1zwnW/ZaWy9hvbs4M1+mwBWvtjxYEYvk+/NnEr0VCCriNgYTE5RaLHmI
	 pUQAGXJQPhZE2Mi33+QDRol7iLfvVWVCOzWaoDFdwfSqEpDog7xiFJGDVGeJxdYfOb2EJ
	 OvZYT+xMKAVUAY6dOi2iv49Zc8nOV0VlgBaT05xPO29gouGWDWOjbH8oGN8WjMY/sbxUU
	 1l+9BmbBH5fOeknuKg07B6rhPgnnSDjVPezmGTav/wLspB6XXmiGEA3ZfoFRvV5oexdME
	 3fr6CZNhLqFaDT9aRBQDt2c14i5+iUJRtQu9w/9RtVx17NPnAYYq7PBFAL6j3zk3d7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTYtxkKv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB84606A320;
	Wed, 18 Nov 2026 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTYtxkKv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432C21F000C8;
	Wed, 18 Nov 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023305;
	bh=tDmsr6vutFJJ3otbotC30PQl3i3I0tD8kG2YV4EUiEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTYtxkKv2IbtDhG7itD5BmrEpjMDvvM83yJJbAzPkugRZ0G2/XYRW+G3s6o2Pywy8
	 8qNLChjnohTlHc2eZl4EeO5DHnMaRHuLZuVh+R14pYf9Bo2QrxHlrC7vRZfwSedsA3
	 HLiysjT3TotecHbiWd6HkFjg9SOIn0Nu2Z46JjXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0295/2151] spi: amlogic-spisg: check clk_prepare_enable() return value
Date: Wed, 18 Nov 2026 15:33:50 +0100
Message-ID: <20261118150132.657469971@linuxfoundation.org>
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
index adeeaa3d058f1..e5f18308daf26 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -718,7 +718,9 @@ static int aml_spisg_clk_init(struct spisg_device *spisg, void __iomem *base)
 		return PTR_ERR(spisg->sclk);
 	}
 
-	clk_prepare_enable(spisg->sclk);
+	ret = clk_prepare_enable(spisg->sclk);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -856,9 +858,18 @@ static int spisg_suspend_runtime(struct device *dev)
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



