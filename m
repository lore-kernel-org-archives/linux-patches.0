Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060761;
	b=T88SUGqDZGeillCCjPWDXOsAIQpoUpPqNXkXjz7tdDEROFNuYCl/ePfNE+t8WzcSUprT
	 QZshFXrYj2WD8mspvxdHSIFO+AlRXHVpz+xuw0PV0qip0g+pu4I6OniRWiN/z3WGrqODS
	 YcclvQ76Sz6eaB+eSoBRz8haJeMIPNC0HIxB7lo0ZaC2XNzM1gH4gaJ1Y2OJz9l6eD+MR
	 mXz4GuvqIEGXeHKb2Tvt7tRzZlw0RIJNuNZ0jLd1yqI8p30FMfVZjuy1LMa9SaNVFNdHY
	 EVrQWriCwQyyVL+bgbQHyp3CG95SQ+Ccp0Sxjh/AVvJ+TygnvHA75Pi9cqFTGpgwH7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SAtD9KGoXSA9FWKHql6adVuNaUBcdfEmM/sOLSVZbKI=;
	b=3YZIvdwMYGkwdYJXZ39UBsnffpGyYRSR0zkCM8LQSs8v6wU2oIN9HhXdefuu8A9Cn7vn
	 x11UNDg980m5LEWNEITQQWNB1grWE1eM2mREBaD8gljpkcwqpImjMeUF0X4RBBRSdNBDR
	 48e+7fyYcZoiGVn99S87c5VbRoa1z3ZzlOc1UKRfMlvUMDTD/LDvgYcET/HRTGi9wwad7
	 RkKPJLZ4lf/DRSqXr3P+AQsKijjm3+CGtrRj+ZJg+sUvQpq1sWPI9EOqlwbeeyUiqlVMJ
	 +MfnrTnLagjr9+KHyMCidQXxkVA9NPkFyDlstFp+jyzZtUBaJno8N64f715SLad0bVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZh7thh0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2A606A326;
	Sat,  7 Nov 2026 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZh7thh0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D631F0089F;
	Sat,  7 Nov 2026 14:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060761;
	bh=SAtD9KGoXSA9FWKHql6adVuNaUBcdfEmM/sOLSVZbKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZh7thh0/47TfMk8dZjMnGKdmUyi8/+FkT89HPwN3BjxnkmmN7iltRLy6QL84Rp0t
	 8jWOY6+GD+QLIO3CWYT+ZL+Q547dYS7yrqLsGKrvDoyH4P5pm4HG5Qy/pBYvZUiUSn
	 YvI3ye+uXh1gRsnKi+yMWcywiJsQmDLhFLjE+oys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Mohan <linmhwork@outlook.com>,
	Ali Alaei <ali.alaei.tabatabaei@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0174/1536] PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Arrow Lake-HX
Date: Sat,  7 Nov 2026 08:36:30 -0500
Message-ID: <20261107135002.545495435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Alaei <ali.alaei.tabatabaei@gmail.com>

[ Upstream commit 72b32eccbcd591b9606edacf3bd7c455176d7660 ]

On Intel Arrow Lake-HX systems (e.g. Core Ultra 9 275HX on Acer Predator
PH16-73), the VMD controller reports BUS_RESTRICT_CFG = 3 in the VMCONFIG
register. The existing switch statement only handled values 0, 1, and 2,
causing vmd_get_bus_number_start() to return -ENODEV and aborting the
entire VMD probe. This leaves NVMe drives behind the VMD controller
invisible to the kernel.

Hardware registers (VMCAP/VMCONFIG at offsets 0x40/0x44):

  VMD 0000:00:0e.0 (8086:ad0b): VMCAP=0x000f, VMCONFIG=0x03b8
  BUS_RESTRICT_CFG(0x03b8) = (0x03b8 >> 8) & 0x3 = 3

Add cfg=3 as a fallthrough to cfg=2, setting busn_start=224, which is
the correct bus number base for this hardware.

Also add a PCI_POSSIBLE_ERROR() guard after reading VMCONFIG: a failed
config space read returns 0xFFFF, and BUS_RESTRICT_CFG(0xFFFF) = 3,
so without this guard a removed or errored device would falsely match
the new case 3 instead of being caught as an error.

Reported-by: Lin Mohan <linmhwork@outlook.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221137 # Arrow-Lake-S
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221136 # Arrow-Lake-S
Signed-off-by: Ali Alaei <ali.alaei.tabatabaei@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260628143450.92492-1-ali.alaei.tabatabaei@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 8df064b62a2ff..c0e5dcd61606b 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -643,6 +643,8 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 	pci_read_config_word(dev, PCI_REG_VMCAP, &reg);
 	if (BUS_RESTRICT_CAP(reg)) {
 		pci_read_config_word(dev, PCI_REG_VMCONFIG, &reg);
+		if (PCI_POSSIBLE_ERROR(reg))
+			return -ENODEV;
 
 		switch (BUS_RESTRICT_CFG(reg)) {
 		case 0:
@@ -651,6 +653,7 @@ static int vmd_get_bus_number_start(struct vmd_dev *vmd)
 		case 1:
 			vmd->busn_start = 128;
 			break;
+		case 3:
 		case 2:
 			vmd->busn_start = 224;
 			break;
-- 
2.53.0



