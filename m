Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643873D0D1;
	Tue, 14 May 2024 11:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687647; cv=none; b=DzTYMkd0wlheaCUmWwuPOQ2OVcPJEKKgbPd6OE5aoZ4ow5wDKCOjyOnmJ4rtZYu2L9+9cS/sDUAMxl6O5vbwpvp0hI6CkKa9u7fGyLOYHPzP9wSx8AzQGn6XrIOLBESQVJjpRtDcS99bwcLsEr2BnrVF36wMhopCU5nkoMp/Z8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687647; c=relaxed/simple;
	bh=By0zXq4HP4doYcrdQScOkffWdxyopWvnzKfI68OkHRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjJUuCNQ+XdahspZtOxncBcNP0vN/rf5rTQHXvQfw1W9gvCgyOsDtlVVYUTxj+L2+eHZ1bZJEfxlcXnztJepVEebUB0aWFI3bdJRK2TF8rssURPRMtvc3tHGdUXKlAqyjWNJJoafaBPCHnUMP1K0tFvDv5neuTxlUT6Pk9B9V+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHtVp/wB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHtVp/wB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF32AC2BD10;
	Tue, 14 May 2024 11:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687647;
	bh=By0zXq4HP4doYcrdQScOkffWdxyopWvnzKfI68OkHRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHtVp/wBATPyGlnlX1yk2J7jkI7iTb3y1+5WzGulkonPlE+wkaNH9lcfmrGK1MrSM
	 FSbZ77HgY9gAEoPiwVDL2PCfjdXl0DGw9pxv7UOr8A7O1zjYYrp9Wen4A6kmL6RT6E
	 fpKG9oGQ7B8Qh/ApMBAl9oQGtzk1rcg0rTsKwF+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/168] drm/panel: ili9341: Use predefined error codes
Date: Tue, 14 May 2024 12:19:15 +0200
Message-ID: <20240514101008.844698619@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f8afa922fe9ca..0d89779de22b0 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
@@ -420,7 +420,7 @@ static int ili9341_dpi_prepare(struct drm_panel *panel)
 
 	ili9341_dpi_init(ili);
 
-	return ret;
+	return 0;
 }
 
 static int ili9341_dpi_enable(struct drm_panel *panel)
@@ -727,7 +727,7 @@ static int ili9341_probe(struct spi_device *spi)
 	else if (!strcmp(id->name, "yx240qv29"))
 		return ili9341_dbi_probe(spi, dc, reset);
 
-	return -1;
+	return -ENODEV;
 }
 
 static int ili9341_remove(struct spi_device *spi)
-- 
2.43.0



