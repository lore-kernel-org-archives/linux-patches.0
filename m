Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1F126ED5C;
	Tue, 11 Nov 2025 01:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825089; cv=none; b=kyasdzUA1leiS/JcQCWkmsFfkvREu6uPWFMFtgQ/hwhbe+7pnSlyZxRUKJYL1D7oRiujjzJfaIKBUpdq8MRcuyZryXLonOWHgfILBstWQPWrmiN37GRESmrM2+S4MPKyaheYW4BXHPQWwtYQ7MHrcDSYqoRrLhsHUQQtPAD7BKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825089; c=relaxed/simple;
	bh=YxwH1YaTa51PKqnK8dpNIQlEEip2+SIJoSNlsSudB78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHDBc9sGuc6bsCKNyo1wYbT00VGRHB12GIlYWfE0NYi56BUtcJZIuyRPbAQVxYUgiKjP7nNKVavh0UlXRSJ7QIEvOBIFo8u6IYuywzcw8HGWDwwWtKXkwIpts+VRbaGTlFKKYoknSEDOboCNyvWDd5v0MSjTTGvN5a8gIeKbn8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BW/tlR3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BW/tlR3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CDEC4CEFB;
	Tue, 11 Nov 2025 01:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825089;
	bh=YxwH1YaTa51PKqnK8dpNIQlEEip2+SIJoSNlsSudB78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BW/tlR3Ss9OBN+1AakWpZqzRN6MsneIHwk2iReTrM8iSbqZ4y8vjoUsQZeN/LbUpU
	 BtDJyXJxsxvESmlH2bzmB4JsbZy+XZWHDrtamunOIs733dUIT/rPrRoYabTalA39u9
	 hY3sqqx3g/iS1C5tFWZnEOiPZDyIjOz/QtUefdeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 655/849] vfio/nvgrace-gpu: Add GB300 SKU to the devid table
Date: Tue, 11 Nov 2025 09:43:45 +0900
Message-ID: <20251111004552.264199674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Dave <tdave@nvidia.com>

[ Upstream commit 407aa63018d15c35a34938633868e61174d2ef6e ]

GB300 is NVIDIA's Grace Blackwell Ultra Superchip.

Add the GB300 SKU device-id to nvgrace_gpu_vfio_pci_table.

Signed-off-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Ankit Agrawal <ankita@nvidia.com>
Link: https://lore.kernel.org/r/20250925170935.121587-1-tdave@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d95761dcdd58c..36b79713fd5a5 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -995,6 +995,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
 	/* GB200 SKU */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2941) },
+	/* GB300 SKU */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x31C2) },
 	{}
 };
 
-- 
2.51.0



