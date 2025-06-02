Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417791C6FE9;
	Mon,  2 Jun 2025 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877156; cv=none; b=OSy/1HWOi/CielQdThny+lXRE2hLwxZkkSCxGzAKSvkdMWT9n8FI2sDSeGrCkJVtsvBe2xtP5Z+hL6NRhfnDlrHJDhlisRSgr4tpP5YeaQjrekeh7lBkxJinmxwPpPKhbbzoFJW34D7F5TA2xm5Yx6159FyfRZ3V4pR3sb/rn3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877156; c=relaxed/simple;
	bh=+WjM1GaK1iVkZwDoLesCK717tWmrO4f/bN9Sbg8v4D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfRZXx5KIk8zyNNYiH2fcunc14wJvv0iUC/nQvkQ6Y+aqbzAssctbbv/vuemK9s6SYTsQjtteQuMZ7nrRNFvGbC62EQ0vJHF8RQO3SuU3Ng+ExZEvJmWAGAE5OJRgGaqaGDY1oxvp3sgOpYJsOHFM6lj9tkv3SpUts08EPuLBRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ghb2V3Ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ghb2V3Ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A556AC4CEEB;
	Mon,  2 Jun 2025 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877156;
	bh=+WjM1GaK1iVkZwDoLesCK717tWmrO4f/bN9Sbg8v4D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ghb2V3Obbk2Fm4TNcz6NrDKh/1yWco4pVWN1usgwYyb5fR2pCNrKETQs9EskFRT5R
	 GsuDXh44mk3f/AkAMs94peVNK8SFL9j/wG08xR96VQqi5aVLC4DFE9JotcZl+vjM5n
	 Utph9UA7evd52yZWYmeX5R+p60EwRciS8HMdy+88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/325] r8152: add vendor/device ID pair for Dell Alienware AW1022z
Date: Mon,  2 Jun 2025 15:47:46 +0200
Message-ID: <20250602134327.528869324@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 061a7a9afad04..c2b715541989b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9880,6 +9880,7 @@ static const struct usb_device_id rtl8152_table[] = {
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



