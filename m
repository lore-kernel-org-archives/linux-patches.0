Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BD4136988;
	Mon, 23 Jun 2025 13:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684410; cv=none; b=GfKWB8d9Ci3kk824BCrdaR1YgTNSm3Z2++LouxLLY99CHH/0fCvnxn99iPUwfAxewI4SF4gZI05RSh0fnn++I5hxEe2fdAnsCZxxlCrfua3wQrpQyufduen6fNjQgPSwPuLSHBK59a28wa1B63pGMeoWgLTJSTma28wWIm0dWFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684410; c=relaxed/simple;
	bh=9rVyxKvlrzkQ+xSRMZGRXeUvvWQtOH8OreSzhlV8/R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CayMm36WHYLtTk12xW1vRty8RF4wZrDyeyPNn+e0ubeQZuJOu0pNhkVGBtC6oNfNgA+Gmcf8tvSGSu2nghr/iA+Orfe450qv6HNXiQlhnaIBWbPWQp6LIYboUVMK9ougPcG9lHhh+EcQ5CfPrmiWI9pNhDQlvnSIxqx/sOOE4NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzjRBDwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzjRBDwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F810C4CEEA;
	Mon, 23 Jun 2025 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684409;
	bh=9rVyxKvlrzkQ+xSRMZGRXeUvvWQtOH8OreSzhlV8/R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzjRBDwiI9EnJUuTc8t+azmTbNeNv0aiI4IJezvL4d4/k4iBJmJR0Tlt9vxCcH7Ld
	 ItkMLMsfpcOD8+Ry4N6r5IOK0ipr4R3nd0oQFP8RzMZwg2n8YGfwOUwKuUTWr45bYT
	 MSGhiYpr7wLhM8DQ4zUaIEhMzvcovBON1j7CzHNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongcheng Yan <dongcheng.yan@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 057/592] media: i2c: change lt6911uxe irq_gpio name to "hpd"
Date: Mon, 23 Jun 2025 15:00:15 +0200
Message-ID: <20250623130701.614331346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongcheng Yan <dongcheng.yan@intel.com>

commit 20244cbafbd6c8486347bb82d972f6e2d2d5a201 upstream.

Lt6911uxe is used in IPU6 / x86 platform, worked with an out-of-tree
int3472 patch and upstream intel/ipu6 before. It is only used on ACPI
platforms till now and there are no devicetree bindings for this
driver.

The upstream int3472 driver uses "hpd" instead of "readystat" now.
this patch updates the irq_gpio name to "hpd" accordingly, so that
mere users can now use the upstream version directly without relying
on out-of-tree int3472 pin support.

The new name "hpd" (Hotplug Detect) aligns with common naming
conventions used in other drivers(like adv7604) and documentation.

Fixes: e49563c3be09d4 ("media: i2c: add lt6911uxe hdmi bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Dongcheng Yan <dongcheng.yan@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/lt6911uxe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/lt6911uxe.c
+++ b/drivers/media/i2c/lt6911uxe.c
@@ -605,10 +605,10 @@ static int lt6911uxe_probe(struct i2c_cl
 		return dev_err_probe(dev, PTR_ERR(lt6911uxe->reset_gpio),
 				     "failed to get reset gpio\n");
 
-	lt6911uxe->irq_gpio = devm_gpiod_get(dev, "readystat", GPIOD_IN);
+	lt6911uxe->irq_gpio = devm_gpiod_get(dev, "hpd", GPIOD_IN);
 	if (IS_ERR(lt6911uxe->irq_gpio))
 		return dev_err_probe(dev, PTR_ERR(lt6911uxe->irq_gpio),
-				     "failed to get ready_stat gpio\n");
+				     "failed to get hpd gpio\n");
 
 	ret = lt6911uxe_fwnode_parse(lt6911uxe, dev);
 	if (ret)


