Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585585;
	b=OxpsPwB1lANxxlk+fOYnhOGr3DljNAGc57WbetiF5eT6q5feAbhi/4DP7DNL/KAm4Owh
	 1cA2Sg3UDdLw5r6IqYAZFWRwMiMsYcRGfMWQ4M+dPsR5lJx+uk1jxKoZwFsW44F0kzPwk
	 kw2+xUMyHrVGp+c4ipteSd5mFKGhMIZlEb8y1EcWPmAmblon6RJDCjuRo6fPe5wrl0ff4
	 IqpCqeYgp0o28nsqhDyIJs1jaD1pN53xEGNGdNVPHYeZ64aoRqNY3qMywJxZYDMYHb24K
	 P5bbmziB2HQVRkWeQgKEgp8NiIV9lqYFXO+rVIPYhuAYowDYfQfsLk1XUcS/LBPxa2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fZsyzlrquM/0GdIaVXK7wZNDo49R14JKRrHjL77C+uk=;
	b=Byn8PlYDP3LgjOotflyhgXW54adJ3Py8frN/Tpy+gq0z/Zp4L0pUT+OU4K+wRG9jpgo+
	 MGL/ZbsS6gKSe2rvXPWx2WquJXnar2UXHOScArdmjzjxX6viEi42HR6zdKyEzHttR8kTD
	 EixTQX69CVn7UVnb0fCKFC41XEDp2nR4qxrJCuFGUPEFyN+faaoJRa8oYZ7DNwqvduIqf
	 XbwkN14XmarsVCcNpcKaibOwAsllDru1qY2DL4dLl82OIlA8QvQObjc1OPi5WEyNl84jl
	 ueg3744YVXSILg3tSe5JtQXSm4AmyPeCZujn/k16GoImQ6DkiEE8e9Onlo1jtsIK89A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lX9ZDA3o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED9A606EA91;
	Fri, 13 Nov 2026 15:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lX9ZDA3o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA0B1F000C4;
	Fri, 13 Nov 2026 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585585;
	bh=fZsyzlrquM/0GdIaVXK7wZNDo49R14JKRrHjL77C+uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lX9ZDA3oBd2mYMP71RT/7A+/N68WPxl83VlgckXcyJqTK8E9P5W8DejnLgyc/GNPw
	 58FQ7RkVLd5XUCRzVsA97niPvIqVWofZ9ICBFMK0fzgkuLZtMsI8udgwzHZrQwa+uo
	 mIiNnT2ik0CcUdTwZk0zsWmA+0jrS5Gl6dAYmwTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Kindschi <valentin.kindschi@fiveco.ch>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 215/507] Bluetooth: hci_sync: re-enable legacy advertising on resume
Date: Fri, 13 Nov 2026 10:48:39 -0500
Message-ID: <20261113153801.774967012@linuxfoundation.org>
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
index a92a81846e9df..4468c1d0b5e58 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2687,7 +2687,7 @@ static int hci_pause_advertising_sync(struct hci_dev *hdev)
 static int hci_resume_advertising_sync(struct hci_dev *hdev)
 {
 	struct adv_info *adv, *tmp;
-	int err;
+	int err = 0;
 
 	/* If advertising has not been paused there is nothing  to do. */
 	if (!hdev->advertising_paused)
@@ -2720,13 +2720,19 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
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



