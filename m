Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027702;
	b=fKRKl0xnSyOCW59onLvJbhGsYSc2qkCewycHBWkH3BzKU5rFkNlkKMufk1YVL9JGcMuV
	 JT/1V6gop1JGPaakQdbnzhrfGl2Uq0KY1UScxeQILswRE3g+Kfn7MRcQXtRKG0OYhhuvf
	 DzAC5fjrzx32NFTyz10K0FaPQDKYx8vIQSmezGQHib5dnyEkStEsAdRnSmVQYo5aSERvf
	 OLK2E58HLfypJFHc5DoY64/gBiqeWurbOVBuXkKEsUQEcRhrzlkjBOvhSul0HByBgeEEJ
	 mmnXcpg5K1fPV2tas+wpiEhG4h7l6bm2kMgWggeMYH71A8mET+RqW+u8w4PwdE63YdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bRNk2RTBq0cK1IV0+pu+FjxIWjJ7bBxc2BaBMgl7AWw=;
	b=E67DVMEbYUK7Cm5XZZHz+5lPA0Vo0u+L1mR5GgqzEVCAYLmthfh/78RxoDamv7MPH/1U
	 WBqd/0S+YXy9utwfHao13o4/ZEJq+0ZNgNfHOkvhgrrBADpzOmoUY6PTbjU/wSrdZ6ESo
	 QQxwdeRBdBfHqmEF+LnrQy8TIhbBN3yzzaU8CGPN4f1CTElT3P7A6l86QmGvP710Hr7tu
	 YfAjPaYAdRt2WsIKXsQtS5sM49RP3/PmsNVb463PIPlixF7FYIrLg9UbQC26r/+fOwpIr
	 /uV3we4Kfs7uVdHLzJqD+3T6U3DrzmbUA2NnwZuI0WOlfK4GqHMKHFQmq4eXIMu5lKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEWXfKHd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA17660A2610;
	Wed, 18 Nov 2026 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEWXfKHd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A321F00926;
	Wed, 18 Nov 2026 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027702;
	bh=bRNk2RTBq0cK1IV0+pu+FjxIWjJ7bBxc2BaBMgl7AWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEWXfKHdH4K+BNjJkeDfpujAe5lVYONk2oK8YlEHX8bUNP/GOW2HC42BM69v9FvpH
	 ishwSGtJ/TOodIIVEHtU75kHLU+z42xCE7z80Li/9ybAgkeEbqGrrxv2ndYGWdi8sS
	 r6AnkzXbXRtruaxbbpN1OqM3rwEpNdgk6IL6qywk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1884/2151] mailbox: qcom-cpucp: Add support for Nord CPUCP mailbox controller
Date: Wed, 18 Nov 2026 16:00:19 +0100
Message-ID: <20261118150230.429029918@linuxfoundation.org>
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

From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>

[ Upstream commit 0edda639ba13d9da37447586b5480582a2581e2b ]

The Nord SoC CPUCP mailbox supports 16 IPC channels, compared to 3 on
x1e80100. The existing driver hardcodes the channel count via a
compile-time constant (APSS_CPUCP_IPC_CHAN_SUPPORTED), making it
impossible to support hardware with a different number of channels.

Introduce a qcom_cpucp_mbox_data per-hardware configuration struct that
carries the channel count, and retrieve it via of_device_get_match_data()
at probe time. Switch the channel array from a fixed-size member to a
dynamically allocated buffer sized from the hardware data. Update the
x1e80100 entry to supply its own data struct, and add a new Nord entry
with num_chans = 16.

Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 74f1cf02d9fe ("mailbox: qcom-cpucp: read mbox hardware register using readq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-cpucp-mbox.c | 35 ++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/qcom-cpucp-mbox.c b/drivers/mailbox/qcom-cpucp-mbox.c
index d8fabc410a09c..515d2d12c01be 100644
--- a/drivers/mailbox/qcom-cpucp-mbox.c
+++ b/drivers/mailbox/qcom-cpucp-mbox.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
-#define APSS_CPUCP_IPC_CHAN_SUPPORTED		3
 #define APSS_CPUCP_MBOX_CMD_OFF			0x4
 
 /* Tx Registers */
@@ -26,6 +25,14 @@
 #define APSS_CPUCP_RX_MBOX_EN			0x4c00
 #define APSS_CPUCP_RX_MBOX_CMD_MASK		GENMASK_ULL(63, 0)
 
+/**
+ * struct qcom_cpucp_mbox_data - Per-hardware mailbox configuration data
+ * @num_chans:			Number of IPC channels supported by this hardware
+ */
+struct qcom_cpucp_mbox_data {
+	int num_chans;
+};
+
 /**
  * struct qcom_cpucp_mbox - Holder for the mailbox driver
  * @chans:			The mailbox channel
@@ -34,7 +41,7 @@
  * @rx_base:			Base address of the CPUCP rx registers
  */
 struct qcom_cpucp_mbox {
-	struct mbox_chan chans[APSS_CPUCP_IPC_CHAN_SUPPORTED];
+	struct mbox_chan *chans;
 	struct mbox_controller mbox;
 	void __iomem *tx_base;
 	void __iomem *rx_base;
@@ -53,7 +60,7 @@ static irqreturn_t qcom_cpucp_mbox_irq_fn(int irq, void *data)
 
 	status = readq(cpucp->rx_base + APSS_CPUCP_RX_MBOX_STAT);
 
-	for_each_set_bit(i, (unsigned long *)&status, APSS_CPUCP_IPC_CHAN_SUPPORTED) {
+	for_each_set_bit(i, (unsigned long *)&status, cpucp->mbox.num_chans) {
 		u32 val = readl(cpucp->rx_base + APSS_CPUCP_RX_MBOX_CMD(i) + APSS_CPUCP_MBOX_CMD_OFF);
 		struct mbox_chan *chan = &cpucp->chans[i];
 		struct mbox_client *cl;
@@ -131,15 +138,24 @@ static const struct mbox_chan_ops qcom_cpucp_mbox_chan_ops = {
 
 static int qcom_cpucp_mbox_probe(struct platform_device *pdev)
 {
+	const struct qcom_cpucp_mbox_data *data;
 	struct device *dev = &pdev->dev;
 	struct qcom_cpucp_mbox *cpucp;
 	struct mbox_controller *mbox;
 	int irq, ret;
 
+	data = of_device_get_match_data(dev);
+	if (!data)
+		return dev_err_probe(dev, -EINVAL, "No match data found\n");
+
 	cpucp = devm_kzalloc(dev, sizeof(*cpucp), GFP_KERNEL);
 	if (!cpucp)
 		return -ENOMEM;
 
+	cpucp->chans = devm_kcalloc(dev, data->num_chans, sizeof(*cpucp->chans), GFP_KERNEL);
+	if (!cpucp->chans)
+		return -ENOMEM;
+
 	cpucp->rx_base = devm_of_iomap(dev, dev->of_node, 0, NULL);
 	if (IS_ERR(cpucp->rx_base))
 		return PTR_ERR(cpucp->rx_base);
@@ -165,7 +181,7 @@ static int qcom_cpucp_mbox_probe(struct platform_device *pdev)
 
 	mbox = &cpucp->mbox;
 	mbox->dev = dev;
-	mbox->num_chans = APSS_CPUCP_IPC_CHAN_SUPPORTED;
+	mbox->num_chans = data->num_chans;
 	mbox->chans = cpucp->chans;
 	mbox->ops = &qcom_cpucp_mbox_chan_ops;
 
@@ -176,8 +192,17 @@ static int qcom_cpucp_mbox_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct qcom_cpucp_mbox_data qcom_x1e80100_mbox_data = {
+	.num_chans = 3,
+};
+
+static const struct qcom_cpucp_mbox_data qcom_nord_mbox_data = {
+	.num_chans = 16,
+};
+
 static const struct of_device_id qcom_cpucp_mbox_of_match[] = {
-	{ .compatible = "qcom,x1e80100-cpucp-mbox" },
+	{ .compatible = "qcom,nord-cpucp-mbox", .data = &qcom_nord_mbox_data },
+	{ .compatible = "qcom,x1e80100-cpucp-mbox", .data = &qcom_x1e80100_mbox_data },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qcom_cpucp_mbox_of_match);
-- 
2.53.0



