Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC023CA481;
	Wed, 30 Sep 2026 19:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795406; cv=none; b=JadDL+fiihgLiGEjT34XJAReOY37XMTc7tceWJPRYOO4QM+KhxkVLDKsIeL1bk5vyi6l+8lM/cN0WS7y8g7WYMiZEwWDlsO5j0zcpgXKQPbQqMlO4lU4rsWxvhTEgGjfcLrQ6c0HliGrpBvlfnv18Ya1LloX+bPc/y6D6Cyh5LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795406; c=relaxed/simple;
	bh=ycWE/b3HaS2TwS1+YYXRTfsmheDB2K5cDNXAZXTZ5Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGxRQg3rGbwnTeuCSD15F9ULByUBHHs9JcpIqyrHvLcz8KOM8qXuawNNpepdzsX4Lck4B3s5nP0uEe57q6zVhcrBu6aN2toMYUFhYvTpykjs72HAf4I1QQW+WyNQQSADFGnoYDJD2WlfCytPzbBCqDoczqA62lxH8u6fVByKEfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2yICJIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2yICJIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490F11F000FF;
	Wed, 30 Sep 2026 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795404;
	bh=97olkUKuWSwFCG3iaF/UmKyP08b+7D11GrT5Wn/Cbro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2yICJIQGVduqkmfOLaxSQXSDaYNeiH77vmJHY+QaCCH+kARJl+xEymP+5Xw+wffa
	 0PWTw0Ca5dahnJ9ZX8uET30CNvzf3Lt205GN74AR1tabhsNEuQs4jhQ07Bi2ncwxWP
	 /WxbOsLtDGUAr82cd640OQ8T6vPMKuYJeEOKIbFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0549/1193] drm/logicvc: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER
Date: Wed, 30 Sep 2026 17:20:33 +0200
Message-ID: <20260930152446.433409919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f97802dd98b27e45c04293f9926f07642578b23f ]

CONFIG_DRM_KMS_CMA_HELPER was removed by commit 09717af7d13d ("drm:
Remove CONFIG_DRM_KMS_CMA_HELPER option"). When commit 6bcfe8eaeef0
("drm/fb: rename FB CMA helpers to FB DMA helpers") later renamed the
select in this Kconfig to CONFIG_DRM_KMS_DMA_HELPER, no symbol of that
name existed, and git log -S finds no Kconfig file that has defined one
since. The select is silently ignored. The driver already selects
CONFIG_DRM_GEM_DMA_HELPER, which is what it needs.

Remove the dead line.

Fixes: 6bcfe8eaeef0 ("drm/fb: rename FB CMA helpers to FB DMA helpers")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260905080344.34077-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/logicvc/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/logicvc/Kconfig b/drivers/gpu/drm/logicvc/Kconfig
index 1df22a852a23e..283dca51e4bdd 100644
--- a/drivers/gpu/drm/logicvc/Kconfig
+++ b/drivers/gpu/drm/logicvc/Kconfig
@@ -3,7 +3,6 @@ config DRM_LOGICVC
 	depends on DRM
 	depends on OF || COMPILE_TEST
 	select DRM_KMS_HELPER
-	select DRM_KMS_DMA_HELPER
 	select DRM_GEM_DMA_HELPER
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.53.0



