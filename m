Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D672D73B1;
	Mon, 27 Oct 2025 19:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592018; cv=none; b=A/L+ah3eoeSuQBzhFKlaKwwPGjs/yI9HK7QrXymTlhKFmEhP7uYKaeD44uWBoJxXbRtB9y3Q9jZVP4VUkRsMb1gjyG3bpV26E+hzbXVsrvDtjToywo9zTBq72rs8RE+Wl/NDDserDhb34btV6UphKtSb3V+kJruZba7GEHZy+fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592018; c=relaxed/simple;
	bh=KUxb3lD8nN9fYDUGRm4L14PFeyPGoIFSSxHlspmzggA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6PvpJiJWZazgWkxM82HrQ1Kw1ngcGeKN4UED+bf8OaY+EjcRkdK0PFZAS25Y/m8SKnpacaPzSSOoldDLCk40hdl3x70mB9Np2kEqYZyDwYUHg1jdQ+JX75YRLc4+7RwbW8FF4mkap729NPs+COxaUZAeT5V6zn9sfiW7J0Y37k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+kJGTjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+kJGTjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06073C4CEF1;
	Mon, 27 Oct 2025 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592018;
	bh=KUxb3lD8nN9fYDUGRm4L14PFeyPGoIFSSxHlspmzggA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+kJGTjN1QXzNCHDKF+Xyd+9XE/ErSvXNIK1zD3+RymBa+dQ6aJsY2fqMstZe0gst
	 Rs9Ggd/F1vzUmjTUDCohd4EQlZWrnV+p7CTO++IvadAOrFj1yEPz6OfnuyEWBRHidk
	 3zfxTyzUd9qtd99zGoXAM7AAX3QqvoZ3ffFS6xy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 086/123] serial: 8250_exar: add support for Advantech 2 port card with Device ID 0x0018
Date: Mon, 27 Oct 2025 19:36:06 +0100
Message-ID: <20251027183448.691063185@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -33,6 +33,8 @@
 #define PCI_DEVICE_ID_ACCESSIO_COM_4SM		0x10db
 #define PCI_DEVICE_ID_ACCESSIO_COM_8SM		0x10ea
 
+#define PCI_DEVICE_ID_ADVANTECH_XR17V352	0x0018
+
 #define PCI_DEVICE_ID_COMMTECH_4224PCI335	0x0002
 #define PCI_DEVICE_ID_COMMTECH_4222PCI335	0x0004
 #define PCI_DEVICE_ID_COMMTECH_2324PCI335	0x000a
@@ -842,6 +844,12 @@ static const struct exar8250_board pbn_f
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
@@ -911,6 +919,9 @@ static const struct pci_device_id exar_p
 	USR_DEVICE(XR17C152, 2980, pbn_exar_XR17C15x),
 	USR_DEVICE(XR17C152, 2981, pbn_exar_XR17C15x),
 
+	/* ADVANTECH devices */
+	EXAR_DEVICE(ADVANTECH, XR17V352, pbn_adv_XR17V352),
+
 	/* Exar Corp. XR17C15[248] Dual/Quad/Octal UART */
 	EXAR_DEVICE(EXAR, XR17C152, pbn_exar_XR17C15x),
 	EXAR_DEVICE(EXAR, XR17C154, pbn_exar_XR17C15x),


