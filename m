Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7671920ED;
	Sat, 12 Sep 2026 15:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225434; cv=none; b=CXc2cHOYyeEMumRecvMawgHAgUob793VeebmgwzCvN/GbN6kuBHEKXr8xy+0Oz1xhxPaetGhSRAfmnXTgvQ7aJvPblUiz7uctJhb7c1Bxth3q0TVuUoc6Iyb/oIXw3x1d8tb2VVQ+it7alqBgUluox5V/WNcvSeYB058ETIdAlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225434; c=relaxed/simple;
	bh=4a8sqUgR428xEXqq+7jKfjnBW0o2if2TD4fB+jvEZ44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmka08P8/fascHw1y8MfFpoViOvdONyrltxkI+H4lnKvfhLWvhJAy71SAge2FkttB1kbQ0rzqQ7F8GfhZxow4xmboHQDZKPcUW1UgjN6GCMkdVhmvJ12yXz4CgQU46CD7DgtHns+HjclQATuJ+hiV0RwBbzHBLRtFrLzfxAptkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D03aIMgQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D03aIMgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6B91F000FF;
	Sat, 12 Sep 2026 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225433;
	bh=mTFEa0rHyWKgGesxlSwFnIj1Y6H3iNGAEEiXjXij8FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D03aIMgQFm0e3Du37UGp4ALZV7DbsxPeqnR7FKdcHKtq3WxxH7uTJhbAiT0WW8nw0
	 IcT0XHdLwl1OLQGi6Csg+RKP5scEptkvWcic7ixNcTnJ+qjsNKtzEIDn9BNGGFK7Ao
	 naUAZHDAHnMkLBxdTFN6KbeCorsOKjW4tVJuX3bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1198/1424] power: supply: bq27xxx: bq27520g4: fix REG_TTES address
Date: Sat, 12 Sep 2026 09:00:30 +0200
Message-ID: <20260912065634.114837656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit c774a623c821a173c950e1297f8e8c85a89455be ]

According to the technical reference manual the StandbyTimeToEmpty
(TTES) register is at 0x1a, not 0x1c. At 0x1c StateOfHealth instead
resides.

Fixes: 8835cae5f2ab ("power: supply: bq27xxx: adds specific support for bq27520-g4 revision.")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-3-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index ff01d5d850f9a..b6eadd6ec87f9 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -324,7 +324,7 @@ static u8
 		[BQ27XXX_REG_FLAGS] = 0x0a,
 		[BQ27XXX_REG_TTE] = 0x16,
 		[BQ27XXX_REG_TTF] = INVALID_REG_ADDR,
-		[BQ27XXX_REG_TTES] = 0x1c,
+		[BQ27XXX_REG_TTES] = 0x1a,
 		[BQ27XXX_REG_TTECP] = INVALID_REG_ADDR,
 		[BQ27XXX_REG_NAC] = 0x0c,
 		[BQ27XXX_REG_RC] = 0x10,
-- 
2.53.0



