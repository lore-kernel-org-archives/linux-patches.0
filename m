Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E6628B4FD;
	Wed, 25 Feb 2026 01:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983946; cv=none; b=Us/0od1e6+u5fzi54H+omqcEqNlMGr98xcibqTTaPRaj5a7XRO98t4ZPqlqU/3fO4PnsLIN4aiST7uRFrneb9JdKHJcJRf1GFj61P9w8NRD7o80hFb5v7pr8IX0fLTlvkZoZIzUO0M8/XJDOHWyfjhcrrmqDFF/pnx7SsRJ2ecg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983946; c=relaxed/simple;
	bh=UOIwvfSlFhX3+hdsBbl0HW8J6qmM8YhYG2LQEStEY4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQ4Doz8C4qYJFRE6M5DJKTZw5RiQIzBjpIY39mTgkWLjROo7D2TZpK7+AdexAV262H25MwPkyOyB42rUZa8zNZNeXC8OfTxe59oPz6wqJzn7TZgN4ogTY+2UKmP7DIYXEUDILbSrocfTZdQn++feMMk0ExaaLDxhc93a4A6pBK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9MaWz0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9MaWz0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1564C116D0;
	Wed, 25 Feb 2026 01:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983946;
	bh=UOIwvfSlFhX3+hdsBbl0HW8J6qmM8YhYG2LQEStEY4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9MaWz0/zleVnvMYzVvy+uDt0PAqiIPz4bQvoJHv4cixY1ZlLfIZ04RRArr97ruhi
	 Nnsdo0c9/iAOAVVKl38uosKrTfkaOEnxDxtEhMW4kTdiLyitOZGhp4I/TlFNZNE+re
	 D8d9pqY+fVZKnf04v1cVNbqdJio2j0Otw3QH6Iug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 182/641] ASoC: SDCA: Allow sample width wild cards in set_usage()
Date: Tue, 24 Feb 2026 17:18:28 -0800
Message-ID: <20260225012353.431555808@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 87783532d34050e2bff6749a4fe9860e624a0540 ]

The SDCA spec allows the sample rate and width to be wild cards, but the
current implementation of set_usage() only checked for a wild card of
the sample rate.

Fixes: 4ed357f72a0e ("ASoC: SDCA: Add hw_params() helper function")
Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251216142204.183958-1-simont@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_asoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_asoc.c b/sound/soc/sdca/sdca_asoc.c
index 892b7c028faea..7e986870d48c5 100644
--- a/sound/soc/sdca/sdca_asoc.c
+++ b/sound/soc/sdca/sdca_asoc.c
@@ -1519,7 +1519,7 @@ static int set_usage(struct device *dev, struct regmap *regmap,
 		unsigned int rate = sdca_range(range, SDCA_USAGE_SAMPLE_RATE, i);
 		unsigned int width = sdca_range(range, SDCA_USAGE_SAMPLE_WIDTH, i);
 
-		if ((!rate || rate == target_rate) && width == target_width) {
+		if ((!rate || rate == target_rate) && (!width || width == target_width)) {
 			unsigned int usage = sdca_range(range, SDCA_USAGE_NUMBER, i);
 			unsigned int reg = SDW_SDCA_CTL(function->desc->adr,
 							entity->id, sel, 0);
-- 
2.51.0



