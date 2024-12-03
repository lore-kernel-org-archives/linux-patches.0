Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9046D1EE00B;
	Tue,  3 Dec 2024 16:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242542; cv=none; b=Tll7MLKiGkS4v2sKF3n8zo0qZh2+JcDWQNy2hdUOVrIe0OC+uZWhsiGRwSjnMZjGYmt1NPJwXRgOu05+wjInu68XVmgG6M/RZXs+A4PsYpQ/cdjBjsOvOnv5u/VJTHMUMofwjiOtQ3jxh/Re4CBRLXfE1MM6uuxPR18IZGUN1Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242542; c=relaxed/simple;
	bh=+5tSvB/PFcmvLNL4fgwg34PDZ6OTMGIlUYZvbuxZCLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSx+er9fBX2ddlRLdU1kLqKOH7RemTO/HljKVXJGpHAtLhiy0QIh2UpJzhSTayAyYSMubn2jUP99vnQO6tbBw76p4j+L3I/uhtCyZsNRah4Hy/wUeoChVb1OTo4imGprG0KNTtSYZO40uDHOrFKFqcLfr9NgcIbEpxrpXq4MZ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJxzyJAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJxzyJAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8D3C4CECF;
	Tue,  3 Dec 2024 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242542;
	bh=+5tSvB/PFcmvLNL4fgwg34PDZ6OTMGIlUYZvbuxZCLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJxzyJAecB615+M8m3PNyk3nBITeg3hnLE6NZTKQIMahHnCHphLh2loxGEXR7rk/g
	 GlEbUyejKPTg3AdN3ykiV6oCohqoOqQrAO/hQnMDh+BJ61yeP6TC43J3NfFSBKxgbm
	 hYCTe93iI8qg6JhjP5Tz951teiXQkCT9y1d+RYNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.12 735/826] soc: fsl: cpm1: qmc: Set the ret error code on platform_get_irq() failure
Date: Tue,  3 Dec 2024 15:47:42 +0100
Message-ID: <20241203144812.437640030@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit cb3daa51db819a172e9524e96e2ed96b4237e51a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/qmc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -2004,8 +2004,10 @@ static int qmc_probe(struct platform_dev
 
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


