Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBCD22EF7;
	Thu, 18 Jan 2024 10:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575085; cv=none; b=rKn7Mp9OvvkPGgymFTjUfH+DoYmCqH02SuR2XELbO/UpbmngNlyH8DKcoQ8GKylntbdETcHnZsz3UHFhcYnRHFP3+l6Z5BigBwdnKvFKQBp59m7QtATEq30MmqOBBF2o+s2kFRxsXXqlAYc6+WOld06Cw9/34itCFMsh2iWca2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575085; c=relaxed/simple;
	bh=deNpQiCl/tzAvXJRRvKUkVOqheQ76p45ckuEg3eIZZE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=OGOYWH8RJqEuLP7uKSsgaXaVM0apal/T5gATfi6tYAyExZD/7oLs+8xjmVSAocP0JkzLJpR5b+hT18LPj40O/Ib3a5hW91I3x3ybcCqFbCe54/rsJVKlbk/2QLn0pqsYXx4nxyAu5hZKm8g6iZWSMrBRh2uGReLQ/2vipLK1G4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNqvi06y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNqvi06y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE75C433F1;
	Thu, 18 Jan 2024 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575084;
	bh=deNpQiCl/tzAvXJRRvKUkVOqheQ76p45ckuEg3eIZZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNqvi06yc5lmuBt4geiaHuyUoqmdj/1+0nmlljN4yoIKC50yOROqCYmIuUzBCADaP
	 Bscxub8tJAdAYUqz3jr+v7J2s5FiGsedtAUBdpIafrtus5xpxJKLPYz0af4h+UIcCT
	 /Z/h639JBDvY4YEFyl9keVSBYDvAuuSf+IBXbiTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 6.7 21/28] parport: parport_serial: Add Brainboxes BAR details
Date: Thu, 18 Jan 2024 11:49:11 +0100
Message-ID: <20240118104301.960911565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


