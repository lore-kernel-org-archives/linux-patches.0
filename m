Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7C51420A4;
	Tue, 23 Jan 2024 01:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972069; cv=none; b=QOoL9eQ5+yCjcvD+iD6SDAKirlRpWMaHvh4RMICtNrr7lzyp4IVt5Tx43YlGdxqqqRO0O/T/eWcwmNs1OM4WeOdjA4oDRWoNS2LAb2C6RciRkKqUHHMYari0IXLCHk4ydGrxegV/0t9lYY0RwenLD1sfY41V7FKn3El5j+V9G7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972069; c=relaxed/simple;
	bh=anUum66owtidInTb19MICf4Ikak9/IkfqEhtKvFo+ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N75LPsBBhTLk4yif6YehfbDTArtnKOFMXJkwJePAIIP6CtdYgkXgWNAxwG7mmeMD+/AYYD/bh/1YjZXddoUGmVEruiGmwh0kU4PuPhh9WP+G375FNZpcDUsb4d9qJSwZQEu9a+UdVehfo9Ib3a7+yXYGpZzSvJTfTR6C2rysJx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9AXdXI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9AXdXI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43186C43394;
	Tue, 23 Jan 2024 01:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972069;
	bh=anUum66owtidInTb19MICf4Ikak9/IkfqEhtKvFo+ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9AXdXI0TqwCccawzQTB0HzHtHGrjEymjYzxYI1493TrOFDEE4Hghm/qRySjO86Rf
	 ltqI7tlR9ZLeb6crvtj2GOWG5tEKNrCeTFMFMB7zuGbdWipD462KM5BQLzgSkarHdh
	 ORr8Bwylww4iogjLj/kEX7N7nXlbbFTppzc8dXqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/374] ASoC: cs43130: Fix the position of const qualifier
Date: Mon, 22 Jan 2024 15:54:29 -0800
Message-ID: <20240122235745.084197995@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 44b20c1ef851..0e2cb54ae192 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -1684,7 +1684,7 @@ static ssize_t hpload_dc_r_show(struct device *dev,
 	return cs43130_show_dc(dev, buf, HP_RIGHT);
 }
 
-static u16 const cs43130_ac_freq[CS43130_AC_FREQ] = {
+static const u16 cs43130_ac_freq[CS43130_AC_FREQ] = {
 	24,
 	43,
 	93,
@@ -2365,7 +2365,7 @@ static const struct regmap_config cs43130_regmap = {
 	.use_single_write	= true,
 };
 
-static u16 const cs43130_dc_threshold[CS43130_DC_THRESHOLD] = {
+static const u16 cs43130_dc_threshold[CS43130_DC_THRESHOLD] = {
 	50,
 	120,
 };
-- 
2.43.0



