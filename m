Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D91D3F3264;
	Sat, 12 Sep 2026 07:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198204; cv=none; b=sMK1dgqBSA6eucYtatkwpNNfhqwG8zPT6g/Rq0Rj05TmSSUxKlZMk7du5uXFNQQF8n2DTOD6hRRabZRnqztIwqowxNz8y2FcnjeImfub/X7nnAZrtnO5Ky9pl73H901FrEYx6mWzkPUo2z/fEDmj85T0I+tu8iINC2oFma2JY9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198204; c=relaxed/simple;
	bh=7yCOoVZMS2OQmdBwWIr45yuuNkG2i/1vaxcOmFjUtCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXN2qDIRa5iHc0Vhy7S8OQAY5pXIMELP2tc8QefyLGFmowxLjPfz0ruzLc6bxrtnoBtY1hb+sjvZAQPn72SQndUUtoWt4sG68p5qVQoOih5O6o0gW8KN1HnTUIS89WNUdKfc0sUIwetmSX8j2rCkXhGfs6vPL/RDrbNAIovC1M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4TjHmoX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4TjHmoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218111F000FF;
	Sat, 12 Sep 2026 07:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198203;
	bh=Ila/5dHAzL66rL2Bq3EHQsQDPXJg8ixjku63kqcqDnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4TjHmoXuLRsSAK2pRZ5eO7/hSLBefp8u0uddwrqsIo7IGH17yhaahqEYrwmARGD0
	 3/yXi/RdGfWC/VS+hKpwIYiCGyyHAK0P/TANY2SGruyyA/O2VZ6z3R33/GjH0UxfGK
	 uJxsXIGeiirxv2MbTHhuBahivBpDEdiYYXku2jHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0333/1815] usb: chipidea: imx: fix missing ret assignment for dev_err_probe
Date: Sat, 12 Sep 2026 08:34:43 +0200
Message-ID: <20260912065656.741734181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 1db5c6b0b9834aee2f14e39764becfcc29d09ccf ]

Assign the return value of dev_err_probe() to ret so that the correct
error code is propagated when goto err_clk is taken.

Fixes: 2e9762f45efb ("usb: chipidea: ci_hdrc_imx: use "wakeup" suffix for wakeup interrupt name")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202607031656.FR3Xrved-lkp@intel.com/
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260710070834.2744357-1-xu.yang_2@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 56d2ba824a0b2..282314eea7fc1 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -528,7 +528,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	if (data->wakeup_irq > 0) {
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s:wakeup", pdata.name);
 		if (!irq_name) {
-			dev_err_probe(dev, -ENOMEM, "failed to create irq_name\n");
+			ret = dev_err_probe(dev, -ENOMEM, "failed to create irq_name\n");
 			goto err_clk;
 		}
 
-- 
2.53.0



