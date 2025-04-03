Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC68824E000;
	Thu,  3 Apr 2025 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693751; cv=none; b=BUNI439OanoNt8tiHgGYPPXflvlUHGL3HF6fflcrDrlUO9D/1EfoTiqjTyhMrzxF0SCrOHethzTbWjUoBAEeisUfy+6Qr4P43rz0/iAD1I50nhkUhWCxu2cUhB4sjlqwCQqbVeCuvZ9UwGQOmQeqf/oAa0MK1Jy+fftUHmUkXyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693751; c=relaxed/simple;
	bh=SAWBC7bj4/Cj0iFdJkwV3m5TqbRkF2R2VHL335ltdxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reza2IBwu7v7Gskit/pJFGaohqSA31DJEUyH9wScy+tQaVlE18LtBsMtWytJISLobZev3Fk9IBEiby3px5PZwqZDuZcnFbStJqJCUyfsssVZViLapaxeEQOqxAs5Zk4cAI99bxHom3WxGRW3kWrZGun7YF1SyLKL/eJnAJe7wvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyYQ/95F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyYQ/95F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11FCC4CEE3;
	Thu,  3 Apr 2025 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693750;
	bh=SAWBC7bj4/Cj0iFdJkwV3m5TqbRkF2R2VHL335ltdxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyYQ/95FuMv5eTD4+PpmAvpHnGZVUCiOEiqTjnJrTSptJvAN0inLRz3EF6U/XC3bP
	 2TUT9FXxdrAZjA1RprqVw3G6LK+m4Z7kUVCmR5HYs1UgQCm74CyS7zUKlxR5D64+lM
	 Z2oqC6m03wk6rkE8vmlSkao6kh0eHQZw3dGHwgpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 6.1 12/22] tty: serial: 8250: Add some more device IDs
Date: Thu,  3 Apr 2025 16:20:07 +0100
Message-ID: <20250403151621.281758392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5127,6 +5127,14 @@ static const struct pci_device_id serial
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
@@ -5247,6 +5255,14 @@ static const struct pci_device_id serial
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


