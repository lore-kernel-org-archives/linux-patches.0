Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D467D31D75F;
	Mon, 27 Oct 2025 19:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593079; cv=none; b=pnxq0KAVNMWcVv6RfF5HOM/bY99OatOcctwRNiUiBZ0u9VsJc0tYlbLuE+HEoy+lPMCyHYCEqcZBjx45ikdyMmHkqfGLoIGHISA9vYT9Nk13gE39fjtaQhWrO3tMc5wA/hb83hikMbE/PvxRmTS6+lvoPqPfFoboKFb4QGTzDa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593079; c=relaxed/simple;
	bh=ILgoM71ClRsX1gdHpc80j3VySiy0tPnhIeLCfWXiSL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCLFngzmbttvcdQILEpU8XTsFWrDOk0JP7iDviskzMaiLhr5v67GOxN11zkt7Se5q0/qJCPb7qV/ZMF1fKE6s+mNP3pVzkpbyhfkTEw8qY425OaCs2NsawJnQOY7ngsscaUj/4/RjWIYbbxF+KDTYb0nf7lTgSBTpFIlznQKx50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Q+s5+Rc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Q+s5+Rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6885CC4CEF1;
	Mon, 27 Oct 2025 19:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593079;
	bh=ILgoM71ClRsX1gdHpc80j3VySiy0tPnhIeLCfWXiSL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Q+s5+RcrTQIsvs/PENhtsnGw+27ME5CyOGUO9Q1KpzN/ewtLwzWIdwDVP0vfOD3u
	 zwsDlldPdY+NpHyrYema2OMCpgW6k7Mq+O8zDmZsDkuxHzxcyUpVkJxEiJnACKc6Zw
	 zwgvgrOwZDxezeEwy5SLbcl6nNSdTlYZ2DPalsXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 112/117] serial: 8250_exar: add support for Advantech 2 port card with Device ID 0x0018
Date: Mon, 27 Oct 2025 19:37:18 +0100
Message-ID: <20251027183457.056970192@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Florian Eckert <fe@dev.tdt.de>

commit e7cbce761fe3fcbcb49bcf30d4f8ca5e1a9ee2a0 upstream.

The Advantech 2-port serial card with PCI vendor=0x13fe and device=0x0018
has a 'XR17V35X' chip installed on the circuit board. Therefore, this
driver can be used instead of theu outdated out-of-tree driver from the
manufacturer.

Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20250924134115.2667650-1-fe@dev.tdt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_exar.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -39,6 +39,8 @@
 #define PCI_DEVICE_ID_ACCESSIO_COM_4SM		0x10db
 #define PCI_DEVICE_ID_ACCESSIO_COM_8SM		0x10ea
 
+#define PCI_DEVICE_ID_ADVANTECH_XR17V352	0x0018
+
 #define PCI_DEVICE_ID_COMMTECH_4224PCI335	0x0002
 #define PCI_DEVICE_ID_COMMTECH_4222PCI335	0x0004
 #define PCI_DEVICE_ID_COMMTECH_2324PCI335	0x000a
@@ -1678,6 +1680,12 @@ static const struct exar8250_board pbn_f
 	.exit		= pci_xr17v35x_exit,
 };
 
+static const struct exar8250_board pbn_adv_XR17V352 = {
+	.num_ports	= 2,
+	.setup		= pci_xr17v35x_setup,
+	.exit		= pci_xr17v35x_exit,
+};
+
 static const struct exar8250_board pbn_exar_XR17V4358 = {
 	.num_ports	= 12,
 	.setup		= pci_xr17v35x_setup,
@@ -1752,6 +1760,9 @@ static const struct pci_device_id exar_p
 	USR_DEVICE(XR17C152, 2980, pbn_exar_XR17C15x),
 	USR_DEVICE(XR17C152, 2981, pbn_exar_XR17C15x),
 
+	/* ADVANTECH devices */
+	EXAR_DEVICE(ADVANTECH, XR17V352, pbn_adv_XR17V352),
+
 	/* Exar Corp. XR17C15[248] Dual/Quad/Octal UART */
 	EXAR_DEVICE(EXAR, XR17C152, pbn_exar_XR17C15x),
 	EXAR_DEVICE(EXAR, XR17C154, pbn_exar_XR17C15x),


