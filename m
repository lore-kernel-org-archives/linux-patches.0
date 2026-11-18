Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049058;
	b=gD7paeQhSjkn2eKX+CDB+QprVI4y3KdnH4ZCo0aCJj1SvuVzlyo1rRquinZpO8QErVo5
	 q7ubr6SRLUnqL5K6HsUHwPOI4mSBAqjDkPdVGhN2oMN30bNwW5OP2cktOmsIcx/i5SXzW
	 fv9h73gXPfryUZHigvSouM6KvDYU+18OfTs9DUSVNYLbEfz4yfIt0fIqxJVXmICZQj1qA
	 9xhQNE6yEUF16pOKADMonf62XfAurQIOD6oFm6q4BhFg0VPv36RUUW5jDfiz5fgxvmJal
	 /7jVy9LfdPs5/Clw4PM5V3N/xJVpmTvdi6R2twFyDyeKZfJWBLfEXwjEvn6uvidkvjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZxUWBv33zHGB8NGc6Ht3TVz0OjTpogwUm8XBo2U6wk4=;
	b=yUUvUfLQxMzZ9d5eCZ6kfzFH7e1Legdr6CJuHR2B5yVsuV44f+C1tov0EPVHTh+rIyXx
	 urrzE6lzNnYBveV5DvKPP7ewxdHxikyUR0wJoKA/f/BBREbhHRsB8ULNrC1l6E1Nc3NJ0
	 XXByL0t2joq/fXoZM22IMqW6r1atoASBMTU6PuaXCLCI7VNjtoc1+aa3SVAgWZJ3dkEIt
	 mNfBlkaMi7j3kMNdG07XVeLCLwq6SO769aqVkzWYEwxnpEMFuJ0YCWYHcyEmRBxle8kQ8
	 feqFcVZjwyVbdNi4FKK4gbFY0DXgdM9LtmhXzo+Nd3j0BBo6QxLqnObbT4fyP93Mn0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSDPta4s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA86606A31C;
	Thu, 19 Nov 2026 00:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSDPta4s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E551F000C4;
	Thu, 19 Nov 2026 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049058;
	bh=ZxUWBv33zHGB8NGc6Ht3TVz0OjTpogwUm8XBo2U6wk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSDPta4sol3kiNCFyf4OgGRvp4R2oZ90Jxx3l55b3nxPsywG+vg9yLu50z76pyu8N
	 eIGi8LXW6WT0Xd/qYKFBbQbGEYgUAbqWAcx9yshg9wfOpG+UnrQCTUHOxuD0ijhY3i
	 LEWVHF9k7ch3VDUR6y12brRk2w9vN02QIx29ut/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2215/2857] power: supply: ab8500_fg: Finalize current measurements
Date: Wed, 18 Nov 2026 15:54:09 +0100
Message-ID: <20261118150321.171762581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9a0461fb5e7cc64ed303bee3661452879ee139a1 ]

ab8500_fg_inst_curr_start() returns with cc_lock held and the CCEOC
IRQ enabled. The bounded sampling loop in the load-compensated voltage
path returns without calling ab8500_fg_inst_curr_finalize() when it
expires, leaving both resources active. The next fuel-gauge work item
then blocks on cc_lock and all cached power-supply values stop updating.

The Samsung-GT-I8530-Gavini, Samsung-GT-S7710-Skomer,
Samsung-SGH-I407-Kyle and Samsung-SGH-T599-Codina-TMO product trees use
a bounded sampling loop in drivers/battery/abb_fuelgauge.c but still
call the finalizer. Follow that pattern so the normal completion timeout
also performs the required cleanup.

Check the start result as well and return an uncompensated voltage if
the instantaneous current transaction cannot be started or completed.

Fixes: edc400e1632f ("power: supply: ab8500_fg: Break loop for measurement")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-14-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 766e5cfad4eb0..681b25fc14a3f 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -939,9 +939,15 @@ static int ab8500_load_comp_fg_bat_voltage(struct ab8500_fg *di, bool always)
 	int i = 0;
 	int vbat_uv = 0;
 	int rcomp;
+	int ret;
 
 	/* Average the instant current to get a stable current measurement */
-	ab8500_fg_inst_curr_start(di);
+	ret = ab8500_fg_inst_curr_start(di);
+	if (ret) {
+		dev_err(di->dev, "failed to start instantaneous current measurement\n");
+		di->vbat_uv = ab8500_fg_bat_voltage(di);
+		return di->vbat_uv;
+	}
 
 	do {
 		vbat_uv += ab8500_fg_bat_voltage(di);
@@ -950,15 +956,14 @@ static int ab8500_load_comp_fg_bat_voltage(struct ab8500_fg *di, bool always)
 	} while (!ab8500_fg_inst_curr_done(di) &&
 		 i <= WAIT_FOR_INST_CURRENT_MAX);
 
-	if (i > WAIT_FOR_INST_CURRENT_MAX) {
+	ret = ab8500_fg_inst_curr_finalize(di, &di->inst_curr_ua);
+	if (ret) {
 		dev_err(di->dev,
 			"TIMEOUT: return uncompensated measurement of VBAT\n");
 		di->vbat_uv = vbat_uv / i;
 		return di->vbat_uv;
 	}
 
-	ab8500_fg_inst_curr_finalize(di, &di->inst_curr_ua);
-
 	/*
 	 * If there is too high current dissipation, the compensation cannot be
 	 * trusted so return an error unless we must return something here, as
-- 
2.53.0



