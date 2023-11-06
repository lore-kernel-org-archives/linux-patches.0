Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3752C1864D
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJzVFk2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B6FC433C8;
	Mon,  6 Nov 2023 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269813;
	bh=9xk7RTB35xUyOpwDbzas/5XQSqbTqk3MB6XkbMXxmFw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=FJzVFk2LG9wKIYhujBOc6I0T2bKjo7LcGk+yV5nPUyIbUvU7TjWRM9gqHMdyT4C7H
	 zIJRck6tssLrvfttNmXixl9kTpnV52ESaaa1RgRrQ7FB2RTg20dr+DOu4wrfq8iRwp
	 kKCriOs3m7O+d7qv1z2MnAT2TD6GKV7OQccvimlQ=
Subject: Patch "can: isotp: check CAN address family in isotp_bind()" has been added to the 5.10-stable tree
To: gregkh@linuxfoundation.org,lukas.magel@posteo.net,maxime.jayat@mobile-devices.fr,michal.sojka@cvut.cz,mkl@pengutronix.de,patches@lists.linux.dev,sashal@kernel.org,socketcan@hartkopp.net,syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Nov 2023 12:23:21 +0100
In-Reply-To: <20231031092918.2668-7-socketcan@hartkopp.net>
Message-ID: <2023110620-ducktail-aorta-8dcf@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    can: isotp: check CAN address family in isotp_bind()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     can-isotp-check-can-address-family-in-isotp_bind.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Tue Oct 31 10:30:27 2023
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 31 Oct 2023 10:29:14 +0100
Subject: can: isotp: check CAN address family in isotp_bind()
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sashal@kernel.org
Cc: linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Oliver Hartkopp <socketcan@hartkopp.net>, syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Message-ID: <20231031092918.2668-7-socketcan@hartkopp.net>

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit c6adf659a8ba85913e16a571d5a9bcd17d3d1234 upstream

Add missing check to block non-AF_CAN binds.

Syzbot created some code which matched the right sockaddr struct size
but used AF_XDP (0x2C) instead of AF_CAN (0x1D) in the address family
field:

bind$xdp(r2, &(0x7f0000000540)={0x2c, 0x0, r4, 0x0, r2}, 0x10)
                                ^^^^
This has no funtional impact but the userspace should be notified about
the wrong address family field content.

Link: https://syzkaller.appspot.com/text?tag=CrashLog&x=11ff9d8c480000
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230104201844.13168-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1129,6 +1129,9 @@ static int isotp_bind(struct socket *soc
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
+	if (addr->can_family != AF_CAN)
+		return -EINVAL;
+
 	/* sanitize tx/rx CAN identifiers */
 	tx_id = addr->can_addr.tp.tx_id;
 	if (tx_id & CAN_EFF_FLAG)


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.10/ext4-avoid-overlapping-preallocations-due-to-overflow.patch
queue-5.10/can-isotp-isotp_bind-do-not-validate-unused-address-information.patch
queue-5.10/can-isotp-set-max-pdu-size-to-64-kbyte.patch
queue-5.10/can-isotp-isotp_bind-return-einval-on-incorrect-can-id-formatting.patch
queue-5.10/ext4-fix-bug-in-ext4_mb_new_inode_pa-due-to-overflow.patch
queue-5.10/can-isotp-add-symbolic-error-message-to-isotp_module_init.patch
queue-5.10/rpmsg-fix-calling-device_lock-on-non-initialized-device.patch
queue-5.10/can-isotp-change-error-format-from-decimal-to-symbolic-error-names.patch
queue-5.10/can-isotp-isotp_sendmsg-fix-tx-state-detection-and-wait-behavior.patch
queue-5.10/rpmsg-constify-local-variable-in-field-store-macro.patch
queue-5.10/can-isotp-add-error-message-if-txqueuelen-is-too-small.patch
queue-5.10/rpmsg-glink-release-driver_override.patch
queue-5.10/driver-platform-add-helper-for-safer-setting-of-driver_override.patch
queue-5.10/can-isotp-check-can-address-family-in-isotp_bind.patch
queue-5.10/rpmsg-fix-kfree-of-static-memory-on-setting-driver_override.patch
queue-5.10/can-isotp-add-local-echo-tx-processing-and-tx-without-fc.patch
queue-5.10/can-isotp-handle-wait_event_interruptible-return-values.patch
queue-5.10/rpmsg-fix-possible-refcount-leak-in-rpmsg_register_device_override.patch
queue-5.10/ext4-add-two-helper-functions-extent_logical_end-and-pa_logical_end.patch
