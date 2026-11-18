Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040739;
	b=ZKrJWLZxnk48T4bpNjYEjk2/n8op6/1eRqtNWUGg9AGL/ZR0naTM8Onccj1LxfZ+QUF4
	 SOXVai+5uHA6rJ/y92vI9F8hUPRbvD6otNe34nnV/xvsRttlio/owCV0TRdOPgktdUBoV
	 O6K+3dEtpyLS/DtOvurF/zlxerW8Z8H5MQZwYc4/LwaorWtR/oY5773K3WrYssbI4K+2z
	 +V2X6cYzRJcNhCDJWU10gfq2ZjsV76V1MmEUlTxGKXWmWIQsZC9WF4wR6BMwwWi26qbDD
	 OqEQETSzgLDkBE/4DXOLBmDUS5fCc58NiNtijaCDIn0SOOFk+PXJgYMfKED3tOkBB3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jmqEs9f4oAsbr5lONR70t2zLWOoxTfqkZ9qd4xaCcPA=;
	b=ygXnR0LUGZReXkYkx18h9b7oLDeo4y1hPNkb83MfXTvzQGHaCAyEYGERTsCdJhcQlYvp
	 x2V3XPDopRUYe3+t8rCLL4vWjktV3+hcoaN3miSunRSQpS4HbLldZ9D9+hNw+Sp/toNjE
	 BVD4ntd7J89fkRYehjgWIzmJZ94KAc3Gg5Hc7+rMXc/ybYPpA1cT0Rg+H1cVQnJiFZJUe
	 fmjcaFzJXBedprnN0z4Peo3kKnAou0WKMeT6QQaEo8YIwgS5/ggIvsBsTVNlK1oJwHT8r
	 i0CRfAKVfj20LYktA0Wk5g67QHO7dLtSlmaBkETKaO5i9g8el9P78XXu7bW/qQm+FcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSlIMwaq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2217E606A31C;
	Wed, 18 Nov 2026 22:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSlIMwaq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7721F000C4;
	Wed, 18 Nov 2026 22:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040739;
	bh=jmqEs9f4oAsbr5lONR70t2zLWOoxTfqkZ9qd4xaCcPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSlIMwaqyF89t9KtG89P9agabBw3NyvzchexgMSsFVz7593AHVjwV6R3S+OuxULSA
	 cGTpfVB/gS1XLx4QZ96YNvOgMo/RE9nVU2U7BDsuEPHFMSWSQsSQK+kCtro2KZC5g3
	 v6gaF71tQdTCdvEvKQQR93G8iQUEQoT66JzxVyUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2564/3318] power: supply: ab8500_fg: Finalize current measurements
Date: Wed, 18 Nov 2026 15:53:06 +0100
Message-ID: <20261118150438.169780043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 26246cc559d5a..0e9ab48aa339c 100644
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



