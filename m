Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023395;
	b=NyYegRuSYnRVqdHWfsXNOiZZc+vJTMvmwkjWCer3HGGJo10PnHYizU4aGuiUHqfEmKjw
	 cgYUpFdafiePtYoWpuJ4n8e4KkpiTJZ66/6kp6sa2igk5K9CVS26YrxnpyEN3yNgn8zCH
	 /Tr1cxFzUgllb5wwf1J0WEorzPvnNzpE8tgmD1jr6BwtteALnPmrVxyc7OktqMdQEPH/f
	 iZB/IKCckhwDwRjU2XaaA0Behg6SmV8IMFQuNYTz+Rxk7Tq0UUptWLzeBr9ppzeKvxQ92
	 LmLi+gvJTbbZU+ktb+uZmZ1w6ZIaxxq0OlAZCDLDbVj1O3qbjdU8bCF/G5FgOQyFxpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TbFtDwcOALFERbJJAj3xd1lpsPeBhCebqIuZoLBpxJU=;
	b=iI0i6Ybkt0HERJELi2XJT+G0wo5b5ZXfAPvc0/9U4YR8ZgUEncogAjdZDLfqvAjfMTAs
	 P3bBmDFvhEQA5dx03mUKe2MpZ1RSZKd6ayGzgR8HzcUN0WZGtMFfRbGcA88CbNEB99YvD
	 qUwRLali+h9LQgoG6HfvIbTfH2590K9xSsoLZhlt9hqT1sNpd1SSyk+TSm60WjUDvIGEs
	 bA1cKzpPMyja5z2XVBF1usbaNccV1veg3poD4kEcXQBO2615wZdvOhjSNqIGmETAZWbOv
	 fidt0RHpsg6PYqPAStac3qifYjhh1YAtpuNB+sa/sJ1On490TFNQ/AxfTgAoMh25e1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2c/+2VlT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9E3606CA6B;
	Wed, 18 Nov 2026 17:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2c/+2VlT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D696A1F000C4;
	Wed, 18 Nov 2026 17:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023395;
	bh=TbFtDwcOALFERbJJAj3xd1lpsPeBhCebqIuZoLBpxJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2c/+2VlTxN9Ua61+wyQ2p4jc4Aa2UkG8UOKATO5KbsodlsiCsYSKyPJCVUP8d+iAr
	 4ca7+GWMwl7TWZw4ULVrnM36nLUdAPJyGEoXKmYX13XMiI/B1WSIam1A30l6U+Zxcv
	 QBU3RmaDmAfaI3z/cwcCXFSeHjExlhWdctSvGzvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0355/2151] usb-storage: alauda: do not do DMA from the stack
Date: Wed, 18 Nov 2026 15:34:50 +0100
Message-ID: <20261118150135.030996033@linuxfoundation.org>
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
index e01f3a42bde42..fac8336c0db2b 100644
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



