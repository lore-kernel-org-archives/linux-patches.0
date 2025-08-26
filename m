Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644FA1A8F84;
	Tue, 26 Aug 2025 13:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213378; cv=none; b=aEkwGA4dO3UsOBHgVcJi4lKLJvNg5FStYg8GhFLLamx3W/dBCE/6kFZIPzsD8G4euKeA6kPy2ORiszt8LNr/yFYJqxaggcGH1kWoLix+Ijd+TlJMNbtSYFaT4zzJJwWx/6nWjpxEipPQ0LZ3jLWk1bcyEIwh5E+rrMKGjT5OfFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213378; c=relaxed/simple;
	bh=e//mKeeXZ9E7TrBks+96fAO+9//IayJM5rRfXbBsGco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nFDBlPQ4GreQXmbdCxerFiMDmNgZk6boiVuuyZjcRL9j8yKTYnXONxvl5+lhdgVLhTmmt2JHvOmFCNE79XI/eBpcpoPhuPAuHZfAuAZ0i8KFrRENUhPxSw1glIqIe/hbxJYwKbbi+ujcJCxS1zLNtOERqYCtR3IttiIWOfB8Eus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo57DXqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo57DXqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C16EC4CEF1;
	Tue, 26 Aug 2025 13:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213377;
	bh=e//mKeeXZ9E7TrBks+96fAO+9//IayJM5rRfXbBsGco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo57DXqcOpABbbHOBve0MnNtOBvj5YXDUUpO31MYaQfmXY5qlXU9x+25mvt5sRZiQ
	 LKmtQSqSPXUI9nT7Pjk4Fq9nayDL8WcGlS94v2Hj9Is8q4j9f+pAOVWxZPY0VLkFyP
	 ZYDN3kxDXtYF6bHfFLdNy1r8q7fM33Y53zUMvkus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: [PATCH 6.6 324/587] tools/nolibc: fix spelling of FD_SETBITMASK in FD_* macros
Date: Tue, 26 Aug 2025 13:07:53 +0200
Message-ID: <20250826111001.159904618@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


