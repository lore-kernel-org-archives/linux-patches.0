Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774009;
	b=z2tllyWmzG7WhvfJZmzLcALiX9Vt4s+KARSKORPhrNa1ewnJKpQkQl0RycbKYdHb+XG0
	 s2way641CM47p5m55IARCQ470+z2a9bF89YEuulK0f5NrMV/9JENQHKCb0X7G2S2oiU5u
	 AtY27CFk3eFHF4JJc/SPCmi1tFsukUwYCgukpukQKt1XL+KD+kk+1JCrFxstHQzDKOmIm
	 Gu1R3qiDiKlDGQHyABVQY1pa+aeknm/N+zGXippQD9cw6EEJDujEShvfUvCxmdPXzWxsy
	 LekQp6EO6+PcYw9jR5Th/D2KjwHn+wQq8p3kbiFd59HRvz/zt0Exfd1lMdNNT3mlvyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4GEFRsVdobVQ90nJOx9IbJEBWyxvm+WFoPO7q8wt4ZU=;
	b=quz+d/PdJCV64zrXiQcIn6b0wJCReWhVxMAY7fPWM23htfiYynomKT5WW+d24icnkb33
	 lQ8d7NMxzFUAVmUY77F6vb/QZeH5HWuYOBNdkDQJrmN595gGNLKxtnDMFpua7t54lXvh8
	 CMLc5uwOI9MR6emWTwhTrfFUPid49EN215keAdqDLTTQ89SvzMxWDY0zPV0TvQZaL2a6N
	 7gTqOHY4+pMYeluVCmNzZXh6yVP2tZ2UmFLfHkfwuL4jIQMnrRXhE9izDlY/cUBlztYwH
	 FP7ut8Qb7phFSUxbPvELXXchfBcNRCy9+yYuhwTTu0OK/rF0f+mxlE5OC2fGpjtjYHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMb7oS3t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FD3606A31F;
	Fri, 23 Oct 2026 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMb7oS3t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A0F1F031E5;
	Fri, 23 Oct 2026 16:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774008;
	bh=4GEFRsVdobVQ90nJOx9IbJEBWyxvm+WFoPO7q8wt4ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMb7oS3t8Qpot/61YzLZ7WabMEfjH23gj3JbTY2bizbN22SDfrGT/hQWfDhh/G/Xv
	 F63OwtcK3nAiDLybRQStyN3uSrQjw2fhlk5EACLlv7se28A9xwW4nZ0Tig82uAv6km
	 dH4SbGUSTq7Ok7VM7qMAMnoKkHMGkBb926VOA/kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 089/193] tools: gpio: fix building from the top level with O=
Date: Fri, 23 Oct 2026 18:36:06 +0200
Message-ID: <20261023163716.312923883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Sasha Levin <sashal@kernel.org>

commit 52336337f1a01ad803c7f3ddb23f40222e9ad58d upstream.

"make O=<dir> tools/gpio" fails:

  Makefile:27: /tools/build/Makefile.include: No such file or directory

tools/Makefile clears srctree, and the gpio Makefile only works it out
again when building_out_of_srctree is not set, which the top-level
Makefile sets for O= builds.

Also work out srctree when it is empty, as tools/bpf/Makefile does
since commit a89b2cbf71d64 ("tools, bpf: Fix build for 'make -s
tools/bpf O=<dir>'").

Fixes: 4a6a6f5c4aeed ("tools: gpio: Use !building_out_of_srctree to determine srctree")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261011223358.2327625-5-sashal@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/gpio/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
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


