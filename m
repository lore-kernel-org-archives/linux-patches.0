Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE181E8332;
	Tue, 17 Jun 2025 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174388; cv=none; b=OvDJxe1rV0+3rX26SN3idhtpRxu8YifpoYa0oYZ+4K6ovtb4LrBduF7fStJeu/Hf4XsqReWjRE90OER77zkeN8ift5ZB8vEkiQbpHSrhYcmqTjC6FXET3hGsaxwFnYWf5uAnh9obU3bHL0ErhsZ6KqaLaoUqTX3dm6PySLVxXXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174388; c=relaxed/simple;
	bh=Tx3ulia7fbdccmfBwdY2vsUDLyPRlfGzVEETYB5h/qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU3K3YjzAkSLzAYVqnTcvJKX9Z/rNrEGE022/mG1Lc3a3/ohRqrLMEXJLa5AUHrbvuYYtdrWSn94TMSXg14GrRViIkj/UyOzUnZUhJZNpHWIGhBN+qL5q6T1ZjRa3R/ObkgiEQGkbeamBXVnrQdEV9CcuTM8/Ri+sqRPPBgwoMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx8zbcwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx8zbcwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E605DC4CEF4;
	Tue, 17 Jun 2025 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174388;
	bh=Tx3ulia7fbdccmfBwdY2vsUDLyPRlfGzVEETYB5h/qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx8zbcwKMTLQN0HClCRTdGmiY4VqxpitIUh+y2VhfRA69+olJAmNBwTEVp7vBjykb
	 wy5cbdc+828Dk4KHr+bmCwnbLTh9W3oOiu+6qvI0416cW9bu8WN1ObZhvrrQYPF9YJ
	 CPB/bDcEUoo6k4AIuHwIz/GKwRPgK6dBXnlgEMZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/512] powerpc: do not build ppc_save_regs.o always
Date: Tue, 17 Jun 2025 17:19:38 +0200
Message-ID: <20250617152420.024211244@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 497b7794aef03d525a5be05ae78dd7137c6861a5 ]

The Fixes commit below tried to add CONFIG_PPC_BOOK3S to one of the
conditions to enable the build of ppc_save_regs.o. But it failed to do
so, in fact. The commit omitted to add a dollar sign.

Therefore, ppc_save_regs.o is built always these days (as
"(CONFIG_PPC_BOOK3S)" is never an empty string).

Fix this by adding the missing dollar sign.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Fixes: fc2a5a6161a2 ("powerpc/64s: ppc_save_regs is now needed for all 64s builds")
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250417105305.397128-1-jirislaby@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index f43c1198768c6..b4006a4a11216 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -162,7 +162,7 @@ endif
 
 obj64-$(CONFIG_PPC_TRANSACTIONAL_MEM)	+= tm.o
 
-ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE)(CONFIG_PPC_BOOK3S),)
+ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE)$(CONFIG_PPC_BOOK3S),)
 obj-y				+= ppc_save_regs.o
 endif
 
-- 
2.39.5



