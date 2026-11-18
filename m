Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024266;
	b=I1fe07rMIqCVhu6TO3LeeQhg8qIIErkpY/iB5A2TFk8Syw2Od1bN+E96m1srz/3XxWGw
	 Q9mF7Wvre77ito8IdI3e1xVtNsta9zbtN/Sl8+kSOJMyya0NXOGnxT5pYqhN7NpDcvr0l
	 /F2n9NYZ5pkkklvJsCokuHMQt3izJ9eOOHPZwAbpr6oxxoAmFAvuoraI7kuShfhK8Joeu
	 ARboh8cCET9sOx+4cHh1pah0bviEu7DDqQHAaW1EZRc110E4hMce24SE4kfbqOqlS280X
	 /+IPsjJj6mk62oqSIoDbwgOLnLka1VRE2znm/dH1ibYzmzkteFlyofTPqG4sHKkkDGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQgSh268vlyhIOV1bCou4eeHrfHUS7yp+5NenSBBuLA=;
	b=x7Y7AFW6wafPjtLgS8dIXYRmhcboI4nlcAvRMzmpcyWsM3hrHYXLsL7gbkCyz7chNlxj
	 p2HsKK7dKEQM5Mol7syP+V5DrJXbpoOUl9kamVX9038wIWkf49E5zDZIM8tm2AW9OgJ09
	 PchfEv62yPjUcg5+pIFR0da3Y9PYQl4e3hKPjrC/vDfl0hzhHJhx1gC+Ax2ta+ewG0Nts
	 5aHA4DnrMeBm+la4fxzWzNho9cnxuM+J1MDZEAJdE0umBLI7VwIyu/s17YnEx4MLPd2Za
	 pNA3HuuRghQWyTpleLGx3rmla3E4hBQwh38E5eQRRSsa9T0vQITm5CMKLHKkPOZ4Vlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=guUO5x+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56728606A31C;
	Wed, 18 Nov 2026 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=guUO5x+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0561F000C7;
	Wed, 18 Nov 2026 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024265;
	bh=kQgSh268vlyhIOV1bCou4eeHrfHUS7yp+5NenSBBuLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guUO5x+M75IQAtfCPrhRdiiZlCBiHXIgL2+h107NNFeGtqJIPI8wC/LK/E9Pkfag5
	 Lka8raU28WT5GyQhFmMc2oLEA3fVXSe7Tau4aUcAuA8v07sBVIr0F93Ut1UjgUTW6u
	 FOavd/68k1o/dyH7SmZtddnm/XM9Fp4DC7vwL0k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0665/2151] HID: Intel-thc-hid: Intel-quicki2c: Use hid_safe_input_report()
Date: Wed, 18 Nov 2026 15:40:00 +0100
Message-ID: <20261118150146.054706266@linuxfoundation.org>
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

From: Even Xu <even.xu@intel.com>

[ Upstream commit 48c72318ef1e9017b6c34cf73eed453d0dc9c2d4 ]

Replace the deprecated hid_input_report() with
hid_safe_input_report(), which takes the allocated size of the input
report buffer and allows hid-core to validate the reported data length
against the actual buffer size.

Track the allocated size of qcdev->input_buf in the new input_len
field and pass it through quicki2c_hid_send_report() to
hid_safe_input_report() to prevent potential out-of-bounds reads.

Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")

Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c | 4 +++-
 drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h | 2 ++
 drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c | 6 ++++--
 drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.h | 2 +-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
index 4588c55cf255d..85be7f87fad4c 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
@@ -295,7 +295,7 @@ static int handle_input_report(struct quicki2c_device *qcdev)
 		if (qcdev->state != QUICKI2C_ENABLED)
 			continue;
 
-		quicki2c_hid_send_report(qcdev, pkt->data,
+		quicki2c_hid_send_report(qcdev, pkt->data, qcdev->input_len,
 					 HIDI2C_DATA_LEN(le16_to_cpu(pkt->len)));
 	}
 
@@ -591,6 +591,8 @@ static int quicki2c_alloc_report_buf(struct quicki2c_device *qcdev)
 	if (!qcdev->input_buf)
 		return -ENOMEM;
 
+	qcdev->input_len = max_report_len;
+
 	if (!le16_to_cpu(qcdev->dev_desc.max_output_len))
 		qcdev->dev_desc.max_output_len = cpu_to_le16(SZ_4K);
 
diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
index 2cb5471a81336..f714e202d0d8d 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
@@ -179,6 +179,7 @@ struct acpi_device;
  * @i2c_clock_lcnt: I2C CLK low period time (unit in cycle count)
  * @report_descriptor: Store a copy of device report descriptor
  * @input_buf: Store a copy of latest input report data
+ * @input_len: The data size of the input report buffer
  * @report_buf: Store a copy of latest input/output report packet from set/get feature
  * @report_len: The length of input/output report packet
  * @reset_ack_wq: Workqueue for waiting reset response from device
@@ -212,6 +213,7 @@ struct quicki2c_device {
 
 	u8 *report_descriptor;
 	u8 *input_buf;
+	size_t input_len;
 	u8 *report_buf;
 	u32 report_len;
 
diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c
index 5c3ec95bb3fdd..47f2f0f283fe0 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c
@@ -149,16 +149,18 @@ void quicki2c_hid_remove(struct quicki2c_device *qcdev)
  *
  * @qcdev: point to quicki2c device
  * @data: point to input report data buffer
+ * @buf_size: the allocated size of the input report data buffer
  * @data_len: the length of input report data
  *
  * Return: 0 on success, non zero on error.
  */
 int quicki2c_hid_send_report(struct quicki2c_device *qcdev,
-			     void *data, size_t data_len)
+			     void *data, size_t buf_size, size_t data_len)
 {
 	int ret;
 
-	ret = hid_input_report(qcdev->hid_dev, HID_INPUT_REPORT, data, data_len, 1);
+	ret = hid_safe_input_report(qcdev->hid_dev, HID_INPUT_REPORT, data,
+				    buf_size, data_len, 1);
 	if (ret)
 		dev_err(qcdev->dev, "Failed to send HID input report, ret = %d.\n", ret);
 
diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.h b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.h
index e80df5f339fef..4c6757eca18e1 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.h
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.h
@@ -7,7 +7,7 @@
 struct quicki2c_device;
 
 int quicki2c_hid_send_report(struct quicki2c_device *qcdev,
-			     void *data, size_t data_size);
+			     void *data, size_t buf_size, size_t data_size);
 int quicki2c_hid_probe(struct quicki2c_device *qcdev);
 void quicki2c_hid_remove(struct quicki2c_device *qcdev);
 
-- 
2.53.0



