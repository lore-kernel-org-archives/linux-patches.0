Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032367;
	b=DovxYGcOFucbTMtM8xZ1v9cfgJjhx5C3s3tDAaCdHohfpW4Lw1n5jjsBEVxGcQAu4pUg
	 B1fCuLXkpJYU0QQUlGUda2Q7tvxKA7KStRqVCgb2RYg+J2FSLqDrLCCfv5oJYZbQet1rw
	 Iq+CJoxeJ1mNZDdcNhnBvu9q7n1N1hoa08oayV0/ugB4Pw10jgbhz4WHlfkOcFKIZ2AVx
	 bu+h2sqYSOw0A2p8WaV8dYKqPYF0rVgLO/peAtBwsezaOXZINVpKuPwZ0SpsohW/GexLi
	 4LZzbO5zZYAJYezwv4//d4KC3BG1p8qeo7I51pBiHg6IQCxZnnbTYqP6tkIGiqpj7/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EHUGS3fk9MUv2DEUzRASZSthMw9mPD34gHhtZb8AdnQ=;
	b=W63uBxSgDruts7cMSr0ysF3AVvyT2UYiDT+ryWzQA/KbH/W6SRd0M24uQ/AtTB6Z0nln
	 H0k0lisgRoggxEuhhKUtm1vNtQkhDbzI2SSls6MNZCwL10L4YRrVvkOUhCZq/X+EsGYl3
	 Py6ClcWipAcfvIZR36CB7elzOowGyXOD08tTgAuoOfKsyokZeJjYHCT1+x0wxfuYMg3hV
	 sKOBybJ/nXEzpRA3qmxjFd++2Uq9AUJ5zpufFwdI26D84lTwwuSGklyr29kdnLjXrj0d9
	 H1lzIq1z1FlOVJJQUC2KQiv21GV9XkMPT3fKJ4AwkD8mNJr1PfZfUuFAHrnAKq6AEqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gU8DTF/D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B2C606A325;
	Wed, 18 Nov 2026 20:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU8DTF/D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CE01F000C4;
	Wed, 18 Nov 2026 20:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032366;
	bh=EHUGS3fk9MUv2DEUzRASZSthMw9mPD34gHhtZb8AdnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gU8DTF/D7uyH0zBhaxNfX11UbUt3/PZ+h5fu8zM9XODx77HcpcY+s/yYXxsNdQvhc
	 SOn07tbb+Yb7tf5LIaOAv9zMQH3nvMQ+Zsfligt+86ZbloIP68DukF7rOBcP1YZ2MJ
	 H8Zo5Sm1vVZC1isl1nRx0Mqss7F4rKyC7evYLEnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d270af829aca04e783fc@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1388/1756] usb: gadget: dummy_hcd: prevent unbind via sysfs
Date: Wed, 18 Nov 2026 15:58:35 +0100
Message-ID: <20261118150104.422124391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit bdf12cde30830d46a8ef1ba93986356f1164b4f1 ]

The dummy_hcd (Host Controller) and dummy_udc (Device Controller) are
implemented as two separate platform drivers that share the same underlying
state (struct dummy). They are designed to be created and destroyed
together during the module's init and exit phases.

If userspace forces the dummy_hcd driver to unbind from the device via
sysfs, dummy_hcd_remove() cleans up the host controllers and sets the
pointers to NULL (dum->hs_hcd = NULL). However, the dummy_udc driver is
still bound to its device, meaning the USB gadget is still registered with
the udc-core subsystem.

If a new gadget driver is subsequently registered, it binds to the
still-registered dummy_udc gadget, invoking the dummy_udc_start() callback.
This callback attempts to retrieve the HCD state using
gadget_to_dummy_hcd(), which returns NULL because of the unbind. This
results in a null-pointer dereference:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
...
RIP: 0010:dummy_udc_start+0xd0/0x1f0
drivers/usb/gadget/udc/dummy_hcd.c:1022
...
Call Trace:
 <TASK>
 usb_gadget_udc_start_locked drivers/usb/gadget/udc/core.c:1237 [inline]
 gadget_bind_driver+0x3a8/0x9e0 drivers/usb/gadget/udc/core.c:1667
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
 __driver_attach+0x339/0x600 drivers/base/dd.c:1292
 bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
 bus_add_driver+0x345/0x670 drivers/base/bus.c:763
 driver_register+0x23a/0x320 drivers/base/driver.c:174
 usb_gadget_register_driver_owner+0xf9/0x270
 drivers/usb/gadget/udc/core.c:1752
 raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:596 [inline]
 raw_ioctl+0x1541/0x41c0 drivers/usb/gadget/legacy/raw_gadget.c:1307

Adding NULL checks to the UDC callbacks is not a robust solution because
there is no synchronization between dummy_hcd_remove() and the UDC
callbacks, which would result in a use-after-free race condition if the HCD
were unbound concurrently.

Fix this by setting .suppress_bind_attrs = true in both driver definitions.
This prevents userspace from unbinding these drivers dynamically, ensuring
their lifecycles remain strictly synchronized with the module's load/unload
process.

Fixes: d9b762510c18 ("[PATCH] USB dummy_hcd: Use separate pdevs for HC and UDC")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+d270af829aca04e783fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d270af829aca04e783fc
Link: https://syzkaller.appspot.com/ai_job?id=7a763ada-c07c-458f-9fea-f7e913dc1f2f
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>

Link: https://patch.msgid.link/18ec3122-7566-49e5-9964-1028857405b1@mail.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index 2a5641c3b3821..3a245bd4cfbaf 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -1184,6 +1184,7 @@ static struct platform_driver dummy_udc_driver = {
 	.resume		= dummy_udc_resume,
 	.driver		= {
 		.name	= gadget_name,
+		.suppress_bind_attrs = true,
 	},
 };
 
@@ -2807,6 +2808,7 @@ static struct platform_driver dummy_hcd_driver = {
 	.resume		= dummy_hcd_resume,
 	.driver		= {
 		.name	= driver_name,
+		.suppress_bind_attrs = true,
 	},
 };
 
-- 
2.53.0



