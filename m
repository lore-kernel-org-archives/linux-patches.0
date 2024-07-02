Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD3C15B0FE;
	Tue,  2 Jul 2024 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940263; cv=none; b=Uw9PM6s3ivDYv2Poxm38g+WNHmwuIA8kZ40UGItLctZVU1iFd59tq1sNcy4uOhGZb1dCJYPEGyQRnpSgCxIi1icL6psNPedQ5CDdJ/E0RgWkXW/ctI7z6AYPQsM5tr/0S4a/JVB7cx0Rz+3/YgSWAux8qr4jlIscha2xtxdzseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940263; c=relaxed/simple;
	bh=MmfwdZdHXpUVv8Jhu1NJf6MQzS2ei8tV+WYLpYq6Lk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGi7oLngolXQRxSdsDEJ/WYcuCf2NNbvGkRp3EQyB0CyiHBw3GfuwCqVrA6mUWjssBWgQL0aQThIx+eGL3bSG+VyyCFGIQ/Jy5c5ftctdiuCiE418Sio3KySJzOKVaXPvxjQE/lDJYrr0MOyx8z0MEQtv7lrRrwpnJlUDMqaIWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBfBDwQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBfBDwQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F43C116B1;
	Tue,  2 Jul 2024 17:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940262;
	bh=MmfwdZdHXpUVv8Jhu1NJf6MQzS2ei8tV+WYLpYq6Lk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBfBDwQqMv0Ya59PEAw/Vg0bP/KHT2PouHxl/IE3Rcj3mjvYWhhAwu7WfGYE0SIw/
	 itImoeMY0+tmOT504nkyzAzzwCkm90cfkyv15hZiIG2daprLmqAJOpTK5E3/e7UszL
	 I6hIbZ4+x3KK8G00vFZkBUZkaDyNZXjth5KNy39Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Taube <jesse@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 101/222] RISC-V: fix vector insn load/store width mask
Date: Tue,  2 Jul 2024 19:02:19 +0200
Message-ID: <20240702170247.829150050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Taube <jesse@rivosinc.com>

[ Upstream commit 04a2aef59cfe192aa99020601d922359978cc72a ]

RVFDQ_FL_FS_WIDTH_MASK should be 3 bits [14-12], shifted down by 12 bits.
Replace GENMASK(3, 0) with GENMASK(2, 0).

Fixes: cd054837243b ("riscv: Allocate user's vector context in the first-use trap")
Signed-off-by: Jesse Taube <jesse@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20240606182800.415831-1-jesse@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/insn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 06e439eeef9ad..09fde95a5e8f7 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -145,7 +145,7 @@
 
 /* parts of opcode for RVF, RVD and RVQ */
 #define RVFDQ_FL_FS_WIDTH_OFF	12
-#define RVFDQ_FL_FS_WIDTH_MASK	GENMASK(3, 0)
+#define RVFDQ_FL_FS_WIDTH_MASK	GENMASK(2, 0)
 #define RVFDQ_FL_FS_WIDTH_W	2
 #define RVFDQ_FL_FS_WIDTH_D	3
 #define RVFDQ_LS_FS_WIDTH_Q	4
-- 
2.43.0



