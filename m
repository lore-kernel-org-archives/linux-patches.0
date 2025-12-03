Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F76B33A71A;
	Wed,  3 Dec 2025 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777352; cv=none; b=ExWpqcwEgtd6pkfnBbgf13gUUAYGPbMiTEr2q7u9JQZWVRU3B/FAhLfOX9RWTTK+7wIzfAc6IDeMDZxRV/WAwgW34zh+AXVGNGg+6sIK+vtVb1vX4mBgbggMjo4eVYT451zAH+9mTOsQ64Fv7nurx2wAXuN0Wt0eFBUixTksYWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777352; c=relaxed/simple;
	bh=OFoUPf6jtryKHYHhNqAI087Ojx2fF8kLzgYEpGdQ8xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXhcsIpH6GT8Bhwgj1i2xff1ITMVv9/tgj4p2gZGkUu/FDprENkUZnFW3H2ndzG+VPqE8EW3zwdC8kWcZElWgKbArd6YURAe9cxwqbSlf/SUC6lYVgD9a8mSTgGAxVfT0/zRdPhz0/eX0BTnJ9QyQ2isAfLDBWVNP0wHzq8yB+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PllL6wYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PllL6wYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2154CC4CEF5;
	Wed,  3 Dec 2025 15:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777351;
	bh=OFoUPf6jtryKHYHhNqAI087Ojx2fF8kLzgYEpGdQ8xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PllL6wYtFpQDJDgVuM8GO78HmSY1/e+FyIb/kW2qNNpEdkjuBkxvJtZae6v1NmrDi
	 RiQN6n49BIbJjyX50x0egslCml9BcItyJ6KpAkhYVvywLV4e6so6yBe8IaHwrOzQBP
	 utFCuqOZCerp4fBbfzRH8WVcLvSFpiM4m+5LIabg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 012/392] fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS
Date: Wed,  3 Dec 2025 16:22:42 +0100
Message-ID: <20251203152414.555701408@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -191,7 +191,7 @@ static unsigned long pvr2fb_map;
 
 #ifdef CONFIG_PVR2_DMA
 static unsigned int shdma = PVR2_CASCADE_CHAN;
-static unsigned int pvr2dma = ONCHIP_NR_DMA_CHANNELS;
+static unsigned int pvr2dma = CONFIG_NR_ONCHIP_DMA_CHANNELS;
 #endif
 
 static struct fb_videomode pvr2_modedb[] = {


