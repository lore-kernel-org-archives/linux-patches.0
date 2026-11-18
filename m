Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053218;
	b=G0/4v9075PQsOyMHTvmABADVqGG+9mM5i8nFxJE3xZpuYlxuAu42zKXaiyFTxNQtEZFX
	 A/IaqJ+OCPtrY9UEIoSXNTaM8JNTmMRa2/F3u/tcO4lIm2q088oiBwflB9/0qVb474pwZ
	 maOVxdhGH2Fsv4fblJ5hdiIVYNAraZTO9mlsCSasPlrTcw5KxowtLyXexfbKhMqIz9gc5
	 BZ8xnhxNB0Qu7AwsFnZOkRvxrJav3+t1hl0WT1oxnCa/gYWYIfpQ3ACL0G+/4vmpDjH6X
	 bp0f8oXqj0VZR74HhV+WehOHYaPpwfco2OR1CUm7jwNW3JyyQ/e+ZckOlNXDCL/gijA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KzvWlpw4X3dyDH9TQ9qA7WyVTsMimrX5qeFSDJ1Hy9k=;
	b=h5m0NneRQCwZjv+tLABWJVjdpGXjcI/XEAOO4h3iT8ke9kEsF+djkd4RqRyRwjDTyp5v
	 HJnDyXyXh4DLKeHgICq7AsFzTW0Q3q80H1sZ9IcwaeywXDO2P4/mnJu3jT9m8nxl0A6/u
	 /94S+f8pTjganp+FgR4T4Tr+z5F9McXeh6h7hrBx3PKg1D8wSTcizE5cnfqUw6w82X8Z3
	 s9FjtSGIACvKgUhgLQm8uGuYZ3VqYzgKkZ2QSabFyC2SR9dHP1+bF91Xc/bZZQi+7evN9
	 /OlAez+D5vode7MVnNaGIei+k8V+gBPUU1E7n0pCyOEWSA+7ADN4d1N2fF3+mkZ5fRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1q630JR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1EE606A320;
	Thu, 19 Nov 2026 01:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1q630JR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA951F000C4;
	Thu, 19 Nov 2026 01:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053218;
	bh=KzvWlpw4X3dyDH9TQ9qA7WyVTsMimrX5qeFSDJ1Hy9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1q630JRf4b649dTRD7g5ENVDijAbR7W5GwnCZrlMmH4esoY/xCF58zy3XuYPOf9q
	 CG2kKpY4Rx33sSiuGiz3/0ZiOxmZcqh3JelLgdocbw5asCXDnMQkc6h4iwIDr1eWr+
	 sWrYgFDAKEyME8en+FncDlWnX4d/aF2vHLYuS9DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0792/2214] HID: prodikeys: validate fixed-format MIDI reports
Date: Wed, 18 Nov 2026 15:41:08 +0100
Message-ID: <20261118150043.238963572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



