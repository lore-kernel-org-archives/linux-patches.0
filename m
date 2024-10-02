Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6251D1E98;
	Wed,  2 Oct 2024 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878241; cv=none; b=gEFdHCcCrWxolj3xpJMEr5BsKsyCCUgnkbcIEHRGPqgVHPIKeXNO0ErizGiN4Obf2DW11iPEPF+sBTsj4UvGl84RG/uviuH3DVRqOTMomgr8KYk8S4EPAgASAJNJfqd61nt9LS+5vRXLr+ufgx7GdSZnMAtYN09YOqrYq5bamsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878241; c=relaxed/simple;
	bh=Y9jKj+m2I+qSbCaBxXWOLMrM01ObuxruwVr+iw6/bCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovvaPuw7dQlXZG2hU0EM0oVwm2Oh+pshDsua9+d/jvx3baspt358GqhkhjCODiGV+Pk8SHBzNWAznUaNqa7IdfmZBKEDLZmSRlfjWh7SPDIPDfabTvGQWAhNSkkbBE4hMmY53Cu529+S7GbJ06WXzOyMYEglFGSU7ApiL9l+zkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcJl3EQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcJl3EQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EE3C4CEC2;
	Wed,  2 Oct 2024 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878241;
	bh=Y9jKj+m2I+qSbCaBxXWOLMrM01ObuxruwVr+iw6/bCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcJl3EQY80uNdpIdwTZwYaRjt81TMyVpbOq7N4/alI19tq0uwC5DErPSdIxn1Fd4G
	 jzHoApRnS2m5CnqHnwOpMZSzDU3qTmhdsvZ/HW7WidD58pYV9HytJBwuIcJT8p7FIJ
	 e63HJ7jxQq0aBWnLb2QQFrJxp1HK4C0FEjW+S5vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 347/634] media: platform: rzg2l-cru: rzg2l-csi2: Add missing MODULE_DEVICE_TABLE
Date: Wed,  2 Oct 2024 14:57:27 +0200
Message-ID: <20241002125824.796504438@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 07668fb0f867388bfdac0b60dbf51a4ad789f8e7 ]

The rzg2l-csi2 driver can be compiled as a module, but lacks
MODULE_DEVICE_TABLE() and will therefore not be loaded automatically.
Fix this.

Fixes: 51e8415e39a9 ("media: platform: Add Renesas RZ/G2L MIPI CSI-2 receiver driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240731164935.308994-1-biju.das.jz@bp.renesas.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c b/drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c
index e68fcdaea207a..c7fdee347ac8a 100644
--- a/drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c
+++ b/drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c
@@ -865,6 +865,7 @@ static const struct of_device_id rzg2l_csi2_of_table[] = {
 	{ .compatible = "renesas,rzg2l-csi2", },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, rzg2l_csi2_of_table);
 
 static struct platform_driver rzg2l_csi2_pdrv = {
 	.remove_new = rzg2l_csi2_remove,
-- 
2.43.0



