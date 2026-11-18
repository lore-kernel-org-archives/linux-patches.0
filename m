Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028968;
	b=xcHtEYzv24aAokVq+YIuhefXpscZeVEkVelPxktSi4tNP79zZaul00RueusCSUYU+Zms
	 AoGSxOJkZKlnV4EyrrLpZxDBrzC7vkrU1CJdB+CAPw4/YgvLosupaIBXajcvp1A3Bdjqn
	 osbAA/uwmc8JHKRvZe7e2qG0Ou2hzDVjGFq5SARwqNfJ6QaC1sbJbQvk1uf+rmUTVGCSD
	 dQzo+Qg6FLALS4LXA/yN60F8mvqAuYp9kmZchSPOHPGfVFmbJDLUJARn1Sf5looUW0/bM
	 7lvkY8zzQqywfaPxnZFeRICTPYzAFyZ1c/j805aWKGP91dKfdsrdTm3SPL6AjEVNvEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ITzFJnGsoHOvmsl4xsOIPumMsflLSkJeCwd9MoD8ttg=;
	b=brnGieaTLVSt79SHcqo+RHxUYMKUh7rT0eoc+mlovqsRfNfE2mEHT2VuR1I7BXEdJ/NK
	 b2Lyx9P+C6jyKGIeb/ubDU0LloVvebbdE5tJw1aexdYaqJDVnFvIn1NtZgr0goYup+xBE
	 nClWhR2HwplnaaEqEizrNRHWz2zEakfcAS4BTLQcXntqIoI4k3hlG75jTPgHP/62DK2uG
	 SNVG8uqF5HnHy4WBPtE6p0XoWLOKg0svmMY3FKDRqpL6kV+U/0Ieidk0+fDkW5yzdf0xv
	 Z2hcdoVsWyux51iEvCZqHboIHT2qjm2tiHMiLFlyLFdwRI6Ea0GjLSpOAqiOPbYgAag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SENslsIp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5C9606A335;
	Wed, 18 Nov 2026 19:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SENslsIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1881F000C4;
	Wed, 18 Nov 2026 19:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028968;
	bh=ITzFJnGsoHOvmsl4xsOIPumMsflLSkJeCwd9MoD8ttg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SENslsIpsq7rafCmhqzvU63aZ/VoYq5LEvLaTAr0mvMBx/pPi2uCv3cXCT2eCAnLH
	 CkX9HmzZX09dKkbHWBojLJipH8JiJboxBHwnj9gBbB4rDzSpMrk36bG8vTiPhvLNt2
	 ZR1R0f9TdVodH2VSrfJ9yPMwadT6NzRUKpqBs3ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0183/1756] spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls
Date: Wed, 18 Nov 2026 15:38:30 +0100
Message-ID: <20261118150015.704659905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 1fa632eb0018b..b84b1b67d9693 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1595,7 +1595,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_ctlr:
 	omap2_mcspi_release_dma(ctlr);
@@ -1615,7 +1614,6 @@ static void omap2_mcspi_remove(struct platform_device *pdev)
 	omap2_mcspi_release_dma(ctlr);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
-	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	spi_controller_put(ctlr);
-- 
2.53.0



