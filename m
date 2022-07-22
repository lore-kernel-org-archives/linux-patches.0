Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313875C85
	for <patches@lists.linux.dev>; Fri, 22 Jul 2022 23:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658532828; x=1690068828;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yw+5sbrqD00Mkg0zJD1e2qgbq/qqFtjTGEKESiXhYpI=;
  b=Go7znKE6xmeEvs8ghRhJeB/OKs1ZukAFPE9YIgOsAruqeUo1e31IMu93
   fuf2Lo8rweKTh4plrYZfYL9ZQbYeAwwfBr2PKluLaNUam4JkTRS9DVKma
   OmXOAp/7bUvD5jKeGNyZaEJNV9HC7f5AVK9q9SULIwVY5r95YyhRHTtDD
   LySjlmsGXadCrrzjnfWU7Lk5zPtTLc08+mp/Vm6Rdajz4U2zvfRobpv37
   TTKWcWKeAQXs8y+Y0CKyJq0wgaore2dHVqCSHIIa16swd1yzz3o4LSiFV
   K99YsGz/UfJWHxGLUMH7t/H63dKfenjcwtfL6qKYzaKj6+CwmgagrqS4f
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="288603558"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="288603558"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 16:33:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="574346058"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 16:33:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: linux-edac@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>,
	Aristeu Rozanski <aris@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/4] EDAC/intel: Some Intel EDAC driver updates
Date: Fri, 22 Jul 2022 16:33:34 -0700
Message-Id: <20220722233338.341567-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1&2 add printing of retry_rd_log registers for the HBM (high
bandwidth memory) on Sapphire Rapids CPUs.

Patch 3 prints from an extra set of retry_rd_log registers on Sapphire
Rapids.

Patch 4 adds sub-DIMM decode (bank, row, column) for Broadwell CPUs

When community review is complete, plan is to add to RAS tree after
v5.20-rc1 comes out for the v5.21 (v6.0?) merge window.

Qiuxu Zhuo (3):
  EDAC/skx_common: Add ChipSelect ADXL component
  EDAC/i10nm: Retrieve and print retry_rd_err_log registers for HBM
  EDAC/i10nm: Print an extra register set of retry_rd_err_log

Youquan Song (1):
  x86/sb_edac: Add row column translation for Broadwell

 drivers/edac/skx_common.h |  10 +++
 drivers/edac/i10nm_base.c | 153 ++++++++++++++++++++++++++++++++------
 drivers/edac/sb_edac.c    | 148 +++++++++++++++++++++++++++++++++---
 drivers/edac/skx_common.c |   5 ++
 4 files changed, 284 insertions(+), 32 deletions(-)


base-commit: 32346491ddf24599decca06190ebca03ff9de7f8
-- 
2.35.3

