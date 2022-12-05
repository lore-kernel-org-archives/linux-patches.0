Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B1D15C85
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA44C433C1;
	Mon,  5 Dec 2022 19:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269231;
	bh=BtqEnEqpe17lsYSv4xP7wVnbYXa/vNShkM9fP1IuSsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SySCuPuCGprPBIUSHBnlcTU/JKC8PTAB/Coda1RM5c3ptvwFcoBpAwkzcT4UN5vJO
	 XwnAEQomPKsAGomHA/LFNEj7aeomHbrHDjAABDXbklLuRhwjyHJmxxrqJ8Cof5QFR/
	 /PIqxM1hB2f1zanDho2KqclZ+XmF9VJ8khMDkDzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/153] nios2: add FORCE for vmlinuz.gz
Date: Mon,  5 Dec 2022 20:09:34 +0100
Message-Id: <20221205190810.153064445@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 869e4ae4cd2a23d625aaa14ae62dbebf768cb77d ]

Add FORCE to placate a warning from make:

arch/nios2/boot/Makefile:24: FORCE prerequisite is missing

Fixes: 2fc8483fdcde ("nios2: Build infrastructure")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/boot/Makefile b/arch/nios2/boot/Makefile
index 37dfc7e584bc..0b704c1f379f 100644
--- a/arch/nios2/boot/Makefile
+++ b/arch/nios2/boot/Makefile
@@ -20,7 +20,7 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 
-$(obj)/vmImage: $(obj)/vmlinux.gz
+$(obj)/vmImage: $(obj)/vmlinux.gz FORCE
 	$(call if_changed,uimage)
 	@$(kecho) 'Kernel: $@ is ready'
 
-- 
2.35.1



