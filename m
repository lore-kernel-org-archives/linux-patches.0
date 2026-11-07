Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064541;
	b=ZnGA8rBlXiMxkh2dsfSFlGHBIycvAoEPI0R2fZigkQOtEMeUuDsuYQMDghzXQvG3MjDp
	 /qzNocrSe3dJQrC76CVb1UwfYEu1QscM8vz0JFML/SyxUnhfi+SnwT7orvwBD+sJx8A4k
	 Ww8FYuLBvDK64woMLkU0ZPGqpi4FtusOYs9znDJiDYXiWGzvSD1TKEZnWKR5u12MzLRde
	 xsya+fVbRxkl4QFzh3X9mPwwmo/m4CuBpiL2xxv1kTQ943L+WG1GG5GJv8ofRiUwuXgym
	 0EJ7HFPOq3XEwqeXah+53rcVWTyjHAfLdqFtdofNFS26DURUxuzC8T4pDbl80eew4FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=14zqS0fgc5rdT8tBxMgsg/WuIin3RqeyPTePQcHc2N4=;
	b=za4ToUV2BXT9XYco0teWfpgHvR6qbCfz5IIiaWp2g42uwdwKvVzpPZ8wKEGOZU2WG+Og
	 0z3mWYyfVN37HctRD63uyGHBzDcyekOcW5jVEm+H0byS4dJ+VULlZpwCy2ZB3Kw+corif
	 pNVD8VSTRR+qD2mN/DFcT2uhrQU7okAYIrAaVforp4CO5vwpJe9OdjAEBSN+beCEjdFv9
	 zu2XskuMGmVYa+ovhIuSD6zsPlyele4Ci8KlYMp44HBXdBMG3VfUCWSBXFtpwXtGQiwSa
	 yPIRM4HDycEFE5lgQSDDLAOIwHdT9LnLOhpFBsqsj/bZS0W65TxDSP5cI4S0O2eatkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Ljonbo7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807A1606B8A6;
	Sat,  7 Nov 2026 15:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Ljonbo7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0B31F0089F;
	Sat,  7 Nov 2026 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064541;
	bh=14zqS0fgc5rdT8tBxMgsg/WuIin3RqeyPTePQcHc2N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Ljonbo74LlefXn7svvJRx2FzS1eeKkq/dcxmpTA4/seLg3UDxae+L5AaB13LWnmJ
	 sVWiAe5UCkCr70534pG/CjdDw7ZHiBGNP19WHabA0ZBxLhyvE35H3SYyniXe4qdaSc
	 EiHM6iCdYNZUjS0DwJlClcSnfJ3qUeGue+wUtpEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0568/1257] riscv: cfi: Bounds check restore token before swap
Date: Sat,  7 Nov 2026 08:47:44 -0500
Message-ID: <20261107134955.048546691@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit df333b72c0e14d6cffec72ce9a00503f12d1e28d ]

Currently the user-provided shadow stack restore token is not checked
before being used as the address in ssamoswap.d. While an invalid
restore token will be caught and raise SIGSEGV, this happens after
writing 4 bytes of zeroes anywhere in the address space. Check that the
restore token is at least a valid user address before the swap to ensure
we do not scribble over kernel memory.

Fixes: 66c9c713de59 ("riscv/signal: save and restore the shadow stack on a signal")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://patch.msgid.link/20261007155748.291814-1-samuel.holland@sifive.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/usercfi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index dec0ba5eff5ea..23c4d6d9d8cbc 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -206,10 +206,13 @@ int save_user_shstk(struct task_struct *tsk, unsigned long *saved_shstk_ptr)
  */
 int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr)
 {
+	unsigned long __user *token_ptr = (unsigned long __user *)shstk_ptr;
 	unsigned long token = 0;
 
-	token = amo_user_shstk((unsigned long __user *)shstk_ptr, 0);
+	if (!access_ok(token_ptr, sizeof(token)))
+		return -EFAULT;
 
+	token = amo_user_shstk(token_ptr, 0);
 	if (token == -1)
 		return -EFAULT;
 
-- 
2.53.0



