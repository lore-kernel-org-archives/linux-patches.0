Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017154;
	b=usibQu7AIV250rrNedKXDMikjFJ2R7f8gPcbMLQvhOUGSk0tmVtV+T4tSxAenxaebupR
	 cL+jMzmwmmw0AzT7DrdfqRUnbHjpO/UjCZ8HqfK84MJfdrRTonutHwG+Qqu0V36e9Kt+k
	 bmyvDdtloQCQZ0ht9UAHUvyEsAQAenTfKS6xtZjhSridKmeXYEEBrK/8SiqnjWFNDAOGs
	 pRBr/+JGZAztVRq/Uzbihr0Xm2YXj+P3335c+Or0sR76rQUZ22yxn3BPNFKuVkns/m+9Z
	 Z6QmpNrKdDxE7VLA1mWooiZZ8byamLskNAB8TbvptBMrdUpofPJi2ieOYzmOOzcHIbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3mgTVs515xNx1JlKLLYfOXnf6J2U0WWSroRvaJkDBNc=;
	b=16VbLvSQVDJz02agO/TCL4ftlYtNYR38ReNhZGfNj62q9l/q/NcAWNvqRq4infL1t8sc
	 20f8hD53xkD3FDslvQUdYhovDccjgp/sQy/E1nJxA1f7N1TZfFT100TT/AZP10QllPvPO
	 +s3pEvGmhMaWRE3zT3aXDLjVTmFevOtMwPPoMhu+TkNiChE2o9juRZFJ25tQW7SSEOuKV
	 HtQCX7OBB6ks2VXBSHbsz8qyZOqP2PPw40/PRIsVgk1ogaHUYuY1c9F43uOzLS2+LRhuI
	 Q62e8vnVS2b9V0tfQm3vYgdhQv6pKe46pwy6I+8Ujki51LB420pUhjKQkxq1c7JPEaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BcvqPCov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74606606A32C;
	Wed, 18 Nov 2026 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BcvqPCov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2EC1F000C4;
	Wed, 18 Nov 2026 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017154;
	bh=3mgTVs515xNx1JlKLLYfOXnf6J2U0WWSroRvaJkDBNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BcvqPCovAfuRuAzRJkQBLkaWXnuLTPr1N8Fmui8pIe96WL3SY7XEgjzOdBV1vdmC4
	 MvjpnpcdqUX+XM28nUTPokmwD/tgyZznKPnsp0ypjxgvYWOCY03QBfRaG4cgcybOlX
	 BhSk21TFmbzAoL/rTMusdG474wraAa7EB1Tlf9PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0741/2651] HID: Intel-thc-hid: Intel-quickspi: Use hid_safe_input_report()
Date: Wed, 18 Nov 2026 15:33:01 +0100
Message-ID: <20261118150314.554407063@linuxfoundation.org>
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

From: Even Xu <even.xu@intel.com>

[ Upstream commit 291f4f310cc18ff8f5addbc3c9fbe33877283ec7 ]

Replace the deprecated hid_input_report() with
hid_safe_input_report(), which takes the allocated size of the input
report buffer and allows hid-core to validate the reported data length
against the actual buffer size.

Track the allocated size of qsdev->input_buf in the new input_len
field and pass it through quickspi_hid_send_report() to
hid_safe_input_report() to prevent potential out-of-bounds reads.

Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")

Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c     | 2 ++
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h     | 2 ++
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.c     | 6 ++++--
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.h     | 2 +-
 .../hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c    | 2 +-
 5 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
index ad676fde211b6..53023e30cf8d4 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -557,6 +557,8 @@ static int quickspi_alloc_report_buf(struct quickspi_device *qsdev)
 	if (!qsdev->input_buf)
 		return -ENOMEM;
 
+	qsdev->input_len = max_input_len;
+
 	max_report_len = max(le16_to_cpu(qsdev->dev_desc.max_output_len),
 			     le16_to_cpu(qsdev->dev_desc.max_input_len));
 
diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
index dc67a39ad546b..fe51ff51d8c0e 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
@@ -113,6 +113,7 @@ struct acpi_device;
  * @low_power_ltr_val: THC low power LTR value
  * @report_descriptor: store a copy of device report descriptor
  * @input_buf: store a copy of latest input report data
+ * @input_len: the data size of the input report buffer
  * @report_buf: store a copy of latest input/output report packet from set/get feature
  * @report_len: the length of input/output report packet
  * @reset_ack_wq: workqueue for waiting reset response from device
@@ -159,6 +160,7 @@ struct quickspi_device {
 
 	u8 *report_descriptor;
 	u8 *input_buf;
+	u32 input_len;
 	u8 *report_buf;
 	u32 report_buf_size;
 	u32 report_len;
diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.c b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.c
index a60a0a7f16aad..ed1c40b8c4fa1 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.c
@@ -148,16 +148,18 @@ void quickspi_hid_remove(struct quickspi_device *qsdev)
  *
  * @qsdev: point to quickspi device
  * @data: point to input report data buffer
+ * @buf_size: the allocated size of the input report data buffer
  * @data_len: the length of input report data
  *
  * Return: 0 on success, non zero on error.
  */
 int quickspi_hid_send_report(struct quickspi_device *qsdev,
-			     void *data, size_t data_len)
+			     void *data, size_t buf_size, size_t data_len)
 {
 	int ret;
 
-	ret = hid_input_report(qsdev->hid_dev, HID_INPUT_REPORT, data, data_len, 1);
+	ret = hid_safe_input_report(qsdev->hid_dev, HID_INPUT_REPORT, data,
+				    buf_size, data_len, 1);
 	if (ret)
 		dev_err(qsdev->dev, "Failed to send HID input report, ret = %d.\n", ret);
 
diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.h b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.h
index f640fa876a405..61b7c6be6c516 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.h
@@ -7,7 +7,7 @@
 struct quickspi_device;
 
 int quickspi_hid_send_report(struct quickspi_device *qsdev,
-			     void *data, size_t data_size);
+			     void *data, size_t buf_size, size_t data_size);
 int quickspi_hid_probe(struct quickspi_device *qsdev);
 void quickspi_hid_remove(struct quickspi_device *qsdev);
 
diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
index 847c5ec55569a..0df33c44fbffe 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
@@ -240,7 +240,7 @@ void quickspi_handle_input_data(struct quickspi_device *qsdev, u32 buf_len)
 		input_len = sizeof(body_hdr->content_id) + input_len;
 		input_report = input_body->content - sizeof(body_hdr->content_id);
 
-		ret = quickspi_hid_send_report(qsdev, input_report, input_len);
+		ret = quickspi_hid_send_report(qsdev, input_report, qsdev->input_len, input_len);
 		if (ret)
 			dev_err_once(qsdev->dev, "Failed to send HID input report: %d\n", ret);
 
-- 
2.53.0



