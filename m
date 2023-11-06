Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D776418AE4
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlOKV2VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B2DC433C7;
	Mon,  6 Nov 2023 11:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269591;
	bh=YiSUevKbVuysu541CEn8fWMVudysQ7uFmqjYnHb7uj0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=LlOKV2VYuXMF7ecKMri9MPdqfWlT7fhiGoYqIvgb8OfAkBmWSHVGFcSgY0NhEDKt0
	 OSM+kLKzvCmz2BbLtcEBbeDSelHLSwb0Hc739LVJVivpOtzwopOtiQZYNGgkIlr1OO
	 130uLa6Q7k8TzRGOGp2+Wgg4FQE0jalJM4LHo2Go=
Subject: Patch "can: isotp: set max PDU size to 64 kByte" has been added to the 5.15-stable tree
To: gregkh@linuxfoundation.org,lukas.magel@posteo.net,maxime.jayat@mobile-devices.fr,michal.sojka@cvut.cz,mkl@pengutronix.de,patches@lists.linux.dev,sashal@kernel.org,socketcan@hartkopp.net
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Nov 2023 12:19:34 +0100
In-Reply-To: <20231031093025.2699-2-socketcan@hartkopp.net>
Message-ID: <2023110633-fruit-stylus-8c93@gregkh>
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

    can: isotp: set max PDU size to 64 kByte

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     can-isotp-set-max-pdu-size-to-64-kbyte.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Tue Oct 31 10:30:57 2023
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 31 Oct 2023 10:30:19 +0100
Subject: can: isotp: set max PDU size to 64 kByte
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sashal@kernel.org
Cc: linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <20231031093025.2699-2-socketcan@hartkopp.net>

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 9c0c191d82a1de964ac953a1df8b5744ec670b07 upstream

The reason to extend the max PDU size from 4095 Byte (12 bit length value)
to a 32 bit value (up to 4 GByte) was to be able to flash 64 kByte
bootloaders with a single ISO-TP PDU. The max PDU size in the Linux kernel
implementation was set to 8200 Bytes to be able to test the length
information escape sequence.

It turns out that the demand for 64 kByte PDUs is real so the value for
MAX_MSG_LENGTH is set to 66000 to be able to potentially add some checksums
to the 65.536 Byte block.

Link: https://github.com/linux-can/can-utils/issues/347#issuecomment-1056142301
Link: https://lore.kernel.org/all/20220309120416.83514-3-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -87,9 +87,9 @@ MODULE_ALIAS("can-proto-6");
 /* ISO 15765-2:2016 supports more than 4095 byte per ISO PDU as the FF_DL can
  * take full 32 bit values (4 Gbyte). We would need some good concept to handle
  * this between user space and kernel space. For now increase the static buffer
- * to something about 8 kbyte to be able to test this new functionality.
+ * to something about 64 kbyte to be able to test this new functionality.
  */
-#define MAX_MSG_LENGTH 8200
+#define MAX_MSG_LENGTH 66000
 
 /* N_PCI type values in bits 7-4 of N_PCI bytes */
 #define N_PCI_SF 0x00	/* single frame */


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
