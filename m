Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692BA22DF87;
	Tue, 20 May 2025 13:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749564; cv=none; b=pAIROSYoFx0/Tl4ZLs4O/Xqf99F1+6c71+LX5hpeRvo876kVawhyyOyJcmCExPaI/Mg47Q229IUYRlk8f0nUZAIgUQCRjc11i2zed+sXP+/zOuiRohwwYTozs11qacVRIZz76aCJW3BK4zbch1/NJEIvPjjPvO4UX8F0q0p/5tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749564; c=relaxed/simple;
	bh=8mvHMg5dQ/w7Ol0RCHGHUmMA7ubWz/fVgtscruMcM24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmA8MQDCbbsWkZF9t2f4f6mcEE/1gak7k5NIFV45oF0umZS+EJ/FD6bySiQ9yeLcZtUJf7TiOjmd7Pmoy6iLnju7sMDofjrXe3ogHtKgYIVvOifGV2VXUqfQxGYnt2cBvidJm67KH5j9KRIGgq4Ca2YyEVdRG8cYyGz6kzvfl4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9wmfBL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9wmfBL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765EEC4CEE9;
	Tue, 20 May 2025 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749563;
	bh=8mvHMg5dQ/w7Ol0RCHGHUmMA7ubWz/fVgtscruMcM24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9wmfBL/pXU+H4Oboe1sPICrVoaG6egqJflFxjhn/a+wyqpmoMPNXkDideiwwi+fa
	 /fbp9+8hfEONZzDZGN5gF4cJ/JCs+SrJxrWnot375xHFUbNS3x7tPCDcjvlwmfW72n
	 8Sz7s0seVDMIMiO51etHvOfbaze7KuD5V1JA+Bps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 84/97] LoongArch: Explicitly specify code model in Makefile
Date: Tue, 20 May 2025 15:50:49 +0200
Message-ID: <20250520125803.925466911@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,7 +38,7 @@ endif
 
 ifdef CONFIG_64BIT
 ld-emul			= $(64bit-emul)
-cflags-y		+= -mabi=lp64s
+cflags-y		+= -mabi=lp64s -mcmodel=normal
 endif
 
 cflags-y			+= -pipe -msoft-float


