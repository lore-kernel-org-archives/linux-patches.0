Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7628118AE4
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHPpUtV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947A8C433C8;
	Mon,  6 Nov 2023 11:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269823;
	bh=hXEzNSHQKhrn77sjOHceGyDN/bAq8mScRUeOcXtyCj8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=sHPpUtV0DLElyLC2D7YyvMc2e4tZtGVLEg8MbCxgfvCOaGZeB6ubgeIh0gnQTRtfi
	 ynjbdS3rhwJ7gCRqUQ3v0e9a0RWr5H1REtlEnR/PKoBAzsi69IwE6jChRAcXix8zMe
	 J1+PRHkWk/+EpBvr/76GipX1zzwq2kXFU5HFXBDA=
Subject: Patch "can: isotp: isotp_bind(): return -EINVAL on incorrect CAN ID formatting" has been added to the 5.10-stable tree
To: derekrobertwill@gmail.com,gregkh@linuxfoundation.org,lukas.magel@posteo.net,maxime.jayat@mobile-devices.fr,michal.sojka@cvut.cz,mkl@pengutronix.de,patches@lists.linux.dev,sashal@kernel.org,socketcan@hartkopp.net
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Nov 2023 12:23:24 +0100
In-Reply-To: <20231031092918.2668-6-socketcan@hartkopp.net>
Message-ID: <2023110623-brownnose-borax-cccf@gregkh>
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

    can: isotp: isotp_bind(): return -EINVAL on incorrect CAN ID formatting

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     can-isotp-isotp_bind-return-einval-on-incorrect-can-id-formatting.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Tue Oct 31 10:30:23 2023
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 31 Oct 2023 10:29:13 +0100
Subject: can: isotp: isotp_bind(): return -EINVAL on incorrect CAN ID formatting
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sashal@kernel.org
Cc: linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Oliver Hartkopp <socketcan@hartkopp.net>, Derek Will <derekrobertwill@gmail.com>
Message-ID: <20231031092918.2668-6-socketcan@hartkopp.net>

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 2aa39889c463195a0dfe2aff9fad413139c32a4f upstream

Commit 3ea566422cbd ("can: isotp: sanitize CAN ID checks in
isotp_bind()") checks the given CAN ID address information by
sanitizing the input values.

This check (silently) removes obsolete bits by masking the given CAN
IDs.

Derek Will suggested to give a feedback to the application programmer
when the 'sanitizing' was actually needed which means the programmer
provided CAN ID content in a wrong format (e.g. SFF CAN IDs with a CAN
ID > 0x7FF).

Link: https://lore.kernel.org/all/20220515181633.76671-1-socketcan@hartkopp.net
Suggested-by: Derek Will <derekrobertwill@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1142,6 +1142,11 @@ static int isotp_bind(struct socket *soc
 	else
 		rx_id &= CAN_SFF_MASK;
 
+	/* give feedback on wrong CAN-ID values */
+	if (tx_id != addr->can_addr.tp.tx_id ||
+	    rx_id != addr->can_addr.tp.rx_id)
+		return -EINVAL;
+
 	if (!addr->can_ifindex)
 		return -ENODEV;
 


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
