Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494F1852;
	Tue, 23 Jan 2024 00:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969480; cv=none; b=OEJ64APD2OIRwGj/e6Wet6OkdkO79HbXuhY5t4nZuwKkDGRZBQC4SAHN25SGIsghWVRgzCADN7MzgXMpZJv1R54tzeeSFnyq3Klm746Yzuj4HWs7cJ4HroGOdln6cE2bJHhMLfn29g76H5VvmYYAh8Ou6+VZnFA/LyAhSpMyr74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969480; c=relaxed/simple;
	bh=e/jKJ+mZsqtO5SFEb4LoUjQIiLf6CQgvsdhpnhghDLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4kNiiJU6NNJwfQrzIHEAR3KeTjqV8YDx2+QM3MQItTKFoBGpKRgpkcJsYVSW7IYEyT2xfqCn58lcF1m+YbJo8nqxc8lK0Ujw5mV1RAspSzymneazapL61TSeHoaljXbmgwulInVsZiUCkW3luH4jyuQkldRntaV7FwPNoQAZBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8Oo2GUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8Oo2GUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1C3C43390;
	Tue, 23 Jan 2024 00:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969480;
	bh=e/jKJ+mZsqtO5SFEb4LoUjQIiLf6CQgvsdhpnhghDLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8Oo2GUo+NXh65K7OOyUjoWW65PouCdVi+f6A9JIOoD+tYfleVlN+8fsb4td/jXjL
	 474JfmZAzu6pBYqeb9myotYOsR5oFq8uTuwO4PVtxMTMY/se2YNQJVBlKYWW+3VhyZ
	 MoG4g91JK9rfwn9ghry7Ca+8Q87eVC7exsZO0e5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 273/641] drm/tidss: Check for K2G in in dispc_softreset()
Date: Mon, 22 Jan 2024 15:52:57 -0800
Message-ID: <20240122235826.460668248@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 151825150cf9c2e9fb90763d35b9dff3783628ac ]

K2G doesn't have softreset feature. Instead of having every caller of
dispc_softreset() check for K2G, move the check into dispc_softreset(),
and make dispc_softreset() return 0 in case of K2G.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Link: https://lore.kernel.org/r/20231109-tidss-probe-v2-6-ac91b5ea35c0@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Stable-dep-of: bc288a927815 ("drm/tidss: Fix dss reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 9a29f5fa8453..2af623842cfb 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2707,6 +2707,10 @@ static int dispc_softreset(struct dispc_device *dispc)
 	u32 val;
 	int ret = 0;
 
+	/* K2G display controller does not support soft reset */
+	if (dispc->feat->subrev == DISPC_K2G)
+		return 0;
+
 	/* Soft reset */
 	REG_FLD_MOD(dispc, DSS_SYSCONFIG, 1, 1, 1);
 	/* Wait for reset to complete */
@@ -2829,12 +2833,9 @@ int dispc_init(struct tidss_device *tidss)
 	of_property_read_u32(dispc->dev->of_node, "max-memory-bandwidth",
 			     &dispc->memory_bandwidth_limit);
 
-	/* K2G display controller does not support soft reset */
-	if (feat->subrev != DISPC_K2G) {
-		r = dispc_softreset(dispc);
-		if (r)
-			return r;
-	}
+	r = dispc_softreset(dispc);
+	if (r)
+		return r;
 
 	tidss->dispc = dispc;
 
-- 
2.43.0



