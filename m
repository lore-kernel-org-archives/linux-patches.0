Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045314;
	b=Z0jJLwtjyMC9O8dF9p3fwJbQirD6VdtCsdyCfrE5Ynblqi6TUINxMMTNNYNPNqSCIuY5
	 110rLI8JXQJVUAQKDgsIphJKkS/r+vGujc5b7jDsym0USW0Cyg5L46DJmtH9TNG6uu4aC
	 j5GZTV2CuJw3rPeFCNRZ3Qdr+qYD+Af1j6LFlMjg1+cWbE3nnoEKQ3N9S4W+7VqzpLD8a
	 /9FBCYkUbGXvu/2ktrApex5iJPqjT5KH2p+vhOuqFUXZpjjCGw7RLOXuQazpNiGfXyMRD
	 34gjibMpNQMXot59mXrzvuqZzobTJygZZR/mg89LfBQxEs882OxM25FJ40YNjL51qDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YAN/EFxDqcTB7VxEdqmxI5TdhoZj4N0NspIVRKPcGlk=;
	b=iez12rY+wNiWY99n0rF2Qah/IvicpLuYqHagx5H0DhajTRSes/Xb4O0qlHyW1UtHNzPk
	 lOSWAI3gSaT+NFTkhA/qYsPMz1TZC4tcrSwhngxkf048PgyMe+MNWt24CV+YpuPOxIP23
	 oFfFTzFjKBrAWlTmdfYK9kBlr7svauMisewl+90gLX350FPEJjegG1hEf2Sn7goUWW68I
	 0+UENHjDuvedKIq7XWF4sX4oXF5l3ue9s7rrsrG2B+BSyGPDB6cu/7Gk8zVny+YK+8H6y
	 NFoO1gYY3O4UsPQJLpgRKd4IfP1BhbtIryp29b21NMN7FQ/xB79WrgrFKnRU4BzaVnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fIoFcAeZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86489606A32A;
	Wed, 18 Nov 2026 23:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fIoFcAeZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1281F000C4;
	Wed, 18 Nov 2026 23:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045314;
	bh=YAN/EFxDqcTB7VxEdqmxI5TdhoZj4N0NspIVRKPcGlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIoFcAeZ2Iwfvlarvp68SHck1GqzqhQdDiCkr7zSWXaiK3zh3BLs3d7GsPWnV1hV6
	 R8fDwtk+kJCKfuh+MzGPJQRDdZlZaz4U19du8DgkHxMo7Ryo4qk1o6gMwTP9JDckrB
	 34i5rSYdCrmGquWmDvPxL1YK6eJYNVZsvYJTqL5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0877/2857] power: supply: ab8500_fg: Report sub-percent charge changes
Date: Wed, 18 Nov 2026 15:31:51 +0100
Message-ID: <20261118150233.141887885@linuxfoundation.org>
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
index 327c7a9f31ece..766e5cfad4eb0 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -1392,6 +1392,13 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
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



