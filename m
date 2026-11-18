Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016765;
	b=YpRgxgHJVCkZ7nPkFxAMeZ2EEqsOJayh3slTZiCgDocE6Ju9EakZnXuuW029hLzLHnIY
	 1cjMl9MZE5zEdu0Y3Eic/br6ddhV8c/zXVjbFZ4m3u4n33RdbIk479aACkhNj5sHWInIz
	 7bNtCzSVf3PMAmJNexjeZhzPXbCTrrH9zfx8bJ+ZnnpvRhYU4YTrx0Ttb9knvBecDQ8Wy
	 E8YbfgEWvTsEtxs8yUzZ5aHmJ1f8/J8hn1vC7refzFRQnsiIv91Hbtf4SB20UDPji9LX2
	 vyx5wnLh8rqcWcGz5SByMs1/WCwooi4t2AHlyCzNVpXbxL/Ogo0uoZ59eL+V3zwHvKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QW9bPK24Tq0138aC5Dzkodg67pnNXbsa/GY1BRXoE30=;
	b=iKgqMwgR/wIb7eG+iemUCCMZb493kbMHOHAohFtDPvo0S/LQfSq/FXgaedfLUnSIFcvd
	 zXC6enqG+tLwdWWUcoZkCxwgJsQJNqKQ+bze5b8Pbi/kQNRYI2bTIvNj1gMpVJsi2HR0R
	 h4n6GwBFPztISp5NLKqx9ziKs95xQLU71mT9Gd0w+FMfKUh5DCDsxWaBQ4vOSBRveT5EY
	 CdBZA6yshvoJ0u4Wjj+J+uT/kR5RtUXgiwoS++Ja+fMt64ezJHUZ8Uu0A/xDZ2gt4EZWQ
	 DOTD/wqvSQnPo3MS9oWDyL01bOBwF2fqeTnfv8icMf3jsBhGAqihkfl8LKdenF9f1iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SK0WE1jv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AE2606A325;
	Wed, 18 Nov 2026 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SK0WE1jv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4651F000C4;
	Wed, 18 Nov 2026 15:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016765;
	bh=QW9bPK24Tq0138aC5Dzkodg67pnNXbsa/GY1BRXoE30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SK0WE1jvUN/Ha9HA6XYFZLb6t3d0FC60McRF/a+eYQ8sGuubLROdY4rdMZctXCIe4
	 0RFreD6rC7RXyVS+K164KM2avopRE8MoMI14MKYYr335lss8IAgHbs41ruxeWHXI8c
	 0VfusLPZjFpEfIpAJBf+yBc04hrlil3q99Lrmluw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0643/2651] perf build: Use the given CC rather than clang in clang builds
Date: Wed, 18 Nov 2026 15:31:23 +0100
Message-ID: <20261118150310.830397161@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit bd874cd8356166d8fb262d32f368c0e460910d5d ]

The clang block is entered when CC_NO_CLANG has determined that CC is
clang, but it then ignores CC and hard codes $(CLANG), which defaults to
plain "clang". Building with a versioned compiler silently switches
compiler:

  $ make CC=clang-19		# actually builds with "clang"

Worse, the target triple is probed with $(CLANG) too, so on a machine
that only has versioned binaries installed the probe produces nothing
and the build stops:

  $ make CC=clang-19
  *** Specify CROSS_COMPILE or add CLANG_TARGET_FLAGS for x86_64

Use $(CC) in both places. Within the block CC is known to be clang, and
for "make LLVM=1" CC is already $(CLANG), so nothing changes there.

$(CLANG) is left as it is for BPF skeletons, as bpf_skel.mak builds
those with "$(CLANG) --target=bpf" whatever CC happens to be.

Fixes: 4772e66cb45e0dd2 ("perf build: Support build with clang")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 3f84e6548c0f5..b2be632e8cf20 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -38,7 +38,7 @@ ifeq ($(CC_NO_CLANG), 0)
 
   # Default to host architecture if ARCH is not explicitly given.
   ifeq ($(ARCH), $(HOSTARCH))
-    CLANG_TARGET_FLAGS := $(shell $(CLANG) -print-target-triple)
+    CLANG_TARGET_FLAGS := $(shell $(CC) -print-target-triple)
   else
     CLANG_TARGET_FLAGS := $(CLANG_TARGET_FLAGS_$(ARCH))
   endif
@@ -53,7 +53,7 @@ ifeq ($(CC_NO_CLANG), 0)
     CLANG_FLAGS += --target=$(notdir $(CROSS_COMPILE:%-=%))
   endif # CROSS_COMPILE
 
-  CC := $(CLANG) $(CLANG_FLAGS) -fintegrated-as
+  CC := $(CC) $(CLANG_FLAGS) -fintegrated-as
 
   # CC being clang says nothing about CXX: "make LLVM=1" overrides both, but
   # "make CC=clang" leaves CXX as g++. Probe CXX the way Makefile.include
-- 
2.53.0



