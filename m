Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF9435F61E;
	Sat, 12 Sep 2026 07:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197182; cv=none; b=WhbyWVe7BhhO6GZpVQfLMjuokoKi+eNnb+L3tZ6sNTirPsjX8VBhR8qtNhV+ZFou8fRk4cCy+t56I7Gf4xPPcrFjBbWuDNpN8WHSzSedIGRcoiAzckPfmY4tL0SaLKWO7sDpxZ/hTBz3Lv4pvZRZS1NQsDq9Y4eri/FxuvZrssE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197182; c=relaxed/simple;
	bh=YsS09WPaGYUaj6OUyu2bWeQtwaL2DgGAVMROWn9rmNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXbcUPYhMwgCJ707ARmYoM3Hdm9W3GYZreiJU9C1eCUfzBQxxnwEiIw1HRhXJnpnSQBEzBDUkO7vq351Zu/v8QH5RaLaD34DCYnnUz81IUzQ01uwbbToYFGuZxxO92vStk0jFv8MUrHVVBlNQzI0dMg6qZ8p2rmxI87/cMhUhhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+5rhli5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+5rhli5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9681F000FF;
	Sat, 12 Sep 2026 07:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197180;
	bh=ZsOtdWatEdK/NeeXB+aoyW44U7g4GACuedN1KacX+Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+5rhli58iVEYKLYwZDgT2QrX2AnQrwJ5p5ukvk/GKnkfHtEqoqlUaosLTSSdkoMY
	 hD7hZ4nLg+iXAqOhmmQVVki5mgcdeHuWcLqv0GZh9v5zwE1jn1XsZ+Ia6seYUPi77K
	 +2irXKPBYDLsqj9komFCRYsj/yLQmCvW0ZHxreg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0118/1815] cxl/test: Add test for module parameters
Date: Sat, 12 Sep 2026 08:31:08 +0200
Message-ID: <20260912065651.781531414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit afae0fa7c6b163339a5d357942b89956a0820e45 ]

Add a test for module paraters during module init to make sure that
only one is activated.

[dj: Dropped counting fail_autoassemble modparm. (Alison) ]

Suggested-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260629221104.3891733-2-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 98ba41c3236b ("cxl/test: Propagate -ENOMEM on platform_device_alloc() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c       | 18 ++++++++++++++++++
 tools/testing/cxl/test/hmem_test.c |  3 ++-
 tools/testing/cxl/test/mock.h      |  2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index ef92dd35e030c..057724f27c6b9 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1827,11 +1827,29 @@ static struct attribute *cxl_acpi_attrs[] = {
 };
 ATTRIBUTE_GROUPS(cxl_acpi);
 
+static bool __init have_multiple_modparms(void)
+{
+	int count = 0;
+
+	if (interleave_arithmetic)
+		count++;
+	if (extended_linear_cache)
+		count++;
+	if (hmem_test)
+		count++;
+
+	return count > 1;
+}
+
 static __init int cxl_test_init(void)
 {
 	int rc, i;
 	struct range mappable;
 
+	/* Enforce a single module param active at a time */
+	if (have_multiple_modparms())
+		return -EINVAL;
+
 	if (!IS_ALIGNED(mock_auto_region_size, PMD_SIZE)) {
 		pr_err_once("mock_auto_region_size %d must be PMD-aligned\n",
 			    mock_auto_region_size);
diff --git a/tools/testing/cxl/test/hmem_test.c b/tools/testing/cxl/test/hmem_test.c
index 3a1a089e1721b..0fa00f7e16db5 100644
--- a/tools/testing/cxl/test/hmem_test.c
+++ b/tools/testing/cxl/test/hmem_test.c
@@ -3,8 +3,9 @@
 #include <linux/moduleparam.h>
 #include <linux/workqueue.h>
 #include "../../../drivers/dax/bus.h"
+#include "mock.h"
 
-static bool hmem_test;
+bool hmem_test;
 
 static void hmem_test_work(struct work_struct *work)
 {
diff --git a/tools/testing/cxl/test/mock.h b/tools/testing/cxl/test/mock.h
index 4f57dc80ae7d5..846d7c5d6eaa9 100644
--- a/tools/testing/cxl/test/mock.h
+++ b/tools/testing/cxl/test/mock.h
@@ -5,6 +5,8 @@
 #include <linux/dax.h>
 #include <cxl.h>
 
+extern bool hmem_test;
+
 struct cxl_mock_ops {
 	struct list_head list;
 	bool (*is_mock_adev)(struct acpi_device *dev);
-- 
2.53.0



