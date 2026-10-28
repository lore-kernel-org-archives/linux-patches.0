Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210073;
	b=2idY2a0ufPCijGLHWspUNh/euZhbivu+JhtS+HufjzSOamlQ5RYaDcblJGRvZKfuqA9J
	 2id+qtkiPTiVwxApG3DfYh0EntMNj880lzgAzMsyfL/SfQ9vvuRCXWTnfkqax1EGWVXBj
	 BTFbyfn5Fp5qCwgeYzxMjpk+OU4un24+JnXpjmmHVpxJnjlLn30BjRfmP2YoI6r5vOFJC
	 /L4uonpNYYek0UQQpnVgd5a1NsqD473A0srS95c0ePPMeXyacmEIcBlUoVPptTzJ9Xu87
	 zS0FGZk1/05kkHdFZKydz2r8yQtKSY8d0e7m0HbwA9kdjMnv6I9D13t8j16kPJa/TEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ttQjy72C6DH9vV4FMNO1NDHh2qtbjy5eckRVpVA5h/Q=;
	b=xGavnbdzo088ikRF8JuSQmO6WS9x1wJt+rpZbSOA/KSkkjvzOlGIJC31ff9xl5DJHxBh
	 bFIDektI/RuLt1hQ7ZqtlhjusBMQMAaBsWILrZBeucdQjBgcSSRcZ9xwC9TbAGPCsfcHj
	 8CPjSIHZ7EaPeXCyviTCEhvv2SxXLb43n6KlNOsccaM92epCiYhIdk9B2ww5iiBX/Xw4n
	 fyTkHouiL6Fo3fpNZvvV4h5u7pMFT/E/JhwvJyb2+t2hxyDqoMKbC7rxQ7LEi23zGaRPh
	 KWUQb8yq508TxLRs46p5n787EezPJgDz4hcmcgtpZugIyJ1mx7KLtGpvhMOYOguGUZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M90+zvTi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEE4606A31C;
	Wed, 28 Oct 2026 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M90+zvTi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4311F01825;
	Wed, 28 Oct 2026 17:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210073;
	bh=ttQjy72C6DH9vV4FMNO1NDHh2qtbjy5eckRVpVA5h/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M90+zvTiShrxBp94vUIGvKJ6tRKrd2YJ5tdhIwbXTRsjPj/SzOiZefN1jHBHViInj
	 AOH66GJ9knYR+gqp3hsmWS69EyyheGXwmUhky31+jhDa5YmIoQAVCXLWldfpmvsGRN
	 mm9lUa/DPh8v0tTADb/0+tqiLLTBTRkBoFLBSl8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 050/168] tools: gpio: fix building from the top level with O=
Date: Wed, 28 Oct 2026 17:59:46 +0100
Message-ID: <20261028165944.274034481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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


