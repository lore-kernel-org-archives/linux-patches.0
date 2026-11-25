Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618777;
	b=FqMMpOZoIZrUIFA+bMg2hsNfuRtp6o9gkzb6uqrHr7YqE45p/hZfEyh81D52bALg7b8K
	 dwSAi1RCZeTOLVi7YD8nLw/5zHT9EwB8MyqG8IwukYAjqdV1XG5VaUdZU6ZnFjhPmscPr
	 e0gepurka4u5KUleLRBLwl+DMWnLoLyltLXezfFHrTVRPQQFwfPTlRhz7hVR8/lI0vj2i
	 vVfPxvB9Rru++cI+bBmyVaygtLIJzHYpWGkK7qR2qxU8/KyFeS14XPm+67QwkYV94HiX8
	 Jh2ci/J7nnvBe3jXUUXHf0l2rdtFNylJpHYOOR3KaYWAg6U0+Ts6GPeTuzGyeFr6d7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C7uCGei2RlQvDBnKozMiliPgxR6SEpCEBTOieWGKzAk=;
	b=Xala5BnI4q+xpH98B+r7Afp+yMjr3Hwme/zz7oNBwaC5SLL0BwK0wA1lDPqS3FMt53BN
	 b/DJ5ZwB2L2GUv8UE6l1X7wwedXKL2qfmXciTr3wSIP+1oEcdELhzfXNJvmxSeT9Vl2J4
	 d2cnP4f2W5OAzFBTT/GbD9CoQDkDAwKWyx4qc+Zkd5AQdvCfdpDH72lRjIRgPsZ4TdPYe
	 dPUFtbgBCjSsB52r2TIs5O/T9Q4STohLxPh3N5of01GChs2QMFMqcGe6SdBceTs6vUSET
	 nGp1ae+zoYtD9S9tnQLx/TtIuvpvM6lT9NhRQ0ykrEeuIJV7+E8VzTR/1Re6bgeNwhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yIq6S2me;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B70606A33E;
	Wed, 25 Nov 2026 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yIq6S2me
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974B71F000EB;
	Wed, 25 Nov 2026 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618777;
	bh=C7uCGei2RlQvDBnKozMiliPgxR6SEpCEBTOieWGKzAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIq6S2mefDWDRYPuN1NWi8Mb7J7BeZL7afdq8KgQ9TMPqOc6YI8QeppRWDBRgUjvR
	 qPzOJSTMwEZuIINLnfGDHHSlnUzW7zDbjX7BydZ2LUkeCmjgB9vNKs3lriMEA3maeZ
	 BIaqFmfPrOinoHV7bULyBXKNs4XbqSU/QEoLIrp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0386/1005] drm/xe/hwmon: Use shared pcode default timeout for power limit write
Date: Wed, 25 Nov 2026 15:28:44 +0100
Message-ID: <20261125143830.782825364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit 1a925ad51847db376fc0acd21fc5b76fb9c36cde ]

Drop the local PL_WRITE_MBX_TIMEOUT_MS macro and use the common
PCODE_DEFAULT_TIMEOUT_MS for the power limit write mailbox command.
This removes a duplicate timeout definition and keeps hwmon in sync with
the pcode default (now 10ms).

Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Link: https://patch.msgid.link/20260907083520.192418-3-karthik.poosa@intel.com
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 94099304b80e ("drm/xe/hwmon: Fix pcode power limit handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index de3f2aeffc3fb..08cec511806fa 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -101,11 +101,6 @@ enum sensor_attr_power {
 
 #define PWR_ATTR_TO_STR(attr)	(((attr) == hwmon_power_max) ? "PL1" : "PL2")
 
-/*
- * Timeout for power limit write mailbox command.
- */
-#define PL_WRITE_MBX_TIMEOUT_MS	(1)
-
 /* Index of memory controller in READ_THERMAL_DATA output */
 #define TEMP_INDEX_MCTRL	2
 
@@ -252,7 +247,7 @@ static int xe_hwmon_pcode_rmw_power_limit(const struct xe_hwmon *hwmon, u32 attr
 							     (channel == CHANNEL_CARD) ?
 							     WRITE_PSYSGPU_POWER_LIMIT :
 							     WRITE_PACKAGE_POWER_LIMIT, 0),
-							     val0, val1, PL_WRITE_MBX_TIMEOUT_MS);
+							     val0, val1, PCODE_DEFAULT_TIMEOUT_MS);
 	if (ret)
 		drm_dbg(&hwmon->xe->drm, "write failed ch %d val0 0x%08x, val1 0x%08x, ret %d\n",
 			channel, val0, val1, ret);
-- 
2.53.0



