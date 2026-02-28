Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539F939B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302585; cv=none; b=olNRNqWgUd4wUQ/dqe86bWnYPFzkbI++8fD/xWYWAWOv9+csrMBkiYd/H6nz7FQ4EwYeH1BRtplIN1RNaf8wQDXSVYsT2NXcJ7v1d/JOivGTSgE5ME6HrruC+aqNwCZCBz1Wz4dHvq/Ccb6H1KUpx8vQ9Uk24KPc+nKcbQhrifc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302585; c=relaxed/simple;
	bh=Yw9hwJfULObXW3/YyR9XohzTc4Xmgi9rKcCJk5bhw5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGkso2W52MMiZdyuw8BpU4py+wJtYkUQXp/ZnKT/1+iJC2wUywV4/U1N01O7Qd7kGO6HLNNW9DujE4KbtC5bR5fr2C/nuh1e/S+2/wpkUa/WZdK4EfkiZHV6D4mH6kFNYbtp8kuYCjKucVuBv67OQ93RJKGykDTRb2NWYZXyr5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLrfPLxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLrfPLxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B697EC116D0;
	Sat, 28 Feb 2026 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302585;
	bh=Yw9hwJfULObXW3/YyR9XohzTc4Xmgi9rKcCJk5bhw5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLrfPLxNsSHzadRhgW08fMU8Mqr63vUtjSSeIpCFfawjSU7zBqSUzZMvIed6cV+Uf
	 0UAebTuAM1mNociuKjW+ciVDJN1SnceAfdMiabjFRj9toJvLN2Q1CEhTIlORoCSkv8
	 uM9tyUptw82ke83sRVw3j7XyNM6kAmmAMAZwtDP8EJZkb6L0jSvfhO2BataUymA8eJ
	 WAEyJvUSuKQ57aJgTB5Im3nPaQ3jaghsPqa0Zg1a8H60o+yZqwCQAwmwJdcFNzr+yO
	 Jaz9DXuMng6hNbK0GevRH8Jp8s5Re6KdDMc65M1rdJgo/l9ekGsvJRRtl1Ok3Dva+/
	 R3C5KO7e5juow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/164] power: supply: ab8500_bmdata: Use standard phandle
Date: Sat, 28 Feb 2026 13:13:53 -0500
Message-ID: <20260228181505.1600663-94-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 1a6784359540dcfbf4fa73c07868b80c8405cc14 ]

Look up the battery using the "monitored-battery" phandle
as is nowadays a standard DT binding. The actual bindings
for these charger elements are not upstream so let's sort
out this mess by conforming to the standard.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: c4af8a98bb52 ("power: supply: ab8500: Fix use-after-free in power_supply_changed()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_bmdata.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/power/supply/ab8500_bmdata.c b/drivers/power/supply/ab8500_bmdata.c
index 6f5fb794042ce..bfc1245d79123 100644
--- a/drivers/power/supply/ab8500_bmdata.c
+++ b/drivers/power/supply/ab8500_bmdata.c
@@ -497,8 +497,7 @@ int ab8500_bm_of_probe(struct device *dev,
 	const char *btech;
 	int i;
 
-	/* get phandle to 'battery-info' node */
-	battery_node = of_parse_phandle(np, "battery", 0);
+	battery_node = of_parse_phandle(np, "monitored-battery", 0);
 	if (!battery_node) {
 		dev_err(dev, "battery node or reference missing\n");
 		return -EINVAL;
-- 
2.51.0

