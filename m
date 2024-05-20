Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383E113AA4D
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245206; cv=none; b=SojU21KQosodibqwy7PDzSVtKmhkM4n++0jzDO/YXj94/XRNG2zw7bb33pKgbDFR18s+0xqX4CR6GTs80taAbes0asxLCwgtbiUeSrsY7rQgAc/PCBfaC21SGd3/bTdbEzZJVfAwMfFLvDw/zruXUfZTu3YPs6z8d2t3loqVp1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245206; c=relaxed/simple;
	bh=hG3FP4AcNKVMSK2tzoC+JG6H48CVh98nrbPvxUI40RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8o67/Bg6mfxkSc5BNIm/+cus4YP4KjpgoIRVsaXZtbq3kLbmrTNvyLkBNA8koc9vfx0ShH4ytBSGPULhkzojs/IJgN5Xqk3WWqdXsB+qTvSnnoRVg6lKv6xLoX4rr560LmWVxrxam8pWYSlcEKtCAzvu48+6wBL6z6tg3vGSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YxvX74y6; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YxvX74y6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245204; x=1747781204;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hG3FP4AcNKVMSK2tzoC+JG6H48CVh98nrbPvxUI40RA=;
  b=YxvX74y6nKIDWl59q/2rboAWh9zNTAm4Oqe0jlc++IRBknykXheLzhg9
   IXoC2zVzGoNzSSW0vXqjjl+vM9veFU5ttnsml3kvgAW/EQtcVf6WRIN7r
   a1LA3EAMhF1ZsE40tvvYubra+J9JT+MEVrTk1dPtt/LN+LcRKZEdRU7HB
   4OjzyLAFFwRLvOhLuc2a2haKihaNveJuhG+Bqwig4PvBeG1Q7CPh4MzeJ
   8ygW6x+qHf92QuTfe1hGE0gNyyuOp8GuCCUrXdw6zRSxCAgE1aZyfi6jv
   ixVdCSu5qKCFreGgUISfRso7uurzJE17T56N7KA/mi3VRtk3a7NMG95p8
   Q==;
X-CSE-ConnectionGUID: /8PGE8V8Tpyte6dc0E6g8Q==
X-CSE-MsgGUID: T6FxzeywT/usg+wr2J+uSw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199693"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199693"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:37 -0700
X-CSE-ConnectionGUID: jTD+lewsQrm7iSCS0pL6WQ==
X-CSE-MsgGUID: V6PIu/WDRNSu54Do8AB0ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593433"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:37 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 17/49] platform/x86: intel_speed_select_if: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:48 -0700
Message-ID: <20240520224620.9480-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
index 1b6eab071068..6c36f7704fe7 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
@@ -161,7 +161,7 @@ static struct notifier_block isst_pm_nb = {
 };
 
 static const struct x86_cpu_id isst_if_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X, NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, isst_if_cpu_ids);
-- 
2.45.0

