Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA93268FDE;
	Tue,  8 Apr 2025 12:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114442; cv=none; b=ltejaz58RHn65hCdglUwRggEMmMhd8pg0TDT6NrwN8PpMZBhj+F1iT8/qbdZxwYotNmcCDAS21Gkfw9a5u2xkMANA7qqhDB/+zN8ZZMTyW46Kq6Wwh9G90U0ngoYKk9fKBM5Ozk25nbxHRj0M4ZpafzOXyIvb4C3oGs8CwdOMwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114442; c=relaxed/simple;
	bh=VRdBrwrvhOUNihDLA+Lm+BKXcz0vxPPoBjaZAgBCHV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mOHs2jKlFb/kPAgEhshOolHxUYBtn3n6agTz0gI/cRFj2Z3i/yVeEiAc7mAN/cbvcWcIOnGgr5c+p07J0/TIlZ2htFMslQO8PHR3EDuESWtunPDYUEYwYQFA6XIaQ7KuhCiH6QO5dbDv7TmlPFh87lJRwk94s69wa7PLic+yi+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkzG1vwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkzG1vwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7113C4CEE5;
	Tue,  8 Apr 2025 12:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114442;
	bh=VRdBrwrvhOUNihDLA+Lm+BKXcz0vxPPoBjaZAgBCHV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkzG1vwVCZ0SML0ZyhyJ3fo7Ndt2UlXyPKpHoEiJqU4P8YKhtZh2PFNfYkOQrJKVG
	 z3OQ1tvJwZQv6AYZ/6Ozv5qnH13Y4pKnxfBsJdeTD2xo3Gi1vArm6dGL1Ng9mB1uJQ
	 LhgkcXsptS9lFd1vqVI3A+yLzrVnWYtoKnibQeM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 108/499] PCI: dwc: ep: Return -ENOMEM for allocation failures
Date: Tue,  8 Apr 2025 12:45:20 +0200
Message-ID: <20250408104853.900217814@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8189aa56dbed0bfb46b7b30d4d231f57ab17b3f4 ]

If the bitmap or memory allocations fail, then dw_pcie_ep_init_registers()
will incorrectly return a success.

Return -ENOMEM instead.

Fixes: 869bc5253406 ("PCI: dwc: ep: Fix DBI access failure for drivers requiring refclk from host")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/36dcb6fc-f292-4dd5-bd45-a8c6f9dc3df7@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 44a617d54b15f..d6a3895e89543 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -771,6 +771,7 @@ int dw_pcie_ep_init_registers(struct dw_pcie_ep *ep)
 	if (ret)
 		return ret;
 
+	ret = -ENOMEM;
 	if (!ep->ib_window_map) {
 		ep->ib_window_map = devm_bitmap_zalloc(dev, pci->num_ib_windows,
 						       GFP_KERNEL);
-- 
2.39.5



