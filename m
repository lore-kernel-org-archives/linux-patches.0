Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B002ECEBF;
	Tue, 17 Jun 2025 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175737; cv=none; b=Vc58Hm0jZfvV+E8yCjKWQwrUONgpyNtwR0/cQoT+6G/jFIvBVPkb4RunyagElKNija2xcT750nYdF15WNcOSnHxnqHwNsnQYqPWySBFo9WXuYRzKX1uFREpCfYwjDm3QuuebgR3vCJk2Ngf+RrwD0pNykixDXNI0OAqULjI13AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175737; c=relaxed/simple;
	bh=o+USO4IWPRoXVyY0fyraN5W4TG2Uz0AVCcXWdPa/phc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bwHuh/a3K7+1+1fE3Gl+IvJGjWVF1O62Yp4a0r9n2xtrrYMHtx7PRDv1uP2j2xl+ihwUHJ7gAO67E5eg/jxXbPMYid438fZKSN1BLXuxn/XyHWlSTzRVa2FDXdRIk/4LmpX/f5JYlbwaHdtsBz5laBsgzqCqakQJx59GVIa66/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dW0yL7cI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dW0yL7cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44D3C4CEE3;
	Tue, 17 Jun 2025 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175737;
	bh=o+USO4IWPRoXVyY0fyraN5W4TG2Uz0AVCcXWdPa/phc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dW0yL7cI2BHjsOiL4PKFO7sURsneHlYCz7YYbQlURKUGRxsTvtlePgETTden1cMHg
	 qHzaYCS5vUt591TGCkW97Dptnkg64k2yyj2IwWJ+J9esRbCYRfBC/i/T6sLx1Qw4jg
	 lrzSZVeb+mosQbGdSB6hioVbVwGzZgp4O7+m1ORs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 118/780] drm/v3d: client ranges from axi_ids are different with V3D 7.1
Date: Tue, 17 Jun 2025 17:17:06 +0200
Message-ID: <20250617152456.306286506@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Maria Casanova Crespo <jmcasanova@igalia.com>

[ Upstream commit a22e0051f9eb2281b181218d97f77cebc299310d ]

The client mask has been reduced from 8 bits on V3D 4.1 to 7 bits
on V3D 7.1, so the ranges for each client are not compatible.

On V3D 7.1, the CSD client can also report MMU errors.
Therefore, add its AXI ID to the IDs list.

Fixes: 0ad5bc1ce463 ("drm/v3d: fix up register addresses for V3D 7.x")
Signed-off-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://lore.kernel.org/r/20250425122522.18425-2-jmcasanova@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_irq.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
index d6ce1324905df..2cca5d3a26a22 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -199,12 +199,33 @@ v3d_hub_irq(int irq, void *arg)
 			{0xA0, 0xA1, "TFU"},
 			{0xC0, 0xE0, "MMU"},
 			{0xE0, 0xE1, "GMP"},
+		}, v3d71_axi_ids[] = {
+			{0x00, 0x30, "L2T"},
+			{0x30, 0x38, "CLE"},
+			{0x38, 0x39, "PTB"},
+			{0x39, 0x3A, "PSE"},
+			{0x3A, 0x3B, "CSD"},
+			{0x40, 0x60, "TLB"},
+			{0x60, 0x70, "MMU"},
+			{0x7C, 0x7E, "TFU"},
+			{0x7F, 0x80, "GMP"},
 		};
 		const char *client = "?";
 
 		V3D_WRITE(V3D_MMU_CTL, V3D_READ(V3D_MMU_CTL));
 
-		if (v3d->ver >= V3D_GEN_41) {
+		if (v3d->ver >= V3D_GEN_71) {
+			size_t i;
+
+			axi_id = axi_id & 0x7F;
+			for (i = 0; i < ARRAY_SIZE(v3d71_axi_ids); i++) {
+				if (axi_id >= v3d71_axi_ids[i].begin &&
+				    axi_id < v3d71_axi_ids[i].end) {
+					client = v3d71_axi_ids[i].client;
+					break;
+				}
+			}
+		} else if (v3d->ver >= V3D_GEN_41) {
 			size_t i;
 
 			axi_id = axi_id & 0xFF;
-- 
2.39.5



