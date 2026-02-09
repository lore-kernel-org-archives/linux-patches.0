Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA181DE8AD;
	Mon,  9 Feb 2026 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647614; cv=none; b=cKPyLIq1tJPB4sTqM8i4O1KtnxffKkv+RHpbRQdGCYHbOeLHIfl2QMW1ID1GmQ+cjIGh92MG2zktBZteT045AH8mvGNzfzQEu/lg3fCv3dXO2na+/heMkzouZJ26IVWas9pW4ajC5P9yaEQeDF0GWRSO/IsfSZQs8dGNhmocoqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647614; c=relaxed/simple;
	bh=y6uxW/vUGNfwjTEa11b5H+ma4GoNJvuIH7EDtFSkedo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9spyOX0/eT7YAMZKwzP5EZX8WAKfsueZNE8Yv6BGEvXq7vJNCHq7I8a54cZ5yMIWB9FjSChq3p/4Wm/s1wMdc6sC6OJAnNJm1bWuxl055ZW7v9ToLnSa3nr9n4uRInmHeJlx4KC2nr4WjvzJkyXTdDaSILmCtr4FuvrABp0YP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9fhsJnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9fhsJnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D531DC116C6;
	Mon,  9 Feb 2026 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647614;
	bh=y6uxW/vUGNfwjTEa11b5H+ma4GoNJvuIH7EDtFSkedo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9fhsJnTLQ0lwYh8+ZE2+h1VHW9Nrh2NzhGYl5fNZ5TPeA1LvZ0xbQT9YNs5wWtLK
	 Nyym/8GLz8nDYvAgcIMYlCmaynzuix+JjytYZFJVvpBN4eGLKfkKYxAv1ER1XIR82V
	 KSvXrlspVf/4VRfVq2K+7SxPmpbzAa+EQhL34oIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/175] drm/xe/pm: Disable D3Cold for BMG only on specific platforms
Date: Mon,  9 Feb 2026 15:23:45 +0100
Message-ID: <20260209142325.966570427@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a58bf004aee73..a74e800846ffa 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -8,6 +8,7 @@
 #include <linux/fault-inject.h>
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
+#include <linux/dmi.h>
 
 #include <drm/drm_managed.h>
 #include <drm/ttm/ttm_placement.h>
@@ -300,9 +301,15 @@ ALLOW_ERROR_INJECTION(xe_pm_init_early, ERRNO); /* See xe_pci_probe() */
 
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



