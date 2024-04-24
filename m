Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C9E1C8FDC
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982543; cv=none; b=SxdqwrpvV5dRwDzIo9ePaPhqg19KGQK0rv7NsWIeRatiGBvB02q3/cdWIIQWv5xLvXfoVwRzDsV1FaOCj0XwHN4vp0bpAwjtRD7+XG5/U90Zr7MZHWNcuqp+B5/1oCW89KiSWTzLu5nPr+Ux02VdVyHbl1GWv/ry/bJ7UCIG7DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982543; c=relaxed/simple;
	bh=i5bcoBcmvU7uXKCZja5nQG8SX5zG7nFXavF27vF+S+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrUCRz+I6XnF4KnozuWJCgyiMt0WG0oXh/TvtQG7F5b9D7vVHt5rivBGuxGVGmDtj4PfivYn9IgHB+N5brpravRzoTlY4xOixW5fku2XlGi0fjn0VnzqW4gEycwc1P9vtqbbfl0cy2tKNMe52OKME/14K21G71xrAJF0FrBgp/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E9O3DnIB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E9O3DnIB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982541; x=1745518541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i5bcoBcmvU7uXKCZja5nQG8SX5zG7nFXavF27vF+S+o=;
  b=E9O3DnIB5TN923SXlGI496vtTraUj1Rj2827vLBOXqsOy3hqoZ0mdLV4
   T1CRvfalAU+9ZG0/Fi02N7Ap54zZbWGfK9cNHlCxvtKxGk4UC34slzy41
   GBWCdKzD1XVn2xG1zpei/erNsAwtBy/tgFNz2rXlYr4vT2/pnoUJMze/x
   h1XDnkWQAhAhPT+wtuIbEjatrcHYQo4RCe3n8xC4IJ+zYrowbOMX68Gdv
   xtrCJJZft1tiPgcoZ0GOqf2m8HI0tHNN3+I5TOfmtV3dMA/hoZT6gVTS3
   gA8LaMGXacSQa1pUo2VXa+YJC0B85CtgItfRbDuIGkmfUae98LHQynnKA
   Q==;
X-CSE-ConnectionGUID: B+lS+Yt1QH2ZPyagQS36Vg==
X-CSE-MsgGUID: eUB6v/l2QiCuXlg/pU7mQw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503694"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503694"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:40 -0700
X-CSE-ConnectionGUID: vv4dO+6LShGBxGm3l8f26A==
X-CSE-MsgGUID: LP9lbvWLTHC4cdj+nEcVww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="55750309"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:40 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 61/71] platform/x86: intel_speed_select_if: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:40 -0700
Message-ID: <20240424181540.42330-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
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
 drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
index 1b6eab071068..6c36f7704fe7 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
@@ -161,7 +161,7 @@ static struct notifier_block isst_pm_nb = {
 };
 
 static const struct x86_cpu_id isst_if_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X, NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, isst_if_cpu_ids);
-- 
2.44.0

