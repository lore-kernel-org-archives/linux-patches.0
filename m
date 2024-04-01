Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2286447A6B;
	Mon,  1 Apr 2024 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990081; cv=none; b=Uan6i7T+JfXJz3w0OPIk5/jIOONelssby1WJyM9TF0b6k30T6A7zwlq2yy45u1R+GGZZ+ggAz4Kb+/puNXaRWh7O6ZMoflBXbcsYgK8Lbb5jtcH0CZ27+/0BX+oXh3YqyvTzAQVDv6Enyil8xuepy/1pUTEHhPOCsjpCal63a1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990081; c=relaxed/simple;
	bh=X4dG82xYU0mvuI9WtvvDGpIPHVHsuTem51br0XSyugQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDfx1FI2dUBgyxWXhr4fkWAukG+Q0itjybrLQxaTEJa8TUOXozxPN2kzxW/v5XIjZijKAOyeF1UlTjbKiBSQ+jnYtN5KQwi+copatyuComg4QitgEZWQMFi0wf6xng1dR6U9mrfbuT/ih5QYwJGzWcj7wDyUD52Nh+TQ3L13kAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAxfscLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAxfscLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99020C433F1;
	Mon,  1 Apr 2024 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990081;
	bh=X4dG82xYU0mvuI9WtvvDGpIPHVHsuTem51br0XSyugQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAxfscLZD711X08Na23pJUi2mmoUIixYmgpKr5djyICP/hGYHwJqxG1nFbO8FjwEL
	 SPCOSG5OEu/iLl2QBM1jEyS+beVUlD5FjTSWt528Lfj4mIJW7/U/6RVOFWUReLO1eM
	 ClqC6zKKzKVQnjBj+d82WvRxWuiwD+JpRW3YtF0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 239/396] ARM: imx_v6_v7_defconfig: Restore CONFIG_BACKLIGHT_CLASS_DEVICE
Date: Mon,  1 Apr 2024 17:44:48 +0200
Message-ID: <20240401152555.039451629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fabio Estevam <festevam@denx.de>

commit 2b0a5a8a397c0ae8f8cd25e7d3857c749239ceb8 upstream.

Since commit bfac19e239a7 ("fbdev: mx3fb: Remove the driver") backlight
is no longer functional.

The fbdev mx3fb driver used to automatically select
CONFIG_BACKLIGHT_CLASS_DEVICE.

Now that the mx3fb driver has been removed, enable the
CONFIG_BACKLIGHT_CLASS_DEVICE option so that backlight can still work
by default.

Tested on a imx6dl-sabresd board.

Cc: stable@vger.kernel.org
Fixes: bfac19e239a7 ("fbdev: mx3fb: Remove the driver")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> # Toradex Colibri iMX7
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/configs/imx_v6_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 0a90583f9f01..8f9dbe8d9029 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -297,6 +297,7 @@ CONFIG_FB_MODE_HELPERS=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_LCD_L4F00242T03=y
 CONFIG_LCD_PLATFORM=y
+CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_BACKLIGHT_PWM=y
 CONFIG_BACKLIGHT_GPIO=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
-- 
2.44.0



