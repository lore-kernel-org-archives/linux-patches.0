Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048090;
	b=K9rmmBd/AzP/QJiYMf95WcGnfmIseL3HdBmzIckAUtQDMtp+yLwRSpZ0+zqcFBWprIM0
	 /UZ8HHMUpKp5WFkFsrA3tNwi54n8L+mSLAoGBLZkXcOZXGp78Z0uzp+er0aA1KLduEHuJ
	 xC6PRsykByJEHt9oUgCmbIQZL+8P1KrSH0YJbFVnpJsdzCIQKWMcmLb8cMfYMOJq9G8Hv
	 pN7Yp8dSgYELSV7sWkUIloKwkS9kZiJ45g+wWjUoCXYGFExmitZ5Rv0TGGDllxKjz2Xdn
	 YcfxZwPTmX+YHOu8Wd/Qz2cjmAP1pTHhjJpVysJ+cGpbZhrN/tFAMRaW2iPj8rPYRqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRGU5xESzCDrt0inwHwEgJIjmwYnmtp+Z81rZlFxW2s=;
	b=a8cpT+QJoUtActywAfHEwudpI+kDUxFd08gT/PPmMnmoEaWQJiEKKR1ByNEeyzIGQGaa
	 0XLuI43uoNxZJJHs/MV5ZsqkmBJjIsUztMbM8jEvGbMWdHQNJqWx14aSYmDXJytjK1FYb
	 vhO9OJTnVihOyshOJOzt3fhbchkbVDBX6S8xhY2Ua4k+77B99+TLvayqtJRFZNcOZjenh
	 px/3Qu9UOFk06YASnC09nfeDfSKhIpmTBbBF8r+LLhYJM4AnnXPkxq6MMaruPUNx/8UyN
	 SwWyCIISxTozWH/i6z0Kkei6M/2Ex/x1X2g9Xeyu3HoyF6JL7v8dFJVzj/SvuN6+lfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GNXD/Kr1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F3D606A334;
	Thu, 19 Nov 2026 00:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNXD/Kr1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAD41F000C4;
	Thu, 19 Nov 2026 00:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048090;
	bh=uRGU5xESzCDrt0inwHwEgJIjmwYnmtp+Z81rZlFxW2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNXD/Kr1579Mi8sLj3AqzHhAYrxEbs/CQ+rshGAp6JPJouBwIb+Mnlsa1zbbOoCyp
	 fKLsUyrlkjx128kCSUqRK66etZM+R413nS29x//k0sICtLs6nehGT5K31jzB2oe+55
	 mm9Z9Rjwvekcx2UEkmBIuV9nO5OxEzDbafLe3m90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1872/2857] usb-storage: alauda: do not do DMA from the stack
Date: Wed, 18 Nov 2026 15:48:26 +0100
Message-ID: <20261118150308.640686130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit ec67dacb75ebd11fbe6d727e6f37c0ef5e3d3431 ]

alauda_check_status2(), alauda_get_redu_data(), alauda_erase_block(),
alauda_read_block_raw() and alauda_write_block() build their commands in
stack arrays and pass them to usb_stor_bulk_transfer_buf().
alauda_check_status2() and alauda_erase_block() also read the reply back
into a stack array.

usb_stor_msg_common() sets URB_NO_TRANSFER_DMA_MAP only when the buffer
is us->iobuf. Every other buffer reaches usb_hcd_map_urb_for_dma(),
which has warned and returned -EAGAIN for a buffer on the stack since
commit 4568136620c6 ("usb: core: Check URB setup_packet and
transfer_buffer sanity"). On a host controller that uses DMA, all of
these commands fail.

Use us->iobuf, as alauda_reset_media() in this driver and the other
usb-storage subdrivers already do. The command is sent before the reply
is read, so both can use it; sddr09_read_status() does the same.

Fixes: e80b0fade09e ("[PATCH] USB Storage: add alauda support")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217862
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260901065831.43567-2-arka@arkamondal.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/alauda.c | 70 ++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 40d34cc28344a..46039016ab82c 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -500,11 +500,14 @@ static int alauda_check_media(struct us_data *us)
 static int alauda_check_status2(struct us_data *us)
 {
 	int rc;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_GET_STATUS2,
-		0, 0, 0, 0, 3, 0, MEDIA_PORT(us)
-	};
-	unsigned char data[3];
+	unsigned char *command = us->iobuf;
+	unsigned char *data = us->iobuf;
+
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_GET_STATUS2;
+	command[6] = 3;
+	command[8] = MEDIA_PORT(us);
 
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
@@ -530,10 +533,15 @@ static int alauda_check_status2(struct us_data *us)
 static int alauda_get_redu_data(struct us_data *us, u16 pba, unsigned char *data)
 {
 	int rc;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_GET_REDU_DATA,
-		PBA_HI(pba), PBA_ZONE(pba), 0, PBA_LO(pba), 0, 0, MEDIA_PORT(us)
-	};
+	unsigned char *command = us->iobuf;
+
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_GET_REDU_DATA;
+	command[2] = PBA_HI(pba);
+	command[3] = PBA_ZONE(pba);
+	command[5] = PBA_LO(pba);
+	command[8] = MEDIA_PORT(us);
 
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
@@ -702,14 +710,20 @@ static void alauda_ensure_map_for_zone(struct us_data *us, unsigned int zone)
 static int alauda_erase_block(struct us_data *us, u16 pba)
 {
 	int rc;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_ERASE_BLOCK, PBA_HI(pba),
-		PBA_ZONE(pba), 0, PBA_LO(pba), 0x02, 0, MEDIA_PORT(us)
-	};
-	unsigned char buf[2];
+	unsigned char *command = us->iobuf;
+	unsigned char *buf = us->iobuf;
 
 	usb_stor_dbg(us, "Erasing PBA %d\n", pba);
 
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_ERASE_BLOCK;
+	command[2] = PBA_HI(pba);
+	command[3] = PBA_ZONE(pba);
+	command[5] = PBA_LO(pba);
+	command[6] = 0x02;
+	command[8] = MEDIA_PORT(us);
+
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
 	if (rc != USB_STOR_XFER_GOOD)
@@ -732,13 +746,19 @@ static int alauda_read_block_raw(struct us_data *us, u16 pba,
 		unsigned int page, unsigned int pages, unsigned char *data)
 {
 	int rc;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_READ_BLOCK, PBA_HI(pba),
-		PBA_ZONE(pba), 0, PBA_LO(pba) + page, pages, 0, MEDIA_PORT(us)
-	};
+	unsigned char *command = us->iobuf;
 
 	usb_stor_dbg(us, "pba %d page %d count %d\n", pba, page, pages);
 
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_READ_BLOCK;
+	command[2] = PBA_HI(pba);
+	command[3] = PBA_ZONE(pba);
+	command[5] = PBA_LO(pba) + page;
+	command[6] = pages;
+	command[8] = MEDIA_PORT(us);
+
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
 	if (rc != USB_STOR_XFER_GOOD)
@@ -783,13 +803,19 @@ static int alauda_write_block(struct us_data *us, u16 pba, unsigned char *data)
 {
 	int rc;
 	struct alauda_info *info = (struct alauda_info *) us->extra;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_WRITE_BLOCK, PBA_HI(pba),
-		PBA_ZONE(pba), 0, PBA_LO(pba), 32, 0, MEDIA_PORT(us)
-	};
+	unsigned char *command = us->iobuf;
 
 	usb_stor_dbg(us, "pba %d\n", pba);
 
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_WRITE_BLOCK;
+	command[2] = PBA_HI(pba);
+	command[3] = PBA_ZONE(pba);
+	command[5] = PBA_LO(pba);
+	command[6] = 32;
+	command[8] = MEDIA_PORT(us);
+
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
 	if (rc != USB_STOR_XFER_GOOD)
-- 
2.53.0



