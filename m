Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052489;
	b=aUNJZhRWMVPzncoEQ3NVNwjWnIknl5vTx+b3Kyb9X7pUcKSChB+I7QnsF8jskCGHxcWE
	 g/OaInZxl0DY8ZR0ru/lcJcBgIu9Yy1iT5hGz7qNSq9SYvDlqgkgU2AoJzWb5B74Bq9xU
	 0Fp29dG2m5qSv4mKAI3paHq1TxXYga9EhWLnP6i7ixVXqFuOcSWor0E+KLHohHl6R7h5/
	 kKiUxuY0+N+bLLySbsR7y+mKfKU/27C8VzWs1l+JKXUOmKkktbBXVdaZa6ulUqfM0k/aX
	 /HBzXy0lU9EXNprSZ0ggZVwoHOg5ou/Zd2euJCVURauh7D4tTIizwrzKF4Afsjzk2bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IeqsGpbtnbzSNVJ8wUvrzc8ZjB9NSZHEGyxyiGyUvzs=;
	b=NS0BLFzEqVci9CzWbW7+rZiz2fLZ9t+3jaY6Z7Vwops5x/yziysOdC5BDOA6GiaI1ndT
	 fWilLx4PjdVcO9CA3z27MV+UDwHmQjCBkbszS4MzipQSKQecW2iJmmkETBeZ6R7gw9wYo
	 pJr7DOH4auYptrBtJzAc3UXg9SopH1Xv0apE+ZdWiA6izmMhgYYhJwDQKboAaFLl28n6Y
	 Aptz56eVvgA5gTDkbDwSyiPOsK/r2xQH2PS9OO+5DKOp7mD/Zush5YGIkKQtT0u+Ec5BE
	 R7dia6vsBOBzNgSTFSW4trVMFKx9qX9FNBW6oNS5IfftjkBE9gtDKf08SLClHABacPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l9PhT7KR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03890606A320;
	Thu, 19 Nov 2026 01:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l9PhT7KR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5A11F000C4;
	Thu, 19 Nov 2026 01:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052488;
	bh=IeqsGpbtnbzSNVJ8wUvrzc8ZjB9NSZHEGyxyiGyUvzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9PhT7KRKdb8YpgBtvc89kLRjssvSIpweUdV1hdGXcLC5862KZyeZoSFMyL1Jp1X+
	 sQoSaF0dX/prj6R/tAPkOYanSdh4YVUTLVaOiWLt/yF3lqBtiGLempplaB28lqbtuA
	 lyDj/7/7S+V131qTfruYRdeY1rA3QywdBfPI9KCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0575/2214] power: supply: ab8500_fg: Report sub-percent charge changes
Date: Wed, 18 Nov 2026 15:37:31 +0100
Message-ID: <20261118150033.953774630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eb7eac23da70f..61235937426d2 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -1374,6 +1374,13 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
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



