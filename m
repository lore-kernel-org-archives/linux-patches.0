Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038F47D096;
	Mon,  8 Apr 2024 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583015; cv=none; b=hASbREHSjN/gcWXlhZ+GFmsLHmrwp8/HSsiMawx7GsBU7SOhjTLAhtwV2htvKWomLU0bWgi/T7XA9fLN7QaiAhLPgYVenpAuExIDUD7Jlb4bCrYBJlDXI4Zq3wzBvtgzsXBbA6XJDYscerU1Qgx5b5g3RWlwA3uJ3xvwvuqJSVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583015; c=relaxed/simple;
	bh=v5XoY3XaoTo/2yNqUEMWu+L3787Pzvde7f9VlpWfIzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YunfQPeSMhQR+R8EIr2mhkfc0U8yW/allH0h22ZZIfH2V6UUC7OSMGoqpH0AtPK0SRIaR36P1BXyJmFk+vKLzUPyNwlz8Wfd3MYswZbBpC9Qx9fvf4osG1242mFWrN3/U92OEfIHAiLtPVH5e2Oqaal9COVAM8VMYob0wlWqncM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t231N4Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t231N4Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7787BC433F1;
	Mon,  8 Apr 2024 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583014;
	bh=v5XoY3XaoTo/2yNqUEMWu+L3787Pzvde7f9VlpWfIzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t231N4Ube0yngPIeEv6K5vUstu5a3h0ViFL+DO8FehmqmIyyYmeBWQqsJ8QASQuD2
	 KBuaI9d6WGwSp6CyTbm1i76l692GDi1kkyN52GFJ6M2Yj1jxad9czg1go7YEcJnW6B
	 gF5ZIJKQtcQF129xxi+fzJIkB/0rir3o5RIT2/A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/252] intel: add bit macro includes where needed
Date: Mon,  8 Apr 2024 14:57:27 +0200
Message-ID: <20240408125311.248476794@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit 3314f2097dee43defc20554f961a8b17f4787e2d ]

This series is introducing the use of FIELD_GET and FIELD_PREP which
requires bitfield.h to be included. Fix all the includes in this one
change, and rearrange includes into alphabetical order to ease
readability and future maintenance.

virtchnl.h and it's usage was modified to have it's own includes as it
should. This required including bits.h for virtchnl.h.

Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000/e1000_hw.c   |  1 +
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c   |  1 +
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c   |  1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    |  2 ++
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    |  1 +
 drivers/net/ethernet/intel/iavf/iavf_common.c |  3 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  5 ++--
 drivers/net/ethernet/intel/iavf/iavf_fdir.c   |  1 +
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  1 +
 drivers/net/ethernet/intel/igb/e1000_i210.c   |  4 +--
 drivers/net/ethernet/intel/igb/e1000_nvm.c    |  4 +--
 drivers/net/ethernet/intel/igb/e1000_phy.c    |  4 +--
 drivers/net/ethernet/intel/igbvf/netdev.c     | 28 +++++++++----------
 drivers/net/ethernet/intel/igc/igc_i225.c     |  1 +
 drivers/net/ethernet/intel/igc/igc_phy.c      |  1 +
 include/linux/avf/virtchnl.h                  |  1 +
 17 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 4542e2bc28e8d..4576511c99f56 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -5,6 +5,7 @@
  * Shared functions for accessing and configuring the MAC
  */
 
+#include <linux/bitfield.h>
 #include "e1000.h"
 
 static s32 e1000_check_downshift(struct e1000_hw *hw);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
index af1b0cde36703..ae700a1807c65 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2019 Intel Corporation. */
 
+#include <linux/bitfield.h>
 #include "fm10k_pf.h"
 #include "fm10k_vf.h"
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_vf.c b/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
index dc8ccd378ec92..c50928ec14fff 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_vf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2019 Intel Corporation. */
 
+#include <linux/bitfield.h>
 #include "fm10k_vf.h"
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index e0685219dbde9..4d7caa1199719 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #include <linux/avf/virtchnl.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
diff --git a/drivers/net/ethernet/intel/i40e/i40e_dcb.c b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
index 68602fc375f62..d57dd30b024fa 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_dcb.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2021 Intel Corporation. */
 
+#include <linux/bitfield.h>
+#include "i40e_adminq.h"
 #include "i40e_alloc.h"
 #include "i40e_dcb.h"
 #include "i40e_prototype.h"
diff --git a/drivers/net/ethernet/intel/i40e/i40e_nvm.c b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
index 77cdbfc19d477..e5aec09d58e27 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_nvm.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include "i40e_alloc.h"
 #include "i40e_prototype.h"
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 1afd761d80520..f7988cf5efa58 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include <linux/avf/virtchnl.h>
+#include <linux/bitfield.h>
 #include "iavf_type.h"
 #include "iavf_adminq.h"
 #include "iavf_prototype.h"
-#include <linux/avf/virtchnl.h>
 
 /**
  * iavf_set_mac_type - Sets MAC type
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 892c6a4f03bb8..1ac97bd606e38 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1,11 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include <linux/bitfield.h>
+#include <linux/uaccess.h>
+
 /* ethtool support for iavf */
 #include "iavf.h"
 
-#include <linux/uaccess.h>
-
 /* ethtool statistics helpers */
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.c b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
index 03e774bd2a5b4..65ddcd81c993e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
@@ -3,6 +3,7 @@
 
 /* flow director ethtool support for iavf */
 
+#include <linux/bitfield.h>
 #include "iavf.h"
 
 #define GTPU_PORT	2152
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 8c5f6096b0022..f998ecf743c46 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include <linux/bitfield.h>
 #include <linux/prefetch.h>
 
 #include "iavf.h"
diff --git a/drivers/net/ethernet/intel/igb/e1000_i210.c b/drivers/net/ethernet/intel/igb/e1000_i210.c
index b9b9d35494d27..53b396fd194a3 100644
--- a/drivers/net/ethernet/intel/igb/e1000_i210.c
+++ b/drivers/net/ethernet/intel/igb/e1000_i210.c
@@ -5,9 +5,9 @@
  * e1000_i211
  */
 
-#include <linux/types.h>
+#include <linux/bitfield.h>
 #include <linux/if_ether.h>
-
+#include <linux/types.h>
 #include "e1000_hw.h"
 #include "e1000_i210.h"
 
diff --git a/drivers/net/ethernet/intel/igb/e1000_nvm.c b/drivers/net/ethernet/intel/igb/e1000_nvm.c
index fa136e6e93285..0da57e89593a0 100644
--- a/drivers/net/ethernet/intel/igb/e1000_nvm.c
+++ b/drivers/net/ethernet/intel/igb/e1000_nvm.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2007 - 2018 Intel Corporation. */
 
-#include <linux/if_ether.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
-
+#include <linux/if_ether.h>
 #include "e1000_mac.h"
 #include "e1000_nvm.h"
 
diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index a018000f7db92..3c1b562a3271c 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2007 - 2018 Intel Corporation. */
 
-#include <linux/if_ether.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
-
+#include <linux/if_ether.h>
 #include "e1000_mac.h"
 #include "e1000_phy.h"
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 7ff2752dd763a..c748668bf2fce 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -3,25 +3,25 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/vmalloc.h>
-#include <linux/pagemap.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
-#include <linux/netdevice.h>
-#include <linux/tcp.h>
-#include <linux/ipv6.h>
-#include <linux/slab.h>
-#include <net/checksum.h>
-#include <net/ip6_checksum.h>
-#include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
+#include <linux/init.h>
+#include <linux/ipv6.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/pagemap.h>
+#include <linux/pci.h>
 #include <linux/prefetch.h>
 #include <linux/sctp.h>
-
+#include <linux/slab.h>
+#include <linux/tcp.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+#include <net/checksum.h>
+#include <net/ip6_checksum.h>
 #include "igbvf.h"
 
 char igbvf_driver_name[] = "igbvf";
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index 17546a035ab19..d2562c8e8015e 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c)  2018 Intel Corporation */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 
 #include "igc_hw.h"
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 53b77c969c857..d0d9e7170154c 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c)  2018 Intel Corporation */
 
+#include <linux/bitfield.h>
 #include "igc_phy.h"
 
 /**
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 6424aa06fb08d..6e950594215a0 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -5,6 +5,7 @@
 #define _VIRTCHNL_H_
 
 #include <linux/bitops.h>
+#include <linux/bits.h>
 #include <linux/overflow.h>
 #include <uapi/linux/if_ether.h>
 
-- 
2.43.0



