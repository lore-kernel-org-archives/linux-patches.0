Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750AB20316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xU/d3+Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C31C433C8;
	Mon,  6 Nov 2023 13:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276470;
	bh=USjVdK3AEkhcYTt4exzQPh7ZfoP8sIPdesEdkunu1lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xU/d3+Qa4Hxxsa5+aBfi1a7wf8o8TKJ6RfSKDeKd3sNU/oqg9dnPvNW8PVtGhdOfg
	 WXQ/vzY/+n0C7kjSyoMqAM7iv9RwoV+d0I3naCp+IG4nh5afa/UqJR7ff4Z7RyWdA+
	 Wfv1wsnFwJDhBfnzO6FMDMTG8TLlo2xS2KwY4PRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 6.1 54/62] tty: 8250: Add support for Intashield IS-100
Date: Mon,  6 Nov 2023 14:04:00 +0100
Message-ID: <20231106130303.701444334@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cameron Williams <cang1@live.co.uk>

commit 4d994e3cf1b541ff32dfb03fbbc60eea68f9645b upstream.

Add support for the Intashield IS-100 1 port serial card.

Cc: stable@vger.kernel.org
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Link: https://lore.kernel.org/r/DU0PR02MB7899A0E0CDAA505AF5A874CDC4DBA@DU0PR02MB7899.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4932,6 +4932,12 @@ static const struct pci_device_id serial
 		pbn_b1_bt_1_115200 },
 
 	/*
+	 * IntaShield IS-100
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0D60,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b2_1_115200 },
+	/*
 	 * IntaShield IS-200
 	 */
 	{	PCI_VENDOR_ID_INTASHIELD, PCI_DEVICE_ID_INTASHIELD_IS200,


