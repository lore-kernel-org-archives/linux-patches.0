Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063553;
	b=a4JzkTT6fpvd8juHC1WVcWX7ytXLhxBV3yUxvAGEYHqsWwypYT00ay/h3Jn4ReV46m3I
	 2rvR4eUIL7iPi9cvPMNmUuHWT+hUbXp0iGU2OVjh30pTJFDsFG+OuVU2PyVcIM/qUyD+R
	 KQC5nXkG0clgRohKmvIREedBYm6HISMYx8Vwy8p6k3akOguqMM6PROShF2yvuw7N3o/yz
	 h8kaEYfUtMi2pDw43nhrB8b7oLJfcwuNuksCXPcb2zmE2vihCVjvE6BwnfJtfGfuY9ZOx
	 mNsiQLndF0IkyHAawF2jgZ0wxRpptR3ZZ+wM0BU4Qq1q4/gzBb3bU+5eAv81vlHcMcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RcHOHk1lmKbEfUPnKOTy/J1lETp0r2y3PPKFYEVUxP4=;
	b=HirCkciG9NJfxWU6dPuELJELyl6XTg3QQSChRa2hViScH/NfjTaiU+Y5F9AqMcJqsf6Z
	 QyDXaSh5BaMLJay0ZEeK/DloJcEXbpR5KB8HKT8Wg5RIFlOII+IsenKkfhqysADH+0wCS
	 qRWvJ9DRmLsU/Qa7rObwItRKUUFIrOlSQqv0bj+txU3GcK+Jb9GHpn6o8AarVgFkybkJs
	 hpax8qdk9NlBdAxm9Ezt3oMoj99arsS7K7+0uxRx/Ps56hdk1MBZaPPU6Q54Y/FVN+hlJ
	 V5Rz40mWvQ3ArkQv9clLC70UuHcUUkIj4cTSlWgbMWKNrBSQd3mGiM3prch7t8qrdWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7hB4E4r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4BC606D816;
	Sat,  7 Nov 2026 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7hB4E4r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A761C1F008A7;
	Sat,  7 Nov 2026 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063552;
	bh=RcHOHk1lmKbEfUPnKOTy/J1lETp0r2y3PPKFYEVUxP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7hB4E4r4l6iKEgb4cLxs0wIj2g97srKaXsK75hGtYHtV/OBH0N3YoX0/LZ15aKcs
	 l6JYvb/ty31PtgqVt0Rum2MaJ6OEGcbU9CmTJFvin4TATxXEjDQcoc7lhv56VgtFtM
	 6sKgX7MRzoqWfrzdQ9BrGz/nGNXx6Oj+trZji4e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0f98b0c0bdeaab2dc2fd@syzkaller.appspotmail.com,
	Sanan Hasanov <sanan.hasanov@ucf.edu>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 639/869] hwmon: (corsair-cpro) Make wait_input_report_lock IRQ safe
Date: Sat,  7 Nov 2026 08:55:21 -0500
Message-ID: <20261107134914.591280486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index bf7775a731fbe..17bb080eb9bb6 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -135,9 +135,9 @@ static int send_usb_cmd(struct ccp_device *ccp, u8 command, u8 byte1, u8 byte2,
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
@@ -156,15 +156,16 @@ static int send_usb_cmd(struct ccp_device *ccp, u8 command, u8 byte1, u8 byte2,
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



