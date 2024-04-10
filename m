Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9566D179663
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712772979; cv=none; b=S9njTPA1XoKv1QK9IY2vGuF0Hp21G/ReRgxoRtDI16tidbdx74VWXtSefoVrOYET5/yqieBSs0qgN80PzZji2NmGegS58NWOLzcFvaGLGPzPzwgL9ps4nPaG+PxqMPl1mM0Ys2hMAxKgGY9jXuYc7Kin7LCAA7ZXPNHk9oGS4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712772979; c=relaxed/simple;
	bh=T6FDQ9/zu1oIbZVeNcOfG/Z9gH7NMMRviW2kjsRd8XU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gpeJgT+Ju+FQJlhUq83AikRD1ZFn3wP74emHuL1r82e0HnO/JjXUraK1JrDKCF7DyQhYl8/OvHbkPpLfu7/kp2ccDL4ngFBUNGBZgyjG8+DQ6hqPAEfwEOQc01p9AQW8sWnl7jiEp44dzFIF1QPhzkyUT1xTnPRGK01PBo6Q1Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPRG8Ala; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPRG8Ala"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC8EC433C7;
	Wed, 10 Apr 2024 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712772979;
	bh=T6FDQ9/zu1oIbZVeNcOfG/Z9gH7NMMRviW2kjsRd8XU=;
	h=From:Date:Subject:To:Cc:From;
	b=iPRG8Alaw0/2dS/FOiq3Nj/dp4rf0e/GEooOQ8icwH6V0jsyA+U7ie6QXaJnkba+d
	 Ta2yk5RDU2BiVZpKR4VT98CcSszKNdZ0I+PMxfPnKtKjbiop+/otRQZU+nWImPME1V
	 UGl6ka6Exb71oJ8fPgK/ieCQioCznuQ+IihPzprgQ1do+HyTc3lILnXwAnfO456G7/
	 /StFOw+YsDmuGcQVMmd9vdpzcKRMWs4zyy/GlSNCbkSPjEoOPHquYV3qyoHdPSXKxc
	 1CCrjFiyAidZ3FYAaPdRpCXyIMVwMhuIcnWi7DJuFGehrQyx5s/kBQRaR25q7jr/iW
	 D6E6TT/to1gdQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 10 Apr 2024 11:16:11 -0700
Subject: [PATCH] drm/xe: Add xe_guc_ads.c to uses_generated_oob
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240410-drm-xe-fix-xe_guc_ads-using-xe_wa_oob-v1-1-441f2d8e5d83@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGrXFmYC/x2NTQqDMBCFryKz7kBiXahXKSXEZBpnYVIyaAXx7
 o5dPb7H+zlAqDIJjM0BlTYWLlnBPhoIs8+JkKMytKbtTGcNxrrgTvjhXcWlNTgfBVfhnG7j510
 pEw5heg4atz72oFvfStr4/7ze53kB7eO/IHcAAAA=
To: lucas.demarchi@intel.com, ogabbay@kernel.org, 
 thomas.hellstrom@linux.intel.com
Cc: John.C.Harrison@Intel.com, badal.nilawar@intel.com, 
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1613; i=nathan@kernel.org;
 h=from:subject:message-id; bh=T6FDQ9/zu1oIbZVeNcOfG/Z9gH7NMMRviW2kjsRd8XU=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGli14ukt/81DNkqZNy1adEhxs2VT1dbTNC5YrQqJiznc
 mn2og96HaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiCzYz/K/5fj5rd67W7HPy
 1pvmH+3aFnxQWm9O94LHm/6X916SurWYkeHySx6eh/sZ67LYvlxIqKhOCF740vXTKqtSjr4VRtN
 9z7MBAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

A recent change added a use of xe_wa_oob.h without adding the file that
uses it to uses_generated_oob, which means xe_wa_oob.h does not get
properly generated before attempting to build the object file:

    LINK     resolve_btfids
    CC [M]  drivers/gpu/drm/xe/xe_guc_ads.o
  drivers/gpu/drm/xe/xe_guc_ads.c:10:10: fatal error: generated/xe_wa_oob.h: No such file or directory
     10 | #include <generated/xe_wa_oob.h>
        |          ^~~~~~~~~~~~~~~~~~~~~~~

After adding '$(obj)/xe_guc_ads.o' to uses_generated_oob, xe_wa_oob.h is
always generated before building the file, resulting in no errors:

    LINK     resolve_btfids
    HOSTCC  drivers/gpu/drm/xe/xe_gen_wa_oob
    GEN     xe_wa_oob.c xe_wa_oob.h
    CC [M]  drivers/gpu/drm/xe/xe_guc_ads.o

Fixes: c151ff5c9053 ("drm/xe/lnl: Enable GuC Wa_14019882105")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/xe/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/Makefile b/drivers/gpu/drm/xe/Makefile
index e106767c9a6e..60c90dc918b2 100644
--- a/drivers/gpu/drm/xe/Makefile
+++ b/drivers/gpu/drm/xe/Makefile
@@ -49,6 +49,7 @@ $(obj)/generated/%_wa_oob.c $(obj)/generated/%_wa_oob.h: $(obj)/xe_gen_wa_oob \
 uses_generated_oob := \
 	$(obj)/xe_gsc.o \
 	$(obj)/xe_guc.o \
+	$(obj)/xe_guc_ads.o \
 	$(obj)/xe_migrate.o \
 	$(obj)/xe_ring_ops.o \
 	$(obj)/xe_vm.o \

---
base-commit: 9c1857d587e91dfc10875a8c1083360db047404f
change-id: 20240410-drm-xe-fix-xe_guc_ads-using-xe_wa_oob-9cb394101ad8

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

