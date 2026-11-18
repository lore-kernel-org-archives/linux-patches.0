Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058064;
	b=YK2It/kDT+W5b+yHq4B9L0jcpsUccJp8xhU45MtdwEXGlQdtQRiemLlaNmqSM8VLeLVZ
	 huYRi+NjIFdvgmAozEAMGmXe0yIGqZN9ZANy+Vwf5X8URZmvieSoy+ghQ5H+Qc7qixWQ5
	 hHeySQNKm9Tl46i6tQkIKbUeTDoQ0HUutGob99rH8LJoct/j66relsol6535M59T3bAmb
	 z/8NqWhdFQRvvFar9k0qUn/m1HiBlTineZUotCFlm6IsQtzGKQcN1uiEZID84URe1wDZh
	 2SF4d+sMCpZ8mgH1sz4pdqWqCnKvN/qpssvwgFp39AW5kWwHauwT4Rrq2cPdnNgKriQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zMhU7MNLNvYpAJZE6PuDF4+d679fdqoLsQau5uLjsvg=;
	b=Uf9ZOhBR+vGdw8ETnUXf2t/5Rulg98bB529U+litnRZu/zdFj0tJ7y0fDI0MxGSBGuUD
	 wnIqAwweS9Ytpw9AoCvLDEn5QToLwws0foP1kU4ZnvPjSil5dFvavi1kfCs8lTgPcl9db
	 qmil4TFz8ZXK8gStyOPt+GbPIfpPOmK9idIyGI2rfunCSIMf2GVrjTRk82yLjeY03XnUZ
	 XmbLH4yzqElAmFWSgAI+NiuVYh7fFASoPQ753bvNlp+OCbWmbSuBiOrrxNwPBGUrisM0j
	 OFLSE9xz8lVUL+l0Z066lnu3Gzbmm3wh9ldnYfqLZTKcqRJv/wyy8K2h/jOnROpY0RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGpsiON4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF494606A325;
	Thu, 19 Nov 2026 03:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGpsiON4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504B71F000C4;
	Thu, 19 Nov 2026 03:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058063;
	bh=zMhU7MNLNvYpAJZE6PuDF4+d679fdqoLsQau5uLjsvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGpsiON4blRWfaNZqq7uPD7wt9ff2B/o5EezKDRRj9YhjPJKwqXZnSFlxybC3V5Qc
	 a+wm9V3TIwJGMMsc3B9zMTicjp9zYxKfWrbqNSVD6zHcRoYsfJdyGVl+TttzPSTsud
	 R7GcSx4hhD7JCly8fRd9ywTgDMUKfa3xY/jc4lIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 0311/1848] HID: logitech-dj: validate unnumbered keyboard reports
Date: Wed, 18 Nov 2026 15:39:09 +0100
Message-ID: <20261118145925.264316723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1601,6 +1601,9 @@ static int logi_dj_raw_event(struct hid_
 	if (!hdev->report_enum[HID_INPUT_REPORT].numbered) {
 
 		if (djrcv_dev->unnumbered_application == HID_GD_KEYBOARD) {
+			if (size < 2)
+				return false;
+
 			/*
 			 * For the keyboard, we can reuse the same report by
 			 * using the second byte which is constant in the USB


