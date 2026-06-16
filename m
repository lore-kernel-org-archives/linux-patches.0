Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC7147AF4D;
	Tue, 16 Jun 2026 17:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630825; cv=none; b=hXL6KfUIgRL6o7CHD3t26z1FUSJ+1IbXvGM+zEP3ZNmB3ruKwwgibyJwIbUwI7zDpqv2lSLCCteM8HiKCSezedhOe1MlBORCufcffczevLiU+A1FZDCKjMIqv8cJ3kfUeYSyPNkar4ptioQsfQPElxQfALy45GomT1oTveGSq0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630825; c=relaxed/simple;
	bh=GlPoG09RXM1p4t6/6QPNpCZdtCTE5S4yh+5shb19n/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJybNaeXVZO7Zz80LXiA6RIPsHozee9hQX2ZuuoSMSG9CoCCnuB/F3i2NvFcovxxu1EU8PZO/WlUv2aIurvrxVgXRyKAUwKEaUo31OJ2YgqnsKp+lfvCM9gKSQyFlWfv0QMc0SpDG3MyJQ0gz81NLdbl8KM8NoNlIeRiKh1O8PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnuN/PbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnuN/PbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB5D1F000E9;
	Tue, 16 Jun 2026 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630823;
	bh=e/+khx6Bl+KnTwBLvkwkm0X2sAihxhB3LCrPJ1g6nsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnuN/PbWBm6GYLdJrGT0dxVtUoO/Nb+Lw6Kkis5CHhhMCcd4IQ6WYxd+I5/SZK3I7
	 dwNKC9WQ8IlE9Q0cr/Au19s4Bv1RypGucIVKOf9MlniT3JroEBWopGgiz0R+wrzAeE
	 K7RSo+y6d6V4vB1iK/Kj5814xnhrEmQQj4qbEvRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/522] drm/i915/psr: Add defininitions for INTEL_WA_REGISTER_CAPS DPCD register
Date: Tue, 16 Jun 2026 20:23:37 +0530
Message-ID: <20260616145129.102260676@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



