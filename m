Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038035;
	b=McW7NXlezo52kfhSAFmjav8mlsEGimRBI1GQ2E5AzUoWGHb7Vw1exo9LTdtm5pYRO6Cj
	 fcmjvZ4YbPAIqKw3kojBsuaGAJ3uTb6gsaTYd62ELURIMiVUo5w3M6ZdLUgM9Qz6iPFHa
	 nEBaPLze56GmL15CV9Uy5dl/GtbEzZYBYHfWmgGiJBXmqb/iC9EX3eaKoyh4muoQo2E7K
	 Lv3qr7A3yhmkGj3jK9VIfb2bD4gmH6IGgWAPQ6U3pfplJXojJHjC6IZCKPwnjga8cAImG
	 Lsp0sP2unGDNLxqJEUf2tfSqTfROLIaXbBn2tGb7Pu8ovg2JZuPu0O+Pkeklw6LFEfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MLxBZTDTtf9yUgmHeD/eTJo3nhjRqsL2ctmgUzTGYDo=;
	b=0pUucBlSLSEfLIRjoN4Cj1sVheVaFoCei1Ywn92tN+pzea+z6VUZgS5P8T1v+ETjERYn
	 Z1RwD0wC11ZYvljfNrc2pPT+1YYs3fbBdozLYphjqtlourZEzm/QXlNcMAsNWY+mgq5ia
	 H7IJlWljWyiSft7E25GSFXtKDPAM1a8FGUVXr93zraZD6rrFzYSfk9rnNbgxk2XH+rYEo
	 wIQ7IrFXXJ7hJzUEJc7J3qUcgUocqOjj9LPi20WgGR5trWmkfd60HEXuRCcqA6zIXdhvd
	 R8BTpd3egFyaTvuehcjmSSwIqJtds/qsKkjI9x5zHyJcUKt87PEMP+kXbrO7rIMhUSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdP4X8ys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF4F60A261D;
	Wed, 18 Nov 2026 21:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdP4X8ys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7751F000D0;
	Wed, 18 Nov 2026 21:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038035;
	bh=MLxBZTDTtf9yUgmHeD/eTJo3nhjRqsL2ctmgUzTGYDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdP4X8ysKuhHhn/jaWFcTPHw5UCI+WUvYWlp3M53sDFAZkNOb965NMuKb6Tlb78P2
	 RQDz8kr9O+NazP3xO46CzT2n7p19O0f6OF+Q2T0OkqHVyIPj13UTpKKKO5fidtvFhy
	 YDgF08odsV6ldM96yQIFHuyVcsqT5KGp3G6kb+U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Kindschi <valentin.kindschi@fiveco.ch>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1601/3318] Bluetooth: hci_sync: pause advertising for the scan address update
Date: Wed, 18 Nov 2026 15:37:03 +0100
Message-ID: <20261118150409.203750562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Valentin: Adjusted for 6.6.y: the privacy guard removed in the failed: label
  reads use_ll_privacy(hdev) in this tree, and the line after the added
  resume is only if (hci_is_adv_monitoring(hdev)) {, without the
  HCI_QUIRK_STRICT_DUPLICATE_FILTER term. The added lines are unchanged.
  Requires commit 737139f4157d ("Bluetooth: hci_sync: re-enable legacy
  advertising on resume"). ]
Signed-off-by: Valentin Kindschi <valentin.kindschi@fiveco.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5b838b9ff2fac..403cc418c19a3 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6106,6 +6106,7 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 	u8 filter_policy = 0x00;
 	/* Default is to enable duplicates filter */
 	u8 filter_dup = LE_SCAN_FILTER_DUP_ENABLE;
+	bool paused;
 	int err;
 
 	bt_dev_dbg(hdev, "");
@@ -6129,6 +6130,12 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
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
@@ -6138,6 +6145,9 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 	if (err < 0)
 		own_addr_type = ADDR_LE_DEV_PUBLIC;
 
+	if (paused)
+		hci_resume_advertising_sync(hdev);
+
 	if (hci_is_adv_monitoring(hdev)) {
 		/* Duplicate filter should be disabled when some advertisement
 		 * monitor is activated, otherwise AdvMon can only receive one
@@ -6162,9 +6172,8 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 		return err;
 
 failed:
-	/* Resume advertising if it was paused */
-	if (use_ll_privacy(hdev))
-		hci_resume_advertising_sync(hdev);
+	/* No-op when advertising was not paused. */
+	hci_resume_advertising_sync(hdev);
 
 	/* Resume passive scanning */
 	hci_update_passive_scan_sync(hdev);
-- 
2.53.0



