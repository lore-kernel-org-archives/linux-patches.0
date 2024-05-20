Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657EB13C8F2
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245214; cv=none; b=KL7IYcXOZn+jjOPI2vMpPowHbV304Qj1AqkZEE98hgM38A180Kng+v/G+1Wr/VXuto5vxNESVV0jOgo6cetPUJf4lT4+pZBxnwTx4O3c0QF5Cb+FHdRs3ejbngO1g9a7mBKz8V39EMpWsrWZ9s+yva5tVrB7RIDSO11bV5y3J5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245214; c=relaxed/simple;
	bh=mv/DdbZyo6eomJ/rc6S48OLZws5x/hvaTKemElND+wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaKHx0pzUZBxD0eR4Z9jowxmIiUUlTzUCSCrltqTttI9aAeJt/9/D8joCSkARznG+Kd7DLEqBeywV9g1JDhFaiBK4nTqUQla1C7jF7pK/hUwNZn2j0qPW5s9wUPhqQi7AbA8CKJH6FAj9grCJyX5iVdjSuoBo88jnTPwoVhjJ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZcRIeLHd; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZcRIeLHd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245212; x=1747781212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mv/DdbZyo6eomJ/rc6S48OLZws5x/hvaTKemElND+wk=;
  b=ZcRIeLHdILpZmDMKuR6zn2wEH0aNsAZQferFrTcKgyCSYbO0Nk62g42Y
   9xf5e03GxcNw4TEPYa1yHu6sfW4CfmXGTB56sOQ++qtC+yXNXsNCJf8dR
   zvGi2xWLJH30Huwt+yrd2Ur/QJQ6R3SxmY2chint3eInMVPdPmpJVHJyp
   tUddcSQ2Nkg3omIKITLAU6noje84W4Ux4yOPIAt3q5isFefqeI3Z2XAJu
   ny1dQp31e8qHMBnOSCvGYGF109Zun4thFIbGVMb0ewx66nYCd+CyE70S8
   W9LMQgZadX9EfmPLspJ1xVNDSf5e0yCmVRDEP343SOvESJVik++z7UDqs
   g==;
X-CSE-ConnectionGUID: QReK4+xbTDyV2PFqPzhg/A==
X-CSE-MsgGUID: pafPHT3eQ0m3ix9lRjGHpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199947"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199947"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
X-CSE-ConnectionGUID: N6iJoTr9Rs6llL8HsCEguQ==
X-CSE-MsgGUID: gq4jayzTTueHQeNli00jwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593505"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
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
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v6 40/49] ACPI: LPSS: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:11 -0700
Message-ID: <20240520224620.9480-41-tony.luck@intel.com>
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
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/x86/lpss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/x86/lpss.c b/drivers/acpi/x86/lpss.c
index 148e29c2c526..258440b899a9 100644
--- a/drivers/acpi/x86/lpss.c
+++ b/drivers/acpi/x86/lpss.c
@@ -338,8 +338,8 @@ static const struct lpss_device_desc bsw_spi_dev_desc = {
 };
 
 static const struct x86_cpu_id lpss_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	NULL),
 	{}
 };
 
-- 
2.45.0

