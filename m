Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468113783B0;
	Sat, 12 Sep 2026 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231415; cv=none; b=dnYPOBPCe3/xhkTXNXurYgajemZ0q+k61EKvR06ZnAbIePzFM4WQgA2I01PJCrVHSEFkRaJUMSLoD3LTXCsgPrfZQ2X2ahgxLxBX9mhUBiUBnM0ZatANKyMs5wVBv65Cr+DRGY18oyumRjqFX6WwB6mLpDScBpJyfpK2SBeWlxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231415; c=relaxed/simple;
	bh=WMDsqyuoWdzN/MtyMXfWOBRkQWUW2aVD4FtuZLz89go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdA0YwwR0DN5p4SuMdqNKnYuoRUog3q97o+jtcM6PyoR909a/D2Db29SDjSyzrF2CcN9pJcPIumMyEkoudrEeyr5bpBFjc2Rwb06jx8jBbS4dakSVH2VSM0lZ+a4FI6kyNK+modhp+wJB9buMXcoS8pn4oHtuhBH1RQk2Nu2JEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXrrcW3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXrrcW3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1982C1F000FF;
	Sat, 12 Sep 2026 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231414;
	bh=uOVCvVQ88lcLZ+1ue7/c07iNmWXo9u/R9XhtZuwOeNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXrrcW3nQ+4PPUDMLKCg3Pw3sxQNlNeGuUpaca1epQ13jDLVmbVkozZ82DTSAw6KZ
	 Tu6Ek0OiDgFiearPUn13skMm2N1odu1G1lNQum05k2laAXJux1vpwOrfLet1F5Y9Rx
	 7MtLFzxF1kcfrnGlSwIR0HcKSu4d2qDrlbxgE9fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0994/1191] power: supply: bq27xxx: bq27520g4: fix REG_TTES address
Date: Sat, 12 Sep 2026 09:02:02 +0200
Message-ID: <20260912065610.528939275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit c774a623c821a173c950e1297f8e8c85a89455be ]

According to the technical reference manual the StandbyTimeToEmpty
(TTES) register is at 0x1a, not 0x1c. At 0x1c StateOfHealth instead
resides.

Fixes: 8835cae5f2ab ("power: supply: bq27xxx: adds specific support for bq27520-g4 revision.")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-3-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index f973b25c7bf3d..c0e28c841293e 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -324,7 +324,7 @@ static u8
 		[BQ27XXX_REG_FLAGS] = 0x0a,
 		[BQ27XXX_REG_TTE] = 0x16,
 		[BQ27XXX_REG_TTF] = INVALID_REG_ADDR,
-		[BQ27XXX_REG_TTES] = 0x1c,
+		[BQ27XXX_REG_TTES] = 0x1a,
 		[BQ27XXX_REG_TTECP] = INVALID_REG_ADDR,
 		[BQ27XXX_REG_NAC] = 0x0c,
 		[BQ27XXX_REG_RC] = 0x10,
-- 
2.53.0



