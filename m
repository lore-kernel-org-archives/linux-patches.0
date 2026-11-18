Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024547;
	b=WCR9T55UFA+qkbxE/UqouMGDpPoWHjyC74hHnxgXH9CDQqMjeTdDMXFqerlFeO+4z+IZ
	 cWrhSW1kB4hYRvuVwADKu5f3bKRRyKGg1hbsLujwSF8CzUC6TmOqrub5sqeMsv6m6bpMp
	 qHg4qN+wHWFQprkvUc+Cy18hdIHLn5b4mBGKvZGSHxT83PQjiyZVgWVI4fqHI2QbkgFnc
	 UjZgNu+ocZtfqpp8oaxilTS1XluA1WR8DyEWTDQE9KMAjMTvO50j3SaiSFhrJJIObJiKy
	 8NiXrdTERYNln5N+QCvkMPqlQ0lBBDlmOu5Ns0WwLSCLk1frRtUtE3X02C5fQL4/L3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1N2IsqsJbIxdnNHDehWFCA/R/Zvf7G0womBDACe6W3w=;
	b=OUWKOYKtEPvSb8h3J1p8ViAW2a89D6GcQvcZ3i+5dEV9IZqGQQw/KPy9dNe6pXiGt9dZ
	 UezCF2vOq3QcZ3BiGCStcWT5W+Jsh4xDe7QDgdD5pWtGjrmSZjefsSkFhYEpDTorY7Do9
	 32Vb9c5vTxq5p9NL4TM8J2N+D6Feoxj0K1Z5RnIhzY4m1BP8xPQo2nbBoo6DBBEB0czk0
	 DbPoqTlbh/l7IkwMkt8xdeia4TulgN7Jr9lsaJH2zhEpBRuqOv7r4ZC5Npo5EQmvXGKQ+
	 zkCjB8gQDMootkEaOS4B4Njr6UKD2IddJZA/Qr2V3SMyR5FCgPaQhIk/5dvxiNyFTTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MpEtpH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85361606A32C;
	Wed, 18 Nov 2026 17:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MpEtpH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF961F000C5;
	Wed, 18 Nov 2026 17:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024547;
	bh=1N2IsqsJbIxdnNHDehWFCA/R/Zvf7G0womBDACe6W3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0MpEtpH7obOd5PhFHjdferrZ9HDtLB9zc/9cimtrM4lShkNM7Krc09BSeyqXf38c0
	 2hpD5B2zoMF9DSjq7vx5foP9ObUDYb+DLHVE3I/v1C36Fg8tMaRNxHHxfgnZdDJWuG
	 pzIIxnAjpLYPCOgWvTSvCtcM9BgGVB5PFxrsK+R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0763/2151] tools/nolibc: fix FD_SET(), FD_CLR() and FD_ISSET() on 64-bit
Date: Wed, 18 Nov 2026 15:41:38 +0100
Message-ID: <20261118150149.827106753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 929ea5b3481fdbbb419f3986703280fb2b819504 ]

Since commit feaf75658783 ("nolibc: fix fd_set type"), an fd_set is an
array of unsigned long, but the FD_* macros still build their masks as
an int or an unsigned int: 1 << n in FD_SET(), 1U << n in FD_CLR() and
FD_ISSET(), where n is the fd modulo 64 on 64-bit architectures. So:

- FD_SET() of an fd with n == 31 sets the bits for n = 31-63, as
  1 << 31 is negative and gets sign-extended.
- For n >= 32 the shifts are undefined. x86-64, for instance, masks
  the shift count, so FD_SET(40) and FD_ISSET(40) use the bit of fd 8.
- FD_CLR() zero-extends ~(1U << n), so it also clears the bits for
  n = 32-63, whichever fd it is given.

select() on fd 40, for instance, fails with EBADF, or watches fd 8
instead if that one is open.

Build the masks from 1UL.

Fixes: feaf75658783 ("nolibc: fix fd_set type")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260925211600.119116-3-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/sys/select.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/include/nolibc/sys/select.h b/tools/include/nolibc/sys/select.h
index 2a5619c012779..d442aef54e574 100644
--- a/tools/include/nolibc/sys/select.h
+++ b/tools/include/nolibc/sys/select.h
@@ -26,7 +26,7 @@ typedef struct {
 		int __fd = (fd);					\
 		if (__fd >= 0)						\
 			__set->fds[__fd / FD_SETIDXMASK] &=		\
-				~(1U << (__fd & FD_SETBITMASK));	\
+				~(1UL << (__fd & FD_SETBITMASK));	\
 	} while (0)
 
 #define FD_SET(fd, set) do {						\
@@ -34,7 +34,7 @@ typedef struct {
 		int __fd = (fd);					\
 		if (__fd >= 0)						\
 			__set->fds[__fd / FD_SETIDXMASK] |=		\
-				1 << (__fd & FD_SETBITMASK);		\
+				1UL << (__fd & FD_SETBITMASK);		\
 	} while (0)
 
 #define FD_ISSET(fd, set) ({						\
@@ -43,7 +43,7 @@ typedef struct {
 		int __r = 0;						\
 		if (__fd >= 0)						\
 			__r = !!(__set->fds[__fd / FD_SETIDXMASK] &	\
-1U << (__fd & FD_SETBITMASK));						\
+1UL << (__fd & FD_SETBITMASK));						\
 		__r;							\
 	})
 
-- 
2.53.0



