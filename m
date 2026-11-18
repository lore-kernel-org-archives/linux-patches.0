Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060027;
	b=E0XbARp6P3n3FqpZ95UF54em1c6uyTr1YBXIFH80TWUekxPGktlZdLpb6Cp4uL6Hslyx
	 UT3AUAc06w07yXawIQazkUHvcrX10zBUPauJqea/4A5Ts4iUal6BDEAjD5o5prEqkqOs1
	 bV5zoM+kQyMQckSrwGyxcxqe24WYbHE2q9XPXiB6nged5fZwdOTTOuonHLvm3XPYt0SDG
	 TW3Do0RJYf5HH0QexO1zxYYIYS/Xiv3OWiSoiSf3r25MJS+iGFmYDKpcvRdXtvvlsX1yi
	 X0HEOvsg5WYfgj83frBM2fYIbw8zmEKUlHGqjxIZoUmqokxAX+6o9eJtjwzOdj3HyXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ej2jt2Iz8aPogC0dQze7dRBi4UriDFLoZ7KGE6wJXzo=;
	b=zqO8ZVFtqbyTXe1ed26X9OTY4Q19glAGqpYdSkESsZHeJBe1AevPJX9N3MbrO0rjPlUD
	 8fjpHOV1jy5OKv0HHHnmztr0QrEyNyL2rpQky1LDC6h/cO3m6IUGjsZAuRmYUk640Q1PT
	 4FFD86sCOHHbTwkJH1ygNaufgk2GovSuS+KiIWvBUGEGCKtPjUbF4kM4vx+TJrMfMuE80
	 TwFES6hb2Q/AbcTFDyrDoO6ZDpjyzAbsLNB31DDbOOm4osMKyT0Qt/ovskeJ47Dt0mvz9
	 6Vgq6Ou1wDBae7UCn64IBuIofVAukE6e/P5NBolqWiQOCYA+CB/4LTetNZG1DNLXFfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QCpsu1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C126C606A32C;
	Thu, 19 Nov 2026 03:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QCpsu1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E3E1F000C4;
	Thu, 19 Nov 2026 03:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060027;
	bh=Ej2jt2Iz8aPogC0dQze7dRBi4UriDFLoZ7KGE6wJXzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QCpsu1bxZrLPCcoGd7ZBQ8NGyGzinmllnm3rBEe5Gur0UzzrMdQyrqpfpKTXWS8I
	 8P3tcfWJpCmYMCl/bX4rvAR1Dff6yHPsDQlx+y2eyeAETJn3Iy7WHUy3EX3dxkLUxA
	 YIxAJpDqzoZSigRFWQS9Xf8QD6PuUYiBENb8cuqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1051/1848] tools: linux/types.h: Add 128-bit integer types for arm64 UAPI structures
Date: Wed, 18 Nov 2026 15:51:29 +0100
Message-ID: <20261118150001.301377333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 154eb4e3ca7c2..7f58e43727fcd 100644
--- a/tools/include/linux/types.h
+++ b/tools/include/linux/types.h
@@ -20,6 +20,11 @@ typedef enum {
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



