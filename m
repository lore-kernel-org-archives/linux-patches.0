Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F9042CB1D;
	Thu, 16 Jul 2026 14:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212335; cv=none; b=laAL81/4Bao8RZb1415towBm8zoNz8e/rMJzuGW4uS0TgJV2Y09WJ1QCB4iTmsrv4cMYT10JpiNaUCq7QaA3Tje7jsEWB/T31vKugzIuNeVY++oVyYoIoxJg8Og9FN6gDHl/UdES2eQwF9bchEz5Sn8LWnio5ImlhAX8o6u+KPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212335; c=relaxed/simple;
	bh=B2VLtL35QgcIl4kxvZNbL/MALjtwGxdgVXs7MHnFiI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmFYjWZVoEsn1KWkU2PbKzTkzXe3asEINcXqACCOXGSr3qrC6dPBbDHOp+QU9f6PlghbxjL3r8ouAuU+vcv80GvOQk8X3zHm7XpPIGqUN/PJeDzC5yUOhWFRsuXEjyJO/7xFx+gpXAXVI4IpPcT5niA2K1rFV/9IVJ7PMqLP28k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBFF2ctW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBFF2ctW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E8A1F000E9;
	Thu, 16 Jul 2026 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212332;
	bh=cVL+hKVWOwyIjnphjNJYGNryrGpj6XgtqqhDkQNNEh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBFF2ctWXaJTL0dglB3f8UNf37Eii/47SpBlqZSPIIu02iioEYgGtWqNyTswGAfkw
	 2+tVxbZknfjqcI8mZI9VUWehjSj3oRkPXo5N452iTd32p2ogVEanhX+dN7cDE9+fYP
	 Ngjh6btgayS/L19TXgkEpnELTt51PaS+TOHIxraM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 234/349] USB: storage: include US_FL_NO_SAME in quirks mask
Date: Thu, 16 Jul 2026 15:32:48 +0200
Message-ID: <20260716133038.602004859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -570,7 +570,7 @@ void usb_stor_adjust_quirks(struct usb_d
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
 			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
 			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS |
-			US_FL_ALWAYS_SYNC);
+			US_FL_ALWAYS_SYNC | US_FL_NO_SAME);
 
 	p = quirks;
 	while (*p) {


