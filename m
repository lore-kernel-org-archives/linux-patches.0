Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829181;
	b=vynsNAGIsiW9rCmDJNFFocjt8kfaNrosUWGv1AT9tnG0mQUQqs1D01v42kEgFDjLK/cV
	 HD/osUqIHCN0aac9sfwl5lsnCbOJPA5CihxIYIa2rwQMH2AqLm9C5BWz3ySSEriBfwCI5
	 rYRsTYeupFPLSmrbUPgx901GEF8g3KUVt2mu1HRqTda5yolSigORyUowb4UAr49/D0ToR
	 pGOk1DFqvIdEkeLx161JVjstqOuYUPml9dcO3KWT+Zt2/4Eqwrvhs97n6AW+x+7ZY+8oS
	 yyKJ6MUP6Lafv8sO2YoIwAzC8E1VCkwZhbrKr4lAGfsSxhWmz6h/s2T0r4E9OW+FrVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fA1bmigfnPcABMGZEiKAW5Yygjhoe7vJqkmm4d0Z5Vs=;
	b=EeYx8n8ZUtk79lkU2XNnCpCIEDpR0Dqa8bz1hX9R+ePQtRyOdWqOKSBbdGvUBEcu7jAX
	 wWWPyBweEel4q1wzrr4M3TtZ8R4KF1twCqJLZK0qY4dDtEpKeK1X/ednqul7Waf6WM5fx
	 SG664S/1Xa7h/By+mMpDoaNJ4C6emCH49iNdCRkqyNjcAUfh79x+vJ90fNraG6FMC2E1/
	 HUgLWhElJjmCHW4Fn8OKfPFf+dqsZo6dNfpH2DJxZ7maYNn0eRYFAQk9q3f8O6GTU9pmL
	 mR1qGfFa2wr30rlEVYjGyDtMmVvvwCnNBfViVehUxPvUKxoUqwTzoAlU7Tgjmq2mBdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dktjczg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C57260709BF;
	Wed,  4 Nov 2026 21:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dktjczg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F171F000C1;
	Wed,  4 Nov 2026 21:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829181;
	bh=fA1bmigfnPcABMGZEiKAW5Yygjhoe7vJqkmm4d0Z5Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dktjczg6DEiC8YoPjTrFD3znSpY6xpPgaV5IoL7iPVIszGroaEL7vWCvDYuvf9Zmp
	 vblUVfkfgCyYnuxV1yqlypSRlmWH4ASu98/9aMpvYnnvkGe4SoHaIApG3HgkSShWEX
	 R68taPmP+7ERwgPp533DZgxu149ngG8/OEqfkaFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 497/547] HID: prodikeys: validate fixed-format MIDI reports
Date: Wed,  4 Nov 2026 16:11:21 -0500
Message-ID: <20261104211052.497532723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


