Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F451D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yge0dnHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A388C433C7;
	Wed,  4 Oct 2023 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443760;
	bh=6ianC40VnR+mUcKE1duN0ZcdA4BFROhcMSSJmISvMPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yge0dnHP6U5ao1txngfVumLuhibXK+IJtdnQdTKc9xLEwJDImjhObf91M4bmqS0fj
	 Q0WphHdMMc0x4CSl4eE9Q//R+4UTpsyITlTlz63SmpJvagcyfkbwG2qjT6B4BrWuyr
	 wwFU0MPnAHG323xbI5nEFdcTeWIh512EozPtjwAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 011/321] media: via: Use correct dependency for camera sensor drivers
Date: Wed,  4 Oct 2023 19:52:36 +0200
Message-ID: <20231004175229.728132352@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 41425941dfcf47cc6df8e500af6ff16a7be6539f ]

The via camera controller driver selected ov7670 driver, however now that
driver has dependencies and may no longer be selected unconditionally.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 7d3c7d2a2914 ("media: i2c: Add a camera sensor top level menu")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/via/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/via/Kconfig b/drivers/media/platform/via/Kconfig
index 8926eb0803b27..6e603c0382487 100644
--- a/drivers/media/platform/via/Kconfig
+++ b/drivers/media/platform/via/Kconfig
@@ -7,7 +7,7 @@ config VIDEO_VIA_CAMERA
 	depends on V4L_PLATFORM_DRIVERS
 	depends on FB_VIA && VIDEO_DEV
 	select VIDEOBUF2_DMA_SG
-	select VIDEO_OV7670
+	select VIDEO_OV7670 if VIDEO_CAMERA_SENSOR
 	help
 	   Driver support for the integrated camera controller in VIA
 	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
-- 
2.40.1



