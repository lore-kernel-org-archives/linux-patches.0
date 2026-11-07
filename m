Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062663;
	b=LETy4xssByHWWFLqBTGXuO8pdgeWzgpRNdYrC66TNhSkToXqez0XBEPOZiVAJaVN00yG
	 fHhXGWi0UbbZsMYlrWHHbsY1C6cB+5l9w7Uu+V8vMbPaHMF3Gu3mKnBMULNRSyz7RH9qy
	 dV2bbbiX2Pek9q8ITU1i97XeFC4kzJW6Ye/W4oXp+FqEqFTDgU0JwobZAk7qmOzcLp+jC
	 rqSGalHyfauXsQXUeY15I41t3MzfZr2UKup9++8wBxqa+M8epszavEezRIR8TCEzchmkR
	 HAdCG5D1oesz4svO+XnqDcoL6S4MfMxDZN8ivB317Y4wBQiUgedbfkodtZWek/ZWa/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x3q56H2R1fXSR/R40NDzWZWzfJuhw3PQpxbC/09z6EE=;
	b=zxbMe1hQO0DV54/dXZDwSP5xPCeGRzPpfjQOsxeRiUGs0egXGd2WEqwaSiTb1tes85yI
	 /AAQmfaW3WaYk2cUE2uBM/NTA9R51lyDMrsHxNgp9PKLAefDUJNc4iVcMH2Borb2gFNHl
	 fCrYqGuB1lK6Aus8urU/jR9xbaxY4MyTnV4Zh3N9fyPhY4oju+jW18xaMuvmPqjmXe7Hr
	 uH1V1b48B437dwKWO5Pvy7ColB4AgYteHfLkqJ8yaoXQp8FJro/7KzVr0rRa05P+R87zR
	 a8xXaEbdYtB59y/kwtFJd/NjojoPCUlX3U96tFuhGP7YEK2ZMpHcSFX8CVGOrNP2TdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkDQmoZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E29606A331;
	Sat,  7 Nov 2026 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkDQmoZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834321F0089F;
	Sat,  7 Nov 2026 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062662;
	bh=x3q56H2R1fXSR/R40NDzWZWzfJuhw3PQpxbC/09z6EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkDQmoZQCFI4bNMRefLWKuK/g0pyG+IWE61DaZtVddpLSPYqx9UAGTwyOEqcVWj0V
	 s8nTV8/UZjaZvfvZOdEkDugBHVtIgkoB1nYYBKdpyhNVBjU5CISVfB5+lnE8hYGnud
	 K9A04rsfr0MGpKCTp+mhwX1CTVnyvHZojA178wGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1488/1536] LoongArch: Remove redundant call in update_bp_registers()
Date: Sat,  7 Nov 2026 08:58:24 -0500
Message-ID: <20261107135039.650019397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



