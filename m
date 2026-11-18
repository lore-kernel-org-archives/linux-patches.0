Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039214;
	b=hqmHPg+oEYSQu71kXlrWXGVtD4/6fEmvM+9WTRYzODkLLANyYJK9tuvkmrl6KEILT1tz
	 fUmIYuQ2jGN2oRMnmmjiucAEe1893L5E/ZjsjvhFvBX4TQkE+onQ6WcZyBDtNR0yx6liv
	 0mm3PkcsqFsmk3Vu6tmIsOgj6Wgg+uwGPjVm9uduzHHUk2iq/AfsTs7OGSAKabN27h2A5
	 chkxQe3K3AZ4HHAUJ/6Xal2ieQkAL29Qa7ow6e2yYU82Zf3TaYfLQr6n06qFxa0RqV5Y9
	 eNnXmdEIhyB5G61jnymn1Nm5AYoLE0+grX03JbcSIRtYtB/1w+xB2K+jM5tTbqTrR+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y/NocT7SUJd6AkeXMaH1BSsvTmFM43Faki5oqwyj88c=;
	b=EAju3qxPPQN7A25VJjxXkuxI+yMjAE942/Aa7Rd+7ZCVQxu32or95zEgxut/K6ZOZKo4
	 USsl6OO8CydAWngJ2SNFrz46n6+ameSKiliQdpHH+x5ZdINcavHTkO1dbBL/3kXtBcLL2
	 32GaTak7rvTr415a/AoZtNq4vbByLGyVVhFRiZAAZMdJs6iyuVz2EqzMJx6gkz5XeVhU6
	 ayAdVinUahKQLbVEvEfug93SB+0E1ye7IsSESurAKJpcbp/YDP2qMBnIdZc1ZmmjmmXRQ
	 7BY5tHqzj/96THkiXky89a4RL46dUmy6HyFe5D74R/t4E6rOec2XXig6ueS5gvh43AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="abh4/t00";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70101606A32A;
	Wed, 18 Nov 2026 22:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=abh4/t00
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6E11F000C4;
	Wed, 18 Nov 2026 22:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039214;
	bh=y/NocT7SUJd6AkeXMaH1BSsvTmFM43Faki5oqwyj88c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abh4/t00JZM9rKhZPoBkEn5ohTB2xm7Dz5Zo8FDgzt7kCgIGwkialBGjT8b900ujQ
	 9YyMaDoOthi+lrUC2n6k8qCwwQv5xwUtUPZuq4jccsB+EK8DARPupoEMWv/U8h4+pe
	 I8Dm1U0VntDlWdB5+UcBxMgzC0HqhNvJe9wER+7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2021/3318] spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls
Date: Wed, 18 Nov 2026 15:44:03 +0100
Message-ID: <20261118150422.672822519@linuxfoundation.org>
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
index c955741f0c739..0d8aaf8c5ed0e 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1549,7 +1549,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_ctlr:
 	omap2_mcspi_release_dma(ctlr);
@@ -1569,7 +1568,6 @@ static void omap2_mcspi_remove(struct platform_device *pdev)
 	omap2_mcspi_release_dma(ctlr);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
-	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	spi_controller_put(ctlr);
-- 
2.53.0



