Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43481C3F34;
	Mon, 10 Mar 2025 18:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630922; cv=none; b=oHrR3kfY0QxYtb1kcuFKMF9GDBKTc3PWlnR1JraHCbrndWLgYOxfqQLAjKArgB9eN8fgGiCcE8gaSIfg5QnoS0uzXpD/EolMBq9znBIQ/I+Ivc6GK4M0PLiR4xEiVH43sdvOP2i0qhHF4W7WYUoyNif8e3rs5WWg/xG00H3WHW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630922; c=relaxed/simple;
	bh=G1br3qEc76hXBnr6DQkQGyiE4wbp7ATZRyMhN540Mn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2YhrIgX8wN+nC+kSry+WJvJsrci9lTqsHfu1/sR4/LKNwHJPEH7VbBEDfLazPPn8ioD0AAUOk73sW1CcsvwJv8ckuM9OuFJ2pKkRwGtoKNg9Sc30OFdWWNT4vVlZoI6ISLMdtW4HktUy16SpROtLhMWMh1L2cQTHgEPN0Ea2kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOq7KSS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOq7KSS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E2FC4CEE5;
	Mon, 10 Mar 2025 18:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630921;
	bh=G1br3qEc76hXBnr6DQkQGyiE4wbp7ATZRyMhN540Mn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOq7KSS7UWVqegf3gGAqLpPrSQePjlFMmyYwm32ydCnA+fab9USbn0KrN7Ry8d4gK
	 gJbOv6tKINO/Kai49XpAneh+xHi7zXvnOodi7/+8E5hBLRK9bOyXr0beHh1p7afqKL
	 NDtbdM77JJuW9eIbFB7xbS3VT/Wc6BncfVeoAiC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qf <quintafeira@tutanota.com>,
	Christian Heusel <christian@heusel.eu>
Subject: [PATCH 5.15 580/620] Revert "drivers/card_reader/rtsx_usb: Restore interrupt based detection"
Date: Mon, 10 Mar 2025 18:07:06 +0100
Message-ID: <20250310170608.431744649@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Heusel <christian@heusel.eu>

commit 2397d61ee45cddb8f3bd3a3a9840ef0f0b5aa843 upstream.

This reverts commit 235b630eda072d7e7b102ab346d6b8a2c028a772.

This commit was found responsible for issues with SD card recognition,
as users had to re-insert their cards in the readers and wait for a
while. As for some people the SD card was involved in the boot process
it also caused boot failures.

Cc: stable@vger.kernel.org
Link: https://bbs.archlinux.org/viewtopic.php?id=303321
Fixes: 235b630eda07 ("drivers/card_reader/rtsx_usb: Restore interrupt based detection")
Reported-by: qf <quintafeira@tutanota.com>
Closes: https://lore.kernel.org/all/1de87dfa-1e81-45b7-8dcb-ad86c21d5352@heusel.eu
Signed-off-by: Christian Heusel <christian@heusel.eu>
Link: https://lore.kernel.org/r/20250224-revert-sdcard-patch-v1-1-d1a457fbb796@heusel.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_usb.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -286,7 +286,6 @@ static int rtsx_usb_get_status_with_bulk
 int rtsx_usb_get_card_status(struct rtsx_ucr *ucr, u16 *status)
 {
 	int ret;
-	u8 interrupt_val = 0;
 	u16 *buf;
 
 	if (!status)
@@ -309,20 +308,6 @@ int rtsx_usb_get_card_status(struct rtsx
 		ret = rtsx_usb_get_status_with_bulk(ucr, status);
 	}
 
-	rtsx_usb_read_register(ucr, CARD_INT_PEND, &interrupt_val);
-	/* Cross check presence with interrupts */
-	if (*status & XD_CD)
-		if (!(interrupt_val & XD_INT))
-			*status &= ~XD_CD;
-
-	if (*status & SD_CD)
-		if (!(interrupt_val & SD_INT))
-			*status &= ~SD_CD;
-
-	if (*status & MS_CD)
-		if (!(interrupt_val & MS_INT))
-			*status &= ~MS_CD;
-
 	/* usb_control_msg may return positive when success */
 	if (ret < 0)
 		return ret;


