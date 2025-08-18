Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99573320CAB;
	Mon, 18 Aug 2025 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524579; cv=none; b=lOTWBk73yfyV0/X4Ng2wlct6Oaa/0cKJ+8uobZcBHvCCoLt8CJPgydgBzkc3i1hYIvV8ZZ//l6owTaLMqFnW3JXbRzmisxb0V4zEA1BLDnBNLoCXv1GYGLSVRYngnpfLsazxavQ4JdnoMVcTIBUdmeUG8uGtmT4yh16fBZt042Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524579; c=relaxed/simple;
	bh=ccBQHH+zfrTOWMouGzzpCsSFF+7IBvKpjk5Ucuun5/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lBhbSDosuU4og+kf+dbdUClZt0Baiai1ACTA1u8Rp+SKOVV308rpOR0obgnBhanRYlWNHJA4NmVMn6gW7Er274gb6IIcrAI08HYb9/aJi51aiaR7425W2pHiJO5T1TE6GkYEsVk23WmF478IOaQ5crbOVLpKLetsu3aEjGf7sUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upmegZKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upmegZKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097BEC4CEF1;
	Mon, 18 Aug 2025 13:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524579;
	bh=ccBQHH+zfrTOWMouGzzpCsSFF+7IBvKpjk5Ucuun5/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upmegZKwV0cYi63Td6+VbKzkB1gCb/UyQoBsYPYJGI/mAnV/srmiqOP4cRa3RJifX
	 Jkx6XqN1wUO2Im4DlmcuMLM3R4WhGzwMi4/6kYw315h5sWKLjpmy41WbXB3FZRzxK5
	 t0dycYDEHcSctBInoGgOhb/sUlBxdmDraw0iloug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: [PATCH 6.15 501/515] tools/nolibc: fix spelling of FD_SETBITMASK in FD_* macros
Date: Mon, 18 Aug 2025 14:48:07 +0200
Message-ID: <20250818124517.733957203@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

commit a477629baa2a0e9991f640af418e8c973a1c08e3 upstream.

While nolibc-test does test syscalls, it doesn't test as much the rest
of the macros, and a wrong spelling of FD_SETBITMASK in commit
feaf75658783a broke programs using either FD_SET() or FD_CLR() without
being noticed. Let's fix these macros.

Fixes: feaf75658783a ("nolibc: fix fd_set type")
Cc: stable@vger.kernel.org # v6.2+
Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -127,7 +127,7 @@ typedef struct {
 		int __fd = (fd);					\
 		if (__fd >= 0)						\
 			__set->fds[__fd / FD_SETIDXMASK] &=		\
-				~(1U << (__fd & FX_SETBITMASK));	\
+				~(1U << (__fd & FD_SETBITMASK));	\
 	} while (0)
 
 #define FD_SET(fd, set) do {						\
@@ -144,7 +144,7 @@ typedef struct {
 		int __r = 0;						\
 		if (__fd >= 0)						\
 			__r = !!(__set->fds[__fd / FD_SETIDXMASK] &	\
-1U << (__fd & FD_SET_BITMASK));						\
+1U << (__fd & FD_SETBITMASK));						\
 		__r;							\
 	})
 


