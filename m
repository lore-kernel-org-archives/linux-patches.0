Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D0B1DE4CD;
	Tue, 26 Aug 2025 13:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214772; cv=none; b=iZ3juGH1Sfir6KjizKoK1iFp7c/+OxUs1X+/Sz9/3kPUI8/n5Dg5IekHiU+xeKj0QVjcFF5qyla2IxgH9jmkgfhl1XCLM92wrOyS5/SzvbziuGmv6ZuzNwHPA1aF2Nrfr09npnTnV9X0ZWZayO7H/LBKBCljaMHwn/d3V4vrbAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214772; c=relaxed/simple;
	bh=zy7d+9vG6PGoTQV8uoOOBR5cyA0gRqGcdL8/Vyw1qQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nLM92GEeRlFUdlQYICUELKMDco5nrreahpr/LvUJHEex6AYjtC/tLJBG2z9ndojUpX8k2uQWBk3N36Hpp2MB1slgLkh9gwiG38+ZM1FVelf+glmAcD/Qf8Skv51blb5ZxH5iNTVqn6FPbwW7zg4iEzdW4oFJNq58DLhf9aqUiEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWzud7WM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWzud7WM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC598C4CEF1;
	Tue, 26 Aug 2025 13:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214772;
	bh=zy7d+9vG6PGoTQV8uoOOBR5cyA0gRqGcdL8/Vyw1qQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWzud7WMoVxdz3fxEaWhg2OLMNaqc9tQPzhoE5Y/LgmiVm7Dgaj6q1wWlBUZuwkgJ
	 d/03kbggI7/1dVLGSMkV8CCw+pL5OmvhiBHj196hodnE3E5W/stST6OKP2vKc3uqc7
	 QBexCbAs5De12GENlbnDmbT5IQEirraDu6jwD+gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: [PATCH 6.1 264/482] tools/nolibc: fix spelling of FD_SETBITMASK in FD_* macros
Date: Tue, 26 Aug 2025 13:08:37 +0200
Message-ID: <20250826110937.289199807@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -102,7 +102,7 @@ typedef struct {
 		int __fd = (fd);					\
 		if (__fd >= 0)						\
 			__set->fds[__fd / FD_SETIDXMASK] &=		\
-				~(1U << (__fd & FX_SETBITMASK));	\
+				~(1U << (__fd & FD_SETBITMASK));	\
 	} while (0)
 
 #define FD_SET(fd, set) do {						\
@@ -119,7 +119,7 @@ typedef struct {
 		int __r = 0;						\
 		if (__fd >= 0)						\
 			__r = !!(__set->fds[__fd / FD_SETIDXMASK] &	\
-1U << (__fd & FD_SET_BITMASK));						\
+1U << (__fd & FD_SETBITMASK));						\
 		__r;							\
 	})
 


