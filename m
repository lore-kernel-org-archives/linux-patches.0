Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829380;
	b=QKsP/ooJcBLZGtuUPoXiRljW0mnOXwRvZ2+SWZ4IZae6AC0c4m2nddpNm0k7N7lQMKWC
	 J8pKNflxuoSqbG8FquNvOaEHP/tXyxwcqq6f7pajeYugygEE0V5DTjeR3LyQEva30aFfW
	 i0j9S9SWGRoB+f5SOQjgr7tuaiSYiZbiMn8K6QI7FYm6+o26IIbUn15R6WhA9ZSghhp7G
	 qWxWPzWig8jJ2yqgPYoC0aIHsadyISSY+zJx0FEg8454Yq716nihNAQ7b+saLbPyrO0pl
	 yq/xZG2U5J8zLhSXW3G8nDuwWG2k5c5l+bzfnIzNxDJN5abavkiqXU0hEcVM4yf4UGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iiODLTbdIuPHkDTxrXht7tsi5I+/Yo0ionq0dtQk1kA=;
	b=tMDPXaNgi+3Emm3qXt8SzlNYMHg3aq3h9JSPxXyV6cZWsLlf43C1eM4GEg/fB4BQGURu
	 PsIVaCZ18+RCHPev8ZUql7DP5/GiDhb528KZG43DL2VFhekhtLaWF0qx8eUlc4H/wB7s6
	 DnCS/Kr5Ff0evCWg0eosn5OQkO+n6WUfLtFZL6+lTUcR087NG5Bk94EPfu/Pl08Iga59v
	 +6OYtJEh/4/kckCodbrk7x+yNEMK6cA9FIrzfHpm84ggiLT78yj7uxFc8oj+ZQ5kPBsay
	 feJ8ZnmiCKbFQE+nRGoAw4rmNqqOhWGPq2Aygr6fs33NFhapoxmni7jE8KuTV16nhPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WMgeQSLS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7804B607490E;
	Wed,  4 Nov 2026 21:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WMgeQSLS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121BF1F00A17;
	Wed,  4 Nov 2026 21:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829380;
	bh=iiODLTbdIuPHkDTxrXht7tsi5I+/Yo0ionq0dtQk1kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMgeQSLSTn8R6SDt7LUZ8hAVo8QdbsQhXacTaI2+zGiApxsmrK+A5qsuDs5tCbC/d
	 BFdn8BatD/n4vHUBXM/Bos/HbGfW2GvS3R8mD6LSPWPFG6mqP/DB3Zq0mGYvYoI8qJ
	 JiH5+k2PS33Kilw7ngA8bdlL2+VsZ7JIS0HZo2kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0053/1005] spi: fsl-dspi: clean up after failed suspend and resume
Date: Wed,  4 Nov 2026 15:56:26 -0500
Message-ID: <20261104211045.077964839@linuxfoundation.org>
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

[ Upstream commit 2543355f3da56a297e3803ccb5d29f4dce5f18f1 ]

dspi_suspend() disabled the IRQ before spi_controller_suspend(),
but ignored a suspend failure and kept tearing the device down.
Restore the IRQ and return the error if suspend fails.

dspi_resume() also left the clock prepared if controller resume or
hardware init failed. Route those failures through clock cleanup.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_427FA55E3D59112524886E9C931CA0F92F06@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 83ea296597e94..1283a193b6fcc 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1464,10 +1464,18 @@ static int dspi_init(struct fsl_dspi *dspi)
 static int dspi_suspend(struct device *dev)
 {
 	struct fsl_dspi *dspi = dev_get_drvdata(dev);
+	int ret;
 
 	if (dspi->irq)
 		disable_irq(dspi->irq);
-	spi_controller_suspend(dspi->ctlr);
+
+	ret = spi_controller_suspend(dspi->ctlr);
+	if (ret) {
+		if (dspi->irq)
+			enable_irq(dspi->irq);
+		return ret;
+	}
+
 	clk_disable_unprepare(dspi->clk);
 
 	pinctrl_pm_select_sleep_state(dev);
@@ -1485,12 +1493,15 @@ static int dspi_resume(struct device *dev)
 	ret = clk_prepare_enable(dspi->clk);
 	if (ret)
 		return ret;
-	spi_controller_resume(dspi->ctlr);
+
+	ret = spi_controller_resume(dspi->ctlr);
+	if (ret)
+		goto disable_clk;
 
 	ret = dspi_init(dspi);
 	if (ret) {
 		dev_err(dev, "failed to initialize dspi during resume\n");
-		return ret;
+		goto disable_clk;
 	}
 
 	dspi_set_mtf(dspi);
@@ -1499,6 +1510,10 @@ static int dspi_resume(struct device *dev)
 		enable_irq(dspi->irq);
 
 	return 0;
+
+disable_clk:
+	clk_disable_unprepare(dspi->clk);
+	return ret;
 }
 #endif /* CONFIG_PM_SLEEP */
 
-- 
2.53.0



