Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058591;
	b=x/1KcmRcSpd1MobmrDUnXskkz8xqcEvNBUTMxZJT8zqoxmMys6miWc31KIgxBo8o8rzr
	 i/oDt13rYy7+nCt5roXh7SHxpVcbaQB35ffeZr1TLof2QthP3dtMboSA55oQQYva9q6Za
	 oMfhCk6Lt7/gn5+oPmMv2Zl4UkkzorgPTnRSJmiV30paNyGjVntXuVDU1rMDkfycxO6bD
	 7xZWsubsId31kABqz4zh8/5yLMvhoSATFFU2s8BAzvjjss+TxzEmJ5DIILFDvyqci1TKM
	 hyRHwnpml7IKLQOqAIzqKe4lUR8mvRoEFzPzaEXgVLGuW+8pNIWEU/k8mbw5uAyELpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K5Ki510SYY9ARFuA/OfGe7khj0F2joLrL+4mtQZ/zJ0=;
	b=ZvfP9Am9rZpj2E25lnRbD0wDkB3erWYPtmejxZtcGa8ECqFPcFsEpclF/mi0dinNr6q/
	 Q29g/JPkZfp1lesI/eD/R738d6n4Xz7WaIXCHSOSfnWXFkDOQ8cGCDf4BiBSIPbIy5dUZ
	 69R92jJbQM0y4wtn+PBDuf8hIkpsv/U2+fAKO50uvP/fxX9AbcE3m2BysLWZPFlOf5zcP
	 E5vrY21WgYtsRgckynEW4CC62jxM4s40vfX6NVR0GHY141JYvuVy+SdaEarcA6fwZRo1c
	 ff6Y4ME517+lc/HOMxV8jaSZmIfYggs9cjVND4B97LHq1yoZfSFRGUpb3vWDtASieJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IrzUUyhk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3841606A330;
	Thu, 19 Nov 2026 03:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IrzUUyhk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563C01F000C4;
	Thu, 19 Nov 2026 03:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058590;
	bh=K5Ki510SYY9ARFuA/OfGe7khj0F2joLrL+4mtQZ/zJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrzUUyhkL7YDO1Tn9SY5PADqp5FyNLkz5Sx5QodcvMrshyItWAl3ZfG3lL75W914p
	 XjVCh+MgkU5bIKD1NN27dZ0w+ztGgnKuDyj4pd78+L3lSeIfW/p3aDqMliicqH/VAA
	 wwN+uUjvjSFClj5QqdQ0qcJO4SVQhcyWVghwgiqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0f98b0c0bdeaab2dc2fd@syzkaller.appspotmail.com,
	Sanan Hasanov <sanan.hasanov@ucf.edu>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0541/1848] hwmon: (corsair-cpro) Make wait_input_report_lock IRQ safe
Date: Wed, 18 Nov 2026 15:42:59 +0100
Message-ID: <20261118145937.599795302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

[ Upstream commit e4fdc82f55cf0e3d5df5c88278da5baa76a109d1 ]

ccp_raw_event() is the HID ->raw_event() callback and takes
wait_input_report_lock with a plain spin_lock(). This callback can run
in very different contexts depending on the transport: from process
context (e.g. uhid, via a write() to /dev/uhid) with softirqs and
interrupts enabled, and from URB completion, which is softirq context
for HCDs using HCD_BH and hard interrupt context for HCDs that do not
(e.g. OHCI, UHCI).

Taking the lock from process context with softirqs enabled while the
same lock is also taken from softirq context can deadlock if the
softirq interrupts the lock holder on the same CPU. Lockdep reports:

  WARNING: inconsistent lock state
  inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
  ...
   spin_lock include/linux/spinlock.h:347 [inline]
   ccp_raw_event+0x51/0x110 drivers/hwmon/corsair-cpro.c:161
   __hid_input_report+0x41c/0x580 drivers/hid/hid-core.c:2175
   hid_irq_in+0x492/0x710 drivers/hid/usbhid/hid-core.c:287
   __usb_hcd_giveback_urb+0x378/0x540 drivers/usb/core/hcd.c:1657
   dummy_timer+0xa91/0x4cc0 drivers/usb/gadget/udc/dummy_hcd.c:2023

For the same reason, the spin_lock_bh() in send_usb_cmd() is not
sufficient when ccp_raw_event() is called from hard interrupt context.

Use spin_lock_irqsave() in ccp_raw_event(), since it may be called with
interrupts already disabled, and spin_lock_irq() in send_usb_cmd(),
which always runs in process context.

Fixes: d02abd57e794 ("hwmon: (corsair-cpro) Protect ccp->wait_input_report with a spinlock")
Reported-by: syzbot+0f98b0c0bdeaab2dc2fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0f98b0c0bdeaab2dc2fd
Cc: stable@vger.kernel.org
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
Link: https://patch.msgid.link/20261008205310.30832-1-sanan.hasanou@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index f117479096ef8..05bf1bbdc4c0a 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -128,9 +128,9 @@ static int send_usb_cmd(struct ccp_device *ccp, u8 command, u8 byte1, u8 byte2,
 	 * the raw event parsing and marked the ccp->wait_input_report
 	 * completion as done.
 	 */
-	spin_lock_bh(&ccp->wait_input_report_lock);
+	spin_lock_irq(&ccp->wait_input_report_lock);
 	reinit_completion(&ccp->wait_input_report);
-	spin_unlock_bh(&ccp->wait_input_report_lock);
+	spin_unlock_irq(&ccp->wait_input_report_lock);
 
 	ret = hid_hw_output_report(ccp->hdev, ccp->cmd_buffer, OUT_BUFFER_SIZE);
 	if (ret < 0)
@@ -149,15 +149,16 @@ static int send_usb_cmd(struct ccp_device *ccp, u8 command, u8 byte1, u8 byte2,
 static int ccp_raw_event(struct hid_device *hdev, struct hid_report *report, u8 *data, int size)
 {
 	struct ccp_device *ccp = hid_get_drvdata(hdev);
+	unsigned long flags;
 
 	/* only copy buffer when requested */
-	spin_lock(&ccp->wait_input_report_lock);
+	spin_lock_irqsave(&ccp->wait_input_report_lock, flags);
 	if (!completion_done(&ccp->wait_input_report)) {
 		memcpy(ccp->buffer, data, min(IN_BUFFER_SIZE, size));
 		ccp->buffer_recv_size = size;
 		complete_all(&ccp->wait_input_report);
 	}
-	spin_unlock(&ccp->wait_input_report_lock);
+	spin_unlock_irqrestore(&ccp->wait_input_report_lock, flags);
 
 	return 0;
 }
-- 
2.53.0



