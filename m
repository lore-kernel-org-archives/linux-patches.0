Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5B282C60;
	Tue, 29 Apr 2025 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947840; cv=none; b=tJHqz/XeUpgQol2OgCOBIHe9NxamRNnBHoNQZq/VGsO27fcXLi+owuYffyxXf6u2AN1m8g+0jkjsPDjuaJGEbdzDrjoTBlYyGe9dXjxm7zgzbQhQ0DI4UXLeMlJu15xbODedzdrEiPBjUEA//ZEctr4yk6fGzG5Muzn+Ysu4XQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947840; c=relaxed/simple;
	bh=xB8zSaiLLeYzpvt8OE17sBByDrUIFxDyHFgKBw7SHnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebvMXQ09uHPO559+5yIlcxwSc1kBfObDlpJMugRZOz7gj/pNNb0N0YrrZN5LU9FTAjOPE86u69esHK/Iln2H0jZWyJuUzeznVMFRBw4r8dDQQo6x5fhWpomLreOSBpPdvsnftKqUfSMFOCswf1bY7yFQ+g7n1CjHWcUaqjUizrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HELhm2Ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HELhm2Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD52C4CEE9;
	Tue, 29 Apr 2025 17:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947839;
	bh=xB8zSaiLLeYzpvt8OE17sBByDrUIFxDyHFgKBw7SHnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HELhm2Ry8SMU0lohj5Th4zfylmNxLtLbMliR1vYkN9+cVZ3Sj3nykCMW1lTz7gE5l
	 Rf8ks8Hr+dqHn7JT1VcTdDF5w3Vkyu9s/+xcDQBmFbm65LcK2eFZ7GGuUd85o/bfXZ
	 c/uuDKNxkf1aP+5BVU8sJiknhFnLJQf26wInalHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 119/280] USB: storage: quirk for ADATA Portable HDD CH94
Date: Tue, 29 Apr 2025 18:41:00 +0200
Message-ID: <20250429161119.980298926@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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


