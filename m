Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970031FECAB;
	Tue, 26 Aug 2025 11:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208723; cv=none; b=OWa8HLAhkxdBOa7/NJBI9NjvA5AQZcaJVe6ndQ6fgstSIyS+xkGEc3/DZESz321GHvQavydCdbhEryNN6ORpbeaoPCVfc76+kC0qv0TAQhbJJgbaN4aG3ck6mCZmqSSJwbPj0kxP7p6rPRq21vulaTtLzRYXCDOu9sf68QytNdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208723; c=relaxed/simple;
	bh=lM3Zo9BoIh5rC5d7sTjPl3cFiNbA/adaeGkb1Rw3LVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u56WBJSPbjeLRqqDUboA/yhiDSVxpfkYCf3DnerC8dmMLJj3UyQaSnZucD5g03Ib64YfjeQTgoxm61bMVBuFhaHKd8k1fZEjofegzvIihVzf1o/Vr+L3pI+veqzb0g/q5EgtTq5ger6FYPDNNG0Z6jiA/ha9TOsXJtWeIqPjE7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKDpE8dl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKDpE8dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D338C4CEF4;
	Tue, 26 Aug 2025 11:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208723;
	bh=lM3Zo9BoIh5rC5d7sTjPl3cFiNbA/adaeGkb1Rw3LVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKDpE8dlRTBmJj2nuDRPYB671aKnx8wOh5wbvxEyAxs9XTA5IihgEsvDBBpVNZji2
	 y2gIqYtG4AdhO6FvJr0Zkzhh6krJqy00vDKtzS+w+QfRLApUZ0e3vmnSExGeUOjV6W
	 XNb9AGvKs/RCeJS6MeCQv7d2/5cEDnHePa5QiFZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 221/322] usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive
Date: Tue, 26 Aug 2025 13:10:36 +0200
Message-ID: <20250826110921.347201512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit e664036cf36480414936cd91f4cfa2179a3d8367 upstream.

Another SanDisk 3.2Gen1 Flash Drive also need DELAY_INIT quick,
or it will randomly work incorrectly on Huawei hisi platforms
when doing reboot test.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250801082728.469406-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -371,6 +371,7 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
 	/* SanDisk Corp. SanDisk 3.2Gen1 */
+	{ USB_DEVICE(0x0781, 0x5596), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* SanDisk Extreme 55AE */


