Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3FD1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B37C433C9;
	Mon, 21 Aug 2023 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648063;
	bh=svC5EW/wWcYF6hFHxGFiGd80cnVgqTU0VKWeb2IcgpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/YPGZ7Q3PGwWvxnd9oto9l5iOr7dvgNahskEKYVJqTOIqMUhGA8lbq1v+TgFJe8n
	 G/vHabWKSBa41Y8+/BPwR8q28gueGhyvOGuJ/MKggPjMOQqPaRzUedeJYa3ajuPn2S
	 7IlnIwLHh5ufZcRyljT8dauNaqeFiyOlsiX0YiLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 042/234] HID: intel-ish-hid: ipc: Add Arrow Lake PCI device ID
Date: Mon, 21 Aug 2023 21:40:05 +0200
Message-ID: <20230821194130.597203646@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Even Xu <even.xu@intel.com>

[ Upstream commit 4982126e3029cd59fbd1da0d9cc0365a0585fe64 ]

Add device ID of Arrow Lake-H into ishtp support list.

Signed-off-by: Even Xu <even.xu@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/hw-ish.h  | 1 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/hw-ish.h b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
index fc108f19a64c3..e99f3a3c65e15 100644
--- a/drivers/hid/intel-ish-hid/ipc/hw-ish.h
+++ b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
@@ -33,6 +33,7 @@
 #define ADL_N_DEVICE_ID		0x54FC
 #define RPL_S_DEVICE_ID		0x7A78
 #define MTL_P_DEVICE_ID		0x7E45
+#define ARL_H_DEVICE_ID		0x7745
 
 #define	REVISION_ID_CHT_A0	0x6
 #define	REVISION_ID_CHT_Ax_SI	0x0
diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index 7120b30ac51d0..55cb25038e632 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -44,6 +44,7 @@ static const struct pci_device_id ish_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, ADL_N_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, RPL_S_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MTL_P_DEVICE_ID)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, ARL_H_DEVICE_ID)},
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, ish_pci_tbl);
-- 
2.40.1



