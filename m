Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9AD377A9F;
	Sat, 12 Sep 2026 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231430; cv=none; b=bx09ZNhj+NdaYwD2eRzI0nXZ84mOehcs2FL0BNFyi+Wu6sjKQYsAYfti1sz3ipQcWZPdknQGiYuxJTZoMkHsJV2fTXtAuC8PGOFqOxbS4W7iQ71EIv3TLXgOpVRa41fIF9Bs7NYcLaCBK5lwNn9PJHBq6KeBWv6l1RmzmEX+E0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231430; c=relaxed/simple;
	bh=pceAvj8lZRSkAKPIdkt9f2FhsfG7HCDYICoY4Te/IFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlAAO20r1Zou8ODXQH4w3XOmJWwwKQDuv0p0Hx1P3fBvc09abZtB4Oa8N9sCkYgS13B9+6n15DxkBkovHKRPVwWzlnhANXvPn/GB11jcJBCgV0A0a1TSL1RtFcEUS0DQWYXqwtJwShuVbCVLtnITM3F0qsb1W/Scm5rcC3XnD3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpxQH/73; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpxQH/73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710421F000FF;
	Sat, 12 Sep 2026 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231429;
	bh=Oue1xI19ZhNQCHwyZ3HLJbi1+hi0u+MMYXkBTe/BKS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpxQH/73aj3gTSlmlKo/92wmTDPr2xLJxJYBVxBp/JCNDuMw1/cJozuLQcPae6Fmb
	 RNjeB69f271uujW+u9sU6lMb7I9WRJxWW1hJIKCQsxvEJ/WKNiU6+C1m706lGA7A5W
	 /sq0mQ3YXcUAprnULawnPpXMUq+O9uDTQvIykVJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0996/1191] power: supply: bq27xxx: bq27z561: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 09:02:04 +0200
Message-ID: <20260912065610.571127340@linuxfoundation.org>
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

[ Upstream commit 2da28b059e0ddcd2e1956eeae383246207965573 ]

bq27z561 currently uses the AveragePower reg, 0x22, for reading both
AveragePower and AvailableEnergy. The technical reference manual does
not mention AvailableEnergy, and it does not make sense to read a
cumulative, always positive, property like AvailableEnergy from a rate
property like AveragePower. Set REG_AE as invalid to fix it.

Fixes: 6f24ff97e323 ("power: supply: bq27xxx_battery: Add the BQ27Z561 Battery monitor")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-5-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 6b1c07c9cd4cc..a818b002af21d 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -489,7 +489,7 @@ static u8
 		[BQ27XXX_REG_RC] = 0x10,
 		[BQ27XXX_REG_FCC] = 0x12,
 		[BQ27XXX_REG_CYCT] = 0x2a,
-		[BQ27XXX_REG_AE] = 0x22,
+		[BQ27XXX_REG_AE] = INVALID_REG_ADDR,
 		[BQ27XXX_REG_SOC] = 0x2c,
 		[BQ27XXX_REG_DCAP] = 0x3c,
 		[BQ27XXX_REG_AP] = 0x22,
-- 
2.53.0



