Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DB715703D;
	Mon, 29 Jan 2024 17:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548303; cv=none; b=Cughn0Qy8qTP+FU+uNcVhTkvJRemedqcpVxeCiOtDuMhMm1fYhPMmnca8E5S+ucnDHiIPJjYREvz66xIoEVgyfQ6BdcfG7S2C0QkZv7k9r3P/WzzhxY0IGsU+9zG19mBVcoARyCxQoxrhGdeNmZMMjsPQzkNoS8aNiGxGQJ9mlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548303; c=relaxed/simple;
	bh=TCZAsNi5BK2MbsjCEOzhNHlF3AcNwgXQqgmenrtn494=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCn4nT9V9+63AhpuO6GpbMAbSVKgLXVYYgydK6j5IZc5Mxrn128BycUCrqnLALEfoKWsjbHPz47sNeDjfrCZy8egWBql20cV09B81pnxKmxghh21ALBKPCBBoeI9kqNpJ+hsWg/bVXImKjLETtcEZpgeALrPd0hypzL2kKC8KGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+GtnmT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+GtnmT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF0BC433C7;
	Mon, 29 Jan 2024 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548303;
	bh=TCZAsNi5BK2MbsjCEOzhNHlF3AcNwgXQqgmenrtn494=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+GtnmT41pPd2jfYaplSXPnp1Qc2ry9IYv70KNcKkavHYaqekQ7NOi/1YBG021ymz
	 EC0tx/jpKMpAOQfmh+77xJ8Th0Q5+eqZ38XMQVgytnGAlla5Ye9GkZcQIzvpTi+TNc
	 Qy6poXeHNMbcOGVG4aY0Je05Z2fA2sRXkw1xZur0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 286/346] media: i2c: imx290: Properly encode registers as little-endian
Date: Mon, 29 Jan 2024 09:05:17 -0800
Message-ID: <20240129170024.798290232@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 60fc87a69523c294eb23a1316af922f6665a6f8c ]

The conversion to CCI also converted the multi-byte register access to
big-endian. Correct the register definition by using the correct
little-endian ones.

Fixes: af73323b9770 ("media: imx290: Convert to new CCI register access helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[Sakari Ailus: Fixed the Fixes: tag.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx290.c | 42 +++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/imx290.c b/drivers/media/i2c/imx290.c
index 29098612813c..c6fea5837a19 100644
--- a/drivers/media/i2c/imx290.c
+++ b/drivers/media/i2c/imx290.c
@@ -41,18 +41,18 @@
 #define IMX290_WINMODE_720P				(1 << 4)
 #define IMX290_WINMODE_CROP				(4 << 4)
 #define IMX290_FR_FDG_SEL				CCI_REG8(0x3009)
-#define IMX290_BLKLEVEL					CCI_REG16(0x300a)
+#define IMX290_BLKLEVEL					CCI_REG16_LE(0x300a)
 #define IMX290_GAIN					CCI_REG8(0x3014)
-#define IMX290_VMAX					CCI_REG24(0x3018)
+#define IMX290_VMAX					CCI_REG24_LE(0x3018)
 #define IMX290_VMAX_MAX					0x3ffff
-#define IMX290_HMAX					CCI_REG16(0x301c)
+#define IMX290_HMAX					CCI_REG16_LE(0x301c)
 #define IMX290_HMAX_MAX					0xffff
-#define IMX290_SHS1					CCI_REG24(0x3020)
+#define IMX290_SHS1					CCI_REG24_LE(0x3020)
 #define IMX290_WINWV_OB					CCI_REG8(0x303a)
-#define IMX290_WINPV					CCI_REG16(0x303c)
-#define IMX290_WINWV					CCI_REG16(0x303e)
-#define IMX290_WINPH					CCI_REG16(0x3040)
-#define IMX290_WINWH					CCI_REG16(0x3042)
+#define IMX290_WINPV					CCI_REG16_LE(0x303c)
+#define IMX290_WINWV					CCI_REG16_LE(0x303e)
+#define IMX290_WINPH					CCI_REG16_LE(0x3040)
+#define IMX290_WINWH					CCI_REG16_LE(0x3042)
 #define IMX290_OUT_CTRL					CCI_REG8(0x3046)
 #define IMX290_ODBIT_10BIT				(0 << 0)
 #define IMX290_ODBIT_12BIT				(1 << 0)
@@ -78,28 +78,28 @@
 #define IMX290_ADBIT2					CCI_REG8(0x317c)
 #define IMX290_ADBIT2_10BIT				0x12
 #define IMX290_ADBIT2_12BIT				0x00
-#define IMX290_CHIP_ID					CCI_REG16(0x319a)
+#define IMX290_CHIP_ID					CCI_REG16_LE(0x319a)
 #define IMX290_ADBIT3					CCI_REG8(0x31ec)
 #define IMX290_ADBIT3_10BIT				0x37
 #define IMX290_ADBIT3_12BIT				0x0e
 #define IMX290_REPETITION				CCI_REG8(0x3405)
 #define IMX290_PHY_LANE_NUM				CCI_REG8(0x3407)
 #define IMX290_OPB_SIZE_V				CCI_REG8(0x3414)
-#define IMX290_Y_OUT_SIZE				CCI_REG16(0x3418)
-#define IMX290_CSI_DT_FMT				CCI_REG16(0x3441)
+#define IMX290_Y_OUT_SIZE				CCI_REG16_LE(0x3418)
+#define IMX290_CSI_DT_FMT				CCI_REG16_LE(0x3441)
 #define IMX290_CSI_DT_FMT_RAW10				0x0a0a
 #define IMX290_CSI_DT_FMT_RAW12				0x0c0c
 #define IMX290_CSI_LANE_MODE				CCI_REG8(0x3443)
-#define IMX290_EXTCK_FREQ				CCI_REG16(0x3444)
-#define IMX290_TCLKPOST					CCI_REG16(0x3446)
-#define IMX290_THSZERO					CCI_REG16(0x3448)
-#define IMX290_THSPREPARE				CCI_REG16(0x344a)
-#define IMX290_TCLKTRAIL				CCI_REG16(0x344c)
-#define IMX290_THSTRAIL					CCI_REG16(0x344e)
-#define IMX290_TCLKZERO					CCI_REG16(0x3450)
-#define IMX290_TCLKPREPARE				CCI_REG16(0x3452)
-#define IMX290_TLPX					CCI_REG16(0x3454)
-#define IMX290_X_OUT_SIZE				CCI_REG16(0x3472)
+#define IMX290_EXTCK_FREQ				CCI_REG16_LE(0x3444)
+#define IMX290_TCLKPOST					CCI_REG16_LE(0x3446)
+#define IMX290_THSZERO					CCI_REG16_LE(0x3448)
+#define IMX290_THSPREPARE				CCI_REG16_LE(0x344a)
+#define IMX290_TCLKTRAIL				CCI_REG16_LE(0x344c)
+#define IMX290_THSTRAIL					CCI_REG16_LE(0x344e)
+#define IMX290_TCLKZERO					CCI_REG16_LE(0x3450)
+#define IMX290_TCLKPREPARE				CCI_REG16_LE(0x3452)
+#define IMX290_TLPX					CCI_REG16_LE(0x3454)
+#define IMX290_X_OUT_SIZE				CCI_REG16_LE(0x3472)
 #define IMX290_INCKSEL7					CCI_REG8(0x3480)
 
 #define IMX290_PGCTRL_REGEN				BIT(0)
-- 
2.43.0



