Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2C02F37;
	Tue, 20 May 2025 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749949; cv=none; b=Trmzo0Jg1w9g6cQbI8R5TBRuIQQABXLAmao5RRvPfRQ3tCZyQt5auJcZ5/qpg+lNjIDUK1tt7IZC/1m1Ngqbz1mWiXac1oOSJYCuh9Qiokc0pAIsTXHXqS5DyOTrBHLh2Hz/ti86T8Zw9oFlk++/7YvsQ2wgFDOfhjGf8hudn1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749949; c=relaxed/simple;
	bh=St9qD/btmGN/UQVahePy9i7K+EZmqVKvRrGc+JFGj9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEF2dX1trsM1Wy0vGUP7kEFqbsfeW4AX9vsbVIDgABeLQQz5qfImgbaEuSnbZhbQV/ZhOhGGNWHfZfNbaiiysdVo3RwLgMf18Yz0JaUJuwCUzjeZPlFDPE8XpHPqXW8SJnBV2k0KIpMDGig4nzHsT1x3NPvI/vCL+4CJmbjsmuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTnLrx/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTnLrx/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51895C4CEE9;
	Tue, 20 May 2025 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749949;
	bh=St9qD/btmGN/UQVahePy9i7K+EZmqVKvRrGc+JFGj9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTnLrx/eRJM7Awg7TP35sX0uahUEo8QxUUvLyhKwfmv8ifs0hYZM1wcJLavVxdJ1t
	 NKC44JYVzHAZgEZvwnVDlZBPTEFip0uOX/FNXgLd736q3HW1KxWtUzQn8onelpvTrX
	 rtazmVOHKraRh503fu+NecT554WABrLQM5x4Th8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 111/117] LoongArch: Explicitly specify code model in Makefile
Date: Tue, 20 May 2025 15:51:16 +0200
Message-ID: <20250520125808.407043927@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit e67e0eb6a98b261caf45048f9eb95fd7609289c0 upstream.

LoongArch's toolchain may change the default code model from normal to
medium. This is unnecessary for kernel, and generates some relocations
which cannot be handled by the module loader. So explicitly specify the
code model to normal in Makefile (for Rust 'normal' is 'small').

Cc: stable@vger.kernel.org
Tested-by: Haiyong Sun <sunhaiyong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -43,7 +43,7 @@ endif
 
 ifdef CONFIG_64BIT
 ld-emul			= $(64bit-emul)
-cflags-y		+= -mabi=lp64s
+cflags-y		+= -mabi=lp64s -mcmodel=normal
 endif
 
 cflags-y			+= -pipe -msoft-float


