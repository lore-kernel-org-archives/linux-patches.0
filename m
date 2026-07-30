Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B3D30C618;
	Thu, 30 Jul 2026 15:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424476; cv=none; b=LfOJUUTlWfvfQt2o9QaIfSsjxyQWK+v76d2nZcRXb+/x9h5/Yw30YoPU6RHAOxe5y5i4PO/CwSxP4guY3w92PP/ZiP2zdtLXrsPzSXHzWg9CNsCRZ1deNQ6EFQZXJHU6/D+fmggzOv/gckrAJWMuFsA9O+w9fFJI++A1gfRJ0oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424476; c=relaxed/simple;
	bh=roziyrbvOTdFFyaopLSuhPkYn/r3le53ejmjrqwrfTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkEdPinQKXciAieSD7t9CPyh0x2S+NC8aqAap4DaxY2Dqct3z+4L4opL0oWQm9sIPngznF3wJGr4Rvq/c+zKzIeD7vYkLTClCNkGULPf5jsv3vioYSBgb9YgUaloZTtdBnLKESBGjgxZZ0iP5dhf4q4eC9oVzPN1mOq/yCl2tkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVxJcG8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVxJcG8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818CC1F000E9;
	Thu, 30 Jul 2026 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424475;
	bh=8liRo18hCve4zqLr812bGyk+M9/IYrX3BFGQlpWm8D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVxJcG8+Ii+kdO3Dzd1lzGbZiwHJ1rWZqWxsTuJ9N3H8ev/QXmbXOAMLJ97XPreSP
	 Dkmpg9YQNuVzk1me6ktAbAZli6Um1CBbYeAlcScCNuG0gkYqYGiFbJ7fdhPnFK9XeG
	 2PeEOde0gSwa2IF8Uk9Tq1G8ETo76eRYDm/PW3iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.18 405/675] media: imx219: Fix maximum frame length in lines
Date: Thu, 30 Jul 2026 16:12:15 +0200
Message-ID: <20260730141453.742253788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -71,7 +71,7 @@
 
 /* V_TIMING internal */
 #define IMX219_REG_FRM_LENGTH_A		CCI_REG16(0x0160)
-#define IMX219_FLL_MAX			0xffff
+#define IMX219_FLL_MAX			0xfffe
 #define IMX219_VBLANK_MIN		32
 #define IMX219_REG_LINE_LENGTH_A	CCI_REG16(0x0162)
 #define IMX219_LLP_MIN			0x0d78


