Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9625250288;
	Tue, 14 May 2024 10:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682779; cv=none; b=rcj4PTjafqM+WVYCBFcMMqYpO66EFXmInqHdQTfRp4NX7my1pMdHzzsPFQcwWO3YCSWWRoDlsxc3uHxV0kFcdgfN3KVjrXXPqfXeYAEbd2KgPlurnM4Pyzn2cNOmwhD0dxaEoNkXQjifSgrIApBD+loF50qUctIovJV+P+nVbJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682779; c=relaxed/simple;
	bh=sCu4YhbqpS58BlPKfgrl0QfDFk0Lb9ioFRTW4eVK8mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ar8vQ4FRbGjcuhXHTh611w2Fb/GvcBOqqPFO7IXVozUzAthzik0k5+ki20eTCVE9KyLO4VaX0j3thGStwk5BVSW9iOOdZSUst9IvD2ra0IrEWOXAsbdBJtJtuweAWgEWP/BkOdeR84XZ5HfIf/EGxTccC64jf9CeeBE3Yqr/oik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJCiTrnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJCiTrnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22631C2BD10;
	Tue, 14 May 2024 10:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682779;
	bh=sCu4YhbqpS58BlPKfgrl0QfDFk0Lb9ioFRTW4eVK8mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJCiTrnlcluueugMiz3wstk9NVUackQfthNhUt8Jn2AAh8EAlV/E2E8Y59m59mg9L
	 bTt5gklI2Vj4A85LaIhl4SXeTYiG5kIUQKOoIoXFbP+PfDhuvN3y/U6iTT+6inKJDF
	 xkURfI1O7harqTtBdE1BSSJ3v1caiWymLZD4fF/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 082/336] drm/panel: ili9341: Use predefined error codes
Date: Tue, 14 May 2024 12:14:46 +0200
Message-ID: <20240514101041.702683886@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit da85f0aaa9f21999753b01d45c0343f885a8f905 ]

In one case the -1 is returned which is quite confusing code for
the wrong device ID, in another the ret is returning instead of
plain 0 that also confusing as readed may ask the possible meaning
of positive codes, which are never the case there. Convert both
to use explicit predefined error codes to make it clear what's going
on there.

Fixes: 5a04227326b0 ("drm/panel: Add ilitek ili9341 panel driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Link: https://lore.kernel.org/r/20240425142706.2440113-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425142706.2440113-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
index 24c74c56e5648..b933380b7eb78 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
@@ -422,7 +422,7 @@ static int ili9341_dpi_prepare(struct drm_panel *panel)
 
 	ili9341_dpi_init(ili);
 
-	return ret;
+	return 0;
 }
 
 static int ili9341_dpi_enable(struct drm_panel *panel)
@@ -726,7 +726,7 @@ static int ili9341_probe(struct spi_device *spi)
 	else if (!strcmp(id->name, "yx240qv29"))
 		return ili9341_dbi_probe(spi, dc, reset);
 
-	return -1;
+	return -ENODEV;
 }
 
 static void ili9341_remove(struct spi_device *spi)
-- 
2.43.0



