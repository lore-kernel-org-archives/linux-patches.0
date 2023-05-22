Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2445171B7
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9C3C4339B;
	Mon, 22 May 2023 19:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784306;
	bh=evjCGMfKp7PC5/x9avug2wU2xLo5VPskx9pMUgNEp2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYvg9dGKpTk/++Mrk8qTcYmLCFaltKZEgdGY8x60fx4t6DOY9OmnvDEr/qLfMO0f/
	 QOz4HE9m+5FiQQWzLzD4rakI1fzpVNriFPD3TMQjmGPkZNrGZ8p7l9/QcWchWNpYG5
	 QTfz7GwmgMwp0VJOI+SHEdgkz3r3MP6eWH/4Te7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 031/364] drm/i915/guc: Dont capture Gen8 regs on Xe devices
Date: Mon, 22 May 2023 20:05:36 +0100
Message-Id: <20230522190413.611501523@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 275dac1f7f5e9c2a2e806b34d3b10804eec0ac3c ]

A pair of pre-Xe registers were being included in the Xe capture list.
GuC was rejecting those as being invalid and logging errors about
them. So, stop doing it.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Fixes: dce2bd542337 ("drm/i915/guc: Add Gen9 registers for GuC error state capture.")
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230428185636.457407-2-John.C.Harrison@Intel.com
(cherry picked from commit b049132d61336f643d8faf2f6574b063667088cf)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index 710999d7189ee..8c08899aa3c8d 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -30,12 +30,14 @@
 	{ FORCEWAKE_MT,             0,      0, "FORCEWAKE" }
 
 #define COMMON_GEN9BASE_GLOBAL \
-	{ GEN8_FAULT_TLB_DATA0,     0,      0, "GEN8_FAULT_TLB_DATA0" }, \
-	{ GEN8_FAULT_TLB_DATA1,     0,      0, "GEN8_FAULT_TLB_DATA1" }, \
 	{ ERROR_GEN6,               0,      0, "ERROR_GEN6" }, \
 	{ DONE_REG,                 0,      0, "DONE_REG" }, \
 	{ HSW_GTT_CACHE_EN,         0,      0, "HSW_GTT_CACHE_EN" }
 
+#define GEN9_GLOBAL \
+	{ GEN8_FAULT_TLB_DATA0,     0,      0, "GEN8_FAULT_TLB_DATA0" }, \
+	{ GEN8_FAULT_TLB_DATA1,     0,      0, "GEN8_FAULT_TLB_DATA1" }
+
 #define COMMON_GEN12BASE_GLOBAL \
 	{ GEN12_FAULT_TLB_DATA0,    0,      0, "GEN12_FAULT_TLB_DATA0" }, \
 	{ GEN12_FAULT_TLB_DATA1,    0,      0, "GEN12_FAULT_TLB_DATA1" }, \
@@ -141,6 +143,7 @@ static const struct __guc_mmio_reg_descr xe_lpd_gsc_inst_regs[] = {
 static const struct __guc_mmio_reg_descr default_global_regs[] = {
 	COMMON_BASE_GLOBAL,
 	COMMON_GEN9BASE_GLOBAL,
+	GEN9_GLOBAL,
 };
 
 static const struct __guc_mmio_reg_descr default_rc_class_regs[] = {
-- 
2.39.2



