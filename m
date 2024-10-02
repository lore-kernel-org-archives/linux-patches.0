Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE21D043E;
	Wed,  2 Oct 2024 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876255; cv=none; b=f4cLhzjopPAE/bzyeExON7RWIgRF0zdFHoipRdCrIFsQ63XSPpN5ds5sDcSua8BPWu+cdonPRHy3bI411USVplThG2jwYWHJVKvSgc1t0GLHT51Zri05Wj/ph2E5wscVyO2Gd90QID2A7Jq5mC3uZNt+/A0TkdZgLC2DUmV0BzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876255; c=relaxed/simple;
	bh=BLdUj+IAJzjgOZGwBFlfItW4FOT2BN5+zP9aVLErkgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLiaMdUBL90fdVipxQPllaDDAMriAj0eP3UOq1DZmgZhtjwJOOKzZpSh9IXRbXQuB8K1Qt0LC+e5GG0cCKfsSn+caUy34yEN+peXDOCDu94ZI2KWi4p0dXaKy+IlaS52ae3oteemckCl2n7jPpOjFE51RfHUCaWUK1dSQkmvdv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCR8AIov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCR8AIov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D414DC4CEC5;
	Wed,  2 Oct 2024 13:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876255;
	bh=BLdUj+IAJzjgOZGwBFlfItW4FOT2BN5+zP9aVLErkgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCR8AIovoux7lXxJPofGxC8PU4Zn7vyvRJzirKFblzoreOPUyYZ+zfKDqsBKg8Fw4
	 wJti3kGisefu53+fmroZDWCP+A8vP0KFWg4ZgcgFA3cUjtA0AkuEwzaik1VznTBRmy
	 Z1hL3FM3NUkxH+VqPfzPkG13qPRuQdyj03UG5CKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 381/695] media: platform: rzg2l-cru: rzg2l-csi2: Add missing MODULE_DEVICE_TABLE
Date: Wed,  2 Oct 2024 14:56:19 +0200
Message-ID: <20241002125837.667059958@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



