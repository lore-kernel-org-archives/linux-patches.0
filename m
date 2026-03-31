Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03633F23DD;
	Tue, 31 Mar 2026 16:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974776; cv=none; b=auMc7BunF9q/geVKru0w0NDTp27KUrtY+vP9BOeP7//h02LRkem+DGjlyCiAStrMruSZm7kmiC62K+G93c3GpGS4RKuB7wdhxhzQeaNpjAUvikgBbSX3/j/kiSafWn9aK6vvoskVB/l2FItLi5rnwyYLmX+WNkkMgkecn2R6yis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974776; c=relaxed/simple;
	bh=JDWt6lCFH2vOOZEaXjN/iAOLDoeDMcbkv4CwdcuIEWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csgQrkU+EoQgtRMOIwtwwwmeaRWs2sCAitlo4JvmRgRcedD2tXZ40m6a+XMuV524bgBPUfQvdno1Mpo4tt5cUFrFELSUt7MxymiEM/tlBavkxcWWvnUvVGYwjKxWTy5nHfeq22fVAoYNEMJB9ZT21ZU/ax43FUOWppmbJ6bGTM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GL7amjWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GL7amjWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88959C19423;
	Tue, 31 Mar 2026 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974775;
	bh=JDWt6lCFH2vOOZEaXjN/iAOLDoeDMcbkv4CwdcuIEWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GL7amjWay/dglPmfevvmta3uSU1i3Hje2sMtgz/McsKX/V43qDCmDt7n/Eb8fSh20
	 QBrcU1C7JElOSuvZNAr1rS4ex33lHpALrZX4vPIy78IkUldyP2j7XHx7Z99vWfzU1k
	 WkeYJ8jiBhFud/K8HKTJuavDVSElskILQ1PQHhNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Spreckels <valentin@spreckels.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 039/342] net: usb: r8152: add TRENDnet TUC-ET2G
Date: Tue, 31 Mar 2026 18:17:52 +0200
Message-ID: <20260331161800.341718723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6b107cf5f37bd..9eda892beb1f8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10062,6 +10062,7 @@ static const struct usb_device_id rtl8152_table[] = {
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



