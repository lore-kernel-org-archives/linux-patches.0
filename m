Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332A39FE3;
	Fri, 24 Nov 2023 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nm0tJ2T+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B0CC433C7;
	Fri, 24 Nov 2023 18:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850167;
	bh=fAC/qRZ3/GaDfETqOQcdZQ41d2wDzZPlciOBTq6xbOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nm0tJ2T+vWXdVvOy/qN3DS01jthaxObffplwsFeGy+KZ4+FK1E5//t0Z0iv7gSwvT
	 GlSj+M3+5FsbZbmJ3k4VubtxubCZkKTBvxXN6HcdP4xULg7xFS/Nb0bLr+7qh4sotQ
	 3SE2pHhtVsqTTojE0ZvCWdHgNRH6mrFxwWISYvH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <suagrfillet@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 472/530] riscv: mm: Update the comment of CONFIG_PAGE_OFFSET
Date: Fri, 24 Nov 2023 17:50:38 +0000
Message-ID: <20231124172042.437243945@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Song Shuai <suagrfillet@gmail.com>

commit 559fe94a449cba5b50a7cffea60474b385598c00 upstream.

Since the commit 011f09d12052 set sv57 as default for CONFIG_64BIT,
the comment of CONFIG_PAGE_OFFSET should be updated too.

Fixes: 011f09d12052 ("riscv: mm: Set sv57 on defaultly")
Signed-off-by: Song Shuai <suagrfillet@gmail.com>
Link: https://lore.kernel.org/r/20230809031023.3575407-1-songshuaishuai@tinylab.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/page.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -33,8 +33,8 @@
 #define PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 #endif
 /*
- * By default, CONFIG_PAGE_OFFSET value corresponds to SV48 address space so
- * define the PAGE_OFFSET value for SV39.
+ * By default, CONFIG_PAGE_OFFSET value corresponds to SV57 address space so
+ * define the PAGE_OFFSET value for SV48 and SV39.
  */
 #define PAGE_OFFSET_L4		_AC(0xffffaf8000000000, UL)
 #define PAGE_OFFSET_L3		_AC(0xffffffd800000000, UL)


