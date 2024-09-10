Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78CE186619;
	Tue, 10 Sep 2024 10:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964484; cv=none; b=QV92/IXg6fuj2QIV6GGkb8IbclTCaYbnN2kNHI6ZAbwT58YTu5JSlQBluvs3xaFkFDzSu0YYv0yIq+NnPeeWhRTvbBn2vyZUNUvgAVM9PzPHBPI8I9cf9hi0jgORYNnoNiF7gV7GxCZQof4tHpcAXwQyKwWoHLvAMTIdoc3HUyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964484; c=relaxed/simple;
	bh=QtQWDCdVsC4gBe/a+uyQvvpPvgR1kSZjrbSlYeT4sEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plpz2GaAVRd1wet20t73MDJ7hYNmeVcXqzi8Zh8HsQN8heXsyVaVM8IDSab5UzIUWVI4qvbfjdRrCYOmYhBZPOlwdWkD8bTTGzLcS5h8oCns+pb163S4+8jnQKBSOLi+Ex75un+WZsilEaPEl3Jsb/4FLfiSjoAPUBvgGOmPT0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaygYEED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaygYEED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106A1C4CECE;
	Tue, 10 Sep 2024 10:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964484;
	bh=QtQWDCdVsC4gBe/a+uyQvvpPvgR1kSZjrbSlYeT4sEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaygYEEDJJbfVtrKjMTp8WmDE2ouuABOB5VUeZE262JmjdIVIlPhsSlX5fEcqpPwi
	 rCK7jxiUcZu+IFeI1zJbe+lsRJ3twf8RgaViDx6cwD8ZMFvP4M99WaROENRxYuX3u8
	 EF0kgM8KeByzrW+XD/2kKQH+fk/En0mA8Oo+qRW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 198/269] riscv: mm: Only compile pgtable.c if MMU
Date: Tue, 10 Sep 2024 11:33:05 +0200
Message-ID: <20240910092615.156434788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit d6508999d1882ddd0db8b3b4bd7967d83e9909fa upstream.

All functions defined in there depend on MMU, so no need to compile it
for !MMU configs.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20231213203001.179237-4-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -13,10 +13,9 @@ endif
 KCOV_INSTRUMENT_init.o := n
 
 obj-y += init.o
-obj-$(CONFIG_MMU) += extable.o fault.o pageattr.o
+obj-$(CONFIG_MMU) += extable.o fault.o pageattr.o pgtable.o
 obj-y += cacheflush.o
 obj-y += context.o
-obj-y += pgtable.o
 obj-y += pmem.o
 
 ifeq ($(CONFIG_MMU),y)


