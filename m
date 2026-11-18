Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017474;
	b=4fNqbUKPXhlIXyomED7pwi8cM4HyieFiTtdz1fleLE2dOX9I2r/PYPcXKU6dCtXtiWfm
	 WNRoN5j2LTyZwua0WgebDx+7g2AqE9Ee0FgL+KSkmOGQ1I9abUJkyRo9SVDij7OHgqO/k
	 OkiJ+xEghnSFcYCa3m2cIEiMTzDlucbdK02yIbBaCadtgqOuV15tsM6bOqX1vPLwJodq0
	 CaUkOkKsPjonAupPI62he1umG07SDGg3FXafpp9Bsd7UIeDNWmmhtH+NLZzyIk0B+CTmC
	 8ENVATBy4pEsPwOdA8w3ICC1RMAdudA38SIqW6QJe9rihzPDtQdnnd4OWw5Suef8u4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3RNaTTysqExztZmjbE1Vst3y9sa8tjVzpGrnKPQnImA=;
	b=LWNXowiWpqKSDV8E7mH3yOlq9FtcT8GTiK59ngUEC4gnn515OWk7AIccz+EUpVwJdAt4
	 bq9UIpkokSlc/8iGcnOwq1ZkB5pqFpFH133+qYHnfPwgfHPLLYBzmuTkc8RkmZiwkeoe3
	 NCDtWjWtL9NmAzod4U0GHWzWFdZGBL82OWUQbNW+wLyxi10vxCstFLcsRHJfVAi8mefRR
	 y0JA4ew1Ltp5HZ8cFEMslGwQsUYU7yfkgkRYb1rKyby40k9afoB1UZ41yWdfX+NfkS4UQ
	 cekw5QsHf21QoIuW8o1DuTaeXTQfFZboiurgU6qmE9aFKHS99D6lLs9awODGHTgNOcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWJ8GyiW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F84E606A320;
	Wed, 18 Nov 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWJ8GyiW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E116D1F000C4;
	Wed, 18 Nov 2026 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017474;
	bh=3RNaTTysqExztZmjbE1Vst3y9sa8tjVzpGrnKPQnImA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWJ8GyiW0vjdRqeAR1VsvjgwaSh2dWhkc3NaXaRrV4Qn2jTlmqAVqITYi/FHkoC/f
	 c980malAh8PJwVXTDDQd1pZ52/k/CYJqRJ3z8umAtzARNAfNcHEvQyX3AbIj1yN8x3
	 3sdQH2iOo2UmzzWnhlF82DpJL1zGIqqIgrm+lNuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0896/2651] tools/nolibc: fix FD_SET(), FD_CLR() and FD_ISSET() on 64-bit
Date: Wed, 18 Nov 2026 15:35:36 +0100
Message-ID: <20261118150320.122570238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6d65d9ef3d6af..f299c79939f59 100644
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



