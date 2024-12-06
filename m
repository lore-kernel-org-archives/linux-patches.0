Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C731448E4;
	Fri,  6 Dec 2024 14:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496313; cv=none; b=ONzvCKc2EjLyxGHvXqMKS9VlAmTS6JYBMlJBgsr41/GVCOiBq7nk3qMayLLtg58cLcGxi1SSCqc2GBuyjIq4ju5MyZqRfe6emOagdmOqXs4zSDrsg4IhTmSEK+W2cgphH/znVbxNazKEGTB8dn9rgjq6NRaJJ3TS5VtMfbgbhDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496313; c=relaxed/simple;
	bh=A86vur1iOalXQiEsed2ko9tDbA+bww+0XJmfzzoB/lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAM+aNnNUKmb+8xnKvcw75xs/h9slhcnPXAdXJLz59W1v4sKcK1JK8R127fetYPxVlY8HeAe5PJ6e7sIG2jCx6hz7hEl8/nygH95pTbeYU8MRyNS+7LAQtHsFy1hJ+fApOFBhME1H2d4uo03M5wr3DlndKbgDh33WO8tPJXDo+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amQjGlpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amQjGlpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0FDC4CED1;
	Fri,  6 Dec 2024 14:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496312;
	bh=A86vur1iOalXQiEsed2ko9tDbA+bww+0XJmfzzoB/lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amQjGlpmB7sVGOcxH5nlAkGNoEcMv+IqDN08IxOXI+022nUkJk2bF3/InScg9zR9x
	 Ah4gO5LtQj6GHUZPxL8WxZ1GtZz+/yTqXOlNRQ2ZqfN2Alue0O2ENKhC6c2zWdzjBt
	 7zHCPld1ny8JGlYcf8QCIPnfboMJYoq39mZxgPzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 084/146] PCI: keystone: Set mode as Root Complex for "ti,keystone-pcie" compatible
Date: Fri,  6 Dec 2024 15:36:55 +0100
Message-ID: <20241206143530.894037461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 5a938ed9481b0c06cb97aec45e722a80568256fd upstream.

commit 23284ad677a9 ("PCI: keystone: Add support for PCIe EP in AM654x
Platforms") introduced configuring "enum dw_pcie_device_mode" as part of
device data ("struct ks_pcie_of_data"). However it failed to set the
mode for "ti,keystone-pcie" compatible.

Since the mode defaults to "DW_PCIE_UNKNOWN_TYPE", the following error
message is displayed for the v3.65a controller:

  "INVALID device type 0"

Despite the driver probing successfully, the controller may not be
functional in the Root Complex mode of operation.

So, set the mode as Root Complex for "ti,keystone-pcie" compatible to
fix this.

Fixes: 23284ad677a9 ("PCI: keystone: Add support for PCIe EP in AM654x Platforms")
Link: https://lore.kernel.org/r/20240524105714.191642-2-s-vadapalli@ti.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
[kwilczynski: commit log, added tag for stable releases]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-keystone.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1093,6 +1093,7 @@ static int ks_pcie_am654_set_mode(struct
 
 static const struct ks_pcie_of_data ks_pcie_rc_of_data = {
 	.host_ops = &ks_pcie_host_ops,
+	.mode = DW_PCIE_RC_TYPE,
 	.version = DW_PCIE_VER_365A,
 };
 


