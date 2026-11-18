Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047573;
	b=YCfJlPRiWSFM2Xf5bmzuihlLwiv8y3ULI22HaFN6GoiWXIb2bM/hEtypNYAm6KRAwLE8
	 rG6hBWi6Nffx+0JACfvy4hM+2GORNogJDEu/rXp79BkvGrQ37Isubb0ZzQgzfQhm2YPFY
	 AlSZT5Yu7H9L7YkHQhJAfBpx9B9SkRYmlIChiVDIjEF/pIXiHgDnHGKDEWYiQ6jGefU64
	 Q0HOTtDd1DS3WVKLs/m5fSrh1BMPPi/WiSimNu+XIpLqyvfM2w8VNfz8ZY203ipdh5TwO
	 vkIhsx3wTBKkJF2Xag7klg4o8BX9IGVCY89rDDRQVRhyED8386ByqvBaE3D6i4Sd96g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l2LYht9gpD+NefJUrGGL6vp5+jFF8g87gE1iQPK0miU=;
	b=3eqeGr0KYqggJpLIZa2U/WKuSmMOSgtGYj4ERS12UctPoSIQBvgpyntp880UpDNAoNfx
	 fUObJU2rSuX1M6JDPugnMN7PR1RxtpZ4oauvQ4O8QLI9TRrzG6aiY8Uj3vIg7PoeDsbxH
	 1pEYEXFfmbXSi0TPQaDc+MX9A689PWGUO73qoSjvGyOFx5ZavHGkruv90Ke2LQUuw/uLF
	 56pHL57Xd4g9AG3vNB6ppjNnAe0u6xtWIHFGMVArH7lAlCqz25xQa9kqcET3FgjzVih4G
	 xY66bX7aJK9Jn2HewXnlSJJ4ClmeYOHp/JVOppfFl7tljNsdGoKMMgdWkCgNaqmikuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gs4ZIhNy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B68B606A32C;
	Thu, 19 Nov 2026 00:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gs4ZIhNy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3061F000C6;
	Thu, 19 Nov 2026 00:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047573;
	bh=l2LYht9gpD+NefJUrGGL6vp5+jFF8g87gE1iQPK0miU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gs4ZIhNyZFuRTkbDzChj0QjhSo0k1Xu+2TiGsm1DJq3DpoNaHTRiCZ7XfvhOsGsjd
	 AeoI+3KlaFnTWZ0ig5bQzHMhB/rsnuCIOQ7GOgpEu4sRq8NLMNXhuFsK8kA9Mchu2C
	 /7Ijf6TKKloL8Muy/RUrNqXPyvk0amRRdG6WHvpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1646/2857] tools: linux/types.h: Add 128-bit integer types for arm64 UAPI structures
Date: Wed, 18 Nov 2026 15:44:40 +0100
Message-ID: <20261118150300.603745396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 051fdeaf26707..e039168de0e86 100644
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



