Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7222248883;
	Tue, 29 Apr 2025 18:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949833; cv=none; b=Ic1hnh7T3APISSx/DHgLrwi/qn+CZ0pBMCt731NDOzPbsy7pUbuw0qvCdbKJX3vpVTDyGb8zn7nnHYHjpN/zfZoAOhDXOAfV1WEB9dnPw7ONdthpjiWImWJ00lXwiOjOCuCasaWkLQnV6uqeTNRu58sp6qe9L2DcMKq3COuW4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949833; c=relaxed/simple;
	bh=mUzFXDhwpzAds7ApUH6/6lVzdUDkRmi8oRFRwSYnjJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8xbB6F2HukIrK8I8wmGxIxCslum4kiM8AmA/caPSfDuzXokhU0IesWXEY5c++u1XTccj5CHDI/J6khHUM1Al7bMA7NDaGPWEYE+hT4BxBZmsiHjU+yFdnzs3XJ1Zyv5F7/0bN4g4EV1Z1O2JzsZ31qLhejv8UlJrhjvczrJadQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4XSfJgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4XSfJgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37802C4CEE3;
	Tue, 29 Apr 2025 18:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949833;
	bh=mUzFXDhwpzAds7ApUH6/6lVzdUDkRmi8oRFRwSYnjJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4XSfJgi0k5OqK5iIIIgu1dbDMeKeG4QYnlNL5TyFsUViRnn8OxoIoSsuW8c/HshX
	 3FTKk6CZOpH+wqwg6xFbe749cZIV2R+4uk+Qe7UML+lqQx+VFwpzrVRP570A5Rsekp
	 pOBxDtKmfiKJWU0TblECo/aI6AMyTfhnnKegTw/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 072/167] USB: storage: quirk for ADATA Portable HDD CH94
Date: Tue, 29 Apr 2025 18:43:00 +0200
Message-ID: <20250429161054.678452610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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


