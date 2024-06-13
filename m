Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A1D1459EE;
	Thu, 13 Jun 2024 12:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281183; cv=none; b=besA4P8jb+AObOnF5JyKY4ZKhLFGQxKim9cbs7Jhhs7G4SMoUIcjQvJ7PIPxBV5FbVrOrjmDPCB6/zy5wzsiyKxwGqqfGaM1hxvB75j5zX+yvOvbUes03XVjJ/oIqNG22TmZhY9k319k3Fpxroy3RGP3Zb+cU1PK6WMPnKb7o9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281183; c=relaxed/simple;
	bh=04A6qyanzTdJf61FAQeSH3G7GbJAqSjYzQOMPxKKX8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spBiFQ+9aIVOrC0YOEOkr1RtqP+MKWsxZj7ZjaU7m5ZsH+1O8qsuRFJLVsb6J/vj5BVYplDvFok1X+zWoGq4e/pPIZyL9pZmMRcI1Zox5Dvv0v4EyV6lVbhAws+lHTw/2IQt62ZZwep0PLPqacsbvKLsZNpAcNPvNHTlRGSNWVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCEMeHgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCEMeHgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BF7C2BBFC;
	Thu, 13 Jun 2024 12:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281183;
	bh=04A6qyanzTdJf61FAQeSH3G7GbJAqSjYzQOMPxKKX8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCEMeHglC08RIHC4yoBTHiH9L9ZCvlyXK/ar/C2xMOtkaVZ7R7sLJb+NsqObPMHol
	 FS4qNnmwjnBg2ZozDmrukQAswfZnA7dw41lzfec4IH5lQzYh8k8iZ2CzUeQigpjzK0
	 im7RkzB+ejTI3OGejzNQMhNpXCH64JgfRwdoMs1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Alex Elder <elder@ieee.org>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/317] greybus: lights: check return of get_channel_from_mode
Date: Thu, 13 Jun 2024 13:32:36 +0200
Message-ID: <20240613113252.902306351@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e59bb27236b9f..7352d7deb8ba0 100644
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
@@ -550,7 +553,10 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
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



