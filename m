Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037215;
	b=1CG/fh5fhSnC8mHlUMFDZWnjJVJI/Z8oIjAMu1Y1X4Wg+Xx7VDpIae1m1fSc8g2ETgvN
	 yNQKuoVx0qK2jyl9hw2KIn55is5qo7+HqY105yV1uUsZaUwnZOKDHATkISsGXeMgB3bdy
	 4kOG/xgyE58TDqGD4w/AS3kbxlQVQCSYdeUaRhuz8uRdzVXXo19gwH3yOPJPhYvfSZ5f9
	 quC5ocqVBZyogI4edjuo2LxHFVJoOUY6ij6egfv2L91akp5YpuKLUbNPoYHnZeYqyJCJK
	 bfKkf8I6qhkoX0OR/SFJMhpbOhjmVWnD++DD4D8sJ2xlsCO9LiBwKxg4KROV/N2i2zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aBn5zi3Q1RLCrdrVpGc3Ua8fiNC+PQxYPPE9THdJUG8=;
	b=23bgb3IJ0dAyG5QN3wIIKDnshGYJ2exiXBpP3/nkHMfiibTfAEo1RDsTRSEZrdedmxOx
	 Pa88Z5zKENzROCCkLusS1+SyosjZJ70us52KcrvwHTqXTSlgZt1gNwHSyGRLO2bnNoL2C
	 Q3ihJPvN0o3cqtx//xCn7Kvf+ifknRtEiAVsQA4KCy3NFsPNLma38/WAuJ5Jtt1O9ZIal
	 8t/osrxAxVHDXBkoi+kIlFrdbLncHYg578dV4/4O7rS0r1IcACe4bWVa7emAL7WFW9Mbc
	 W+OFsop5GDluYlYq4od0XCaD+5hj9Sy1rfyCt93K6JX+1ZeUu/0xc7w8TUQaGFKdcMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zKDwFO1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE31606A320;
	Wed, 18 Nov 2026 21:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zKDwFO1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BB01F000C4;
	Wed, 18 Nov 2026 21:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037214;
	bh=aBn5zi3Q1RLCrdrVpGc3Ua8fiNC+PQxYPPE9THdJUG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKDwFO1RsIwuGOuBDSWOl14L8icPR5Hbk+4coBIRrZ6I35FwTmXWX6Bbmm7Nmclm8
	 B1vnRke9UWgkP1Jl6LNnEx2MrDSgFK2rYiilL5fiEjgy0Nn1i1lfWOynPq5scsr6ro
	 vKOMusfXGcHNL8L4z8EUPURyP44uz0EI63xvriG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1330/3318] HID: prodikeys: validate fixed-format MIDI reports
Date: Wed, 18 Nov 2026 15:32:32 +0100
Message-ID: <20261118150400.234391191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 0ff37294c41bd925258893310398bc2b45fcd4a7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-prodikeys.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index b53b0c02675a4..f2b9142e95021 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -774,8 +774,13 @@ static int pk_raw_event(struct hid_device *hdev, struct hid_report *report,
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
-- 
2.53.0



