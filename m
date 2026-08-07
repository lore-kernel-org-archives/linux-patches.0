Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A5D368276;
	Fri,  7 Aug 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114533; cv=none; b=Z/0QfqvjxRw6zDYWa2ZGoyhitbmrk1CMeqj9FVyo3LVFxwZ9MOkj9e3y5/eR1XhOUmzx5VManknEc3W8Km4fiaYOmTjeMDh5zOMV1F1Uysuq6XDFpC4FolKpKhXxhM2w4OHzLSfk41x3thH6FvVWjT7wmkvfi3UACk5brBv7J9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114533; c=relaxed/simple;
	bh=70D3Wpu2e3yivbDsnPweyqachAbyCxT5m5Nbl3AqjLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsIECSjcqeSuWaF+e2sOHnGIKSWvUbDwTbpPgcuwfN6p+nlpV7fGnNOl0LpMui8RpVQ9ZSPV9K69Q8BYpl/ZecUxFUtUi368iJd7P6c3TKD44QeXpGW+GCLJF9Eb5DQOci/CT8WvRuRzkP2UBvHTSGJiVrHmRaLlF6L3C1e/R5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1Xx8bS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1Xx8bS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75701F00A3D;
	Fri,  7 Aug 2026 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114530;
	bh=7nEUCaTuS+KSS71NRQx0IRY3W7JAhISZD8KyhcUh2Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1Xx8bS0ifxQ+hMABRr+/BZZ8rciUEDTSD9hoKN1liMRwsVT9ey1R8fgVEw9m3n47
	 hqmbj1eUc9Jvju0nj7J1Oy9aA2wn5y8Mho+it6Cgp08i8WKfP3MkkfWgRTChBRoZ0r
	 xA/Z5Xj2DYnVVaXC2ovC6n9ABElY1H6KnwO0Xwow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/337] media: imx219: Fix maximum frame length in lines
Date: Fri,  7 Aug 2026 16:38:18 +0200
Message-ID: <20260807143424.922340172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 2c4f1ba7354312ad2d6e34e70a518a51a9344715 ]

The driver used the maximum frame length in lines value of 0xffff, but the
maximum appears to be 0xfffe instead. Fix it.

Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 
 /* HBLANK control - read only */


