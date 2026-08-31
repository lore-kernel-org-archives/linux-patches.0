Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C2E47DF8B
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198286; cv=none; b=NqTyYB5Kxs+NIwX6VwrJ18xRx7OfxXlKlwcqggyMA6TwjdFgdsnEj9fyQ0ckzHWl8glj77KiMesV35ZM+Ic2c5Skn+51bD3YSezJZCr3oVst5DIXCjXpqPnKMESATjmlrKH4Y/QMcrxoBZ9i28hlFtlEcIpGzbOGMYDLk9b+YYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198286; c=relaxed/simple;
	bh=+u+EvE+NfRiQbNrCgeYd4kTis6EGnyXUS5dn2VV8Rm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+lh0u18F+vAMl9UZ/bdP16/mXkbGd6tjqVpvxJFwbXaT9bquCVthLL8BavxELLcNakkzH2VHxpt1Iq5PnzgW0f5OW8i+XgdapXKeHt4I0pdfpm7T6ud0m5xAn3l81Ndodt+c8XvLdMK+6sUeQZLI0YriUcp4aUwF4mgMH3bvSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TfUiCbCo; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TfUiCbCo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198285; x=1819734285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+u+EvE+NfRiQbNrCgeYd4kTis6EGnyXUS5dn2VV8Rm0=;
  b=TfUiCbCoxxwRSxgsOhPgyfJXHViXSLtWkKP/moMppJiflkg2rCWdy4bm
   XOflNmxXJpt27T4utUOdrlWIeaRz8o9TVAjUlhtNXYCQ88qN/7d/m0ANP
   qA+AHIT58SIJNMlV4FGvCOBlMIn5JXZsJLIBz9x4AhLJgAk38zPDkWl2c
   PShaDMHwmeme/FDV0cCue9Ep1skt5EAIQlPxF6e5xf79ssoXvjWLV+1Ep
   639gOUNCO5AZjlDlOCeVfH5JnJ7WgvN4YFNVhUR6wDC4+JdPEnY+PEo3S
   dbv8pZAwlGd09BB4fbo306qQR8zaviSAZdkbCRcrHBGwAaiSI7d7sgUiA
   A==;
X-CSE-ConnectionGUID: Pwd+xeBsTsO8GE5nmSBGew==
X-CSE-MsgGUID: NAMbRl0STZ2bVNev3i+Fsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480063"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480063"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:40 -0700
X-CSE-ConnectionGUID: mk/m8oInT4Sn/Et4Av32Gg==
X-CSE-MsgGUID: YXKQ7hTtR5WWycmoh4GeTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268907005"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 16/23] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Mon, 31 Aug 2026 10:44:14 -0700
Message-ID: <20260831174421.13921-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
call PMT functions directly.

Use ".probe_type = PROBE_FORCE_SYNCHRONOUS" to ensure sequential, synchronous
calls to per-device .probe() functions.  Register the telemetry enumeration
function pointers at the end of pmt_telem_init() when all .probe() functions
have run and enumeration is complete.

Unregister at the start of pmt_telem_exit() before teardown of the
auxiliary drivers.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	Add TAB to line up '=' in .driver initialization

 drivers/platform/x86/intel/pmt/telemetry.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index 953f35b6daec..2d2282c636b2 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -427,16 +427,28 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
 	.id_table	= pmt_telem_id_table,
 	.remove		= pmt_telem_remove,
 	.probe		= pmt_telem_probe,
+	.driver		= {
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
+	},
 };
 
 static int __init pmt_telem_init(void)
 {
-	return auxiliary_driver_register(&pmt_telem_aux_driver);
+	int ret;
+
+	ret = auxiliary_driver_register(&pmt_telem_aux_driver);
+
+	if (!ret)
+		intel_aet_register_enumeration(THIS_MODULE, intel_pmt_get_regions_by_feature,
+					       intel_pmt_put_feature_group);
+
+	return ret;
 }
 module_init(pmt_telem_init);
 
 static void __exit pmt_telem_exit(void)
 {
+	intel_aet_unregister_enumeration();
 	auxiliary_driver_unregister(&pmt_telem_aux_driver);
 	xa_destroy(&telem_array);
 }
-- 
2.55.0

