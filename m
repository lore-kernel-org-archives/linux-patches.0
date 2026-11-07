Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063724;
	b=hpcXaoYuXH/kFCAVW5Ij3nOZ7tfDnXtgkGkkH48it0Hww03QZoIomt8w1QkzLuLV84Fx
	 L0ElJDP27WtiPpnKm2MPS7m82WPFixoe8BSAQ2e+L5q/GQnevvLMC/vcjUM1btD6+EPD/
	 CFewo4rAfWCcJvRDshCuiJ4WZub3SO9c61eD9EgJsddrR8RLpldo3rKce/6OdXXfdKaHs
	 fb6Q7c5sb6QBFCz/EHu8q2WN92xjRwMtRXg8smDNnJTTe+4S7exPxvIYK6wb84tOwVLAz
	 tsoUCJmDUcDrHVE8aDlXEyeCoMHBtVqqMWGAx72GA4uabLtcoS2PGkjQf0XAEIHPtGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQpw2JyXWUUQOz+YJKXEyou5IGG8IGVi8KmC42yt9CE=;
	b=cnOGHexsLY/cZ2EigKMSCEp3W6MYYdgK4bxQ+XpQh7Y5ep4ofMVQD4TmKYW4OXhka0Gy
	 iwaEmK3TUxJmiimzFCqXyZM6y17iNzC86yZL9ahQplUA+eJkBVauEV+z+QpakWttCznh2
	 2XuEPApLj+e+ElZncPuBsLLHGqmg7yqTs3bZLfrdVgDBhD6M1yWavL6fDP6krHHXZsWZV
	 n0Xyg0pG3+JbGTbRVJxGJWfz4xPFyVVrL/aoXqlB44/aTaqCBYWl+IG+4ehhSsl0NBJtX
	 E1Z3ZSDE+ObjspTf7VDLUhuF8vrYOYO2d+qj/WAMUMX9xSdSq4TrwXtLCuB32Nsb3Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6xNnFeW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0C9606EEB0;
	Sat,  7 Nov 2026 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6xNnFeW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CA51F0089F;
	Sat,  7 Nov 2026 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063723;
	bh=MQpw2JyXWUUQOz+YJKXEyou5IGG8IGVi8KmC42yt9CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6xNnFeWroXnmWd5f8TXDZGm8S+g/JHZptXuFb86wA6vm94fmQDi7lEFddZmTTCZf
	 fKPx0yXc4O+RdCAhEgIQl4Hp5LD/SAi8Gc1o4auEjhV0NLjFV2OsNUFqHCDSTXMp4A
	 U8dcRO/gmJwokuOUto/Y6E0DzUEIh3tkKdj5pguM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 805/869] LoongArch: Remove redundant call in update_bp_registers()
Date: Sat,  7 Nov 2026 08:58:07 -0500
Message-ID: <20261107134920.219533239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



