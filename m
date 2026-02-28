Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD4F421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301161; cv=none; b=lYnAYyTP3p4L8K9QAKpskUBHLvNMeYNHA2xnEvxqBvVvyBLCtkhMcxeuoIGGlAiPeUzAyeWQr9UakQRg2WqRnwHxL6DCeJNo/G1v8rBH9D1EK/lZuo/YIlYOdbrjXKaeyfEO85U/pqbmX0+pb5it3IDMK/YXxa8P4V32Mcw6Yno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301161; c=relaxed/simple;
	bh=0KWI7mRy87m/nS0+mW6q0c2VaGXP+MWdnuyz1U6iQD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhBiROmN+rAhPgfC/UjB4kgx3iYsDX1RtRF6ScBu3BHEyy+YARySIfsrzy/zWsc2P1cN/X2NNdllulb62IV3QIV80j37ek+03sdo+iPnkvRKqRIjMuzOwDwi/vKmmPQiHqdWc0Z1sqXdg6FRqc5I7jfm8+zj5IOwQHtNVBuFWuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ecf9m6Xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ecf9m6Xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DD8C19424;
	Sat, 28 Feb 2026 17:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301160;
	bh=0KWI7mRy87m/nS0+mW6q0c2VaGXP+MWdnuyz1U6iQD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ecf9m6XrnCrGle5vlVGX8Ic67DDS/HHtGrTv5FtJbeUOQ0ZI3eQZWLz53n8CylIwV
	 rbTX+xMYk3Zf+twVXcIXAZF3q9k+CEhfr14Z2up4l0MXZ4y0EG/i/IBA4+92R305IO
	 ILTqS/4/L8t2m4yXBikU2ukthg2/dhD541R99r9NJKoApsqYusHeUucLu1UW0hjzyx
	 R1LYLYgq3LQrx4/VbE1nI6NVEHf2K8d1cJTLf7Nsea6BryEVsumasNmNESYYIY9p6q
	 jTs/V5HKfMN9QOEMgC9BaMF+FJbSkooCaKfS35BmWJOanVOX3SiCdnsZPaV0SezKDd
	 SyycCCnKB0dTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 325/752] soundwire: intel_auxdevice: add cs42l45 codec to wake_capable_list
Date: Sat, 28 Feb 2026 12:40:36 -0500
Message-ID: <20260228174750.1542406-325-sashal@kernel.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit f87e5575a6bd1925cd55f500b61b661724372e5f ]

Add cs42l45 to the wake_capable_list because it can generate jack events
whilst the bus is stopped.

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251215151729.3911077-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_auxdevice.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 6df2601fff909..8752b0e3ce74c 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -52,6 +52,7 @@ struct wake_capable_part {
 
 static struct wake_capable_part wake_capable_list[] = {
 	{0x01fa, 0x4243},
+	{0x01fa, 0x4245},
 	{0x025d, 0x5682},
 	{0x025d, 0x700},
 	{0x025d, 0x711},
-- 
2.51.0

