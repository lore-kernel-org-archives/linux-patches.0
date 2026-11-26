Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705794;
	b=a4cf79kD45vJEXvB9eZIWtdqXpj21Jc1A1hQone6iOGvMAGKODEqBviuoC1Rqds/Gl+q
	 8JY9NZiCfQE2rheP4a5ORtkkJj0m/AeS3qyY3kJnud8DvSynWAov5AeAtCSrKxSRQ6DMK
	 W2nzPLxZvxasFuHS+prDAFy4uNGqy0upxP+9vrraAhmicuPpinqgkEjX69JHXIal7cED7
	 8P10JP04ckouio9qxTBqwaXWuYw0D5gZ45xSycg/5RQZ4xRq8e7/p8VO73a31aCrlXore
	 MBsYpWFhiwOmiSYtdxs1qL7NtqOmMNgr2b+3Nkx+GVO0f8qiJSdHaPTUjHwDCrTsk5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=m6dO61roQycHeXk5ZNt+PX9L1LyTCHQamK5GKztBahE=;
	b=JSkab2Xo52EWyHBP/HrUhEB9yHNZ99krUlRhwqHQzLPGBm6L8xQ6p8Xamjy/RG/uXcGv
	 eL6DpRvbODoyPmd/x6xrjIPAzkYRJ1lkZUu06hOMNr3R2sJezVfgqjQLi7aOvSlcaXklg
	 sTSE1XZF02EvUshBhTCxqWF1lb8vdfHlYNLWaYTPKkInOJEc2wpQGx4CdeOU+EDOYofNa
	 HvrIOEkcKrSUl5NyCC+AVAGqOheNnrWcg4Odz0VI2KCJKyXTqx+6pF/y1nnqbdI0TTUbG
	 qQPp/i8C5PJpgKWHRKBwKGHA+cZGTu8DthY7XIxNhA2y9yO/biQsl64T5vIPoIrfX3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MParGnF+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42669606A321;
	Thu, 26 Nov 2026 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MParGnF+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE3E1F000D0;
	Thu, 26 Nov 2026 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705794;
	bh=m6dO61roQycHeXk5ZNt+PX9L1LyTCHQamK5GKztBahE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MParGnF+yWxoH9K8zw/wbRK3uGnZGJIZltDIBmMVx6cISUIMHKNoTDPAy+tQkQf/l
	 QvgqxOjQeC7vLHgH+NgeihSSEWQIl3lp3PQFubUcqfJyqp/iHqK8CEexokEyqq5q/9
	 Fe0MuWlr6FLISWQPsvXlxl2PuLJjC3roSVCgzgzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 272/319] usb: uas: ignore UAS for ASMT135x bridges (174c:55aa)
Date: Thu, 26 Nov 2026 15:40:40 +0100
Message-ID: <20261126144012.890327252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>

commit fafd23d61494461256d374f67c121f2712e1af2f upstream.

The ASMedia chip detection in uas_use_uas_driver() assumes that every
device with idVendor/idProduct 174c:5106 or 174c:55aa reporting a
config.MaxPower of 0 is an ASM1153 with working UAS.

ASMT135x bridges (iProduct "ASMT135x") share the same 174c:55aa id and
also report MaxPower == 0, so they take the "ASM1153, do nothing"
path — but their UAS implementation is broken:

- The first READ(16) issued by sd probing times out after 30 s;
  enumeration only completes after a uas_eh_abort_handler plus a full
  uas_eh_host_reset_handler cycle:

    scsi 3:0:0:0: Direct-Access  ASMT  ASMT135x  0  PQ: 0 ANSI: 6
    sd 3:0:0:0: [sdb] tag#26 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD IN
    sd 3:0:0:0: [sdb] tag#26 CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00
    scsi host3: uas_eh_host_reset_handler start
    usb 6-2: reset SuperSpeed USB device number 2 using xhci_hcd
    scsi host3: uas_eh_host_reset_handler success

- Under concurrent load the bridge stalls: all inflight commands (20+
  UAS tags in the captured incident, mixed READ(16)/WRITE(16)) hit the
  30 s UAS timeout in the same event, forcing repeated abort/reset
  cycles and eventually a USB disconnect.  Writes dropped mid-flight
  during these resets returned zeros to the filesystem (observed as
  XFS metadata corruption on the mounted volume).

- Sequential-write throughput is ~45 MiB/s under UAS versus ~136 MiB/s
  after disabling UAS (usb-storage BOT mode), which is fully stable:
  several tens of GiB written without a single error.

- Bulk reads of healthy LBA ranges do work under UAS (~190 MiB/s, no
  errors); the failure pattern is command-timeout at enumeration and
  under queue depth / write load, not a broken transfer path.

Since 174c:55aa is shared across several ASMedia bridges and enclosure
rebrandings, distinguish the ASMT135x by its product string — the same
approach used for the HIKSEMI MD202 check a few lines below.  The
product strings of working bridges using the same id ("ASM1053E",
"ASM1153", "ASM1153E", "ASM1351", vendor rebrands such as "YZWY_TECH")
do not contain "ASMT135", so the match is safe.

Verified on an ORICO enclosure (iManufacturer "ASMT", iProduct
"ASMT135x", bcdDevice 1.00) attached through an Alpine Ridge TB3 dock:
with the equivalent usb-storage quirks parameter (174c:55aa:u) the
device is completely stable.

Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20261014165741.35758-1-olivier.kaloudoff@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas-detect.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -78,6 +78,8 @@ static int uas_use_uas_driver(struct usb
 	 * ASM1051 - with broken (*) uas support
 	 * ASM1053 - with working uas support, but problems with large xfers
 	 * ASM1153 - with working uas support
+	 * ASMT135x - broken uas support, shares the ASM1153 MaxPower == 0
+	 *            signature, identify it by its product string
 	 *
 	 * Devices with these chips re-use a number of device-ids over the
 	 * entire line, so the device-id is useless to determine if we're
@@ -99,7 +101,11 @@ static int uas_use_uas_driver(struct usb
 			(le16_to_cpu(udev->descriptor.idProduct) == 0x5106 ||
 			 le16_to_cpu(udev->descriptor.idProduct) == 0x55aa)) {
 		if (udev->actconfig->desc.bMaxPower == 0) {
-			/* ASM1153, do nothing */
+			if (udev->product && strstr(udev->product, "ASMT135")) {
+				/* ASMT135x, broken uas */
+				flags |= US_FL_IGNORE_UAS;
+			}
+			/* else ASM1153, do nothing */
 		} else if (udev->speed < USB_SPEED_SUPER) {
 			/* No streams info, assume ASM1051 */
 			flags |= US_FL_IGNORE_UAS;


