Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8341E89C;
	Tue, 27 May 2025 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366480; cv=none; b=mm0gLv1tLpwM0s7c7aKspq4yJn6UzYYa6raxJmlmvJ4s71Mfm3T6kfGys2VElyw9olyCv9tC+375hxFZzIuL8BHjEwdZIqtp88xhn8rzt4c3vjhuFysfiqiwKN0DFp/Y6UaA6P/qxofZyg0wISOzh0+1W1llyAqd+wctRnWb0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366480; c=relaxed/simple;
	bh=D2VcMOgA7zAEtmX9nJRtLASzIXssptvZyQBQYqYclns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRBYegEDxeBgFT4Sd5kRB1kXdHv7x0Q8x0ou0igCCZIuFKnFmPyuUKCV8m4vA/IbuH43GJ39Dkg3zp2/nhTDsOWm/gcf9odCZhgU6/wB0y/I184NkJxe14C+vAuciyDRS+P+TaWcEpymfBBgDCVCHO+rCcU1xLRdUUj8wCFV8FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaI0KYqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaI0KYqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431C2C4CEE9;
	Tue, 27 May 2025 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366480;
	bh=D2VcMOgA7zAEtmX9nJRtLASzIXssptvZyQBQYqYclns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaI0KYqewGzm+1RMb6Qm1Ubnd8RS2asUY2AXEHulUFPm+DRuwzzeCgG4kwGSxPzrQ
	 1hATx+wi6vIAkU9CdPMo9mG/EDiopT3LaH3y7WRgFgKp4w70quty4yRtW5xS+DupQ+
	 qnJOxjKyJMNvQcX/bTnQqt+pBInK73WVbsCqTAPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 080/783] ASoC: codecs: wsa883x: Correct VI sense channel mask
Date: Tue, 27 May 2025 18:17:57 +0200
Message-ID: <20250527162516.392032586@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ed3b274abc4008efffebf1997968a3f2720a86d3 ]

VI sense port on WSA883x speaker takes only one channel, so use 0x1 as
channel mask.  This fixes garbage being recorded by the speaker when
testing the VI sense feedback path.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250312-asoc-wsa88xx-visense-v1-1-9ca705881122@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 47da5674d7c92..e31b7fb104e6c 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -529,7 +529,7 @@ static const struct sdw_port_config wsa883x_pconfig[WSA883X_MAX_SWR_PORTS] = {
 	},
 	[WSA883X_PORT_VISENSE] = {
 		.num = WSA883X_PORT_VISENSE + 1,
-		.ch_mask = 0x3,
+		.ch_mask = 0x1,
 	},
 };
 
-- 
2.39.5



