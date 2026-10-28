Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207611;
	b=40RDwOxVZWrtvpzBnBJ2pXGHN4epTmFe5Qr/TCtrfIbGuuQUdC6PYEQvysdYUueU4lD6
	 pqiY5uMl5ZWZoQ/X2eLQJoxNm/FIdmHlVlWUhBXH3MLpiBCfe68ljRi5E47haKKOfFj9x
	 kOcttYre+gaQzSPTt1UBjTA1sKWzRVjBNLlE2JZuIsvyMCMmfINET8IBWsVOrtwCDVG0b
	 s6Z0wAX/e371UvotyflGwhsAORclX8B0LKllq93+4ld7rOGIrbKTmpImXf2Z6RGV0EJRy
	 0/vxx0eecni6kRm3B248SUlUDCJYw8JiAUH8M1lZRH96av8eRvsFOcz8VPe+WiIhRwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zdnrZoR5saUGSWKk+sP5+VMr3LC3vB3oSSMHeSOWcHw=;
	b=1Y9eNc+OzjuCOT3OJlESZZvrFJFIUk3eIO7l9xGrxHa0WFnR5qJPsEmKL0NeAKeDITxy
	 voJ5fzTs2hdcdX87LAfoEEo4vOlvmyv1JAvWJCggbbT1k5cThq1uNjuhuiFQX/roSnwPa
	 CLfOFy0Qr2npU/xruXLCkz0QrZhTpX4Hn85BDwCZIYyAG3rw5o6aSjzOFneE6MmUhLJ1k
	 ZJfzFjG0aMRxyt5R7AYDB8bPacbFKvdJyuWpgo34fwqhU+wdnQpR41tMaBog1mSfzd682
	 aeR4eHRXNNcELlJSSEeZwVJlybHdJEn5jIaaR1lc+diLOhrkMM7TlD8Xw2TwZ+TToyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZeeNq489;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343AF606A325;
	Wed, 28 Oct 2026 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZeeNq489
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF2C1F01825;
	Wed, 28 Oct 2026 17:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207610;
	bh=zdnrZoR5saUGSWKk+sP5+VMr3LC3vB3oSSMHeSOWcHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZeeNq489y7J1UZA4USjuGhIMZGUI3M41IHhe2CWy1M8GMA5Joz0Tq73LSwP6VDasf
	 uJLzGNgUTu4h17ciuJ2BVFPa/D2r6lZP21XTQfVWI3GY4j/Z8REtQ8WTN/MnEhQ0Ob
	 6h2VmTBxg/liMP3LhJ/53n0WFdW53iiA9M2oNKdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 075/247] tools: gpio: fix building from the top level with O=
Date: Wed, 28 Oct 2026 17:57:58 +0100
Message-ID: <20261028165949.168795196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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


