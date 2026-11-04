Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831848;
	b=UN/3HAcxFX5KqnX7ui5g8VUUYqzW2mkrwoOEHdkY0ZDkIyVw5do/zjDNAbnitwv8xBl8
	 nZcSrfGDz8N4j3oyl4vPndOzex4BiiA8wudQsOF2ufNsIxxavY2QOq7w9kLPIpQ5YWyxS
	 nI8HWA9wiU5BCZSmdUdbjVPDrCaRVFNspAHIRocB1j9/sAx42iwvF9hP7Y5ZCfKY2hXkr
	 juxbOHh3IO9QkTLaLEMdtDz3h3jChmia55gMDI2ysD6XCrxBMXCAC2kSeEv0XR1H6xtrR
	 Tk5RXxfWhjJDbWM8wHl5EMosWD1/e0nfw/Dtzif45h333wRgnYINh7Cv8DtVUlrbTqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mTOEkhOJ3o0KPF+dcXm2IgCFkzU0PhJv/VV0TT3QHCs=;
	b=LUY4c6qFdosfYnn1Wa23Yl5cqvrvUplQdiEzLffwDP6LLsKGsvIvz5yaQG6GxjVvTIBr
	 qMnVdk3XhJ/N2rwx0zVLIQNrtqBl+J3pjgHwdD7YZZIspzTAqQXWGCO8Apd3mvqfRMz91
	 JR+5a6VL1hvJ66/2BrIZEePUHNH89Kn13dGjE73SCXLfjbCj91aGrzYejffU4sn/HRPZF
	 4s3qLfIfPTAdnJJTVviPV1liXcOqN7IaPRwq7h4jlyH3AD0cIw66eyZ7TbrH0fihTj2VS
	 +x5mYsq2lq8NQawnFC8VvunVHBL9uEW8AHXpJlybsT6ezV5VBdn1VSQs7qg/rf09aQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXcckd0e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF323606A33E;
	Wed,  4 Nov 2026 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXcckd0e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC291F000C1;
	Wed,  4 Nov 2026 22:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831847;
	bh=mTOEkhOJ3o0KPF+dcXm2IgCFkzU0PhJv/VV0TT3QHCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXcckd0e7DDM1oSZygW4yWF1fC9K5qon7ZgbSbuoEMU9Hy34A6+Z2FZWs64zODBW2
	 Vx3UYIIafiQWOldVgdu3U/Dh7h2d4U2vFwh+xemL1gz5Zy9kNAODSTWKsQWbLEUPDk
	 O//5KAL8syH+sbizi44dmz+7n2vdp5zyOa2hy7tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0952/1005] HID: logitech-dj: validate unnumbered keyboard reports
Date: Wed,  4 Nov 2026 16:11:25 -0500
Message-ID: <20261104211109.767803891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit c2deafcb4c8227771f768d77ed3c0a489250e9b2 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  For an unnumbered keyboard report, logi_dj_raw_event() uses the
second byte as temporary storage while prepending a report ID.  A one-byte
report therefore makes both the initial write and the later restoration
access data beyond the received report.

Reject unnumbered keyboard reports that do not provide the temporary byte.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 74808f9115ce ("HID: logitech-dj: add support for non unifying receivers")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-dj.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1682,6 +1682,9 @@ static int logi_dj_raw_event(struct hid_
 	if (!hdev->report_enum[HID_INPUT_REPORT].numbered) {
 
 		if (djrcv_dev->unnumbered_application == HID_GD_KEYBOARD) {
+			if (size < 2)
+				return false;
+
 			/*
 			 * For the keyboard, we can reuse the same report by
 			 * using the second byte which is constant in the USB


