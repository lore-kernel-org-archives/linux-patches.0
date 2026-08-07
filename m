Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1748B46AA62;
	Fri,  7 Aug 2026 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116443; cv=none; b=oeNFlUnvxciAtLcOD0QpRnLtPEfxNXp1CYuQguci1CYqC5UEkGdzFtgg3vihCKXSeE3PI+oR79DJXFPbnPi4k0TgzkADBg4E8x7pdJ9FOv4LP38P2Yvey1PXxDFl+qn5jUjDzzdP9rhoDZKulqBUCo1rIQJkDIc4xaOgmgWTM2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116443; c=relaxed/simple;
	bh=uAcEIqjlxxGVJ154x/qAWU5jUYbR5+/wGjrlS7SH78c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAvIuO1BpT2Q3BiigL13I4SqZv0gE0CT83hsXP1q4fZeZUH6TrXGXXjI6BhF7FKdLg4/eOTadvHQfDz9gdVeHBYOsnXphOvT9pRZwoUIiLf4qRRZkh6A4fcy5pz/SB5jXZ7kSDBT7ibeG/fnkrye1i57nx0iMsk/AGaNjeyQxO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+xf884r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+xf884r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743D51F000E9;
	Fri,  7 Aug 2026 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116442;
	bh=ARtIzuKJirEf5K7Q+z85+zvXLdDuaJUOF+XidklNb/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+xf884rMWnn2poxsMughc51shHmkpFTTLW2UbP40Lqj6kdSYxNv2NYJJlIkN1RuW
	 4oXStLE9/eMTto/LZjQ5X32BpDm/X99ulDiGMD2NOjMZyJH/gS4xB5eawsjEx/tNth
	 tJD/9xXnVEEuTefmpgC8Q9niZydDrMOhcCoPuj+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/261] media: imx219: Fix maximum frame length in lines
Date: Fri,  7 Aug 2026 16:39:50 +0200
Message-ID: <20260807143420.405108319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


