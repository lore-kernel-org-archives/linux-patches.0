Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058869;
	b=yPKrW/S1lDcj27GCCbz3nN/J733KXeYqziSeJHliIpwlz1aZpnLGmivZvCD/Abq/yoat
	 mnXLp2d4vjxaaUJXFoTpyki4QVFF84i3D7/1JSzxt2TzNLuvOy14GtGQffMCtorAAvLBe
	 mSyd/bGinWh95mWs9jQgADlzTC/MDWB5NAiw8CyaNJXyAplWRcY3+E0gTyIOnjG3Udzfl
	 FWvo2PiRMTFLU7biOxFu1zEOgJ2/Tw5i6CH08HgpHnxwdOr3RZiys5lg91FyMZDYLauAe
	 Ir7mKVOC89KMWiiD8WOT+8HmZIccaXrbfbhpX7jsf9adH2mJKbL3F8u3WFj4Jf24NYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YHg8feNHmEkQ0ln7Sf35jwH3B/OuWukFAecrmcJW+KE=;
	b=uafH87VFCE7EQm+fEZGgfKnG/bE+qA7YjDN9VTHRyb5z0O0did071CVM1xnYd+GPxgAf
	 Ki54dmmLtTRk2yzi4iR9rUjGJHz+Be6QL+i/wCyy027jI+h3tqfL75pqMjtIAo6c9WuB0
	 TpkY8gEDQ49siOiJCEQ400FC1zcdF2N/3lA/UByw/heQGQdBSOIS6yrnUhPJoUzEUgTLK
	 Y9mpu2P6UBSJ6tJNlmJVaYDlT5GX8E+M0w//cA2IOpl26eT7s2Zz3fPFLJ/wyX72ihiiV
	 5A6nr+weHLsFbTvu1kNYx0DJM4Vc3Ltf4fTMEO+muxIdU/zCU6lnOPuuEsqtO4VzLLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfLjlmQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977FB606A31C;
	Thu, 19 Nov 2026 03:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfLjlmQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9CC1F000C4;
	Thu, 19 Nov 2026 03:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058869;
	bh=YHg8feNHmEkQ0ln7Sf35jwH3B/OuWukFAecrmcJW+KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfLjlmQhn+wH6ERSL1TqyWieKY+y/RJTzP28UKbf/5gO9tTk+TKO7gFelp3yaV92J
	 wM0t38DesyZybVTV6nPOjNrk8Kyydo20FHw6djaUnItlS/vXUf57d7jCby40i+vYCY
	 dJvYcYqd7PZ5hOY2xDLCS5UCBy3dLqrHNc5ap7sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0640/1848] HID: prodikeys: validate fixed-format MIDI reports
Date: Wed, 18 Nov 2026 15:44:38 +0100
Message-ID: <20261118145942.538648832@linuxfoundation.org>
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



