Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441632033B;
	Thu, 18 Jan 2024 10:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575555; cv=none; b=qVXb6MvOM2PXdvC9B5YjbUeKS+5tI59+rqI8weWha6W68++g+zzFTDcZgPmNEKh/RyGwyqpzAbpVlJ81rRiyV00tjlr43mlmMg1fqDQFiurrlh8AAFVmIdbyJADD7Va9b7HLHsS6th/R6emKc8q6RzGleq42LsJpLDurJ6ZVHZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575555; c=relaxed/simple;
	bh=MYoZyVa4EOGmd9IwWzi/Eyp1ydi+r0MaQ14HTnfqFI8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=QNm7AW9NzURmxySuo6hEINbj7yCOJCYKFfMy0U5EF6aLR9SVrAKyq/LpeUvWY+9GAnGY71TXCf/+I3vuk/2wV/5Xk1aYqyPpXNP14EavJKLuIdEzQAVJcZ8/4vMs1sFyxKCamtV5cM5wzqUBOYgm7QzLpkz8q2N4vuRbPW008Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGQhG1ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGQhG1ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD03FC433C7;
	Thu, 18 Jan 2024 10:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575555;
	bh=MYoZyVa4EOGmd9IwWzi/Eyp1ydi+r0MaQ14HTnfqFI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGQhG1juNyZ+/vNR7ZfDe0E1wrxGx7LiTFbinOikawH6+aiKKqQOb6DsjHBqiTyfp
	 GKctXSvLrBbL64KELoMa/cXfTxtvMp1+4CRgBToatqvsW1dKpL4jdttP/lNc8StcVr
	 LYBwSUrCN+ZEYnamdSN4LISLx0RmrxmXqFvcrSuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/100] ASoC: cs43130: Fix the position of const qualifier
Date: Thu, 18 Jan 2024 11:48:31 +0100
Message-ID: <20240118104311.912113023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index db39abb2a31b..1fcbf2ffccff 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -1683,7 +1683,7 @@ static ssize_t hpload_dc_r_show(struct device *dev,
 	return cs43130_show_dc(dev, buf, HP_RIGHT);
 }
 
-static u16 const cs43130_ac_freq[CS43130_AC_FREQ] = {
+static const u16 cs43130_ac_freq[CS43130_AC_FREQ] = {
 	24,
 	43,
 	93,
@@ -2363,7 +2363,7 @@ static const struct regmap_config cs43130_regmap = {
 	.use_single_write	= true,
 };
 
-static u16 const cs43130_dc_threshold[CS43130_DC_THRESHOLD] = {
+static const u16 cs43130_dc_threshold[CS43130_DC_THRESHOLD] = {
 	50,
 	120,
 };
-- 
2.43.0



