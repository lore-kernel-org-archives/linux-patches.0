Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3A11D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdv0oAgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AD1C433C8;
	Wed,  4 Oct 2023 18:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443398;
	bh=WdAkV3U2UUtblSRX0mCVxFEu482nLqvJx1D3hqRZ2SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdv0oAgLVk+xkCPmUW1VMoFd4Fq4iPsYGiYnr5EB1Ui17FSBQLd5cb51CWvd5pZ+i
	 WUQOn3+QI7PLMDkpft1dHIAfULbW/hTv7U2CJuV/TUbsub/jEusENasi2k5U2ALsAy
	 srAIvIAvXYOgp/qC8sTG25DQV1KakCuf2xG6r67k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/259] power: supply: ucs1002: fix error code in ucs1002_get_property()
Date: Wed,  4 Oct 2023 19:54:58 +0200
Message-ID: <20231004175223.095789196@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



