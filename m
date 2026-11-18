Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046031;
	b=KStKwLXKhmxVSnQWgGPGIYt2gjfoCazxUHNuzHCj+Hw+4qz1EEdRJ/woBpyABZuYRySm
	 BVmeYfSxuqSB7F2m+ytj+J7y0UrR/Ub1tzb2+reBWJ+m1bw7twKKlvl/EGA76TwL/kop9
	 iYR5JRBZ7OGt6cFBDAjiiPa2M03xEX5wd20oRAEkOtS2Asf4Z2ZqIgdQnEZSXtx+f5MOL
	 Fxc1PXI5W8Iwz9sDD7y1dpPqSBJIsqxk9sq4clqTvBTu8B+LA1kGJtepbm0y2sCHMCvDm
	 5XHY8MCP93k9E7rvpaJHh1dbSyuGZ/hA7A3T8QCAjEJI/b8YHTUndFRdRj8IRp8JWLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jUgvxCi4uVTJCkKEte7nCWHe6RmXy8vYT6xeTnld030=;
	b=J2W72vM9lmD8pVH9WYQsUJrqHS7iHT1K2AyEVup1yQuN0MXIek2Xc7EiCvrVMT3wp9Qn
	 UGAIq5h0GvRI3Pqht8A+9RfKCSE/J9K9q6JOUCY091oynSuAyPqaIj9tNyLcu2LwS99vQ
	 ecOsh8Xlai3w9hGhKdnuOVKbmHUFJ8E5Do7EL6pTh/GNdvvT1t1x0dR7x0xyeYBfMfWI8
	 oHfdO7WWYBuIHp+rHSA/sOQR9qV9VUf2Cgv1Eg8IzSqYNGggZoOd3/rl1I4XobrncrOZE
	 mcV44T4ZwR260kDhehTD82hJ32jbnvNh/KSqQd6bZ/fmZ8oB+ngo3fovCb7rMt64bqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnWv3VIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53C606A32A;
	Wed, 18 Nov 2026 23:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnWv3VIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F5D1F000C4;
	Wed, 18 Nov 2026 23:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046031;
	bh=jUgvxCi4uVTJCkKEte7nCWHe6RmXy8vYT6xeTnld030=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnWv3VIUndLr8DQteOjj3qVdcEscfaLBIcYiC2nOaPZrpfiXXFfJVqvHelzdih4f9
	 4ti1SC8pQSEys+KWwJQ3GHwpbcz84ZpR3iwSt0OboePOBDOBfpM4sRHk4JY2Udvqdp
	 GX8SVNVWw6cA6tOQWX3vqjzBlE0/OgyrrbDoxsm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1136/2857] HID: prodikeys: validate fixed-format MIDI reports
Date: Wed, 18 Nov 2026 15:36:10 +0100
Message-ID: <20261118150242.496462800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



