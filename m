Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB88254705C;
	Wed, 30 Sep 2026 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785410; cv=none; b=TVR9Gs4y2qzX+0eF/CMhX6wPcqNNJJXSKmzYSKj4pIb6RAY3XpjmXHRcckrOTTW6getNZMLoiSM7Ce61KMAzpxrTXG3mMPAd3GhOf1PriWx2raJe90M0zdepE2GnqSj38SsKGP/NrUC9NerNptbE4FbPAfE9ygrSm6brBMTMf3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785410; c=relaxed/simple;
	bh=w4K0OnoEsoldxzk6WE6DEj4iELxXqMJQ51lpk+Ojzp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiqf1wcDumbkS8r9f1pp/ONW5l2TUTLiN/g6eHBhJ+7VNe9nJYgaQOV0Ovzq9HkEMPmcE04CXpf4uxyqI+Dtpa+5habOviWWCwcT55+cNBHBnSARbawlLleq9GHHKVqWitNfS0iNN+yLUpgs+/c9JkKxKb9Zl9SZY6GphoNUoKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx4B2aex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx4B2aex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D891F00898;
	Wed, 30 Sep 2026 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785407;
	bh=QAi+Z4P/aAEXHB4KSxwqKAc9+DaUxJN9ap40LdT2Gto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hx4B2aexeWRhpkXMAKGUFmDd6QjFdkj/jGAiUe/GpCnbSv0H46muXg2F8n+Q+Dd1A
	 sTbmrVvWcGjRXdb5bS/yGCL1bFUMhp7GmuS5FBkiFruS3btcp82lAc/TJbQzWJzGVD
	 rylmubqep3rN8D9Lycb9QeI7M51fnQZwBxiplJzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 453/982] drm/logicvc: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER
Date: Wed, 30 Sep 2026 17:19:49 +0200
Message-ID: <20260930152426.522465562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



