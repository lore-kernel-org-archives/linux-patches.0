Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018418;
	b=K5i/nrOom09jROngt/vIYZEPAlVth6XDO1ye6MZMbOhWZ8igtwgqJDizNCHHa/ZQ1Eos
	 rf+Ir6yb9HxptL2ywRoQLoaq5UfH76ia3pWTYCSXSLy+wsDKyzJaRj3tTlf+dZgUOcZjR
	 bSYWZrDBcOB5CLxr65vVmaDgoQieRq5RKMPPwXnZajDgWso2J5XO1PZIulqGOMQkLNFdZ
	 d5gSZ/2Cn1H0eUz0F6C87R7sSky8T+YvSRK3uwevQBO0Dx+F9d54Wi2FJkZvco+WLDe0I
	 jq+SF3LgDJZmIeDhu6FVKFM5DOPA+39xjYot/MQFIXthXNahO1cYjh15FVi+7zq/ejg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PqgzNhsptxQTgeDF3UAUzesjrA64LpJS8dtjVMx/egY=;
	b=SM+yTVy9R7qgCpnH4Yh8EzFxr6ElCpmvwESL1+2eNXamy0GJIXuuuB9D4AZmTVxDuIw5
	 VYPLt7JPyPLOW42pglguS0f5eF1kI4lVsNFCKycE0gMZiajx3YP8+T4K3Cqu0pyPlHHrB
	 HnidRB4EpLUiqthJ0NuV9vqw7i8A+7iONPqSGozPrtH14frC+5sNjgYhA2iu0GS1Y3j02
	 vq3MdHsjVLTZL2tTD56irYi+V5ZO03t+jGgmfQC4llK4l5q37wV/jn+IEbfdm4yvnz7iv
	 aifXKdYFksD/bRKsLqSwjtrgEAcleH8LlozY9Darx0ie4lYf5Zn+tJEMCVflFasFEFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uFh1/6Y8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE08606A333;
	Wed, 18 Nov 2026 16:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFh1/6Y8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C731F000C4;
	Wed, 18 Nov 2026 16:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018418;
	bh=PqgzNhsptxQTgeDF3UAUzesjrA64LpJS8dtjVMx/egY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFh1/6Y8towNzXqhzbJ/RVyl1L5Nh2G0egFIVSQ9PvvEjRp4Igg4lp4/NqPp7ZyT/
	 ++yKj6X0mzCyD2WdhqQgD7K/S+lcpWlEsmYAgD2gNbRZSnS20KHrPqFkheRW/OUu+h
	 p03dFDPBubJvKcCSxEepVEM4f/uitlkkNxiN0ITg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1234/2651] phy: qcom: qmp-pcie: Select MFD_SYSCON for the multi-PHY driver
Date: Wed, 18 Nov 2026 15:41:14 +0100
Message-ID: <20261118150332.433122222@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 77a0e6ae5dec54fb6049e3ab88288bc40c81f9fd ]

The driver reads the active link mode through
syscon_regmap_lookup_by_phandle_args(). Without CONFIG_MFD_SYSCON the
stub returning -ENOTSUPP is compiled in instead, so probe fails for
every device and no PHY is ever registered.

Nothing in the build catches this: the driver still compiles, and arm64
defconfig happens to enable MFD_SYSCON through an unrelated select.

Fixes: 1781be3c8a5d ("phy: qcom: qmp-pcie: Add QMP PCIe Multi-PHY driver")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260825225729.230493-1-devnexen@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/qualcomm/Kconfig b/drivers/phy/qualcomm/Kconfig
index d910a5d1a1ac3..9113e10992457 100644
--- a/drivers/phy/qualcomm/Kconfig
+++ b/drivers/phy/qualcomm/Kconfig
@@ -81,6 +81,7 @@ config PHY_QCOM_QMP_PCIE_MULTIPHY
 	tristate "Qualcomm QMP PCIe Multi PHY Driver"
 	depends on PCI || COMPILE_TEST
 	select GENERIC_PHY
+	select MFD_SYSCON
 	help
 	  Enable this to support the QMP PCIe PHY transceiver that is used
 	  with PCIe controllers on Qualcomm chips. This PHY is a single
-- 
2.53.0



