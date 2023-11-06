Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7154322EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3rSAknd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4A3C433C7;
	Mon,  6 Nov 2023 13:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277340;
	bh=WSU1EHmmHrFbZ5mA2sFqAwJDpglu/nofnxCG7y+o0HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3rSAknd9uY+DdQC3VKrAU/oVek2VxEdKtRD78ztrH25bvuFnyffwJh01KRqF9ict
	 M52Bbf2uAJwLEycSHcRJsiFZOb3Ys8oLzUbp3HJKYtXz4T6i3JByqTRcUl9u613PF/
	 XLefBoGc/cf/VlyB1iZfIraoiPZYyWcT9mK3lais=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 5.15 119/128] tty: 8250: Add support for additional Brainboxes UC cards
Date: Mon,  6 Nov 2023 14:04:39 +0100
Message-ID: <20231106130314.576975380@linuxfoundation.org>
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

commit c563db486db7d245c0e2f319443417ae8e692f7f upstream.

Add device IDs for some more Brainboxes UC cards, namely
UC-235/UC-246, UC-253/UC-734, UC-302, UC-313, UC-346, UC-357,
UC-607 and UC-836.

Cc: stable@vger.kernel.org
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Link: https://lore.kernel.org/r/DU0PR02MB789969998A6C3FAFCD95C85DC4DBA@DU0PR02MB7899.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   57 +++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -5367,6 +5367,17 @@ static const struct pci_device_id serial
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
 		pbn_b2_1_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0AA2,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_1_115200 },
+	/*
+	 * Brainboxes UC-253/UC-734
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0CA1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
 	/*
 	 * Brainboxes UC-260/271/701/756
 	 */
@@ -5399,6 +5410,14 @@ static const struct pci_device_id serial
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
 		pbn_b2_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x08E2,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x08E3,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
 	/*
 	 * Brainboxes UC-310
 	 */
@@ -5409,6 +5428,14 @@ static const struct pci_device_id serial
 	/*
 	 * Brainboxes UC-313
 	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x08A1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	{       PCI_VENDOR_ID_INTASHIELD, 0x08A2,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
 	{       PCI_VENDOR_ID_INTASHIELD, 0x08A3,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
@@ -5423,6 +5450,10 @@ static const struct pci_device_id serial
 	/*
 	 * Brainboxes UC-346
 	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0B01,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0B02,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
@@ -5434,6 +5465,10 @@ static const struct pci_device_id serial
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
 		pbn_b2_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A82,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0A83,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
@@ -5452,6 +5487,28 @@ static const struct pci_device_id serial
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
 		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-607
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x09A1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x09A2,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x09A3,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-836
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0D41,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
 	/*
 	 * Brainboxes PX-101
 	 */


