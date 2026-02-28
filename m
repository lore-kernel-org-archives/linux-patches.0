Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0509E340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301044; cv=none; b=Uebp9Ri54RvsfwO4ytMJTFJxFH4OmfSTV197n2itpEfyLoaXdlUARurmkeEqD9sJRBf9ZZ4KWucJ2N11ADJImsRQ+Qqy4ZoH9fMTxGYrCpHHGjZbTBI3ToWK/MeY/gtlZHFFpGFV0p+c4FR3PTZUlkBIHdcXdjuWN7lBGKRvaz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301044; c=relaxed/simple;
	bh=6Cc4PRfLk/PGnfreM9C7aKdfqUUrvxo7Edl5B+zZn2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=op8wf6ecyur2CE32Tt2Jh7lhvh/XtBCNccTnWCQyp6P/RavNcDOdfnOCmNpnMBzDCcEKJ/lPlxFN/uEo6BhFOMhaL4Mt0uqnInwCo6f4vtZQIywwHGWGFIMrZY5N3oAu+2B6Z8aDAlA1iPwosNQOUapXKsiuDPUfi8GRbSpm8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVrI+6dL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVrI+6dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580E2C19423;
	Sat, 28 Feb 2026 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301043;
	bh=6Cc4PRfLk/PGnfreM9C7aKdfqUUrvxo7Edl5B+zZn2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVrI+6dL8+9VRjbsOZ7w77uv5PE/gBYF5F2JOjIInwXE574uQ9c+1Xc50257uEukr
	 /lhyE6PnRuPu/EAw/CMOr3CVDtQvjFclW2nr7uFWiKaWBG1/ULkFcHxEEXaJq0Exs3
	 nvV9cQtjTv4azJugmD4jXvy/3rJhyaqQ2/dkemtD3fWsuT+tat6MUIajLK9dC0yKix
	 0F7t6nFZ11earQ/ganrVP/Jbn/6p17eRPD6GgpkGqNgg/sS2znZMDAbPlgS9lNz1La
	 X7cENf4/u//jYoMzHw2WvjvtPNcEfuzZIA3e4pVcR0Q3QhQdm+QUafXCfxkJOTWVRZ
	 F+50mG0EtjD2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thorsten Schmelzer <tschmelzer@topcon.com>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 182/752] HID: multitouch: add eGalaxTouch EXC3188 support
Date: Sat, 28 Feb 2026 12:38:13 -0500
Message-ID: <20260228174750.1542406-182-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thorsten Schmelzer <tschmelzer@topcon.com>

[ Upstream commit 8e4ac86b2ddd36fe501e20ecfcc080e536df1f48 ]

Add support for the for the EXC3188 touchscreen from eGalaxy.

Signed-off-by: Thorsten Schmelzer <tschmelzer@topcon.com>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3965a58926f1c..240fcff0ca71e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -437,6 +437,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349	0x7349
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7	0x73f7
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C000	0xc000
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002	0xc002
 
 #define USB_VENDOR_ID_EDIFIER		0x2d99
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1763809177c4a..4dcb1d43df27a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2202,6 +2202,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_EGALAX_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
+	{ .driver_data = MT_CLS_EGALAX_SERIAL,
+		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C000) },
 	{ .driver_data = MT_CLS_EGALAX,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002) },
-- 
2.51.0

