Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6184E274669;
	Mon, 13 Oct 2025 15:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369819; cv=none; b=HvxrOceCZfcwPpXwH2hE0mH2/GjBBAaYaH1p9VPTguKPULxTDlc4nVWZo1J4P9oE5n3KtwMmkCH7RD20cDNgjX0UTD5X3iJBLJ59rmkWFcvcoMDZ9moUafYz1Tj0jBuWobcdQxVLbPCQNibXvZ9sx5p8mMnQQzhkgzX070l1hXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369819; c=relaxed/simple;
	bh=5teCdA5xFef1wOWUkl+8i6B8a/Lx1fVGFO1hMO495g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYeYuMUCPBKV1TM0Ie8iAp/gfj2D+uUTQjyqxr9FgbesCX4YSspQwCSHQqFlu0FbxpHXGNsMZCPv/te3V0UN8lN7dMjMz+84DSrzfzPlGDb9VlzuQofNt5ApaMsoUiTExv07i3F217B3oyPmN3y4d8PBfV5IjbkiS3xmk89FmIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzCJu8Y3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzCJu8Y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9457DC4CEE7;
	Mon, 13 Oct 2025 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369819;
	bh=5teCdA5xFef1wOWUkl+8i6B8a/Lx1fVGFO1hMO495g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzCJu8Y3atTAjsSGF6wcOu0k7wZPUkWwemE9iDHMB7SeSkMvywhfrUy5lP5ikgtra
	 AG5zrywyQWF/rZ/0Zmu3DYhtMu7UtUlK2xsPc3wBXysTX5REOkUDZEsBePb5usYTFw
	 KzWz+ovZAwKJl37V/q2g0Bpwn/wLJhy+ERJnCTQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 347/563] HID: steelseries: Fix STEELSERIES_SRWS1 handling in steelseries_remove()
Date: Mon, 13 Oct 2025 16:43:28 +0200
Message-ID: <20251013144423.840646292@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 2910913ef87dd9b9ce39e844c7295e1896b3b039 ]

srws1_remove label can be only reached only if LEDS subsystem is enabled. To
avoid putting horryfing ifdef second time around the label, just perform
the cleanup and exit immediately directly.

Fixes: a84eeacbf9325 ("HID: steelseries: refactor probe() and remove()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509090334.76D4qGtW-lkp@intel.com/
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steelseries.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hid/hid-steelseries.c b/drivers/hid/hid-steelseries.c
index 8af98d67959e0..f98435631aa18 100644
--- a/drivers/hid/hid-steelseries.c
+++ b/drivers/hid/hid-steelseries.c
@@ -582,7 +582,7 @@ static void steelseries_remove(struct hid_device *hdev)
 	if (hdev->product == USB_DEVICE_ID_STEELSERIES_SRWS1) {
 #if IS_BUILTIN(CONFIG_LEDS_CLASS) || \
     (IS_MODULE(CONFIG_LEDS_CLASS) && IS_MODULE(CONFIG_HID_STEELSERIES))
-		goto srws1_remove;
+		hid_hw_stop(hdev);
 #endif
 		return;
 	}
@@ -596,7 +596,6 @@ static void steelseries_remove(struct hid_device *hdev)
 	cancel_delayed_work_sync(&sd->battery_work);
 
 	hid_hw_close(hdev);
-srws1_remove:
 	hid_hw_stop(hdev);
 }
 
-- 
2.51.0



