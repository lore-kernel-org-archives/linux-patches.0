Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA34713CA93;
	Thu, 12 Dec 2024 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016730; cv=none; b=FlP5x2NBkWQ796yuOnnfpEaYSNd96eVyyVBjyXb9+V4kiaBuZ5Po36VyyxnLJVYGvsKHn8Myud18FZo3L9qxT+PNjeGQEpS1PIOBC5lAX0ewywNVBsh0r979Z9QvP10BN3IuSyv30ZBfSPHdwrQ/QbL26a+Crw9zjfl0v10fC88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016730; c=relaxed/simple;
	bh=RAPzDKVz7GCslkY1cufuQqXTPwZGhqlYI2DJouCZlZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irz/JJJxXjeRlQPa/1VC4iMcnPMQXtLDi5heueR35DNSNbzkrIYPbA+W7PnLpKnXiDIJwlXxQt8iuVpypwZ1HEYEajCPJsbRPtjnt1XhGYNmGuyheWqKtSfu0OT8/9Z35PfU2WO/ZBeLEu5oCtXDFtMm4Z7A4G1JydufF5t5Gag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2FJwGON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2FJwGON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B913C4CECE;
	Thu, 12 Dec 2024 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016729;
	bh=RAPzDKVz7GCslkY1cufuQqXTPwZGhqlYI2DJouCZlZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2FJwGONkdASVJKeFw9TjQvkPOuS8YrqnEcW+e0tHVIoml+1qTdb6xlkrFXDZUqLv
	 IVUfveX66xExCsj4LRlXycmKTO9iu6WOljUpAliloLIZawDu481aQHtYKjj9PjAXqh
	 QvrtopHrnWjfM+AR0cmgEMc87lJveylYb22voV24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Hanson <quic_thanson@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/466] accel/qaic: Add AIC080 support
Date: Thu, 12 Dec 2024 15:57:31 +0100
Message-ID: <20241212144317.931735977@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

[ Upstream commit b8128f7815ff135f0333c1b46dcdf1543c41b860 ]

Add basic support for the new AIC080 product. The PCIe Device ID is
0xa080. AIC080 is a lower cost, lower performance SKU variant of AIC100.
>From the qaic perspective, it is the same as AIC100.

Reviewed-by: Troy Hanson <quic_thanson@quicinc.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241004195209.3910996-1-quic_jhugo@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/accel/qaic/aic080.rst | 14 ++++++++++++++
 Documentation/accel/qaic/index.rst  |  1 +
 drivers/accel/qaic/qaic_drv.c       |  4 +++-
 3 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/accel/qaic/aic080.rst

diff --git a/Documentation/accel/qaic/aic080.rst b/Documentation/accel/qaic/aic080.rst
new file mode 100644
index 0000000000000..d563771ea6ce4
--- /dev/null
+++ b/Documentation/accel/qaic/aic080.rst
@@ -0,0 +1,14 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+===============================
+ Qualcomm Cloud AI 80 (AIC080)
+===============================
+
+Overview
+========
+
+The Qualcomm Cloud AI 80/AIC080 family of products are a derivative of AIC100.
+The number of NSPs and clock rates are reduced to fit within resource
+constrained solutions. The PCIe Product ID is 0xa080.
+
+As a derivative product, all AIC100 documentation applies.
diff --git a/Documentation/accel/qaic/index.rst b/Documentation/accel/qaic/index.rst
index ad19b88d1a669..967b9dd8bacea 100644
--- a/Documentation/accel/qaic/index.rst
+++ b/Documentation/accel/qaic/index.rst
@@ -10,4 +10,5 @@ accelerator cards.
 .. toctree::
 
    qaic
+   aic080
    aic100
diff --git a/drivers/accel/qaic/qaic_drv.c b/drivers/accel/qaic/qaic_drv.c
index bf10156c334e7..f139c564eadf9 100644
--- a/drivers/accel/qaic/qaic_drv.c
+++ b/drivers/accel/qaic/qaic_drv.c
@@ -34,6 +34,7 @@
 
 MODULE_IMPORT_NS(DMA_BUF);
 
+#define PCI_DEV_AIC080			0xa080
 #define PCI_DEV_AIC100			0xa100
 #define QAIC_NAME			"qaic"
 #define QAIC_DESC			"Qualcomm Cloud AI Accelerators"
@@ -365,7 +366,7 @@ static struct qaic_device *create_qdev(struct pci_dev *pdev, const struct pci_de
 		return NULL;
 
 	qdev->dev_state = QAIC_OFFLINE;
-	if (id->device == PCI_DEV_AIC100) {
+	if (id->device == PCI_DEV_AIC080 || id->device == PCI_DEV_AIC100) {
 		qdev->num_dbc = 16;
 		qdev->dbc = devm_kcalloc(dev, qdev->num_dbc, sizeof(*qdev->dbc), GFP_KERNEL);
 		if (!qdev->dbc)
@@ -607,6 +608,7 @@ static struct mhi_driver qaic_mhi_driver = {
 };
 
 static const struct pci_device_id qaic_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, PCI_DEV_AIC080), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, PCI_DEV_AIC100), },
 	{ }
 };
-- 
2.43.0



