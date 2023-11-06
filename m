Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A27EEBF
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZyR7CWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2144DC433D9;
	Mon,  6 Nov 2023 13:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276305;
	bh=/O6S/f8B7Wk4qXJPP1WoD2kZXrgJm90Almoc9tqyLcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZyR7CWfrkEDgfhs7odvZNB5pwWcA7vNEV+ho52ryuQbR/OeHFzp5VOTBzEeqcQEO
	 aob/W+4q83e63eh2KSpWVoiEzNoJh8RQaaXeoxiBM0ioHdE51SzQl3mztJTNYkRVG6
	 FgOtzMjxitbGmTXRAOjv6jTA+1Zz3ZWJb52l2S2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 4.19 58/61] tty: 8250: Remove UC-257 and UC-431
Date: Mon,  6 Nov 2023 14:03:54 +0100
Message-ID: <20231106130301.577976516@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cameron Williams <cang1@live.co.uk>

commit 33092fb3af51deb80849e90a17bada44bbcde6b3 upstream.

The UC-257 is a serial + LPT card, so remove it from this driver.
A patch has been submitted to add it to parport_serial instead.

Additionaly, the UC-431 does not use this card ID, only the UC-420
does. The 431 is a 3-port card and there is no generic 3-port configuration
available, so remove reference to it from this driver.

Fixes: 152d1afa834c ("tty: Add support for Brainboxes UC cards.")
Cc: stable@vger.kernel.org
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Link: https://lore.kernel.org/r/DU0PR02MB78995ADF7394C74AD4CF3357C4DBA@DU0PR02MB7899.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4799,13 +4799,6 @@ static const struct pci_device_id serial
 		0, 0,
 		pbn_b2_1_115200 },
 	/*
-	 * Brainboxes UC-257
-	 */
-	{	PCI_VENDOR_ID_INTASHIELD, 0x0861,
-		PCI_ANY_ID, PCI_ANY_ID,
-		0, 0,
-		pbn_b2_2_115200 },
-	/*
 	 * Brainboxes UC-260/271/701/756
 	 */
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0D21,
@@ -4884,7 +4877,7 @@ static const struct pci_device_id serial
 		0, 0,
 		pbn_b2_4_115200 },
 	/*
-	 * Brainboxes UC-420/431
+	 * Brainboxes UC-420
 	 */
 	{       PCI_VENDOR_ID_INTASHIELD, 0x0921,
 		PCI_ANY_ID, PCI_ANY_ID,


