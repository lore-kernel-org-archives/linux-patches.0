Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A224CEE5;
	Thu,  3 Apr 2025 15:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693860; cv=none; b=G35VjhgY89HSdXJjq7y/gAEiz81SIJ466lx3PYAPRTIrIiVttkifKxq+742NawR8NEmeZx4+KFj5FXz2TB37aOXtR+QO4qJ23eE2bZ/tN6Q5+v/99d2Ked6wZ87Az3JcQoiX3/VfB4gxQILrPjAa8mQwzuNF/xW+MAMZ+XezlZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693860; c=relaxed/simple;
	bh=WtOHdnnbBs2PIPCKerghme4CIIR6q+7JSDNkQgk3NOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHiR8JcVYAen7FNwc2BP6VxMBsw4fdnert7KjtHBMvmA+vTdB9GD1vvdpjL3oMVMgIn9pAX6C8ZPv2KDuey7ZyAl6voy0LcdNwyZ8oQjIvIrSycKvcxAMhILvCDGFQNdS6izGhL4U6r5cHFKfzhEezFjjz0tKidvUMUNRUmHWX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkDHLyr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkDHLyr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312E1C4CEE3;
	Thu,  3 Apr 2025 15:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693858;
	bh=WtOHdnnbBs2PIPCKerghme4CIIR6q+7JSDNkQgk3NOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkDHLyr6gdRKY+3BUTodv4FgU4Jd4fVepjlxqF0CovGJKlgrbg1OPhcF1j10Z4fSh
	 6TJFpt7v/QyMu4KhZoQ0uEy74e/IoGYSm/SVBqAOEtWXjnsxOFvK0shlU9DWA+wwYP
	 Ly/ORj7myvfhGMq0RBlMjuI0xAR3exAf+fXGd+to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 6.12 10/22] tty: serial: 8250: Add some more device IDs
Date: Thu,  3 Apr 2025 16:20:20 +0100
Message-ID: <20250403151622.335926252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
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
@@ -5213,6 +5213,14 @@ static const struct pci_device_id serial
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
@@ -5333,6 +5341,14 @@ static const struct pci_device_id serial
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


