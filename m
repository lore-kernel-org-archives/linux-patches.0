Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77C313AA52;
	Tue, 23 Jan 2024 00:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968131; cv=none; b=eXiom5pf1g9q/JRnN+BpB/Q1WljNkC+V8aj6XoxwHOIGiilb7J9NdvF5evfhsWbeJQ7tXE2M/mdD8jNLOcW5hUViiCUYDjpDVKR5H1prHBon6rLxpsTLtRcLnZ93Ol6ppl/C2NV4d4+D9cm6gl7MgnqpdauK0PlYnQF7TwX/Dp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968131; c=relaxed/simple;
	bh=H5hxi/9iN32AWmr2tGuibiDNemnd5MesdfXUDGE+xH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT7FUIcOpomX4POgb4JAQg0rYG4n4hoFw6/Z9KXaDslliymRzrC+bkoxa29iocMODz0V8CSAxbceIsNL6H3Wdp38d2QQXq+vy2ae8VGfjjPDD98TnZ5B5CAWCs5njaA8UOjeXg86NR0zlyQROwuazK1xYJZxO3kWwx07hxaxi+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWU7XBI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWU7XBI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2642EC433F1;
	Tue, 23 Jan 2024 00:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968131;
	bh=H5hxi/9iN32AWmr2tGuibiDNemnd5MesdfXUDGE+xH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWU7XBI7c9RNWANspiFho27vcTi3xQ9a7utxd/RPUcQg2qoQ6b31Mo+uDFo+4ShQp
	 IQOi9l8CYq65JEHvFd2ooJuu/hmbGbds5N3jTvWztJZUuvKrDSsLhgSrzGGndyz3kp
	 tHQ1bqV2v6JbZ6JBk/KZttTNTP8nx001w6djGSrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/148] ASoC: cs43130: Fix the position of const qualifier
Date: Mon, 22 Jan 2024 15:55:59 -0800
Message-ID: <20240122235712.576993559@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index cf29dec28b5e..95060ae7dbb4 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -1686,7 +1686,7 @@ static ssize_t cs43130_show_dc_r(struct device *dev,
 	return cs43130_show_dc(dev, buf, HP_RIGHT);
 }
 
-static u16 const cs43130_ac_freq[CS43130_AC_FREQ] = {
+static const u16 cs43130_ac_freq[CS43130_AC_FREQ] = {
 	24,
 	43,
 	93,
@@ -2365,7 +2365,7 @@ static const struct regmap_config cs43130_regmap = {
 	.use_single_rw		= true, /* needed for regcache_sync */
 };
 
-static u16 const cs43130_dc_threshold[CS43130_DC_THRESHOLD] = {
+static const u16 cs43130_dc_threshold[CS43130_DC_THRESHOLD] = {
 	50,
 	120,
 };
-- 
2.43.0



