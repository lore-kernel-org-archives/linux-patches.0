Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8F298CC4;
	Tue, 21 Jul 2026 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673289; cv=none; b=KnyfrqwLGdkVs97eUb2hLEHh2KNU72oG2hpO41r/j1sD5lSZEyfi3BvA980MK3Y5N2ehmfxB44hPKbMnu6MExpCRz0aYmbxc+pQTM6ZPvCv2Xqo6J7zz08m2VQ48TCOsvfFhR0Cd1iqErWkHLyoTVVI//NI/lWU1Hz6GjrCh6Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673289; c=relaxed/simple;
	bh=VcslDtFOwGn8ZQXhUO1oekOXfUvkvMIkixSCTGb5G4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDJq13D5VdtRU9BNHGDaFufd08fGENjPp9s89/6TivdveiAHoyo6I573gWt3mRpBWeojwNfcvGLW7Xi191EqKQZEtpbnQdPaI0Uq31FCH5SoHPHXzs1s7lT39YJOuBp6AXYXw9MO+RrS55iZiaWaDdSrQ8iQgWawqhFRhq5gU/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eq/623cd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq/623cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECBF1F000E9;
	Tue, 21 Jul 2026 22:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673288;
	bh=i5EZpPdSeSeL1VWM+ryMes8g1XWwr0AwNw9o+SR38eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eq/623cd4DB1hAI1/b928IPAtvAq57OK8ks+YqhHbzYU/rsQbtmCMRb5dSGpnsjjx
	 EQcWgACtx9NrcHQljC0Sktkeikvv/zYpLaCgG/S9yary2UAeH2j+zIBdQGnqzqXzwP
	 8bBb31nvnz8hW+HAyhLm2hmtRj62vhwmfRnRwEJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 106/699] USB: storage: include US_FL_NO_SAME in quirks mask
Date: Tue, 21 Jul 2026 17:17:45 +0200
Message-ID: <20260721152358.091762463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 2c00e09e3f9f06f8434f5ea2ee6179ce46692ee6 upstream.

usb_stor_adjust_quirks() parses the usb-storage.quirks module
parameter into a new flag set and then applies it with the quirk
mask to override built-in flags.

The mask is meant to cover the flags that can be overridden by
the module parameter. The 'k' quirk character sets US_FL_NO_SAME,
but US_FL_NO_SAME is not included in the mask.

As a result, the module parameter can set US_FL_NO_SAME, but it
cannot clear a built-in US_FL_NO_SAME flag by providing an override
entry that omits 'k'.

Add US_FL_NO_SAME to the mask so that the module parameter can
override it in the same way as the other supported flags.

Fixes: 8010622c86ca ("USB: UAS: introduce a quirk to set no_write_same")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/3BCE5880F9A45C2E+20260602053842.2920137-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -488,7 +488,7 @@ void usb_stor_adjust_quirks(struct usb_d
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
 			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
 			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS |
-			US_FL_ALWAYS_SYNC);
+			US_FL_ALWAYS_SYNC | US_FL_NO_SAME);
 
 	p = quirks;
 	while (*p) {


