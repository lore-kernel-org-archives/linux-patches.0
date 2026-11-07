Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064704;
	b=r2idS8aMwnEYZnw6G8vaiDcEWmk86a3O77tTsoFVjP3p0jHOEWHdcKIplQ5ITsgoQnBu
	 zcjmEp/PBKSD3VAVpl4GMBbHLL8e8EOT/pJaI0eAkUR9RFn+ie1IFyv7c+sBGSghHDG8P
	 1qceldEz92QryWL9hGsMMraOGrxEaYKpmTLFdvS9OUsGTgyEi+zGVHR5/HbPOM9s6qDN/
	 RE2bYCDHFTNmpE8NI5BfTSphsc4NfQWMxK9hrGdHRUHROhffCWnIed8hxoHg6Rj1xgG2q
	 5DE7C6pXAS2tT/MSk46v2g7gWLrvibgnvUggDCIN/PnHfF7zDEmJdS2avWG/hxFVu6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f/jULhVxc9YM1O8HfSEkacV8lDi3zzURNN3CXAZtlIE=;
	b=5XmOTBEVUt57vJEvyGPwf6pBaf5K4u8Ueo0T6/oEA3p6H6woToS/t9nabKPTMv9Sqcor
	 XKXv/x9iSXMCNwekP7q3scm2x+ONj8L7Yrug1VFOJSwU+Uxd+JOBxOE9poBit9jt2ZTd4
	 iQZE3kQbGSfaED6cl5X+Isms3ZaJvRKmW5rQpHTexZqnHR+klSJhTlwBCKxjugEDuMk1j
	 x4d4KC2PPEikQ/8diImCORr0WG0QJ3KGhpJyYSVaOyHJCziVyx0jB9kQauDMBzMDOiQ9Z
	 3LYJjtVSLWUFHSYf+Ws/uKTDlB1foroEwJe7G9dgLgnXdofOY6AmOdYHCzcVGLG2Mtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AuhIwDQQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6605606A335;
	Sat,  7 Nov 2026 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AuhIwDQQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591741F0089F;
	Sat,  7 Nov 2026 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064703;
	bh=f/jULhVxc9YM1O8HfSEkacV8lDi3zzURNN3CXAZtlIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AuhIwDQQwG+ZUUHAPL4PSG0RjXJdBq/zf0QosVZq1niYW5GcONjkyk6I9urN9C7Kw
	 U/p8Cdl3rYoQ59vXkhyyior8QYL0UbtvREHxc0te0JS9l2gzU41w2OpTJxRWBd/d6L
	 1JmBpGGR3oUwfLYlRAdSQtCyvEaDgotrdXszCDlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Qinxin Xia <xiaqinxin@huawei.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7.3 0691/1257] tools/dma: fix building from the top level with O=
Date: Sat,  7 Nov 2026 08:49:47 -0500
Message-ID: <20261107134958.349299756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 352665c55877368854f87724698dad0b453444eb ]

"make O=<dir> tools/dma" fails:

  Makefile:27: /tools/build/Makefile.include: No such file or directory

tools/Makefile clears srctree, and the dma Makefile only works it out
again when building_out_of_srctree is not set, which the top-level
Makefile sets for O= builds.

Also work out srctree when it is empty, as tools/bpf/Makefile does
since commit a89b2cbf71d64 ("tools, bpf: Fix build for 'make -s
tools/bpf O=<dir>'").

Fixes: f74ee32963f1b ("tools/dma: move dma_map_benchmark from selftests to tools/dma")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: Qinxin Xia <xiaqinxin@huawei.com>
Link: https://lore.kernel.org/r/20261011223358.2327625-4-sashal@kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/dma/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/dma/Makefile b/tools/dma/Makefile
index 0c239a6b9eae5..20ae7f09cd206 100644
--- a/tools/dma/Makefile
+++ b/tools/dma/Makefile
@@ -7,7 +7,13 @@ bindir ?= /usr/bin
 # isn't set and when invoked from selftests build, where srctree
 # is set to ".". building_out_of_srctree is undefined for in srctree
 # builds
+ifeq ($(srctree),)
+update_srctree := 1
+endif
 ifndef building_out_of_srctree
+update_srctree := 1
+endif
+ifeq ($(update_srctree),1)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
-- 
2.53.0



