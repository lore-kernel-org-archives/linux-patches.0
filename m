Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644A91D5146;
	Mon,  6 Jan 2025 15:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178451; cv=none; b=p44KQzljviT4MH6Mm+ONymF7AWfFq6lVXHsq8o57kD0JNuhUGnol9JKZpDclEFb3lx/CgzdA7WSbkL4ajOKMojrlhly8E2gzjI+dureInUzmbJCF22eAzQ5SPqy3tAjjVR65FJdB53ntgGvhDbfn344G6P7lODoIiiTDpyQO7d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178451; c=relaxed/simple;
	bh=JCKWXQyNBVuS8G5SCAzK8Ulvb0S6Wn9J50KelQViuFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tER/pJIPm+2a2lBDgqNg8hbKWqazHDtxwWCMqo04e8G4hBqzSXIc8+Ds7xwM8FjJbGNtPWp5QfQrLiFDfSkz1Dams8hfiuc/JEItNGG0wE/2+NuGGnFRKN2NLpBHj4/vSgv5nzrtS0NvDPx+JNUmDm+kvLe7C1Om52luFF4ZALs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGxH+m5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGxH+m5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE514C4CED6;
	Mon,  6 Jan 2025 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178451;
	bh=JCKWXQyNBVuS8G5SCAzK8Ulvb0S6Wn9J50KelQViuFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGxH+m5MxYEOV151Tc/cWUeZPo6PNsfbZZ7FgKEMT+J/VNJA/FzYC3DDwZEKx3GWp
	 9q5R5vI8K5N1+7rRT4cejvIrHSkeSoxAfmoBOsqOdWeIlB6hvQGYpZA/oF0sL5NQXS
	 1pPjWbC/tnoipjPdjxYHMbR+mPJLJXfxLZJ0PhrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/138] thunderbolt: Add support for Intel Panther Lake-M/P
Date: Mon,  6 Jan 2025 16:16:55 +0100
Message-ID: <20250106151136.678071797@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ada11c239e73..710c905a62d8 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1367,6 +1367,14 @@ static struct pci_device_id nhi_ids[] = {
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
index 4b0fccf033e1..67ecee94d7b9 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -90,6 +90,10 @@ extern const struct tb_nhi_ops icl_nhi_ops;
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



