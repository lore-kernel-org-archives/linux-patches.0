Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D53BA42
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9104EC433EF;
	Tue,  7 Mar 2023 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210656;
	bh=YxlUhGt43u17Ppx7Y8MnNtp+R0dUfZBbeu5ZqIcySQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvASa1lerG5YPg0kfWoyJn00uA+G2w2hXsVO9kT+MpzmnZFM1HIXTtR0l2Hq/9fqC
	 4WNbOhiPcY2IlKfIIzirs6A/u1MCrKXepHOuQ0EJ6tGlLW383FRu+d0oI1sCz5RWGU
	 gBo/ZIiHb6ry3C6m+u1vgqjnv1AnOv2Qr+GDckEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0611/1001] media: atomisp: fix videobuf2 Kconfig depenendency
Date: Tue,  7 Mar 2023 17:56:23 +0100
Message-Id: <20230307170048.035402193@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit be94be1b7fc7e51f9ccef20a0ef76583587275f3 ]

The recent conversion missed the Kconfig bit, so it can now
end up in a link error on randconfig builds:

ld.lld: error: undefined symbol: vb2_vmalloc_memops
>>> referenced by atomisp_fops.c
>>>               drivers/staging/media/atomisp/pci/atomisp_fops.o:(atomisp_open) in archive vmlinux.a

Link: https://lore.kernel.org/r/20230104082212.3770415-1-arnd@kernel.org

Fixes: cb48ae89be3b ("media: atomisp: Convert to videobuf2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index 2c8d7fdcc5f7a..c9bff98e5309a 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -14,7 +14,7 @@ config VIDEO_ATOMISP
 	depends on VIDEO_DEV && INTEL_ATOMISP
 	depends on PMIC_OPREGION
 	select IOSF_MBI
-	select VIDEOBUF_VMALLOC
+	select VIDEOBUF2_VMALLOC
 	select VIDEO_V4L2_SUBDEV_API
 	help
 	  Say Y here if your platform supports Intel Atom SoC
-- 
2.39.2



