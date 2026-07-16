Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79530AD05;
	Thu, 16 Jul 2026 14:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211098; cv=none; b=cXJVn5Q8/Tl5pD8ZK0m3mOrSrV9rBUvrg9zHeARnn5q0dn4+5yD1zgurqFMr2RmQJ+aCdx/86ee8lvfGZ+Bq7qiiQoTKObh7LypT90Y466/2/lvuO68RJ3AhghGgoLpDvt/L6xsrDASq6bIPFh/DkdlT8rZVDiIzgYbhnq2fKWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211098; c=relaxed/simple;
	bh=zOnRFpSq8TjnJhH2W2QHGg2uZjo3LHi3Mxqv4BlQaiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+UeGk9fAMT0AN/Sg7/GaszpvtqDbDc4jDAHW1Lu+Au3YZQujH9rmmdNeHLQvDbyiRY2wFNzv2nq5VU06ROWoVwaM/Hr7+XPUhceX0jHqSgjt9PO0oah6s2INUuao1MBbvcqz/BAbCTewa4wOuywWQw56pMjrdtIuHDnv06EZ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tv1Zf+sU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tv1Zf+sU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A217F1F00A3A;
	Thu, 16 Jul 2026 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211096;
	bh=qn0qqMU7ap0qXY8cR6jusO89s+mUpoAa3SiuA3DR7VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tv1Zf+sUvI3pK4J5BoIOy7WeJhHu4iq6yNV5OoN80NIqWlhn/0ddT3b4Sls2zDBaN
	 1Z2c4s+SNPuC7X7fXwLNc/9+WCWTAcTlqv/FHOEy5A6/CjCXlKvZiNxCiZuBlFjVDW
	 2evbpp03x7HyXUfLYfe8zJpC/W/D5udSE7rWBRW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 298/480] USB: storage: include US_FL_NO_SAME in quirks mask
Date: Thu, 16 Jul 2026 15:30:45 +0200
Message-ID: <20260716133051.265972988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


