Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D7970831;
	Tue, 27 May 2025 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368338; cv=none; b=Dm/IEOIfT5z3EKnPastpyWl8qG0BhCl/tSqt/3AvmIFYd/wShY7Hyk/uJbe1j0IYUGLy6mICBI2/uiJ6prWzhxA2ul2jS85KfSVZhZbgGa/QWFSeKRjGkFNbfYWJAlYoFpGRvUhOqw4xglxZBYsRrneggJXSKWw9p0et5G/zgGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368338; c=relaxed/simple;
	bh=oDaIEVsy/539sAvzZdL+Di55u3FCoso135MD3Yp2f1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USwx71FhOPuS3+RcpS+WiFqdH5Ia1hpwzC1xd8V093WCKenOwa8k/vELL4Q/1JU+6DgOQHMEW2PLsP0Yip0YmD80rCFT/W1g8UUDJdNCzsJ2XxToRoPxJu/0OuzY9dyk8mycl7AYvRHxFpQ4TcL6q8TZ8XvilPfTDLt+OzGR9wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVsGa7qQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVsGa7qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B624C4CEEA;
	Tue, 27 May 2025 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368337;
	bh=oDaIEVsy/539sAvzZdL+Di55u3FCoso135MD3Yp2f1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVsGa7qQ8GIxJkn9nCaWftohGMhrXBTDCc5+louRxHwWhWGwgmm8HlNUrtn/ZnZnV
	 1lP/K+Z/tKRPf6/0tH2ax+wwuzYoZzxSyUyH/aRIhqyM4d1zGodKZcEZjRddzVhCO+
	 jUoUyxxFtyfXvN6SF/0WkWSMQ0DZxrBvLM50GYwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kate Hsuan <hpa@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 645/783] HID: Kconfig: Add LEDS_CLASS_MULTICOLOR dependency to HID_LOGITECH
Date: Tue, 27 May 2025 18:27:22 +0200
Message-ID: <20250527162539.405868106@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kate Hsuan <hpa@redhat.com>

[ Upstream commit 4465f4fa21e0e54c10896db3ed49dbd5a9aad3fd ]

The test bot found an issue with building hid-lg-g15.

All errors (new ones prefixed by >>):

   powerpc-linux-ld: drivers/hid/hid-lg-g15.o: in function `lg_g510_kbd_led_write':
>> drivers/hid/hid-lg-g15.c:241:(.text+0x768): undefined reference to `led_mc_calc_color_components'
   powerpc-linux-ld: drivers/hid/hid-lg-g15.o: in function `lg_g15_register_led':
>> drivers/hid/hid-lg-g15.c:686:(.text+0xa9c): undefined reference to `devm_led_classdev_multicolor_register_ext'

Since multicolor LED APIs manage the keyboard backlight settings of
hid-lg-g15, the LEDS_CLASS_MULTICOLOR dependency was added to
HID_LOGITECH.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502110032.VZ0J024X-lkp@intel.com/
Fixes: a3a064146c50 ("HID: hid-lg-g15: Use standard multicolor LED API")
Signed-off-by: Kate Hsuan <hpa@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 4cfea399ebab2..76be97c5fc2ff 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -603,6 +603,7 @@ config HID_LOGITECH
 	tristate "Logitech devices"
 	depends on USB_HID
 	depends on LEDS_CLASS
+	depends on LEDS_CLASS_MULTICOLOR
 	default !EXPERT
 	help
 	Support for Logitech devices that are not fully compliant with HID standard.
-- 
2.39.5



