Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFB831B13A;
	Mon, 18 Aug 2025 13:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522786; cv=none; b=Dm/i3jewk2NbmcVvgPB/Aq+ImvL+QRoDlidm8KgZ70Twix551CDM+4A8urcMjkSNwXMcQFY25QXdYfdNuNDgSPuRZFrIyefPNkzqx2/ZngiT0zkWEC+mj4nrzUfQkG7FVfFNrZEG7ftJD3I2gkmSeB3rgNRVtE6mODNMeEMt0Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522786; c=relaxed/simple;
	bh=gfOWD9TvwJrxVZ3G+uN8qSIiGNnrWeeV0P8sDaWgfag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ck/ri4tG9/CDU8FGyVY6+bRVkBL8uc/+gYev3EUanV1G+Z9ADA3Dl8HKb7OzedyoY8qpUo0tljL15k1A+1kgqIifXqW9v8ja0sa4Pe9T4pZL4BjtzKKrq+4RszLn+ImwYcfUMX7aoJ3PqXcw9+xskoIwK5blEow41vRYaruAPik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDPMKs3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDPMKs3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2924EC4CEEB;
	Mon, 18 Aug 2025 13:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522785;
	bh=gfOWD9TvwJrxVZ3G+uN8qSIiGNnrWeeV0P8sDaWgfag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDPMKs3BcFCNVAXSK0ITJJyDYJVqr8MGqD+l1ubsDp/IKf/41eIyfRtSWRjfcpQXg
	 3wiOl8wJMZCG3BYhk1zYz+7EeFlbUzmALeqLXrNxZy0vLxkie7UhwUTcoiVWhIKNKB
	 PU73yMJDl14mHoPsmp8tNsqEmeN6eeMtnUNjr6iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: [PATCH 6.12 420/444] tools/nolibc: fix spelling of FD_SETBITMASK in FD_* macros
Date: Mon, 18 Aug 2025 14:47:26 +0200
Message-ID: <20250818124504.689750224@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


