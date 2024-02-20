Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE0314F9DA;
	Tue, 20 Feb 2024 21:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463000; cv=none; b=pK7mU1twdpBjkFTOzy0cLo7DhQ0LCQwANLAWKO9DUmPVKbLhesLHih3Ztv4P37iEeuJIOnbXuVZIAAAjWaXs4eW1kY6k3pCKIU4N53dRlZneY7aeGL3sKUHimUqZjgKlVL8MYaYHl4Y57CEFmrb3b4tZTS9PRK6Ln+B6dpetTiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463000; c=relaxed/simple;
	bh=rHdDQ3yw+AUt1WgcV3VDVp4pjjXyZIr05WfG7hLhGEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9csaACDu2HS3iFKEK6mt/UL9rHbUGkoQtViX1v/zPueDBRmK1f6yf8rOUK1kiiCk6L/8u+KBQKyZtYTZpZsZWbAUmiP8dfjdwslUtLC/c0leDzj4FcieuPMcAA7fns7Q10KluKEMIXVROYnaMKrHSPAgfPqBaaYZIGcKKEBQrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gF2M6A0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gF2M6A0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871C1C433C7;
	Tue, 20 Feb 2024 21:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463000;
	bh=rHdDQ3yw+AUt1WgcV3VDVp4pjjXyZIr05WfG7hLhGEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gF2M6A0oCUt0s9LmcDMyDDLK7hjtuleXzT4plS9gS1UhswJXKokwIros1AodLssMz
	 EWHyIFZZDPuLnv+oXeTkoKFsdODaIRGKY57X00BhWR+I01uT8bfHC0tHYSmxwtlg6t
	 jf515ZLZ5NPyttIBm/TKqzaELlO2S/LlNcqKqVMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Rudenko <mike.rudenko@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.1 074/197] media: Revert "media: rkisp1: Drop IRQF_SHARED"
Date: Tue, 20 Feb 2024 21:50:33 +0100
Message-ID: <20240220204843.294350269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit a107d643b2a3382e0a2d2c4ef08bf8c6bff4561d upstream.

This reverts commit 85d2a31fe4d9be1555f621ead7a520d8791e0f74.

The rkisp1 does share interrupt lines on some platforms, after all. Thus
we need to revert this, and implement a fix for the rkisp1 shared irq
handling in a follow-up patch.

Closes: https://lore.kernel.org/all/87o7eo8vym.fsf@gmail.com/
Link: https://lore.kernel.org/r/20231218-rkisp-shirq-fix-v1-1-173007628248@ideasonboard.com

Reported-by: Mikhail Rudenko <mike.rudenko@gmail.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -559,7 +559,7 @@ static int rkisp1_probe(struct platform_
 				rkisp1->irqs[il] = irq;
 		}
 
-		ret = devm_request_irq(dev, irq, info->isrs[i].isr, 0,
+		ret = devm_request_irq(dev, irq, info->isrs[i].isr, IRQF_SHARED,
 				       dev_driver_string(dev), dev);
 		if (ret) {
 			dev_err(dev, "request irq failed: %d\n", ret);


