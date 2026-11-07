Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062253;
	b=hAccOQkjBiA+BoPAy7GYFs1LInHW9hfEigJ2jsJ1b+als8g14q9h/qh+2vph2vX1QtxZ
	 m6rSPdMZepve0o1t8PtJwJk6uehjhtmE7soAQcF7VnYzDrrGA7iGplZ/EZ/HDWD+R0tlC
	 QwJ/HsynMnAyPoZhQtwIG0O5oMn5cGs1xhD1aqFkGu5VhmmvBJM1ioc2IYj4LnEhxn5/q
	 siQafsDrpNOCRuF+88uIYCouLTeR7ZQEdWcsslUw5DaFBPJme6ILH587tZ9nz0A4Ytdq3
	 OUOIS+JJ7OXFz7kN6ZgiA9RQ40x3DD/6nr1O8HAfiZknQzWHKcUSaB0PYcAWWYMwOpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YGbqaEy6wWS6/pKxBu6tm4SGULsx2iqStEpKeBUVIWs=;
	b=ym+Z6qrz3tFQ6K0T9JYPnBb9/EH0MZMfzIhg9/C1c7CRSEzv8xCgfQWfCoeE/j1gFqpS
	 +UndFz4dnZXiGJrDwGzJmykecnRevZWF5kHbBViyJgJ7KwGC5MwJFaKtmuzuk/rjxstfT
	 LVheq8QEQMDrYESzFjvWtwKs34W5DbotFEEq0sDxxiKkApv32N2lIy8W7h1TSYR4xYosE
	 y0iyf8UUfQdgRxRSGfxv7+WvTJc0im2BeH0McuIllqLrrOAAdisbheHC+We45/zsyqoPh
	 ykQNagwpcYzYy7qXXnRctL43wotl704vZhNdzCZkpw0wzcneD890QlNJMgXJKtMci6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtxjhBuU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13557606EE82;
	Sat,  7 Nov 2026 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtxjhBuU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8AF1F008A7;
	Sat,  7 Nov 2026 14:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062252;
	bh=YGbqaEy6wWS6/pKxBu6tm4SGULsx2iqStEpKeBUVIWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtxjhBuUhd+/REchwrRA8uCYVmg/pElTxzmQCPoWHiZnwRc4P/LfQtPZKM3svR+c2
	 sNh1rIH/DnFYTPR8yz9TbKVcu43eyYpekbsNeiB24M8Ku6Ey5lhsRWVZUgdbNp4AnC
	 t7tafydt15+JVSsq+MtTMqjYkHiN/yHGtGzfLf4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1158/1536] power: supply: ab8500_fg: Report sub-percent charge changes
Date: Sat,  7 Nov 2026 08:52:54 -0500
Message-ID: <20261107135030.250407138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 4d40dba1815d46c6ef9019ed80e3b998b0fc443d ]

The fuel gauge updates bat_cap.mah from the coulomb counter but exposes
bat_cap.prev_mah through CHARGE_NOW and ENERGY_NOW. It only refreshes
prev_mah when the rounded integer capacity percentage changes, making the
momentary properties appear frozen between percentage steps.

Refresh prev_mah and notify userspace whenever the new charge remains
within the currently accepted percentage. If a discharge estimate tries
to cross upward into a higher percentage, the existing rejection still
leaves both the reported percentage and charge unchanged.

The AB8500 fuel-gauge implementations in the Samsung-GT-I8160-Codina,
Samsung-GT-I8160_HD-Codina, Samsung-GT-I8530-Gavini,
Samsung-GT-S7710-Skomer, Samsung-SGH-I407-Kyle and
Samsung-SGH-T599-Codina-TMO product trees retain the same percentage-gated
prev_mah update and contain no finer-grained reporting workaround.

Fixes: 13151631b5bd ("ab8500-fg: A8500 fuel gauge driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-2-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 4c15cb1f7b7c2..fe143d13718c4 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -1387,6 +1387,13 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 		}
 	}
 
+	/* Keep the charge properties current between percentage changes. */
+	if (di->bat_cap.prev_percent == percent &&
+	    di->bat_cap.prev_mah != di->bat_cap.mah) {
+		di->bat_cap.prev_mah = di->bat_cap.mah;
+		changed = true;
+	}
+
 	if (changed) {
 		if (di->bm->capacity_scaling) {
 			di->bat_cap.cap_scale.scaled_cap =
-- 
2.53.0



