Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065252;
	b=BoNQtSk4Y7yKMHkCJ8nl8CF4WVW7Atx1aoixf6Y6bB9v9Vnt1aiEw1KQE0oGT6Kp2L2W
	 vMzHC2yCmxCa+BK/MoKQS339gE+Xjnu4OIye5QuarqTbMdixCLYzoBfV83I3j7kXeKt2R
	 l6dVnxqt+mmH/Y5ahf8R1Y9TecmeddseeSeWadnNuEX57crwGsWLkVIjJsE3h54yd7+lS
	 IcFo1pYStmBO9x+77HxI0LZya8jJcySbOqi4AeY1x+c+6kA0gMrhTuWuVUVdlvsqtrdmt
	 qe6lvC8+f/0375UDQQn9df0E2nGl5jMtZ8Fpv/iXAN4R4ShXFrft5EMIsebeehvk3ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aqsay0j8/Qn+zvdwRhsLlJ++nbmo+PMCJc/pk7awTwQ=;
	b=lVIMYhTp3IS7GLCmREXW8ZLk10x72i54IzUeCco+m76z68RiWJLpT0QNtz4t1ARdA9gE
	 NWAc5HdpZ6l/UJrbzhl+/d9Wrmz8iGT3ClT/mmEOfgDkTC4bW8fn4pZ/kjQjsF8iVjzYr
	 DkzXf+FJFQuwMEIP4uOHB2FTpXg5mtlAK1ii/MuCVGWWu0gf6jdSQvcOH8ufybI/+mKkY
	 OWxNlatgATRp26H2MlMVcj3T1i0s1z67rUWy4zhfnbgIT24IZ1nLPO9GE3rlQw/s2t/NM
	 3SiGNH5Heaz5csrJ7NOKjUD7WS2AGDbtr5uLhVqCd5rQd8t5Dzsd1GVPxvn6R2GRICg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxSjGOb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF31E606A32D;
	Sat,  7 Nov 2026 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxSjGOb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4203A1F0089F;
	Sat,  7 Nov 2026 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065251;
	bh=aqsay0j8/Qn+zvdwRhsLlJ++nbmo+PMCJc/pk7awTwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxSjGOb18M1Q+E+9VFQGWDuafXP1T5iU+cFCnAlTLdOtjvfgSJVIupqdWJ0G8cOB9
	 gbbVx3JzcRj80zcJX6J4aBCiIuxSC5O113ONNfeOVVYMahx7srODJJKHp4LVy73b2T
	 RirdqAeJbMojYQB5zjhKxYbeJyFGvsq9QM61/ooU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0979/1257] PCI: qcom-ep: Deinitialize endpoint on remove
Date: Sat,  7 Nov 2026 08:54:35 -0500
Message-ID: <20261107135006.398111927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ed1d71e41c7b2e755e0ef8e9af9cab9b6b185c4b ]

qcom_pcie_ep_probe() initializes the DesignWare PCIe endpoint with
dw_pcie_ep_init(). The probe failure paths call dw_pcie_ep_deinit() to
release the corresponding endpoint resources, but the remove path does
not perform the matching teardown after a successful probe.

As a result, resources initialized by the DesignWare endpoint core can
remain allocated when the endpoint controller is removed.

Notify endpoint functions about EPC deinitialization and call
dw_pcie_ep_deinit() before disabling the controller resources. Keep the
existing early return when the link is already disabled since Qualcomm
endpoint controllers depend on the host refclk for hardware cleanup.

This issue was found by manual code inspection.

Fixes: f55fee56a631 ("PCI: qcom-ep: Add Qualcomm PCIe Endpoint controller driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916090126.2963064-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom-ep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom-ep.c b/drivers/pci/controller/dwc/pcie-qcom-ep.c
index 56184e6ca6e69..28949386b0e87 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -944,6 +944,8 @@ static void qcom_pcie_ep_remove(struct platform_device *pdev)
 
 	if (pcie_ep->link_status == QCOM_PCIE_EP_LINK_DISABLED)
 		return;
+	pci_epc_deinit_notify(pcie_ep->pci.ep.epc);
+	dw_pcie_ep_deinit(&pcie_ep->pci.ep);
 
 	qcom_pcie_disable_resources(pcie_ep);
 }
-- 
2.53.0



