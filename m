Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4741586D3;
	Tue,  9 Jul 2024 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524325; cv=none; b=Nu5iBduwGYaW5bD3PvVeB49NohiDT0nF8W2jh1/qC+U9WPBHzbaTNYBdzuJr2c77N0EKVc8D+9S/lANNh/h+ZPK2ZF1Jkr6BsCVYccbkKKqKtzequGRdxCle6lbz+lqCOw4kwH3x4YVOlKttaN9Hbk+RM2MHNzeMefWXNuVLoXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524325; c=relaxed/simple;
	bh=4aB/4rSx5rC3Vk13idBRNXMiVuvsYh4yxgEfjeKRdfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMiAkeV2ZiVfhVG3onB/1ZUSYGDlHgBuBmIEUx0hCRCNWchteVbXO07Y1N8qBOb2ITTIQ+p9rjXBbn69/WQAOHoqYSZCsigDH08KXsiWVaDWd+2Zlzdb2UwZCs2cXB+jDYdXaHdm+2suQNEO0g/p5xUxkn0yIPNvhMsuQX9MCng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfIleVli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfIleVli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18154C32786;
	Tue,  9 Jul 2024 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524324;
	bh=4aB/4rSx5rC3Vk13idBRNXMiVuvsYh4yxgEfjeKRdfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfIleVliNJHS8hjlTsvMhzKoK1Ca6D2ebIXs73b+eeI2/20C92Wn2bca9m8T4udM9
	 yCWTxVdu1aqMgCzWqETtStRjiDgF2NmjkfYK9pvDyz3Gp+zQki3sW0LYmi8hl/h1em
	 mfgequGQDuGv+G+xcpNrk9/Fq2pieSIC4AOM+4a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.9 146/197] can: kvaser_usb: Explicitly initialize family in leafimx driver_info struct
Date: Tue,  9 Jul 2024 13:10:00 +0200
Message-ID: <20240709110714.600339555@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Assarsson <extja@kvaser.com>

commit 19d5b2698c35b2132a355c67b4d429053804f8cc upstream.

Explicitly set the 'family' driver_info struct member for leafimx.
Previously, the correct operation relied on KVASER_LEAF being the first
defined value in enum kvaser_usb_leaf_family.

Fixes: e6c80e601053 ("can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression")
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20240628194529.312968-1-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -125,6 +125,7 @@ static const struct kvaser_usb_driver_in
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
 	.quirks = 0,
+	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 


