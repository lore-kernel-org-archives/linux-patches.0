Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFF734D39F;
	Fri, 21 Nov 2025 13:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732117; cv=none; b=XEaAfuowHXhk8ob9y2K3o3xZMmNXuYT0qJz1Rns5R4Qsb2oNH1BxmmLP8zpPxEVScX0/7d+htyworlxHzr6o/gkuVfS3DLuDX0FcoV9cMrS9ENXnGMJ/ZfMyxGZ/Hu5kBkFIsaph5BGCdA438rBjgWMjV0fqTbGnh+7MhCj/yEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732117; c=relaxed/simple;
	bh=3pd94Cxp/V/Eu2P3hC7FVyqiWY+BkifV+S8XeDbUD+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQKL9wXZ9hta86+FQojFowylcau9sLcyrJicyIeepODLlR44hUft1AMBPrNVfsD/h0S0GjVxK4eOxnrIpc5+SJJPQy8u+a52U91712PK9ISXoG5/MY17h0LbAs8QjKE7gn5whoMiOlverLOOgn698xCGBxak/X9JWpNqEwGweO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=re0aut7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="re0aut7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE38AC4CEFB;
	Fri, 21 Nov 2025 13:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732117;
	bh=3pd94Cxp/V/Eu2P3hC7FVyqiWY+BkifV+S8XeDbUD+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=re0aut7WtGG20GSi7HuvTrdlwLvykNG89H2WEFEl7uBjhS5420xBw7JW4de4uEdw8
	 GVKSLycYjjpt7nouQHSKFpYW5luzPKe5op5QYdyOAJEsHRzhuMgVhL/UkiOk/j5yc8
	 Dx/DLz16Hq3eSS+ZKq80mKNJ7q5mPWcdjbapVaUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 010/529] fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS
Date: Fri, 21 Nov 2025 14:05:09 +0100
Message-ID: <20251121130231.366744344@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Florian Fuchs <fuchsfl@gmail.com>

commit 5f566c0ac51cd2474e47da68dbe719d3acf7d999 upstream.

Commit e24cca19babe ("sh: Kill off MAX_DMA_ADDRESS leftovers.") removed
the define ONCHIP_NR_DMA_CHANNELS. So that the leftover reference needs
to be replaced by CONFIG_NR_ONCHIP_DMA_CHANNELS to compile successfully
with CONFIG_PVR2_DMA enabled.

Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/pvr2fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -192,7 +192,7 @@ static unsigned long pvr2fb_map;
 
 #ifdef CONFIG_PVR2_DMA
 static unsigned int shdma = PVR2_CASCADE_CHAN;
-static unsigned int pvr2dma = ONCHIP_NR_DMA_CHANNELS;
+static unsigned int pvr2dma = CONFIG_NR_ONCHIP_DMA_CHANNELS;
 #endif
 
 static struct fb_videomode pvr2_modedb[] = {


