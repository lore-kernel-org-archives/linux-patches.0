Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214779;
	b=BbjanAKwRMJslXFln803bMsz4M9HKM0PnYx0YIFIkQI2wSkiTaZ+w+CNk5ESoO2eE8d9
	 pFq6fZH/b/rw908BdzWh3BG0deSSYk9vKgVmeWyvNC5vYClE22t78DESLyO3ybUKsutmh
	 XCL4Cv/+/KK31Dy1vGXWJuokoCvHW++qX9ex1Co/iXADT+I6jHeVDPcPKMAx1k+Gm3PXS
	 GFuyBDbKI8xTqSZ8b2xQwQ9D4Eiy5CRveCajXGSVBnOc6aY1PogKnqpJVAQQB24ZXZZ23
	 a8LU01misLXvWBlZDdd6KaRsxxLu7TysFXTFqBXDkLeI6FhKXPV5kYaDQV3Cu2kueBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p302TmqCXuDpfItjYMbPmaRoSojsnhMGaqJPkRxUYWw=;
	b=ZmfuB00IKRLbpINj96IV3tPnDOZuh8km8/wt7psA5Pse4oG6Qu//l32DIQpd5fO657aZ
	 f52SYo5o6diG07h46x5ERk/XPzxLiniU6HamUGUxhun8KgzgSV3CYNIWpu01VAm2JgrMh
	 oY3AoGCasXWJRZq52+a10fld92vqOkb3fVZAdyPa/lAYKRYMcOG4IcxfJVHDr4rAvBm++
	 rFPlw2Y5hq/yZCjhKCH5bbzB7o7AszF7PvafUTilZejB3R//6CqZmaxpwTydhB+PVY8UG
	 O/gsB1/uoaDdTUEqcTYktSFZWuzotY0lPUZxu6w/K7TyZnwJJUOIbCDmOZ2Ds2KZ1Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L77YyJbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589B3606B7CF;
	Wed, 28 Oct 2026 19:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L77YyJbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F411F031E0;
	Wed, 28 Oct 2026 19:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214779;
	bh=p302TmqCXuDpfItjYMbPmaRoSojsnhMGaqJPkRxUYWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L77YyJbGIxCeX3F5ayQxRYk/gUgsZ6840R+dnfNeqarYj2FWpj526uYWQSp9nfmCT
	 RTmyOXCu+tGFo0JncwbfUMLXrcrd6wNJ6pJ1HvQxCpRiU/bclvQRH3OobKe5wxdJuW
	 fuE2HU5dXEI5Wu68DF4dpNoE61UcTP24tojyxdQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0978/1887] HID: core: Mitigate potential OOB by removing bogus memset()
Date: Wed, 28 Oct 2026 17:51:14 +0100
Message-ID: <20261028170521.665325769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit 0a3fe972a7cb1404f693d6f1711f32bc1d244b1c ]

The memset() in hid_report_raw_event() has the good intention of
clearing out bogus data by zeroing the area from the end of the incoming
data string to the assumed end of the buffer.  However, as we have
previously seen, doing so can easily result in OOB reads and writes in
the subsequent thread of execution.

The current suggestion from one of the HID maintainers is to remove the
memset() and simply return if the incoming event buffer size is not
large enough to fill the associated report.

Suggested-by Benjamin Tissoires <bentiss@kernel.org>

Signed-off-by: Lee Jones <lee@kernel.org>
[bentiss: changed the return value]
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4b717cc838cf1..66deabcfb68b8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2052,9 +2052,9 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 	}
 
 	if (csize < rsize) {
-		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
-			csize, rsize);
-		memset(cdata + csize, 0, rsize - csize);
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %d)\n",
+				     report->id, rsize, csize);
+		return -EINVAL;
 	}
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
-- 
2.53.0



