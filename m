Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FEB197A67;
	Thu,  6 Jun 2024 14:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682920; cv=none; b=fRa6uytVi8hS+QMTo4mKgZiKtjHfox/LCAEu9BMF6KGYSb0x3s0G/ZYOJRdLM/gfJaD5Q5yNoT7t5fUIZuxor9B+puSVexEk/jJJc0PhbZ7z3mjJ6f235RFhuH1rU/AodCwFgYWa/x0jq2aWagPjoqVCOABjfKfrVqDSUpP2voA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682920; c=relaxed/simple;
	bh=weyoj2ndVQbt1k6PoSAx4g+GIm21NyOibk6eyN88gBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzqN2+p9ULryWO+w256SsefzG+y1Dm0gYr/6Ul8fkRtBpYwaXliVjZcP8TSO/Ffyc61d71oC9LPTWZUaHJ9y2ShXDYPNGwVp36OwCfkUAOk7pAhS10pC+W5fPgVkAmk1cdZ0T+Veg++j7LCdKKsb1thXZsPhCpEKzsK53HIB5l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUxDtx+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUxDtx+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F60C32786;
	Thu,  6 Jun 2024 14:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682920;
	bh=weyoj2ndVQbt1k6PoSAx4g+GIm21NyOibk6eyN88gBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUxDtx+CMmbTWZbF66sz2j8tEVbg8l2l84F+7wT6FsHqpGA5dNLtKnPQguCiHKMp9
	 kUiglLUg1R/orpq5OT2Bt8DrdfNgZfCcvlTC35z/3POO10nx/Yh0an+szcLdN0Agy+
	 U9ZYYYan6BV2yxEGZIRvgx34jYBVMDnRi/hGtbBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Alex Elder <elder@ieee.org>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 006/374] greybus: lights: check return of get_channel_from_mode
Date: Thu,  6 Jun 2024 15:59:45 +0200
Message-ID: <20240606131651.934513393@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a5c2fe963866d..00360f4a04854 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -142,6 +142,9 @@ static int __gb_lights_flash_brightness_set(struct gb_channel *channel)
 		channel = get_channel_from_mode(channel->light,
 						GB_CHANNEL_MODE_TORCH);
 
+	if (!channel)
+		return -EINVAL;
+
 	/* For not flash we need to convert brightness to intensity */
 	intensity = channel->intensity_uA.min +
 			(channel->intensity_uA.step * channel->led->brightness);
@@ -528,7 +531,10 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
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



