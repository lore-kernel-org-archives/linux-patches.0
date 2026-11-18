Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035151;
	b=KaL4qTUi18ES4jcTXgcchaTIDtd798I0RLuTDU0nGTGbLQUKp9ZkFJhPbcGZJ+BCHHLj
	 c/I3gXUjZo0QB8zwyv+3951rpubtpKgQCqTRsYFRe+cxl77aJXxBY7gymPs0vLFm8L5Iy
	 Nsl5bfiORwE5f0kJwwT5lKe9jp/Tme2D/8rTmaqGvHDRpIZJJR5msrhCVKYPV2xm7aGJT
	 3GjsbZQTsORBZAeZv6JEGQFV2wFeNB2ygWbW+B+bAPYjmNBOy0uPivw7zur0lWASWHVG2
	 e+keApykheD65rkXMseHwwrc3UF9pp4F034PesawVY8KvbsB3giXyZhsRhXtrd0wekw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=acS0iEzOkXINvVxRDi8a0heqOjpyEBTYMAxhoF/9vNY=;
	b=YzIn0pLKY4cTjKiX2N/EAW8p0r436bdDSa++pzMSvkue7H0GpSgUh3R06UH+an2yWlZl
	 N9ZGbFrxX3RHEVlTdWgCMRw6kIXexVeYvIwU8QtmFX6oS66Qbza4uTIaEKVD55lmIMdIs
	 OTAz6xogk9tr1xujp+ENqjkntwCYN5WyqgmLndSHWpP5KL7th1vIBiZdgqG0WtuWVL1/R
	 G6w7W9LPPZBvOE88OYtlshsLnZbEybecDD6aT5ovTpkE85uyEynS6d4SF7JoxZVH0D6zN
	 AIu/tUZnjm7Ag/hOpgM1nthbxi1g/zCkb87fs/yt7HZaLM87ATf0FUQx/w0GF7H8wCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XM3cEaJR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D71606A320;
	Wed, 18 Nov 2026 20:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XM3cEaJR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3FD1F000C6;
	Wed, 18 Nov 2026 20:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035151;
	bh=acS0iEzOkXINvVxRDi8a0heqOjpyEBTYMAxhoF/9vNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XM3cEaJRR2kbCURKTiEnVEZ1j3x3jq2YiI/btHtw2Vg7KHFVv5uLMjE3NVU2mMcHv
	 wuKeyrILO6n3adhZtE6eHlxNDctxJRttmLe9UMtxPS6IkZ0ViIkhYhi2Hm44O/sJVr
	 vJovVZOA0zC17yisUSRo0+RSwUr7dddMPV/uxXlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+302b9b575a06733ff60c@syzkaller.appspotmail.com,
	Rik van Riel <riel@surriel.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.6 0623/3318] media: redrat3: fix UAF in probe error path leaving rc device registered
Date: Wed, 18 Nov 2026 15:20:45 +0100
Message-ID: <20261118150336.534359560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit af452b9e01331b5338a1e5141624f17607239207 upstream.

redrat3 stores its device name and phys path inside the main rr3
structure, and the rc device's device_name and input_phys point into
rr3. When the RC device is registered, it keeps those pointers.

  KASAN: slab-use-after-free in string_nocheck lib/vsprintf.c:648
  Read of size 1 at addr ffff888051fda758 by task udevd/7464
  Call Trace:
   string_nocheck lib/vsprintf.c:648 [inline]
   string+0x216/0x2d0 lib/vsprintf.c:730
   vsnprintf+0x74a/0xef0 lib/vsprintf.c:2945
   vscnprintf+0x41/0x90 lib/vsprintf.c:3014
   sysfs_emit+0x10e/0x180 fs/sysfs/file.c:761
   input_dev_show_name+0x58/0x70 drivers/input/input.c:1282

  Allocated by task 10:
   redrat3_dev_probe+0x477/0x2570 drivers/media/rc/redrat3.c:1023
  Freed by task 10:
   redrat3_delete drivers/media/rc/redrat3.c:466 [inline]
   redrat3_dev_probe+0x1bf4/0x2570 drivers/media/rc/redrat3.c:1124

Syzkaller triggers this via usb probing. It probes the RedRat3 USB
interface, which calls redrat3_dev_probe() in redrat3.c. That function
allocates rr3, then builds an rc device whose name points into rr3 via
redrat3_init_rc_dev() in redrat3.c, and registers it with
rc_register_device().

When the detector enable fails after the RC device is registered, the
probe jumps to the led_free path. That path unregisters the LED but does
not unregister the RC device before freeing rr3 via redrat3_delete() in
redrat3.c. The RC device still holds device_name = rr3->name which is now
freed.

Later udevd reads /sys/.../input device name via sysfs_emit() in file.c,
which calls input_dev_show_name() in input.c, which emits dev->name which
is the freed rr3->name.

When the detector enable fails after the RC device is registered, the
error path must not leave the RC device registered. Make the probe error
path clean up the same way redrat3_dev_disconnect() does.

This change should be safe because the RC device is fully registered at
this point and its teardown via rc_unregister_device() is protected by
the input device mutex, and rr3 is still alive during unregister so
device_name remains valid until after unregister. The URBs are killed
before rc_free, so no completion can run after rc is freed. No new lock
ordering is introduced.

Reported-by: syzbot+302b9b575a06733ff60c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=302b9b575a06733ff60c
Link: https://lore.kernel.org/all/6a74a76d.ec7c9571.3ac9bb.0056.GAE@google.com/
Fixes: 2154be651b90 ("[media] redrat3: new rc-core IR transceiver device driver")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2 syzkaller
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/redrat3.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -977,6 +977,7 @@ static int redrat3_dev_probe(struct usb_
 	struct device *dev = &intf->dev;
 	struct usb_host_interface *uhi;
 	struct redrat3_dev *rr3;
+	struct rc_dev *rc;
 	struct usb_endpoint_descriptor *ep;
 	struct usb_endpoint_descriptor *ep_narrow = NULL;
 	struct usb_endpoint_descriptor *ep_wide = NULL;
@@ -1121,9 +1122,12 @@ static int redrat3_dev_probe(struct usb_
 	return 0;
 
 led_free:
+	rc_unregister_device(rr3->rc);
 	led_classdev_unregister(&rr3->led);
 redrat_free:
+	rc = rr3->rc;
 	redrat3_delete(rr3, rr3->udev);
+	rc_free_device(rc);
 
 no_endpoints:
 	return retval;


