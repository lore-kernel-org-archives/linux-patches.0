Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2C63090F7;
	Mon,  1 Dec 2025 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588343; cv=none; b=hhMvli465w7+BHUcJAJPwLR6ALXJPwqn2xmH+f0Jjgsa9xJB6JTND00yy9yCjXJi4fY3dWIj3hZArTOpuScnaoOQ82DxdhUlvqx/490wJQrM9E1ILHAucvo2xaloA5tBL1dGIjOwxmq+OpTXcuQu7IB17UeShtjuWJeUoADyH3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588343; c=relaxed/simple;
	bh=1U98qpJMI54RXA3s7xDcAZHayPaOwVMdA8cDWtVubIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlmTLOsPkq/BfjlGwu5aIKrDh6vNfW+q8oVu3dCYz2JpAiv42LWhtJsPKM1ApyGKDhlMQYPtP/Lzko9pkePGMNuzT/o9O4agV2Kn0QOCa3xC611Y6ezT2MoyR95ach5pn6D6O2YAbof44XQtowIk0cwlhH0de6HAApXdrvjn7po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgJC2xEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgJC2xEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51C3C4CEF1;
	Mon,  1 Dec 2025 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588343;
	bh=1U98qpJMI54RXA3s7xDcAZHayPaOwVMdA8cDWtVubIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgJC2xEdw1jXLl8+aJdKsmUKIPyJcQXTl1gGxv00os0elGY3o5ilwySKr+FDZXni4
	 h7srmBueLGoSz0mYrlpHWAxk7bwzzj/zdAIIUMZogDy8OCsreV8SavSQHwwD+eJUBu
	 xForNvuOp4EceAZ7IeVsq2yHBPCz+WsuR+t5Gqz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 008/187] fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS
Date: Mon,  1 Dec 2025 12:21:56 +0100
Message-ID: <20251201112241.550527318@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


