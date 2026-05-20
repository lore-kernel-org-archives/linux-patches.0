Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A413F9296;
	Wed, 20 May 2026 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300925; cv=none; b=XdmEvFjKm64NRTgP2iB/I9FHVr2qpV7w2xLWIB32k2RG5de/bZ+hBeg7wWf/kpel6PGjySB88RosnN4R18bSCISDyDj1/PJ1HDv4cWkXcDm7Hesjz1fKYVY6fV4kDlzUevRo7OUHxIGy9LlQSKRziBKJsQam1ZfPYZEA3itPYEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300925; c=relaxed/simple;
	bh=0nVM/VkTws/+t1rtsjnaPXFXByxuJbxpmm1sMy+Ky1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIKQ76sezTmnboC++2ld0qI/+vKADSYlk0nUHj71I67lsUvzBxTlVG1gXC87DXMLSWs6x3CG1+pNA2vSvKcJsqesDfVRWIUSocb2w4rrzgcHo063TXJqCwM8+ovHh1H9sH/szhDwPsYLcsk25lEFJoyDozjP/6gO7GxS0XBL1uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSck0Tua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSck0Tua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF721F00893;
	Wed, 20 May 2026 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300922;
	bh=OrmrpQzcGzg2C93oJQ058OBuM3h+O3wrMdaSv1fTGos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSck0Tua/KYJSwNhs9ZN3PTW/d45XjLAJSU/F2Kpxfh7O+Vy4/3Sxhd3qVBZ+FruB
	 VpTo5dJ+6cZoBvm3EZTNj8TfLHh4gY/yI6yY9aUDWCVTl4079vArzcOKbx6idIA5u1
	 KakpBoHD/zot+2xbVmF2fNYlfF2iKaPFMOw7bNwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/666] pinctrl: cy8c95x0: Unify messages with help of dev_err_probe()
Date: Wed, 20 May 2026 18:19:31 +0200
Message-ID: <20260520162119.040823962@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 014884732095b982412d13d3220c3fe8483b9b3e ]

Unify error messages that might appear during probe phase by
switching to use dev_err_probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Stable-dep-of: 5ad32c3607cf ("pinctrl: cy8c95x0: Avoid returning positive values to user space")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index adbfea8ca5fd6..baf32847cea5a 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1354,10 +1354,8 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 
 	/* Read IRQ status register to clear all pending interrupts */
 	ret = cy8c95x0_irq_pending(chip, pending_irqs);
-	if (ret) {
-		dev_err(chip->dev, "failed to clear irq status register\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to clear irq status register\n");
 
 	/* Mask all interrupts */
 	bitmap_fill(chip->irq_mask, MAX_LINE);
-- 
2.53.0



