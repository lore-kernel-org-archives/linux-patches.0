Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038879;
	b=G7YD8ffLQZvTONueU4TyXcEBMP0vlhwX9ovtq4MhablijQtoy9hsaVgw7DhvaJe+eDZN
	 pPXARGcbS/f5HngGzXFNviIJdCTMhY9XfLTWa0gdb2zEC7W2V/rH/deUZ+TiwJFv2vFwm
	 tSzeqP5G+QC1R5Wr59NAEOMGPWsIlS/I4yz0URqKbxgU9M0yvk7qw6cCzlgMxUFUWhuO9
	 A9qfeqmiOAJpPaBSjrtGkyJNNuJIqJNIgsYqNAszpIG86ENuwy3CpQoWmj6ys/kxGiOjo
	 8670CrLggAe8BbbtbwaWnLWGG1PlCbnPyihaYHHkK007if5CcuiKjMMjHwG/XA3WGiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wzvBg53CAGm0yrPB9dUqtuFv/yHR16+DnyuWWH9J0ds=;
	b=QpdtrG3QeBy1YAkkIb9XhgRDz6IiOT+uLL4AWwj1EVG9qlh7aNQDsKRWSu9sIcR7ylfL
	 lI2W5X/TkamC5H9jhVwsowjlg/gZ7Lcgx7UJtevlB3VDtw2O8h7LznoT7efJDE1BqP1uf
	 QCp3OAe9jTtDEH/k+vz3/iRDzW7Yg75eLIMos8a4uzh5JNvb8Y1ujyFzzVfJShFnXSeoN
	 /shhqQrp3z1RaBUavOyVOvp8lM9zoyzmLSVxGN5w+U6OcmKJLCR5E+rI/2sB3o70lYJ7J
	 bueqc3pcaoWBVI+AgHlG3VOg+wHkxB1MSdVU4CWbnyyffdEV/N0Q8AkPWxf9nglUAHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qScGJNAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E7606A31C;
	Wed, 18 Nov 2026 21:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qScGJNAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB87F1F000C4;
	Wed, 18 Nov 2026 21:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038879;
	bh=wzvBg53CAGm0yrPB9dUqtuFv/yHR16+DnyuWWH9J0ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qScGJNAjllUi3RENB5AoHVJGXygyFiPEkbZBTwnKvhhKI8oBedat+0E099nE5y5Ou
	 34eYY9t7KAVe6fiqsVTCorcY3+5jw6MrdOvWw9SLi/9/gvxeWjbmjQed4dtRtSGlgU
	 8rqZa1meFJZdcTy62mfCmCIh2eR4nMZ1xGNOAsfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1900/3318] tools: linux/types.h: Add 128-bit integer types for arm64 UAPI structures
Date: Wed, 18 Nov 2026 15:42:02 +0100
Message-ID: <20261118150419.010813407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[ Upstream commit 10a47fb67340bca274276faf855d7d460afd9a7a ]

The arm64 UAPI exposes some 128-bit integer types to represent things
such as fpsimd registers in the sigcontext. In preparation for defining
these using the '__u128' typedef implemented by uapi/linux/types.h, copy
that typedef over to the private linux/types.h header used by the tools
directory.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
index 8519386acd239..432b28f77ae2c 100644
--- a/tools/include/linux/types.h
+++ b/tools/include/linux/types.h
@@ -23,6 +23,11 @@ typedef enum {
 	__GFP_HIGH
 } gfp_t;
 
+#ifdef __SIZEOF_INT128__
+typedef __signed__ __int128 __s128 __attribute__((aligned(16)));
+typedef unsigned __int128 __u128 __attribute__((aligned(16)));
+#endif
+
 /*
  * We define u64 as uint64_t for every architecture
  * so that we can print it with "%"PRIx64 without getting warnings.
-- 
2.53.0



