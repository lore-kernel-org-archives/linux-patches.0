Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051907;
	b=UGorvmR4DXvb70Qii2sm815zuWZYvFTW4h4jL4H/LzeNq5iVP60Uq2cju5x8Z+2XHi2x
	 MEo0vUsod+/vWKQzAND0swoPWBmsvmDdrtbgxjzQ/JuUFLLOscYa/lCqc4nJWRHso5JXV
	 0p+xAhSlAfZFLEW9t/yUZIqmKF0wUwIDM9LrpPu6aWrCtjZooVXN36zwmq0uDg6AyxKXb
	 NjyRCkHZEjQv47ynPeCjD/HpAvTiIK+Q+VvkG8lrYIcbaujpFgn6+lYwK9m46xN9qE2q3
	 Nu/PxADYErTF4C+97sJv9qvsdZft5auanCwqIQoEQwHGiz8Q65u91+TvboQCnpGBmiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TpRbREFGEwIV1VJlV34s6X4qlOeJyuNMKe3rt7rVh1Y=;
	b=m7z/EfRhAIR1wb33WuRA1ucGXYoAaRHMAzvP4y3WTFo84O9B7t1zZLDYiG1ULjjQRDtU
	 5hl29MGunsVuMnL0cNDQ/ZHNflD/NKLz74OxINQLGwFvOK9oe9fXfhs1s76gTFUh60FnO
	 9M9j+88nCwZImNJCZbA4b3ug65NX10Vrd1W+Xdtc63jRkIQqr0xKR2x8kVBjXriymzs9s
	 wWSwZP54vpYROEcaRKkCcLXvpyZRv705+xhG99RjvKjl4Ttx8qsdtm2njxV2MeZ5CCNCI
	 s40WuJyTJyUuCPxOo6/tkfNTrTDAwuzFkVRqNrK2MqIeuoXbSt2rPQ7lDFxjNrYI0BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OAYznuU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB102606AA12;
	Thu, 19 Nov 2026 01:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OAYznuU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26AA1F000C6;
	Thu, 19 Nov 2026 01:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051907;
	bh=TpRbREFGEwIV1VJlV34s6X4qlOeJyuNMKe3rt7rVh1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OAYznuUVN0i34uHrOecaA6BrjJAljYCWcGjyV4Z/dJMLg9D/iy9vvPUoZ0Wct55z
	 zsZvMfQpr8WtEluWkc374+z4FpNqnNgj0COBjawfMXm9l4TRNvae97fYdmyVFyX79A
	 88dufJTp8TKxiu6Dh+XiO3TS/roi4+Cfvn9W6IjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0376/2214] HID: logitech-dj: validate unnumbered keyboard reports
Date: Wed, 18 Nov 2026 15:34:12 +0100
Message-ID: <20261118150025.753149099@linuxfoundation.org>
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


