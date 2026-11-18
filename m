Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022921;
	b=CwftVea3hHu6PA54clFiiD67W5Peu3jbwHPKqvcveAtvbEeyBdsdmzTe1sT2JrLk6q+z
	 TRIK8qQptLBD1+pgKmaebGe3/uRyFEstbsJWhj2Pu5QA/uPbXjiOGQvRbKXBdGSlD/ENB
	 V1VPj2EaUeCmkNgdaDzLMeO98CfrVut9nSy0P0LhDFvb4SdFT8vPBmuRC+unH/93kR+Hv
	 53vV/sOMUHAp/s9SNj9AwkXNXSswfnvWeKe0OI+9ohUyM2z4g9bFufFKlaOZHNGG4c5aL
	 318/fuodmpDASRhjFRu+HL99bcPTwEjNpNNjbjYgt+5U0eRflnqzR1aD0Z5PfhYWceg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Ze/dRJzLaJSlWtNoLQ3Pt8rrT08YFs3B5iujXekKiI=;
	b=0xR5LlMgUFJf7Zq3STF1IYy6Hjru016M0Jvcyet0jw/xEmvh47l6+pYC2mOGb9VFvb95
	 K0ZUkCUg4Xysw3HGnKyOd4BR2LaCtSdzY4/aAy/4fljeCG88eINuaCud6fWeEecLe5C4y
	 vsMAiZW6m58iSmTFUPEj87MPgvub/uCn6H89VLnekDorW/T2Px/gq67uppVETjtAuU2SU
	 b0MaiGC9f2tA4rHbugKGTx+6HGAGOrnWTMxTEV+lDBDTsmsKocPT7vz+2g1RIfk1HVmEV
	 HZeaql8RSGZ3lhSVqxVB0AW/jBr8HX4CAGKj6IQsfWxntQXwIFQ56FH1WkdsaU2NGwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B6sbsJFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08959606A31C;
	Wed, 18 Nov 2026 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B6sbsJFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7D71F000C4;
	Wed, 18 Nov 2026 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022920;
	bh=0Ze/dRJzLaJSlWtNoLQ3Pt8rrT08YFs3B5iujXekKiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6sbsJFNFKnWN6yEpdRdF5gsbxFAjGbJx63JRWWYQ/weCArj85gebVyF4WgNf/tF0
	 N6Cnm/Fh9c04DmI6tKeQIf47tlaWLizwP1Xy5AN49FFF2rVeXYmGh8WEH1X/shoOEw
	 o7c/sQ3pYD2o/Byul/xORhsM5cqFZtCWR8+4HGLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0183/2151] spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls
Date: Wed, 18 Nov 2026 15:31:58 +0100
Message-ID: <20261118150128.394034153@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 5f01cb141169fe422c42279f7d502479b1ff9fd2 ]

pm_runtime_put_sync() is called in the probe error path and in remove
when nothing holds a runtime PM reference anymore, so it underflows
the usage count.

Fixes: 0e6f357a5deb ("spi: omap2-mcspi: Fix PM regression with deferred probe for pm_runtime_reinit")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260826-mcspi-v1-1-0a8dd7f6dd56@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 86b3d21e77617..921fc07d9bee7 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1593,7 +1593,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_ctlr:
 	omap2_mcspi_release_dma(ctlr);
@@ -1613,7 +1612,6 @@ static void omap2_mcspi_remove(struct platform_device *pdev)
 	omap2_mcspi_release_dma(ctlr);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
-	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	spi_controller_put(ctlr);
-- 
2.53.0



