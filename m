Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAFD371067;
	Tue, 10 Mar 2026 11:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141111; cv=none; b=hJ0pgTAxD+/L8PnD8DTbiJaEk8wKHjuVDauAQabDSEDshXpB9z5rjg2AL6uE37+w2GTdr+DqYch0wyUun9KSvvXOrtphULncPxCgite7vjUZd777HB1rAnwpeYucbxct9WKz2ggJPVB/9cuglLBnrS80lTOhOVdNWFmXdH6Ly9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141111; c=relaxed/simple;
	bh=T/LNN9QFEpL+Sn5oAXB89WXMb/FCc6/ZM0k0NrdVFjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw5ZkfIjrxuHrFwf3zVpZHARBQkOI+ukK5mSu3Yz40hwllCTWyuTzVMCVWLL7I0wrJGdfv1r8pDz8ZiiTgp7PoQakQ4KPXiz5Wkrad3YwySDWkggOIekBxBb+ZLuvPoeyNUS47LE3UfFR4ZrRKocvfGrteXpid5G4Uxz+OmWDUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8B94msR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8B94msR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0DAC19423;
	Tue, 10 Mar 2026 11:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141111;
	bh=T/LNN9QFEpL+Sn5oAXB89WXMb/FCc6/ZM0k0NrdVFjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8B94msRYqeTmWqLjrC9/3cA2NhZBREwwgQkdv8rKD2k1jMQpDtVDQ3SsmllXMNLE
	 RZN9iMUzX9au4iRtrRffe2jp/gdG+4yiaTfUEys99p6zXSWVLDeEk+eSw2lb3dbovZ
	 wpIdebI0FnBNL9stO9GZbR3Elvy9GOXKm+SH5psamp9scwlVUrVUHWOwFTV2NZhhME
	 6jtFygHghPXNdcZxC9Rd31aQfrJxDbCJfW+c4vfXVMVKU/XjEpeMI3Rr1eYj9BpiaS
	 WARdNAU5JN3CLfYgUgBEFjBeDsvpQW18BEUYu04U819v+IoEiTiQXqtkPb6lPRdd2B
	 kQ28Odh5p2t2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Bastien Nocera <hadess@hadess.net>,
	linux-input@vger.kernel.org,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 113/311] HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them
Date: Tue, 10 Mar 2026 07:02:40 -0400
Message-ID: <cd66bd2824d7220039ce5daf4138f0f09bd0c4b7.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit ecfa6f34492c493a9a1dc2900f3edeb01c79946b upstream.

In commit 2ff5baa9b527 ("HID: appleir: Fix potential NULL dereference at
raw event handle"), we handle the fact that raw event callbacks
can happen even for a HID device that has not been "claimed" causing a
crash if a broken device were attempted to be connected to the system.

Fix up the remaining in-tree HID drivers that forgot to add this same
check to resolve the same issue.

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Bastien Nocera <hadess@hadess.net>
Cc: linux-input@vger.kernel.org
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cmedia.c          | 2 +-
 drivers/hid/hid-creative-sb0540.c | 2 +-
 drivers/hid/hid-zydacron.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-cmedia.c b/drivers/hid/hid-cmedia.c
index 528d7f3612157..8bf5649b0c793 100644
--- a/drivers/hid/hid-cmedia.c
+++ b/drivers/hid/hid-cmedia.c
@@ -99,7 +99,7 @@ static int cmhid_raw_event(struct hid_device *hid, struct hid_report *report,
 {
 	struct cmhid *cm = hid_get_drvdata(hid);
 
-	if (len != CM6533_JD_RAWEV_LEN)
+	if (len != CM6533_JD_RAWEV_LEN || !(hid->claimed & HID_CLAIMED_INPUT))
 		goto out;
 	if (memcmp(data+CM6533_JD_SFX_OFFSET, ji_sfx, sizeof(ji_sfx)))
 		goto out;
diff --git a/drivers/hid/hid-creative-sb0540.c b/drivers/hid/hid-creative-sb0540.c
index b4c8e7a5d3e02..dfd6add353d19 100644
--- a/drivers/hid/hid-creative-sb0540.c
+++ b/drivers/hid/hid-creative-sb0540.c
@@ -153,7 +153,7 @@ static int creative_sb0540_raw_event(struct hid_device *hid,
 	u64 code, main_code;
 	int key;
 
-	if (len != 6)
+	if (len != 6 || !(hid->claimed & HID_CLAIMED_INPUT))
 		return 0;
 
 	/* From daemons/hw_hiddev.c sb0540_rec() in lirc */
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index 3bdb26f455925..1aae80f848f50 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -114,7 +114,7 @@ static int zc_raw_event(struct hid_device *hdev, struct hid_report *report,
 	unsigned key;
 	unsigned short index;
 
-	if (report->id == data[0]) {
+	if (report->id == data[0] && (hdev->claimed & HID_CLAIMED_INPUT)) {
 
 		/* break keys */
 		for (index = 0; index < 4; index++) {
-- 
2.51.0

