Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A71126AF3
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 21:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756847758; cv=none; b=F0WY0u5ymRi5Oh+rrsLJ+joK9Mx8FxmDM3Yr5RV2HajesAoQp00Re6sVTuYbdHXJtSko/+2V8KiD2btoGjWBnMZUzkv9UMUg/7p/VYxugYmVeJCmRvWM00EiENthyPRx3QgvXZOKBHCh8TS48CaS+O6H44yhHM3pJ3xUPhzoHuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756847758; c=relaxed/simple;
	bh=95tkdMDuso5OG/9KbTm4H+ptGB07aLJvYeRM1Q04jNU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=FVo74wucIbxyDWClgcV77HqBw9f8gv0pVXvPjyy7I80fPOSPdroWOnhhblATb2wnJazgn68VOrQIRYFrFDIG2fgivz9a/RCAaI3MMfPj8KEi5HI3rBL757qhOrTclHHDAcMX6OvnVXHeaBbRPTLNcZnGELqREmJ9PhnFi4/TzlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdX4OJxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdX4OJxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD06C4CEED;
	Tue,  2 Sep 2025 21:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756847758;
	bh=95tkdMDuso5OG/9KbTm4H+ptGB07aLJvYeRM1Q04jNU=;
	h=From:Date:Subject:To:Cc:From;
	b=JdX4OJxzQt/QhxWqIsxxUQwA43kiBUlJL7d2tqHaHNgTvR+AT5CUdn629cKsQZ3Ej
	 2vFaKUv9Bh0aXWhfL+MDzdMTUStrtik7S24otrzCvsB6ghP5NZ6v0QTRlJyL/wJ+xv
	 kWoB4Zq1brbwRMpPcfrfhrGgDdhaItnO1q6kPle6ocnJjHBHFYMl1NynCsOBNW+aYJ
	 ftbXM+euNtf6MQRhY2fiBUNZLzJqwo0xQEzSz5wZO1Cspu3hS3KrAUK+E2poQR8+ya
	 ulUfsV043ZZAOonMMkL7X3WIgdj1RCfucGDge1+mSwUX1wPBqdNUNgP3iVgM4uyZQq
	 Z/cewRXtq4jzA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 02 Sep 2025 14:15:50 -0700
Subject: [PATCH] drm/tidss: dispc: Explicitly include bitfield.h
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-drm-tidss-fix-missing-bitfield-h-v1-1-aaad4a285f98@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIVet2gC/x2NwQqDMBAFf0X27MIm2hb7K+JBzaoPNJaslIL47
 4YeB4aZk0wT1OhdnJT0C8MeM7iyoHHp46yMkJm8+Ic04jmkjQ8EM57w4w1miDMPOCboGnjhZhC
 p9emq/uUoZz5Js/lftN113fSkYLByAAAA
X-Change-ID: 20250902-drm-tidss-fix-missing-bitfield-h-9b004e613a71
To: Jyri Sarha <jyri.sarha@iki.fi>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2161; i=nathan@kernel.org;
 h=from:subject:message-id; bh=95tkdMDuso5OG/9KbTm4H+ptGB07aLJvYeRM1Q04jNU=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnb43pqHyT8+RekoOh2w6RTNrKwN0RfJiBS6PqhPp7vr
 ZN/7VjRUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACaS1crI8LIqoXqdgDWX681C
 W7MNiRFqKyZ9Wb3UddbUM7ZyTleDUhkZprpcv+P1PEvmo+m1v19Z1W9/SF+3ZfENka4DbROmuAW
 WcAEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent series to use FIELD_PREP and FIELD_MODIFY in
tidss_dispc.c, there are many errors when bitfield.h is not implicitly
included, such as when building allmodconfig for ARCH=hexagon:

  drivers/gpu/drm/tidss/tidss_dispc.c:1116:2: error: call to undeclared function 'FIELD_MODIFY'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
   1116 |         VP_REG_FLD_MOD(dispc, hw_videoport, DISPC_VP_CONTROL, v,
        |         ^
  drivers/gpu/drm/tidss/tidss_dispc.c:631:3: note: expanded from macro 'VP_REG_FLD_MOD'
    631 |                 FIELD_MODIFY((mask), &_reg, (val));                     \
        |                 ^
  drivers/gpu/drm/tidss/tidss_dispc.c:1140:2: error: call to undeclared function 'FIELD_MODIFY'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
   1140 |         FIELD_MODIFY(DISPC_VP_DSS_OLDI_CFG_MAP_MASK, &oldi_cfg,
        |         ^
  drivers/gpu/drm/tidss/tidss_dispc.c:1203:10: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
   1203 |                        FIELD_PREP(DISPC_VP_TIMING_H_SYNC_PULSE_MASK, hsw - 1) |
        |                        ^
  ...

Explicitly include bitfield.h to resolve the errors.

Fixes: 9accc8b10de8 ("drm/tidss: dispc: Get rid of FLD_VAL")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 97e2cd7b1e20..7c8c15a5c39b 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -4,6 +4,7 @@
  * Author: Jyri Sarha <jsarha@ti.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>

---
base-commit: 306734a1c76ce35fa613ea823a31ddbcdbf1eef5
change-id: 20250902-drm-tidss-fix-missing-bitfield-h-9b004e613a71

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

