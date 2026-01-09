Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9862F12D4;
	Fri,  9 Jan 2026 11:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959707; cv=none; b=OcQ3XpxHMtW3im4ioDy++fiS17UDZdNfqSzRMDtA60VgutjmcdUyKvXMrcAafFk/mbybej83Gvuwckpa+HAFo8HYYtdL03u88RqG8ejWAZWpKyCr9ydjoe7j+YLHuHHeK+05mhUyohm0idEJWJj4pA1780/y5dBdpeGIlgNEFrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959707; c=relaxed/simple;
	bh=heQh4Gmu2e364sIdiK+yU4Tyim3+t9qmGHXKhZUj9yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oosfz8jyZkIpSRmPOz25xmblQQ7ozJI9k6/uBkOmgkIJ6vaJ+CfHhZKrAxR18grZwtmEUAC/3n0btZe2a7tdZfKgcpBZQCOjYL1AX8NXp20hOHaJOJ7o03y2Tq96I4QZjw6dzMRtECH1JgIshTrL5/BLx2ZrGxdV4Cgzt6WOCjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBqA6Jen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBqA6Jen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DD5C4CEF1;
	Fri,  9 Jan 2026 11:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959707;
	bh=heQh4Gmu2e364sIdiK+yU4Tyim3+t9qmGHXKhZUj9yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBqA6JenzehiBgljyJIF+sXPEsBF/8UtpEEv5TIzKxK5hzdhRI+4HrR/u7XHQAzF1
	 MY622IubDHOqqKfeLC+Pyk3vxkjNQYhwxfrmZztunu1D6Jdn9mdmDxOxF4J5hiKnKt
	 6Ag+DeUtLgdYXtlFnXVRuRWRXGNY2kHQPKvnhM8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/737] power: supply: rt9467: Prevent using uninitialized local variable in rt9467_set_value_from_ranges()
Date: Fri,  9 Jan 2026 12:34:13 +0100
Message-ID: <20260109112138.293256749@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 15aca30cc6c69806054b896a2ccf7577239cb878 ]

There is a typo in rt9467_set_value_from_ranges() that can cause leaving local
variable sel with an undefined value which is then used in regmap_field_write().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6f7f70e3a8dd ("power: supply: rt9467: Add Richtek RT9467 charger driver")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20251009145308.1830893-1-m.masimov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9467-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index 1462d630e399c..1e16593267511 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -376,7 +376,7 @@ static int rt9467_set_value_from_ranges(struct rt9467_chg_data *data,
 	if (rsel == RT9467_RANGE_VMIVR) {
 		ret = linear_range_get_selector_high(range, value, &sel, &found);
 		if (ret)
-			value = range->max_sel;
+			sel = range->max_sel;
 	} else {
 		linear_range_get_selector_within(range, value, &sel);
 	}
-- 
2.51.0



