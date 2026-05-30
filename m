Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C755366567;
	Sat, 30 May 2026 16:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158670; cv=none; b=pvFUHtnKXgIm7l/l3Zl7RM3q5iAjk5H0SIqsctDXbvOLYtK3gexfof9AGz9Y93RgGlVXeqRpDP8IUpeqU5eWoF1fFSioun24QdzRaIeCivsDVEMFDeWbt1ORWTqJgexvQ1zoj0nS7u21+qCnwZRF91T2pIVwM7TTVmpGK0bk+Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158670; c=relaxed/simple;
	bh=ARG9r2UjBUHuixqNe/3kulITTDHsT8j9PppFEO8YKpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKRjGvJ+LKNAW4hpwdk1kfpe5GFAVdq2ThIYwg3B+in4KlqSdsxVaN7bGMn4mrethRM4usYM26y5Vo+rgYcP/k4g4U1SymeyetnH8gsDBNC6dTRARtnhSxj/Xv5KoeVMkBVeCgDSf0wxE08PWrXVIYhBgCD8vAwl+y3to9BRD+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjSJFPSx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjSJFPSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BF41F00893;
	Sat, 30 May 2026 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158669;
	bh=lz8ajR7E9ddB9WLt0JsXZbOWk3N1XUBYatnNaTst9WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjSJFPSxlRqfgfvTFougu5Vu63m/pdL7YtlO+qJmkqREZC9OpNW7EKs5r3TbUdZO3
	 neYGOKbdi6mOP+VuixGnGvImE3kFwW5Z5C4+lLOaVzT/L3zmVDUc3M6QG35xqJPWG4
	 gpBRoC7xVtbLlXdubLBAOSXmaRR4f9vkt4sQyxuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20Br=C3=A1t?= <danek.brat@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 073/969] usb: storage: Expand range of matched versions for VL817 quirks entry
Date: Sat, 30 May 2026 17:53:17 +0200
Message-ID: <20260530160302.376690842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


