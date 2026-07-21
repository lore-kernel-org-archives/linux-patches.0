Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE7523C368;
	Tue, 21 Jul 2026 20:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665267; cv=none; b=bszU9wRsyKIpW0ExrYAUn+xI2mP6X+hryWvN6B2slTZQYXybU4D9ZhjXzEfdMkfsXfT6X5yQ0xfHxXDnWI6z5vANZChYex3cIifatoCEWI15Pi403TcLC/12PA8BIAg0XI/6h0VtDvfAsHYm7TFmOxop2KE7irIE3QQRpFAab50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665267; c=relaxed/simple;
	bh=7OXLRxNK5UFOHrPn6cSCBXbSNeJbllBn4bdvE5FthWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iib5rk8HuQyhsjBLSWhCgefGMV2nFSNsv+2iqVX1/axbBhyeew7AFi9cCpzwvasWbAjl4ci9nnH+IStFm8o2AzZR7QjNGS6wAKZD69IQ5j7jIxZwkXwXlclwXOtWfJWsnBkWoLAg8KBQ7qFhIJHo/yw6KxEZos7lUvcAXpF+5TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVe2oemR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVe2oemR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6554C1F000E9;
	Tue, 21 Jul 2026 20:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665262;
	bh=qCeU/V4DoD0dh7sJlzR5XHmDNLKB5k82Y+sXRNu5Rrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVe2oemRuYpIZT8FeyAMVC8tJXyYM6jPNU40Ht8oeTVpmtLcMjvfeA1JOH6tJHRLR
	 HhR5HwbDORcdAZFQ/MhB3QjpX5P+kXBtBTEid6Gx4r7jZqwwt1mCCBP7cbWpnAJdMX
	 8a0gebZHjkL9ek7DVRXLBRTT3W1RUdK4yEAfzbWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 0239/1266] USB: storage: include US_FL_NO_SAME in quirks mask
Date: Tue, 21 Jul 2026 17:11:16 +0200
Message-ID: <20260721152447.166399907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


