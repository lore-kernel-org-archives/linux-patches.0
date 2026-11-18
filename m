Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027538;
	b=KX1qArhpxACK5X5Z9KuxKY7RrMuhYWBO1MAbzH6ES9jScJ3kSDdhht77iKhpFtZKzhQI
	 JBKfLXPXS0zcfN5ANVr0FgGaCaZRxNMNjU3caPA8EdjyV+dge6gjXwySOoN9HDLDvval1
	 d43wrsNmI25W4ReN2eD+b9clpJQjQCg2BCBYDZwDtmNsY4No875EdUzmL6trpks18dGKS
	 sxyBsmjDdmGXbwwujae6tH3jORIjQiv1nIfKcrhvuS+yIflMWVFPMm/tXcZyqTcM39zVx
	 kMVOwDwD3RYwLC1pjg9dIOWxZgR7lBaoq9HiUYaMHo8mPjFCQvjhSq6cMteIouUAlVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lCUbytVMKx+goMNFwtEfngGtH7ZMCmrVBWlpxRD39Wg=;
	b=yg7KTBcuffsnHdNVxhyh1QQ/Da7qrcgyBhEv8MNa2VHKQz86iy7LGrS+OBBhZSUSGQTk
	 +14CfEzhaPqDN5XZ+RsXWtePWzJ1DdEryonX8EK7ZpwZaAXmSByhwcbDtUi/ogs12fqhQ
	 x2Qfboj73/093+LsmOa/0vJBNWESD+escGnuc6YTOAWMpSUgzqGcQ8UyyBV9FR0rYPHBW
	 OTVLOo5q/hemreZ7E+fZC/Uk6hBLlpWguPhwWixm0MPsNIvQhX5cb6YDsGTjAG19C8VwE
	 Hx18DIzTCVUDoSVufII7EhSVn1xNxG3lSj7w3Be5xQGIx0ZpPOtYy9w8f5nf3QjJMSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNqNORyp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B6C60A260C;
	Wed, 18 Nov 2026 18:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNqNORyp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776A71F000CE;
	Wed, 18 Nov 2026 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027538;
	bh=lCUbytVMKx+goMNFwtEfngGtH7ZMCmrVBWlpxRD39Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNqNORypfoXYIVG3ooTxHmTxy0h/Aa3cAcbGK4vIv0JqXbD8IUaWmrNMaxIxLedw7
	 +7g2qCTj4pWtFFStYTjctW27nyRw68itLYUNkxbxVhJYmiXizM93rVIoW0JNsxiF2I
	 9kYiUyaSQQ03HbYkrWaFV55uDP96N19mzADqLNgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Koichiro Den <den@valinux.co.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1784/2151] PCI: rcar-gen4: Add missing PM ops
Date: Wed, 18 Nov 2026 15:58:39 +0100
Message-ID: <20261118150226.812963383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 6b8c12d354dfa9c80d82eea8c0c45d331a28be11 ]

The R-Car Gen4 PCIe controller is part of a power domain. On R-Car S4
and V4H, this is an always-on power domain which is not shut down in
suspend. On R-Car V4M, this is a dedicated A2PCIPHY power domain,
which is shut down during suspend, and the controller loses state,
which prevents the PCIe from working after resume.

Fix this by adding generic suspend/resume noirq ops for the controller,
which tear the link down on suspend, and restart it on resume. Use the
same PM ops on all of R-Car Gen4 to gracefully suspend and resume the
PCIe link on V4H and S4 too.

Test case which demonstrates the problem on R-Car V4M:

  $ hexdump -vC /sys/bus/pci/devices/0000:00:00.0/config > /tmp/pre
  $ echo s2idle > /sys/power/mem_sleep
  $ echo platform > /sys/power/pm_test
  $ echo mem > /sys/power/state
  $ hexdump -vC /sys/bus/pci/devices/0000:00:00.0/config > /tmp/post
  $ diff -Naru /tmp/pre /tmp/post
  ...
  -00000000  12 19 32 00 07 05 10 00  00 00 04 06 00 00 01 00
  +00000000  12 19 32 00 07 05 10 00  00 00 00 ff 00 00 80 00
                                            ^^^^^
                                      Class 0604->00ff

Fixes: 0270dbe4f891 ("arm64: dts: renesas: r8a779h0: Add PCIe Host and Endpoint nodes")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20261004011851.866833-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c | 27 +++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-rcar-gen4.c b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
index 9e5dc1009ed4e..5877d6f6e88c8 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -416,6 +416,8 @@ static int rcar_gen4_add_dw_pcie_rp(struct rcar_gen4_pcie *rcar)
 		return -ENODEV;
 
 	pp->num_vectors = MAX_MSI_IRQS;
+	/* Reserve an iATU window for the generic PME_Turn_Off implementation. */
+	pp->use_atu_msg = true;
 	pp->ops = &rcar_gen4_pcie_host_ops;
 
 	return dw_pcie_host_init(pp);
@@ -800,6 +802,26 @@ static int rcar_gen4_pcie_ltssm_control(struct rcar_gen4_pcie *rcar, bool enable
 	return 0;
 }
 
+static int rcar_gen4_pcie_suspend_noirq(struct device *dev)
+{
+	struct rcar_gen4_pcie *rcar = dev_get_drvdata(dev);
+
+	if (rcar->drvdata->mode != DW_PCIE_RC_TYPE)
+		return 0;
+
+	return dw_pcie_suspend_noirq(&rcar->dw);
+}
+
+static int rcar_gen4_pcie_resume_noirq(struct device *dev)
+{
+	struct rcar_gen4_pcie *rcar = dev_get_drvdata(dev);
+
+	if (rcar->drvdata->mode != DW_PCIE_RC_TYPE)
+		return 0;
+
+	return dw_pcie_resume_noirq(&rcar->dw);
+}
+
 static struct rcar_gen4_pcie_drvdata drvdata_r8a779f0_pcie = {
 	.ltssm_control = r8a779f0_pcie_ltssm_control,
 	.mode = DW_PCIE_RC_TYPE,
@@ -843,10 +865,15 @@ static const struct of_device_id rcar_gen4_pcie_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, rcar_gen4_pcie_of_match);
 
+static DEFINE_NOIRQ_DEV_PM_OPS(rcar_gen4_pcie_pm_ops,
+			       rcar_gen4_pcie_suspend_noirq,
+			       rcar_gen4_pcie_resume_noirq);
+
 static struct platform_driver rcar_gen4_pcie_driver = {
 	.driver = {
 		.name = "pcie-rcar-gen4",
 		.of_match_table = rcar_gen4_pcie_of_match,
+		.pm = pm_sleep_ptr(&rcar_gen4_pcie_pm_ops),
 		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 	.probe = rcar_gen4_pcie_probe,
-- 
2.53.0



