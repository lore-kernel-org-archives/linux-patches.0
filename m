Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1549219EB
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 00:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543446; cv=none; b=gJqLxZNGC3OcTGtHNo8+pKFtwi18aY8P5/0sMVTlIPe0EkVfaAnKcE0NSHbwRi1dUA0K/kv582iXBv5whUffG8EMHZqVCrgcSH0kUWfGHDhh2IpjAttkqUV19plEqIm6W2c9s7IXoUAnkX7cDG6PvRtPpo9LJ7bcz1s0rUfvpoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543446; c=relaxed/simple;
	bh=l+muwJjd4b/MMagbFBq0iDX4dVxLpcndlyRlD39vk0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIcdRjO4XYBUwN6sqVM/dAoEU7ujzzzK/TClofIE1heyqbZbCMiEDaYmzqvMzAhX/eqChJh+E3A0WYF/hz99MHRQQDKIH1UwChEEnJPYL/SQUjHX6eMB+7Fq2ToNxkat73+D19hOqZ5wTgsUH9TpCI9bgRqPBe3X/tWa+aEX7Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qa7E6fhQ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qa7E6fhQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731543444; x=1763079444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l+muwJjd4b/MMagbFBq0iDX4dVxLpcndlyRlD39vk0s=;
  b=Qa7E6fhQUxwsHXyoEnvqiHms9EBgOFzT5xApDoCmsxCuA9Vu4Jm/WIPk
   J02jO5Llp/rjKeu5CF45JbtX5A6oo8W3dWdJZu4Ut3k6yDmsi+mzFaYFF
   Lqt1ZkkYYucDoTiXG1EWYYFbM7orXHzgBJPXMseXiWil3mRMc/eUr7xkN
   hYC/fuG9emwm7ozVu5q+4BmnHWXWWc4a1FByjCLStCXGEF+CWb1L2HgxR
   J5lD4fxpeg5bnJarIsL6Lac9U/oM7dqFct2dC7Qeq9XsmQyIAf8LLKFIX
   qezrvnv6phblP1+y1netjACl/QWwLhkpvZolzBPZWzXoebIJKjvUG7oxo
   Q==;
X-CSE-ConnectionGUID: jBzI7Z3DQk28U5jPIEAPGg==
X-CSE-MsgGUID: VIwD2+4/SgOMCqBEjDRHMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="30869541"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="30869541"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:19 -0800
X-CSE-ConnectionGUID: khuRkRx+Qm6mbRfwLv0nGg==
X-CSE-MsgGUID: QVZiBJ/cRIWtxagvcsXg7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92081175"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:19 -0800
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
Subject: [PATCH v9 9/9] x86/resctrl: Document the new "mba_MBps_event" file
Date: Wed, 13 Nov 2024 16:17:11 -0800
Message-ID: <20241114001712.80315-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114001712.80315-1-tony.luck@intel.com>
References: <20241114001712.80315-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a section to document a new read/write file that shows/sets the memory
bandwidth event used to control bandwidth used by each ctrl_mon group.

Signed-off-by: Tony Luck <tony.luck@intel.com>
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

