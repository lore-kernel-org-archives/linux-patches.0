Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F73913AD38
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245207; cv=none; b=WTr68jBQHIbYgip6P1KqcVSzSc+7FhTC89B8phftYgq+uZwMqGQyDZyzobM8PXXX/PfZmuj7CiGKoTTcT9c8FZLlxfr1BFq+obtCZ/WBCZHhEefChSQ9GEyOCzbDES851vh9+/tLZuGT5lVd51/NNcXlfUn7y6FHrxydIBhpIvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245207; c=relaxed/simple;
	bh=hy9MtmDbv3l0daB2PANyWQHGl/YT+EbTWZX9BQjPOSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsT32mrIrYiZ6n4AXRjbGlW56v4maepmJXseIc1Mks+1jHMoTSQqRIWkmAEAZEfn3XDUpX3m+zeuGK9p1iarsBYYi43+wzxKbYLqdKNxYDW30mmS0Cr+l0WR5KD499oXK2PhT324ixIl9ByRiZVK+LiN0j98cU925RKAwM+4CDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fSiEvcL5; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fSiEvcL5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245205; x=1747781205;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hy9MtmDbv3l0daB2PANyWQHGl/YT+EbTWZX9BQjPOSw=;
  b=fSiEvcL5FNvKeI65a6Z4z/qmryAosPGZcX0F6RsKyYvDdzhr+b2HyZ2Y
   h8FC7Oya2bEwoBF/4Uu2IfrX171XO0qP8kuUls9gPZTsp2QD9PnfQ0+Un
   zn1Caz7DM8C+tTbV1rcsvOBwRskQo6QgL/rFzH+fjDEqFylDZStbhBfjX
   RWJypXpkkaYsvaquY2Kk1M0LjbSPeElX0cW0x1SPBGMYImsTN7Hfg9/uo
   xoAX685otFjpb9BiNrPNs6TD94R7Q013c25IWHDBi3OyvVvKvqsoBD4Y8
   8FidzH+YYMLG6NX8J9EW55ht6jXtWRNiBkHJ4LvTB3ty1cpU5C+o+LrFd
   g==;
X-CSE-ConnectionGUID: TYFocbbWSduSif9T0zrumA==
X-CSE-MsgGUID: Z8ZSePB/QzG5zkgHaU+L6A==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199725"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199725"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:37 -0700
X-CSE-ConnectionGUID: hO+AK607SROrhO7Ia68InQ==
X-CSE-MsgGUID: ohFA/K4uTAWphuojlwHxcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593442"
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
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 20/49] platform/x86: intel_telemetry: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:51 -0700
Message-ID: <20240520224620.9480-21-tony.luck@intel.com>
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
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/telemetry/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/telemetry/debugfs.c b/drivers/platform/x86/intel/telemetry/debugfs.c
index 1d4d0fbfd63c..70e5736c44c7 100644
--- a/drivers/platform/x86/intel/telemetry/debugfs.c
+++ b/drivers/platform/x86/intel/telemetry/debugfs.c
@@ -308,8 +308,8 @@ static struct telemetry_debugfs_conf telem_apl_debugfs_conf = {
 };
 
 static const struct x86_cpu_id telemetry_debugfs_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&telem_apl_debugfs_conf),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&telem_apl_debugfs_conf),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&telem_apl_debugfs_conf),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&telem_apl_debugfs_conf),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, telemetry_debugfs_cpu_ids);
-- 
2.45.0

