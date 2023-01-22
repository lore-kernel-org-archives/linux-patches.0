Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7296A2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD6AC433EF;
	Sun, 22 Jan 2023 15:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400440;
	bh=oqR1VhxSwlrU/vPXp+4PAuGjZcXPYVrAzMFOqDcPPh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1N2pGqCs/kD7MBKsi8cEHcQLZgE41DkijIP6Cqh0IiaovhsUtautxY+FCbuwqY3C
	 6KVcnHuuuu6gnwT08BE+NE6XKqLEHCHtKaCn70aMc2m02myG20UeTqmTmVLllxwYU9
	 sTPW2LhAkEQ/g9El+cJLyBgIxMz7ZnvVbGWeEjgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 75/98] mei: me: add meteor lake point M DID
Date: Sun, 22 Jan 2023 16:04:31 +0100
Message-Id: <20230122150232.602815061@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 0c4d68261717f89fa8c4f98a6967c3832fcb3ad0 upstream.

Add Meteor Lake Point M device id.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221212220247.286019-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -111,6 +111,8 @@
 
 #define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
 
+#define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -117,6 +117,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


