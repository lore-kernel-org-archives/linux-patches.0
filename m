Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784CB299927;
	Mon, 20 Apr 2026 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699865; cv=none; b=nykGieAe7T6Tdz1n5bCd/rzrlXlqBSC/qbyLxlmO/E4QTWG0MNc5M0qZEaFzeeGYZp2HuKG3dHj+D665+UKbyV6lnv2hnPk7rMi7f5yOmKvcsW7PB8XxiAmDk3dLjFtHHTVO9pj1BzKnCBAqz0wlgyQewJ+EdDv8l91oHtsqphs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699865; c=relaxed/simple;
	bh=OqKNbjlVcJ4YxmKyqA59svzwq6FXpA+jlN/kynzHn5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbFNvMmaNfIheTwoqtuAoDr5MAro7LwOzXTwxq3azxnbEWrlindwVz5ZxNpyVLdzP36QRAVXjtIKG4dsnire/NnA8dAM89Dputwf7XTU+e5LIz2ftTbW+OtNZOpL9rJdv377zL8VQCBtNdbNzvglG353T1SsIJ3wJxUFlIHBbrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwUrIF3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwUrIF3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB24CC19425;
	Mon, 20 Apr 2026 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699865;
	bh=OqKNbjlVcJ4YxmKyqA59svzwq6FXpA+jlN/kynzHn5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TwUrIF3jn1ike/lb7DHbPosfAalDUkqgO7A39aSikoyNX6RIHgIcw2QT6dwGHAxKc
	 +dhI8z92eR44q6s2ZE31tiozC2Q3PpPIuv4py95FaOJKvUjO5LbxLWuRXKwIQ0nZSS
	 Y43Ee7pg20WxifCYreNTBalV7gABHE+DHmMPKhIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20Br=C3=A1t?= <danek.brat@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 27/76] usb: storage: Expand range of matched versions for VL817 quirks entry
Date: Mon, 20 Apr 2026 17:41:38 +0200
Message-ID: <20260420153911.811377137@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


