Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2BE1CA8F;
	Mon,  1 Apr 2024 16:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988757; cv=none; b=Er70XnVeHW64di4bvW9yOwEtk6qBd3Qnf0QtD2ecs6BUBl9aCv2dr2aVA3/kCYqIi/mwLtd8dtwCGY43tj2bLWJGayMYEYFP5947fyxlhA8zjv7bE/LVu+ELM1Ui4arn+ldcpjmtzLoZO05N08xO6BxOKMaFRYv0gY9j8F0zmqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988757; c=relaxed/simple;
	bh=Mu+wTT7mZu6JU+R2Lyp0TxyE9VZGN3/zzalje0P5DgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8xOVF0jZhM+4aW6UvsEoqWOeDXGP5e9s5cUMOVWImi6CqlhDyobg6AwsjqrzD7Kv9Dv4J2DshBUWhhB8KU9ujJFvH0JYPMnFznkRLPvMxSAQXiAOLXLw6k3oieD+E4kx5TDEXjAxylGpdnhnCczNG7Qr3gD6RDsUoF7bDABaSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u05kKsAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u05kKsAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08674C43390;
	Mon,  1 Apr 2024 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988757;
	bh=Mu+wTT7mZu6JU+R2Lyp0TxyE9VZGN3/zzalje0P5DgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u05kKsAwy/NqgcUBRaWngcH4mkLCx+DlH7BtqCGmUVw4cQVEYWK3NKUaZD5wQslog
	 INpvhnJmTzKyOK1+IoCz/a1YpjoVWmSsmlaB4kEzebD7LUqX5x8ZdgbzxiLQlIrcbW
	 PeS+huiRkVw0EHSyqF5O3DwrAMZUjNa7BCn+fvdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.7 279/432] ARM: imx_v6_v7_defconfig: Restore CONFIG_BACKLIGHT_CLASS_DEVICE
Date: Mon,  1 Apr 2024 17:44:26 +0200
Message-ID: <20240401152601.493489664@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/configs/imx_v6_v7_defconfig |    1 +
 1 file changed, 1 insertion(+)

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


