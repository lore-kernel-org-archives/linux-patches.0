Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CA014D708;
	Mon,  6 Jan 2025 15:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176761; cv=none; b=q0dlbi5T0XFEnf4zjMmvTxAAfP6fXsKuv46Id5H/8nc6LJRfiCbhjJ1H1qS+cs4ap6RbesupI8/gGgWSmKIeK56Z96ZuYYJLHuC9pUqhFHICYIYQCvOHU6yFACMbeZ2UTHxqNPK2zeuUqB/QCGvtDbhUsKAOKpxvAS9vL9nSAhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176761; c=relaxed/simple;
	bh=0AU6prH1UHiA0WluoZtgGqihG7bdLOXZju7DWTuh9mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4Ql3208lY6s+E9H8nh/FIMHNMqqhRBY7HvVXF+JljOXraiWWxE3syFDPgFUD7swLiANOQMB8bYcM9YpCMunyJqASYEjIyyuPz1bacepGi+/JqlJ/uG4Jt6Ji0ELix+A+8eLz0SxVuBLFaA3+YeMW82H1auV1WV6D5FsGO6dFHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvGbDVIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvGbDVIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14080C4CEE6;
	Mon,  6 Jan 2025 15:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176761;
	bh=0AU6prH1UHiA0WluoZtgGqihG7bdLOXZju7DWTuh9mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvGbDVIKgFvRLX7+oRiRoxkUty9KEklx9Ruaoc32aCipARqsKHmyaeeT/P452SkO4
	 cfS1Looz07FkQppo14MGaxYFaF8okXfZQtGkP8vFgin5pcQDMudM0xf6BC8b+1FSNS
	 TxEwIhRyrDt9XpfPJaj5YJKj/XGuONo2OoAo/PHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/81] thunderbolt: Add support for Intel Panther Lake-M/P
Date: Mon,  6 Jan 2025 16:15:38 +0100
Message-ID: <20250106151129.678673157@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8644b48714dca8bf2f42a4ff8311de8efc9bd8c3 ]

Intel Panther Lake-M/P has the same integrated Thunderbolt/USB4
controller as Lunar Lake. Add these PCI IDs to the driver list of
supported devices.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/nhi.c | 8 ++++++++
 drivers/thunderbolt/nhi.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 5301effa6ab0..56a9222b439a 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1483,6 +1483,14 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_LNL_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_M_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_M_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_P_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_P_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 7a07c7c1a9c2..16744f25a9a0 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -92,6 +92,10 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_RPL_NHI1			0xa76d
 #define PCI_DEVICE_ID_INTEL_LNL_NHI0			0xa833
 #define PCI_DEVICE_ID_INTEL_LNL_NHI1			0xa834
+#define PCI_DEVICE_ID_INTEL_PTL_M_NHI0			0xe333
+#define PCI_DEVICE_ID_INTEL_PTL_M_NHI1			0xe334
+#define PCI_DEVICE_ID_INTEL_PTL_P_NHI0			0xe433
+#define PCI_DEVICE_ID_INTEL_PTL_P_NHI1			0xe434
 
 #define PCI_CLASS_SERIAL_USB_USB4			0x0c0340
 
-- 
2.39.5



