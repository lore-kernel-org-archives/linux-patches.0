Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207434;
	b=ThE9VcrRvorGkEHgjP7kNLQflcfSlT4Ik1kGvVRkfX2LYiXxzJvQQT2FGfJbY0Fh8+73
	 hec3FP+2mon9S5fQGfqtTJl3EOkAbwYTW3NZ+g69cSxAAQhbbiGnhUxNZ6oDtDr9LS5jO
	 MFwp605Y8AqK+hqCaUaFm9U7PCNm/hcPOqaxUGiSY6zDrBfxNF6uFJ8a2rjMIzZwTwzy2
	 juK79l4ERELaNIBXkzG3fZ+T61Yeg6xWEhx85f7gfvA6zH55vbhCiMuwsduOaqYV0un4e
	 MAMPNgBvu/4t08xElKKTR6vYomo8lPEibcu5y258F/EOq4+6hupnBkJxyh4ksLLy+zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZQKK1LRYGviG3YWXqjLPicaIB53WB5vD7FfnmrNFj4=;
	b=UbvDleWnL6I64peXIraOKqf/MWiPQPne4acrwoRBq8ISaJjBGrorWc4Sz0jZeP66ZHL2
	 nipjbojqdIZHcw3Nx7ERUkJR5h8UOgfTLoJNgQ8xdK2m577otBcvzi0mGAPHMJSnhv8cS
	 uE3fjBMqVzCFgxmmNtyBiPb1uEkAVc9ef2ua59zjBX74Nbrt3R8MaBijX5GI+Dj04Uygv
	 naLEmAwfxvcPGRhIXsq0sJzJ675oEjYvRv+SuBdyfUplgNvGoiAXCPDNqXb/ORUqBlmYn
	 8agfzTpnSdiP694vn0uIeY1qS31/afWtFr+0y4khINIh9gH0sOr+TxKnA9gNo7W2IcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2e62SzCo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD7D606A31A;
	Wed, 28 Oct 2026 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2e62SzCo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD961F01825;
	Wed, 28 Oct 2026 17:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207433;
	bh=PZQKK1LRYGviG3YWXqjLPicaIB53WB5vD7FfnmrNFj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2e62SzCoiXfwLQ1VHv3Q1SJqPh0YmReeZZhlaGSrw/pDQmBfXzel6nvCGk7R2ZDZI
	 hrXza6lw2c+C4643lb4EpDEKOfzUAaL2+laYp+FF1fBF6r+IKN2VJpsU6w3LMX1gAy
	 ii78R2p0WoTd3sH66R+YeOrDDvNAGOCrJ2cEphbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/247] power: supply: Fix maintenance charge table kernel-doc
Date: Wed, 28 Oct 2026 17:56:59 +0100
Message-ID: <20261028165947.743387733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
index 910d407ebe632..b03991a29a65e 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -360,9 +360,9 @@ struct power_supply_vbat_ri_table {
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



