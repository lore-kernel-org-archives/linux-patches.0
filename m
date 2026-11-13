Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585587;
	b=TkJoChKkPbJ7LdQmgkVlTv3eO9k5lLJ+LMW3CdlvcQbX8OcomvvZrNyBnpVeO3KvAIM6
	 BG+9k/wPR0I+Y4bl9oyl6njHblcD/Uw/PXbQ9N3C9hlBkyR+MpwAdaQET/wYYQY0sOHCn
	 +3nidCtQ8K3USYtdRZhR5Zt5y2y5S4K4mccYO006TRmotbLnWbiBWZfHebxZ39Wh05uAs
	 CEL6tYQ8jwO+f8ItshiGc5g0F3wQ8dq3xDRzbu5ndioXdp4ayCPATrJAU6eErXyesyyfY
	 hdlWoBTTZRBgnxbFnZm7cjgHb868jGn6zpt2j+sOw2bILore019UOo/q27miwahk4Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bLmQkm71JJAW2GV6/W3H8MQdWHFscw5ZkVFMsT5gj0E=;
	b=PNmZLLY0QbrfYeU5XilyjSpx3bur1LZVRKMG3ahttseGnK5/YXg1wd8JaDq45eQ1oTTJ
	 WdT45YYTnzFH/vyCp0rvCpPNa+HlN931iBYXgDU+m4/5oEfUJ1190DGsBn44xqZRJWdw2
	 Un+LtI604iVUGenIkPlEkBXI5wjtIZuWzFh+0bqmlnyx9aVpzKXaxixtDFFU5Zd3v9Mio
	 y4O4qaxKmviaVfKeUaPIAf4N3/AdzdBB9PCpezfSUeX3gkjIJK8X+Y6jY2twReBKQTR+i
	 TQNTLF3bAL6LxkUZlawWPdyvizLJ6yZYSWrcEBeSOrWj+5c+1ssfYBp9yta02K57ecw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8pvgQB5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069D1606EA91;
	Fri, 13 Nov 2026 15:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8pvgQB5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594B11F000C4;
	Fri, 13 Nov 2026 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585586;
	bh=bLmQkm71JJAW2GV6/W3H8MQdWHFscw5ZkVFMsT5gj0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8pvgQB5qENFP0gy9b2b8Md3gdUIdApMLxRA/s6TrXkZktMLMhbAtfpYdPVwaYv7V
	 cZEA3wJ2T9JO9qOLbYlt46XeQ+KCAfTqeW6G3OiJ8YOApu3arE0ohjkdyJiH6E1LKQ
	 I8CqJTyBIFOKF4S0fPDQOq/RwrfcnwSARwK+OpPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Kindschi <valentin.kindschi@fiveco.ch>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 216/507] Bluetooth: hci_sync: pause advertising for the scan address update
Date: Fri, 13 Nov 2026 10:48:40 -0500
Message-ID: <20261113153801.809708209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Kindschi <valentin.kindschi@fiveco.ch>

[ Upstream commit 56ed6b127a27c418dc2daa3fd076539d8fe69c4c ]

hci_active_scan_sync() programs a non-resolvable private address with LE
Set Random Address on every active scan start.

BLUETOOTH CORE SPECIFICATION Vol 4, Part E, 7.8.4 says the controller
shall return Command Disallowed (0x0C) for that command while legacy
advertising or scanning is enabled. hci_pause_addr_resolution(), called
just above, only stops advertising when LL privacy is in use, so on a
controller without it the command is issued while advertising is still
on:

  Bluetooth: hci0: Opcode 0x2005 failed: -16

It does not converge either. hdev->random_addr is only set on a
successful command complete, so it stays BDADDR_ANY, and the deferral
added by commit c2994b008492 ("Bluetooth: hci_sync: Fix not setting
Random Address when required") requires it to be set. Unlike the
resolvable address a few lines above, which is reused while rpa_valid(),
the non-resolvable one is regenerated and rewritten on every call, so a
controller that refuses the write is asked again at the scan restart
period of about 10 s, for as long as discovery keeps restarting.
Observed on a BCM43455, which has no LL privacy and no extended
advertising, 190 rejections in one capture, every one retrying the same
address:

  < LE Set Random Address  Address: 02:16:91:90:F1:D4 (Non-Resolvable)
  > Command Complete       LE Set Random Address, Command Disallowed
  < LE Set Random Address  Address: 26:90:57:96:9A:3E (Non-Resolvable)
  > Command Complete       LE Set Random Address, Command Disallowed

Pause advertising for the address update, and resume it once the update
is done and before the scan is started. The pause does not outlive the
function: it is taken only when nothing else holds it, and every exit
resumes advertising, which also releases the pause taken by
hci_pause_addr_resolution(). A failed pause returns before marking
anything paused, so the error path is a no-op.

The resume in the error path is no longer guarded by ll_privacy_capable().
That guard matched a pause taken only under LL privacy; the pause added
here is unconditional, and hci_resume_advertising_sync() returns early
when nothing was paused.

One caveat this widens, raised on the previous posting. When
HCI_ADVERTISING is set, hci_pause_advertising_sync() also clears
HCI_DISCOVERABLE and HCI_LIMITED_DISCOVERABLE and zeroes discov_timeout,
and hci_resume_advertising_sync() restores only HCI_ADVERTISING, so the
discoverable state is lost. It reproduces today on an LL privacy
controller through hci_pause_addr_resolution(); the unconditional pause
makes it reachable without LL privacy as well. hci_suspend_sync() also
pauses unconditionally, so a device that suspends loses the same state
on any controller today. That asymmetry is pre-existing and is left
alone here rather than folded into a scan path fix.

Legacy controllers have one random address register, shared by the
scanner and the advertiser. Restoring the advertiser here can reprogram
it when the advertiser is non-connectable, so the scan then uses that
address rather than the one generated for it. Both are non-resolvable
and neither is linkable to the identity address. With privacy enabled
both roles already share one resolvable address the same way.

With the patch, on the same hardware:

  < LE Set Advertising Enable    Enable: 0x00              Success
  < LE Set Random Address                                  Success
  < LE Set Advertising Parameters                          Success
  < LE Set Advertising Enable    Enable: 0x01              Success
  < LE Set Scan Parameters                                 Success
  < LE Set Scan Enable           Enable: 0x01              Success

The address write is accepted, and advertising is restored before the
scan is started.

Over 119369 btmon records and about 12 minutes of the normal workload of
that device, alternating active and passive scanning with ten outgoing
connection attempts, every LE Set Random Address succeeded and there were
no Command Disallowed responses of any opcode, against one per scan
restart before.

Patch 1 is required: without it the resume added here returns -EPERM on
the controllers this fixes and leaves advertising disabled.

Fixes: 3c44a431d62b ("Bluetooth: hci_sync: Resume adv with no RPA when active scan")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5.5 btmon
Signed-off-by: Valentin Kindschi <valentin.kindschi@fiveco.ch>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4468c1d0b5e58..5b99da7028b9d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6278,6 +6278,7 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 	u8 filter_policy = 0x00;
 	/* Default is to enable duplicates filter */
 	u8 filter_dup = LE_SCAN_FILTER_DUP_ENABLE;
+	bool paused;
 	int err;
 
 	bt_dev_dbg(hdev, "");
@@ -6301,6 +6302,12 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 	if (err)
 		goto failed;
 
+	/* LE Set Random Address is disallowed while advertising is enabled. */
+	paused = !hdev->advertising_paused;
+	err = hci_pause_advertising_sync(hdev);
+	if (err)
+		goto failed;
+
 	/* All active scans will be done with either a resolvable private
 	 * address (when privacy feature has been enabled) or non-resolvable
 	 * private address.
@@ -6310,6 +6317,9 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 	if (err < 0)
 		own_addr_type = ADDR_LE_DEV_PUBLIC;
 
+	if (paused)
+		hci_resume_advertising_sync(hdev);
+
 	if (hci_is_adv_monitoring(hdev) ||
 	    (hci_test_quirk(hdev, HCI_QUIRK_STRICT_DUPLICATE_FILTER) &&
 	    hdev->discovery.result_filtering)) {
@@ -6333,9 +6343,8 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 		return err;
 
 failed:
-	/* Resume advertising if it was paused */
-	if (ll_privacy_capable(hdev))
-		hci_resume_advertising_sync(hdev);
+	/* No-op when advertising was not paused. */
+	hci_resume_advertising_sync(hdev);
 
 	/* Resume passive scanning */
 	hci_update_passive_scan_sync(hdev);
-- 
2.53.0



