Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9790D34389F;
	Sat, 30 May 2026 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162766; cv=none; b=tZKtTVN6vCYr2qdoig+OFLNhrhHf4uK1O+Y6I2r0ve6YaIIDqwsZnArIWia1nOWzukqfsOjVrcWBuP/PnMTCPxhbhHevXmg8ZMNA4TcmlbknaNEkQRQTHISVrf+0ETKwIRyHvlhY7ZlW+cMcM+G0cxRkAY9eIpagMnDGSVAq7gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162766; c=relaxed/simple;
	bh=vAoyYDztNTtSSED5jIKqo+y6hLpfX3nde+5Pak/6OV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCTsLUjzdGPQRz7eII+IHs2JsH4ZgzarKg7hDR/ul0bE+JsRXjFCA2dYG85kcY7fTLJpABtjbktF9s8kIWpnlrNqgCBEHhqqeVfD1u9ydd85AZbtbCOyOVNpyHxsQK7wdr9TMziTDvFayiNwKD5JfRAgA39pbLaPHBavyJTEWRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diT7wAZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diT7wAZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD401F00893;
	Sat, 30 May 2026 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162764;
	bh=PjtiooSNFHoHgQrU2Y0NjFM63Fl1RGLI3tDDi6SQCDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=diT7wAZR2fBlb+euTkjHCLrmYRCXmLRBE+JoSD/hK+2l9T+1T8qXflgjWaufYXq5S
	 aYebqlMJbCRfeu+d92f/KHZxfq6pgvdu6qu3V6GDZtFzUtPTPRnsr0dxeKtIDBBEM2
	 PUgjZyvKwSzPKap3XMoQJ5R3w8UAKyDTlmb6cdYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Masaki Ota <masaki.ota@jp.alps.com>,
	linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 056/776] HID: alps: fix NULL pointer dereference in alps_raw_event()
Date: Sat, 30 May 2026 17:56:10 +0200
Message-ID: <20260530160241.762132673@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1badfc4319224820d5d890f8eab6aa52e4e83339 upstream.

Commit ecfa6f34492c ("HID: Add HID_CLAIMED_INPUT guards in raw_event
callbacks missing them") attempted to fix up the HID drivers that had
missed the previous fix that was done in 2ff5baa9b527 ("HID: appleir:
Fix potential NULL dereference at raw event handle"), but the alps
driver was missed.

Fix this up by properly checking in the hid-alps driver that it had been
claimed correctly before attempting to process the raw event.

Fixes: 73196ebe134d ("HID: alps: add support for Alps T4 Touchpad device")
Cc: stable <stable@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Masaki Ota <masaki.ota@jp.alps.com>
Cc: linux-input@vger.kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-alps.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -437,6 +437,9 @@ static int alps_raw_event(struct hid_dev
 	int ret = 0;
 	struct alps_dev *hdata = hid_get_drvdata(hdev);
 
+	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !hdata->input)
+		return 0;
+
 	switch (hdev->product) {
 	case HID_PRODUCT_ID_T4_BTNLESS:
 		ret = t4_raw_event(hdata, data, size);


