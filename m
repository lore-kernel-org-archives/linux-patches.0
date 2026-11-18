Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032712;
	b=StAcHOveS0spY+NeIi/8TD9qWLh6CRsElGwGndPLCOWlxrJGeoVnJl6+qyz1ZBnK3RWH
	 9P45DH89T9l2+G2xNfYl9enmR+NsWI7wpvbqJysLvwIQZsjrIPJn2bpMh9ITvaQN0kZda
	 PTEHGj6TrV9vQyIQAfLwJ3Eg9y1FxqAQisEOyAolQy2xHwRdQeCwcQWp8KsVagqE9JP3r
	 nGMQTgKVoY6WbJIE0H5MGz9NOL4ZccpB52Fuf7Tzpbs7ZH0Eau0Tw3eeOPaBHLWEXCWN9
	 IwZQZMSLqP49Wnhtt5+pGnS3LdWyITjnzlQNRqG7+IIJ7HtJ3rxsD6YgcwRNzqU1KIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CSBPvN+dW8+4ipa/iab/64Bgq6N4Xd3I8CH79393H18=;
	b=X0/ZfwpznP4h2FKyORuyBfTWaU3fjqXogzZaWBzfvfAOYASCZ5Ux29tRddDBqlcTL3ZQ
	 d0xjqP0NE+0FL0wNI1msxu+5I9heF5WNTsnW6jsIUUj0kDVATYWpchjSmvyU6eWmI5/1p
	 b5Qp2kEKQSUFHCBlz/WQPdd8/TtrmMdglF3XyhWa/pFSCwLUl2vBUtKwysndiGohtHHX2
	 7yyelCyY6AuQJEHi6nOSwQkknTmhylm0xxLZPHTRHHur4c9Cy0isaeYQOLW+HTsPrbLbm
	 N2bA+rQWI83mbHrgbbsJ1G/eAlLoa746QnFqGYm7pgxZLkD9gN1i0wOGmcHytV9lppw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYbjhQkf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F19606A33F;
	Wed, 18 Nov 2026 20:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYbjhQkf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C2C1F000C4;
	Wed, 18 Nov 2026 20:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032712;
	bh=CSBPvN+dW8+4ipa/iab/64Bgq6N4Xd3I8CH79393H18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYbjhQkfRhCZTf9zBwyvOF/FLydjpivaAud+x4XC8GOYlABsoVGUDvxt/axRvVqTq
	 hWlo5dUqI+rKqdJJO6eK8CgnGP4vFn6K9Bu77Psx7Rm4F0rc9IULGOg4ZW4h53q4GJ
	 lL1JA2U8N/o2Xd2Tx4fa9wDlawuKjlX23wVkNwB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1507/1756] mailbox: qcom-cpucp: Add support for Nord CPUCP mailbox controller
Date: Wed, 18 Nov 2026 16:00:34 +0100
Message-ID: <20261118150108.902345970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 57f731418fafb..298b357c0f9a6 100644
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



