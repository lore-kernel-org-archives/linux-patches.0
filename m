Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070E3BA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1D8C433D2;
	Tue,  7 Mar 2023 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210326;
	bh=SFqXgsn+8bOaD0r9xYRk1WjdzmAYRbBqIVh/vPS3q8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqxODTPAdfv1AfWTMw/d46MgIqbnxM/QZm3owZoc42U3Z/77YMwHBDUtByIBdb54D
	 E9+o5vxgeyFh4Ei9PnzRAv7ZZkh9btEJJmPkebVcH+MmlhXFTdGEFRlZ1ayp1NgZV7
	 rSDByiVEfW3cszuaEFEArq68RgBOkB/OV715Z+wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey V. Vissarionov" <gremlin@altlinux.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0506/1001] PCI/IOV: Enlarge virtfn sysfs name buffer
Date: Tue,  7 Mar 2023 17:54:38 +0100
Message-Id: <20230307170043.363635224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey V. Vissarionov <gremlin@altlinux.org>

[ Upstream commit ea0b5aa5f184cf8293c93163f0fb00505190d431 ]

The sysfs link name "virtfn%u" constructed by pci_iov_sysfs_link() requires
17 bytes to contain the longest possible string.  Increase VIRTFN_ID_LEN to
accommodate that.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

[bhelgaas: commit log, comment at #define]
Fixes: dd7cc44d0bce ("PCI: add SR-IOV API for Physical Function driver")
Link: https://lore.kernel.org/r/20221218033347.23743-1-gremlin@altlinux.org
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 952217572113c..b2e8322755c17 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -14,7 +14,7 @@
 #include <linux/delay.h>
 #include "pci.h"
 
-#define VIRTFN_ID_LEN	16
+#define VIRTFN_ID_LEN	17	/* "virtfn%u\0" for 2^32 - 1 */
 
 int pci_iov_virtfn_bus(struct pci_dev *dev, int vf_id)
 {
-- 
2.39.2



