Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443059;
	b=tqRxl3bNFONY9sVz+MuE2ZYMWcroIidF/8h3QvbueqLe1LjmDX3LMt98MitECAW3w6Aw
	 lfCMSgRb5yubT8RJ0A3knoZy6sWXzQPhjzc136kII44jK9P9zC2IAhSxxo/JlYBLTdypb
	 +RuUvoLGk9IgtMat/LFYnrPzSq2pQuRYSm1QVMqhHmjaXg0p+eQ9qctoZ13mTig1PZ+Xu
	 j+DfvV9uMmWzHlPp3oFc/+YdoF4qBQHoiPw9DK1Do1/+++wCxrAAuTLaOAuTFatXNfNJG
	 0T4Zh2AmN9HMnNCcPmUXl7+T1F4ymc4Vppb4HxucnHikB38E0TI//u9DLifBd0rtvWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443059;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k0i/N1b5yWNh2DrHfWtbHgv/fVPwrlaI2gnbJ6ty73w=;
	b=QOaCs8+9oYMDmfA8ur69J4GOxhUjgsVU8lAp39L3AwcOY/lyfX4lTKhzmyp+IjYrgoDl
	 hEEQB7tlnffGcgX11pg5lPq+dQy4ScPBWgAxQGP2cJVoFPyDuFJOPkke/Uq0hcKqvDQSV
	 cz8UBzcoSczJaub70Ybb2XJ1hqdhrwmqpVXRxRkL167ete4dj8Ai8ePxU3M9Oxn00EFwR
	 BD6pm2/Pq9/9f8iXNAn8HzmApCYhMbewrHJsMG5VA34UvyBt0K5IL0FReeqVuW1OGd9qa
	 Cw3hHssxC8V7H3u/AeUohWIcfjoI2gscpuXo3cifKdnJEiHlx8anY3Mqh+rKecVIZXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="T6UVt/b5";
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F26606A31D
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47F26606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T6UVt/b5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443059; x=1823979059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xsbwNdGGLJOC/4bW7nqSY811th/00q9A8AGx07zDNwk=;
  b=T6UVt/b5jfEQDtwcUEBAIuUa+7r3S+4ON0gwUWDebHoJEz2Dv41nstAo
   04crATmdm9G0bXaESXeyQmtTcyOVJgD0kJWndWVZBkf1p7nT/GaGfNcTV
   JYhBnm2cPo4HrbCsp2XZrQcq3Bvt/GazjoMl5L8f+0ZxmqdJVAXS9LNsL
   VdRXNgD+YOqTfD/K/LfdfD3hYM6ra3enljIa7daChwIy+UHFdRolHenP9
   3ROGU2Y+qJO4AxuiiHs11H9Wt1zbgpgkjujLUeep7q0+T/RfR9rxGtg1Y
   U5q+yG+Y8QIrjXtIfABlwnW3v0fKerRgVP4rPBsdP7tR2tb6yAoG8pNTD
   w==;
X-CSE-ConnectionGUID: 1KyKkI1gSmi1y1SIutFVwQ==
X-CSE-MsgGUID: DENFPi95SDGbW1ZqjB7dIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131253"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131253"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:51 -0700
X-CSE-ConnectionGUID: Js7ajy48RSW4+vvWNL3+WQ==
X-CSE-MsgGUID: CkT+Jh2ARPG0Nemy2BI1kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008671"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:51 -0700
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
Subject: [PATCH v14 16/24] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Mon, 19 Oct 2026 13:50:23 -0700
Message-ID: <20261019205031.16977-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl enumerates Application Energy Telemetry (AET) features by calling
pmt_telemetry functions directly, which requires pmt_telemetry to be built
in. resctrl now provides functions with which pmt_telemetry can register
those enumeration functions instead.

Register the enumeration functions with resctrl when pmt_telemetry is
loaded, in preparation for resctrl calling them through the registration
and for pmt_telemetry being built as a module.

Register only after the driver has probed all telemetry devices so that resctrl
does not enumerate a partial set. Force synchronous probing to avoid issues
if kernel command line or module parameter requests asynchronous operation.

Unregister the enumeration functions before tearing down the telemetry
devices on unload, so that resctrl cannot start enumeration while they are
being removed.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	New commit message.
---
 drivers/platform/x86/intel/pmt/telemetry.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index 953f35b6daec..57eb2967a4d0 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -427,16 +427,29 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
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
+	if (ret)
+		return ret;
+
+	intel_aet_register_enumeration(THIS_MODULE, intel_pmt_get_regions_by_feature,
+				       intel_pmt_put_feature_group);
+
+	return 0;
 }
 module_init(pmt_telem_init);
 
 static void __exit pmt_telem_exit(void)
 {
+	intel_aet_unregister_enumeration();
 	auxiliary_driver_unregister(&pmt_telem_aux_driver);
 	xa_destroy(&telem_array);
 }
-- 
2.56.0

