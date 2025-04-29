Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94FC219A63;
	Tue, 29 Apr 2025 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949390; cv=none; b=WYAioaTn9luV8s/ObHR9/bBibIz3Wi1TX+n2u0z1J0ly1LWQezDxePEu9HuDK3xOpg14qMkp4/+zHkqBCibr5XjqBcCfiB4OOMttmDIjlXDJzdTwXKPmepztvLnSiU7jvqAfISlISaA1Z42VQr3jzwrZPFM4FdBGlDHlpXxiyC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949390; c=relaxed/simple;
	bh=SOclo1YfiBaNT/ZBSKirPQNzt3pHijxJ/R7LnME2kWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hhr/aGrTsp9KZFkzKC3Ndw4627ZeU0ew4hr0eyDkUStqlEldjM5ql2UZMBnYzZD0uV9U4Lo1vZJO+7X++HE46ve0zWb6GS0AiY0QpZk3QEes0/tumKn9DKsv3P+IfwpV7oYIMcK3y9mR3TYiVwA90c8GbKoQGyQqAQU54FQ6fJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXA5EfNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXA5EfNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4832DC4CEE3;
	Tue, 29 Apr 2025 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949390;
	bh=SOclo1YfiBaNT/ZBSKirPQNzt3pHijxJ/R7LnME2kWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXA5EfNkIb5H3WS2rIQDwQ1kBLY4vM8SrCBEYUv7oFardgQ/XOiQaz10uzfxTaxzD
	 a6vbSnzvIHv2hAL9pYaPVe9hatYW+P4aWh24+JZT6WKBtod5rJIM8ZJoPpjUZjceRl
	 OFi4gOPNOLXk0ThhT9vd3aqqVpr9/DvokSFaZOy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 303/373] USB: storage: quirk for ADATA Portable HDD CH94
Date: Tue, 29 Apr 2025 18:43:00 +0200
Message-ID: <20250429161135.577354635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 9ab75eee1a056f896b87d139044dd103adc532b9 upstream.

Version 1.60 specifically needs this quirk.
Version 2.00 is known good.

Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250403180004.343133-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -83,6 +83,13 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
+/* Reported-by: Oliver Neukum <oneukum@suse.com> */
+UNUSUAL_DEV(0x125f, 0xa94a, 0x0160, 0x0160,
+		"ADATA",
+		"Portable HDD CH94",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",


