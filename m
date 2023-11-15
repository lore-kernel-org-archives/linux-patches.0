Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02653A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq5wXeI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50462C433CA;
	Wed, 15 Nov 2023 19:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077855;
	bh=yFyXm4JAoncDZPkviO+11x7torsooitJrJapDV1z8Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eq5wXeI0FNeOfEm4zRCB1scPhFNIm0jKB0Vl1qx5kwFdBX7V73z9Xj3yaL3KUqRl3
	 8Stk5P39Mm+mF2pMEhtpMlkXcQ1dVG0edj6YSFfoSgS/TdYimx7S+dg/tnvjGpeqxY
	 9oZyMrDrT+C1EBnXvr6NqsvcxTzNVJ7z2o9Jpqhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Damien Le Moal <dlemoal@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 561/603] riscv: boot: Fix creation of loader.bin
Date: Wed, 15 Nov 2023 14:18:26 -0500
Message-ID: <20231115191650.448121327@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 57a4542cb7c9baa1509c3366b57a08d75b212ead ]

When flashing loader.bin for K210 using kflash:

    [ERROR] This is an ELF file and cannot be programmed to flash directly: arch/riscv/boot/loader.bin

Before, loader.bin relied on "OBJCOPYFLAGS := -O binary" in the main
RISC-V Makefile to create a boot image with the right format.  With this
removed, the image is now created in the wrong (ELF) format.

Fix this by adding an explicit rule.

Fixes: 505b02957e74f0c5 ("riscv: Remove duplicate objcopy flag")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/1086025809583809538dfecaa899892218f44e7e.1698159066.git.geert+renesas@glider.be
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/boot/Makefile b/arch/riscv/boot/Makefile
index 22b13947bd131..8e7fc0edf21d3 100644
--- a/arch/riscv/boot/Makefile
+++ b/arch/riscv/boot/Makefile
@@ -17,6 +17,7 @@
 KCOV_INSTRUMENT := n
 
 OBJCOPYFLAGS_Image :=-O binary -R .note -R .note.gnu.build-id -R .comment -S
+OBJCOPYFLAGS_loader.bin :=-O binary
 OBJCOPYFLAGS_xipImage :=-O binary -R .note -R .note.gnu.build-id -R .comment -S
 
 targets := Image Image.* loader loader.o loader.lds loader.bin
-- 
2.42.0



