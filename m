Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054687;
	b=WdkuObxCiTOUSaTp5RZGFNvk14hFAhLcN9eDN/qrK/di9YI3J8DEG/6A2gBjy0M7zNG4
	 Eu2EUAkKQVEz1+RAZvi4qKj5Hk6wjyC7OjFDzKDHrlDQogIFEdfWUoPx5kywsAo5qAK9v
	 wUn76ZjV7JyQ1kxaT23f1fVGrrVhp/S8JIJX8EzB0uDBu/UKLR0GGtuluHHNtZUvhEpvp
	 h/j+wCd+VQmiITfHieGKEFAYtl8GFRn75y+6cnCPlNIG8D7LoliO5k/08aGXhDK2KDPqG
	 Qgx03mtCH8963GGB++pRp57ZiPdj2CxN+7GoAxULGHbSbR47djoMuimU7VDkkmkIYrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FEePminJ5zxqm6mpcLi6sWwHBzzIHjiAceKKQ+kl9jo=;
	b=z5Sokci/E6mZYn90ctb8Axql9pNbhFSTjfV+IiE0vVc1UKZDxLCFbrpNMSr1GgnpVvq2
	 e1/Z9omoUSz1D231qHJSziGT16Q72s6Ei1sVei27qdMMvuCKq1m5skjgllpvk4xXDbA6v
	 tF1yfs5QDe59QjzzMX+YHNdEtGU0HjwO2s80v5W3/pY4ePel1cQxlHHmnJQ7iqKtSs1Qj
	 Kp2f2FWXJsKTmMqTO/lUaYs5DUbhM4wUyUBtuZplmsR3zA9dplu8aU9hHpPDhWGahLB1B
	 +nJQGo3fmcnsTgQKREsrAwYBiNi4j0GyzhAIIEq0JZ1Kyl1UNwWmJFegDKrtp1eF7zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NVvS9kLc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFB8606A32C;
	Thu, 19 Nov 2026 02:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NVvS9kLc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A181F000C4;
	Thu, 19 Nov 2026 02:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054687;
	bh=FEePminJ5zxqm6mpcLi6sWwHBzzIHjiAceKKQ+kl9jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVvS9kLcXEBBLKenlPif13lil/clF5QgHetIw//i9pESnVsA4DJVjq3RO+Pd96X65
	 4lbgE/Jz9t3wrsEXsAOVJxnNgj38CkqJresS9DqDShlr1Hx1tX66G4KnJCkcoZ9uNF
	 g5WMEOskp4tWQAcMhHODwif/dotqdkc5rfWX0Vcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1362/2214] spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls
Date: Wed, 18 Nov 2026 15:50:38 +0100
Message-ID: <20261118150105.887875847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 60c9cdf1c94b4..069ba2559b5c4 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1539,7 +1539,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_master:
 	omap2_mcspi_release_dma(master);
@@ -1555,7 +1554,6 @@ static int omap2_mcspi_remove(struct platform_device *pdev)
 	omap2_mcspi_release_dma(master);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
-	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
-- 
2.53.0



