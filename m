Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F0B1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB947C433C7;
	Mon, 21 Aug 2023 20:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648222;
	bh=a1Q7LCzp5dNem3+7hsF71ADo7lxbD30w5Opz0DKmD4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIbTRZaQ52Iw2WQMM+hVoLfg1semQwFu4lLWsBVwtihBgAZbzbwF8o2sVBjhgdV4W
	 VtumMB8oSlKLNbvmzFeFY5wSzQ2UZjQAAOelV+XNnML4RD2z8RSLkIgnMt9+DRPega
	 LKKemjGYEPhqQrLH94ID8sj90OAbO5k6DHCj3Q9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 060/234] thunderbolt: Add Intel Barlow Ridge PCI ID
Date: Mon, 21 Aug 2023 21:40:23 +0200
Message-ID: <20230821194131.415749508@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 6f14a210661ce03988ef4ed3c8402037c8e06539 ]

Intel Barlow Ridge is the first USB4 v2 controller from Intel. The
controller exposes standard USB4 PCI class ID in typical configurations,
however there is a way to configure it so that it uses a special class
ID to allow using s different driver than the Windows inbox one. For
this reason add the Barlow Ridge PCI ID to the Linux driver too so that
the driver can attach regardless of the class ID.

Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/nhi.c | 2 ++
 drivers/thunderbolt/nhi.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index e58beac442958..1257d1c41f8e5 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1480,6 +1480,8 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL_P_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
 	/* Any USB4 compliant host */
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_USB4, ~0) },
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index b0718020c6f59..c15a0c46c9cff 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -75,6 +75,8 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE	0x15ef
 #define PCI_DEVICE_ID_INTEL_ADL_NHI0			0x463e
 #define PCI_DEVICE_ID_INTEL_ADL_NHI1			0x466d
+#define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI	0x5781
+#define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI	0x5784
 #define PCI_DEVICE_ID_INTEL_MTL_M_NHI0			0x7eb2
 #define PCI_DEVICE_ID_INTEL_MTL_P_NHI0			0x7ec2
 #define PCI_DEVICE_ID_INTEL_MTL_P_NHI1			0x7ec3
-- 
2.40.1



