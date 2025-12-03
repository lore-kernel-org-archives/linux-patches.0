Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EC8256C9E;
	Wed,  3 Dec 2025 15:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776019; cv=none; b=u94vccFVcdesbJMxMMicX45x/MFXKbyjztgz+498USrIswTJvHBl/O0/pYRwvfhqmpoZx58wsIIWl5XUvdQGSU+nJGTDvZQZdXElGdmlYDhyKlfwDJQvZSgURcmZiNLKCJ/Vykboi9b1dj1LzDT3IHETgc6JauIlt0A6nexQmRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776019; c=relaxed/simple;
	bh=2i5N4cmFuqYrZduftipop98bdRUH9sQKJUVW+F+jop8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noeVXiwpppI9zHDFEHva/3RVVo77SamOzjbSlIwH17K/NW5CdcYedREkSOzsVI900UCr9MoCfRaFn7R2U/PhgQDyaZ/4gk+Fo5sZv+OFlwtIW7vjFD1CZREKQB1aw4WSrB9kBQ47TJ5tnoB/yik3mAMjoi4lIMdOLsHY4YH+Yr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItstxGrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItstxGrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D670C4CEF5;
	Wed,  3 Dec 2025 15:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776019;
	bh=2i5N4cmFuqYrZduftipop98bdRUH9sQKJUVW+F+jop8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItstxGrpgK7I5vlslkBkpYh/Ag9XtFlVlhu6oGhOJhEw/uhZ7m+Tkw4yLDc8Jil7T
	 HvyGvUuz3b6OXg0W45tCqLQhVpYONEbREJIHLAnUpOUcOFnb8977egwfXAW7hoL3mQ
	 prTEbUrwbNVpUfgIDe3mnW3S3Rw+5IZ6gU8CCSGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/300] video: backlight: lp855x_bl: Set correct EPROM start for LP8556
Date: Wed,  3 Dec 2025 16:24:19 +0100
Message-ID: <20251203152402.661878016@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 07c7efda24453e05951fb2879f5452b720b91169 ]

According to LP8556 datasheet EPROM region starts at 0x98 so adjust value
in the driver accordingly.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: "Daniel Thompson (RISCstar)" <danielt@kernel.org>
Link: https://lore.kernel.org/r/20250909074304.92135-2-clamor95@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lp855x_bl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index e94932c69f540..80a4b12563c6f 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -21,7 +21,7 @@
 #define LP855X_DEVICE_CTRL		0x01
 #define LP855X_EEPROM_START		0xA0
 #define LP855X_EEPROM_END		0xA7
-#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_START		0x98
 #define LP8556_EPROM_END		0xAF
 
 /* LP8555/7 Registers */
-- 
2.51.0



