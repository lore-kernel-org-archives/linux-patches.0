Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B23309EEC;
	Mon, 13 Oct 2025 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368514; cv=none; b=EfMQmIhemDsbk9GqDQEdfuGjvZ2W0Gq6UKxARWM3jdMKkKk56iXt1mp66UKFCKUdy4kIk/lqX10WpyN54u3Kv29d028hwHghQoidnicr4HCWUH2iNmiplR75wkjs+cCyz/A69uu7odiwsN5+3Af5uDSpWF2kAVOY9fbkTJXO1ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368514; c=relaxed/simple;
	bh=SkP1MvfpMlPq/9fxIjtw6iCJ8n3JR9gslw0NchviMV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3RR5lgVDu/Y73vCATYT/A2e+xbYIxWn+iHMwOMTOyCFE3Q0xy7/Q5twcUcLRohUgyRVPWxldv5crQWmZuMJuWTG2ynK8Cngg2elEUrp8kRK+FczdTWP7r8g0PAYNrU3AsRE8p1hYHfQxFs98aOcDDzv/pNPnd52lpBoIBmOpas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTiM6gTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTiM6gTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC72C4CEE7;
	Mon, 13 Oct 2025 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368514;
	bh=SkP1MvfpMlPq/9fxIjtw6iCJ8n3JR9gslw0NchviMV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTiM6gTqM47uAQyAJlF1Hpvgbi2fp9OLxuFF2UYQe0eCSV34m6nsC/T03w/4oAKYa
	 8lzmUC9Ke/r9sxdSdah7v13E8lcfY+IQlLgbOXXZ5OPLoNsAV8pDFXHX53DkopAeJZ
	 PcqxKfaUEnMGeWzWiucKN9rG8UFx3wtqD4Wq+Glc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@h-partners.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/262] coresight: Fix incorrect handling for return value of devm_kzalloc
Date: Mon, 13 Oct 2025 16:45:30 +0200
Message-ID: <20251013144333.020198520@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5755674913723..d771980a278dc 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -1267,7 +1267,7 @@ static void arm_trbe_register_coresight_cpu(struct trbe_drvdata *drvdata, int cp
 	 * into the device for that purpose.
 	 */
 	desc.pdata = devm_kzalloc(dev, sizeof(*desc.pdata), GFP_KERNEL);
-	if (IS_ERR(desc.pdata))
+	if (!desc.pdata)
 		goto cpu_clear;
 
 	desc.type = CORESIGHT_DEV_TYPE_SINK;
-- 
2.51.0



