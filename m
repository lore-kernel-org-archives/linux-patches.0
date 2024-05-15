Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E8D15D5AE
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811822; cv=none; b=Fiz6OVyDTuqQcQ0jo51eJqiGc2dlaJ++/zO4TwbRi0hLRxHvE+nEgIeBQoyDbPQ+VRTnmvLDAkCjF7MNx1FT1IuOPCApMx0Z4448bq+E4xtaS5rxWzgt5B63LMzBtv3VddL9JPqBmMHryKjwXS1lqQfUOLnh3Ug2QpFvIt9Zt3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811822; c=relaxed/simple;
	bh=0YtER+0pZZM0aonKKMX98jcoXBMdyd2vjep0paG/Gss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkJMcTHcFWQHOizl5tW8S3BDljtEAYKPFXrFKqX5aO1PQ9I81vLbkW/YdpXqg39RA2TcI0ySEntmsIQ0l9rGzaSocxHKB6ogI7FA86inyezgBGTWYsaPV5DaMD/WLqe/LUaar2K/f/DX/g3Hpa78LTizlDrlmUoXDdOU8HKsFLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i4+8H0VM; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i4+8H0VM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811821; x=1747347821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0YtER+0pZZM0aonKKMX98jcoXBMdyd2vjep0paG/Gss=;
  b=i4+8H0VMAb40V8XXMeeTlEoUPhHJVzyb7Yls32BhiQRErBHoAJGJyggg
   kLHP3F9lfkedQLI4hAMU+2cCyL4C1MKr7cwVNmhYkyPwpFpcnOCrVdWPE
   i/khkub6jMa+4vGYBjjN20YuX0liY37E6HlripWiZOF07WJhBEV1TEmYY
   R5889PT6xXa+8alAqtziAiCvm5WGfbAu5jlhjGNgfsuforrcxHDk+aaVh
   8Dx2kErMGP5yDIEU5GatLV27+1EWCvabQxM+JQgl3416+jgxEfVa0Olp+
   nYObwYKCBRDbY62yKi5IFwMPuaxeZuyALnN7YwDR00mZPXfWAweC5nAni
   w==;
X-CSE-ConnectionGUID: 9rzFyd/wTFGv1liEorv93Q==
X-CSE-MsgGUID: AwxVbJ4cQGCVMMjR+k0vTA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671658"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671658"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:35 -0700
X-CSE-ConnectionGUID: CsgZSs/FQGGXi18ljD+89w==
X-CSE-MsgGUID: IBpYasFrQt+WSSUL2JvfqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989172"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:35 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v18 09/17] x86/resctrl: Add new fields to struct rmid_read for summation of domains
Date: Wed, 15 May 2024 15:23:17 -0700
Message-ID: <20240515222326.74166-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rdtgroup_mondata_show() calls mon_event_count() which packages up all
the required details into an rmid_read structure passed across the
smp_call*() infrastructure.

Legacy files reporting for a single domain pass that domain in the
rmid_read structure. Files that need to sum multiple domains have
meta data that provides the display_id for domains that must be
summed.

Add the sumdomains and display_id fields to the rmid_read structure.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 49440f194253..498c5d240c68 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -150,6 +150,8 @@ struct rmid_read {
 	struct rdt_mon_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
+	bool			sumdomains;
+	int			display_id;
 	int			err;
 	u64			val;
 	void			*arch_mon_ctx;
-- 
2.44.0

