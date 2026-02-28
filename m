Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07844BC004;
	Sat, 28 Feb 2026 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301340; cv=none; b=t6fnASN8qzSAo10hHXQPQ63TiqEiPbGnBidsDyYMmJ+zVXUsVcbPz6LAeOs+DMG801pZYBMOr+WGdkLkmOZS+XaNKlI+fK2JOpssObIvCNB1urJ85YDnTZpGKgiEXbGhnmRgplNT1YDaxLmRPLA7mZIeNUbr05koBPF8geWotGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301340; c=relaxed/simple;
	bh=b6WhtVEP2p+gcJPlwCLcllZp1eYEWxVNgELP2T2BLQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHOjtlStZgPT5PsU0FwEGmRWH/LOFokB2kWc6Bo7s8En4sOvSvCPUMQArmaPshVvPiqTuWrqnNzcEcYXpMg4dzL75l/y4nlIwuwlhGUc5alUTqSoWHtadye0PFCBMVF4GaGcY4dgcaFsCVy506eITibB6VY0oYHmNB6AXWD2F3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3F7o0NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3F7o0NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4BDC116D0;
	Sat, 28 Feb 2026 17:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301340;
	bh=b6WhtVEP2p+gcJPlwCLcllZp1eYEWxVNgELP2T2BLQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3F7o0NAOZu0X//wl6PHiRzQ8xduREbkhdhdKXw31A9GzmFg3S8KHzYaRyvT26aUQ
	 FuRSmbT/vmcxp4qdCYQ1V0R+prbKRaI2vYYdAcNsl0Q0tWufqvMW70ew8pvvWdU+NG
	 3igBNmOqbq/7W0X/+JtYaNinzhNoeHILy9QphQCQfCxOuQWXY63I16cMya0G3hHwTw
	 yEsQPyIgAZqKDjjF53m++x0CersYW9oWHDssQnJApPoRdrS117A+LgfHU4l/9UIoLB
	 Aj3Wu+/tERzENngpAT8/Q4dT9vAb4IDA6K+CXLUgMGL+tpa6siDHnK5vptjjmC1PCx
	 iETx12nRqY2qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Plowman <david.plowman@raspberrypi.com>,
	stable@vger.kernel.org,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 527/752] media: i2c: ov5647: Sensor should report RAW color space
Date: Sat, 28 Feb 2026 12:43:58 -0500
Message-ID: <20260228174750.1542406-527-sashal@kernel.org>
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

From: David Plowman <david.plowman@raspberrypi.com>

[ Upstream commit f007586b1e89dcea40168415d0422cb7a0fc31b1 ]

As this sensor captures RAW bayer frames, the colorspace should be
V4L2_COLORSPACE_RAW instead of SRGB.

Fixes: a8df5af695a1 ("media: ov5647: Add SGGBR10_1X10 modes")
Cc: stable@vger.kernel.org
Signed-off-by: David Plowman <david.plowman@raspberrypi.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 191954497e3db..c0f1121b025e5 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -508,7 +508,7 @@ static const struct ov5647_mode ov5647_modes[] = {
 	{
 		.format = {
 			.code		= MEDIA_BUS_FMT_SBGGR10_1X10,
-			.colorspace	= V4L2_COLORSPACE_SRGB,
+			.colorspace	= V4L2_COLORSPACE_RAW,
 			.field		= V4L2_FIELD_NONE,
 			.width		= 2592,
 			.height		= 1944
@@ -529,7 +529,7 @@ static const struct ov5647_mode ov5647_modes[] = {
 	{
 		.format = {
 			.code		= MEDIA_BUS_FMT_SBGGR10_1X10,
-			.colorspace	= V4L2_COLORSPACE_SRGB,
+			.colorspace	= V4L2_COLORSPACE_RAW,
 			.field		= V4L2_FIELD_NONE,
 			.width		= 1920,
 			.height		= 1080
@@ -550,7 +550,7 @@ static const struct ov5647_mode ov5647_modes[] = {
 	{
 		.format = {
 			.code		= MEDIA_BUS_FMT_SBGGR10_1X10,
-			.colorspace	= V4L2_COLORSPACE_SRGB,
+			.colorspace	= V4L2_COLORSPACE_RAW,
 			.field		= V4L2_FIELD_NONE,
 			.width		= 1296,
 			.height		= 972
@@ -571,7 +571,7 @@ static const struct ov5647_mode ov5647_modes[] = {
 	{
 		.format = {
 			.code		= MEDIA_BUS_FMT_SBGGR10_1X10,
-			.colorspace	= V4L2_COLORSPACE_SRGB,
+			.colorspace	= V4L2_COLORSPACE_RAW,
 			.field		= V4L2_FIELD_NONE,
 			.width		= 640,
 			.height		= 480
-- 
2.51.0

