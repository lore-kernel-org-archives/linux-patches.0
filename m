Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764A91836DB
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982527; cv=none; b=ea+XzksRFimMC5bERQqNWoOM20En6i+xttaAJlKT9ilxH5QXFSW4dcuzEYZvcImoYU57+Z+m2QEJNeL7S30rQNyl+e85Zo3CAO2D1crxM0JcMzMZ1craxLZ/P2gmVU3F+5YdDZjNsWl/4yWrTrxGt5tyzVyLCgD24E7l7tR+slY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982527; c=relaxed/simple;
	bh=MGAFX/pQ0txb1l1dIq0DhSgBPKYTlahDlBrDWyImM3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrRS9Q0SxkgM6IkD6kfQaGJGVf8c0x/6/6dPLDjK5ZdynO5IzlNNqUiXpzSK+U8Bdckmfv9I2BQQp2kU9R5+CN1h5LlX6o1eV1Ad1N9wIp2AWGw0TI177tag26uCnParP4MwiBCiYsoeu4H3I+TgvrxPTgM71qacG5oWB79fI+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VxAdQ2m5; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VxAdQ2m5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982525; x=1745518525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MGAFX/pQ0txb1l1dIq0DhSgBPKYTlahDlBrDWyImM3Q=;
  b=VxAdQ2m52OtctpvX28tJpV17kxYVFiEreTuw+yAX6dxYo99wRV0VJz5Y
   n3hqtbthkhVgfGdvs4lI4XqVh1Z6Bfp0x5naKWocWfVnC+YnXKIYPgC4C
   NHuWZrH3bnYGiDAeis9HmS7Pg6Wuc25rOdVAguQRIDBPHbmAxJsbFZ+hW
   Wn50OQ11b0G1HfGidA3Bw0pkedzxhJ0PwjQxnnMrdHIaLlVRKh1xNeBPw
   hkP3dX2ATXJro3frxJVJ2ZAU9LS9ZqQr5xfA+6ZtuPpihiSKI62xdBj30
   Wu5zk/vlN5/n85x3AKYfW1Ltx2idP0W5uXWUDh+PZkWnhWJT24qw0qibm
   A==;
X-CSE-ConnectionGUID: vicdliSeSvqt/TVmK1xcNw==
X-CSE-MsgGUID: ELg2YzH6RuWpykbC3+cpKA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9482050"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9482050"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:16 -0700
X-CSE-ConnectionGUID: 6+UXyGROQ1+HXtAw5ajgGA==
X-CSE-MsgGUID: 8mzt6r6xRDSmxfuTjnF+oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262780"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 38/71] x86/cpu/: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:16 -0700
Message-ID: <20240424181516.41887-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
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
 arch/x86/kernel/smpboot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a58109583c47..8dc83b16845b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -438,9 +438,9 @@ static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
  */
 
 static const struct x86_cpu_id intel_cod_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X, 0),	/* COD */
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X, 0),	/* COD */
-	X86_MATCH_INTEL_FAM6_MODEL(ANY, 1),		/* SNC */
+	X86_MATCH_VFM(INTEL_HASWELL_X, 0),	/* COD */
+	X86_MATCH_VFM(INTEL_BROADWELL_X, 0),	/* COD */
+	X86_MATCH_VFM(INTEL_ANY, 1),		/* SNC */
 	{}
 };
 
-- 
2.44.0

