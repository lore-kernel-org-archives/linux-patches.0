Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035871;
	b=5UGdsTnvDnLr/SBBk8h770wyHlbr2I3yF+wooD94IJR9kqHaomrQdpBQs2KAB/Q8dM6/
	 5WwFACcqng94h15lUY1It3vb5FvzaqFGaawgVMXy4OI0ynYvFFm5tnaTkAncvWbNK4s9W
	 uAdajuMNiNdheiB/EMyjrrWevW1Do1sne0C85Rs585rcX6WNnB5jMeUu3R+Az2sE8+xQb
	 8Nc4c51H5K17PHI4YqBrEAl02oxurjeqmWu+JR8D0ZaEOnWkGwNzZe2hmHjnw2aLYr47T
	 7XPjLGgBNLHBFjVDr1HTZKpUgFgpVIyoX/Hztb8w6w/DvjoAbZ4LkEGqRkIAB5JyucA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LYCf6Zw6kBRL5EZijUbkFxOhUoJfLMK7DkM1Y/vv9xY=;
	b=BFDSLa5/X17kM+pPhawFAgU7UgLVCjQ7u7QPwH6sQhtdxaSHpb/qbRhkl9EkKqdMjaob
	 V3qdkg03OLXLjKt1ShgTwR0zRjv8Xj+/IUGo/HhMfYm9pA7Bb0TEy3H+NW/M8fHrgq+Gc
	 //HJo4HPGf1xfrcLuwfeO1XrKCckMJc0ARr56MpVdmHigiLiFvbu3/ElWRQH2c3InUl3l
	 ZmcasPC76+RDKyCUZybCURVOu7sBXXxqfXxd2jlVDJOfef40LFqFhtecdy7HJLpE77KLO
	 51Ar7cFRSDv8SGkj6DUWbDNiBOwQFpFTfDaQLB9Rux7IrEQ6hCp2ObAUmTqq4aRbVSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nj54LcnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9332C606A334;
	Wed, 18 Nov 2026 21:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nj54LcnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FB91F000C5;
	Wed, 18 Nov 2026 21:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035871;
	bh=LYCf6Zw6kBRL5EZijUbkFxOhUoJfLMK7DkM1Y/vv9xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nj54LcnP6jw8WrYsNa4KtRR5ncJEmIT6QymTj2EWoKOwAlrHSHw3ti4T7SKkunTcN
	 wzLdBE+q6B3KA+xw5sPQtQ5C8QVyD899PRllDRI1EBulzHr4oyU2YJUhVHYESxSFPu
	 3eIt8IgzoAXcXv0YPmSuDIs9B6UhBJymc/+Q7xnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0857/3318] power: supply: qcom_smbx: include base when petting watchdog
Date: Wed, 18 Nov 2026 15:24:39 +0100
Message-ID: <20261118150344.963117804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

From: Robin Snyders <robin@snyders.xyz>

[ Upstream commit 2f0dec12007891398e6e3041aca0b8656918973d ]

BARK_BITE_WDOG_PET is an offset from the charger peripheral base, but
the watchdog bark handler writes it as an absolute SPMI address. This can
write another PMIC peripheral and leave the charger watchdog unserviced.

Add the charger base, as all other qcom_smbx register accesses do.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Snyders <robin@snyders.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-qcom-smbx-fixes-v1-1-eb48246be599@snyders.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index 22c7c0e7c5228..90f99e1a16b3e 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -764,7 +764,7 @@ static irqreturn_t smb2_handle_wdog_bark(int irq, void *data)
 
 	power_supply_changed(chip->chg_psy);
 
-	rc = regmap_write(chip->regmap, BARK_BITE_WDOG_PET,
+	rc = regmap_write(chip->regmap, chip->base + BARK_BITE_WDOG_PET,
 			  BARK_BITE_WDOG_PET_BIT);
 	if (rc < 0)
 		dev_err(chip->dev, "Couldn't pet the dog rc=%d\n", rc);
-- 
2.53.0



