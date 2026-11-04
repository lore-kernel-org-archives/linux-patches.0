Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831854;
	b=kmVLHFv9MNaG3iX18mKwQ7xyPlUoHZCZWG0rCDvJTLaERlD+GuMrgr+k2DnYjbsAurww
	 0ctniG2cort/N2xN6DVJG37i+1LblYlDpNGXqnlkBc1xwXjM/vkIbQWIStYAAEKxawyFA
	 tKYU1xaT24Rwy4uRqbyvJ+B7EQPbJANYBRHlsU9ltzPle7xgLImbI2V6A9+7c0L1oQInk
	 3dSVTEJkzCbPOge+bZogoshnQB++atkiVpTnVt5Z5qOvUji7Y+rMiYs6P/TimWNoanIii
	 7VadgIm4m+CvUpFuv6/IFWCthk11H5LZ3TQ03XqcOPsVEk3/Ggjf2TQjhG32depEHYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtUUs790kwZ0Bu2oyaX0rO94QFhmPm1OdLf69JdoltY=;
	b=hn46e0ka06K6uHS+NRkT2mghqCMphNYJWRcQRajQqKKmDR+CS6JWuVMO8VR/XPh+Srt/
	 JTeu0WmwXIsg5Cw4LSmhccmY1PLOzQJuouyQqjkLTbdtq20Bgsam6YKD2g/a4V0hKjA8q
	 yj6hEX2TgHDR5059VlXqHPgE2dibRPRl9wAHF4M/xMWfIzeBvhSiiR280LWIk8fQvkeni
	 +Z6hk/it0k9l7YP1229Ey0jhz6GTOIs086aSnbW5neKgKc6IR0OeEIuwU/nRNj8C2CQvG
	 iKjWSIT9VmnajgmYuPbA/XdShxptFWSPLO6jGYdmL1T8DOgcSUWfEYrJNnLoJLlNbSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uphFfG8P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085F1606A328;
	Wed,  4 Nov 2026 22:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uphFfG8P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A8B1F000C1;
	Wed,  4 Nov 2026 22:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831853;
	bh=dtUUs790kwZ0Bu2oyaX0rO94QFhmPm1OdLf69JdoltY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uphFfG8Pa5MsuM2XwlpWNGs9CFUv57yKwQVX162CQdII4GVDzMXiJng3MXLdRrMy7
	 lFWl5z8Dt3RSAGrH4W4enL6YWVSwRs9YcSNJvT1BywkfG81xmS/D+hDQRpVpKzPKTA
	 cbjA3PpiqmdyvwmhUdZcCdoF6VrcqR3gUkZU64dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0956/1005] HID: prodikeys: validate fixed-format MIDI reports
Date: Wed,  4 Nov 2026 16:11:29 -0500
Message-ID: <20261104211109.870371244@linuxfoundation.org>
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

commit 0ff37294c41bd925258893310398bc2b45fcd4a7 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  Prodikeys reports 0x01 and 0x04 are passed to handlers that always
read bytes one through three, regardless of the supplied size.  A truncated
report can therefore cause an out-of-bounds read.

Require four bytes for the two fixed-format reports.  Keep report 0x03 on
its existing variable-length path, which derives the number of note pairs
from size and only accesses complete pairs.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 3a370ca1dcf8 ("HID: Prodikeys PC-MIDI HID Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-prodikeys.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -772,8 +772,13 @@ static int pk_raw_event(struct hid_devic
 		if (report->id == data[0])
 			switch (report->id) {
 			case 0x01: /* midi keys (qwerty)*/
-			case 0x03: /* midi keyboard (musical)*/
 			case 0x04: /* extra/midi keys (qwerty)*/
+				if (size < 4)
+					break;
+				ret = pcmidi_handle_report(pm, report->id,
+							   data, size);
+				break;
+			case 0x03: /* midi keyboard (musical)*/
 				ret = pcmidi_handle_report(pm,
 						report->id, data, size);
 				break;


