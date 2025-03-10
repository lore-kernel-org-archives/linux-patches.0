Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E07230BE3;
	Mon, 10 Mar 2025 17:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626897; cv=none; b=LJXqtpPRafqAuieJJ6KhwD/THPOVfHDYwJVcj7NJo8MoOQcm5ApWeRPCEB6Mob4AZSPQNJLU5J0MthNUIXYXHFE9C7QAwYiNu5SrjoF9hdDECDwLwLkzM1oNzZwacoLIUVsSeFcsr4AHWViIzdjPEYSkSYxoADCVYrlYryqMFlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626897; c=relaxed/simple;
	bh=Qac905umtN8Ce8ef7FqZaK5Fbc6DclHTyAM0AL1hU9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=br8CyhLOhlgRly8NJS7LJYafwz7RLa+p8cxUAmU9rcng3Vb+ar1UsWOgeRF52mKczFLZAIenR9KneQHDuKdv3ei59kU9eurbLjiNYh6Moxoi9WR4gHGS47M4QCg0z1jK2TSn8UnWiB2C6DHaN+xB2iUvYCmR/eY59chvLvuECHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9h3sr84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9h3sr84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDBAC4CEE5;
	Mon, 10 Mar 2025 17:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626896;
	bh=Qac905umtN8Ce8ef7FqZaK5Fbc6DclHTyAM0AL1hU9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9h3sr84Uk9y+OetJ5zPzwe+mEDdtJ5jhheWIr1d8dQvpUfJRcuRYbZU394GSKLMN
	 /t2Pq2kaMp/mHZzWWhrowT06oTQ2pnZ1Yb290g+IIPR/Wewkb57LvPzMgGWSIE0z6w
	 xh4uEyAvtbPpPozSsZvk1JvE3EwlREZxNEr/7b+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	qf <quintafeira@tutanota.com>,
	Christian Heusel <christian@heusel.eu>
Subject: [PATCH 6.13 151/207] Revert "drivers/card_reader/rtsx_usb: Restore interrupt based detection"
Date: Mon, 10 Mar 2025 18:05:44 +0100
Message-ID: <20250310170453.800418873@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


