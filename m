Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E69DF9C7
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849848; cv=none; b=BASaUVI9M+JSiFCYfLaIkHbXUNMqoXFmFZ5uydkD2r8qOgcyBVa+smJA7q3LdQG94E7FqWH7cWOhcQfWilIIijAWYIr+kkwZbEzoUIQyC1eExGJFxYqm5gR0/lB8dVmGqUJuxyMCvWB+RqOVh1c6wDrKOTtG/UfU0VAhZS72XSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849848; c=relaxed/simple;
	bh=VittVlf1b0271e/PJ8Q1PNQZ9T1Axil9WEjsp2ki1d4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mN4oMCrgSX60zcD/nIlyhPVz1i3PKYETC2DlxV1Ze+y7DEEcTHf/OZ/2fOowqEguOhaKXpEs5gZpjzOXHpP0BbEMKdp/YyVNqEKHel5hb7cfnBDnkSBqeHYQ8NSc9rss2zGMJE8RgTTlR/uwRwpjKH+9or7cQXKrkHGnVQHJsTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J+K0hbCq; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J+K0hbCq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849846; x=1738385846;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VittVlf1b0271e/PJ8Q1PNQZ9T1Axil9WEjsp2ki1d4=;
  b=J+K0hbCqsCaSKZ/CiEAlocNL45IAnQy8brVvc6ip0pzlCkyRo75DJaxU
   I4h2VqdA9pVIjOHv8oXJDy6rRT06x6XzjyAGJETrBASdnDR5djfgScn+q
   I+gGgNL7qWktML9Ly6C1UKHqUqwcsBftBFLXhgaejQIs2Z6TLpoxbTIJw
   fMXmr2xMX3Tywkc4OhBPsjP6cm/1XoYR24KCio8Y2fpOWM62+8FgBIDeM
   ZFG2D5bnOzKSPaHm9+/glZJokRi/W8+kV82bnFOZqm/w37hxBCezTYFvu
   8A+p0r/Ab8rO9L4lywvRLT0QOixfcWjpVcP/btsxbEmzq1MTatdZ8yFO5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615782"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615782"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339756"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339756"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:24 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	ashok.raj@intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 00/17] vfio/pci: Remove duplicate code and logic from VFIO PCI interrupt management
Date: Thu,  1 Feb 2024 20:56:54 -0800
Message-Id: <cover.1706849424.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Everybody,

Duplicate VFIO PCI interrupt management code and logic can be found
in two areas:
1) the VFIO PCI core (vfio_pci_core.c) directly accesses the
   VFIO PCI interrupt lock and data to duplicate actions available
   via the VFIO PCI interrupt management code (vfio_pci_intrs.c), and
2) the INTx and MSI/MSI-X interrupt management code within
   vfio_pci_intrs.c have duplicate logic.

This series addresses (1) and (2) by first containing VFIO PCI interrupt
management within the VFIO PCI interrupt management code found in
vfio_pci_intrs.c and then refactoring the VFIO PCI interrupt management
code (vfio_pci_intrs.c) to share common logic between INTx, MSI, and
MSI-X interrupt management.

Bulk of the changes result in the same actions as before this series.
Two functional changes to highlight:
a) "vfio/pci: Consistently acquire mutex for interrupt management"
   changes vfio_pci_core_disable()->vfio_pci_set_irqs_ioctl() to be
   called with the igate mutex held.
b) "vfio/pci: Preserve per-interrupt contexts" changes MSI/MSI-x
   interrupt management to preserve per-interrupt contexts across interrupt
   allocate/free.

This work was inspired by (and inherits a few patches from) the IMS [1]
enabling work but this work is submitted (and expected to be considered)
independent from IMS.

Any feedback will be appreciated.

Reinette

[1] https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com/

Reinette Chatre (17):
  vfio/pci: Use unsigned int instead of unsigned
  vfio/pci: Remove duplicate check from
    vfio_pci_set_ctx_trigger_single() wrappers
  vfio/pci: Consistently acquire mutex for interrupt management
  vfio/pci: Remove duplicate interrupt management from core VFIO PCI
  vfio/pci: Limit eventfd signaling to interrupt management code
  vfio/pci: Remove interrupt index interpretation from wrappers
  vfio/pci: Preserve per-interrupt contexts
  vfio/pci: Extract MSI/MSI-X specific code from common flow
  vfio/pci: Converge similar code flows
  vfio/pci: Extract INTx specific code from vfio_intx_set_signal()
  vfio/pci: Perform MSI/MSI-X interrupt management via callbacks
  vfio/pci: Remove msi term from generic code
  vfio/pci: Remove vfio_intx_set_signal()
  vfio/pci: Add utility to trigger INTx eventfd knowing interrupt
    context
  vfio/pci: Let enable and disable of interrupt types use same signature
  vfio/pci: Move vfio_msi_disable() to be with other MSI/MSI-X
    management code
  vfio/pci: Remove duplicate interrupt management flow

 drivers/vfio/pci/vfio_pci_core.c  |  49 ++-
 drivers/vfio/pci/vfio_pci_intrs.c | 510 ++++++++++++++++++------------
 2 files changed, 318 insertions(+), 241 deletions(-)

base-commit: 41bccc98fb7931d63d03f326a746ac4d429c1dd3
-- 
2.34.1

