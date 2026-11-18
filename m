Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017152;
	b=Rhs2AxcM/gcZChahGil9NZGHmN9So9NScAzZG8hdKbg59XE7Q3LIzkGF/oqIW+S3gUHr
	 /gXbeeBYEX44mlzasg5SILAkNiYBRkg4iNPPRN6Lx+Y+J4XkW65PNLug47DOuS4zx5ksQ
	 +C/lSM6TW1PWQTHV8POTsZbX6ZrHqYF1xqtxhQlaOq+jApaYVXCIMGSfwqlmJo0w+wNsy
	 UxPAQeDS5gUHDpmfUiGwH3Fy28OCfY6+NNg9nwnkiuGIeZrPMif2aHCx4dCJeVo8/CLk3
	 FTZ6jYYQ9T+Fb69qjVShRceWpoL6cRuRwZ5igXxAD//N4+HEXtc9koQ59HAmFf4+u0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=InumNUp3RSQwhmmlHzLAVlY3t8KOiP0c5ebASste6LQ=;
	b=5dXXp9vGpEBPccsmfjM+co1F7zdmMhrFN1iv6TYRvm/RdDN9P2JDCaCpOJs32hMj92Rz
	 vWU0+uxqPnsNvK43YOrXmDpSGyrl8Cx5qVZd8VSbtchuZVwo04hvsJrveiWCBoqCsKRn8
	 R2eHKOgWP1DU75gSflVY8rc5/AQx0FrEibUrTeIuRLLTV9MTohXz97DkYe2p7PE19KGPH
	 /32IpqSAgQt78AUCBM1UQUqL3k0rbG6FjAq6lFfr/IZ35EyxEBZdr7NQTvG/DhDpNDT5E
	 c0hm+QGf85mHeIc9FRvtESpFFChBieT7F/RnrET+ng+islvPz9g6XvrM06Y3dlUOBqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h79jVGoc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB22606A31C;
	Wed, 18 Nov 2026 15:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h79jVGoc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FCC1F000C5;
	Wed, 18 Nov 2026 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017151;
	bh=InumNUp3RSQwhmmlHzLAVlY3t8KOiP0c5ebASste6LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h79jVGocnUofKkEPssFt2Y80vlNFXBnqXB2sB4jbD5FGvsNN0Ieot6cL+eA1EPFGs
	 FfZ2DsaqN9tWch3aNBBL3Rb4YtGSuOldYeVrdXn5/tCHRlfQUzS974G5qONgpjGg8K
	 rxNWJidCwBwXQzl3iAwdURNAfJnFtX3YNRT00s08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0740/2651] HID: Intel-thc-hid: Intel-quicki2c: Use hid_safe_input_report()
Date: Wed, 18 Nov 2026 15:33:00 +0100
Message-ID: <20261118150314.518072352@linuxfoundation.org>
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
index 2537288b50261..7a913f717efaa 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
@@ -315,7 +315,7 @@ static int handle_input_report(struct quicki2c_device *qcdev)
 		if (qcdev->state != QUICKI2C_ENABLED)
 			continue;
 
-		quicki2c_hid_send_report(qcdev, pkt->data,
+		quicki2c_hid_send_report(qcdev, pkt->data, qcdev->input_len,
 					 HIDI2C_DATA_LEN(le16_to_cpu(pkt->len)));
 	}
 
@@ -611,6 +611,8 @@ static int quicki2c_alloc_report_buf(struct quicki2c_device *qcdev)
 	if (!qcdev->input_buf)
 		return -ENOMEM;
 
+	qcdev->input_len = max_report_len;
+
 	if (!le16_to_cpu(qcdev->dev_desc.max_output_len))
 		qcdev->dev_desc.max_output_len = cpu_to_le16(SZ_4K);
 
diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
index 6d25a846153e6..e9ff0440fb546 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
@@ -181,6 +181,7 @@ struct acpi_device;
  * @low_power_ltr_val: THC low power LTR value
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
 	size_t report_len;
 
diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c
index 8075992e8732e..1a220a50d934c 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-hid.c
@@ -157,16 +157,18 @@ void quicki2c_hid_remove(struct quicki2c_device *qcdev)
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



