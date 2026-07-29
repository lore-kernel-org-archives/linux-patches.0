Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241CF390231
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346092; cv=none; b=dA1exFkJkhbnTHkKrTEPmdtjmOMG3O+sog3LfLi0e2b/kk9W7tBxzEnJULGPsHs9K3BgtTywrUrIcQ18ThdcM1YFd9gykMTU1cYrKJhrcelx8WXUlugOjatc2/5NBGYWJP6cJRTLk12csWutOdEloySdB9ZUPL/n9mqlBB8RNIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346092; c=relaxed/simple;
	bh=4BoKs1od+Gv5HH07yihtTbqfbNKVweeOxorcymMBGFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYWfidnOfx0CPHYmy6Xu+Qk5ogqWB1UIITjkKsHFpzkDLAM6E1cdZiIKFkI7G2cU+cqGLPdIMomEOEofUiQdZ0JyKr/+dKU0VfoJ3gr5Kusu6xVK/Z0wErUdp4KH1dhvnMnvtGKRS7dQvZ5X+3J0oiZUwoeEE6wCnF5oXUpItzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NTXRhVqN; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NTXRhVqN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346090; x=1816882090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4BoKs1od+Gv5HH07yihtTbqfbNKVweeOxorcymMBGFk=;
  b=NTXRhVqNEBSHgz61I+qk2SWYiJ5012CsPmRJCuxFDzwL/fX4FACuV/8U
   F4q1Nqu8bL7HDsoFfL14SsOAtM2khLWOPHpafqaQJtAe2H9HpMp3L66Bp
   xCyC2/8ds1JMuekV7g2prnDD7TNOcIg5sZ7CHz7d0Q10gEx2PLPOvcRr0
   hO2/SmdrOy7RXujBsg2xqXPrVerFnZF242Zg4gyQTD+/u7z5y40gg0Ow/
   8nPMivGfwOYvWmyrYz53h/5pu4cnqMzYKtROCCNqVNmT3F88SQXmNRWgW
   rFkdFXIrBuGbLSBnnUP0rXtvHXf/eTIDUnu3Q2QzjaWzBNBCELyeODYPK
   w==;
X-CSE-ConnectionGUID: qyXZ7RlHRcmccVfD6mj8EA==
X-CSE-MsgGUID: uWDOq/WhT9K38DHZXxJH6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473648"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473648"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:02 -0700
X-CSE-ConnectionGUID: FbG+LTywRreyI0YR1IJK/A==
X-CSE-MsgGUID: +HrO8dpbQHCWCcaK9Yb3hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024596"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:02 -0700
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
Subject: [PATCH v10 10/17] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Wed, 29 Jul 2026 10:27:45 -0700
Message-ID: <20260729172752.11561-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
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
v10:
	No need for <asm/resctrl.h> now that declarations of
	intel_aet*() moved to <linux/intel_vsec,h>

 drivers/platform/x86/intel/pmt/telemetry.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index 953f35b6daec..cafa2288600d 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -427,16 +427,26 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
 	.id_table	= pmt_telem_id_table,
 	.remove		= pmt_telem_remove,
 	.probe		= pmt_telem_probe,
+	.driver = {
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
+	},
 };
 
 static int __init pmt_telem_init(void)
 {
-	return auxiliary_driver_register(&pmt_telem_aux_driver);
+	int ret = auxiliary_driver_register(&pmt_telem_aux_driver);
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

