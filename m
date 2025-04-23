Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E272701A0;
	Wed, 23 Apr 2025 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419903; cv=none; b=W0cW5mXZyjB3mwb6zPIU5bcffLKWlZVuYM7eOn5swsTG4U8DHcM/c39vdXnqNsKGjZl9A4UNSpdJ3/0G36rrHdwwWbkjBPvS0Xqz4GRSvMzBkNH8hW+y89iq3T69KlBlLkjQgPMhUnftRiBKt4rEYIYp4IHdbc3XFvW641+J6eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419903; c=relaxed/simple;
	bh=5rX/37BfTYHRr469TUATse27fotc7mAyLKDRjbodyPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WWFko+25MQod4SC/Uer6mNbocxv4P+KUE/HrVkLioZXdtHEmKZDwdWCx8dz1R/AQ9ujOTqIimUMCTj1xuHjnIQWUQb7NiOXyuh5OSBmkyx5dd/Tb6u+yIXQFmltceGzaO/sPNLWvHd4k6bHQwT2AXM5GmtbNdv3D/px8gxcvGDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yd+qY0GI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yd+qY0GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6DAC4CEE2;
	Wed, 23 Apr 2025 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419902;
	bh=5rX/37BfTYHRr469TUATse27fotc7mAyLKDRjbodyPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yd+qY0GIc/ShTpJDjoW0xTMowtVBlGdDheZa0p+DPCTiNzs+Y8iUhF0I/QyY5MgP1
	 pH6OQNXXZ2umfaW7DXwwsnn5X6fXWfjBgrQD4SZlAUxIhPY4IMAGPbp9wiQKh1WOcN
	 QUQI0hb/PRU4yMUYP2hQyrmgqSp07jfOzOXMOkfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/393] drm/tests: helpers: Add atomic helpers
Date: Wed, 23 Apr 2025 16:38:34 +0200
Message-ID: <20250423142644.019377820@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 66671944e17644804cb0886489e1b8fde924e9b9 ]

The mock device we were creating was missing any of the driver-wide
helpers. That was fine before since we weren't testing the atomic state
path, but we're going to start, so let's use the default
implementations.

Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240222-kms-hdmi-connector-state-v7-2-8f4af575fce2@kernel.org
Stable-dep-of: 70f29ca3117a ("drm/tests: cmdline: Fix drm_display_mode memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_kunit_helpers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_kunit_helpers.c b/drivers/gpu/drm/tests/drm_kunit_helpers.c
index bccb33b900f39..272a3ba46d602 100644
--- a/drivers/gpu/drm/tests/drm_kunit_helpers.c
+++ b/drivers/gpu/drm/tests/drm_kunit_helpers.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <drm/drm_atomic.h>
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_kunit_helpers.h>
 #include <drm/drm_managed.h>
@@ -13,6 +14,8 @@
 #define KUNIT_DEVICE_NAME	"drm-kunit-mock-device"
 
 static const struct drm_mode_config_funcs drm_mode_config_funcs = {
+	.atomic_check	= drm_atomic_helper_check,
+	.atomic_commit	= drm_atomic_helper_commit,
 };
 
 static int fake_probe(struct platform_device *pdev)
-- 
2.39.5



