Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024016;
	b=hDDTqX9EjVuqHl1Funzpn0TZHMv2MG6JOK98Wr3R/dzRQJU+ADZqc62x6DCgX2Ppzjqq
	 ffuYW00fOs7MaOpVpoyR56SCNRLX35ep+54vyxsBvP6iC3+ruUAiZRd1Zk+JdZCX0dSl4
	 73hVWthlyTjc8eEPPR+2yRKZGZ3asZVeg6yBCkYnIoC3M/w4CGI2VCkMdW7iMUGVz2Vn9
	 GqDTg7mMTH4yLV2eSSQGNEkKJKUEOlHHiqKpcyVv+Rh/HFlh09V5XbzewZVHMXLDysqLr
	 yuxa3JfxDzvcFZlOkiBonjj5hUdDoj6JxNT4V/cxVDBPFY/JtUE5XHCD9J44qtQZcHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JognOjbo91Qa3SwPx/Uhx1FeU33lmwOHPBeWVLyIUFY=;
	b=HMch5Xn2t9mRIw97y07sXTabehOqyM5fmg6fhBnmGibYAUnreM2uxqEZlya6wM7HDSB8
	 YpwLtzSD7L5UZ0KZbY2LIHJJO74UAy8gcNsBxcllLh5ph0b4mNP4+xckJXtBgaU7QTo72
	 Rr5AHgoTGrRtENHr/1j7U5godbkADTmhR69+TW9F+8ggPoFb5raloZHChR9HYnt3UsuXq
	 SONW7y55vaAvPTSHIwkJ0DQGJHr0Nqx01QMVL6UTz2unW3Vyztn5RMxAcoKZHI8L2JOuc
	 qdpU6fU4AnRu4S7E753m1qeh33RurUU1R6he5HiXFNCmPGxOePUswNMFiVbSFl+fUNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lhnxh3We;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940B4606A31C;
	Wed, 18 Nov 2026 17:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lhnxh3We
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E311F000C6;
	Wed, 18 Nov 2026 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024016;
	bh=JognOjbo91Qa3SwPx/Uhx1FeU33lmwOHPBeWVLyIUFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lhnxh3We/UxOfjtXQXZgIEGLFTq+HpzCybD3pbDVxwtjx0J6mAXFOdCpdVr/OZrqa
	 TedJQ5tzE7FBtUW1NuJbTSBRILSATq2bCxlYQqKI6ZK1M+o4IcxMYow6W/RPpxBVrX
	 hZT+18+TGP/ZhfjX95Ya+qp4fOewkDZ0tgrPAlDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0576/2151] perf libbfd: Fix the clang -Wthread-safety build failure
Date: Wed, 18 Nov 2026 15:38:31 +0100
Message-ID: <20261118150142.937995952@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c4c43343501bd9fc24ec501ecaf43b7ef2da44d2 ]

perf_bfd_lock() and perf_bfd_unlock() are the callbacks given to
bfd_thread_init(), so by design they acquire and release the lock on
libbfd's behalf and the lock state differs between entry and exit.
clang's thread safety analysis, which perf builds with as an error,
flags both:

  util/libbfd.c:56:1: error: mutex 'bfd_mutex' is still held at the end of function [-Werror,-Wthread-safety-analysis]
  util/libbfd.c:60:2: error: releasing mutex 'bfd_mutex' that was not held [-Werror,-Wthread-safety-analysis]

Mark both functions NO_THREAD_SAFETY_ANALYSIS so that libbfd.c compiles
with "make CC=clang BUILD_NONDISTRO=1".

Fixes: b72b8132d8fd2d6b ("perf libbfd: Ensure libbfd is initialized prior to use")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/libbfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index 6df72889e5075..6e00f9dab9ac4 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -39,13 +39,13 @@ struct a2l_data {
 	asymbol **syms;
 };
 
-static bool perf_bfd_lock(void *bfd_mutex)
+static bool perf_bfd_lock(void *bfd_mutex) NO_THREAD_SAFETY_ANALYSIS
 {
 	mutex_lock(bfd_mutex);
 	return true;
 }
 
-static bool perf_bfd_unlock(void *bfd_mutex)
+static bool perf_bfd_unlock(void *bfd_mutex) NO_THREAD_SAFETY_ANALYSIS
 {
 	mutex_unlock(bfd_mutex);
 	return true;
-- 
2.53.0



