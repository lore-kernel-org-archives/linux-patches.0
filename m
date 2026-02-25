Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3801FE45D;
	Wed, 25 Feb 2026 01:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983063; cv=none; b=r5D26ootq7yL1bTbJqoZLWdJuJIBBCZyTD+e86vJb+eezLRFejUMzAcdzIBg3S83s/k/Wgi1zRwjw5o2ndsF5Oyuw80ttkc7AS4VLU0Tz77pFeuRKRtr3qDykbjFoXjQD8WjbcrNaZWAxFwiqTfIqUEDwsRqgsfLps22TQRmGQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983063; c=relaxed/simple;
	bh=rzy8+DvEHgk2megqNaChjmK3s56ydKAhc3hdXSxM9LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gpWhDif9hgOPymZ0+R6mOnLR0JsKe8bunGZD/a2ARhYjbyCCd6/vx80bIb9p92NTXxn8mmi7cT/URERX/9A+Tl3CEfY/SmJWEDxw+24r1sjMGI5VyhYVlKMg4Yx2pvO21w+LH4Wv8SYaF6u9ocEc3MTd8TAeKObg1iqqM1l9TAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaUsGgDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaUsGgDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F3AC116D0;
	Wed, 25 Feb 2026 01:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983062;
	bh=rzy8+DvEHgk2megqNaChjmK3s56ydKAhc3hdXSxM9LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaUsGgDe7J+BfLDEgw4DrpZAO0qDpwkIIxPbfxXR86yMAYOdYRbrmmWxsIHlcEbXy
	 QF7BAyym3dvGzaoVeeu9H/rB6tCphj6JcWtey0bIOiS6xH/HIuvi68yRVO7PqZwPmx
	 bNRqdOabpbuGx3G2lkdddWpDWUGNV5hde7q/fZN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 226/781] drm/i915/colorop: do not include headers from headers
Date: Tue, 24 Feb 2026 17:15:35 -0800
Message-ID: <20260225012405.254787728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 6a3591522930897c3fdb326c5d48b906b5c30b71 ]

drm_colorop.h doesn't need the intel_display_types.h include for
anything. Don't include headers from headers if it can be avoided.

Fixes: 3e9b06559aa1 ("drm/i915: Add intel_color_op")
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Reviewed-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Link: https://patch.msgid.link/20251218141807.409751-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_colorop.c | 2 ++
 drivers/gpu/drm/i915/display/intel_colorop.h | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_colorop.c b/drivers/gpu/drm/i915/display/intel_colorop.c
index f2fc0d8780cee..1d84933f05aa9 100644
--- a/drivers/gpu/drm/i915/display/intel_colorop.c
+++ b/drivers/gpu/drm/i915/display/intel_colorop.c
@@ -2,7 +2,9 @@
 /*
  * Copyright © 2025 Intel Corporation
  */
+
 #include "intel_colorop.h"
+#include "intel_display_types.h"
 
 struct intel_colorop *to_intel_colorop(struct drm_colorop *colorop)
 {
diff --git a/drivers/gpu/drm/i915/display/intel_colorop.h b/drivers/gpu/drm/i915/display/intel_colorop.h
index 21d58eb9f3d0f..9276eee6e75a3 100644
--- a/drivers/gpu/drm/i915/display/intel_colorop.h
+++ b/drivers/gpu/drm/i915/display/intel_colorop.h
@@ -6,7 +6,9 @@
 #ifndef __INTEL_COLOROP_H__
 #define __INTEL_COLOROP_H__
 
-#include "intel_display_types.h"
+enum intel_color_block;
+struct drm_colorop;
+struct intel_colorop;
 
 struct intel_colorop *to_intel_colorop(struct drm_colorop *colorop);
 struct intel_colorop *intel_colorop_alloc(void);
-- 
2.51.0



