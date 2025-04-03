Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B82251793;
	Thu,  3 Apr 2025 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693805; cv=none; b=BhjmmAgXlv0MXUiOXI0bauWx+szXhSMLw0eSnSbslvjVFnEqmZvZfx9dOzrr4O05+vF9V8KKgJdgQUjMVRn9agTF1ZdofThCKhIcCNlHHmx5jkUZp0vriX/hw0XvcXFHjCpG+c44yESklEtmYZliYxO2X054RyDJSEaU0qQxAcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693805; c=relaxed/simple;
	bh=pVbEn94qM0ocDWiaZS8wkV1i3PaoEd/WmxAMM+RaGXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzpm1OZ3pwZ6QEY3MSwkl2tPTc/ap0L5S5/PCihpre8KwLd0w0xkL/Tu3PE8CwIxttbTtYxHkeMlKYkTCsoUaNvcHQi81yEhCo2bPsVm+PMTVG6T37ZQlnlYEAjl3RHZdQ8BcRsMYznzXMagw2gCbjlH7b28NZXxDzHSjweW7Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxK0lyc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxK0lyc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA2EC4CEE3;
	Thu,  3 Apr 2025 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693804;
	bh=pVbEn94qM0ocDWiaZS8wkV1i3PaoEd/WmxAMM+RaGXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxK0lyc7+s356IzKpVjIW9TbhnraohK7P/7kOhYCR/QetmZXwVk/EKhYYUDWKIxf6
	 gRh4cqi48in/EyoL7ESL4JDF2Al2WdRPh4FJZ1vV5Z0Jb4ucbrfRofkY7Yf7VVDL0R
	 9QEQt5reMj9ifcGvWv4uri7w+f5/F2zPHIBk5buI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 6.14 10/21] tty: serial: 8250: Add some more device IDs
Date: Thu,  3 Apr 2025 16:20:14 +0100
Message-ID: <20250403151621.435870194@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5253,6 +5253,14 @@ static const struct pci_device_id serial
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
@@ -5373,6 +5381,14 @@ static const struct pci_device_id serial
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


