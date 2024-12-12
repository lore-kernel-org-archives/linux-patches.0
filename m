Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D59215764;
	Thu, 12 Dec 2024 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017676; cv=none; b=E+O9PEP9g84oQ84ilBUrPbnqSb42qtBhYJ+WJfVcdvepSnSLD3XG3wVGxHs9NgpeFrOIAloLX03BKg1hbLsSunL2NkPEC+AL5QDN2IHmJAAW/kBrx/ym5GerhVhGcmpF4U5rIv/WJwmLBvYaBc2ePfbW+4kmunfzk0wfWmGtP3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017676; c=relaxed/simple;
	bh=+owGEW8YeDRHzCFIoC7P44pxIKbAc0XqsykRVQGEq+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+MKPReLHfbKgVIHz5wcmvyMmTQ0V/PbvOar6L5Rw0+JXz2CzjTb/B4AfI095oHbouoju4jjoiH3HFLI/s2qLCbLdWFA3Q5Qb2VMidVC8ysK6YAWpodFTW3SYcL6FJLH2cF7jWBWsDIv2vqGC2Pve74X0PQ4VfblDgIHFi/PC74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EI1/PpJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EI1/PpJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C300C4CECE;
	Thu, 12 Dec 2024 15:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017675;
	bh=+owGEW8YeDRHzCFIoC7P44pxIKbAc0XqsykRVQGEq+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EI1/PpJ0Vvm0ptd5HFpcb2xbH+1BMlpxXY0bPI+DMIE2z2zQdhU8YhQz81SFaI0ET
	 L5ddImPHTCT9ccjx6UwrYrl7DifIB/IY2uDt59nuQVNVy03myXog479qBMac9u+fxE
	 byu1REX1Do9vWe1mhaOqdB8kHJzkOXFwa1KejgU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/356] soc: fsl: cpm1: qmc: Set the ret error code on platform_get_irq() failure
Date: Thu, 12 Dec 2024 15:56:38 +0100
Message-ID: <20241212144247.746298989@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit cb3daa51db819a172e9524e96e2ed96b4237e51a ]

A kernel test robot detected a missing error code:
   qmc.c:1942 qmc_probe() warn: missing error code 'ret'

Indeed, the error returned by platform_get_irq() is checked and the
operation is aborted in case of failure but the ret error code is
not set in that case.

Set the ret error code.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202411051350.KNy6ZIWA-lkp@intel.com/
Fixes: 3178d58e0b97 ("soc: fsl: cpm1: Add support for QMC")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20241105145623.401528-1-herve.codina@bootlin.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index 9fa75effcfc06..f1720c7cbe063 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -1420,8 +1420,10 @@ static int qmc_probe(struct platform_device *pdev)
 
 	/* Set the irq handler */
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
+	if (irq < 0) {
+		ret = irq;
 		goto err_exit_xcc;
+	}
 	ret = devm_request_irq(qmc->dev, irq, qmc_irq_handler, 0, "qmc", qmc);
 	if (ret < 0)
 		goto err_exit_xcc;
-- 
2.43.0



