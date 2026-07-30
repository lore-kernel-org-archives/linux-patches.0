Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD2D3B4E9B;
	Thu, 30 Jul 2026 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422577; cv=none; b=nEiqUNl6GzgJFDp3JyvvtgjGzz1dbJFXuSzFTB1i/SCOUPSlJJUhIUtrr6vyaPATOHP2Xvoksx1p0KvhS19ix5mRTtZAinAzhaKrcfAElpqRT3rrQVcbL26B37mXuJuW3x9m48kHr8Hzkk0AdFrVaBOkb0hxfYublN1zcqCebOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422577; c=relaxed/simple;
	bh=VNRYirEKXUCl6yF5uDVqrG273IhecT2inNd+enaaxgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6dHAaoCzmsKUXSQy/eD14ICgCanKntDPvO9X4BbTS0RdZZiDBv4iLajIaRu/lalyQ866TTz6olb/CaFgTE9OmwpPKr/qFn+knyOLxwIJclhQV3IlEJK1n6k0je7igMmDSZlMlh9WS58PEZXH1DU3SKPRFQ0Yk1OUE3k4umnorQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2fHtfFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2fHtfFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990AC1F000E9;
	Thu, 30 Jul 2026 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422576;
	bh=eiNtk01cWF/SMQQthlm0SLSj3jYU5pnmICrl3XUBZhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2fHtfFmLdov1CFfxwI1FBdYRsa5Wkjk3ioOjxUOIaaUhZdB6zp1MMe1csGaPBuNi
	 veIX6goMIQSTd+OTLAzbOqB1dSRicGqH2xHLmj3vTsil/TSExuFP8sWGVVrCVgU4IY
	 OhKQT3i75LFfItfajbTmz31BmdeO/pGXHdWr10nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 7.1 486/744] media: imx219: Fix maximum frame length in lines
Date: Thu, 30 Jul 2026 16:12:39 +0200
Message-ID: <20260730141454.625778322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 2c4f1ba7354312ad2d6e34e70a518a51a9344715 upstream.

The driver used the maximum frame length in lines value of 0xffff, but the
maximum appears to be 0xfffe instead. Fix it.

Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -72,7 +72,7 @@
 
 /* V_TIMING internal */
 #define IMX219_REG_FRM_LENGTH_A		CCI_REG16(0x0160)
-#define IMX219_FLL_MAX			0xffff
+#define IMX219_FLL_MAX			0xfffe
 #define IMX219_VBLANK_MIN		32
 #define IMX219_REG_LINE_LENGTH_A	CCI_REG16(0x0162)
 #define IMX219_LLP_MIN			0x0d78


