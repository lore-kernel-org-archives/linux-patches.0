Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF424F403D;
	Thu, 17 Sep 2026 18:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668005; cv=none; b=q+6lMhkcnVeo/S6WlAiN1t4Tlh6GIpCoIEFt22AKNiY+qSh+E/RvuXN4tNs6XHtXLvCGWZlDTyZQb46mg9H4MXwdsNnFlSAlRl91cIBlBbQG3wOAV35WHIBSB8uxtXvKrs53NEN9wb/byrLHe3DvVxAQcNwATOPlX8hQSAtLgyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668005; c=relaxed/simple;
	bh=Y4vsxzfWFjmZj0SF+rjdGpRWcRw/zJophn9vn4Me4rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BiWMBOYM3O7q/iUPBubJPPbkcb+pSN8UoaEFSKW9m4iU9+V8JYs7WEma9OA7H4gpiwUrwdiKlxYXiYyZS9kWgZ44qrMB6RV2538ZMZiftuz5aDdDlBcecqlMzisFD/xsvF9v+jqf7RgM0igYRs4Sm/d9AuQejLcES1ABF06+woc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBBhB33F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBBhB33F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7C81F000FF;
	Thu, 17 Sep 2026 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668003;
	bh=RxETTxfZIBQgCatdM8Vqz7Ar/Ht/xjzhnDbnNHYpEaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBBhB33Fh8XnIvZCLyfMliIbJEajJh0RuHhszN6TISbu7ibbh0h3D6/tX7L6hRmms
	 ktN2z64lTqj+h4lOXUDj9BQvfYrXsF9PJRnOyBa2m93xPCFKeb78kTg+I19LkDsjvN
	 ui7bt8pzeqx87VMd6bQz/vKsoA+eX7MmQGj1Xx0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0280/1102] hwmon: (dell-smm) Add Dell Latitude 7530 to fan control whitelist
Date: Thu, 17 Sep 2026 16:03:43 +0100
Message-ID: <20260917151546.640624769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 5a1aba28f6c79f4bbb7a5361063225030ecd36f3 ]

A user reported that the Dell Latitude 7530 needs to be whitelisted
for the special SMM calls necessary for globally enabling/disabling
BIOS fan control.

Closes: https://github.com/Wer-Wolf/i8kutils/issues/17
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20260610180141.311503-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 2cb92a53e7c2c..8473269842c9b 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1501,6 +1501,14 @@ static const struct dmi_system_id i8k_whitelist_fan_control[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_30A3_31A3],
 	},
+	{
+		.ident = "Dell Latitude 7530",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Latitude 7530"),
+		},
+		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_30A3_31A3],
+	},
 	{
 		.ident = "Dell Latitude E6440",
 		.matches = {
-- 
2.53.0



