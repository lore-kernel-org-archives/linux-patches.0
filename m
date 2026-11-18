Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044631;
	b=DNKgWvdkpIbO7Ti1LMUwYOb+G9unI5B8TsnaFqID3uFUV455I043+Pm/8wxPatWbbYpo
	 PndiRjdy/kwO2UkXNCGiPSWe+IW3uPliqc1MfwGyLACpCAiSudG5sbQs9h0shQbH62YKV
	 NXVhD43yjkqGUVDD0b3l9AYAvr1F8oEgcPbUQmd+VnnBgWOPZfBEpdgI1VmSMuXjUSphS
	 2I4YHcNaJTdrpdVXoxpCNCLDBSyjwwLxHApDhXHLa3AFs4yvi7yq1UOtfcBGGRBSi60GB
	 9BktdbSK0US/t2BcGpEky09TzF3TYZ5/8W3cUhx2J4own8jF/vZUxJ7Bro8Z6nL3lPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDflOXygslcUolNPRJjswRHjy+oHYWkJkw7woRX4BLs=;
	b=lvd5cfrB2lIDiDUHUzN09TiAhL2yfnHaOw0Hxd7CBJ9KTvJWYWFqFTQKouryzGMobUVN
	 SUHBrcrJoPPST8z5iMqguvHgGQ2Cisj38fKwga6bIED5j3R0Db1zSeYBSTPcCEm0RRT0a
	 LOjRgrnALnDD+aJ1sSt1z2SxsVXJpRuj6SUUDqWfuLko7LBtJM0c0AREQV/2A7MZA83Mq
	 Yyk5ToCZqJa7rvxYT0C2NsHQRoDX6zQpuXpveljhNjZ10kq78u4oobq6FVBveZ3cp38JJ
	 uP5z91S9pRmikpf7iUHMTTMHp01L2F/mITX+evlhpY0ZDWmCkSpiY98jIg3sWfFGmfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHoocNyd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60D660A2614;
	Wed, 18 Nov 2026 23:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHoocNyd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF4E1F0092B;
	Wed, 18 Nov 2026 23:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044630;
	bh=DDflOXygslcUolNPRJjswRHjy+oHYWkJkw7woRX4BLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHoocNydjL5bipo1VP9+KT5j0ncxOXVd32KebnjjF4XOZH8GXgdpIFsIJNIg5gVz3
	 XYtE0qiSRyFNi+Wen/H+XhmH1f7uKS36OyLn/rjqV/xVm1mDcawf1K8oTnPV7aeZj0
	 ljVXUiMa8dgoZsmAT4un79HT8NZpeEXZ3WEvsX84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0637/2857] HID: logitech-dj: validate unnumbered keyboard reports
Date: Wed, 18 Nov 2026 15:27:51 +0100
Message-ID: <20261118150224.449260261@linuxfoundation.org>
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


