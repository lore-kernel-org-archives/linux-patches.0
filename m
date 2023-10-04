Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABB1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AB7C433C9;
	Wed,  4 Oct 2023 18:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442764;
	bh=v/NGMzA5RWfLKzWKTHYo4ZE1JbniWFWIoFp469AQiHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTanYqQAwyE1wdivPKo7fNzhv13oLjAuMZEXvmWMbydMcTDj0TuQmrUIQ+DOBZxe6
	 uhSdnef5LCB6gDCYL+5SHSeqLgg+rLuteUbkwWsky1j8+fUVRcAwZ7UWq+xw1W9t01
	 oM8pFBN1m0XUEEP22o+p95IEa6je6wUEUAxLIJW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/183] power: supply: ucs1002: fix error code in ucs1002_get_property()
Date: Wed,  4 Oct 2023 19:55:32 +0200
Message-ID: <20231004175208.104806415@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e35059949daa83f8dadf710d0f829ab3c3a72fe2 ]

This function is supposed to return 0 for success instead of returning
the val->intval.  This makes it the same as the other case statements
in this function.

Fixes: 81196e2e57fc ("power: supply: ucs1002: fix some health status issues")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/687f64a4-4c6e-4536-8204-98ad1df934e5@moroto.mountain
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ucs1002_power.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ucs1002_power.c b/drivers/power/supply/ucs1002_power.c
index ef673ec3db568..332cb50d9fb4f 100644
--- a/drivers/power/supply/ucs1002_power.c
+++ b/drivers/power/supply/ucs1002_power.c
@@ -384,7 +384,8 @@ static int ucs1002_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_USB_TYPE:
 		return ucs1002_get_usb_type(info, val);
 	case POWER_SUPPLY_PROP_HEALTH:
-		return val->intval = info->health;
+		val->intval = info->health;
+		return 0;
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = info->present;
 		return 0;
-- 
2.40.1



