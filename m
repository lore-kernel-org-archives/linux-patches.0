Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1BD131748;
	Tue, 23 Jan 2024 01:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972127; cv=none; b=LSxhY5V4v2cqrXJ962FkkZOmGH8CKNZLdsZZkTpGzrNkOm5yHXo35XrhhSz+JMS6O6zmmqv3ZW94xiqiJUy3xyfS/pElcozw7IOfM/ZHzbeb7RiKan0z+CMu9eOGsS8J1olBIsO3AWGzUjRKBMArnCPOmWiz9fCrvDklMki7Xns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972127; c=relaxed/simple;
	bh=9kb7zZFIDXauJbx5pOxbW+gOiwuVaai9d1I7+cqvXXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dls+TJMZSBfs77OLIj0Oqsz1MUmZipoImJUJFgLR15s5W28G8Nfn2rYYFz8RfbdiQTzy2noOYl1xhxvuWXWL88frkWPp3byjNwshxCSTlm7+ugu5lVxMeAgoGngYT190Ev/sVwAfX/SWpXoEx9eXcoR8anDL8gpr9OrxjOE2ly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNIZVPsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNIZVPsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50485C43390;
	Tue, 23 Jan 2024 01:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972127;
	bh=9kb7zZFIDXauJbx5pOxbW+gOiwuVaai9d1I7+cqvXXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNIZVPspmFMRRxBydwODaI2LV03iEaXL6yPdoXdCaLCahKs3YsbBjk0+gNBXTb2mn
	 KZLSHK93ofwyBw360zHdVM/IaFFHOcFqrcw3JBoCGpGlJYWaT5gJy4aqcx8F7zw9BR
	 p263gyXByVqzH3JP4WqCIxMkcabA+e5nQlfbi208=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.15 060/374] parport: parport_serial: Add Brainboxes BAR details
Date: Mon, 22 Jan 2024 15:55:16 -0800
Message-ID: <20240122235746.696419963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cameron Williams <cang1@live.co.uk>

commit 65fde134b0a4ffe838729f9ee11b459a2f6f2815 upstream.

Add BAR/enum entries for Brainboxes serial/parallel cards.

Cc:  <stable@vger.kernel.org>
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/AS4PR02MB79035155C2D5C3333AE6FA52C4A6A@AS4PR02MB7903.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parport/parport_serial.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -65,6 +65,10 @@ enum parport_pc_pci_cards {
 	sunix_5069a,
 	sunix_5079a,
 	sunix_5099a,
+	brainboxes_uc257,
+	brainboxes_is300,
+	brainboxes_uc414,
+	brainboxes_px263,
 };
 
 /* each element directly indexed from enum list, above */
@@ -158,6 +162,10 @@ static struct parport_pc_pci cards[] = {
 	/* sunix_5069a */		{ 1, { { 1, 2 }, } },
 	/* sunix_5079a */		{ 1, { { 1, 2 }, } },
 	/* sunix_5099a */		{ 1, { { 1, 2 }, } },
+	/* brainboxes_uc257 */	{ 1, { { 3, -1 }, } },
+	/* brainboxes_is300 */	{ 1, { { 3, -1 }, } },
+	/* brainboxes_uc414 */  { 1, { { 3, -1 }, } },
+	/* brainboxes_px263 */	{ 1, { { 3, -1 }, } },
 };
 
 static struct pci_device_id parport_serial_pci_tbl[] = {


