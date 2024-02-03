Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29C239877;
	Sat,  3 Feb 2024 04:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933609; cv=none; b=emmvNhSTqETkOiSNYJQFN9eW10TwCnFZiR438oKabZeZhQI8alZOJDBshShzhjeI2mG5GyJSWHrw2I4UhYwWgkjvTkR1eTpnqM1UKnlAPwRrayeGRH5mWH+4KbJDdIwr6ZUEFMxM6aOv2YhxK83CtfUdv9Ao9ujrZ+bbgcW4pDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933609; c=relaxed/simple;
	bh=X3r8w1cfdHRCAxXqsZPJHKqAli5dwY0Rp59TO8ArO50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUZMBScK+KMEExvMpnkLZxFDihTOqm+7CzTlsyuDxpTHaozkFL9jsf5UzvsWjCzjGodw3AEcYVRujfwkmFc/lhfNaQRBWjzIEHQZegCJ7Ng6EGfnfljL8iq+Y5Hepe1MjkDYFHZ4lJvXk5t4VFd92+4P8BIcMXtXP8tFs/Ez4TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjbEW45R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjbEW45R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B333C433F1;
	Sat,  3 Feb 2024 04:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933609;
	bh=X3r8w1cfdHRCAxXqsZPJHKqAli5dwY0Rp59TO8ArO50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjbEW45RYKYS055JVhuwZT9OEOQR8wfSykXTMJyiY9mDpRB7NTprjsioTYocXN7Ut
	 KrR9RIDo3asXj+otalcT00fzAY3mbzIZD/OEmYx7BmCy+qo67WCoDcd8fo6sk4vg9E
	 p9FJymRZKVx1hOBzuIxP4eFWiVxxGwqhmKPeebzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Adam Ford <aford173@gmail.com>
Subject: [PATCH 6.6 180/322] media: rkisp1: Drop IRQF_SHARED
Date: Fri,  2 Feb 2024 20:04:37 -0800
Message-ID: <20240203035405.071562565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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



