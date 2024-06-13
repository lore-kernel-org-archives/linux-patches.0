Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100E5EC4;
	Thu, 13 Jun 2024 12:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282153; cv=none; b=SbRoLNrF+0ZNQJ3dTj5wxDDIioFouM23cFwQ8HdJTACveldEVOfPoLtJTWoIzQ/NDDIkSah9DuDIeX2cTSGt5MNXnwnkLZuoCoLVrtHfxp+uYUO5m+3XlKbnPnbKi5LcbhO0SNfzHppm0DGNCgYvHzq36yvYAooff5VeMQAb5Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282153; c=relaxed/simple;
	bh=y+HX9gTNq4sfiBSTIUb+w0IaDyGZxRFPla85ycAJJ70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss6mVj4JvqARBdPIO/zoQLXSH03uz7csmGhu1agQfBMp8f8RrHONs9IV6VcQLggaMUr0O+/wYdqD/lnuBJd+/jlJ0oqnGC2weoKeqW1wFWmUD/Uw457EpdjgPl/FN1ffKIaiCGgwckMSR6bcqjMg8tpMnjp9h5txJwKAMnIMcG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cc3R/IVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cc3R/IVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B6C2BBFC;
	Thu, 13 Jun 2024 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282152;
	bh=y+HX9gTNq4sfiBSTIUb+w0IaDyGZxRFPla85ycAJJ70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cc3R/IVIeTCZPHfzy2527XtU81R+7oplhuYXIIJ5tQTdzv566BBs0OqYhN/GzUAjZ
	 l2q8d3NJ/3V1txHvTuhHsBAP2lelB9oFYMqGcvXGRfjRLbdsbI7WrbWE3YbMjcDYb5
	 AshZwJT92w9oOtn9ZBszqA0lEleqBbj/AVwdZvlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Alex Elder <elder@ieee.org>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/402] greybus: lights: check return of get_channel_from_mode
Date: Thu, 13 Jun 2024 13:32:16 +0200
Message-ID: <20240613113309.132212489@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Rui Miguel Silva <rmfrfs@gmail.com>

[ Upstream commit a1ba19a1ae7cd1e324685ded4ab563e78fe68648 ]

If channel for the given node is not found we return null from
get_channel_from_mode. Make sure we validate the return pointer
before using it in two of the missing places.

This was originally reported in [0]:
Found by Linux Verification Center (linuxtesting.org) with SVACE.

[0] https://lore.kernel.org/all/20240301190425.120605-1-m.lobanov@rosalinux.ru

Fixes: 2870b52bae4c ("greybus: lights: add lights implementation")
Reported-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Suggested-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Suggested-by: Alex Elder <elder@ieee.org>
Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
Link: https://lore.kernel.org/r/20240325221549.2185265-1-rmfrfs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/light.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/light.c
index c6bd86a5335ab..9999f84016992 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -147,6 +147,9 @@ static int __gb_lights_flash_brightness_set(struct gb_channel *channel)
 		channel = get_channel_from_mode(channel->light,
 						GB_CHANNEL_MODE_TORCH);
 
+	if (!channel)
+		return -EINVAL;
+
 	/* For not flash we need to convert brightness to intensity */
 	intensity = channel->intensity_uA.min +
 			(channel->intensity_uA.step * channel->led->brightness);
@@ -549,7 +552,10 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
 	}
 
 	channel_flash = get_channel_from_mode(light, GB_CHANNEL_MODE_FLASH);
-	WARN_ON(!channel_flash);
+	if (!channel_flash) {
+		dev_err(dev, "failed to get flash channel from mode\n");
+		return -EINVAL;
+	}
 
 	fled = &channel_flash->fled;
 
-- 
2.43.0



