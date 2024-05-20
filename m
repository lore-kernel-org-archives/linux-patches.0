Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE7213C692
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245213; cv=none; b=JVvQb01oXU1vSD5suTivUztSFf9PsB3fg9VBhBZnteo+c6DMPNFHZL5PX9tjyvMmH7FoUjhYdMk4KHLq2RmnIFbGbuzfUfo2tJyn65J9hr1lNLzhhti2JNc5vEkhWhHf0N7tx5p6CynAQr9xOT1JydKiFlBAjHMFe1PAVFY2kh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245213; c=relaxed/simple;
	bh=ifunLBjjEJ27+/uU6cajdNrtE7FxVrkvN9E3z6UIJT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atUhKxq2CnSgj57DiQBoqbCx1R2Ec5C/Z0khq6Pf88d0920zfpFs4xMc2Hd8sK7IQ1RYdmUtr6E/cHKQb2syYpYQ5IEJoMBsiqxzSoar3ubluHjolzOSmUZkVTrHnk0wQo1hZPA/Apl8/hEy7uP9SD7dBwgq3EiRo2wXX/T7xHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AY1hYlvK; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AY1hYlvK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245211; x=1747781211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ifunLBjjEJ27+/uU6cajdNrtE7FxVrkvN9E3z6UIJT8=;
  b=AY1hYlvKOlXgO9/nFnKIVZufoVRbt9K71URYiPcGFDFnvggnFYrFF/XA
   IGaLLzdBj4xK0q+eyoX0rivxlpN17TmRmixksDY6XDtvyqfa3Uqju8Y+c
   NwG6fw30SXBzCozOgGN3O052HZQRU9HNo1qhEQF+Jyq4IoADgBk0VgFX/
   EB4orm/Vbx/3fK4cD48ISX9AZqUfU8dlajVDBjOgAvk5TxUSlL0IcDv5N
   vT0tVPXSvJYGlUXgsfADK3JCFnRUcDkgi93M7D/4890t3Mty3QYHtyUge
   6WRnqmzqFCt+yWkKonsz0BzKxbQLHSROEWkj6JsAM5Sp3DT+a/XhG4cSC
   w==;
X-CSE-ConnectionGUID: R0dbxOoOTt6OxDWEWpjtxQ==
X-CSE-MsgGUID: HpWnhh+zRx6gd/fD4jVxcw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199902"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199902"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
X-CSE-ConnectionGUID: GVU20H2TQqCBG6tz0xcbZg==
X-CSE-MsgGUID: 9fqPi9D2Qt+5UqCp/uLm3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593492"
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
Subject: [PATCH v6 36/49] EDAC, pnd2: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:07 -0700
Message-ID: <20240520224620.9480-37-tony.luck@intel.com>
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
 drivers/edac/pnd2_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/pnd2_edac.c b/drivers/edac/pnd2_edac.c
index 2afcd148fcf8..f93f2f2b1cf2 100644
--- a/drivers/edac/pnd2_edac.c
+++ b/drivers/edac/pnd2_edac.c
@@ -1511,8 +1511,8 @@ static struct dunit_ops dnv_ops = {
 };
 
 static const struct x86_cpu_id pnd2_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&apl_ops),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_D,	&dnv_ops),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&apl_ops),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&dnv_ops),
 	{ }
 };
 MODULE_DEVICE_TABLE(x86cpu, pnd2_cpuids);
-- 
2.45.0

