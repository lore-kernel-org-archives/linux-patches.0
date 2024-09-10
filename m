Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EC118595E;
	Tue, 10 Sep 2024 09:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962216; cv=none; b=fLdNcI1UbF8OPV6gj+a1PxHNUK0JSxi2Tdj1A4rcTC95zygLk5cMhG8eh8UPZ+LL4ifgcsVuoEvVn7JCBdmeSfNJVhLJ/4V8Pv0+StLDtTXwMI6hylkKPFyKa1PRVdFPuuEelAj7swGrweTPE1uOeooB9M/5U25w9AdQG+ckgcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962216; c=relaxed/simple;
	bh=rAZn397ZojRYl4629UiRxJtswdUZWdRekan0kvDJWhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuL0RDTfJ5oHrR4DhQml2f5FX+IfM5WiUWszIR0tClUQox5xSFrsPIh5ULxFXkfyxFH0Rs+tdlNmC49JW1Yhlghs0NExpLtH3M+JRdgIFA1Qw+a1NnDkcIT49NFM2sJWjuodPWdVMfVuF4O/w7O31rOHqcLURjyskMXfVUu0dVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqwI3her; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqwI3her"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338C6C4CEC3;
	Tue, 10 Sep 2024 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962216;
	bh=rAZn397ZojRYl4629UiRxJtswdUZWdRekan0kvDJWhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqwI3herOfRpl27JCe0uXdKtn7hMjTNDQUVKI3x0++N78UN7ACyUO7Pm+xUlCUFKG
	 qSm+ugoreKjMIcDnbF9/skCtdp/0ItRGhQcjqpHkYVPXDCmYZlKPVyy69V1QdQHIYM
	 Jxd0qt3EO0JzMXfqwdsaJ+maNQ9Uv8vZOz8DIKlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bommu Krishnaiah <krishnaiah.bommu@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 334/375] drm/xe/xe2: Add workaround 14021402888
Date: Tue, 10 Sep 2024 11:32:11 +0200
Message-ID: <20240910092633.800605226@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bommu Krishnaiah <krishnaiah.bommu@intel.com>

[ Upstream commit 598dc939edf8d7bb1d69e84513c31451812128fc ]

This workaround applies to Graphics 20.01 as RCS engine workaround

Signed-off-by: Bommu Krishnaiah <krishnaiah.bommu@intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240418111534.481568-1-krishnaiah.bommu@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: b196e6fcc711 ("drm/xe/xe2lpg: Extend workaround 14021402888")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 1 +
 drivers/gpu/drm/xe/xe_wa.c           | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 94445810ccc9..23c302af4cd5 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -350,6 +350,7 @@
 
 #define HALF_SLICE_CHICKEN7				XE_REG_MCR(0xe194, XE_REG_OPTION_MASKED)
 #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
+#define   CLEAR_OPTIMIZATION_DISABLE			REG_BIT(6)
 
 #define CACHE_MODE_SS				XE_REG_MCR(0xe420, XE_REG_OPTION_MASKED)
 #define   DISABLE_ECC				REG_BIT(5)
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index dd214d95e4b6..303f18ce91e6 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -533,6 +533,10 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(LSC_CHICKEN_BIT_0, WR_REQ_CHAINING_DIS))
 	},
+	{ XE_RTP_NAME("14021402888"),
+	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(HALF_SLICE_CHICKEN7, CLEAR_OPTIMIZATION_DISABLE))
+	},
 
 	/* Xe2_HPM */
 
-- 
2.43.0



