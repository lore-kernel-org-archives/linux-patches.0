Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A972204584
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733502722; cv=none; b=doK8xxHEyPJDU+BtPVYyewEImKU2iroEIwp1zHOPGrcaP2TQzEcRkAgVqpj3Cx2VmilUh36DefS82QgVqNf1NVullqSIsu751AgLbbTf0//XGBSrZXFzgwEuojDIPv/Ks+3aU4lFnv3donCgqh5ZXloYLx1A06YoVM/SS50+DIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733502722; c=relaxed/simple;
	bh=RFzKZU16G64WevDvffNNaOLPzBtFmeFhRrOM1vduHhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0GaFyLkojvIMlUZB4EsFMUom21mtv+d5Ud5Wk9fdgAtp3/wB2mWlwJ9QOVD77u/CJh+3ShrabUf5P+E628mEKhd6n+lflJp2j+8jJAK1L7JdUnej1KLrpmfI5+Mefdcj3FdOfSoeYdYiuTssxjSfCjZAhxFIh0hf+F5lfiFxQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mGLRAt92; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mGLRAt92"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733502719; x=1765038719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RFzKZU16G64WevDvffNNaOLPzBtFmeFhRrOM1vduHhg=;
  b=mGLRAt92IZezCy1AtG3AmhIYFK+/a44m3CxdT32H2apQUJHOxr/j8oXE
   PD0StUqLO8ltUgCk2MJDBDgwTEv4xGyhwzaJFgGb2A3N6v/xodoSgKRj7
   U0ygbmUlPSXbAIbmAAgtJcvGb90qNfGOB123epFkkWHN+CrlEzOZShjiu
   r/iN7ZJu6l32T0p0QMGE0K42uAua3vzh68eZ8MoB6defk7AI4zhzz6Kcz
   2jvjYFPTf84CB+dao2sjKBQxOcRIXAGR9TUyrbEy/VQQu/bcrvTAGvwdT
   xroZwWPQVSH3y7HpBhxXzWhDDNvbEOuIwaDRlTJEMnNrZg72zYb8KIg0C
   g==;
X-CSE-ConnectionGUID: rr/1GWqBQRu4oytPXT2gVQ==
X-CSE-MsgGUID: 27mmiREfRNCFytiwNbFuiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="44470452"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="44470452"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:55 -0800
X-CSE-ConnectionGUID: jctF4re7QMyXOcO8Jb6sSw==
X-CSE-MsgGUID: ahdfbdBNT5KrzPn25pqrtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="95258533"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:56 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
Subject: [PATCH v11 8/8] x86/resctrl: Document the new "mba_MBps_event" file
Date: Fri,  6 Dec 2024 08:31:48 -0800
Message-ID: <20241206163148.83828-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206163148.83828-1-tony.luck@intel.com>
References: <20241206163148.83828-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a section to document a new read/write file that shows/sets the memory
bandwidth event used to control bandwidth used by each CTRL_MON group.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 Documentation/arch/x86/resctrl.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index a824affd741d..6768fc1fad16 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -384,6 +384,16 @@ When monitoring is enabled all MON groups will also contain:
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
 
+When the "mba_MBps" mount option is used all CTRL_MON groups will also contain:
+
+"mba_MBps_event":
+	Reading this file shows which memory bandwidth event is used
+	as input to the software feedback loop that keeps memory bandwidth
+	below the value specified in the schemata file. Writing the
+	name of one of the supported memory bandwidth events found in
+	/sys/fs/resctrl/info/L3_MON/mon_features changes the input
+	event.
+
 Resource allocation rules
 -------------------------
 
-- 
2.47.0

