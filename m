Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061788;
	b=xVFwhgKzxdpVndQqVIV0tBtH4e5ukXO1W18S9kNjotKIl0jXfh+IWCUrM7KNvrvMS6OY
	 1vEZI+h/nAK+woZqrci8W6IF56ZmVocQ2k9j+nYIMYz5ftU16s3UQytZD9YpEpKQdQ/po
	 tyUKXN5q4mulU5jEUcfpahC++PcPy9sMNxLn89yLpz5jYApi2Y6ld6UliTCjko4Qcv5av
	 keAIV8UdFBWkQrIW3YdJ/2dXwpI/lFtNlY9c7aMyYCHEnLc+fC09panz52hwrOkAHjFZz
	 iG42jJcmtinoP7JFidTQM0WSJT1lIg4urf9y0WyBQceSTxXh63xjX+BFMS3WzCfhYSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WABr2u4PJLoOhfLu5C/i6SAkoWBhsM8iA1lRl0MeC1g=;
	b=Gef0YyyzpVlshJgJD6cwVfX2OKDOMHy+tqru9ssH+3o5vrGKyhfqD/ysFvvTev986KEM
	 jraYW5CICeJKI4enPBqbVmcY5CK+OyeHmY8oloamdb983TELcL0sSd6Q7xlHPKbklDjtB
	 5W7cFQcdHiP30NtB/K1l2R7DyAvsExN7Vio+zGkdStYNxvH/5tYDLa6PUCuZZmOAU7Vzr
	 BHVXOT5HDSPxosiN1k+J1SNw7fCG3aL5nxz/lPq7IqoTxJ2Vceiv0XNHckI+C/TDZmnmz
	 v8vv8bdwucT7qDrtXVyteTpchWTKnBkXnRdzvM/W1KiITFVxceo0roLxYkFjM3wdmaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qz53vLqy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C8A606A32F;
	Sat,  7 Nov 2026 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qz53vLqy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857781F008A1;
	Sat,  7 Nov 2026 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061787;
	bh=WABr2u4PJLoOhfLu5C/i6SAkoWBhsM8iA1lRl0MeC1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qz53vLqyLvn3gG51YixDEdOycaoSdZWoT6pUjV1SMgAYCfPT/8JU2c/fzSorI9eT5
	 l8BjgbWyiSYr2cpp8ix7Vt2382UNaIgPtwSv+9pbE1mzguEdS92Leujgar5CzMgrJR
	 2u1cd4T62lNMPebYJhVqHfKnkhLmZCMkPyu4lzDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0817/1536] HID: prodikeys: validate fixed-format MIDI reports
Date: Sat,  7 Nov 2026 08:47:13 -0500
Message-ID: <20261107135020.490521792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


