Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8423331200;
	Sat, 30 May 2026 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166304; cv=none; b=OzVXegkE9ij8RlikPqecZM8ecnBDPfDl18XhW+cezaU75aPljSXHI/HGuYQNSKKGi2ITVbi911zritsVy/TwC3+xJopOnoZVTy4KOxKA2skoSBJl6kVmUV8BtHAMJ32y4/MRkKmjCpbE3a92LazlHUfTkrVNeOAzFvJlY/HjhQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166304; c=relaxed/simple;
	bh=3vhalJVmp96w92gYl6TCsWtg2/CLnYYxkhI0x8/lrRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3owCGc1Uz1i8ivQGtikelQmvhkUDTt5nv7sD7MHj95/CgJKsLGWbeSEYYPb1RIA4iG/WwKTWtFHtTXRetogHtnqD/XQtj8gk0uNbDOw4vQCFVHzXGzcv9Aw919pSnOzDfEqRcYjrD0oQFBNLmD77+z77X1gswEzeef8P0Ndq40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bI1TRVyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bI1TRVyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295931F00893;
	Sat, 30 May 2026 18:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166303;
	bh=ZU6jshQKcydDhh71pZNGj/FWWP5hfM8oS4n1xw0h4Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI1TRVyZwkHzDAGlJNw4n9ig0k4KDY9EmJyyPsV0UimPZ2bGCI6Yb5mJ4Yh7uERQ4
	 5PWIdF74Klq/MteyC5eat9XriyIma1qjaCW3Y6aMPoIAdTRw5ptNxJlNOab2AuFF5K
	 J6LQZjQLpCrSU/Ed6RIRdF1XrttGrDXk2L1fNhvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/589] drm/panel: simple: Correct G190EAN01 prepare timing
Date: Sat, 30 May 2026 18:03:35 +0200
Message-ID: <20260530160233.683175183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit f1080f82570b797598c1ba7e9c800ae9e94aafc6 ]

The prepare timing specified by the G190EAN01 datasheet should be
between 30 and 50 ms. Considering it might take some time for the
LVDS encoder to enable the signal, we should only wait the min.
required time in the panel driver and not the max. allowed time.

Fixes: 2f7b832fc992 ("drm/panel: simple: Add support for AUO G190EAN01 panel")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260217142528.68613-1-ian.ray@gehealthcare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index d4bd72347245a..a59adc08267f5 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1140,7 +1140,7 @@ static const struct panel_desc auo_g190ean01 = {
 		.height = 301,
 	},
 	.delay = {
-		.prepare = 50,
+		.prepare = 30,
 		.enable = 200,
 		.disable = 110,
 		.unprepare = 1000,
-- 
2.53.0



