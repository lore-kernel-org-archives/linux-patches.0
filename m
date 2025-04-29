Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF2524C071;
	Tue, 29 Apr 2025 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945547; cv=none; b=dnnmLFwiyYVUfjIBnw2EoqSaGrvb2+qQrQhrCgS6Xja5y6CfHuvjz/wXFZiJThViH0PVwaESPI669azLLjoj2xUtqJnpWY2+YDSAZ7GlOWprCGGqxN1w58IU8WNiRdRs1+fDOIrpZGxnVSnA/uT9F2ivEzgDrLleBab/WUjpsZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945547; c=relaxed/simple;
	bh=z6wwGu5Nz4q+sgA3nKl7V3sl4hrwkMjsgoJMz+hWX58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2YaZCq9wThHpKDH8E1UrhvdlvGURHppqzqkUt4ZVusz7Pq8lKLvkY3Z7rhfDBuxlFNujdgVGovswg+ooa6bqMEaCHaz2ijSJJ13jgL4dpBukCkvNIjTwMcqSYuSvKqHfNkxLftRdnBRca/NSGLnYaITpwR9f6IHHSHymwz4O8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZBpRkvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZBpRkvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922ADC4CEE3;
	Tue, 29 Apr 2025 16:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945547;
	bh=z6wwGu5Nz4q+sgA3nKl7V3sl4hrwkMjsgoJMz+hWX58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZBpRkvTaHoqdlZ4Vg2PN6qE9Jfd0A2r3dZrpprpvcmk49J6421E91I2V0FpLcH0b
	 3MTExqDdFNYQnhoJtvH9QNc0bR2FXCXhm1uhYuz5KesmQfzulYU0T2ugF4IztTvhqt
	 njVGOXpsCAFspnnU64B8qfn8HupwEYNANLxheIDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.4 148/179] USB: storage: quirk for ADATA Portable HDD CH94
Date: Tue, 29 Apr 2025 18:41:29 +0200
Message-ID: <20250429161055.375299003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


