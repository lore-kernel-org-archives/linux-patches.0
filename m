Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B947224169B;
	Mon, 23 Jun 2025 13:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684412; cv=none; b=W9/0YNm2RIWtvBMsBcQTZLgBZxlQLur+3NXuGcOgz4/Sn5CVvVKMEydgIk6nt2/ZMsNi0IoTg5tOs+pApE8rD2Vl2oekOj2OjeuDJLkbTWwz1Dm7kTIfR75jVVbLufksfU50z6SeNw0Ir1akITl+ZTrAp2PXROeGoozq2BiPSI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684412; c=relaxed/simple;
	bh=AxvU0QFVTr+VQFJDd6gHS9CZTP9k5OlV20wIiCEcbUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixMiqEUf3ATndPiC6mYHfHiiT9BMEsWvOVjQyAm0G3toL2sM1m49YMkJLJYll8UTHuatRkavB89b0lf5umKEGtTu+elBz+wZbqf6lBw839p84piGFmzlsl39A7/w8iFYhpb1gDnO2mf7WyzJHsL5JHXWLANtd33UOgXZ5qHhBSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpgvmdWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpgvmdWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B112C4CEEA;
	Mon, 23 Jun 2025 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684412;
	bh=AxvU0QFVTr+VQFJDd6gHS9CZTP9k5OlV20wIiCEcbUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpgvmdWcnr95ZbNNSFcjGfwznE1nKbPuYQxnd2uPWP1xNAx4PFfWCm31bu2URvgMx
	 FuFbAl5gD0R2kg/T9SPzaRX//QhcSFNNn4B2K1/03dFLWNaXtQoEsCy3wt3pl7eSp9
	 mKE+vw7bTJVzL9D7iSBCmkqwp39iZzdRpYe9h4ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 058/592] media: imx335: Use correct register width for HNUM
Date: Mon, 23 Jun 2025 15:00:16 +0200
Message-ID: <20250623130701.637510292@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

commit b122c9cfcb39c8ef520d50eddfbe15f3e6551a50 upstream.

CCI_REG_HNUM should be using CCI_REG16_LE() instead of CCI_REG8()
as HNUM spans from 0x302e[0:7] to 0x302f[0:3].

Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Fixes: 8f0926dba799 ("media: imx335: Use V4L2 CCI for accessing sensor registers")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx335.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -31,7 +31,7 @@
 #define IMX335_REG_CPWAIT_TIME		CCI_REG8(0x300d)
 #define IMX335_REG_WINMODE		CCI_REG8(0x3018)
 #define IMX335_REG_HTRIMMING_START	CCI_REG16_LE(0x302c)
-#define IMX335_REG_HNUM			CCI_REG8(0x302e)
+#define IMX335_REG_HNUM			CCI_REG16_LE(0x302e)
 
 /* Lines per frame */
 #define IMX335_REG_VMAX			CCI_REG24_LE(0x3030)


