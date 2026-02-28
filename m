Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A382D4A33EE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300988; cv=none; b=k+T2BJiZRHNKfs97ff6QvzfY2epOya1g1NFEVkdnbo6pU5DDGB+IK0QK9aD9YHtWHTr7GkE2OR0a5uG+IK922c4WdEEJqb3dMwhRiyum5rProsDrCiHOpEB8+p2e9yuHUTk/XBDlCNzywMV2/aXyOXl7VNnNM1bJYB8cP2nX534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300988; c=relaxed/simple;
	bh=T24sbfWGzVfFg6wJl20rdCtqhvxSC8yU6Rmmv6GX75I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlfdShR4FhQpn9rqhUM5Vry11BuVZ6tVsfkt9hmiddUgFGv8uAvVpL8Vz7CJtQjW2noW82xdZuqMR5vS2Pra4zflzDGFWefVgipBcP6lrszqdBomOcvf8xWHPFNwSLeChetEMS9Bmtyhf5h6u/cayR6JLQN2LrJHRh7pi1N/BU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEcOku92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEcOku92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7983C19424;
	Sat, 28 Feb 2026 17:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300988;
	bh=T24sbfWGzVfFg6wJl20rdCtqhvxSC8yU6Rmmv6GX75I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEcOku92hxQOXlgvcozjWCDzsKhB3Tu4amgwq+Goo5qFkoggpSPOR04OXKjILuIcu
	 okx/Yf5P3GY9qNEa0CYl2K3noAOAYemSDnWyoDT7mlFe4/SLXh8s3Asy0c80WCkIx9
	 41WQnAxJVQEuKs+B+UKTuyz2o+I4QW/IyS0n7+YJS9CS0Q42522SxCIVjRAMsYDcD0
	 mpNofvc1Zj/gjhkEDRyWGU2fkcQb9GxFswk1LX4EKgr3h7P9uYC4bZbMLowTX4eEEt
	 Doeq5RwTrxFoIQHex5rbIN3PS61Lh/oNshfWO9/pRLMkP5fCCTfXyEiYMRLF/VECpm
	 It0zcgTcdJG0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Val Packett <val@packett.cool>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/752] drm/panel-edp: Add AUO B140QAX01.H panel
Date: Sat, 28 Feb 2026 12:37:09 -0500
Message-ID: <20260228174750.1542406-118-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Val Packett <val@packett.cool>

[ Upstream commit bcd752c706c357229185a330ab450b86236d9031 ]

A 14-inch 2560x1600 60Hz matte touch panel, found on a Dell Latitude 7455
laptop (second-source with BOE NE14QDM), according to online sources it's
also found on the Latitude 7440 and some ASUS models.

Raw EDID dump:

00 ff ff ff ff ff ff 00 06 af a4 0b 00 00 00 00
00 20 01 04 a5 1e 13 78 03 ad f5 a8 54 47 9c 24
0e 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 f0 68 00 a0 a0 40 2e 60 30 20
35 00 2d bc 10 00 00 1a f3 53 00 a0 a0 40 2e 60
30 20 35 00 2d bc 10 00 00 1a 00 00 00 fe 00 36
39 52 31 57 80 42 31 34 30 51 41 58 00 00 00 00
00 02 41 21 a8 00 01 00 00 1a 41 0a 20 20 00 a1

Don't have datasheet access, but the same timing as for other panels from
the same manufacturer works fine.

Signed-off-by: Val Packett <val@packett.cool>
[dianders: Moved to the right location in the table]
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20251206173739.2222940-1-val@packett.cool
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index aad5838cd700a..6a8a4ebc91e21 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1880,6 +1880,7 @@ static const struct panel_delay delay_80_500_e50_d50 = {
  */
 static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x04a4, &delay_200_500_e50, "B122UAN01.0"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x0ba4, &delay_200_500_e50, "B140QAX01.H"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x105c, &delay_200_500_e50, "B116XTN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1062, &delay_200_500_e50, "B120XAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x125c, &delay_200_500_e50, "Unknown"),
-- 
2.51.0

