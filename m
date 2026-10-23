Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774353;
	b=zCFOFKA990tcBrQMM8EmIIUG00+jnjrdDoLT8vzIb9XtL7UH/U4g5lsEQRDe2oYhcaHW
	 YwpRoFRhXzTexczDv1ljrqsqRkrFTGpRhAJlrUiPS996iK55xImwgZZRD4Xwk8EGQnnzS
	 BDKBgxL7fuO9+buX1nupj64McnHMfITCAUYgeHL7UQtt7jDDLfqKP+73BsodCPrQpchLl
	 xZmBcOq4pHIAr4Auq364Y2sPbTjbvlxLwXk9onP+dLe4h4u7GfYbf3HpHtTgS65tmTzQS
	 vV6xcOqrpl2GigskyoSojYNcFQxXM8b0EvJlNU29wvoB08aLQMrPl3dAQ3mECEdYbTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PgDZ8owmUDklsh/REx453VAvwv9SJKiAP8oK2cx0JlE=;
	b=zJYD13+rAb+uSKsgIlhUA47oXkks7EQMh7ui/pCKvfnjrlHONUB/juvf+jgzwA8c2KVy
	 s/ud9waNQaLExmIx+X1PbLL+utKEy1hG2oCNRW45UEUBgBp7AyI5NJQywnUiZhRq7JDrE
	 xm6W7vdaWW61DGSuaJVuXgaYi06Uh+fMa4KFC9sDplbGuk8bMHXz8IkVUiWbJepMf5dXx
	 gHx8Hug37A24XBnJYit2WZFjTerFJ0A7padhAnozg7HzL1qFZ9J5yQzJ1UDW7sVZYpLv8
	 nlb2gmmwzfc8bXP7mHCqEnJlGELzNcdtMt2iNcMmmzNxD1ORC1j3MIEBrbSYbOtmtoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7p2BwHG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86212606A321;
	Fri, 23 Oct 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7p2BwHG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90251F01825;
	Fri, 23 Oct 2026 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774353;
	bh=PgDZ8owmUDklsh/REx453VAvwv9SJKiAP8oK2cx0JlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7p2BwHG3OQ0YPNjtzQa9UCxUT168bE69HW/gPvn9KWHg3QlPYMVNJrQU40OausAT
	 sqC7i9jAVKuY/OEr9mfkyI+SWKUGSxeROLXsagQoFJyEPEw+A6V+Oiq/OcUASQ4Vsc
	 u134xsBG5xkNU4MLcL/kmUVXnMuP4U+sFlNdh7Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 005/242] power: supply: Fix maintenance charge table kernel-doc
Date: Fri, 23 Oct 2026 18:37:27 +0200
Message-ID: <20261023163713.933463906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 45d4af4e80a25881b6b75e8e34872c555c43a41d ]

struct power_supply_maintenance_charge_table contains
charge_safety_timer_minutes, but its kernel-doc describes
safety_timer_minutes. This leaves the real member undescribed and adds a
nonexistent member to the generated documentation.

Use the member's actual name.

Fixes: d72ce7d32478 ("power: supply: ab8500: Standardize maintenance charging")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260909064623.90737-1-kmehltretter@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/power_supply.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 7a5e4c3242a01..b85fd02409c67 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -400,9 +400,9 @@ struct power_supply_vbat_ri_table {
  * @charge_voltage_max_uv: maintenance charging voltage that is usually a bit
  *   lower than the constant_charge_voltage_max_uv. We can apply this settings
  *   charge_current_max_ua until we get back up to this voltage.
- * @safety_timer_minutes: maintenance charging safety timer, with an expiry
- *   time in minutes. We will only use maintenance charging in this setting
- *   for a certain amount of time, then we will first move to the next
+ * @charge_safety_timer_minutes: maintenance charging safety timer, with an
+ *   expiry time in minutes. We will only use maintenance charging in this
+ *   setting for a certain amount of time, then we will first move to the next
  *   maintenance charge current and voltage pair in respective array and wait
  *   for the next safety timer timeout, or, if we reached the last maintencance
  *   charging setting, disable charging until we reach
-- 
2.53.0



