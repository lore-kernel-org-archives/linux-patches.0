Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753AF560AB3;
	Wed,  9 Sep 2026 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961999; cv=none; b=I1NObr+6dNA4lCbAB6mqg/pX5gQ1HIjzQxzXxRHt+T14Hm+syL/WeZNJH8UTTKFGMU+bNAa7lvBldr/iLZYrPwNQoQxAw60VDU3Gh08YmEzHkhKVLKi+SIg5GsHYA2pjZg6is4E1nfRszZtiGLUPNbAH21lhgKhDDXWz1OMpfRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961999; c=relaxed/simple;
	bh=sQ4twYFlymceOFIpmNYD1IGQ9kXuyjDdB3yrdlb0ZJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCdTmAeZ1Df+gN0ostC9sm3ZiCL8Kc+JOJAOcGiCua0ZlLybHG8CRvQMfhrEOEh5/Pk9wP3MVM/2rk6J7M9hDRtSZs6Sxkeqf5mqB3QUx9s7tefzwM9akTPaxdRfFn7Ub2bZQu2Qlh3KI0X5w9t+vKCj3nh7ShjxJImquoLnQzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHtwiEio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHtwiEio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCF91F00A3A;
	Wed,  9 Sep 2026 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961998;
	bh=qkuXpAhPwbKHUvJ/qpBbuVsCZamUYQdeKhgKB1DQexc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHtwiEioSg3o60Ate3MkTZN7LBdmTtfVsPwYzvTUFfw7fJgSHxH8XRl1GEoCAyt5j
	 V0qi4TbtlmlVjrdAP89foojwTPzHPTuVJv8mNE4CHCZbv2bEj99QOTK+ZgeEYt/oZt
	 yG1DKk2UNlsRAGMhtWiC9AZcgL/OfDgO6qdjvGqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	WANG Rui <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 139/556] perf build: Add clang and rust target flags for LoongArch
Date: Wed,  9 Sep 2026 15:36:59 +0200
Message-ID: <20260909134235.341016289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyong Sun <sunhaiyong@loongson.cn>

commit a2628ce4ddb6873e35380a42396d17a66e704a1a upstream.

Add missing CLANG_TARGET_FLAGS_loongarch and RUST_TARGET_FLAGS_loongarch
so that perf can be built with clang and enable rust cross compilation.

Cc: stable@vger.kernel.org
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Dmitrii Dolgov <9erthalion6@gmail.com>
Signed-off-by: Haiyong Sun <sunhaiyong@loongson.cn>
Signed-off-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Makefile.config |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -27,6 +27,7 @@ CFLAGS += -fno-strict-aliasing
 ifeq ($(CC_NO_CLANG), 0)
   CLANG_TARGET_FLAGS_arm	:= arm-linux-gnueabi
   CLANG_TARGET_FLAGS_arm64	:= aarch64-linux-gnu
+  CLANG_TARGET_FLAGS_loongarch	:= loongarch64-linux-gnu
   CLANG_TARGET_FLAGS_m68k	:= m68k-linux-gnu
   CLANG_TARGET_FLAGS_mips	:= mipsel-linux-gnu
   CLANG_TARGET_FLAGS_powerpc	:= powerpc64le-linux-gnu
@@ -1142,6 +1143,7 @@ ifndef NO_RUST
   ifneq ($(CROSS_COMPILE),)
     RUST_TARGET_FLAGS_arm	:= arm-unknown-linux-gnueabi
     RUST_TARGET_FLAGS_arm64	:= aarch64-unknown-linux-gnu
+    RUST_TARGET_FLAGS_loongarch	:= loongarch64-unknown-linux-gnu
     RUST_TARGET_FLAGS_m68k	:= m68k-unknown-linux-gnu
     RUST_TARGET_FLAGS_mips	:= mipsel-unknown-linux-gnu
     RUST_TARGET_FLAGS_powerpc	:= powerpc64le-unknown-linux-gnu


