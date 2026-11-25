Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618655;
	b=oxmzJlDfceokOT2Z2cwSsx93J0Cl89P+HqhVLUMV84VB43BCHsjUDNP4HKKV0TPPCVIe
	 /AVCC7HdNevCxFtcra5h3NkozBd2K5h4R05iynqF6q2PyR2d0T60ZD7Np4f5dyi+bROgu
	 BBC9AWiJVxne8ge4ixmk3jJDrY84bxdcv2+nqRcrjX1MmUdvjW7RbpFKVkCcXj72GbWqa
	 O8JXnzspbM1HPH+sVcBMNmo0AIZSbITmHwEgSRLa/1hKt2/gwdCwJg1ibsS0FNQYO9Qtk
	 uAuwNHqbmBR+ycPrJRx96SLBuYBKk8IqExHEkXHkla5UMd7DzR7dtCiSuW9/FwqejBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GWKhthgtTx8ernyUynd4XocHb71z7whiogmsMhsf3D8=;
	b=vhLLZKdMlUAmUBKS185QkmYETHFAU6AxQfc15+rrG+Pvxbz8cUWlg6R5M7FVfjCRDyFV
	 jHrzCzFp1oUeXlr00Gt/HN94SyIiTExge35CKv+lVDL3H7VnLBzPGfFiy1qF2NFVlyyP8
	 GxuRU3Th0kUp2tACCNp7X7kcC2wQJfA+Innmx2EmvAo7reZSBOxdGJXKBg4eHoyOGUufJ
	 sqrMdxhIjdUHHqHg3L8CS9o2YnYy91Td4vHyatMjdUtbIg8SJTeBU+k/7333TOVxDdWsr
	 E5iIPKSkC2MTpKkiD9uakRen5o656rGoSUBI2KmV7uCi1+Zolt/+8PWm/8YWBciaLdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTaHTt2H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675E606A31E;
	Wed, 25 Nov 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTaHTt2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2227A1F000CF;
	Wed, 25 Nov 2026 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618654;
	bh=GWKhthgtTx8ernyUynd4XocHb71z7whiogmsMhsf3D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTaHTt2HFJLrKQA3xWwyfyPaPxz0OKzgGv85TD+oKwAplWXct+cqa5CQpD/84ZaVL
	 sDhdQwim1XsRwWic1cB7Vxxqwfx4ZkzGoTDP/lezO+b0k3Gxr+wt9t9UQbhg43FOVk
	 cZzfQm6+cggmhtXRrZ8XawvjA6EbkTdNoeNRmPXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0346/1005] sched/pelt: Fix u32 truncation of the PELT period count
Date: Wed, 25 Nov 2026 15:28:04 +0100
Message-ID: <20261125143829.839865769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit a0c755e574e37fddb59edf175f27dc3877e7fe23 ]

accumulate_sum() computes the number of elapsed PELT periods in a
u64 but returns u32. When the count is a multiple of 2^32, it is
truncated to zero even though the PELT sums have been updated.

The caller interprets zero as no period boundary crossed and skips
recomputing the averages, leaving *_avg stale relative to *_sum.

Return the period count as u64 so the caller can test it without
truncation.

Fixes: a481db34b9be ("sched/fair: Optimize ___update_sched_avg()")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Link: https://patch.msgid.link/20261023025207.2967903-1-sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/pelt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/pelt.c b/kernel/sched/pelt.c
index 779eb58a42614..d10d57b6b8ec7 100644
--- a/kernel/sched/pelt.c
+++ b/kernel/sched/pelt.c
@@ -99,7 +99,7 @@ static u32 __accumulate_pelt_segments(u64 periods, u32 d1, u32 d3)
  *      d1 y^p + 1024 \Sum y^n + d3 y^0		(Step 2)
  *                     n=1
  */
-static __always_inline u32
+static __always_inline u64
 accumulate_sum(u64 delta, struct sched_avg *sa,
 	       unsigned long load, unsigned long runnable, int running)
 {
-- 
2.53.0



