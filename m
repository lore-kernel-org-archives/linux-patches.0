Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D59141981;
	Tue, 23 Jan 2024 01:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972071; cv=none; b=avssFSxdrsfc+Cl3B8pP3iixNjIu1om7fQeLgruUr0cze3h120sXUe2+z0z2GqZo6Fyz/aDuZH5Zs+Czwc1OsvMhWW4J7GcoH7Dcx2cRFm+XCqnc3dDjM+zJ0+gQrZt+QZbr8LnzWXjKIOWrIUCKfB9Yh/Ygj3EgHmH+qLVNr84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972071; c=relaxed/simple;
	bh=HN8JyC5G2tIaSjGdLX1eWNDMjsJgz3JXRMof6Zmp9+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6ysVxwgIi1amNpcZVXnM5rjp68XdREVNUmrO8jXifI1NxK6WjM6VHjcEupzzniHIliwYgxqx39GP07SafcMWuU/DktiV5Cpam3mMEae983Ud43Bf7BQtdX2tSYJwGWx2EzdTzvU5aCiBoZiGu2sYFMqBNJlYAbF6tQsQsmME1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDeJEmrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDeJEmrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B375C43390;
	Tue, 23 Jan 2024 01:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972070;
	bh=HN8JyC5G2tIaSjGdLX1eWNDMjsJgz3JXRMof6Zmp9+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDeJEmrvXZFw0yPAwlQwLi+nzVYIIdxXcCvUgvbUOSyjTWuiRW+ZD6XRuoanQnECa
	 zF8Ojg7GTyU4jOodvpfnP4cnz/7mzGwPvT8aVRp+PftcC+cqJpnN+1ZmxGeUj3TbjX
	 /a2cD1e48PBsv/D6PPqIg96Wv9uzR9K3h7kOcs58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/374] ASoC: cs43130: Fix incorrect frame delay configuration
Date: Mon, 22 Jan 2024 15:54:30 -0800
Message-ID: <20240122235745.122008406@linuxfoundation.org>
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

[ Upstream commit aa7e8e5e4011571022dc06e4d7a2f108feb53d1a ]

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231117141344.64320-3-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs43130.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c
index 0e2cb54ae192..d3edc5796d66 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -579,7 +579,7 @@ static int cs43130_set_sp_fmt(int dai_id, unsigned int bitwidth_sclk,
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
 		hi_size = bitwidth_sclk;
-		frm_delay = 2;
+		frm_delay = 0;
 		frm_phase = 1;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-- 
2.43.0



