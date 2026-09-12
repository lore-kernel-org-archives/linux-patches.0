Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB143624BC;
	Sat, 12 Sep 2026 08:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203566; cv=none; b=ZGtzRopMCNSUsMkR933iJBsKLYeqQx2LyLNd+qOLH+3iRxVQ6mfx+sliHaA/y84AQ6O7nHVDglqCeYR/JawqPpWIqeEw4agq4vn1cyKbxvKerw3Fa1npxQb28PBqz3Ydqbum9KKi6HmKbLyxJ1yBOQ42QWCBSMn74nJd81xKzzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203566; c=relaxed/simple;
	bh=0k2gq2TiipmKKKQzJhw8OAHdigmedDfgZ5VKwPC/0xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5XSw6O5DIGVyPMPModkSbgmY0Cd9BUpLJ8PHA2NhnoF5sY6o1v8tegyFd13PvO5mHJlyEK2UY6Ax8KCbLs9BfQO8zZZldiX/mcCByuekh3GzKpX56SdX3YjHUFcBZXuGOvLV1McmPL5xoC3tsU5do2NWvb9Onq5jTpk0mTNX70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsB+QYhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsB+QYhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DB11F000FF;
	Sat, 12 Sep 2026 08:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203565;
	bh=LnGOTelyjWgfRIyejbwJq7cVjIaEWnNYFJev9PFe90I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsB+QYhkkaobrhXfZuDfYfP/ON1+L7uoPTYmYYjSIpg13fPHTVD46Bh2bwD7L1Rqk
	 tYEfLZhCgvm0F4zqEHaXv+e+BVMmnayxpZnwjx/hEPh5qFyRMpW/+f4qtYg4JKW3AB
	 ZiyorDOGi2ebPUPificcNk5f802bcedWGT9pxta0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Kalle Niemi <kaleposti@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1417/1815] power: supply: bd71828: Drop duplicate power-supply property
Date: Sat, 12 Sep 2026 08:52:47 +0200
Message-ID: <20260912065722.286487442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 6605209ceb53eaa25582d1f4726217bd09eff392 ]

The POWER_SUPPLY_PROP_HEALTH is added into property-array twice.

Drop the duplicate property.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 5bff79dad20a ("power: supply: Add bd718(15/28/78) charger driver")
Tested-by: Kalle Niemi <kaleposti@gmail.com>
Link: https://patch.msgid.link/518283ec9163943fcd1b53ad61fc3025fd346d83.1786356145.git.mazziesaccount@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bd71828-power.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/supply/bd71828-power.c b/drivers/power/supply/bd71828-power.c
index 98e9b096cd1c9..792596d96e624 100644
--- a/drivers/power/supply/bd71828-power.c
+++ b/drivers/power/supply/bd71828-power.c
@@ -639,7 +639,6 @@ static const enum power_supply_property bd71828_charger_props[] = {
 
 static const enum power_supply_property bd71828_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
-	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_PRESENT,
-- 
2.53.0



