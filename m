Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FBA76051;
	Mon, 29 Jan 2024 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548631; cv=none; b=p527Kk1kJGhidvq788Tqc/r7TReymPNZ87/inGS779itvdlg7k/uiq+d6re3FOMXhJ3aftRPpuxtiHlZOkuXkEQRitgkC2wPxyoSdpqZxaOTkHrc/bs/3RpGvMebW8D3HYFTMhTrh9lCjFXNhuUmQi5RmNzcMV7NR3uJMzCTp5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548631; c=relaxed/simple;
	bh=XgQIvs8XtoZD3PzsV6hb4pUzZapiKARTl+ft/Vzv95w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPXj1D5pTQn7wDs3gMF/Sxm2SC9Y4f5yER6gZyWBnkERy5MygzQ0jMzM4I/vQNNjVGO2/HKKRDpnYzNMe8iwm2WjuvASqiiAZJ8N7qvBg42QkjxPoOR4EUaa5YGm2wGTcmwGBDam44H9Z2VoXjoG9GrKNK2n1Pe65YGXWzyd/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/AZd2il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/AZd2il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A73C43399;
	Mon, 29 Jan 2024 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548630;
	bh=XgQIvs8XtoZD3PzsV6hb4pUzZapiKARTl+ft/Vzv95w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/AZd2ilQRa1rZoZn9fMggvIqtd6cobH4LFVV+R6sj2DzTCZ2/wGfKnT01ElpelQL
	 uVugCQjr2wJFQrNfcTD9uJvq/XgZy8Z2gnLbA3kMQKsNSeSqlM9DL7G+wv8KMNQ0gA
	 WYfKuXaGZBpNefzqirx2KnpkDBPvP3qoGfXuv8E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/331] media: v4l: cci: Add macros to obtain register width and address
Date: Mon, 29 Jan 2024 09:05:44 -0800
Message-ID: <20240129170023.056975525@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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



