Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F24A33EF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300998; cv=none; b=Zv4mBuIMQp2sSBHq3jEHIiEg8SxuEMzDrM/EEdayifrcmoLPA0Rekl7SQeeoo4DUMs0ezVmZGxWO/uSoYdOIG65aJszStunKT19YnAr+THCIBwgCdhNGXvZpb8F5JhZ3pP1YW2xGFt/q84cA6lM207ApoR8q2gUaDvhDKVy0Jes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300998; c=relaxed/simple;
	bh=K/186z1y6c+vK5de+7Iw8hyg8iSR5DBLjUV9OQvskRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFJWtJrFYMVFDBM1bk+ACMh9A1hU194vccrJJl0ThukIb8sPa5B1bGreVsMbFDoAu3Yz+EmVl1N1rS+Y8w7wQYuJBAcgp/GujbzIozBw0f/2ejkhpT1z5KkoAQUaUGaIVRi6+u/hzZh0iIzVOnAEflwcGKUFA3sDxqVBaoe3rEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RahSHXuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RahSHXuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD49CC116D0;
	Sat, 28 Feb 2026 17:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300998;
	bh=K/186z1y6c+vK5de+7Iw8hyg8iSR5DBLjUV9OQvskRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RahSHXuMUf4gVYYrfvBJq+0qjvkH1UfRZ0plQOobgMj7uHfLMOlh/sFh+IptR1yGw
	 h5/GO89g/izhjHHSFogS7BU2/qn+GAXV2dx+xwerQvRThjE9nZiikw7GwNYJxgYtt3
	 77tAPhOq8tu8YKoUqeEfpGFT4GDciEc05G9O74fahv3AaTAyZkDy6+V9Pdnsmc1GdU
	 GUy3LGR4w8FlqBEueGQ9MgERamc/eiBUqFfr/PPQn7waSlLlhAGZ8AVOJaLKysMoXq
	 VvbZGOLP3vw17qTIcojFR+8mLqpARXzgWuJPhGYg2t5KQuwcO0IUQpFD2EkQ48Hgvt
	 dQch+XPvSDfEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/752] media: omap3isp: isp_video_mbus_to_pix/pix_to_mbus fixes
Date: Sat, 28 Feb 2026 12:37:21 -0500
Message-ID: <20260228174750.1542406-130-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 44c03802a5191626996ee9db4bac090b164ca340 ]

The isp_video_mbus_to_pix/pix_to_mbus functions did not take
the last empty entry { 0, } of the formats array into account.

As a result, isp_video_mbus_to_pix would accept code 0 and
isp_video_pix_to_mbus would select code 0 if no match was found.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/omap3isp/ispvideo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/ti/omap3isp/ispvideo.c b/drivers/media/platform/ti/omap3isp/ispvideo.c
index 0e7f0bf2b3463..68e6a24be5614 100644
--- a/drivers/media/platform/ti/omap3isp/ispvideo.c
+++ b/drivers/media/platform/ti/omap3isp/ispvideo.c
@@ -148,12 +148,12 @@ static unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
 	pix->width = mbus->width;
 	pix->height = mbus->height;
 
-	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
 		if (formats[i].code == mbus->code)
 			break;
 	}
 
-	if (WARN_ON(i == ARRAY_SIZE(formats)))
+	if (WARN_ON(i == ARRAY_SIZE(formats) - 1))
 		return 0;
 
 	min_bpl = pix->width * formats[i].bpp;
@@ -191,7 +191,7 @@ static void isp_video_pix_to_mbus(const struct v4l2_pix_format *pix,
 	/* Skip the last format in the loop so that it will be selected if no
 	 * match is found.
 	 */
-	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
+	for (i = 0; i < ARRAY_SIZE(formats) - 2; ++i) {
 		if (formats[i].pixelformat == pix->pixelformat)
 			break;
 	}
-- 
2.51.0

