Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3721F12A15E;
	Tue, 23 Jan 2024 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968754; cv=none; b=jfHrzto2lEIY6zS4U9UHUcJeLs7W3B1ZdS0hTD2ZAebBz+YchPLg9pjCVOSy1J4r8W+9QzeUAvyBYwcp0qB8xvD8bChibmB0qlgzWs6i+lV9sGb5AFnznuWE9R0hr77RlP0OCG6C/MCYkZ8MIJgwrepfw8MEzy5szEyKrJSGnQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968754; c=relaxed/simple;
	bh=LO03A/IDFe6T3MzK/wSsOEJmfC5dZr2TQTkAmCuja04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kncn7BdKGfUWFtlNE44j+JyaBCvVkW1qFll89cdby36BjTBkpt+D5X6XyQTWRgTdbWzp63ztiYGSxVJ3SO5LQngw3syI9YMseRiz/doZj4OhincRaFYa71quWhLLju/4XMVVp/FAq911qfvpDoK2Llv6BsKBCcY9+g/UAnCL7+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqAa+KGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqAa+KGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C464AC433F1;
	Tue, 23 Jan 2024 00:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968754;
	bh=LO03A/IDFe6T3MzK/wSsOEJmfC5dZr2TQTkAmCuja04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqAa+KGFb7Y6jXRhdnE92+EmWJ3/TcIvECw1FyKGXpIwHltsQKn7R4QWq0fRhX8OG
	 HCZujWbcdSccZ/R209Jh01fEJ/c+1sAuTWPRU3sv6Np7FDzpzQT4l3M4YH7MbnNYpo
	 toZ6jl3koEOvJUR9Ndl6xgtPhXGRABjAHgkWaoFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/194] ASoC: cs43130: Fix the position of const qualifier
Date: Mon, 22 Jan 2024 15:55:37 -0800
Message-ID: <20240122235719.519623510@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



