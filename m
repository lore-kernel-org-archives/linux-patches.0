Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063882;
	b=Hez6NXU2o2B8sQihssBtWs/AoUnltBMEIEyW1ibyEOlwN1mu0msnQGqIac+C1H8U6ZBF
	 H8fThDtKdrQKxr1b5u5ZgKQQtwASIVjzGymJTFsr+FgDsi46pJc+p7lfHjRBHt1evFwxm
	 m7smYuMJihyrI8LcOhmYMFyzpYzHUFfYDdklEWyJT7niwSJCm5B2Hzr0x4I4YRvQwlFvN
	 qmtRr54M7Q8LNfRQXt7GHFw4kETm/KYJiX+UIMp+PwQGwPfG0tJjOjMp/L0P2F3gZXfPh
	 gTF2I2rsI3YSZcFQbJx5y9OJy4DExW9oBckUgDRYIFACi/kj9kZ2eS4I9mZhNv0JCnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pgoFmkk6qYaazPvMStb/oZlmf1o8NetSfik5E55KtrM=;
	b=QcPsSc+lx8ru1IVs5Z0R2BzObRy6n60fnn9VykH4skWWAC+daqVBfbIyxGAR22nFZTJU
	 5J+ZPHRM9AI9LH0WiXIkdvV7dn3IYM0S9jBUqtGnhY7yHiJjJWabCm09vGmUIiEinnVst
	 /esXJukqTG0UhB7J1vP/w8ABe5PbsfoB8470Ny/Zuj+u+N4Kjxbz5nIGBFqaYDf9wPlnt
	 B9VpgMzDHn0Ncnyt+2Qy3IwYvPR+DZS7YIjMiYAo7K9WN9YTblWoKcKWt6Q1uj91BsGqL
	 8/771Qiw0ju4fizKzWC9y/MIZknRiOg1C6BP0HU44J4+7lVixitBdHKI+mbPhQZ3YjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FG8XNYFa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA567606A32F;
	Sat,  7 Nov 2026 15:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FG8XNYFa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546331F008A1;
	Sat,  7 Nov 2026 15:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063881;
	bh=pgoFmkk6qYaazPvMStb/oZlmf1o8NetSfik5E55KtrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FG8XNYFaYpNgyyDCaGcXJEzMGSOtYdrs2lEJqjczTdBP6YjKtik/FPJNHox5MXdCY
	 AJoECjGq0Oyymc2We7CWkVmld7oAcRCoJZxtJVARbYw1y9SXYCC4gnb+Pi0A9Xj0TU
	 QXHgUOwg6pS4aBVBY1R9AMQToiEpMssdOYewiidk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Obbard <chris.obbard@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0047/1257] PCI: qcom: Only check bridge nodes for PERST# GPIOs
Date: Sat,  7 Nov 2026 08:39:03 -0500
Message-ID: <20261107134940.709754792@linuxfoundation.org>
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

From: Christopher Obbard <chris.obbard@oss.qualcomm.com>

[ Upstream commit 1b3b0bc2b3672e928e06997444528f8797579eb2 ]

qcom_pcie_parse_perst() walks the PCIe hierarchy described in the device
tree below its Root Port and collects the PERST# GPIOs from each bridge
node so all PERST# lines can be driven in unison during controller
bring-up, reset and power sequencing.

However, the recursive device tree walk currently visits every available
child node without checking that it is a PCI bridge. This allows the walk
to leave the PCI hierarchy and collect reset lines from children of PCI
Endpoint nodes, where those reset lines belong to other drivers.

This is reproducible on the Qualcomm RB3Gen2, where a Renesas uPD720201
USB host controller sits behind a PCIe switch downstream port. A Genesys
GL3590 USB hub connected to that controller is described as a child of
the PCI endpoint:

	pcie@2,0 {
		device_type = "pci";

		usb-controller@0,0 {
			compatible = "pci1912,0014";

			hub@1 {
				compatible = "usb5e3,610";
				reset-gpios = <&tlmm 162 GPIO_ACTIVE_HIGH>;
			};
		};
	};

The USB controller is a PCI Endpoint, and not a bridge, but the PERST#
walk descends through it and incorrectly claims the hub's reset GPIO:

	$ gpioinfo
	line 162: unnamed output consumer=PERST#

As a result, the onboard-usb-dev driver cannot acquire its reset GPIO
during probe:

	onboard-usb-dev 1c08000.pcie:...:usb-controller@0,0:hub@1: \
	  error -EBUSY: failed to get reset GPIO
	onboard-usb-dev 1c08000.pcie:...:usb-controller@0,0:hub@1: \
	  probe with driver onboard-usb-dev failed with error -16

The GPIO is also added to the root port's PERST# list and is asserted
and deasserted as part of PCIe reset sequencing. On the RB3Gen2 this
causes the USB hub to repeatedly re-enumerate:

	[  116.479598] hub 2-1:1.0: USB hub found
	[  116.488601] hub 2-1:1.0: USB hub found
	[  116.496971] hub 2-1:1.0: USB hub found
	...

This disrupts the hub and devices connected to it.

Restrict the recursive walk to children with device_type "pci", so
PERST# GPIOs are collected only from PCI bridge nodes and the walk
does not descend through endpoints.

qocm_pcie_parse_ports() has made the same distinction since
commit 45df22935bdc ("PCI: qcom: Restrict port parsing only to PCIe
bridge child nodes"), but the PERST# walk added later did not carry over
that check.

This bug is distinct from commit 3edb3a038d42 ("PCI: qcom: Skip PERST#
GPIOs provided by downstream PCIe devices"), which filters PERST# GPIOs
based on their provider. Here the GPIO is provided by the SoC TLMM; the
bug is that reset-gpios is consumed from a non-bridge node at all.

Fixes: 2fd60a2edb83 ("PCI: qcom: Parse PERST# from all PCIe bridge nodes")
Signed-off-by: Christopher Obbard <chris.obbard@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260829-wip-obbardc-drivers-pcie-qcom-rb3gen2-usb-fix-v1-1-337821131a99@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index b58a607b713f5..89a476c370988 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1953,7 +1953,7 @@ static bool qcom_pcie_is_child_node(struct device *dev,
 	return false;
 }
 
-/* Parse PERST# from all nodes in depth first manner starting from @np */
+/* Collect PERST# GPIOs from PCI bridge nodes depth-first, starting at @np */
 static int qcom_pcie_parse_perst(struct qcom_pcie *pcie,
 				 struct qcom_pcie_port *port,
 				 struct device_node *np)
@@ -2019,6 +2019,9 @@ static int qcom_pcie_parse_perst(struct qcom_pcie *pcie,
 
 parse_child_node:
 	for_each_available_child_of_node_scoped(np, child) {
+		if (!of_node_is_type(child, "pci"))
+			continue;
+
 		ret = qcom_pcie_parse_perst(pcie, port, child);
 		if (ret)
 			return ret;
-- 
2.53.0



