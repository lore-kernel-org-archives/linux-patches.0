Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9BF133435;
	Tue, 23 Jan 2024 01:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971914; cv=none; b=U3pWcAT8TWdOz1495+Oz0FYpWlpyCa/JsBh3cEWS0vYTG9JbLYpWpNdmUyx5gLVYGRSZs7EA6eyRDlc6gWPGnciT0MmF+ZOPYpGxwNt1BHg2CRU8JIMz0rqx4u526kSy3QDZUXOkNu7XQSU8OSRL6jaRSD+OEpAoHkN9ypnNTZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971914; c=relaxed/simple;
	bh=//mPx3NEZtBtuYfMw1gm8HpziCrMEqvhBKLooMBKJOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdV+4vjmxLnRYj2JmO7XBNHjGj9tDkPypryPaDl4pXwWqUShi3fJx0H9xP+0ObetsRlEpaQJ6AjngHbRyKJYAsRGcwnrqJn0P/fUec9+XmKHneaoj7WT9o2pI669BHuYn/u9LntXJPs4vwqCCKzkjLivnoF8PkF+oxfXNjZtEbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3gnJdYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3gnJdYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10B0C433F1;
	Tue, 23 Jan 2024 01:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971913;
	bh=//mPx3NEZtBtuYfMw1gm8HpziCrMEqvhBKLooMBKJOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3gnJdYCJHRdImh35HJrT3I23UOEs8SZk5GEX9LrSl4Ax0IeQJYCvTc9Wc++XWaMT
	 5PX8WKwlKC1kyDd7sxVAWIGYAkE7W3trzuOQDXhmnm0NgXpgvdmOIjUK9ZrwzRCdQU
	 SPuYIzS8qPKMZJEA3E2UwPc1a2HJkXE/H/xwXvYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus@fastmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 336/417] power: supply: cw2015: correct time_to_empty units in sysfs
Date: Mon, 22 Jan 2024 15:58:24 -0800
Message-ID: <20240122235803.421239095@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Jan Palus <jpalus@fastmail.com>

[ Upstream commit f37669119423ca852ca855b24732f25c0737aa57 ]

RRT_ALRT register holds remaining battery time in minutes therefore it
needs to be scaled accordingly when exposing TIME_TO_EMPTY via sysfs
expressed in seconds

Fixes: b4c7715c10c1 ("power: supply: add CellWise cw2015 fuel gauge driver")
Signed-off-by: Jan Palus <jpalus@fastmail.com>
Link: https://lore.kernel.org/r/20231111221704.5579-1-jpalus@fastmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index 473522b4326a..9d957cf8edf0 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -491,7 +491,7 @@ static int cw_battery_get_property(struct power_supply *psy,
 
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
 		if (cw_battery_valid_time_to_empty(cw_bat))
-			val->intval = cw_bat->time_to_empty;
+			val->intval = cw_bat->time_to_empty * 60;
 		else
 			val->intval = 0;
 		break;
-- 
2.43.0



