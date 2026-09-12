Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0521035F191;
	Sat, 12 Sep 2026 09:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203710; cv=none; b=jU5aMoiCZJKTMxZIb1eGXyVihDHrA8XBm4kur22wefP11SyGcOt/9YObdfOclHX7M+3kJQdNR7iZGmTAwGXYiNvd919PABDIXmdUCHUf5dUwjGuISH+nTHH4JVbhTsl9pp3ue6tm84gxsPci7iA6sCGn9LAln8QzQBzXN8aICKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203710; c=relaxed/simple;
	bh=Z8+ZlzLVC2p//php5E8WCAbpPz+CAfIEcsFX1HgLZoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkPVOI4fUT1eSpHHd3D+EjbsUFz2+N5V8Qt3v2ejafw2jjjRmiYKO0fn5ZF4EQlaVwfq5zCdZJpHiDUYL/al+cKkAjRFgCUiRayGNjlk+BYsgCZ3lxe/iTkv4FjkaKEIXgJH0VwtlDsyiPxdzS0YF+LcniaBJdcDh6JllWkraKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPihi8TH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPihi8TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B451F000FF;
	Sat, 12 Sep 2026 09:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203708;
	bh=g1a0dqiOPctKKMaSsV/ak80J4B5sHnw5LA35yEc+nxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPihi8THu7grcHKp8cLwsma7xN5rIlZFD4Nkwr+pqZUWNdfFTsfSnJEqtgYdkTnDD
	 3uAFf86rHV4F8G+hTYXHnHs7uqYl54yswZbQupmfL8PRLIajWyeoT39NFVXRpJ2JAs
	 B8AaAxvNkhSg2lfrM9QDrGD9EpPtKT4yZoaVXUwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1420/1815] power: supply: bq27xxx: bq27520g4: fix REG_TTES address
Date: Sat, 12 Sep 2026 08:52:50 +0200
Message-ID: <20260912065722.355612458@linuxfoundation.org>
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
index 45f0e39b8c2dd..e72a9d8399858 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -330,7 +330,7 @@ static u8
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



