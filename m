Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D955143747;
	Thu, 13 Jun 2024 12:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280267; cv=none; b=fpO2wSv1zvmI2OMB3/USZQzDNkQX8RyipvYDAg5Z00Nd789RY9d1KWQUlV4/tPjCAMWqxAfhRZVAoN3S1EBWHVWQjwa3FIfueDlsTKcPsZQLiNk8hl9mzFlqrsZxZCyspIS6+cvpqzq43q5d2Ocm1Zan5/Srs2677I37NcpDFQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280267; c=relaxed/simple;
	bh=sEVtyOjvwrVK9ooazGnqCpjLRap7GGj0c4CyZyMLZv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYDsNXXeDjQBBwbp84pzvGDOC9gvJk4k0oLvcXscmZZlIlcpchL2pxpVFa32MLWJqwQEySEN/chXx4TjbAk79TrSgHR/7URiO+iWGfg4aZuZMa50/cmmzLxNKa6mkSo4EwbxhapNpBABQff9ltPVnKtNYV6n+XD6nZppp+3j+pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ocuzg1Sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ocuzg1Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8257CC2BBFC;
	Thu, 13 Jun 2024 12:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280266;
	bh=sEVtyOjvwrVK9ooazGnqCpjLRap7GGj0c4CyZyMLZv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ocuzg1SrS+jmOJB9b93QfbdSIH3ZTiQpuCG1u4Xk+lyoYQQ+F1FWw+cQnkQvMwrPZ
	 7vspVg//tHAKf5vqeJVwIhkMb67LbGVl7gEyZ6AXWX6oXf2qm0TG5ADP87UhP/akaB
	 CFBcIJQRFYRZ5ZSXiGletKEv728+sI/yeTlkJd5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Gilbert <floppym@gentoo.org>,
	Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH 5.4 199/202] sparc: move struct termio to asm/termios.h
Date: Thu, 13 Jun 2024 13:34:57 +0200
Message-ID: <20240613113235.417711741@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


