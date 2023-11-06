Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C51C182BF
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgEI3ITx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D0EC433C7;
	Mon,  6 Nov 2023 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269800;
	bh=6UOYmMcqaB6HOosBsvIvyMNeqyGlPyp46fmZpukk688=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=zgEI3ITxognSEwlpfYPoquN2+lo97dRNd2m0msCIdVpRJjC+2qIJ+iNCFn4DMib/m
	 H0h5AHhhhAjuNOetatqMG8qK5DAtwJ85ze5zNewT8PJn4FFMjVtiSpF89h4zfP4X0g
	 mjmoViifPWkKHL7ZLkTX9TDZyTYR6KQNqeQGUJ6w=
Subject: Patch "can: isotp: Add error message if txqueuelen is too small" has been added to the 5.10-stable tree
To: gregkh@linuxfoundation.org,lukas.magel@posteo.net,maxime.jayat@mobile-devices.fr,menschel.p@posteo.de,michal.sojka@cvut.cz,mkl@pengutronix.de,patches@lists.linux.dev,sashal@kernel.org,socketcan@hartkopp.net
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Nov 2023 12:23:17 +0100
In-Reply-To: <20231031092918.2668-4-socketcan@hartkopp.net>
Message-ID: <2023110616-overflow-filling-90e2@gregkh>
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

    can: isotp: Add error message if txqueuelen is too small

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     can-isotp-add-error-message-if-txqueuelen-is-too-small.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Tue Oct 31 10:30:23 2023
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 31 Oct 2023 10:29:11 +0100
Subject: can: isotp: Add error message if txqueuelen is too small
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sashal@kernel.org
Cc: linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Patrick Menschel <menschel.p@posteo.de>, Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <20231031092918.2668-4-socketcan@hartkopp.net>

From: Patrick Menschel <menschel.p@posteo.de>

commit c69d190f7bb9a03cf5237d45a457993730d01605 upstream

This patch adds an additional error message in case that txqueuelen is
set too small and advices the user to increase txqueuelen.

This is likely to happen even with small transfers if txqueuelen is at
default value 10 frames.

Link: https://lore.kernel.org/r/20210427052150.2308-4-menschel.p@posteo.de
Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -813,10 +813,12 @@ isotp_tx_burst:
 		can_skb_set_owner(skb, sk);
 
 		can_send_ret = can_send(skb, 1);
-		if (can_send_ret)
+		if (can_send_ret) {
 			pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 				       __func__, ERR_PTR(can_send_ret));
-
+			if (can_send_ret == -ENOBUFS)
+				pr_notice_once("can-isotp: tx queue is full, increasing txqueuelen may prevent this error\n");
+		}
 		if (so->tx.idx >= so->tx.len) {
 			/* we are done */
 			so->tx.state = ISOTP_IDLE;


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
