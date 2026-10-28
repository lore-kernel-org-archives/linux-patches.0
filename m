Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210025;
	b=aJZW18+cpJdpt4vTOUKQo6/7fwQfFdsVWJiI6FIDsGCBxyry2/hoVyL52uG3EtrZTHZU
	 o+wBocjzWFX+91mF1JYh8WROWEsZlu7lxfKNA/O4Q8OA1plMmXijALoxSpNB46vm7t0bo
	 eDen48XuX+iu8tdRFzxKGmhUDM80AolSZIcromdmywyFHKThYO/KkcbZbDr1ZuxI3Hz/G
	 b7sM/uZ+NXiXj0LGPRPxJ2QfJMz9UOCun3O2eVhVJPvpuGE9EVo9YxHxT1AxOaxRJ9nf2
	 O6cVpoBycAIGTiaB/97f26HxTwwvSMV8NP9X6yhJsxOCp7PIUbZ9cWBY0OLciQO2iXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bBt1xYl6JoqijT7TOnMdx6DVcInHw6Y5Cb5k/RfWFS8=;
	b=02liaEkGijyJ23ioycshWRX0xW2Jaq+RWqLZ66g0espri6Vp0U2//7jxSVSQ7aFy7dYq
	 lNA5GfwjmDLGEJTsMiokQVb4elYaHf8LGSwr/3tWTO4vPXDH3ophBFDlUT0HYZ59DRmx6
	 KwBCJiIFoy0Oh3/gbKBz/2pikG4cmsbntP0om49okEvXVaQtInPEkvmo/pDvtHU8xNw3n
	 /5FUnKoqrW8e5OqS1K6oYmXx7dqmpz/inthOS8PGQMckWTkd7psAIvmoLMBoFrF7c/6a1
	 EQ3YtRo7TayrnYv6aaALEVYaCrOZEKjAp8cC5+mL3RrrNL59WKSna+i+8zIHFKjQz4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvxDIS9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12506606A31F;
	Wed, 28 Oct 2026 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvxDIS9P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EEA1F01825;
	Wed, 28 Oct 2026 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210024;
	bh=bBt1xYl6JoqijT7TOnMdx6DVcInHw6Y5Cb5k/RfWFS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvxDIS9PvAMjuF2/jaepXvLU2PGQv9hYQeAZugdV+LC2s0R5of0f6fVrA1TjbP3Ta
	 QN6rCrfwByvM64YGUOkf/YbhqhDW1Rjb1ziAIeJG8yIpxaO+Ehr2mqbuwZsQgbshfg
	 g6IJH6Ay8dgbm4psZo8ZS1EtyIT/JTAFyCrDIMt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/168] power: supply: Fix maintenance charge table kernel-doc
Date: Wed, 28 Oct 2026 17:59:01 +0100
Message-ID: <20261028165943.221487979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
index 85b86768c0b91..aa20bf8c3366d 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -365,9 +365,9 @@ struct power_supply_vbat_ri_table {
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



