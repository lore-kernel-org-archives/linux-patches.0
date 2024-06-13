Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72C0137914;
	Thu, 13 Jun 2024 12:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281595; cv=none; b=s2EVzoUFCTvMd/ixr+8MxmEeeHvx8ztntV28b2GkLM8FYFFHOnzwYBjS9lM4Pk3i+/i1ssbHAPN3j1wo4ux87gtU/WmalSUf9APXv6iWNybMw99zhYGtVCk8xRDnnYJnp3jq2M1ddQgKgROO0M5yIQsgw40bCuWyuQIpRR2ApHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281595; c=relaxed/simple;
	bh=3ereE59v79g7qO3fRUXUk+zC8R3OTrq6GynoURG87ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iwo9P4lKswUE9YpHV77AYQYfL/sX27303nVPU9AeK9DumZuP6eIFbr3BeS4bo6eOO0OD4WTqyQ3Ca4s8ytVugtA/OFUyJFH6yX6tHEKwfefjLDTmecVHxZSocG3aBkFPu3kgqA9Aa1W08hlkeV8FcFnTxM2v/cx4xIechyDZ88g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zq5iW24k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zq5iW24k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EA3C2BBFC;
	Thu, 13 Jun 2024 12:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281595;
	bh=3ereE59v79g7qO3fRUXUk+zC8R3OTrq6GynoURG87ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zq5iW24kvoAwPqLYA9PfObKS4xXwCQDmwRxxrHHLp3r+RB3FzluPKMW4M+tLVinDP
	 xB0JpgOckIMCtf4DIS1+SYMtrtTGj5ViFp+ZcTuCqa/S4F8ZScG8GUGDPs2di2ndKl
	 EbNJbPuT/QIpU3pbwOoV5IP6iF4othzSWDSC12yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Gilbert <floppym@gentoo.org>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 5.10 309/317] sparc: move struct termio to asm/termios.h
Date: Thu, 13 Jun 2024 13:35:27 +0200
Message-ID: <20240613113259.506997612@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Gilbert <floppym@gentoo.org>

commit c32d18e7942d7589b62e301eb426b32623366565 upstream.

Every other arch declares struct termio in asm/termios.h, so make sparc
match them.

Resolves a build failure in the PPP software package, which includes
both bits/ioctl-types.h via sys/ioctl.h (glibc) and asm/termbits.h.

Closes: https://bugs.gentoo.org/918992
Signed-off-by: Mike Gilbert <floppym@gentoo.org>
Cc: stable@vger.kernel.org
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Tested-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20240306171149.3843481-1-floppym@gentoo.org
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/uapi/asm/termbits.h |   10 ----------
 arch/sparc/include/uapi/asm/termios.h  |    9 +++++++++
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/arch/sparc/include/uapi/asm/termbits.h
+++ b/arch/sparc/include/uapi/asm/termbits.h
@@ -13,16 +13,6 @@ typedef unsigned int    tcflag_t;
 typedef unsigned long   tcflag_t;
 #endif
 
-#define NCC 8
-struct termio {
-	unsigned short c_iflag;		/* input mode flags */
-	unsigned short c_oflag;		/* output mode flags */
-	unsigned short c_cflag;		/* control mode flags */
-	unsigned short c_lflag;		/* local mode flags */
-	unsigned char c_line;		/* line discipline */
-	unsigned char c_cc[NCC];	/* control characters */
-};
-
 #define NCCS 17
 struct termios {
 	tcflag_t c_iflag;		/* input mode flags */
--- a/arch/sparc/include/uapi/asm/termios.h
+++ b/arch/sparc/include/uapi/asm/termios.h
@@ -40,5 +40,14 @@ struct winsize {
 	unsigned short ws_ypixel;
 };
 
+#define NCC 8
+struct termio {
+	unsigned short c_iflag;		/* input mode flags */
+	unsigned short c_oflag;		/* output mode flags */
+	unsigned short c_cflag;		/* control mode flags */
+	unsigned short c_lflag;		/* local mode flags */
+	unsigned char c_line;		/* line discipline */
+	unsigned char c_cc[NCC];	/* control characters */
+};
 
 #endif /* _UAPI_SPARC_TERMIOS_H */


