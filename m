Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF913B2A0
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245207; cv=none; b=vE7WPno/SUmmE5KGEWdQpS7+KtdQNhHs3RBykxzPx2BPQn6HaeFio1+c6cCaMh/dF/ialIRidxu/YO0UbooSPYbLtgHO5byX7Ebr9x7uSS5ZXF/q11KZq8oD2YNKyBbPeaQC3monWgDsKUnunmK0M2weSHNpEHNyvs8tGjkbdvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245207; c=relaxed/simple;
	bh=WB9IrZhQaBiWvCtxLVin3lFQLCeXldDe0NZh3MqrvXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPZrKRD+6F2cvDkeh+9s7DDIT/nWoGPZzVgjiX83I76v+MYvH2hpaciBEga+qBpwtLPQ0SznTIbEcPk+rpx4kesFZOrwJtKPXMqakv2RyjHdfshRX4a3GoJBtqpOd1otasO1k5cMoOJii6ui8aLCOhnlVxQCXwmIOgY8n/GZptQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PYEYWYWE; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PYEYWYWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245206; x=1747781206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WB9IrZhQaBiWvCtxLVin3lFQLCeXldDe0NZh3MqrvXI=;
  b=PYEYWYWEcxILUpIQcNOFWBADkcH/Gj8ReMKFLsZZLwZZZSYjzuHIE8+2
   ovR7izK9hLe6YYR/AUbR8gdpZqT9Rrgh/+qbWJZPj5n+NjNdJgvT9Yr/8
   CJt9/MPMD/YjWuPbEnhv/MaeVtmSmms6LWLZd2xeO0Co9I3eBrq7y3z2+
   3t+sGedEugVHbboeK+hnHXNCgECi663nYboRg7+IzMX3gRQae8I+eDfwQ
   LwPmnTjmqJDqh7IpgbQO95C1vQLWgoy6JnxJsZe63nAHm5nD9WZtGV6/a
   qdCpAfqvxcXEKGlkGH3mI8YlV8H7pxrqSFPL6EeVeAU6trdqHsX4ctmkJ
   Q==;
X-CSE-ConnectionGUID: TQFz3AM7RTC7IKwfecmX8g==
X-CSE-MsgGUID: HaxyTGJgRT+x5cddwHCOKA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199747"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199747"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
X-CSE-ConnectionGUID: VURtXdSDSkeM+6BtBnTnLg==
X-CSE-MsgGUID: OiObT9RmQ8Gac8FzHR0c4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593448"
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
Subject: [PATCH v6 22/49] platform/x86: intel_turbo_max_3: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:53 -0700
Message-ID: <20240520224620.9480-23-tony.luck@intel.com>
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
 drivers/platform/x86/intel/turbo_max_3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/turbo_max_3.c b/drivers/platform/x86/intel/turbo_max_3.c
index 892140b62898..79a0bcdeffb8 100644
--- a/drivers/platform/x86/intel/turbo_max_3.c
+++ b/drivers/platform/x86/intel/turbo_max_3.c
@@ -114,8 +114,8 @@ static int itmt_legacy_cpu_online(unsigned int cpu)
 }
 
 static const struct x86_cpu_id itmt_legacy_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,	NULL),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,	NULL),
 	{}
 };
 
-- 
2.45.0

