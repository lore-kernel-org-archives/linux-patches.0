Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1046715C158;
	Sun,  7 Sep 2025 20:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277105; cv=none; b=UoKBtJYr4dnAt0sGVhIN8APlj9N4rzribiPED+BGBZXYXgHviJHtXKfSmVOe5TXlrbIvKjeVLAR7Z0OkBM0EWZ6nOaJ+7ciJoDtTcIkVWYzuxnltkGKBrJg7RLmxvTVIfzwT2Wl8y/r4liyxRWmjqM0d6IsWPg0GBNikAnGY4Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277105; c=relaxed/simple;
	bh=9YxmnxPiipSJLg0iURRI71r0c8ef35aaj44VUzHl62k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afl6A8Eg1pUCirN/qij5NYIJafpRVVwnS5fEffXOlexwjoUpb1WZ3JXlH8hb1hpMb87IFTUzDV1R8w0JK1OYiawGQryzqjvC+J47V4FNXiDFsGacG+aJQ3+6r3tWEJwbFTVui6/g1B+7Bv/HxXVqOe9swEUPjSWr79Na0fIAXqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebbYDAbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebbYDAbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54237C4CEF0;
	Sun,  7 Sep 2025 20:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277104;
	bh=9YxmnxPiipSJLg0iURRI71r0c8ef35aaj44VUzHl62k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebbYDAbEP7HmG4krNLCHATcRuVAgFwdfDK9S777mh2IVNJCTVr4DNe+W+BwSXQz98
	 8Tb4uOMRNUakdfSheNChZ+/GZqFQsmv+irmktGZTL5spRy9z4p0SObIw3pU58W0+c1
	 3bk7+aBGAtKnf+UFRu/sJ9f6CNPi9dV6xwl14Tjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@cqsoftware.com.cn>,
	Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/175] LoongArch: vDSO: Remove -nostdlib complier flag
Date: Sun,  7 Sep 2025 21:57:05 +0200
Message-ID: <20250907195615.579280306@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit d35ec48fa6c8fe0cfa4a03155109fec7677911d4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index cf6c41054396a..49af37f781bbe 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -36,7 +36,7 @@ endif
 
 # VDSO linker flags.
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
-	$(filter -E%,$(KBUILD_CFLAGS)) -nostdlib -shared --build-id -T
+	$(filter -E%,$(KBUILD_CFLAGS)) -shared --build-id -T
 
 #
 # Shared build commands.
-- 
2.50.1



