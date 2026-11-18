Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017485;
	b=lZCKkcUtiyHhFTVVpY4mIPqR6dtqUUTuqVOVinnuC5v/QBMZgjHnyNYbhzFkcGOlclS7
	 xCtel8VdNSubWQp8MxxfpShywpNN5mwCmsYJu0/F4k/YHFIzh8up07WIRp39xwFExdDCH
	 ban9JRU9lWBkg2SL1vf88S8YITEKkW2/QG3vIvXrzhw4u5MGp2zjqrrNmVVtaWyfQw0pm
	 UAl/tEV7lEGqrKVKkH4+IHpVhZrH9xIGmHlok59y8NHm7CEJ5FiUi/xv2dL2fsDsr8GIC
	 cfbzSharamdkcu3kBX5LJe4zwkfPaQGI3V+a3mUFRZxh7SeUrc6zwR5E+v+XFShYbUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nFPFHww9dJLUwwbn/XH/JUHsmiNKL1ZDnf1Ptcxz1p8=;
	b=ZCyDUYrrtgc04d9OwBlx0uUwfVr6F8/8xSVcMEpJamdndh8RyMZFUYSkxRYwg70eC+qR
	 iyDM0yY1Nr8xBlawCYCMkRkJEcRt91RjNyiHoB3WxjzfRqRGdaD92eFP7iz7FtWSmHC0O
	 H0yjg8hkEVMwTy9tfAdWgRGbB11ZjmOEwg2e2265VnBuxKtev34A+vX7tdu63OGqicb9o
	 ctZiRmpr7fUECQuRC0AoE+U0QDHY8VFiM4eJZTU1Ro4C/PpA92k8eNQCIJMrB5KvkxNcb
	 U2sRn6dsQrtcNKKflbB8r5mUQ7SAVgkY9W11GjGR67C86RIiK/CgXdTso3gDDny8O7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRkeTGrT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982A2606A31C;
	Wed, 18 Nov 2026 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRkeTGrT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B651F000C5;
	Wed, 18 Nov 2026 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017485;
	bh=nFPFHww9dJLUwwbn/XH/JUHsmiNKL1ZDnf1Ptcxz1p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRkeTGrT9v2L7PkgmEZHHnUQI1Mnkxg68DXgeX9CTsCsYcZqhiy7Zj1eVxznlm1X5
	 0J9zZ4Zc0EtWU8vy9gXdQSNjNT0kPiN1hqf+Onn+UoFV1O+ifnoh6FExr+WAL//gmo
	 VRCcITbJOhJZf4l16uUx0CKMbGpqFWXkzt9ZgElQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Lu <alexandra.lu@nokia.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0900/2651] bus: mhi: host: pci_generic: Fix runtime PM imbalance for no_m3 devices
Date: Wed, 18 Nov 2026 15:35:40 +0100
Message-ID: <20261118150320.269228014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Lu <alexandra.lu@nokia.com>

[ Upstream commit 95601e9948b42f82600ff2d9e0c2f699a067d561 ]

mhi_pci_probe() drops the runtime PM reference taken by local_pci_probe()
only when the device supports both PME from D3hot and M3, but
mhi_pci_remove() re-takes it based on PME capability alone, without
checking no_m3.

For a device that is PME capable and has no_m3 set, probe therefore never
drops the reference while remove takes an extra one, leaving the runtime
PM usage count one higher after every bind/unbind cycle.  That is benign
for the device being removed, since the PCI core resumes it to D0 on
unbind regardless, but the struct device outlives the binding, so the
count accumulates across repeated cycles and can end up preventing
runtime suspend altogether.

Cache no_m3 in the driver's private data, as is already done for
reset_on_remove, and gate the removal side on it as well.  Unlike
reset_on_remove it is cached for virtual functions too, because the probe
side gate tests info->no_m3 for physical and virtual functions alike.

QDU100 is currently the only device that sets no_m3.

Fixes: 0494cf9793b7 ("bus: mhi: host: pci_generic: Disable runtime PM for QDU100")
Assisted-by: LLM
Signed-off-by: Alexandra Lu <alexandra.lu@nokia.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260807143353.1932381-1-alexandra.lu@nokia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index b636e2c23b4d6..eda00a2e242c4 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -1097,6 +1097,7 @@ struct mhi_pci_device {
 	struct work_struct recovery_work;
 	struct timer_list health_check_timer;
 	unsigned long status;
+	bool no_m3;
 	bool reset_on_remove;
 };
 
@@ -1409,6 +1410,8 @@ static int mhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mhi_cntrl->mru = info->mru_default;
 	mhi_cntrl->name = info->name;
 
+	mhi_pdev->no_m3 = info->no_m3;
+
 	if (!pdev->is_virtfn)
 		mhi_pdev->reset_on_remove = info->reset_on_remove;
 
@@ -1497,7 +1500,7 @@ static void mhi_pci_remove(struct pci_dev *pdev)
 	}
 
 	/* balancing probe put_noidle */
-	if (pci_pme_capable(pdev, PCI_D3hot))
+	if (pci_pme_capable(pdev, PCI_D3hot) && !mhi_pdev->no_m3)
 		pm_runtime_get_noresume(&pdev->dev);
 
 	if (mhi_pdev->reset_on_remove)
-- 
2.53.0



