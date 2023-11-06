Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540B9182BF
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUjyESfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4725C433C8;
	Mon,  6 Nov 2023 11:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269807;
	bh=wuZOkZILFk3rDJ2MRYNUommSBIzxbXtIgv/3PMOYrf4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=IUjyESfbd+zJRajmyeI5ZIPm1Aq8c3XniYbKMbhNqS0cVyi9P/ybm68L5myJMo6ab
	 YOvxCBZ3TwV0tNTGqUvsHyBq9rCRlUdrjjXITAh5cB9ecXGfhSDe0a1WjhXsG2rAmw
	 02Rs09gTSMhSJIEwznRe4f2mNJK6tlh6VXA0QpWo=
Subject: Patch "can: isotp: add symbolic error message to isotp_module_init()" has been added to the 5.10-stable tree
To: gregkh@linuxfoundation.org,lukas.magel@posteo.net,maxime.jayat@mobile-devices.fr,menschel.p@posteo.de,michal.sojka@cvut.cz,mkl@pengutronix.de,patches@lists.linux.dev,sashal@kernel.org,socketcan@hartkopp.net
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Nov 2023 12:23:19 +0100
In-Reply-To: <20231031092918.2668-3-socketcan@hartkopp.net>
Message-ID: <2023110618-finishing-squash-8d0b@gregkh>
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

    can: isotp: add symbolic error message to isotp_module_init()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     can-isotp-add-symbolic-error-message-to-isotp_module_init.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Tue Oct 31 10:30:31 2023
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 31 Oct 2023 10:29:10 +0100
Subject: can: isotp: add symbolic error message to isotp_module_init()
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sashal@kernel.org
Cc: linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Patrick Menschel <menschel.p@posteo.de>, Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <20231031092918.2668-3-socketcan@hartkopp.net>

From: Patrick Menschel <menschel.p@posteo.de>

commit 6a5ddae578842652719fb926b22f1d510fe50bee upstream

This patch adds the value of err with format %pe to the already
existing error message.

Link: https://lore.kernel.org/r/20210427052150.2308-3-menschel.p@posteo.de
Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1550,7 +1550,7 @@ static __init int isotp_module_init(void
 
 	err = can_proto_register(&isotp_can_proto);
 	if (err < 0)
-		pr_err("can: registration of isotp protocol failed\n");
+		pr_err("can: registration of isotp protocol failed %pe\n", ERR_PTR(err));
 	else
 		register_netdevice_notifier(&canisotp_notifier);
 


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
