Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED481BD002;
	Tue,  2 Jul 2024 17:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940247; cv=none; b=OWM6fukRS6wXUmNBuXI4K+2a5XhhUk64R3uNrxuurL7ZI1I0GcNm4d1VUpxd0pgE1Ym1md/IVcPBxMBM12M8vawp9xpKR25mhls2g7BxP6c8FBv+xLzsO2W97WKA5fU5YW4ADUPL0o/WnR/lJMDlrVS6fvTNVnxTDE+n31bOwqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940247; c=relaxed/simple;
	bh=axIlLpq3Ltfdo0lUDcZL3UWrZGo98kOVDbcTjVdVHiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ma+XKV9RTJZMt5idkjZHkx05r2SDtSFE7SC3KA7fuhLUi/R/y4RvZ3Yv2AwObt0CCAXEwvJj8At1Npyup2GHRB4AE56z+lJxQVazXHm+RK7mIOWvLN1wJNeaFONYWhGr7l84C0W3bQMFSIwmmakckekHxvCFBBp4pQwEZFbWdfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjLX9naN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjLX9naN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4736CC116B1;
	Tue,  2 Jul 2024 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940246;
	bh=axIlLpq3Ltfdo0lUDcZL3UWrZGo98kOVDbcTjVdVHiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjLX9naN/uhY9QzXY9oc9kAuqX2D6L+33/WBm/A8TbQx1fnVlrpkjo0Qn8x84/66z
	 w55JiNddb4IVdBCqjvHUM9XpN4B5RPK1xwHnqMbWIdcGofm4LU/BDOMSK4/rx29M2l
	 PAPHJh4WZ8xuBazhkoczbVWiBIhPPHzerDmeUE/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 097/222] drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA
Date: Tue,  2 Jul 2024 19:02:15 +0200
Message-ID: <20240702170247.677070003@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 37ce99b77762256ec9fda58d58fd613230151456 ]

KOE TX26D202VM0BWA panel spec indicates the DE signal is active high in
timing chart, so add DISPLAY_FLAGS_DE_HIGH flag in display timing flags.
This aligns display_timing with panel_desc.

Fixes: 8a07052440c2 ("drm/panel: simple: Add support for KOE TX26D202VM0BWA panel")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240624015612.341983-1-victor.liu@nxp.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240624015612.341983-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e8fe5a69454d0..6aac6f2accb43 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2707,6 +2707,7 @@ static const struct display_timing koe_tx26d202vm0bwa_timing = {
 	.vfront_porch = { 3, 5, 10 },
 	.vback_porch = { 2, 5, 10 },
 	.vsync_len = { 5, 5, 5 },
+	.flags = DISPLAY_FLAGS_DE_HIGH,
 };
 
 static const struct panel_desc koe_tx26d202vm0bwa = {
-- 
2.43.0



