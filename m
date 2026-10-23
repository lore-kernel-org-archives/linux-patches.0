Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773796;
	b=pV91htV+Co7atkMboXUsWacOTUbaU833uOQaIW6D0x8eetAO8nrozU4zRFS4O/Jq5pfc
	 KHS2CFNZvcGj0i7/D4hMtK/guzWDINrgjzoUeFE9qbHxtn5d50LQy/ebS70bKZB5U9vDw
	 KkN4QggL1XSrXb9ZdvnkT5BPlF+onbkd0f/lGO5Iq9IGlBm/aJQxu//TPyecl9qKfpi56
	 z5XjjZTtmL7MiXRHJLx45LUHI3whAv8QA17efMvge4J7LSJ5+S+FMEV/wxJwuCI4KdijC
	 V2Yee3vccDw3ygEYJC9r0Hy5HvBVC5Mw/Rf8vQslbFt1okoIGKCoGuXx8lONTEpGLxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vlmx/guPJThAoqssX1ETfj18gaHZY+sQ+j84iajtzfk=;
	b=Lm5k5TnRZeVb5D2ysxcIctFIkY0nVWWRKfqE5dCAR+DvDBWmQ4WYlsg79VWFMjKWhWZS
	 Hdtp5L/CfCU1GS//PsQRtRWaeG+KKRrjcj1aU6nQT38loTK4Ruo/U77MsfVauuv5O6Nyj
	 VlgruWILIt3iRqeH9gg3BF8p1nTlEOjskZYwoJyRYqxMbHxkN6MDu0mxIwQ1aFjwIXc6s
	 A2SYiUsqI+x3+utfyvzF4LLWHA2tA4JvI23W5HvbGgPCKIoPjIwC1hVaL4UJujtaT3WaK
	 4gbXr/4gU9G63nokNyak9yYlqTzJhcsBMuZYIXjM473im/Qi2A/CSrmOXi6fiZ8d+LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZRcG5Y7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD27D606A320;
	Fri, 23 Oct 2026 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZRcG5Y7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366691F01825;
	Fri, 23 Oct 2026 16:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773795;
	bh=Vlmx/guPJThAoqssX1ETfj18gaHZY+sQ+j84iajtzfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZRcG5Y7WdoiWHQ/5ptHmu4Ij+o95oIedIFvrdx4pVATs9OJFfd0bCvS4Uw2uKJIw
	 WtrHf7k9XxmHtQJEtVMjtRsHZSlUiGLHVc1Goa92jldrHtQ0kbtuxA1e0lM9N6e/IP
	 wMB6H0fPbjTyJjK/JCTqXk1kXPnxAJH5fpyaCPso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/193] power: supply: Fix maintenance charge table kernel-doc
Date: Fri, 23 Oct 2026 18:34:48 +0200
Message-ID: <20261023163714.470842441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 360ffdf272dab..2a8266b125618 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -397,9 +397,9 @@ struct power_supply_vbat_ri_table {
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



