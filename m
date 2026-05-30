Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCF833F8A2;
	Sat, 30 May 2026 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164325; cv=none; b=TNGe5Y+E7M3lLUDC8kwFPRgzJplJpTMTWVwAMzh4ghb3ylZOYbFciIhdXRMXYIMu3yIxOdxvR1hJNLbkeytpA/wlOFeLoohkhDOynNCNvkyEzuGww/1Yfhjw37qGwbDIXD/lz1KLj4eVjgcyeNHaVcYqQW0vbxEpsuhS5yvsLnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164325; c=relaxed/simple;
	bh=0t3RHsZX1cACFpB74X9KJWSz7btNzVI3wr2T2QbtRQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZaBdsSwsl1HBi9MuJr9G581cNhLfYrplhcH5mUtocaDl9L17TkOjhJJWbJ70ClUhpiO/ZfWyK4WxBiN/g61nOkbOl1M39YyhZn1O1H9iHDahdN0bJZ7DQXzVUfwFU7wjFTsK4lnZ2aEISq1ui5ggnccidxjNkHY/jhYOJv4A+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNEgE7ak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNEgE7ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420B21F00893;
	Sat, 30 May 2026 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164323;
	bh=eT5P1smzxJUkfNkf+LSfP18pGzwtzv226GB0riDXXKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNEgE7akQSiKEbbMeVP8X4BjRQkbeFxICH/JgHMDL9nc365FR/DgPC7E9CNuQoaq+
	 h0HF/UgV7fF6IM/6zHwkp7fxGVv3kWitHFpNlfMxcFLysXXWcME+gQCcHlShdlOeWL
	 v/jarQfLxBq0LmoVs72lYUz7Ft9BVO1iQ7J/9UgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 520/776] driver core: device.h: remove extern from function prototypes
Date: Sat, 30 May 2026 18:03:54 +0200
Message-ID: <20260530160253.674478239@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit f43243c66e5e9ad839d235f82a58e73a7e7612af ]

The kernel coding style does not require 'extern' in function prototypes
in .h files, so remove them from include/linux/device.h as they are not
needed.

Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20230324122711.2664537-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 797cc011ae02 ("backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 18f276f4a9c01..97fb43c6d919d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1030,8 +1030,7 @@ void device_links_supplier_sync_state_pause(void);
 void device_links_supplier_sync_state_resume(void);
 void device_link_wait_removal(void);
 
-extern __printf(3, 4)
-int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+__printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
-- 
2.53.0



