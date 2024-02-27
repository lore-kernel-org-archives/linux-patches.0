Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FFB13B78A;
	Tue, 27 Feb 2024 13:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040559; cv=none; b=M0Tta7TldUeMd5Xdvpp9jxlZyzDVM0Z3IKE90/7JshxpCbL2Zn3fNstVNUn3OXkygc69cJn7mNSKhBdyZ9/2Zue9wwXOwI//33jhNjBH0yoOylzxIXuC3SkfHx8CzzGYPlmhxF3mwrnVn3PM/Y31nfVg3nujBnPFecMopoTpS5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040559; c=relaxed/simple;
	bh=lBkBZkQLaUd9Zu5sfPJuZe42sG64+nWLQoyyeqa4Js8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MxFS9eDyZpB/Vt8HY6JDlDGRnh668PX641keQk0YV9pnHAbgh4+aIzyhvN5+3+kcFJ7LtGLXiE2XdbvKvFXNWXWHLZW++yuEuOOFUYOgYftroeCQzpI6HuHMkfcbwm6WgXLd+Cg+UtwmFrpgiS3sGFriyuiHISEvNSyKaNPM93I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qobgha+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qobgha+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7578CC433F1;
	Tue, 27 Feb 2024 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040558;
	bh=lBkBZkQLaUd9Zu5sfPJuZe42sG64+nWLQoyyeqa4Js8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qobgha+ZOf396prcyCutM66+I7l1QAmfx8zJ/Y5UKsWlsh4Qbs6Dt4WnVYBlx9D+3
	 6aR5vhjKM8nvMjKlUgiXoxXfoBrgqqfEwdUie5zgoHRfwlhi6t5uBYBQNJtHcpM8AY
	 8qGHGwobD+EL8+0x1giRecf5J5s7RqGQO8cHLAVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 008/334] tools: selftests: riscv: Fix compile warnings in mm tests
Date: Tue, 27 Feb 2024 14:17:46 +0100
Message-ID: <20240227131630.902289811@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Müllner <christoph.muellner@vrull.eu>

[ Upstream commit 12c16919652b5873f524c8b361336ecfa5ce5e6b ]

When building the mm tests with a riscv32 compiler, we see a range
of shift-count-overflow errors from shifting 1UL by more than 32 bits
in do_mmaps(). Since, the relevant code is only called from code that
is gated by `__riscv_xlen == 64`, we can just apply the same gating
to do_mmaps().

Signed-off-by: Christoph Müllner <christoph.muellner@vrull.eu>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20231123185821.2272504-6-christoph.muellner@vrull.eu
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/riscv/mm/mmap_test.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/riscv/mm/mmap_test.h b/tools/testing/selftests/riscv/mm/mmap_test.h
index 9b8434f62f570..2e0db9c5be6c3 100644
--- a/tools/testing/selftests/riscv/mm/mmap_test.h
+++ b/tools/testing/selftests/riscv/mm/mmap_test.h
@@ -18,6 +18,8 @@ struct addresses {
 	int *on_56_addr;
 };
 
+// Only works on 64 bit
+#if __riscv_xlen == 64
 static inline void do_mmaps(struct addresses *mmap_addresses)
 {
 	/*
@@ -50,6 +52,7 @@ static inline void do_mmaps(struct addresses *mmap_addresses)
 	mmap_addresses->on_56_addr =
 		mmap(on_56_bits, 5 * sizeof(int), prot, flags, 0, 0);
 }
+#endif /* __riscv_xlen == 64 */
 
 static inline int memory_layout(void)
 {
-- 
2.43.0



