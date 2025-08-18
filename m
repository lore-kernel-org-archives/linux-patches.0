Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A79343D9B;
	Mon, 18 Aug 2025 14:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526500; cv=none; b=uOL/+WDLYHDHf3eMRAMtT/MCmrAYs4h9PWHINSCos1UxhshjCyw3ea/ME4mHoP993Rd13uNH/sUcb9RcmArBQ1o7MA67dBMR39TVU9ZEfOsSYryF+nq/WJfTk1RyvFsB9Ii6fxreTb3YihMxCACPW+WFmpbWnvvK/Qvnb+TnPhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526500; c=relaxed/simple;
	bh=PBYb9bBqBSjrQfMlv8pfd3MIpbOqy/5L9NUiqouxNfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suEu4OeIvzfKueZsThrGlWVq0ooqMbCmbUqiN5Ojj47DXU7GC4vGqCWC2BEt2RC7HtaA68/FH2++D5OhUlPDatofIycFXZdVXINeIMZqFJxy9sHQt9D3hixRWyHPqWOiFFZoAj/TCo9XaW1emc4O3Gj7zWB5SovhK/ukzC/ToyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPoz9Uqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPoz9Uqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1704C4CEEB;
	Mon, 18 Aug 2025 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526500;
	bh=PBYb9bBqBSjrQfMlv8pfd3MIpbOqy/5L9NUiqouxNfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPoz9Uqaq9QXhO1MkvjxqTAcylU8lqtt8ypmh9vEO7k8GYUEwpLDkY/yQvcbiEuL6
	 7BXsqn6Vy5hmFaCVfOKCEVENWyu2kkJb+HiwAA4lfeIXeuWWjlJEo3FbmY3IA2WAtT
	 rAifHOy7jSc7ixiJTMoBVxXJ5nHIaLjlBjm/vftI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: [PATCH 6.16 555/570] tools/nolibc: fix spelling of FD_SETBITMASK in FD_* macros
Date: Mon, 18 Aug 2025 14:49:02 +0200
Message-ID: <20250818124527.251631250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -128,7 +128,7 @@ typedef struct {
 		int __fd = (fd);					\
 		if (__fd >= 0)						\
 			__set->fds[__fd / FD_SETIDXMASK] &=		\
-				~(1U << (__fd & FX_SETBITMASK));	\
+				~(1U << (__fd & FD_SETBITMASK));	\
 	} while (0)
 
 #define FD_SET(fd, set) do {						\
@@ -145,7 +145,7 @@ typedef struct {
 		int __r = 0;						\
 		if (__fd >= 0)						\
 			__r = !!(__set->fds[__fd / FD_SETIDXMASK] &	\
-1U << (__fd & FD_SET_BITMASK));						\
+1U << (__fd & FD_SETBITMASK));						\
 		__r;							\
 	})
 


