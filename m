Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D14D2E5417;
	Tue,  8 Jul 2025 16:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991829; cv=none; b=ckphUlKJNEQ6WnoWVar0mDHBTT0buphHmHWOuJuaC76G7eBJgaIcfiFB90qSIWw6MCIkMOZxfoswr7IlkXvGo/6gjE3oS5WekowlNrFn6RT604IeM29d0X+GaN0J5vPGT0LNxJIo56JwoFqnynB0JH6n8PKooc1UEEyJ0W4GnEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991829; c=relaxed/simple;
	bh=U2m/tQPuIKyrOGVH9saLBmx3y9NFrdvLMViY6tirfSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWWvUB58g3vPT4jwdTD+k9rRemo580oWuHYVfhIxqvYKRwTI2VD7ly0gbJAr7Fo1K2i9w8V1ymYVH4kYneoXogCZqxcy5Vk7/kLm86VqHu0KT2MsEdsJTTlIKa0m5ylxNZVmKg4ugEqGGb7GshBh4UIqL2GO6f/IRf1BzVV2vkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xygCvJhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xygCvJhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D9BC4CEED;
	Tue,  8 Jul 2025 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991828;
	bh=U2m/tQPuIKyrOGVH9saLBmx3y9NFrdvLMViY6tirfSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xygCvJhFXfHys1VRaJ4MvyicA9Oqy8ip6TvXNJnwW+QQR3+ISplWGtiTiRJEutvho
	 f97H28fwFLLjmA9OAYnS6LlNx1lmp2UkBKYrjwxg0VeI9lM7z90eDMID54LJKTQeQB
	 1aQ6eSvEEz7xdmHd37p8RgFmNssL6PYUyDiiQlpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Popa <elena.popa@nxp.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.15 001/178] rtc: pcf2127: add missing semicolon after statement
Date: Tue,  8 Jul 2025 18:20:38 +0200
Message-ID: <20250708162236.592550092@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 08d82d0cad51c2b1d454fe41ea1ff96ade676961 upstream.

Replace comma with semicolon at the end of the statement when setting
config.max_register.

Fixes: fd28ceb4603f ("rtc: pcf2127: add variant-specific configuration structure")
Cc: stable@vger.kernel.org
Cc: Elena Popa <elena.popa@nxp.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20250529202923.1552560-1-hugo@hugovil.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pcf2127.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -1538,7 +1538,7 @@ static int pcf2127_spi_probe(struct spi_
 		variant = &pcf21xx_cfg[type];
 	}
 
-	config.max_register = variant->max_register,
+	config.max_register = variant->max_register;
 
 	regmap = devm_regmap_init_spi(spi, &config);
 	if (IS_ERR(regmap)) {


