Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A9C374D1;
	Tue,  8 Apr 2025 12:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115586; cv=none; b=QwnNBHZFFf/hZhUh+df3rf7biV17zxtZ6qT6Ls8G8xhX3GHipkPSq7s7Owc4/kwI+KsEUVY0hwPShYcU5pIBKdlAUhjc+z7HUYIkPCFgfo0dOo3JhMtZ6j9jFN6bWeU+9H5ct5JnZ2cAQ0x6/1dMUBP0jsnfygmjE1PF19LUOp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115586; c=relaxed/simple;
	bh=N0K2GsOsrflpONmz3DEgh8BXkJU/fGPm/zhgH9SLDAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiXWpvKg71xi2QPL9r3xNvUhqgNrDsbW6PjL6jkuV5nJyzGwdfI5K/veKNbNmY7cBok2zKWwWnMxp3XJ3Df6aPhtlYuwpPibhFukLo1NROSQkASRh1MsNoQiLFHrkfIV7PT0wZ+V72oGiA0e4KN197TJUPuzVShZXMLg2evlPBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxfnP62C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxfnP62C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F155C4CEE5;
	Tue,  8 Apr 2025 12:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115586;
	bh=N0K2GsOsrflpONmz3DEgh8BXkJU/fGPm/zhgH9SLDAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxfnP62CqPK6CEVz8pXF3bR3Bl9T/bW4802lqsGzfA5Rmwz7fpsUM5pMMeTcPRF18
	 Hevltoa8bUnn6FFNBpgoqGiSScND6xfziaU1h5mBXzvtXrqL30tK6yyhf6CmxKh8Iu
	 8MZsOfZ6dDtaH8VWOMieWWRFG+5X7ZAUHy2VtdtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermes Wu <Hermes.wu@ite.com.tw>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/204] drm/bridge: it6505: fix HDCP V match check is not performed correctly
Date: Tue,  8 Apr 2025 12:49:19 +0200
Message-ID: <20250408104821.181121356@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermes Wu <Hermes.wu@ite.com.tw>

[ Upstream commit a5072fc77fb9e38fa9fd883642c83c3720049159 ]

Fix a typo where V compare incorrectly compares av[] with av[] itself,
which can result in HDCP failure.

The loop of V compare is expected to iterate for 5 times
which compare V array form av[0][] to av[4][].
It should check loop counter reach the last statement "i == 5"
before return true

Fixes: 0989c02c7a5c ("drm/bridge: it6505: fix HDCP CTS compare V matching")
Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250121-fix-hdcp-v-comp-v4-1-185f45c728dc@ite.com.tw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 7c3bd539655b8..cc2bf9c143733 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2030,12 +2030,13 @@ static bool it6505_hdcp_part2_ksvlist_check(struct it6505 *it6505)
 			continue;
 		}
 
-		for (i = 0; i < 5; i++) {
+		for (i = 0; i < 5; i++)
 			if (bv[i][3] != av[i][0] || bv[i][2] != av[i][1] ||
-			    av[i][1] != av[i][2] || bv[i][0] != av[i][3])
+			    bv[i][1] != av[i][2] || bv[i][0] != av[i][3])
 				break;
 
-			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d, %d", retry, i);
+		if (i == 5) {
+			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d", retry);
 			return true;
 		}
 	}
-- 
2.39.5



