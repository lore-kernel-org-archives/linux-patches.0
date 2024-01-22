Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9706775D;
	Tue, 23 Jan 2024 02:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975284; cv=none; b=AYpEhkra8W4VnRMX3UFp/F5xq3peaRLdBzLsH2jlUmEKo9ZOo77azicpYcyAL1LW/+dzXvd2QxWRjwTPXW4ccuI7zliIzPZPBcN0F0BTxRlHTibZ41UG3yt7YNdLla0oYB4JJAS2qyv1xNTxFhdMtN+3k29LuP+vGcaTuL4jTfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975284; c=relaxed/simple;
	bh=qZm7xf8O7L+NZrPtpsaf4r7YCjDJPZ66h4Z9GF+2uNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqkdMmoF93A2l+2EHNxQu2vDIMSxVFvH/b01g7uTgrjCqSRJrNIdLvGVe9+bHv1OkrhD4AUJkdMitEvOju/s8YqkAZSk3re0BxRKZTEI4K3JwGp86HmBpP1dauB+Y06xV85S4z7RBiIeIAK+OtiDIDuLZtFBW+ihw3l1zwcxiOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7F3XxKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7F3XxKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C014C43390;
	Tue, 23 Jan 2024 02:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975284;
	bh=qZm7xf8O7L+NZrPtpsaf4r7YCjDJPZ66h4Z9GF+2uNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7F3XxKSw/qaN5OYthRGSVWwd9cOVdB9xF0aVeDX/Dy5M6OgfRkI5BXM5iFeLR7Da
	 w6Wzn6T6OSy4M8bU4hMG/6nhLSfDvqatyEIbMdxrUoLlmuRhZeVN08BJlrETgfDR7f
	 KYePBk1ieA3TU4L5asmDEvaYZGcxzoZX4sHuSQ24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/583] drm/tidss: Check for K2G in in dispc_softreset()
Date: Mon, 22 Jan 2024 15:54:57 -0800
Message-ID: <20240122235819.525363785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



