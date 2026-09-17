Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3339522F1B;
	Thu, 17 Sep 2026 17:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665945; cv=none; b=UL/NRpMyzxt9MIwflfc47UMlXSUCr4wmIg18zJt2useFxx338A/8PE1vOGyfwejzkQ+8wc4HebROvWY/L41l+iLzjZDpv5AU30tiahrTlbnf7mHoiCvIsJ3ga5DZDQQVWKNB+InvDJWClcmvk8jcCPJi6O2mNVayXzLuY1Op37M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665945; c=relaxed/simple;
	bh=Au12aXTrSU//C5VYpor3sugnxGyJQwI6Vij6Ha9r3xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMoKLQ9f3e58RsDLYHnGthwGPIfYW8Rge43NwN1yXy8TN2z27W1kFc2MSj5FfDYyFG2I5LjH2zxC3OhrCISrzfpDZ9V9eQUSo0OuLgiLp0PGwi0ydgUXEtRXc/tlp6I8oVqoi7XAT/Heap6dgXvlEF8q4Qkdb2a8YyqTaNGUhK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNEsELmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNEsELmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B921F000FF;
	Thu, 17 Sep 2026 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665943;
	bh=+MrQi0+L9DzjK6s3O3GApAHf0oAgUvXJTSddRnKVdNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNEsELmtgzdX+Fqnoz/q5RPGXXiMFeBCRx1T+3xCZBP9LPsmEBiqZa66Z3R4LtZiQ
	 8b11cKDmmeWKW0HI3NW6s9U3lnkVOFKiSFbKfnRD8tOcRwC9ueAU7rw5OdMUWNc+KV
	 FAq9dKRPYdymC/jiLH1iP+CrtiFsY121wONvsDXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0873/1250] drm/adp: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER
Date: Thu, 17 Sep 2026 16:11:08 +0100
Message-ID: <20260917151615.639767361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



