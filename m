Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9D523ED75;
	Mon,  2 Jun 2025 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873820; cv=none; b=BFs0+OwvzaJOVyMr3tuvTOGrwMgv4SW0Avvm2oor4iQCPstP8XpVwppGQb5Kfs3XtcYSdPZC1mqxLceWjwGliYK/nTySnWw7lv5zrODezn/UsgrztRJ7kbmt7SDMSnaiyYAvZICHdqQvvP6jbbdRVlSn/N1CbcJzmKf3tCQEH6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873820; c=relaxed/simple;
	bh=3xSUgPtSKRvjUy6eBSR6JGbp/UycxjCs232zMSeAyXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/QbIBLLtMMUmgWLZtcICyY9NOUYYTwsFuuDdkq8xoirC1XR8ex276jFeMstJWjbhegfIzu8FJcwAbXfHMnfi34joDhUCtawlacHOzGI/IaCByG3k7KCsn61My46iST+mu4mmq6P36Pcoc8tA0oDu3wR9bY36Qtf5b878P6wAvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIg2V6Bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIg2V6Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C989C4CEEE;
	Mon,  2 Jun 2025 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873820;
	bh=3xSUgPtSKRvjUy6eBSR6JGbp/UycxjCs232zMSeAyXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIg2V6BdMcBopTaFV3M4ViqZLEWhLDY/rPv928Wcx9FBPKxiBCXdKeVxHPbN8EIqC
	 oCB8tOEF6cQw5seUNbEYqLr0jr+0mqW2jTO0vKcjaTnli0c/IUouyx8Kh/c/H0SvDJ
	 qAoO+LLXvwhQ8KD7gKpHrVJY2MJTTHYvOpSau4DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/444] r8152: add vendor/device ID pair for Dell Alienware AW1022z
Date: Mon,  2 Jun 2025 15:45:27 +0200
Message-ID: <20250602134351.606054655@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 848b09d53d923b4caee5491f57a5c5b22d81febc ]

The Dell AW1022z is an RTL8156B based 2.5G Ethernet controller.

Add the vendor and product ID values to the driver. This makes Ethernet
work with the adapter.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Link: https://patch.msgid.link/20250206224033.980115-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c   | 1 +
 include/linux/usb/r8152.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index bbcefcc7ef8f0..1e85cfe524e87 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10032,6 +10032,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff) },
 	{ USB_DEVICE(VENDOR_ID_TPLINK,  0x0601) },
 	{ USB_DEVICE(VENDOR_ID_DLINK,   0xb301) },
+	{ USB_DEVICE(VENDOR_ID_DELL,    0xb097) },
 	{ USB_DEVICE(VENDOR_ID_ASUS,    0x1976) },
 	{}
 };
diff --git a/include/linux/usb/r8152.h b/include/linux/usb/r8152.h
index 33a4c146dc19c..2ca60828f28bb 100644
--- a/include/linux/usb/r8152.h
+++ b/include/linux/usb/r8152.h
@@ -30,6 +30,7 @@
 #define VENDOR_ID_NVIDIA		0x0955
 #define VENDOR_ID_TPLINK		0x2357
 #define VENDOR_ID_DLINK			0x2001
+#define VENDOR_ID_DELL			0x413c
 #define VENDOR_ID_ASUS			0x0b05
 
 #if IS_REACHABLE(CONFIG_USB_RTL8152)
-- 
2.39.5



