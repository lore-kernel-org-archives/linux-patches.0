Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D512E093A;
	Mon, 20 Apr 2026 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701092; cv=none; b=aQdlH9RV1FzyNohDHVIm8+5qh91Y/vQ6qLIhsa1BV6CnB9NVAOLNkdFCB6OqB2EyKTHqVgbDqxeJAQAVaTr38SldfWYbAWtxbklawMqxXVvafY91HKwPTYSbGj2puhD1inmL3h6yS81qbXr1ql/mMxWfkcV/t9wFP3gUuou+7DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701092; c=relaxed/simple;
	bh=EKIxXJyibHbCe5TlJw6CrFrH2Bu8t/7nhUeXaXw0WVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GKAGE6KRS4b2SzGHkUbi+oSULQf3TFHZ8mOeQWEUoBywYs+cpyPhp+8qPEu0ISPLFNcf1eV72/BIbSFgfh+aR/6Oom9pIL8ZH3r7FLMzuIqa6ILRIvbMAlk24MlMKavAYcjjawsunSG4It/uh9gmush4tgst5hDnb30m1n1pr1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VT/HLNJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VT/HLNJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E28DC19425;
	Mon, 20 Apr 2026 16:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701092;
	bh=EKIxXJyibHbCe5TlJw6CrFrH2Bu8t/7nhUeXaXw0WVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VT/HLNJeQCFjqzAnnNYWL8ib7AOMqoSulSJFWqEfOA5kjDKJiOb1C83rfr6y23duh
	 xg3nvnaCu+8VJhbZ5GPRPsedIIYyMDeOE9wbf5OVOt3JX1AMFpu843Z1MSl1AqdR9X
	 gHzwky3AEvT8b9BJEhIF7p9MssqLZlc6Q7ZBUXQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20Br=C3=A1t?= <danek.brat@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 146/198] usb: storage: Expand range of matched versions for VL817 quirks entry
Date: Mon, 20 Apr 2026 17:42:05 +0200
Message-ID: <20260420153940.866272630@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


