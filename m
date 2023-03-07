Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8256BBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08222C433D2;
	Tue,  7 Mar 2023 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214727;
	bh=rNGADHJy3eePnzbqDz9rHr2kAkoEd4vGmPrPiHYlVXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOCdJAS8o+Seqv/E6nVL77vLuqYYjiKEYq9HN6PKpOwpWFU55GCKapZuellrehRqk
	 xbPc3/g/kxjQt9lls3HkuWzUdd+xEf0O5bRREaCNOGbKzQz9I1rxbvuVOB+wU15zoV
	 IBhTGNWJRRLLo0/wFunEuryEyqDOQAFe6OBS9P4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/567] ARM: bcm2835_defconfig: Enable the framebuffer
Date: Tue,  7 Mar 2023 17:56:06 +0100
Message-Id: <20230307165907.233382424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index 383c632eba7bd..1e244a9287902 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -108,6 +108,7 @@ CONFIG_MEDIA_SUPPORT=y
 CONFIG_MEDIA_CAMERA_SUPPORT=y
 CONFIG_DRM=y
 CONFIG_DRM_VC4=y
+CONFIG_FB=y
 CONFIG_FB_SIMPLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_SOUND=y
-- 
2.39.2



