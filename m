Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3771E3469FC;
	Sat, 30 May 2026 17:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162475; cv=none; b=ZB54mk+g/TMmGX6fWNqGpDAho8nqVhFIHJ3cCELFbGbQfNoE4BrTQxdcmMZXCt5yTymVq9JHvAHDLpXQevY0VxT0kZhRgTmktHsEFLvEvLWlooDj0LNpTx9u7ImrDUnyqkZNd78R2jnodO6XMS/n0VWLP+IJtL8DvEm+x0L615o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162475; c=relaxed/simple;
	bh=G+BLoo1xWRm1aD7C60JfHHG2aaVFQomRrMESJ3eUWlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC68CR9kgmFgQV6kkDy6TTmLVSWvLyg5YjaeMDgAUqD5hT2Vc4GtLEX1M2MEKVSION51dbtgvfzCBB5SB5xuzww83VBqon81udGMWG0TXoaOIL3ezWk5QqFqGerYTfn1T5ClFxWK0PR+G7vBdPenKpFob+b8hRZCEPv9mCvAaN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Asyp6DX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Asyp6DX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434D71F00893;
	Sat, 30 May 2026 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162473;
	bh=RpIysb3vF1DF3zNQ1wr1Iy2342i3Rl4OaTF7uc2Z5A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Asyp6DX/kt5fVVvnGmgMIuu5IjN5t853pqzMj6KsGlXgYGVfEfuC8EtxCijdGasMS
	 gHZcqF3i4t4CFiKJVv3djN8X+SePS5jpkS5rEXlaUkos8T0P3UZLD9kS7RfdQaLin4
	 E3qwAbgIGqPmHXKqZnHFD4bW9RScKzqp8769W6pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 931/969] HID: quirks: really enable the intended work around for appledisplay
Date: Sat, 30 May 2026 18:07:35 +0200
Message-ID: <20260530160326.455838571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

[ Upstream commit 5f90dcfa8dc32a488581b78e575cdd7808ba5c78 ]

Commit c7fabe4ad921 ("HID: quirks: work around VID/PID conflict for
appledisplay") intends to add a quirk for kernels built with Apple Cinema
Display support, but it refers to the non-existing config option
CONFIG_APPLEDISPLAY, whereas the config option for Apple Cinema Display
support is named CONFIG_USB_APPLEDISPLAY.

Refer to the intended config option CONFIG_USB_APPLEDISPLAY in the ifdef
directive.

Fixes: c7fabe4ad921 ("HID: quirks: work around VID/PID conflict for appledisplay")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 99fca77d16641..91ce2b6840144 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -222,7 +222,7 @@ static const struct hid_device_id hid_quirks[] = {
  * used as a driver. See hid_scan_report().
  */
 static const struct hid_device_id hid_have_special_driver[] = {
-#if IS_ENABLED(CONFIG_APPLEDISPLAY)
+#if IS_ENABLED(CONFIG_USB_APPLEDISPLAY)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9218) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9219) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x921c) },
-- 
2.53.0



