Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417BC1272AB;
	Tue, 23 Jan 2024 00:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970760; cv=none; b=C4HzeQ2NC0bDYjrTFD1HoeTLFCv8GHyegpOpIPLxHMTJAOEf55CotS75Swd5ImwBqbCcfZJoP8Vcd9pbzfPJ+uhSQ7tyPB5Deg2Y1OVxKZIt8ZNcGhWuxBiLHLcWynkoy9n8uq5jc6u7FogB7CM+U1m0WJZlV6CZ/9PJP5QoLt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970760; c=relaxed/simple;
	bh=rn45UU08KQ/o5O1JThDKVndVWfrSaG0WMY7pYIe7P60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO9FPLVQzEjTvRagfol1QoQQ62010D5i2YIDFry5IiDa+7R9FFckMzezf5Ref3vZ8khpM6UBxYD4UgPXsuPPFjxHKDidGFYfN40mXeq1IbH/dSjUKOUGcJ5iUPINgkyc0hx5/Tr+hOScMuzkFoY1b3Mb2FsAwOECEvAE5UjQ4TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpiyPgvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpiyPgvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D509C433B2;
	Tue, 23 Jan 2024 00:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970759;
	bh=rn45UU08KQ/o5O1JThDKVndVWfrSaG0WMY7pYIe7P60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpiyPgvSqxWMoyVTkFMraLS9WQ+bpFBSPR/9BbMPLQSvGbv41H3eoAP4DMLJBljiA
	 Gj4wx5vDiAGFXEWn/VgF6v3vGr7fKZGZzww5/qP+xCWgbSK+laiCe29a0V3NStgeYj
	 kwWcCg3MlPte2uSUlX2GmMUfozF4hSekXtcyF9+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/286] ASoC: cs43130: Fix the position of const qualifier
Date: Mon, 22 Jan 2024 15:55:18 -0800
Message-ID: <20240122235732.488782450@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit e7f289a59e76a5890a57bc27b198f69f175f75d9 ]

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231117141344.64320-2-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs43130.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c
index 8f70dee95878..285806868c40 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -1683,7 +1683,7 @@ static ssize_t cs43130_show_dc_r(struct device *dev,
 	return cs43130_show_dc(dev, buf, HP_RIGHT);
 }
 
-static u16 const cs43130_ac_freq[CS43130_AC_FREQ] = {
+static const u16 cs43130_ac_freq[CS43130_AC_FREQ] = {
 	24,
 	43,
 	93,
@@ -2364,7 +2364,7 @@ static const struct regmap_config cs43130_regmap = {
 	.use_single_write	= true,
 };
 
-static u16 const cs43130_dc_threshold[CS43130_DC_THRESHOLD] = {
+static const u16 cs43130_dc_threshold[CS43130_DC_THRESHOLD] = {
 	50,
 	120,
 };
-- 
2.43.0



