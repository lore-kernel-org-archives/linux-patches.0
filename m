Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B003569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96B3C433EF;
	Sun, 28 May 2023 19:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301877;
	bh=lTy7IDSLgtTrZBotiWdMEJxRjafNuUN+OW8PH2fbAf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aq4DwWmvzqBQhL4uruXnjgjnbnSx2eCIefIHptyBczmEoOLv1D/Kooq3B/5aKf0JL
	 2GsSOiNUvCt1Lwet0OAg6VDH3hWbe1oFHQo/IVPgi3OoPTCvY3rt/23+cR5NYQYvez
	 eXON2Sy5tuV58KE9QjN5WQNAEqDWVhhzmEVFZeaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/161] HID: logitech-hidpp: Reconcile USB and Unifying serials
Date: Sun, 28 May 2023 20:09:27 +0100
Message-Id: <20230528190838.586448783@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 5b3691d15e04b6d5a32c915577b8dbc5cfb56382 ]

Now that USB HID++ devices can gather a serial number that matches the
one that would be gathered when connected through a Unifying receiver,
remove the last difference by dropping the product ID as devices
usually have different product IDs when connected through USB or
Unifying.

For example, on the serials on a G903 wired/wireless mouse:
- Unifying before patch: 4067-e8-ce-cd-45
- USB before patch: c086-e8-ce-cd-45
- Unifying and USB after patch: e8-ce-cd-45

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20230302130117.3975-2-hadess@hadess.net
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 2fd64361884cf..b8558292801ec 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -809,8 +809,7 @@ static int hidpp_unifying_init(struct hidpp_device *hidpp)
 	if (ret)
 		return ret;
 
-	snprintf(hdev->uniq, sizeof(hdev->uniq), "%04x-%4phD",
-		 hdev->product, &serial);
+	snprintf(hdev->uniq, sizeof(hdev->uniq), "%4phD", &serial);
 	dbg_hid("HID++ Unifying: Got serial: %s\n", hdev->uniq);
 
 	name = hidpp_unifying_get_name(hidpp);
@@ -945,8 +944,7 @@ static int hidpp_serial_init(struct hidpp_device *hidpp)
 	if (ret)
 		return ret;
 
-	snprintf(hdev->uniq, sizeof(hdev->uniq), "%04x-%4phD",
-		 hdev->product, &serial);
+	snprintf(hdev->uniq, sizeof(hdev->uniq), "%4phD", &serial);
 	dbg_hid("HID++ DeviceInformation: Got serial: %s\n", hdev->uniq);
 
 	return 0;
-- 
2.39.2



