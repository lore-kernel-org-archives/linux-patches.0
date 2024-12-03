Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB63E1F4709;
	Tue,  3 Dec 2024 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237842; cv=none; b=h24/Blhl4PKff+93c47sCXtJ/f67lV+Ndf3VJqE18TjyBbA26Ynb+NH0xNihGf5OzE27C47xyzYxUybpiYuzUL1cU1lDEtSmhvbqzlNSRWgfob3c6DfhaIngCYTHorEHbIzF7vAGG99G2VghHuuZXh+Frv/Sj46/VOnck8OLAeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237842; c=relaxed/simple;
	bh=okTR3qavnKt9NpcADArA5ywEG4QFJAlivnJ81YSiV+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Swp41AOmeZAqfhgxPA0fy4rghUHcC83WfRUjsEdyMLHhIqggU9+6EYYjS9gmthePuZa3lTJzcPoP9KZQk9XHmgJlPLunuI2e9+fI86B/PZrMQ64ClqKdDligd0lagtB+pclkheI3b49DbARcXZXf1nbCfVU1A8pkimmmJvAUpZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=df6b9Frs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="df6b9Frs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFADFC4CECF;
	Tue,  3 Dec 2024 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237842;
	bh=okTR3qavnKt9NpcADArA5ywEG4QFJAlivnJ81YSiV+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=df6b9FrsjqnHMjwQe5daKk1xbaWCrlpOn5/cLUruDaJKjDvTAZF3YDpTCMI9jCtcx
	 b9M0+Ql4+HqJJvyqUroCURCR+cgews6o/0RsljerzzZElZR7HaZo8Uf5nSANkT3vu4
	 OXPftwEmrFNrCCsrBvUAsv2LG3SY18mIlrXvXOiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 068/817] m68k: mvme147: Fix SCSI controller IRQ numbers
Date: Tue,  3 Dec 2024 15:34:00 +0100
Message-ID: <20241203143958.343035460@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 47bc874427382018fa2e3e982480e156271eee70 ]

Sometime long ago the m68k IRQ code was refactored and the interrupt
numbers for SCSI controller on this board ended up wrong, and it hasn't
worked since.

The PCC adds 0x40 to the vector for its interrupts so they end up in
the user interrupt range. Hence, the kernel number should be the kernel
offset for user interrupt range + the PCC interrupt number.

Fixes: 200a3d352cd5 ("[PATCH] m68k: convert VME irq code")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Reviewed-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/0e7636a21a0274eea35bfd5d874459d5078e97cc.1727926187.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/mvme147hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
index e28eb1c0e0bfb..dbf88059e47a4 100644
--- a/arch/m68k/include/asm/mvme147hw.h
+++ b/arch/m68k/include/asm/mvme147hw.h
@@ -93,8 +93,8 @@ struct pcc_regs {
 #define M147_SCC_B_ADDR		0xfffe3000
 #define M147_SCC_PCLK		5000000
 
-#define MVME147_IRQ_SCSI_PORT	(IRQ_USER+0x45)
-#define MVME147_IRQ_SCSI_DMA	(IRQ_USER+0x46)
+#define MVME147_IRQ_SCSI_PORT	(IRQ_USER + 5)
+#define MVME147_IRQ_SCSI_DMA	(IRQ_USER + 6)
 
 /* SCC interrupts, for MVME147 */
 
-- 
2.43.0



