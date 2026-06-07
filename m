Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748B94071FE;
	Sun,  7 Jun 2026 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828185; cv=none; b=JKl5o4rRdckM23uks8TZhOTGecxTefv8MDA/+rfwMeps+W5l4LsWTdymzCb5APF7vv1wez3/ERxi9a/7XPSW2LcQgMjF4HNfmWna49uhoDJRW2npm6A7QNEP1VQa59Yh9GT9Yq6u/H5MhShkg0Us3z+Mq6m7GNi5DCwwYfx/w2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828185; c=relaxed/simple;
	bh=j/lvoxwl0QYqlBgu4Mp6UugVGY8xyhvVWwqCEDpoC2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LcCRiqzZrWPn1hNo4XtQRWh4oQ2FUTCVPqE2r2Lv6+Efmb1pB3G45aiRV032Z70BkzFYtC6fJe1OBHQYvLRrpFx3DaaTXogcfvRVz883Ou9J+BTEDI1UeJW4WuRL3w5mm5mCiSEHclzTl3HIBj+DIhvjAEyDLtUVnDNVaid0RHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIHW7gIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIHW7gIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7801F00898;
	Sun,  7 Jun 2026 10:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828184;
	bh=cyrTeQkUgUXdQ+YYKkV3/KNgXnbwTvfK6CJSQYBq6BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIHW7gICE1RktlSnqymmtwh6fZo5tagPqdgr8auiAJ64m1xVHMTVKlckeRg8NDJJf
	 d3iFPGH29uqEIOIJWmtWAEcZx8KuOvC0DIs8RUCd+59raV2blxbhxycvHjcoNSeA0L
	 Eu29j5Id7xZ64FLwxWPicr6jOVYzouPeCA1vs9Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/307] drm/i915/psr: Add defininitions for INTEL_WA_REGISTER_CAPS DPCD register
Date: Sun,  7 Jun 2026 11:58:35 +0200
Message-ID: <20260607095732.100232680@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Jouni Högander <jouni.hogander@intel.com>

commit fbceb39b536e40c2f7cc47ab42037bb7c2b7ced9 upstream.

EDP specification says:

"If either VSC SDP is unable to be transmitted 100 ns before the SU region,
the Source device may optionally transmit the VSC SDP during the prior
video scan line’s HBlank period There is a Intel specific drm dp register
currently containing bits related how TCON can support PSR2 with SDP on
prior line."

Unfortunately many panels are having problems in implementing this. So
there is a custom Intel specific DPCD register (INTEL_WA_REGISTER_CAPS) to
figure out if this is properly implemented on a panel or if panel doesn't
require that 100 ns delay before the SU region. Here are the definitions in
this custom DPCD address:

0 = Panel doesn't support SDP on prior line
1 = Panel supports SDP on prior line
2 = Panel doesn't have 100ns requirement
3 = Reserved

Add definitions for this new register and it's values into new header
intel_dpcd.h.

v2: add INTEL_DPCD_ prefix to definitions

Bspec: 74741
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260515095756.2799483-2-jouni.hogander@intel.com
(cherry picked from commit 1da1c9294825f08f622c473480d185680c2a3b75)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dpcd.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 drivers/gpu/drm/i915/display/intel_dpcd.h

diff --git a/drivers/gpu/drm/i915/display/intel_dpcd.h b/drivers/gpu/drm/i915/display/intel_dpcd.h
new file mode 100644
index 00000000000000..4aea5326f2ed48
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_dpcd.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2026 Intel Corporation
+ */
+
+#ifndef __INTEL_DPCD_H__
+#define __INTEL_DPCD_H__
+
+#define INTEL_DPCD_INTEL_WA_REGISTER_CAPS					0x3f0
+# define INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_EARLYSCANLINE_SDP_SUPPORT_MASK	REG_GENMASK(1, 0)
+# define INTEL_DPCD_INTEL_WA_REGISTER_CAPS_FALL_BACK_TO_PSR1			0
+# define INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_WITH_EARLY_SCANLINE		1
+# define INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_WITHOUT_EARLY_SCANLINE		2
+
+#endif /* __INTEL_DPCD_H__ */
-- 
2.53.0



