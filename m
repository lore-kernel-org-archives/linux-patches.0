Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC621863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A5DC433D2;
	Wed, 28 Dec 2022 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242538;
	bh=T7hT4a7GPAyQmZCF3BKZH3BCGdsLcX2t0ZMHj9GOTXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmgzdLQ5uzMoTcuodGcn/4tLdRgb5hBd8tkRyn93HklHR3TRRlHAqJmxLGgOv6gdR
	 GeaxnLXAr6gafceK643HYq481A8HEhXJmI9LHUzaEPI3dtmEDuW8N9qDJnVvk37fwT
	 899MSqkADMGxNiw6vNNqfX2UtCOP0QOtF3jbB4ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0381/1146] drm/i915/guc: make default_lists const data
Date: Wed, 28 Dec 2022 15:32:00 +0100
Message-Id: <20221228144340.515439559@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit dfa5e6ef3ccefff9fa8a70d9f5fa6ef6244aa312 ]

The default_lists array should be in rodata.

Fixes: dce2bd542337 ("drm/i915/guc: Add Gen9 registers for GuC error state capture.")
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221122141616.3469214-1-jani.nikula@intel.com
(cherry picked from commit 8b7f7a9b10b704ba7d73199ff0f01354e0bad7a5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index 2b75b2d53383..685ddccc0f26 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -165,7 +165,7 @@ static const struct __guc_mmio_reg_descr empty_regs_list[] = {
 	}
 
 /* List of lists */
-static struct __guc_mmio_reg_descr_group default_lists[] = {
+static const struct __guc_mmio_reg_descr_group default_lists[] = {
 	MAKE_REGLIST(default_global_regs, PF, GLOBAL, 0),
 	MAKE_REGLIST(default_rc_class_regs, PF, ENGINE_CLASS, GUC_RENDER_CLASS),
 	MAKE_REGLIST(xe_lpd_rc_inst_regs, PF, ENGINE_INSTANCE, GUC_RENDER_CLASS),
-- 
2.35.1



