Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7351E048E;
	Wed,  6 Nov 2024 12:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896504; cv=none; b=NFIs0idLNkq6CE6VThJtmx/8QeKpqiY9JEZpDl9ceFr5tPIyQuaLiR9tnibKYQ6MNFT8Pwds3kzJnI+FJOV7dMbUEAyhT2UaRmRMsiDW5dVszuTQPjn4CAnJbIN8zWpgcLCbrb3jKp2hPrU148p725o5RKk+9LvyaANR5Tms9Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896504; c=relaxed/simple;
	bh=bu2dBFprwhnN0H1Eo+J04x8YPQS76XalEyg345nKgiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQY0sloA4u8IJsSeT2yJuFJWF2sR+8TLJ3cUcnv9BJrtfRBzZvTyNPQjnAcWcmFPx6m6DUj3myeA5vRY6BwviF1WrhXe2O78hIQggUWCr3ggxoKWO407drkXaL8sdTgvyx4q8FzzQT69Zwb8cbv5yDvLDCjzmLqIaHuDEnVheAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSQbxje1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSQbxje1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C05C4CECD;
	Wed,  6 Nov 2024 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896504;
	bh=bu2dBFprwhnN0H1Eo+J04x8YPQS76XalEyg345nKgiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSQbxje1VMN4NHPVOLpSy/XlWiJN8AwqDpEhZk7GpYSbqB8vUD31qPUnjTHUH+Yix
	 sWDfro1PneVGDJ5yYWMdg16Vur+PelWr5JxErSjt5dWl0+6XAvYsL6v2ZCmX2Vb42Z
	 R1X/AG6b+YTx+gtsXIqayH3fyLcmFHzduxm7mCMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Nemesa Garg <nemesa.garg@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 224/245] drm/i915/display: WA for Re-initialize dispcnlunitt1 xosc clock
Date: Wed,  6 Nov 2024 13:04:37 +0100
Message-ID: <20241106120324.771903406@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>

commit 7fbad577c82c5dd6db7217855c26f51554e53d85 upstream.

The dispcnlunit1_cp_xosc_clk should be de-asserted in display off
and only asserted in display on. As part of this workaround, Display
driver shall execute set-reset sequence at the end of the initialize
sequence to ensure clk does not remain active in display OFF.

--v2:
- Rebase.
--v3:
- Correct HSD number in commit message.
--v4:
- Reformat commit message.
- Use intel_de_rmw instead of intel_de_write
--v5:
- Build Fixes.

WA: 15013987218
Signed-off-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Reviewed-by: Nemesa Garg <nemesa.garg@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240708083247.2611258-1-mitulkumar.ajitkumar.golani@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_power.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -1704,6 +1704,14 @@ static void icl_display_core_init(struct
 	/* Wa_14011503030:xelpd */
 	if (DISPLAY_VER(dev_priv) == 13)
 		intel_de_write(dev_priv, XELPD_DISPLAY_ERR_FATAL_MASK, ~0);
+
+	/* Wa_15013987218 */
+	if (DISPLAY_VER(dev_priv) == 20) {
+		intel_de_rmw(dev_priv, SOUTH_DSPCLK_GATE_D,
+			     0, PCH_GMBUSUNIT_CLOCK_GATE_DISABLE);
+		intel_de_rmw(dev_priv, SOUTH_DSPCLK_GATE_D,
+			     PCH_GMBUSUNIT_CLOCK_GATE_DISABLE, 0);
+	}
 }
 
 static void icl_display_core_uninit(struct drm_i915_private *dev_priv)


