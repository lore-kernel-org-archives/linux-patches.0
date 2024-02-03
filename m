Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80BDFBF2;
	Sat,  3 Feb 2024 04:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933858; cv=none; b=DbfrNwWb7GdJq5tWNBwXu7YgcISSxTCFmPRnbetM14hyMZsR4lLFnVR1Guk6unkvFj9d03e2TL+6W+bpFqVFGKme8QGiH4uH/hqVpB50XvzS/hc34BNzGX8xN+0pSLHidELxYVkrY/M/D5YyDTipfSfNkk3EsUTgUrptoY9kd9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933858; c=relaxed/simple;
	bh=tt7x1MrDZu0AWT45Aaw75yRV9fgjFI/A3qBbo1H3nxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpNSRpDxT3TChRWJvMDFLt5z8hUcSKQsbIMRa3aJr/91WVNai8xqVjJHf3nfYUQ+TxaF3H8hNdJgVLdvvbyzRKoGNjhRjr/LIkXnaMjSUbDyAdkaW6KrqIVBn9bvGxvOVcfz7l3WMouYuQ9xZK4+ynoGDBZLy4ZIzdwRiLgCF/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgnwZjbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgnwZjbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4EDC433C7;
	Sat,  3 Feb 2024 04:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933858;
	bh=tt7x1MrDZu0AWT45Aaw75yRV9fgjFI/A3qBbo1H3nxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgnwZjbz2rOZxV+eFfDeMXZmHfMFqh3TP0Va18RntauObtexE9ZVYwDKPQ+VP7wLK
	 vVZ173rqK/gRpW3U5cDxfpbjLKCUBL5506OI3EENxsdwJGtAxzudoMTOl9IxdtrRaJ
	 9SIk+A86cCegrYYE2yFMigDnSrhGL4nIpPYkMOI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Adam Ford <aford173@gmail.com>
Subject: [PATCH 6.7 190/353] media: rkisp1: Drop IRQF_SHARED
Date: Fri,  2 Feb 2024 20:05:08 -0800
Message-ID: <20240203035409.680899716@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 894d5afaff4e..b676db9bff62 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -542,7 +542,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 		if (irq < 0)
 			return irq;
 
-		ret = devm_request_irq(dev, irq, info->isrs[i].isr, IRQF_SHARED,
+		ret = devm_request_irq(dev, irq, info->isrs[i].isr, 0,
 				       dev_driver_string(dev), dev);
 		if (ret) {
 			dev_err(dev, "request irq failed: %d\n", ret);
-- 
2.43.0



