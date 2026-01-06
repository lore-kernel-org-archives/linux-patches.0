Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB8235503A;
	Tue,  6 Jan 2026 17:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720252; cv=none; b=uZf5KKsDUGjLDkRHpI0G0J7UEf+Ijxs7yGXXrvpti/6P8yAGJAJNYnxQK3ymYbCD20H+1KL/2Zq7wHfZ+BPaRSqSgldltMAmxje39+lEvnBjehlljsKq6cATzE3bvWjaw8oDsFRmKbmJLGmxiBWOySGo/NeFEdWqd5HiPil7Z48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720252; c=relaxed/simple;
	bh=ehVoZxOnGI3nin9JWLKIuqBSsCQALK/hI4ZdYCd2fuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QlCi2CREqHm/gsIcOciS5o10Wou9uYLZXE8XhHWbu39ca7ImxdP+9NHAzjE9MdavfU6Wv2Hu8cZd960xNUKqnukWnBvoeJJM3bqO0ovL3FI3t/Uqp9PemLQlGqbLz4Yz2CiQ/VQrB+SGX8v5vjj2sXFEnLNioPBeydQsS05KkUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPxNvbel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPxNvbel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEE6C116C6;
	Tue,  6 Jan 2026 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720252;
	bh=ehVoZxOnGI3nin9JWLKIuqBSsCQALK/hI4ZdYCd2fuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPxNvbelaBeDZPGe4q/XpFjiHYfYs9KUQv49ALcbjGV6wLdnMbXBX5E5EGtQx68fN
	 B2TIj4tJJimzurzAWDlu8vnmvzCKKCyZq4dJGKkkgsbk2DlKD5Z87XWt928Uu7EEW6
	 C+M3NXCxhdY94uuRC/mxxHHflVO3j6CZhz2dVxCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 181/567] phy: broadcom: bcm63xx-usbh: fix section mismatches
Date: Tue,  6 Jan 2026 17:59:23 +0100
Message-ID: <20260106170458.024969043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 356d1924b9a6bc2164ce2bf1fad147b0c37ae085 upstream.

Platform drivers can be probed after their init sections have been
discarded (e.g. on probe deferral or manual rebind through sysfs) so the
probe function and match table must not live in init.

Fixes: 783f6d3dcf35 ("phy: bcm63xx-usbh: Add BCM63xx USBH driver")
Cc: stable@vger.kernel.org	# 5.9
Cc: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251017054537.6884-1-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-bcm63xx-usbh.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/phy/broadcom/phy-bcm63xx-usbh.c
+++ b/drivers/phy/broadcom/phy-bcm63xx-usbh.c
@@ -375,7 +375,7 @@ static struct phy *bcm63xx_usbh_phy_xlat
 	return of_phy_simple_xlate(dev, args);
 }
 
-static int __init bcm63xx_usbh_phy_probe(struct platform_device *pdev)
+static int bcm63xx_usbh_phy_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct bcm63xx_usbh_phy	*usbh;
@@ -432,7 +432,7 @@ static int __init bcm63xx_usbh_phy_probe
 	return 0;
 }
 
-static const struct of_device_id bcm63xx_usbh_phy_ids[] __initconst = {
+static const struct of_device_id bcm63xx_usbh_phy_ids[] = {
 	{ .compatible = "brcm,bcm6318-usbh-phy", .data = &usbh_bcm6318 },
 	{ .compatible = "brcm,bcm6328-usbh-phy", .data = &usbh_bcm6328 },
 	{ .compatible = "brcm,bcm6358-usbh-phy", .data = &usbh_bcm6358 },
@@ -443,7 +443,7 @@ static const struct of_device_id bcm63xx
 };
 MODULE_DEVICE_TABLE(of, bcm63xx_usbh_phy_ids);
 
-static struct platform_driver bcm63xx_usbh_phy_driver __refdata = {
+static struct platform_driver bcm63xx_usbh_phy_driver = {
 	.driver	= {
 		.name = "bcm63xx-usbh-phy",
 		.of_match_table = bcm63xx_usbh_phy_ids,


