Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216851;
	b=rO4rX+OP6OZJL7eaaCYoalObGX5OJaWTeE3KNG81QvJRYqZWnJlT1Czk0uMwUJSJFrxI
	 qwu+pAm9XGHS6Z4Mydxgz51m3t/u5OBJxiNAYLgMpYR+8BGQvc5SvvOooA9998AGo7rTn
	 YYERuwxkPIprL4VPPbSUjorbkisKgAo4I4RCOYONGABCj/KaI52ZcuNRtwiCSbME/8Qdy
	 MDlQbEAI6QICAwkjGBKA6I4JPasJI/wIt5/fQCId8GoRU28ZLM3rf6pDYDBnyNiYNRYXY
	 DFgodJ8KUPmmTWWEge5KZ5wJt7kwO7t4V1QDvm2CsJ786v7pEcHO/jgwY93UvtZO4uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VDvlFcE9XpRRGOzKGNKKT/sk88ff/onrpnbPp4ZVrj8=;
	b=BNwFn736PBZNRNqLkANv5Q/44a9dL+F4/xjn2S5mJ3z1+iQM+8HksD0qoiUkBA+d0MEF
	 jZ0PD7G2i8ODyIfXpkTySpOwzuCosoT8FlP+Ul5z4XjZhHmLrWh9BnsLdeUV0RGft3EgH
	 9ofq0oZVR/rUotFC5dViMnU1DuDuUPctMu2Tlb40IX5iRMA7NVSKUM0dQa6MlsR6pozMh
	 eW9+vZz2iUfAHcJu+DS819eDvEHOeGReaKkZq6AG72DiKbUmwYRq8pnBqh16I8h8CNVF0
	 /kno043ietSmI8baDfM+rxy7LTK/T3TuCoZjGkBteutAaz4eG5nhPUNtnzDnv1RhAFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihPw41dz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42564606A31A;
	Wed, 28 Oct 2026 19:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihPw41dz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9371A1F01825;
	Wed, 28 Oct 2026 19:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216851;
	bh=VDvlFcE9XpRRGOzKGNKKT/sk88ff/onrpnbPp4ZVrj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihPw41dzPGVC2R7kiycysPvupt5TS4p+YP3izgfARHtFqoHlAods01qwKnH2y2acH
	 G9mWJxITMY1f2pGnS8dpmnnzSlAXh9TNugXXs3do6xAmgbOpljZ5IlB6QCYosGaK57
	 9fYzpjKLJKBVH2fsja2VIP9nbn6w/CsZP9bbMikU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1702/1887] power: supply: Fix maintenance charge table kernel-doc
Date: Wed, 28 Oct 2026 18:03:18 +0100
Message-ID: <20261028170538.185355479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index a10428884e6a5..049ca48a98385 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -364,9 +364,9 @@ struct power_supply_vbat_ri_table {
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



