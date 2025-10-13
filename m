Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405EC30DD34;
	Mon, 13 Oct 2025 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369973; cv=none; b=bYfL3LS7kUYRLhG8ZrDxX8d/yGBTxtWPn3eGiACn7dnxBtbjIS2YGbJ9A4LHqY2ixbGz9GyoR/ibOQx+5EsDDzr5ooE4n5DAs4wsoG6GBRJ/1EcNEppW6qohXl/93OlLDbX3/ffLc8U0WCnfXWzTxsTeKMoAbWTjbZbL2pmrHiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369973; c=relaxed/simple;
	bh=3Wk6KASJiARM10HX6UQ79piIDvhl/6cy/Krd753LMbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPKFMMRg1auAZ1vJ7KytAZfOHMaBsm2XYBN+8i2v2ewfFKK/ektsCIsgP9Wo/0tIIVh1rI3CljTqSX/zSUxx+E6l5mtcx5TAmet5jg+rMIL0j7fz2xFfavZsWskJLag+NswkwKDkQLQpWvwIRtIkGZKV1KuJxPpOIvQfgvUHAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeH0nFji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeH0nFji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D1FC4CEE7;
	Mon, 13 Oct 2025 15:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369973;
	bh=3Wk6KASJiARM10HX6UQ79piIDvhl/6cy/Krd753LMbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeH0nFjiXIK6RyRHYvVy+5RiCx4/52FO3zOMFLio4ONR7tRP7D2gH2ERkYomtBb/B
	 NGKi7yof5Dru7Uk8lm6GNyewcQkNOmwdXLhKEs863CRUdn+OnUukCBeAGU3gEckCws
	 nal3lPuysZoaYfsvDlEOfeDOZ0lT90fnKJKJCsCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@h-partners.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 433/563] coresight: Fix incorrect handling for return value of devm_kzalloc
Date: Mon, 13 Oct 2025 16:44:54 +0200
Message-ID: <20251013144426.970849233@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Yujun <linyujun809@h-partners.com>

[ Upstream commit 70714eb7243eaf333d23501d4c7bdd9daf011c01 ]

The return value of devm_kzalloc could be an null pointer,
use "!desc.pdata" to fix incorrect handling return value
of devm_kzalloc.

Fixes: 4277f035d227 ("coresight: trbe: Add a representative coresight_platform_data for TRBE")
Signed-off-by: Lin Yujun <linyujun809@h-partners.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250908122022.1315399-1-linyujun809@h-partners.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 3dd2e1b4809dc..43643d2c5bdd0 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -1281,7 +1281,7 @@ static void arm_trbe_register_coresight_cpu(struct trbe_drvdata *drvdata, int cp
 	 * into the device for that purpose.
 	 */
 	desc.pdata = devm_kzalloc(dev, sizeof(*desc.pdata), GFP_KERNEL);
-	if (IS_ERR(desc.pdata))
+	if (!desc.pdata)
 		goto cpu_clear;
 
 	desc.type = CORESIGHT_DEV_TYPE_SINK;
-- 
2.51.0



