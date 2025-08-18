Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4637821D3DC;
	Mon, 18 Aug 2025 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524714; cv=none; b=L59b9NRcbMjEgUw7Khde80g3shIuYU6GhejmKwr+o9tsDyQQLVGbAvWnZqvGHWtmZwZ1cxc2gdyWPCEGAOXT/SfH18xxjZEH0OpLI0gugQoZsQyPUoPYyhgucmcuV/OxBKltcDRA8Bx2i0vyAVQNkAKwqS7qvQDId59o1AqHxUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524714; c=relaxed/simple;
	bh=tBhMnoe1lrRbIh/zve1vSTmx8BRKNxBZwimgCle28mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjHso6UVHB4JXR6eC165l+mMXjbmLQ4ZEC5PWzzUkljVUq6qO24s5HNtpSQf8gK0yD6k2zVnRy94kP+pZKOiop7FWQPHLNx/a+4ZK2vYIrm45GzC+FrXbRu97M9b0bJFvqzOcSW+AUeUMZsdfra25jgg/tzxySg6fgY6EfoBL6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0A416vmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0A416vmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C167CC4CEEB;
	Mon, 18 Aug 2025 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524714;
	bh=tBhMnoe1lrRbIh/zve1vSTmx8BRKNxBZwimgCle28mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0A416vmRhJ3X07ZcsGX9qZaVIpHk8iXPe2rl0sb+ZTidkamOnVSey87HeLSF9snAY
	 Bm83zOyeM66P4Mg1eZdwUCx4E/0wyrxJ3mbjI/lQWRGExQpd8zqKZ6qacUL5n+qVgQ
	 YryVNclgYD8sk06YvB65Djkj9csV9gcTx7sBkh5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@cqsoftware.com.cn>,
	Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 040/570] LoongArch: vDSO: Remove -nostdlib complier flag
Date: Mon, 18 Aug 2025 14:40:27 +0200
Message-ID: <20250818124507.360643113@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

commit d35ec48fa6c8fe0cfa4a03155109fec7677911d4 upstream.

Since $(LD) is directly used, hence -nostdlib is unneeded, MIPS has
removed this, we should remove it too.

bdbf2038fbf4 ("MIPS: VDSO: remove -nostdlib compiler flag").

In fact, other architectures also use $(LD) now.

fe00e50b2db8 ("ARM: 8858/1: vdso: use $(LD) instead of $(CC) to link VDSO")
691efbedc60d ("arm64: vdso: use $(LD) instead of $(CC) to link VDSO")
2ff906994b6c ("MIPS: VDSO: Use $(LD) instead of $(CC) to link VDSO")
2b2a25845d53 ("s390/vdso: Use $(LD) instead of $(CC) to link vDSO")

Cc: stable@vger.kernel.org
Reviewed-by: Yanteng Si <siyanteng@cqsoftware.com.cn>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/vdso/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -36,7 +36,7 @@ endif
 
 # VDSO linker flags.
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
-	$(filter -E%,$(KBUILD_CFLAGS)) -nostdlib -shared --build-id -T
+	$(filter -E%,$(KBUILD_CFLAGS)) -shared --build-id -T
 
 #
 # Shared build commands.


