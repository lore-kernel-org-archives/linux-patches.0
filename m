Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272C41D07BD;
	Wed,  2 Oct 2024 14:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878764; cv=none; b=QPCIZBdXB9MKlBXeHJW3gR1gp0LDzDfsge1qVxTQN2BUX4pRbnRfoPAM/YNazXEcOqwqJnUdutInDL+4IFh9iN5kGeqkXk8mUnhWjCNlmPJ135zMMvwo0IBV7Jin30jEpvlD4IAhjEnwkCzsR6ghA7tBBpbfoaTgABY2lwaGxRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878764; c=relaxed/simple;
	bh=BbLPYrXzGI3llzLphcLAUbIvWJOOcxb9K4aBcCoSMtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC0FdjIVi9HnMwLhn+eyFOGmW/xDXi+ew8cpHNFqGAB5yPbC1DB4qLAlpc95oTwbtfC6bS3u59t5P3aBkX4mzSfC9+Z6HgZrlAx5kerUcUAa2fTHwlCKIJbmg7vvmKEfouQQjN5C4vs1YMfTj9CLStN5A34itGXtiurV7yS4OkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQRBuJqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQRBuJqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53AFC4CEC2;
	Wed,  2 Oct 2024 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878764;
	bh=BbLPYrXzGI3llzLphcLAUbIvWJOOcxb9K4aBcCoSMtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQRBuJqsCkGmVtpfUltj5AqJy16a066MwJd92eeqJJwnAWbnwSaFiSHw1H8ce7v8N
	 FmRaXfnOESy2rJdKYEXl0hqCYgzc2zmVgqCgHmXX5/tXB4RdaAkELJ87Dwqprva8XQ
	 gX9BVW9lxGtv9vFsms5ZBrS4RQuIUuzmng4k3BJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Baozi <chenbaozi@phytium.com.cn>,
	Wang Zhimin <wangzhimin1179@phytium.com.cn>,
	Chen Zhenhua <chenzhenhua@phytium.com.cn>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	Jiakun Shuai <shuaijiakun1288@phytium.com.cn>,
	WangYuli <wangyuli@uniontech.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.10 524/634] usb: xHCI: add XHCI_RESET_ON_RESUME quirk for Phytium xHCI host
Date: Wed,  2 Oct 2024 15:00:24 +0200
Message-ID: <20241002125831.788516021@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit 118ecef16cc221a23f96617016f7a205b070109f upstream.

The resume operation of Phytium Px210 xHCI host would failed
to restore state. Use the XHCI_RESET_ON_RESUME quirk to skip
it and reset the controller after resume.

Co-developed-by: Chen Baozi <chenbaozi@phytium.com.cn>
Signed-off-by: Chen Baozi <chenbaozi@phytium.com.cn>
Co-developed-by: Wang Zhimin <wangzhimin1179@phytium.com.cn>
Signed-off-by: Wang Zhimin <wangzhimin1179@phytium.com.cn>
Co-developed-by: Chen Zhenhua <chenzhenhua@phytium.com.cn>
Signed-off-by: Chen Zhenhua <chenzhenhua@phytium.com.cn>
Co-developed-by: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Signed-off-by: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Co-developed-by: Jiakun Shuai <shuaijiakun1288@phytium.com.cn>
Signed-off-by: Jiakun Shuai <shuaijiakun1288@phytium.com.cn>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/r/2C1FDC3BB34715BE+20240905040916.63199-1-wangyuli@uniontech.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -55,6 +55,9 @@
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI		0x51ed
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI	0x54ed
 
+#define PCI_VENDOR_ID_PHYTIUM		0x1db7
+#define PCI_DEVICE_ID_PHYTIUM_XHCI			0xdc27
+
 /* Thunderbolt */
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI	0x15b5
@@ -416,6 +419,10 @@ static void xhci_pci_quirks(struct devic
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 
+	if (pdev->vendor == PCI_VENDOR_ID_PHYTIUM &&
+	    pdev->device == PCI_DEVICE_ID_PHYTIUM_XHCI)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+
 	/* See https://bugzilla.kernel.org/show_bug.cgi?id=79511 */
 	if (pdev->vendor == PCI_VENDOR_ID_VIA &&
 			pdev->device == 0x3432)


