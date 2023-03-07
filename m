Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB8EBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8A8C433EF;
	Tue,  7 Mar 2023 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212092;
	bh=kZNN6dcrAPno52ez8PA+dWnQJ3W3MGvWUppph7XjsX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R54Lz6J4TZ7zisYpkgVbihdCnyS/TkLL66aAtmWuZbSE8UZVezZmFTMAHhPkOoEle
	 VB1A9yxOvKeJCKt9SDU1bn9MtSQzdXdUhVWzHJxsArqjm4yJhm21UJ70T4FNuOKxjt
	 CovkRZMIJtdxQj7qAGFojRXk3XhT8mS9TP2vAZmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/885] ARM: bcm2835_defconfig: Enable the framebuffer
Date: Tue,  7 Mar 2023 17:49:41 +0100
Message-Id: <20230307170003.750062148@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit afc8dd99840b7fb7190e769a893cda673bc3a907 ]

Booting Linux on a Raspberry Pi based on bcm2835_defconfig there is
no display activity.

Enable CONFIG_FB which is nowadays required for CONFIG_FB_SIMPLE
and CONFIG_FRAMEBUFFER_CONSOLE.

Fixes: f611b1e7624c ("drm: Avoid circular dependencies for CONFIG_FB")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20230113205842.17051-1-stefan.wahren@i2se.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/bcm2835_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index a51babd178c26..be0c984a66947 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -107,6 +107,7 @@ CONFIG_MEDIA_CAMERA_SUPPORT=y
 CONFIG_DRM=y
 CONFIG_DRM_V3D=y
 CONFIG_DRM_VC4=y
+CONFIG_FB=y
 CONFIG_FB_SIMPLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_SOUND=y
-- 
2.39.2



