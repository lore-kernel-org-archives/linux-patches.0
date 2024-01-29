Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B2B15B961;
	Mon, 29 Jan 2024 17:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548271; cv=none; b=jxlRp8OV/QVZ0NsKBeReIOvglo1lK/OHhWtm616sg5TBBtfX042ESpVM4/pkSKMKkoqREFWRCkv0B5uaIaPkfVIBwn1RnPvFWEc6VZi0jst/Oqg44K1yavvDsz8WsVh3hFu8WriJXJUBfshiymlPoIoPcjA0IpOibQA1ZJrJZbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548271; c=relaxed/simple;
	bh=5oqWWDfeTuW2HyDLeuoSO4d2ZJuSgCuL7B9aXYum+0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvdlUpSB2pTepH+l4StnYXBmMblsozK4rR5Y1xaaDTeDSREEvwuLkbLmgPDXLaZKbbWEsOTXzfek8fInYeTzOicK9r2Jo5xX//0pJdCwccTDdKu0luXeC4fREkle3MRsmciYYvD6iZQaCzh5wfrG0ERqG4c8fFE7jxyINuKTxd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEvhfXNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEvhfXNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2653C433F1;
	Mon, 29 Jan 2024 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548271;
	bh=5oqWWDfeTuW2HyDLeuoSO4d2ZJuSgCuL7B9aXYum+0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEvhfXNNM1Wz+Tt9H8dBJh6SyDixf/ylWZblmQU03+x3463dDibt+z1L2dAQhlNRl
	 DkkQR8/13WDL2R5pLKxi6Kfx4IXc2hVDIo8F7PsziUGGNvBEhJhQDT1JdrhOnO7rfD
	 XGsnzznuGb7MtxXN//HKSIvg1nIVNkBrwaJgzl8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 284/346] media: v4l: cci: Add macros to obtain register width and address
Date: Mon, 29 Jan 2024 09:05:15 -0800
Message-ID: <20240129170024.739270927@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit cd93cc245dfe334c38da98c14b34f9597e1b4ea6 ]

Add CCI_REG_WIDTH() macro to obtain register width in bits and similarly,
CCI_REG_WIDTH_BYTES() to obtain it in bytes.

Also add CCI_REG_ADDR() macro to obtain the address of a register.

Use both macros in v4l2-cci.c, too.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: d92e7a013ff3 ("media: v4l2-cci: Add support for little-endian encoded registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-cci.c | 8 ++++----
 include/media/v4l2-cci.h           | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-cci.c b/drivers/media/v4l2-core/v4l2-cci.c
index bc2dbec019b0..3179160abde3 100644
--- a/drivers/media/v4l2-core/v4l2-cci.c
+++ b/drivers/media/v4l2-core/v4l2-cci.c
@@ -25,8 +25,8 @@ int cci_read(struct regmap *map, u32 reg, u64 *val, int *err)
 	if (err && *err)
 		return *err;
 
-	len = FIELD_GET(CCI_REG_WIDTH_MASK, reg);
-	reg = FIELD_GET(CCI_REG_ADDR_MASK, reg);
+	len = CCI_REG_WIDTH_BYTES(reg);
+	reg = CCI_REG_ADDR(reg);
 
 	ret = regmap_bulk_read(map, reg, buf, len);
 	if (ret) {
@@ -75,8 +75,8 @@ int cci_write(struct regmap *map, u32 reg, u64 val, int *err)
 	if (err && *err)
 		return *err;
 
-	len = FIELD_GET(CCI_REG_WIDTH_MASK, reg);
-	reg = FIELD_GET(CCI_REG_ADDR_MASK, reg);
+	len = CCI_REG_WIDTH_BYTES(reg);
+	reg = CCI_REG_ADDR(reg);
 
 	switch (len) {
 	case 1:
diff --git a/include/media/v4l2-cci.h b/include/media/v4l2-cci.h
index f2c2962e936b..a2835a663df5 100644
--- a/include/media/v4l2-cci.h
+++ b/include/media/v4l2-cci.h
@@ -7,6 +7,7 @@
 #ifndef _V4L2_CCI_H
 #define _V4L2_CCI_H
 
+#include <linux/bitfield.h>
 #include <linux/bits.h>
 #include <linux/types.h>
 
@@ -34,6 +35,10 @@ struct cci_reg_sequence {
 #define CCI_REG_WIDTH_SHIFT		16
 #define CCI_REG_WIDTH_MASK		GENMASK(19, 16)
 
+#define CCI_REG_WIDTH_BYTES(x)		FIELD_GET(CCI_REG_WIDTH_MASK, x)
+#define CCI_REG_WIDTH(x)		(CCI_REG_WIDTH_BYTES(x) << 3)
+#define CCI_REG_ADDR(x)			FIELD_GET(CCI_REG_ADDR_MASK, x)
+
 #define CCI_REG8(x)			((1 << CCI_REG_WIDTH_SHIFT) | (x))
 #define CCI_REG16(x)			((2 << CCI_REG_WIDTH_SHIFT) | (x))
 #define CCI_REG24(x)			((3 << CCI_REG_WIDTH_SHIFT) | (x))
-- 
2.43.0



