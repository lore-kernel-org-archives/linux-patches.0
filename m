Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217409;
	b=lIVvJWRJ+L3bV0/eNJ1+YPiTri5wH10NEp8Xm0Fh6z2cUnAOTBtpUhEDvMYfkrr6EDFx
	 J7wJLNhnsO/scDnZEtOWnpP+kI2cOZkeLo7849XJys6CrTA568i0IEoWHicnC0IvsRaG1
	 bTtCwBT8H7LAUcQxgQ4niZM73l/rdomRUkLOD5e8yyDLNiFb2FUGMYpZ3ZbmeaQGnZy4q
	 zYz1moXVIE1Kx3HyRrnUxta5o8CEd7gZippDaImTFN7vALWbdTaRCCd10+MtrDm75ng3t
	 cCPDf8XpBSoutofrKpEfzwFCCaDHYIPOPmicbTo4ICggFKi1ZM++qU3IDJIAOlD/zVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9/r18T48ZxSDJGeQS0lLjJRJTZxJAo8EEvQT8ZQZ4oU=;
	b=ary7+VxeJfNUdQOHvKDz0JAbevdQDluNRcmyUC25R245gpgAuJKEXjnc2pl+XFd7EHGt
	 VJAYRr99tOkA+mgmnddJU0JCVZzp0OApDThQQNQ2MLmmnJHMlhaaU4kGoHC950TUTk9XE
	 XVXbOeq9Nml0fmQNaQri+ig0RtCrfmCYCL4t/6ejiswVnsoirrlxNkWRZKH45JnkND+nn
	 yxaXfLwj5z3CTqiKxokbyxYGL5AfO55PnLNdYeThyJzOIMFQTndzL2tXGEnwsmzdJjebM
	 cG+xPJds97UP/LoYoqcck9X686Ky1uV/FA4uEtbyV+K3UBrjDF5FyITvIAkeB2X+41g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyOAZt1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3488B606A31C;
	Wed, 28 Oct 2026 19:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyOAZt1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833681F01825;
	Wed, 28 Oct 2026 19:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217409;
	bh=9/r18T48ZxSDJGeQS0lLjJRJTZxJAo8EEvQT8ZQZ4oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyOAZt1agzkEY+RF63sdHzV+jfpebqtDZAEkFm/I/pG/K/xlp5Zls9dnCkdkdmM1e
	 dxFydt03aORgxI4MJ/4KX8WmwclhtD5/1UtGrdgCdDZdwJ/z0olkHKeb5wSECpqnRb
	 8zY9FBBYATwaj9Pnh7h5d/+G0RxMAl1NFeh3RSgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1887/1887] uapi: stddef.h: Fix header guard location
Date: Wed, 28 Oct 2026 18:06:23 +0100
Message-ID: <20261028170542.397077653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 531108ec5b5cd45ec6272a6115e73275baef7d22 ]

The #endif for the header guard wasn't at the end of the header. This
was harmless since the define that escaped was already testing for its
own redefinition. Regardless, move the #endif to the correct place.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and identifier expansion")
Link: https://lore.kernel.org/r/b1f5081e-339d-421d-81b2-cbb94e1f6f5f@p183
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/stddef.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index d9edecdf69701..f039ec8e5455d 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -51,8 +51,9 @@
 		struct { } __empty_ ## NAME; \
 		TYPE NAME[]; \
 	}
-#endif
 
 #ifndef __counted_by
 #define __counted_by(m)
 #endif
+
+#endif /* _UAPI_LINUX_STDDEF_H */
-- 
2.53.0



