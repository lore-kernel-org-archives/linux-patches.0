Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AC22BDC0E;
	Sat, 12 Sep 2026 07:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197915; cv=none; b=tV4fqu5RwSy7GKuiloKXk5e168ivTIIOdLajoG3VzCL7pHe6M06qF06UFF4yYgoyPzb7yVO3fJ951ENMsgC8jY55o5ma5LVQmnRLnBstb5eYX4AX6lgTLwnFlJ/NMhh5IHfTs5GXus1isEMa3Qlv9ROFTVWOaN45/cdD5fclGT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197915; c=relaxed/simple;
	bh=EC4/OhD6gl3+BeSLVVxcjnz7U5a7hVyA3q0n8/NOicw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDwxi4LSQ+8Zw+c0vw0GGpzF7NY18gwd0JsOuEPbYPPerezoOiwSrGgBhCW3YEYPeK2TZ43/YoeDIbRf64YdHbcnRDtcvm9ZEyY562Q3SlsKIj0EbF/rwFC13T3WHmVuU3Dgvq/Jycxc14pQZFpB9q0v/KjXz+qUwGbNjK9YFuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x96iyhuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x96iyhuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590291F000FF;
	Sat, 12 Sep 2026 07:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197914;
	bh=3dBwwNZ6fhgSLaecOYxSewQUSuRbyTB2USq3TXe+zlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x96iyhuLvNA6y93qSYUpPkZs2rbfjz/ZiqPviRIYc35GW36DW4yoVXNzZ+j9A0Kjz
	 x5os7pzkBHQRhTPTo31ngF68uLzLAJsRANhlRfnlqcs/m72fiuH8yHwTKdU+H479e1
	 XSifX8DjjxPuTZrLIczhguU+ErzSxXdXjqOezH94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0230/1815] staging: sm750fb: Add missing Kconfig dependency
Date: Sat, 12 Sep 2026 08:33:00 +0200
Message-ID: <20260912065654.393070205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit da8fd33e7d6af4c069668c2d42234b969f706885 ]

The sm750 frame buffer driver depends on FB_IOMEM_FOPS, but its Kconfig
somehow misses it.

Fix it by making FB_SM750 select FB_IOMEM_FOPS, as other frame buffer
drivers do.

Fixes: dc0ad215e5d8 ("staging/sm750fb: Initialize fb_ops with fbdev macros")
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260603-sm750-fb-iomem-kconfig-v1-1-7f6a3046cce2@rong.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/sm750fb/Kconfig b/drivers/staging/sm750fb/Kconfig
index 08bcccdd0f1c4..25fe422f55f2c 100644
--- a/drivers/staging/sm750fb/Kconfig
+++ b/drivers/staging/sm750fb/Kconfig
@@ -6,6 +6,7 @@ config FB_SM750
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_FOPS
 	help
 	  Frame buffer driver for the Silicon Motion SM750 chip
 	  with 2D acceleration and dual head support.
-- 
2.53.0



