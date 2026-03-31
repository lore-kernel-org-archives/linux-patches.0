Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA392D1F40;
	Tue, 31 Mar 2026 16:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975621; cv=none; b=pavEoNFc3d0XPU281hi8uMlwYWRGT3y24PuLPM2iqSjUFZh4J67T8Tu+duUTfd5NEzjy+msWxouXnnQj9SemTRs6zKVmFRjRmGdPmaop+QpkBFn0u0hIkGbvRrdy1T6jHPTcVagf/i51uilq3op39P66+sLnVwXPXU6qHm8jz1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975621; c=relaxed/simple;
	bh=wN32Aw63BdisMfMpu4cdJ7lhb6tf+zYl02z8CyZodXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbUe131x5Z9VYvgT62fk7xp9APh4G351fJBBbi8AR03IWbAcfJvu36/jUtJJWPFQ1bTJYQV0frNEqiF+inK64kOvJucHcmTft29MSyZV0dqOJ/44OAqKGBF6R7FsrTY2QoQa04J1X0TA9zOmM8x9UOwOZF3r+Cze1JzQW0sSxgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTgpNrh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTgpNrh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AFAC19423;
	Tue, 31 Mar 2026 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975621;
	bh=wN32Aw63BdisMfMpu4cdJ7lhb6tf+zYl02z8CyZodXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTgpNrh2W48N/bGKeAGZ6hKU3wL3DYhqjbujVKmjdXs7vbcZNfW0sRSxZgX9kWkkM
	 vHoodz5j57y1kE2AaHzjJGYqs1Dwy6a1qyHmKBn81yR0yp70Fg429QoE8uVrMNKtHK
	 Og/dPm7oxz8TfEe9DrIA3sjvch+VfYLXuq7qQyno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Spreckels <valentin@spreckels.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/244] net: usb: r8152: add TRENDnet TUC-ET2G
Date: Tue, 31 Mar 2026 18:19:32 +0200
Message-ID: <20260331161742.523540352@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Spreckels <valentin@spreckels.dev>

[ Upstream commit 15fba71533bcdfaa8eeba69a5a5a2927afdf664a ]

The TRENDnet TUC-ET2G is a RTL8156 based usb ethernet adapter. Add its
vendor and product IDs.

Signed-off-by: Valentin Spreckels <valentin@spreckels.dev>
Link: https://patch.msgid.link/20260226195409.7891-2-valentin@spreckels.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c   | 1 +
 include/linux/usb/r8152.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e4eb4e5425364..6ce25673e4cc8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10090,6 +10090,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_DLINK,   0xb301) },
 	{ USB_DEVICE(VENDOR_ID_DELL,    0xb097) },
 	{ USB_DEVICE(VENDOR_ID_ASUS,    0x1976) },
+	{ USB_DEVICE(VENDOR_ID_TRENDNET, 0xe02b) },
 	{}
 };
 
diff --git a/include/linux/usb/r8152.h b/include/linux/usb/r8152.h
index 2ca60828f28bb..1502b2a355f98 100644
--- a/include/linux/usb/r8152.h
+++ b/include/linux/usb/r8152.h
@@ -32,6 +32,7 @@
 #define VENDOR_ID_DLINK			0x2001
 #define VENDOR_ID_DELL			0x413c
 #define VENDOR_ID_ASUS			0x0b05
+#define VENDOR_ID_TRENDNET		0x20f4
 
 #if IS_REACHABLE(CONFIG_USB_RTL8152)
 extern u8 rtl8152_get_version(struct usb_interface *intf);
-- 
2.51.0



