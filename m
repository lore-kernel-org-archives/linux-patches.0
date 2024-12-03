Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7610E1F7569;
	Tue,  3 Dec 2024 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239562; cv=none; b=HfhPQFfSH6tdvFcuRMSiVzBDfXQC2REn4vxCjoPG1Kyj5Vz9mlSfhMFb6cPIjqLYJImMJLWqrjFuQu9ElioC/dOmBl0iv/62gw+sex7d94epXe53CpmOr+cvqDMZv30njRwBp9qsf6Jz7+IxeRF0CoQeyzD3kqJJnqVgeD5kYTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239562; c=relaxed/simple;
	bh=xr+eRuqgIguaB/aA2wHe+sRDd4kmAUu8C7G0gfoHjgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3O42lwchM5fxNlAZEeKJ0IzbaA6sDepJA7rw/BCpiwpcg6BB3i8og+aFn5E4Fq35SGdcn98hhKHkQjSMD55fL6xfHrmq1xqloSWrjWEZu8iZlfb1zSJaGnx08UGy8D0Wa4J7wBGYNOpuorleVC5GR7GOjDIdn+WB+fSsec4j0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHXf4XXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHXf4XXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012FDC4CECF;
	Tue,  3 Dec 2024 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239562;
	bh=xr+eRuqgIguaB/aA2wHe+sRDd4kmAUu8C7G0gfoHjgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHXf4XXN0+CsuFFvDVtsT8gfsRs3cZ4buwelbgZ/HEd9zbx0w2MpJwZe5NikTKkn3
	 bkj3o4pUhSWImQ4w7gghX0u7yHA18Ao2qg6MpPmsHpmzv7+iGJtvsrrm+Bhb4X5+Eh
	 sMBE4dEemHbNvK4dmAOe8Q/phAUMxhzcYwJQ4UAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.11 657/817] LoongArch: Explicitly specify code model in Makefile
Date: Tue,  3 Dec 2024 15:43:49 +0100
Message-ID: <20241203144021.604709934@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 arch/loongarch/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -59,7 +59,7 @@ endif
 
 ifdef CONFIG_64BIT
 ld-emul			= $(64bit-emul)
-cflags-y		+= -mabi=lp64s
+cflags-y		+= -mabi=lp64s -mcmodel=normal
 endif
 
 cflags-y			+= -pipe $(CC_FLAGS_NO_FPU)
@@ -104,7 +104,7 @@ ifdef CONFIG_OBJTOOL
 KBUILD_CFLAGS			+= -fno-jump-tables
 endif
 
-KBUILD_RUSTFLAGS		+= --target=loongarch64-unknown-none-softfloat
+KBUILD_RUSTFLAGS		+= --target=loongarch64-unknown-none-softfloat -Ccode-model=small
 KBUILD_RUSTFLAGS_KERNEL		+= -Zdirect-access-external-data=yes
 KBUILD_RUSTFLAGS_MODULE		+= -Zdirect-access-external-data=no
 


