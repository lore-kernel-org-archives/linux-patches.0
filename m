Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028575;
	b=5gqSXruzDNQhfg3G7+jryJKMRYxgufvvAXBiKTAHu2x0yi5WowbPTHfSbOvsslNjTend
	 xvKGEOCZG5GVdpE4IgDANi/TugWdhot8HZy1qg1dvLDPaZx0WzIU0ZBN25Lbi6uhln9Tl
	 bz8YO+tqi7gnQDdug6zygMK3UCpIk2Qr6/RNfaVsTnxMpf8aDHdnjyh8AGm8hQzZcVwlN
	 grGl7h7auHU/kIjuq1DMQmbJT9ovK19Hs58YmcUUPryUFrc/0WWCcQ6IBVNUsPKRPzIYZ
	 S23LOkhIhrqO3Oft9dPSuCxBNSskrKfYqcSJbR1yjPUr/AGXuJvABkalkzMGxplNk+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8++aYmaHLWRijPgVur/HhgPqN/PYQv8lDgjPoLlSmOA=;
	b=PXc/NlHrP0X57zkAJXloyUsCTatq7XgNExyO4ph+s7zOBueIEddgwDNaOOIktO4qmXuV
	 9z8k/JClsau04HL28+swMAH4suSCWmBrKKwGZJ4Acidm2d+8lFnlLapQRBYRHeBPxswT4
	 ocyEKWyXF3CZddVWjTBiYaGqc6/2szWbiqs4DGQp4cf2AJWypDNO7LV851xN8DLZzyPaE
	 1jIDWKyor5nOb6rCUAvEO3s3z1LW4mi/nCXBYVQsZzuNXSDjrSrQjTrT7ESH/V//UNQlg
	 x9oh91KLFI6iFOQQy4S9DyQ4g71tcwdi1A7swjikAVAta5Ts3tvTHUBRCcw6Se4sAXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0mz/PGm3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75865606A320;
	Wed, 18 Nov 2026 19:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mz/PGm3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57FF1F000C4;
	Wed, 18 Nov 2026 19:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028575;
	bh=8++aYmaHLWRijPgVur/HhgPqN/PYQv8lDgjPoLlSmOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mz/PGm3g8+vvqy7RwFyvUz2Us6nn0yLALOv8KwJM5uWx/AoW9vHzMlVYJhxe4TCz
	 V19uBNntVzS/b5bfameBWUcmjpuzik9pQaqBEEyRE9rAxBJxCFsalq8X6R3g1ieXSN
	 4AId1Gf/rRrl0DannXg9I3Q6o2Er2J1obrGf/Unc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0044/1756] tools: linux/types.h: Add 128-bit integer types for arm64 UAPI structures
Date: Wed, 18 Nov 2026 15:36:11 +0100
Message-ID: <20261118150009.774314527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



