Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236B2340D90;
	Wed,  3 Dec 2025 16:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778959; cv=none; b=JJ170woGZHEdYWxVRWksacMVz+vQLGzDPsq424REK954PtdC1OUJ2fDbSoACWTnHRhR9zQXK0MPk0XwK/Z7ZumJsX04wqKfHrFn96wvjzdKywhjdJcKbHw/O7BbhcU2Vo7YUYkAJCCRHTkwA3MsoHc9O9XExdWKHNKL17bbg1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778959; c=relaxed/simple;
	bh=y2c4WUsxOpNDp4beAtgzMXJX1qWuTKqm+L0tnJXzN3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiixAaoEVCxtOe2fUoVJSmilQ81bxOqR221ElKsrRQ+vW6uYAlqJTi/Y4TXx++tovHf9myKqqcQ5PzLJ3bvIzruMA7ktNizh3H8ce5KwbGSzy4oBoulFvVr0D+QR6OWk+nP6jyW9kT/AV8Rd6/HOFdN4qo5mhps4Xql/+QHzeaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nks6jtkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nks6jtkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840BDC4CEF5;
	Wed,  3 Dec 2025 16:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778959;
	bh=y2c4WUsxOpNDp4beAtgzMXJX1qWuTKqm+L0tnJXzN3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nks6jtkkJUCA9K030xYiARfkmar2reAijR5+rgksPYpr5ysRZlkGMAE+hte6stiEb
	 /kFj956ke5nDIAKegKBMRT2uUaQJpCiCX0+s0qLIxRoysNg/vUMKA4XCHT4GIJ+0aS
	 hd2EqUZtupaa40rH/UpL64OkWRnSYKFab/pKGD0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/568] video: backlight: lp855x_bl: Set correct EPROM start for LP8556
Date: Wed,  3 Dec 2025 16:21:55 +0100
Message-ID: <20251203152444.874800895@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd0bdeae23a4f..7e6d252313b7d 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -22,7 +22,7 @@
 #define LP855X_DEVICE_CTRL		0x01
 #define LP855X_EEPROM_START		0xA0
 #define LP855X_EEPROM_END		0xA7
-#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_START		0x98
 #define LP8556_EPROM_END		0xAF
 
 /* LP8555/7 Registers */
-- 
2.51.0



