Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D435922EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhBNbsaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAC0C433C9;
	Mon,  6 Nov 2023 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277377;
	bh=T0tY2Toi9SzAQnL+wvXYs3yFBHtiwj0vQJ8/HkP3QkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhBNbsaVy2fEPO3pTqd6T1jV7BmqfDUkYEhT/aCCvXykjXs/+EF8vwXv4QUM7tMTT
	 WEuh38BNOBrGLHWfzPQreZmUUvD8DOX+5jojB6b8VDGibY1zirrmjWsQ34qPkFzV20
	 HVvTl4icGbNR0exueXatuI6YMQnfqXA84/mGvPt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 5.15 123/128] tty: 8250: Fix up PX-803/PX-857
Date: Mon,  6 Nov 2023 14:04:43 +0100
Message-ID: <20231106130314.766318325@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

commit ee61337b934c99c2611e0a945d592019b2e00c82 upstream.

The PX-803/PX-857 are variants of each other, add a note.
Additionally fix up the port counts for the card (2, not 1).

Fixes: ef5a03a26c87 ("tty: 8250: Add support for Brainboxes PX cards.")
Cc: stable@vger.kernel.org
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Link: https://lore.kernel.org/r/DU0PR02MB789978C8ED872FB4B014E132C4DBA@DU0PR02MB7899.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -5662,16 +5662,16 @@ static const struct pci_device_id serial
 		0, 0,
 		pbn_oxsemi_4_15625000 },
 	/*
-	 * Brainboxes PX-803
+	 * Brainboxes PX-803/PX-857
 	 */
 	{	PCI_VENDOR_ID_INTASHIELD, 0x4009,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
-		pbn_b0_1_115200 },
+		pbn_b0_2_115200 },
 	{	PCI_VENDOR_ID_INTASHIELD, 0x401E,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
-		pbn_oxsemi_1_15625000 },
+		pbn_oxsemi_2_15625000 },
 	/*
 	 * Brainboxes PX-846
 	 */


