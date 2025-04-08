Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3B5268688;
	Tue,  8 Apr 2025 10:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109923; cv=none; b=hT4zBiDqvZsbK8i4PocfziLlI1+QjHHYLx1h4fS2A3t7uUXQCsC+1KPX74L4H4gMcfbDkNn1yYjRXJpzw0iHfVktzDC7ACMQEa13FZNYH0Tl/3w7xH8egW0bhNTp9k4O7hdHik9e8RrVZeSvBmfg/STU6RqnzccMjklDz+NaN1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109923; c=relaxed/simple;
	bh=K2Rr9ksECkpA5wpuWOp3qRDd61MlNKzY//5vnabaAm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lranXUdL4vFvSAQXe0zq66xdndAaMusiwy9TWAWNgSOsK31iXt4D4jJfxb3kHtnb2j5GQBXK84pON3ZFF+BQUeOyYfbo4HyhILZA/+gv7crIExKRuaiR19A0E0RP5t4HPssIbczHAUAXPsjLkc0YJVqP3i0y3+2yYU25Kk3Dsls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcLYitaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcLYitaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5FFC4CEE5;
	Tue,  8 Apr 2025 10:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109923;
	bh=K2Rr9ksECkpA5wpuWOp3qRDd61MlNKzY//5vnabaAm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcLYitaOYcHUcR/o2FST0dOiZEj/JYaXgXZKRUTiKqj6GdzL44dfPkRZ0+TOeJJah
	 J1kjaufg+Q1lvkfmjPIfagWE1w+Zbcc5SlMpoHw2gOsUlElee/Z4ET/C2clAI75xRM
	 Vydpwi3MusHTnLDNHV7hW2Eauk0Uo3WH2DWb+fJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 5.10 103/227] tty: serial: 8250: Add some more device IDs
Date: Tue,  8 Apr 2025 12:48:01 +0200
Message-ID: <20250408104823.450321874@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cameron Williams <cang1@live.co.uk>

commit be6a23650908e2f827f2e7839a3fbae41ccb5b63 upstream.

These card IDs got missed the first time around.

Cc: stable <stable@kernel.org>
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Link: https://lore.kernel.org/r/DB7PR02MB380295BCC879CCF91315AC38C4C12@DB7PR02MB3802.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -5160,6 +5160,14 @@ static const struct pci_device_id serial
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
 		pbn_b2_2_115200 },
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0BA2,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0BA3,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
 	/*
 	 * Brainboxes UC-235/246
 	 */
@@ -5340,6 +5348,14 @@ static const struct pci_device_id serial
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
 		pbn_b2_4_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0C42,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0C43,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
 	/*
 	 * Brainboxes UC-420
 	 */


