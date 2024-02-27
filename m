Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C7454BD4;
	Tue, 27 Feb 2024 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041690; cv=none; b=cVWvBF7lJNOE1bjMkCMLyIzxe4dhccElbcoXpwLdLn3ul3u2gZdfEovQLldmvbz1/gq2gIEue6HQ2Pbylld2bL8kNAbA6q1yDKF9lZLW1l1scyT/SZW1HgtcTTX5ysU6Z9bgibXMSdviDcxzbAOFRCuKQ7YTisM8X15oN+ekYnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041690; c=relaxed/simple;
	bh=Xw8ajy95xXuTH9d/V3L99dooD1E1dKMNpZmDIhnnXWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I07bkpuI75AYaVr4oncBIi5I8hdWPtfYxQUEOn4YLG0h5vAjz/4Ze44QHARE/a177EPgMe/tO/7o+facpXVrSSGKrHnm80Maqu9eHMgro9mhCmO41Co99Tqipi4ULEpZM9dUsRBK+WlXkEXmt0ntYWtuKnRIvmInQ5zO/qcep1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCDwdA+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCDwdA+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD62C433F1;
	Tue, 27 Feb 2024 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041690;
	bh=Xw8ajy95xXuTH9d/V3L99dooD1E1dKMNpZmDIhnnXWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCDwdA+ZDbxQ4JLsRuUISlCELG31Ho/q4D8o9YcMW61CFLn6/wlLZSv7hMFw4LaqH
	 DxU03YZOIozyKPfx9YZureFM71+OwhrKBns4o6miHU6xoI47LeN7JDBbDjxeg9E3hQ
	 VSjxbfgCewH/cdTBTFiJwbygGPTPDEVKdSPz90OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/299] tools: selftests: riscv: Fix compile warnings in mm tests
Date: Tue, 27 Feb 2024 14:21:59 +0100
Message-ID: <20240227131626.111083170@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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



