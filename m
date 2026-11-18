Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023423;
	b=0s9x+nt6Yabfv/kJuNO81Ty/8/t4EIarJI3wZmyJw8eDRAdUh9t4OWzz27icEr5wZdSl
	 EW2yyXE8Bile5LxFrz8LJV+Z0EB5oV+AO4uIkgzZXeDkxO99avLP3NYBWAE2YJb6kObFj
	 Qzgh2/d7wGa8SO5D+sLY+UoDiE7R4hrIviXgHB7h9utC/Hu5IsS1XYolBtguWfZ5BXAD8
	 JOxu/M2fAmPdKnvjMPBfB9M84fX027YCHmxq8hDgYmpfkBUS6k358aH9RUDwgZ9ydjkZP
	 1+2KxjUZsUU31Br3kTRT420O7NDhj2lWT1IR4pAtAD7qtoJrQ9DwLXSEbVa6icImWBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4OWgQwUhrsW/YlJcGVb4AjmVNzbcV0erAnjMJz1uT8M=;
	b=SDetqrmZ9o08rHOHcGcOCpuDIvuy7lLiQSfobhedUIj/V4YzgsFHTEvtJkMOLeFw6yoI
	 RAH0WoFHuSUb3m2briwPIRs0LnntTKfI+NKqzhk7KdT+lBC5gb/ye1yUAmAuO9UtORD5m
	 psZYFlCGV8PwoV1MYnBiLdNcwPyuHZ9cjzRUE81F7X7+v+3rLIuMAjd5GAizLYuXWsOOV
	 Z5PgLybJ/KuI7b33aLg2bmiM+gmGnOmg/CCkYqwLYTiP+eG0m74zv2f1dhVnKd26Nm6o6
	 4KlwjZFqCgublZl1HDzGd0hZzlDKnqoQjsDIt1ZJWb3+cF4Pzf0fH7pHcfMHcMDDD3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01VonrVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E48606A325;
	Wed, 18 Nov 2026 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01VonrVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9DD1F000C4;
	Wed, 18 Nov 2026 17:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023423;
	bh=4OWgQwUhrsW/YlJcGVb4AjmVNzbcV0erAnjMJz1uT8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01VonrVCGubll5QmBlT53FL+uulPqh2mm9jaKi1YQUwKbULkNE+RQx1wbN8tuULzo
	 BGRYs2UiDRtFUSAXmhbDh6jW7RWoCfANKMf9bUP3LO6mvLFtB9nG3+1nV/8cflr/Ig
	 uW+TlwpKgy6oGJEqQUhfhPZNT0eeD2gVZZe94eKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0364/2151] usb: gadget: composite: avoid warning on aborted delayed status
Date: Wed, 18 Nov 2026 15:34:59 +0100
Message-ID: <20261118150135.351037496@linuxfoundation.org>
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

From: Keisuke Tsukuda <catnyaaan@outlook.com>

[ Upstream commit 048884b782b137229399b9f727b6437d9b4f1071 ]

A SET_CONFIGURATION request that disables the current configuration, or a
disconnect, can abort a control transfer whose status stage was delayed by
a function driver. The asynchronous function work can nevertheless finish
later and call usb_composite_setup_continue() after reset_config() has
cleared delayed_status.

This is an expected consequence of aborting the old control transfer, and
does not require a kernel warning. Keep the diagnostic available under
dynamic debug and ignore the obsolete completion as before.

Fixes: 2bac51a1827a ("usb: gadget: composite: reset delayed_status on reset_config")
Reported-by: syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a83a5a1ba9ff57935171
Signed-off-by: Keisuke Tsukuda <tkdkei@outlook.jp>
Link: https://patch.msgid.link/20260908203348.95825-2-tkdkei@outlook.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index e09256304dc0a..6945cc63d8825 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2740,7 +2740,7 @@ void usb_composite_setup_continue(struct usb_composite_dev *cdev)
 	spin_lock_irqsave(&cdev->lock, flags);
 
 	if (cdev->delayed_status == 0) {
-		WARN(cdev, "%s: Unexpected call\n", __func__);
+		DBG(cdev, "%s: Ignoring obsolete call\n", __func__);
 
 	} else if (--cdev->delayed_status == 0) {
 		DBG(cdev, "%s: Completing delayed status\n", __func__);
-- 
2.53.0



