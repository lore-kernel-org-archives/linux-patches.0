Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5FB37AA87;
	Mon,  9 Feb 2026 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648079; cv=none; b=kbz3Rk7mZSJ/2JAp2QNn564tlGifFcu2yIoB2wXf8EPdDyipo3PsDu5tmZpRckYDZ/fsXEeSrdtf7N2qwMLND5m8kYomGcKWv0eERFThOB3ayaNxJmSFHuH95e46CTcczqNWt968yZsKY7BXbYfha9Udp384JzNlpnnKZw+NsZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648079; c=relaxed/simple;
	bh=/tvTzSdIwdz3PNWom4gQE698ApXHGteI0kEPTWrZclg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlPWlRynhODe7T3GFe6hivT65pH2Ed9fSJ5EFEGi5tWFc35cQxsEcbziWP7xsSRuKwX7Y5CDojEAHrb9EVelet0fUHC/6ImJEAXdgOv75xWGNsk9a/toEQZqpArsBCalN1qSf+hqjtgseWG33s8JoMVh6ojxnvM9jdru8p+mCio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riLsew9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riLsew9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A317EC19423;
	Mon,  9 Feb 2026 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648079;
	bh=/tvTzSdIwdz3PNWom4gQE698ApXHGteI0kEPTWrZclg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riLsew9LS3GNIWmQd/YMIA0rBP1bJl/S3bvIIiQ02fm9tPnvuw2iPWUhRWodlBYiK
	 cJAffYYR62yFxS7MZolclRcyArsNpgZoITf/8heI5/QiILkmyFFmd8wpoApLdSFZ8K
	 GUDthdJmgHLdDZmSSLzqbzP3YQ7rWB41KKXt2D8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/113] drm/xe/pm: Disable D3Cold for BMG only on specific platforms
Date: Mon,  9 Feb 2026 15:24:09 +0100
Message-ID: <20260209142313.769998932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit bb36170d959fad7f663f91eb9c32a84dd86bef2b ]

Restrict D3Cold disablement for BMG to unsupported NUC platforms,
instead of disabling it on all platforms.

Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Fixes: 3e331a6715ee ("drm/xe/pm: Temporarily disable D3Cold on BMG")
Link: https://patch.msgid.link/20260123173238.1642383-1-karthik.poosa@intel.com
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 39125eaf8863ab09d70c4b493f58639b08d5a897)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 1012925aa4816..cab80b947c755 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -7,6 +7,7 @@
 
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
+#include <linux/dmi.h>
 
 #include <drm/drm_managed.h>
 #include <drm/ttm/ttm_placement.h>
@@ -270,9 +271,15 @@ int xe_pm_init_early(struct xe_device *xe)
 
 static u32 vram_threshold_value(struct xe_device *xe)
 {
-	/* FIXME: D3Cold temporarily disabled by default on BMG */
-	if (xe->info.platform == XE_BATTLEMAGE)
-		return 0;
+	if (xe->info.platform == XE_BATTLEMAGE) {
+		const char *product_name;
+
+		product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
+		if (product_name && strstr(product_name, "NUC13RNG")) {
+			drm_warn(&xe->drm, "BMG + D3Cold not supported on this platform\n");
+			return 0;
+		}
+	}
 
 	return DEFAULT_VRAM_THRESHOLD;
 }
-- 
2.51.0



