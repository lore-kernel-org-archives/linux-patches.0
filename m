Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5135E53A7;
	Fri,  6 Dec 2024 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498644; cv=none; b=fxi/5atRsULOzYfYbP6iypPrugxc0luDc7AMM3Z3HVt+KKNEJxZ8tQDqnKg+s4iSZaZOPT8VCcXxGRo8CyLOp6mut3B4dOS35zsVxbgvPDYnTN+qA+VqSu16CGPINkQ8bah2IykUwE+p1oNohbl4jTapG7ivCIZ7No4xVcbLBzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498644; c=relaxed/simple;
	bh=kIr6dEoJPl8979oywJIguzcAUrRqiN8b2PhLfCy42ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ry9ujg15LlY/7CJfgj5cmKDJ1RZT5W1ioQA8bv4Bgi2wbD/WssPeQztn6xF8HgWB87ZfbeqEuwpxrEjk7K+TO6HlTEmE1cn1DaXz66qxACT1Z/B5s28rn2qeGmOOUmCXGO16gO47GJlzN8aSFKttxvcYpSSGXGvyN5JHjKTvtso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZvnixPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZvnixPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42CCC4CED1;
	Fri,  6 Dec 2024 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498644;
	bh=kIr6dEoJPl8979oywJIguzcAUrRqiN8b2PhLfCy42ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZvnixPXbrG5bZpyIeA2oiHNPi/W3kHgFqrgX8xou5G8QacsFgT2NtdGe+sziwY9b
	 jfzHfAvGATocFysIZWpsjBICsLYJEN4cWEW0d6JTchWcUg7QC7Gq3Z1Adi7ucHEG8d
	 9wwQ7IvqhNRMezzGRW3mtvksIXb1mONi82BoF/RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.6 645/676] PCI: keystone: Set mode as Root Complex for "ti,keystone-pcie" compatible
Date: Fri,  6 Dec 2024 15:37:44 +0100
Message-ID: <20241206143718.563606835@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1104,6 +1104,7 @@ static int ks_pcie_am654_set_mode(struct
 
 static const struct ks_pcie_of_data ks_pcie_rc_of_data = {
 	.host_ops = &ks_pcie_host_ops,
+	.mode = DW_PCIE_RC_TYPE,
 	.version = DW_PCIE_VER_365A,
 };
 


