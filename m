Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036994;
	b=yBoY8eXTHbV5rjBYtGMiUGHk2EL51AcmH7Kv5PwZtKWEmsmkXuzxzpWQS/e3EjWzOoPy
	 qk8RnbS62zDcg4NFAJsBXOmEBApBWRAE35oFdfb7rYw/aZM4VJbnrBaTWkw+y8K5w4oxa
	 vAeTkoYviPbwK9VbL7f3dS7vqbAVVWFrZ0896UBPQefzLMmZgUgdE20VsPjbIt6sIGXX8
	 5DBSBI/ydxM/oLLXwK2p0D9wJ+17BJjBs3be85ZMavNv9dXvkVBNjKVesmf5fZOtCo34G
	 optuRcMXrF0UAajXvF/kSnkMadgMLwFhVf8/OIgqpIrm+dOXEWrwHGGz/hGa2OJcxCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hpze9uMAfKM8kV7CTY3tRfDig4o/9X0jGfcrYR8ULJE=;
	b=1h5/SA2kQiMHToLWyP9hWmJPo9mAW7bWSnIU/6kKGeQuh2fBJ3pRFIbvWZsbf6nMaDfI
	 kV0Uaem3E645bGxAqf6MDdh2r57HvyZsuEJSEuZj/JKWXRxCsKAJlVRmJfgrVKgL1hKpT
	 C1SwNn8l/ZudgmxCvrV43yBrQsHOFveWGs+dDVFRh5qm+80Vjf50YViGk7nIfqhntjBcf
	 FKlg5TROq8q7itFfABsy6ZK614J+rbRx0HNWWwqed/P62oeOeg76hV4KVm5iMUzufC1iV
	 N/pKiymbDWqrsbKmlFUF8VVF60WMixLMwcHgtbw6e4zP1k6kWFelMWqEm2DRzJFW1ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2+xgfsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED03606A320;
	Wed, 18 Nov 2026 21:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2+xgfsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A601F000C5;
	Wed, 18 Nov 2026 21:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036994;
	bh=hpze9uMAfKM8kV7CTY3tRfDig4o/9X0jGfcrYR8ULJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2+xgfsQ46FBwaZyNqs1boc6pT81wKbQRWWrL2PHpk+Y0UgsGn9GnhSE61vs/68Cy
	 2kjpMobTXghYtfjXRqo3x8B9pbj+e6CnJNa2JZm2tgYn3sN3dmI7NwvmWDbd4bBmL4
	 gOXV0CUsSFYq65HxAw95B58gF9CAb6yHOXRggQTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1257/3318] LoongArch: Remove redundant call in update_bp_registers()
Date: Wed, 18 Nov 2026 15:31:19 +0100
Message-ID: <20261118150357.908885972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



