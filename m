Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1C94E4C50;
	Thu, 17 Sep 2026 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667569; cv=none; b=psnV3syz7Iqv/Oz+waYcT7e0QBybTL4iIC8BZqHbMn/ADq6lB1XJVFQZbY/ciRQpx9FOZn5Crbm70D8B6UszSLhArDfBeSi7grzVnVmZtgIBx3J97QRFFtzWuYuKK0AvhfTngTLrxy8pEZ0Y/wgLJV6odBGo8c5dpCIjoA51QmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667569; c=relaxed/simple;
	bh=M7r9SFw0a5T3b43VK4Hy+HelxBcyGUExOQyi5YkgKlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OH2tTM8KBzRXrMpD8lQqHHlCIoR6zHN4rk86giWTfczl29WTl/1zolp/D31aDuoYOS+OkPMzNuf+jqVtCpYw0+NrgS1J9xTku1sPB/g7aD3map4rJBEaEEMOGz+FRVT0jQn7ar8fHOK07jhL/3k97VeyRFmWwU3GkvOZGfj851U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsWclJLY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsWclJLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36411F000FF;
	Thu, 17 Sep 2026 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667568;
	bh=Kn8BbSGS8iEj5Po02mZDRi88q782CpcPdj7NRG2L2d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsWclJLYOeC31Sx9WaxqbUTEuXD3JXO5nHkTX52tF9Apvmic82c2/zXbN+cis57JK
	 79StIHTOHf7791uT8tBU7a3QdHMoqNQbfjiXPlsCx1c//wGxwNqXY8NQx+wsYe/wg7
	 R+k3d+E9ObPm2wM38TyXGPBiwp0MS/KxxM/kssOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0137/1102] usb: host: add ARCH_AIROHA in XHCI MTK dependency
Date: Thu, 17 Sep 2026 16:01:20 +0100
Message-ID: <20260917151542.961089642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit ffeaf31f05d664581aa436d9cb92b4d1d8d301ce ]

Airoha SoC use the same register map and logic of the Mediatek xHCI
driver, hence add it to the dependency list to permit compilation also
on this ARCH.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20260519164903.31258-1-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index d011d6c753edf..9d8626f36ca67 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -71,7 +71,7 @@ config USB_XHCI_HISTB
 config USB_XHCI_MTK
 	tristate "xHCI support for MediaTek SoCs"
 	select MFD_SYSCON
-	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || COMPILE_TEST
+	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || ARCH_AIROHA || COMPILE_TEST
 	help
 	  Say 'Y' to enable the support for the xHCI host controller
 	  found in MediaTek SoCs.
-- 
2.53.0



