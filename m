Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371A93D668B;
	Tue, 25 Aug 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665045; cv=none; b=aKExPFtMCXGQUSPRwtOPJpw0zGRe0ekym51YYggB0KWzzK2jCl1KK+ybj3Y3nw3U/XWtuPjEg9jwVrLT5R51pbsEQD0+rergLzwFpU0ZRSBG3zSuNFcnvwREyM/2Iy9yKJlg1ngLZDowFbzmMJsMN3/Lh53GSqSCWEx1O2mKl+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665045; c=relaxed/simple;
	bh=ugE/C/48wl6Aav1oWjMvUcOJt1exh7TXTBmk3ydg48k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XovwF5/waFNbysffXT7bqJu++zFHvsko5Wn/CM951cxEEP5nQR5XIjjz0a5Pdory7/ov+0qij4RHc5Cx1KIHIDMKfzZHfkPhXWNVjFbzZkvFoWI7bfNYD9jes94YlPWl+s/joWm8/T501wYMlfx/JLiPLytnZebc6076Pe2QgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dx4tGwy2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dx4tGwy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893441F000E9;
	Tue, 25 Aug 2026 13:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665044;
	bh=QHWPAWGaNRP48FxJsxzOP9ypVVFYzUo05l23S2yat44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dx4tGwy2mhaYAu0fN13ZAq4giYmJRWaPquwEiqLpkwedDyRkmBaJQ17M1Lo6oqfkt
	 56Vg7xkOCRLzzU1tNjPjv+vRXtKuA1QNfe7tejYVbhdc5sRYUvNenOePxzWJmf3u0x
	 Lbh6A6TbLv042cSGco+298K8MN2juNWKnCAIghJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	imx@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.1 052/101] dmaengine: fsl-edma: Add error handling for devm_kasprintf
Date: Tue, 25 Aug 2026 15:25:30 +0200
Message-ID: <20260825132544.048900028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit bf1af4dfdc017dfe989c0dbcf0e608dc95f1d2cb upstream.

Add error handling statement to fls_edma3_irq_init() for the
devm_kasprintf call.

Assisted-by: gkh_clanker_2000
Cc: stable <stable@kernel.org>
Cc: Frank Li <Frank.Li@nxp.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: imx@lists.linux.dev
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/2026070605-frying-fling-b9c5@gregkh
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -414,6 +414,8 @@ static int fsl_edma3_irq_init(struct pla
 
 		errirq_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s-err",
 					     dev_name(&pdev->dev));
+		if (!errirq_name)
+			return -ENOMEM;
 
 		ret = devm_request_irq(&pdev->dev, fsl_edma->errirq, fsl_edma3_err_handler_shared,
 				       0, errirq_name, fsl_edma);


