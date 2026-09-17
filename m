Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED0501F26;
	Thu, 17 Sep 2026 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659784; cv=none; b=Yuqs1jueoosMkQG6nsQBII5AVkPOJ+J8dIvKBOXhl1Yb4ETYLs5BsRjURl6Vtj5A6xgt1XDoVl8lUpqPLDblmt42EAMwtDiaHRdxnTNPFG8yYFzqxNnuSgPfkSpYgdju2fx/EmnULo6dsIUKv2M77YGm+7hOp8zq+XRBglarObQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659784; c=relaxed/simple;
	bh=7xxDs9ggV58IkEdEOT28K4Yg/aQn2bgjkZWxvXCgDhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKx/MUnREPPb60j7ZDfxgxssyONaelDBLFHNt/rgxFipWI3USD4Q+nIpyhj0K5PtsPYVnUU5olujPguetK9koENpK+ac0c+ddxL3ZIQlmsa04W00jza0ERJJ6bJORV0AmZ/+khDOXDLzcwRu9ScHxM0mbOgFMsD2OxtpEZ2L3ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbWzj7fk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbWzj7fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16731F00893;
	Thu, 17 Sep 2026 15:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659773;
	bh=0pvwWshktyH1RBIIpOaTQlI3zwWKJ9AdhYiYClhVdow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbWzj7fkkcU8O/PZ4VfpoK4VC/GvoS/ATigAUvEdrba5p9Vn5bWc6JBE6tE8Z2TCl
	 QxhY8q4wAiT9496GC0R+ifyF00+lA2Giq/wJQZKdXeJnvLtsJxFiLBTXZ8HyQP5rty
	 f8d0LL0LCdhAS0COD5dk+rAuZsH75BkFfMHEnCBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 367/733] drm/adp: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER
Date: Thu, 17 Sep 2026 16:11:15 +0100
Message-ID: <20260917151400.772058624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit fedf002d7d08bee36693aacd1ade2ba39351ea91 ]

There is no Kconfig symbol CONFIG_DRM_KMS_DMA_HELPER. The former
CONFIG_DRM_KMS_CMA_HELPER was removed by commit 09717af7d13d ("drm:
Remove CONFIG_DRM_KMS_CMA_HELPER option") before this driver was added,
so the select does nothing. The driver already selects
CONFIG_DRM_GEM_DMA_HELPER, which is what it needs.

Remove the dead line.

Fixes: 332122eba628 ("drm: adp: Add Apple Display Pipe driver")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260905080426.34224-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/adp/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/adp/Kconfig b/drivers/gpu/drm/adp/Kconfig
index 9fcc27eb200db..acfa21ee06d22 100644
--- a/drivers/gpu/drm/adp/Kconfig
+++ b/drivers/gpu/drm/adp/Kconfig
@@ -6,7 +6,6 @@ config DRM_ADP
 	select DRM_KMS_HELPER
 	select DRM_BRIDGE_CONNECTOR
 	select DRM_DISPLAY_HELPER
-	select DRM_KMS_DMA_HELPER
 	select DRM_GEM_DMA_HELPER
 	select DRM_PANEL_BRIDGE
 	select VIDEOMODE_HELPERS
-- 
2.53.0



