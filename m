Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5200136A37A;
	Thu, 20 Aug 2026 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238610; cv=none; b=YR5X4LmifWMhmno1gLJt8naiitLE5OPOScJa0jJjDlpqyZ+K4ZUmA6z4HKWD4UUkyPesdQ2Qs9MUhEU3LeFihPkfV2pb1G6NWFYOTXK++yNP4KIkOmHD68WUBISwyen5/JnnDEDwtWGxb6B+CJvMRhzYJ4ePQ28TnOVZLppPx3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238610; c=relaxed/simple;
	bh=LdMWlLFcbFH70h3/bVFrVKSIUyPhx0FU9CAWXm/sTd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGoLEOVw2ut2JPxJKB1pAffsDdsQqa4NkN9b8JnrO1wjsjkNcOdkXqmWgqnUOIZWbznT0uPPHWQi4O1M6bU6YPhWlwStM87CcMKgkToyTiqCSSxD9BpjKXR8kgn/RvEkBUIzPD11hox9tVy4+0DunV8wmtFhoMFBpKrSbEkixG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+HE5FOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+HE5FOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB501F000E9;
	Thu, 20 Aug 2026 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238609;
	bh=b69sFRAVF41QAiFt8JMwCBdg7lT+yDdgRwQXnJr5Soc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+HE5FOrQA7XtrQ3sunt2ahTcekv6+Y0aVLm5AUPGLE3fASr2j0GqOOSW5urDZmVB
	 LSYBB9yZgcUdwMaBv7rY41AHi+aDATHfS+iA61v4TOry1yrJr1Nfe0IDjmkD26lYMy
	 tzjjnzcKbdKdJkc2E/URLLDDe8MZZQyIHIF9Y7P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Saarinen <wiza@saarinenkoti.fi>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 207/228] regmap: sdw-mbq: Fix swap of timeout and retry times
Date: Thu, 20 Aug 2026 16:55:49 +0200
Message-ID: <20260820145251.321583083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ae7fd6ff4c6713270d2efe6db87a4a58ccb7cc61 ]

When polling Function Busy using read_poll_timeout() the total timeout
and retry delay arguments are swapped. This leads to only a single retry
being processed, it seems the existing users typically do succeed before
the first retry.

Swap the arguments over to ensure the correct polling time.

Reported-by: Ville Saarinen <wiza@saarinenkoti.fi>
Link: https://lore.kernel.org/linux-sound/ansTPGgVNoDJlA5r@opensource.cirrus.com/T/#m680731a2f307f1f5176b27ed5aa560ddc94e5d62
Fixes: 5bc493bf0c37 ("regmap: sdw-mbq: Add support for SDCA deferred controls")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260811131816.332082-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-sdw-mbq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-sdw-mbq.c b/drivers/base/regmap/regmap-sdw-mbq.c
index 2585933d4946b..6d7c760cbef2b 100644
--- a/drivers/base/regmap/regmap-sdw-mbq.c
+++ b/drivers/base/regmap/regmap-sdw-mbq.c
@@ -59,7 +59,7 @@ static int regmap_sdw_mbq_poll_busy(struct sdw_slave *slave, unsigned int reg,
 	if (ctx->readable_reg(dev, reg)) {
 		ret = read_poll_timeout(sdw_read_no_pm, val,
 					val < 0 || !(val & SDCA_CTL_ENTITY_0_FUNCTION_BUSY),
-					ctx->cfg.timeout_us, ctx->cfg.retry_us,
+					ctx->cfg.retry_us, ctx->cfg.timeout_us,
 					false, slave, reg);
 		if (val < 0)
 			return val;
-- 
2.53.0



