Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FA5179A3;
	Fri, 24 Apr 2026 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037914; cv=none; b=GPFc72f6T67vCjU85RNYBw0MBk5yzDigFQ23eyXQzu+g8t64fPsqYzdAwXIhSAb+k8lg07ViWrmgn4AFoyhCQu2uFF3vtzaW1TZY51IGRC1cC/rn5NtvdOG+gKxD5fN508/XQuz0yjrnFcHsj5texG9bg3/VudHkJPr8z+XeCjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037914; c=relaxed/simple;
	bh=6Wk2x5lZm3jMCcqeg7vJM0b/3QrKcxGOScfvT6hJgnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NE9lc8CWdje+jDXX2VHWN8TY8+4mLIhYnNYoMxK8Zk5FmX9s0VRGPxVttxByUDNbHYPiETn/olDZNzIv0qny1VhcgIDuWo/YqT0O1owPpXHSQeB3NWQTqcWSm8JGgYYqG2UNw31dhkIKhPc9dKCWLs/tv/zcjwvJ+SOGydeTp6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06uPxOFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06uPxOFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B4CC19425;
	Fri, 24 Apr 2026 13:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037913;
	bh=6Wk2x5lZm3jMCcqeg7vJM0b/3QrKcxGOScfvT6hJgnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06uPxOFGRV7Ahwp/3VKJPiOKzikXm6QKmb5OPQkZBtcHilx9NZkcrDIhcxTMhy2sv
	 NnlK2bLFRvLZ3EoFr3LAY9WcfBaZyqAvnKKCIbWG/hFPjg0lyaL+jyjVqAJdY5RQBt
	 LfS7MNI1a+UuTzjszuG7kuuxIQjZu8VoL/22CdC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20Br=C3=A1t?= <danek.brat@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 086/166] usb: storage: Expand range of matched versions for VL817 quirks entry
Date: Fri, 24 Apr 2026 15:30:00 +0200
Message-ID: <20260424132550.757049413@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Brát <danek.brat@gmail.com>

commit 609865ab3d5d803556f628e221ecd3d06aed9f30 upstream.

Expands range of matched bcdDevice values for the VL817 quirk entry.
This is based on experience with Axagon EE35-GTR rev1 3.5" HDD
enclosure, which reports its bcdDevice as 0x0843, but presumably other
vendors using this IC in their products may set it to any other value.

Signed-off-by: Daniel Brát <danek.brat@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260402172433.5227-1-danek.brat@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2350,10 +2350,11 @@ UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x
 		US_FL_SCM_MULT_TARG ),
 
 /*
- * Reported by DocMAX <mail@vacharakis.de>
- * and Thomas Weißschuh <linux@weissschuh.net>
+ * Reported by DocMAX <mail@vacharakis.de>,
+ * Thomas Weißschuh <linux@weissschuh.net>
+ * and Daniel Brát <danek.brat@gmail.com>
  */
-UNUSUAL_DEV( 0x2109, 0x0715, 0x9999, 0x9999,
+UNUSUAL_DEV( 0x2109, 0x0715, 0x0000, 0x9999,
 		"VIA Labs, Inc.",
 		"VL817 SATA Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,


