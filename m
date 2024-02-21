Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B177BAED;
	Wed, 21 Feb 2024 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522655; cv=none; b=PIpFGQ9SyJqhOKOh2srxAcpmQpPReX/AacevUR5C+ll3BgqyI/RTTdvz5QPeu5CnNryGtYIOKOKcPs1USONh6IlQIKKNmFCU7qYmhWVS+IwZNxYmr/i5yhES0JPFmY7FNsMuA+xGdklYZ8uOtu1SHceogZCPnb9RB0a4HOCyJgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522655; c=relaxed/simple;
	bh=Zfocd8g0ekcyC4RBKlyc+ZBBRBfcw4pWW+DmTaHlh5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/cIIxklDl7XogX2jLiaLa5Eo7YHNaPavd31O2U16lB7Led93UdEwfmPKxC6p1Nm/UKxMaCFwcNYwDcf2IWTnQ4/rYlBx5Sqx1HF/oCp6dL1NezjII0BV1w8RXrC3OH2+94WinFOk2EFw+8kxIW9izIVYiV//yl8f31W3sEEzKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERdRDz9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERdRDz9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FEBC43390;
	Wed, 21 Feb 2024 13:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522655;
	bh=Zfocd8g0ekcyC4RBKlyc+ZBBRBfcw4pWW+DmTaHlh5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERdRDz9GnBif7l2Iz5ZoMq4+n26OB/6UGSoVNftEF1Fw5m95jTlcvn9T7FdXHtAYg
	 B/uJ9+TfaxOgevjj4nrkFsg4JLjwJYfowk2itV9VGz35u55DEbUpgSOU9xJJgIIIti
	 MsnXfBJxcxK2J5SYX5OLAbTigV7npkIM/1jpo/W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Adam Ford <aford173@gmail.com>
Subject: [PATCH 5.15 223/476] media: rkisp1: Drop IRQF_SHARED
Date: Wed, 21 Feb 2024 14:04:34 +0100
Message-ID: <20240221130016.140228613@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 85d2a31fe4d9be1555f621ead7a520d8791e0f74 ]

In all known platforms the ISP has dedicated IRQ lines, but for some
reason the driver uses IRQF_SHARED.

Supporting IRQF_SHARED properly requires handling interrupts even when
our device is disabled, and the driver does not handle this. To avoid
adding such code, and to be sure the driver won't accidentally be used
in a platform with shared interrupts, let's drop the IRQF_SHARED flag.

Link: https://lore.kernel.org/r/20231207-rkisp-irq-fix-v3-1-358a2c871a3c@ideasonboard.com

Tested-by: Adam Ford <aford173@gmail.com>  #imx8mp-beacon
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
index 79cfa99f2a64..c0d732c56c1a 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -482,7 +482,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_irq(dev, irq, rkisp1_isr, IRQF_SHARED,
+	ret = devm_request_irq(dev, irq, rkisp1_isr, 0,
 			       dev_driver_string(dev), dev);
 	if (ret) {
 		dev_err(dev, "request irq failed: %d\n", ret);
-- 
2.43.0



