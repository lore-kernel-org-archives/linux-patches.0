Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064425;
	b=YSufaf8QJYXkgqBabsY7lRehJMJF7MN5nlKgNZlzLMTEjgzROGgYgBlOPQds9IuMNsxJ
	 YvdKl7Lv2T/yviVfodcN3mpJs1kxWF0jRLwhlYe0QBlPzxKAXGPASy1P4FUuFPyLQ/YOU
	 THqm1JT3cxiRvooW2WluXIJuKlPmx7PLMPQysqbxjxKlRkTAuKl2RAtoJhZTrhF/89Ea+
	 EOAa14+7tcKIs6sSCzd7NTtMYgc9uRO2J6bU59GtYBaKcuzwDiOUFegUrFt2pasoD8/YZ
	 IvAftAOEZz+KDNGJ8MALnZNAwNZLdFpBUf1vwKGcQ1vulQSprWhlAV3D43522te65nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GQW6qc9EphUMe/i3EJsbv04YBl++6D6gx7CRahc257Q=;
	b=cbPnjFz6gLwJR0IJdNn8J/+p7VoQ9Uf4esOTmeTvKg8TWxlKZLQTCmE2Wgvk3yOhXoNw
	 feXU7OI8lN3a4L5OG0lsygR1bGysp4+CmNJcbFo7czFiMUt1qI3kRypPj/X3kzjFZau/W
	 XE9a3pu+c5DnwHehAk6G2nGfqG8XKBs76/LLw5k2UegkCB9+71PnA4UGgrZbUvrY0lxKt
	 pexa1ghQQJCMHzv7LcxL4Jvsvq/+KkRtGJThTL0zvQgEXx7d6+nhmF8h22hqtgaWTbdQJ
	 Wi76/+p7JAgX8fvKHDZMpopAgH56yANGqpeQCCdphpTIJsWnzv1zSrMsnUDY7OYlPUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqjHIjcz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B835606EE91;
	Sat,  7 Nov 2026 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqjHIjcz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1C21F008A2;
	Sat,  7 Nov 2026 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064425;
	bh=GQW6qc9EphUMe/i3EJsbv04YBl++6D6gx7CRahc257Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqjHIjczRx8Ics43ERHJZnca1h1q8LiY9hIZh25ScZDRhwQ+HhZsKZt0OazDQr/lp
	 eITpKbhh7LNArI6W0S9Su1tlzDzfbwsGwWE2EeXQ2bIhxzk9RM9RaLCLaRlh9sno6F
	 0vRAJW940F7use/3XHkip+oYLiYJyOSeWQqMnKZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0475/1257] power: supply: ab8500_fg: Report sub-percent charge changes
Date: Sat,  7 Nov 2026 08:46:11 -0500
Message-ID: <20261107134952.570962906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 016ed35e90f91..c5eaa32c4a2d8 100644
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



