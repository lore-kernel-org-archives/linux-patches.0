Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934BF361648
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300927; cv=none; b=rVqTbIhryP0h8hgVs8rvtBGm+ycdH+4id7APSyy8LUEXxo++oJ/1M7byHJBHF5GUZu7zNbYeNn2jHGq+jmvJIc/Xuvy1neqY34lnqKIma/RV4V+uEOo/42bSSB7Ae0n4Lc2auRVZ1gmW+QV1p07w3GcZwV2K41iloF5jnLNJGs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300927; c=relaxed/simple;
	bh=ac4WStoxKfAasctsVBfwXUUhvWrA9GNM2xoK62d7wz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCSApQprw2oLthznYUWR9u2AYSKk9n+8XomXNrgFtwxPPLFUmtaWzTLKtUbLqOLrQI+LVdyZQEyg9KGAqEwD58wju8mywvuFJbOBw2Tbi6L3+o3OSsqiHteQetD32PQu1MBtcyRwk0uT2T8zNkjoOd6Sf5mWXYqttkCxmlh9I38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9LMuPeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9LMuPeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8A7C19423;
	Sat, 28 Feb 2026 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300927;
	bh=ac4WStoxKfAasctsVBfwXUUhvWrA9GNM2xoK62d7wz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9LMuPeHa8on7U1GpjMxIFa3QAqHKpnNVNibqJun0NKc79LQKUv+6CIdkvhgGrD+f
	 WA3Fvk97G+zuNWihxiJUK+LTg5m4iN5L8X4poKBCwoeANg4FIHdaF5d+/aLVrqCobw
	 4T+tkOuu9+tSXXT1OJgUptWoH0Sq3rOP8HdB+QPv6xmh8W1S7yFxq6X2J+dEUESsXx
	 dFwVY/JLm1csax7zHup50LCK9eRZ9sKu1jw11KrY+o5I3gBA/RQbaFDQiKArr/HZyw
	 U+bMQtSgfZ4NKUofqOt7LqQ2jMRuQfqruMdA9L8t/vDJofYjiLnEXyg268K4GZISe+
	 kyvavf30I4kew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Michal Simek <michal.simek@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/752] perf/arm-cmn: Support CMN-600AE
Date: Sat, 28 Feb 2026 12:35:57 -0500
Message-ID: <20260228174750.1542406-46-sashal@kernel.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 12a94953c37e834c3eabb839ce057094946fe67a ]

The functional safety features of CMN-600AE have little to no impact on
the PMU relative to the base CMN-600 design, so for simplicity we can
reasonably just treat it as the same thing. The only obvious difference
is that the revision numbers aren't aligned, so we may hide some aliases
for events which do actually exist, but those can still be specified via
the underlying "type,eventid" format so it's not too big a deal.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Tested-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 23245352a3fc0..651edd73bfcb1 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -210,6 +210,7 @@ enum cmn_model {
 enum cmn_part {
 	PART_CMN600 = 0x434,
 	PART_CMN650 = 0x436,
+	PART_CMN600AE = 0x438,
 	PART_CMN700 = 0x43c,
 	PART_CI700 = 0x43a,
 	PART_CMN_S3 = 0x43e,
@@ -2266,6 +2267,9 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 	reg = readq_relaxed(cfg_region + CMN_CFGM_PERIPH_ID_01);
 	part = FIELD_GET(CMN_CFGM_PID0_PART_0, reg);
 	part |= FIELD_GET(CMN_CFGM_PID1_PART_1, reg) << 8;
+	/* 600AE is close enough that it's not really worth more complexity */
+	if (part == PART_CMN600AE)
+		part = PART_CMN600;
 	if (cmn->part && cmn->part != part)
 		dev_warn(cmn->dev,
 			 "Firmware binding mismatch: expected part number 0x%x, found 0x%x\n",
-- 
2.51.0

