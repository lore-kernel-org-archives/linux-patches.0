Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063135;
	b=R8m004uVNFXVd6oKoqYuwNZf6KJeDosbu9ClcgQD9hIq5jifGZZZEX750FMAA3y4cf7y
	 0I5Jvlryv/M5fjSs8mC1pcRvaucN1K6MqshXFJi58WGJhv8r1tD3gF0+tZQzrAjS1NY+Z
	 tOZda2ADO8H8rKflKX5h4dh0RS2kgdveKpcXj7TJcMTz6T0A6fnk58aQ782bHddadCBqf
	 4FJpf0TQwIefcTZB+bvuv5SLn80pQw4kuweaO0k/20Sd9gk+fe/GutIb/tUMxQvxwoWc+
	 vSTlimRi2Z5wJap46Ya3oGZmBQTm+ljkSF/KmYjgPRAKipPToQB/wQ5iUqcEsJKn6eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6huHyqFeIBKMvGDHzWGxho6A1r78PXkv6qo8rjIodcY=;
	b=PmwL4AtJ6gyN5td3kd7T6a1lS7w3/4su9vXFwgMqAitpRka2ZRCgT4TnAoHExpGqC8Eh
	 jSWpM/tE8ZxEIu2u1578xUk9WSmYTqrBg/RucfkiM45b951MJ43MInwyxJUjnc7XkhAIV
	 Y1q7uUYalWqY9hNgItwi473OfRVMUsn/sMwrW/Lcy52psGT3J5ikNCWKE/JJUfqihFDEn
	 5n+DDgpLp58jrrDE36diDtzWuEyAj/ygNo9XQDIc7f35niwIpKxXXDsDUFItBHkCgbTHc
	 fMWOaJa57MFd1Fl+g5Z6KYP8y8pqAWfywmRFc8WThgw4ywEOAZXeeLxOaYEgbK+p8UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nc1ga4no;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE77606D81B;
	Sat,  7 Nov 2026 14:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nc1ga4no
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9581F008A1;
	Sat,  7 Nov 2026 14:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063135;
	bh=6huHyqFeIBKMvGDHzWGxho6A1r78PXkv6qo8rjIodcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nc1ga4nowMlDNPB0syv9787YNNmwsl2PSpXw7mSI8ZT6Vc7cxvoQurgBiDNLPjvMl
	 X6thPz7bkTQxC3xBJCFE0E7D2KRAnhnW8umDHQpKAq4f6ezje7vixjo0+phFjfHd1R
	 XjYJ9y93pRCxc9QoQkT0THVRZPm96SIuwa1nZTd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 364/869] power: supply: ab8500_fg: Report sub-percent charge changes
Date: Sat,  7 Nov 2026 08:50:46 -0500
Message-ID: <20261107134904.985556412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index b122bd473c773..3b0a5bdd352b5 100644
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



