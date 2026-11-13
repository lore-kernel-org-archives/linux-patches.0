Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590321;
	b=xGELbGLYGYoTEaRlbGtCXudE89Nf021SEh5kgxhgSoADr6MT1ixbkfMFaRPvnY0lnfCF
	 LtShWJL1EOXiwVxBw1EUtXlg7yVKS4Xs/yOFakiTNYweQ7a4Uo5ior6mjB/k4s4PPAWib
	 EdsEBQXiDZOpTz1wAnLa38Age+dPMmdnm90kHPy7PDRt9DzRrB0Vkm3D6QSGkR5oCuSaJ
	 8YxRt8RFIvD2Ro1ym9rjR++Uk0Ihwp8o2WoP/O+SrcYPKIlWE0vEc6+To2pXLpZCO0faL
	 52TfbvZf9zB2xcl9o7qzijVpv+4m/JjgLTVEAGZ3UB3RRh0NHmYvCHRF+2TfXcLYjtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nflbDotpFSDiXr/g39mt5w1ghC2sctoZHgjQFjzNZc0=;
	b=z5Xyh6dL8T2j5YB3/gQ6W6brvXQVDMIJOhv2lSPg50DkkP2kHYyEH2LFURo2VwWb1Xyx
	 xTUIe7NiQV1nbIK0pidkO/WrnZS+ZkYQcjTYl5AZkigCdSDnvzXu6ZqiQNr/nbGo/Oxmz
	 BjAkd6iSmoX5Ru9YnrHHlG3/essQagZIpBiYOK4gBLew8xSKz4z2NySRkkud+cKNi3QbX
	 3lDqc2e//hgpZc2uVmyivjQ04sfpGDVq24AW98SU1sSk/trnxyeQD0c4aNinZFPxXOqdu
	 3LPrJKItPZdB5Jo+JuRFv0EuxfHpr9XOyL9/4ZwlsV5XH046O+MgXhFInyMNbHWq5Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="onE/CaMB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047A0607E04F;
	Fri, 13 Nov 2026 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onE/CaMB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BBB1F000C6;
	Fri, 13 Nov 2026 17:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590320;
	bh=nflbDotpFSDiXr/g39mt5w1ghC2sctoZHgjQFjzNZc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onE/CaMBUrMPj5tkmfx3ufGRwUCvt/OruOghzX14yB+I4f8pXSHQ5ipz71IJ5AZ9R
	 innfwL4sA7q27HXRXWZCfpF8BobGpB9J2S28JW9Ta3tkp1mZp5c7jZa63ZekBfWVV5
	 5AyVBJCjOv7xm0mMweyTVNxak75fguDPGBRz6PrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Kindschi <valentin.kindschi@fiveco.ch>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/686] Bluetooth: hci_sync: re-enable legacy advertising on resume
Date: Fri, 13 Nov 2026 10:47:15 -0500
Message-ID: <20261113153831.186890278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Kindschi <valentin.kindschi@fiveco.ch>

[ Upstream commit 737139f4157d302292a6b937d96922879ecabfa3 ]

hci_resume_advertising_sync() never re-enables advertising on a
controller without extended advertising.

It restores HCI_ADVERTISING from advertising_old_state, then calls
hci_schedule_adv_instance_sync(), which starts with:

  if (hci_dev_test_flag(hdev, HCI_ADVERTISING) && !ext_adv_capable(hdev))
          return -EPERM;

The flag it tests was set a few lines earlier by the resume itself, so
the call returns -EPERM without sending anything. The return value is
discarded by every caller, so the failure is silent: advertising_paused
is cleared, HCI_ADVERTISING is set, and the controller is not
advertising.

Observed on a BCM43455 (no extended advertising) after an active scan:
btmon shows the pause disabling advertising and no re-enable in the ten
seconds that follow, the device does not appear in another controller's
scan, and btmgmt info still reports "advertising" in current settings.

Enable instance 0x00 directly in that case, the way reenable_adv_sync()
already does for the same situation. Instances continue to go through
hci_schedule_adv_instance_sync() so the software rotation loop is
rearmed.

This affects every caller of hci_resume_advertising_sync(), not only the
scan path: address resolution changes, accept list updates, discovery
stop, suspend/resume and the end of an LE connection attempt all leave
advertising disabled on such a controller today.

The resume does nothing when the controller is already advertising, as
it is after directed advertising was started for a peripheral
connection, so it does not replace that advertising.

err is initialised because the extended branch leaves it unset when
adv_instances is empty and HCI_LE_ADV_0 is clear.

Fixes: ad383c2c65a5 ("Bluetooth: hci_sync: Enable advertising when LL privacy is enabled")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5.5 btmon
Signed-off-by: Valentin Kindschi <valentin.kindschi@fiveco.ch>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 8da58c61e9723..1bdaf7b2e01e1 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2708,7 +2708,7 @@ static int hci_pause_advertising_sync(struct hci_dev *hdev)
 static int hci_resume_advertising_sync(struct hci_dev *hdev)
 {
 	struct adv_info *adv, *tmp;
-	int err;
+	int err = 0;
 
 	/* If advertising has not been paused there is nothing  to do. */
 	if (!hdev->advertising_paused)
@@ -2741,13 +2741,19 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
 		 */
 		if (hci_dev_test_and_clear_flag(hdev, HCI_LE_ADV_0))
 			err = hci_enable_ext_advertising_sync(hdev, 0x00);
-	} else {
+	} else if (hdev->cur_adv_instance) {
 		/* Schedule for most recent instance to be restarted and begin
 		 * the software rotation loop
 		 */
 		err = hci_schedule_adv_instance_sync(hdev,
 						     hdev->cur_adv_instance,
 						     true);
+	} else if (hci_dev_test_flag(hdev, HCI_ADVERTISING) &&
+		   !hci_dev_test_flag(hdev, HCI_LE_ADV)) {
+		/* hci_schedule_adv_instance_sync() rejects instance 0x00 while
+		 * HCI_ADVERTISING is set, so enable it directly.
+		 */
+		err = hci_start_adv_sync(hdev, 0x00);
 	}
 
 	hdev->advertising_paused = false;
-- 
2.53.0



