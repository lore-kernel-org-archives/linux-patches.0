Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065522;
	b=MJtftZurTspjtuwswREtXyisoaPCWqOch11gUnmcZ/LnxpmO0Sj3nc744OoCi4l2q/GC
	 e3jVq/23SO0IRNp72NdwOSZO2Inkuw2L86NMkUH8ESkypExOJh1h4WhaHdliZO8QPOvo8
	 SjFTmJpbx035Y4hWAQ44n1fh/Kbpb61h7MVjKqLeGVsZocSQ09N3qH0fqD1ZHr2wYZtmb
	 D81sf+uIPze1bAovCMDLH218ACXeDZL7Vkru6rU8VsCCYbpuk2A1rMTXPBZaaaCkvL6Bk
	 Z/NGmfb9ONUsd3tl1xjbT8JyzsIFlYby56z4H5ytTZJUxJeWYmlrko2uK+f9d8jhz1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3C2bDWe10tyNe1VetAG3Oh8HEZGBT/6O3YjndDpfLuM=;
	b=q2UWBUBRqWIeG//A5u03SwLYx74GsMRUvo6pYoK60ElEy0lYP7OrXgeypdIeSP0MLbsE
	 FqXvJd9wOtllSxX+PbL8D/X1GHk/tfFIpuzJ+b2lCa9cmjznQRTb/oeLTBBrqc7oEASEE
	 HXgCdQyOX2ZDLOz7DBty3hUgLvQSu6Pz3usY5TRmlnpbZX4CbQNJCQPtr18i1H1jqfItf
	 goxwRFCB3TzeiJIWujHZqru35FFjW3Sr6aWFAiD1DOCHLmL/ea70eTc/x8jdwQhEV2/J/
	 jnPOgFxeP5AZr5WbSm40yNKCDVrFsQQ8HuR+99a4mZTwwh25WO/D1pNqNkQys0jl3LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJ0cZUPw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7733606D805;
	Sat,  7 Nov 2026 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJ0cZUPw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9323B1F0089F;
	Sat,  7 Nov 2026 15:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065521;
	bh=3C2bDWe10tyNe1VetAG3Oh8HEZGBT/6O3YjndDpfLuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJ0cZUPwuvGCOdEZTxeuqEDt0nlgeTTPtH1kMuwTUM7enxv6yIGWRO1EyOgJJdrtY
	 HN243KIRtBJoOEIgjrxqXy914QbVXNMwBojqzp1Bv3qFrGN7Cmir16Ye3QfBSQ2yqX
	 I0BTkIj9lfuzfBLu6ev4jbbJ6Hf0q4zZ741dAhKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1166/1257] LoongArch: Remove redundant call in update_bp_registers()
Date: Sat,  7 Nov 2026 08:57:42 -0500
Message-ID: <20261107135011.392693954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 23534c6efeb718e8a4d9107fa7d6707b5b1f5859 ]

In update_bp_registers(), there is a duplicate call to write_wb_reg()
when enabling an execute breakpoint:

    write_wb_reg(CSR_CFG_CTRL, i, 0, CTRL_PLV_ENABLE);
    write_wb_reg(CSR_CFG_CTRL, i, 0, CTRL_PLV_ENABLE);

The two lines are completely identical. Remove the redundant call to
clean up the code and eliminate unnecessary register writes.

Cc: stable@vger.kernel.org
Fixes: edffa33c7bb5 ("LoongArch: Add hardware breakpoints/watchpoints support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/hw_breakpoint.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/loongarch/kernel/hw_breakpoint.c b/arch/loongarch/kernel/hw_breakpoint.c
index c35f9bf380334..deeb2f9795705 100644
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -453,7 +453,6 @@ static void update_bp_registers(struct pt_regs *regs, int enable, int type)
 		if (enable) {
 			if ((info->ctrl.type == LOONGARCH_BREAKPOINT_EXECUTE) && (type == 0)) {
 				write_wb_reg(CSR_CFG_CTRL, i, 0, CTRL_PLV_ENABLE);
-				write_wb_reg(CSR_CFG_CTRL, i, 0, CTRL_PLV_ENABLE);
 			} else {
 				ctrl = read_wb_reg(CSR_CFG_CTRL, i, 1);
 				if (info->ctrl.type == LOONGARCH_BREAKPOINT_LOAD)
-- 
2.53.0



