Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5674A17754
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEU8mIHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93FBC433C7;
	Mon,  6 Nov 2023 11:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269578;
	bh=Z+WhEO3b2TaXrpXY9Tyo3G5KFFYeP+9Pg9KWbbFx3as=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=MEU8mIHxESxry+//MyK/JMLOmO8fLcRRZ2GuSA5pyZDC4w9USJ8Ut7e2oiBY220gE
	 REK6pxtEkChtA3EDPWvlAJkcZoylFsZaxZXE2ZfxEFii2cCEEoMY89jzk+1aFQ1kub
	 aA+gwKpXq9h2O4B/ynflbpFaVa2p90cdmy0nxbHg=
Subject: Patch "can: isotp: handle wait_event_interruptible() return values" has been added to the 5.15-stable tree
To: gregkh@linuxfoundation.org,lukas.magel@posteo.net,maxime.jayat@mobile-devices.fr,michal.sojka@cvut.cz,mkl@pengutronix.de,patches@lists.linux.dev,sashal@kernel.org,socketcan@hartkopp.net
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Nov 2023 12:19:30 +0100
In-Reply-To: <20231031093025.2699-5-socketcan@hartkopp.net>
Message-ID: <2023110630-evident-pry-87e4@gregkh>
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

    can: isotp: handle wait_event_interruptible() return values

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     can-isotp-handle-wait_event_interruptible-return-values.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Tue Oct 31 10:30:57 2023
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 31 Oct 2023 10:30:22 +0100
Subject: can: isotp: handle wait_event_interruptible() return values
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sashal@kernel.org
Cc: linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <20231031093025.2699-5-socketcan@hartkopp.net>

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 823b2e42720f96f277940c37ea438b7c5ead51a4 upstream

When wait_event_interruptible() has been interrupted by a signal the
tx.state value might not be ISOTP_IDLE. Force the state machines
into idle state to inhibit the timer handlers to continue working.

Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx processing")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230112192347.1944-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1071,6 +1071,10 @@ static int isotp_release(struct socket *
 	/* wait for complete transmission of current pdu */
 	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 
+	/* force state machines to be idle also when a signal occurred */
+	so->tx.state = ISOTP_IDLE;
+	so->rx.state = ISOTP_IDLE;
+
 	spin_lock(&isotp_notifier_lock);
 	while (isotp_busy_notifier == so) {
 		spin_unlock(&isotp_notifier_lock);


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.15/ext4-avoid-overlapping-preallocations-due-to-overflow.patch
queue-5.15/can-isotp-isotp_bind-do-not-validate-unused-address-information.patch
queue-5.15/can-isotp-set-max-pdu-size-to-64-kbyte.patch
queue-5.15/can-isotp-isotp_bind-return-einval-on-incorrect-can-id-formatting.patch
queue-5.15/ext4-fix-bug-in-ext4_mb_new_inode_pa-due-to-overflow.patch
queue-5.15/rpmsg-fix-calling-device_lock-on-non-initialized-device.patch
queue-5.15/can-isotp-isotp_sendmsg-fix-tx-state-detection-and-wait-behavior.patch
queue-5.15/rpmsg-constify-local-variable-in-field-store-macro.patch
queue-5.15/rpmsg-glink-release-driver_override.patch
queue-5.15/driver-platform-add-helper-for-safer-setting-of-driver_override.patch
queue-5.15/can-isotp-check-can-address-family-in-isotp_bind.patch
queue-5.15/rpmsg-fix-kfree-of-static-memory-on-setting-driver_override.patch
queue-5.15/can-isotp-add-local-echo-tx-processing-and-tx-without-fc.patch
queue-5.15/can-isotp-handle-wait_event_interruptible-return-values.patch
queue-5.15/rpmsg-fix-possible-refcount-leak-in-rpmsg_register_device_override.patch
queue-5.15/ext4-add-two-helper-functions-extent_logical_end-and-pa_logical_end.patch
