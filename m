Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137F913C91A
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245215; cv=none; b=cPtlkP01I7JY83ahCnP4tONfVPLNCONMpm6T1AhgfLzvgyC/STqBlSJuBoE6b5vXgImx3Vwb3ifr15EdB29MHRchGGjE7eYBobp53gGrzlxIsjr+7ewK67Zd6wo8Rf07/gGC3QLeARdSaXAX8bAWRfBr3H1th+++osMdulMXNOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245215; c=relaxed/simple;
	bh=PfFXI3d8s3t/NWnQnGzvD1hWBKVfxk2hbTTJbFy8Fl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVbQWtehr69mcH+t3PWG7Z8G7Hq2/0+SjnRmT46XiZfeArQkeY5Y6xSBOkmSEKV01hpFos4MEUaSfA4eAHjCNyJaJMrO8iVzzPhE3Hd9/cjB7LP0c7CBCc3r603i1g9bRxok7XOWlpVCyOgC+nyryG6R7q6gVWNIjeM7zfIONZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SfWj7I6X; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SfWj7I6X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245213; x=1747781213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PfFXI3d8s3t/NWnQnGzvD1hWBKVfxk2hbTTJbFy8Fl0=;
  b=SfWj7I6XPllyizezYJH8AxWg8AFuiK52oR1BV4uzYNpHdPvYkgOjEDSS
   PR6zll8W808C2Q4vZzoGnJAhBAONRtHKjrPsaa3oc2S1mTmZP5b/KvW0c
   G0CQ7gOyA62J1K/8qw4PuKh2vssOoeKk+ztQBg0aevzz6I+OYzvhXoiUq
   9HSBvONITyNA4zzmoUU4bYxPFGquWn2rNjQXIFFcA1pC4NV25zBxECBHI
   iF2ZLihSMWK5yhTv9PVg2h8+GA3VXTOEX6PQCMr8CFJjY2NhI93+TFecQ
   ZMzBIKfeEuNB7vWAhzzySC9nSx2cdW7Lru+yGF2S/Hw+Kk/7HcW4Y1wUp
   w==;
X-CSE-ConnectionGUID: w+03SbclTx+M6WI9N6GCtg==
X-CSE-MsgGUID: mliW57KxSomtH9Ht20KCdQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199941"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199941"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
X-CSE-ConnectionGUID: QRLoRNeHQ0Od5z6D8hPZAw==
X-CSE-MsgGUID: FZ22/soYRF2xjxrtSRVzZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593502"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
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
	patches@lists.linux.dev
Subject: [PATCH v6 39/49] extcon: axp288: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:10 -0700
Message-ID: <20240520224620.9480-40-tony.luck@intel.com>
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
---
 drivers/extcon/extcon-axp288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
index a703a8315634..d3bcbe839c09 100644
--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -108,7 +108,7 @@ struct axp288_extcon_info {
 };
 
 static const struct x86_cpu_id cherry_trail_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	NULL),
 	{}
 };
 
-- 
2.45.0

