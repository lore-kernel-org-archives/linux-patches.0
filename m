Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047786;
	b=vnVKl4cdQlFHaE0zPTSgHy7MjQt4uSNmTVHoyxddliLonpEsMC24hCWx11aeE4GAJxC9
	 dDv0Nk0ww3PdWBGy4QAxgyn66XUClcOuyxUWOysLCi1iXVOWHyd2l5e+/K6JDqWWHKnS4
	 fx2iU/60hHuWEKzlqpFcUgo8GHuLw6N1LwCs1cKpj0muicc5scNAhRSvaDHuNlVZS9Wut
	 IH6SupzB3GORFjE+f7oMsBafgKIAjrXMMXJqmaiwM3ny1LckCkcz9VDWG0Bcj3s6JlpUS
	 cZGkcr3s8/p3kmDVRIizDQaI/jQVgYdsZvbOQUIHRwMuU9b3DTM5VZct79EL98ZQibw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UK1Uj6otN0FOygN+Ol+Vlarkw2+0szK4/Z+K11psg38=;
	b=0DM9+98eUjQnuIuM9ZwJzvipeZAU9NUcTzy2/5qdKLHk0qi0Iw7lJ1ox5tFHrJqHIKar
	 LsqwD4uXQYtaVRtiViQIANrSX+DyJuNR49jOplBD5fJa5a0t1URw4e9fNj+rDvc4IjbzX
	 H/QUgKebksmpsrKEs9sBwjzrN+frhxWhQpm/49ymwV1lHmARxgN5GlaySRkz7k6bIcFy7
	 oY9k5UwwBenQbjpz0VTHVp8dTl7bCJCxPXdbBpNlugwXcqjQMQIQP8xgyvlh/a9M2XzQv
	 4Pq6r712hqAPrVm/gscwjTxLDCWeaOXyiwQkIqJqBouvjqEkNCacm9fjz4FMIBHyETw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2S1DWEf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFBC606A31C;
	Thu, 19 Nov 2026 00:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2S1DWEf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E861F000C4;
	Thu, 19 Nov 2026 00:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047786;
	bh=UK1Uj6otN0FOygN+Ol+Vlarkw2+0szK4/Z+K11psg38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2S1DWEfLPG8sAxmtRyBlHPRaFnPfqug0RZkzwe/w4vSE8TzO7VNvh/2qNG0ID082
	 GbYXBCirD3OjwKjJ6JhO0tSO45hILv5IYoyVtZN5o9IsOlAQlx/3mi0JXm45Vgnlx8
	 kPMKvDCWI69KTOcKEYdV/M7eDowEfF9uVwML5G68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1762/2857] spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls
Date: Wed, 18 Nov 2026 15:46:36 +0100
Message-ID: <20261118150304.729256627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6ba9b0d7710b0..16109ff1ba728 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1538,7 +1538,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 
 disable_pm:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_master:
 	omap2_mcspi_release_dma(master);
@@ -1554,7 +1553,6 @@ static int omap2_mcspi_remove(struct platform_device *pdev)
 	omap2_mcspi_release_dma(master);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
-	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
-- 
2.53.0



