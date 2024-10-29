Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A631207A0E
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222928; cv=none; b=g0N71gz5Wg4AbLlNdHSdHzOuXBKyrEEFExCZ0IS5Qt/uRcwwkOm3KQ5b+Tg1s/sqSLltXYXTbj7b955gYqjAQuewmQr6QA2wYYxwr7Fq6qntF2utVpyM+ToxwV/yCeCNfmzDRwUur+HzetRdW7NYjU3V2xUuSCpwWHj9icbNWqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222928; c=relaxed/simple;
	bh=9ogyyqXIQi/uuhL7kuz5NJmlYRlDjf87yhyhV6XKxhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCIiZ3DCZhv8gu1iIjpM8IVA10vzCX8fJywxjIr7um9lXVS8D3aODbEmZpxdiYj1tOsfILCjumGAAPA9r2NnqcpEkr0OZM27RNLGsD3BQidi4mTnhNr362K0wVtuiH31xYK05G3nBlF4GN4qrXrPjW5ywSyy5KzliGU/7qC4crg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZVzEA3m+; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZVzEA3m+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730222926; x=1761758926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ogyyqXIQi/uuhL7kuz5NJmlYRlDjf87yhyhV6XKxhk=;
  b=ZVzEA3m+ElWqYEIZ3pZVllg7CLhLRqkW8EuLBmbe72pCIes9I00vdc1o
   zNyIS4hDmwIGyJbQ68cyJUlsu6KnvVaLsR6oPpIAkafSaBY2rmfw/JVau
   KICEGvbaOqarKgcO1bkfTmRhSLfmy4T39zViI5dWq95a+wdz5lTsfx6Cn
   4c+jLeQDxQ3s+jB/Ponw89hkvDX7svw8JB0Yxb5tBkC9dYeP5cDyeQvHH
   QczZNCEWpTOt0Jth7yljMhPted1lOTVMKAbgfa6DcD2pB3AlAA4kYX55M
   wB9yzkEWP8hlxTY3aikThXDNvHwwMM/cV6zddT17mRXz6EAH4v2itOwAd
   g==;
X-CSE-ConnectionGUID: ER/DW7E7SpCRXRWH42mDxw==
X-CSE-MsgGUID: lhNRqIAxT7a5FrLa644cMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="17515711"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="17515711"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:40 -0700
X-CSE-ConnectionGUID: Gmx31W2JQuWsJkP81PRDSA==
X-CSE-MsgGUID: ALxxAqEmRnGM8ug5OpYAKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81585616"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:40 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 7/7] x86/resctrl: Document the new "mba_MBps_event" file
Date: Tue, 29 Oct 2024 10:28:32 -0700
Message-ID: <20241029172832.93963-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241029172832.93963-1-tony.luck@intel.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New read/write file to show/set the memory bandwidth event used
to control bandwidth used by each ctrl_mon group.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/arch/x86/resctrl.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index a824affd741d..d86081e76bbf 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -384,6 +384,16 @@ When monitoring is enabled all MON groups will also contain:
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
 
+When the "mba_MBps" mount option is used all CTRL_MON groups will also contain:
+
+"mba_MBps_event":
+	Reading this file shows which memory bandwidth event is used
+	as input to a software feedback loop to keep memory bandwidth
+	below the value specified in the schemata file. Writing the
+	name of one of the supported memory bandwidth events found in
+	/sys/fs/resctrl/info/L3_MON/monfeatures will change the input
+	event.
+
 Resource allocation rules
 -------------------------
 
-- 
2.47.0

