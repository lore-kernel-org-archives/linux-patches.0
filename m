Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBD521B191;
	Sat, 30 May 2026 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165368; cv=none; b=b/R9M6L1vaP3CFtTp1WqHWskUftgthIVgoncGYHIAY4tqRzClTaD3gaVSPf/foBVsyQioYiJi6DYTi5H22C/Gb17EPN/V78mcNa2CPWEdy0lxD1vVvVtYxPO8Lt/xsDXPUTg317BkovwZWsKcEiEM3p0OPyKIa8szkuthD8UhxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165368; c=relaxed/simple;
	bh=jpsYki9kN6BE0S0GYDMAJhnoJrSKaFcrhyJeJsu9fqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/RObF4AgvbHVCW7cdZqNc7yoTtO/ZInZtYluEwRjJCul0xWTp1wyrhncwFOMzePQMsKUjcbuVe7EztMvw9QAnYmrsEwsQmyQ5YjfCVMoC40ywdeLrWU7G/QqaCV1zHBTs2BnC5ksjpVRmV1DAJGFDCQCQeqTHMDSM3AWIoCphk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnzb4ZUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnzb4ZUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605591F00893;
	Sat, 30 May 2026 18:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165367;
	bh=B8bR1yCo8NWCN4S5FExiCAwzTxG2hlty2lV+LU8B8eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnzb4ZUOePxHaxln1FlvLM3rpvBJUkDclSrsEdEWI+PRotDfhmTdA4yq4oQP/mDNl
	 bskLPhXArmUvt6gf6kJU6U4wj1y0upKF1HgjT6LwgGYX5IenWM+luIg2Tm9uuQ7nKO
	 wcV1HFcAFnRP2vRuTWbGTnce63yZ/0PHD+xyEELw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20Br=C3=A1t?= <danek.brat@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 057/589] usb: storage: Expand range of matched versions for VL817 quirks entry
Date: Sat, 30 May 2026 17:58:58 +0200
Message-ID: <20260530160226.093421677@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2339,10 +2339,11 @@ UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x
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


