Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B15B7475
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 17:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679073654; x=1710609654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=me1YBwks8BolRJDJwSw1YQ5GKXju7AeGeCEcg1Uk3OA=;
  b=FjwD80GJcb9tgP3Hr6WKC5PA34p5QaQD7BpmGFW7izkUzDMsGEk0kv9C
   yWObxJZwdC7iXFO96SH2HnfdylZySXLtz4lT2kmsfsN9x06XXh3NL2KwQ
   3QvpOQrVEVy6NpoQE6pWk6asZiIhe3KLJUb4ovUoZbpsoGZCmESVd4Rcp
   S13AQuqKaOJJDVoWDoudM4V56xwiVq9MPqoxKNtgykhEAdGoNLF2tXXhK
   nlL3H6Eam/Biq6+EgN5eoEXPLdmrxVRKP3ULV8DTPSV6CD/6loYJGEO80
   qgsfHssSizxrz7pucVa8i6qgiqDwlrkZlUmw8TftdA/owdPpnkvOJrqly
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="339858213"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339858213"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 10:20:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="804166595"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="804166595"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 10:20:48 -0700
From: Tony Luck <tony.luck@intel.com>
To: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Smita.KoralahalliChannabasappa@amd.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 0/5] Handle corrected machine check interrupt storms
Date: Fri, 17 Mar 2023 10:20:37 -0700
Message-Id: <20230317172042.117201-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <ZBR+GMH0olGoDMGs@yaz-fattaah>
References: <ZBR+GMH0olGoDMGs@yaz-fattaah>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the same as v2 (posted June 2022) rebased to v6.1-rc4. I meant to post
when I did that, but apparently got distracted.

Pathces 1-4 still apply cleanly to upstream but there's a trivial fixup
needed to arch/x86/kernel/cpu/mce/internal.h to make patch 5 apply
to v6.3-rc2.

Smita Koralahalli (3):
  x86/mce: Introduce mce_handle_storm() to deal with begin/end of storms
  x86/mce: Move storm handling to core.
  x86/mce: Handle AMD threshold interrupt storms

Tony Luck (2):
  x86/mce: Remove old CMCI storm mitigation code
  x86/mce: Add per-bank CMCI storm mitigation

 arch/x86/kernel/cpu/mce/internal.h |  33 ++++--
 arch/x86/kernel/cpu/mce/amd.c      |  49 ++++++++
 arch/x86/kernel/cpu/mce/core.c     | 139 +++++++++++++++++-----
 arch/x86/kernel/cpu/mce/intel.c    | 179 +++++++----------------------
 4 files changed, 230 insertions(+), 170 deletions(-)


base-commit: f0c4d9fc9cc9462659728d168387191387e903cc
-- 
2.39.2

