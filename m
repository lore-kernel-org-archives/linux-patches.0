Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021074;
	b=LF5llknRlgTDLWBkLtrudrj0uyuXEFtta4gFAskEu4Aj6xvqUIwYgU31G2jV9ZoWhPvT
	 yIhD03eKp9o6nfXrmH6YiVC//m2kaoEPr0Gvyzl/G82cCvQZ3sR08k8AQVU0Vwru5SAez
	 HG9W46Lq7WGA1a6vY4Hu4E0ODOQqthTvNL1/D4YKEgwCqd2j7rWYpvrW9rMSB+DjT7c+Z
	 7qeDg+d9DQFC6kJ9UKc2C983L8cMb9iNx/t+WwheQiPuhtwbbEntKKujjJuprHnTfIGas
	 0aTtFiFSmKwKT86iNFA+yTVD5PZmDBLLc3ZR+f4GUDnMQUiuzyFaja3/INEo5dvVrzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ttWzRkkzWrTvt0ZB5CQSLtjtG7gBLPkAWUgLAk61f58=;
	b=tR3k5c516+LQHY8Q8vleIhR0gL3CHUAskXwGouLevGv8ubZuWPmIhqs+rQMDuNKKMngC
	 dVzvtUzFuzmQ+5RjRQLGWAxnHpSGIkCHTtIqsfem9cevhoZfkVAjrtRctgDa5H4IE5CZt
	 EZgi8f8ayEEA6fknDqScKPNMUCVWsFHY6INVn4ERzcbmmbRqSwH03hGXZewjIwD4PvH8f
	 u/gR5Dmbt5pqQHT2fqOBeDSZwyUN+dXfA1D7CjpbBxd3Gyr8Be1tLKjnatAp80vFNY1yd
	 wmOlmPiUSkfVhv8/yaZ755I1FmqnAPHcjUwF0gVDNAsUDrlgmwskJOx3xBF7h7wXsxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PR5G3LJW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99648606A31C;
	Wed, 18 Nov 2026 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PR5G3LJW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F001F000C4;
	Wed, 18 Nov 2026 16:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021074;
	bh=ttWzRkkzWrTvt0ZB5CQSLtjtG7gBLPkAWUgLAk61f58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PR5G3LJWJTesS/+6H7fK6BU+zkbpapHhB2uD8J9hbO3IsyRzoiZ1MJrgkxVP7Qtnp
	 pIjKJn40P22OQacnEdSGE+2qVmcwdK7fLG2gOKEVntwDZWlLWXdpLj7o4H8krBVndp
	 6jlE7KZj83zQgMGS95d2AjtUY/RUldFiMZ7udH40=
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
Subject: [PATCH 7.3 2177/2651] PCI: rcar-gen4: Add missing PM ops
Date: Wed, 18 Nov 2026 15:56:57 +0100
Message-ID: <20261118150404.166510629@linuxfoundation.org>
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
index 241adcd727894..964b45f8f9b7c 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -524,6 +524,8 @@ static int rcar_gen4_add_dw_pcie_rp(struct rcar_gen4_pcie *rcar)
 		return -ENODEV;
 
 	pp->num_vectors = MAX_MSI_IRQS;
+	/* Reserve an iATU window for the generic PME_Turn_Off implementation. */
+	pp->use_atu_msg = true;
 	pp->ops = &rcar_gen4_pcie_host_ops;
 
 	return dw_pcie_host_init(pp);
@@ -903,6 +905,26 @@ static int rcar_gen4_pcie_ltssm_control(struct rcar_gen4_pcie *rcar, bool enable
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
@@ -946,10 +968,15 @@ static const struct of_device_id rcar_gen4_pcie_of_match[] = {
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



