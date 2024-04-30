Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F4C12B176;
	Tue, 30 Apr 2024 10:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474697; cv=none; b=J7FsQjavtVJx70qXzYLivDBUO+vIQHx/dIPDQzBz/TEQ/8jbhLzGcA3MNw4ptEbhnfk9ki+/WH1Hs1NVDP2xMvS29/hK83ROypb7xLaU2OXvNf9RwJAL4x1CGmfCzq/9lqRxcPx6sjtCc7UYTjt0lSis1FILbt0iEzf6ZunpU9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474697; c=relaxed/simple;
	bh=uCTjn1BA2rB6wfqZnqAgHz2wsuGpAfIBgzeLMZa8PLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvzaFsylhIxvY5GFGG3REAOH+Iz1RM9QIXhOs05lDvbG360wnTpi662XEOvjj2StCtwKdWkpn05J09weOml98j7yCyVjkX+SDICCk3qDVE051yoU1MzL2Dl7wDAHJ2s57K6CxFK6bJ7hgu8G+Gu/7yHgVVF87jS7mYxDDqWoDCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFjQUF6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFjQUF6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12B0C2BBFC;
	Tue, 30 Apr 2024 10:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474697;
	bh=uCTjn1BA2rB6wfqZnqAgHz2wsuGpAfIBgzeLMZa8PLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFjQUF6vK+M31U2GIE+rjtVYD9arMG1SZ/NjAgH4t03T+TpshWf5oCQJg+xvICDiq
	 BlJIjt4leT4xi83almDKGxE5mtkAO0UMV9Hckda1rsN5oAfRGNyHIsmpSiyRXECXco
	 bgjb28MLy0AGymGO90M+D6aPMA8lXy4uNCqW7Np4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Woodrow Shen <woodrow.shen@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 222/228] RISC-V: selftests: cbo: Ensure asm operands match constraints, take 2
Date: Tue, 30 Apr 2024 12:40:00 +0200
Message-ID: <20240430103110.208792996@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit 49408400d683ae4f41e414dfcb615166cc93be5c ]

Commit 0de65288d75f ("RISC-V: selftests: cbo: Ensure asm operands
match constraints") attempted to ensure MK_CBO() would always
provide to a compile-time constant when given a constant, but
cpu_to_le32() isn't necessarily going to do that. Switch to manually
shifting the bytes, when needed, to finally get this right.

Reported-by: Woodrow Shen <woodrow.shen@sifive.com>
Closes: https://lore.kernel.org/all/CABquHATcBTUwfLpd9sPObBgNobqQKEAZ2yxk+TWSpyO5xvpXpg@mail.gmail.com/
Fixes: a29e2a48afe3 ("RISC-V: selftests: Add CBO tests")
Fixes: 0de65288d75f ("RISC-V: selftests: cbo: Ensure asm operands match constraints")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20240322134728.151255-2-ajones@ventanamicro.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/riscv/hwprobe/cbo.c     |  2 +-
 tools/testing/selftests/riscv/hwprobe/hwprobe.h | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/riscv/hwprobe/cbo.c b/tools/testing/selftests/riscv/hwprobe/cbo.c
index c537d52fafc58..a40541bb7c7de 100644
--- a/tools/testing/selftests/riscv/hwprobe/cbo.c
+++ b/tools/testing/selftests/riscv/hwprobe/cbo.c
@@ -19,7 +19,7 @@
 #include "hwprobe.h"
 #include "../../kselftest.h"
 
-#define MK_CBO(fn) cpu_to_le32((fn) << 20 | 10 << 15 | 2 << 12 | 0 << 7 | 15)
+#define MK_CBO(fn) le32_bswap((uint32_t)(fn) << 20 | 10 << 15 | 2 << 12 | 0 << 7 | 15)
 
 static char mem[4096] __aligned(4096) = { [0 ... 4095] = 0xa5 };
 
diff --git a/tools/testing/selftests/riscv/hwprobe/hwprobe.h b/tools/testing/selftests/riscv/hwprobe/hwprobe.h
index e3fccb390c4dc..f3de970c32227 100644
--- a/tools/testing/selftests/riscv/hwprobe/hwprobe.h
+++ b/tools/testing/selftests/riscv/hwprobe/hwprobe.h
@@ -4,6 +4,16 @@
 #include <stddef.h>
 #include <asm/hwprobe.h>
 
+#if __BYTE_ORDER == __BIG_ENDIAN
+# define le32_bswap(_x)				\
+	((((_x) & 0x000000ffU) << 24) |		\
+	 (((_x) & 0x0000ff00U) <<  8) |		\
+	 (((_x) & 0x00ff0000U) >>  8) |		\
+	 (((_x) & 0xff000000U) >> 24))
+#else
+# define le32_bswap(_x) (_x)
+#endif
+
 /*
  * Rather than relying on having a new enough libc to define this, just do it
  * ourselves.  This way we don't need to be coupled to a new-enough libc to
-- 
2.43.0



