Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015364;
	b=u0UOpkpy17i+WE0F98fq75AfzAsGlVypzy15enEJvS3cZbF6tLVbsivhfYTvbIG2G5RW
	 DwEyX3GzAhtXcFYB7Odkgsey1lmrJoMUPvXd2vpMus7zgp2hi9JlRAQPCpn/MoZBWNeMY
	 U5gKd+3p8Xkj4r/kL3wb6xHKsaQO2tWnqNPfuS16LsEgjy/efSjW8gMYI1NMPUmF3Y4ty
	 mbDwZ+t2pz6of3zTThjMOeBtlR6l+LfE46T9iRbmxqrJRNfQD1CX010/oMf9GnmCMbbvY
	 liQn0n+fiVVy5CmJIaGA4pouIh6Sfe2YIrLMwHPVS+QuZK2gmKHswj29RDW6J7nfelw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yiEHHEaItvsf1oTeIpD1UKMOq1mR1ub+GqKkwfuDsTo=;
	b=L4h8IjQBcSOzcEu33Lud6+F9U9pRxrvjW540N6JRe9bu6LTqejIIy+Ihw5rHzwsNYvAf
	 IuAO5qJelMhjGAkPZQwLJWUPnK08Mz8mYNhNKii4vw12DbYrnNwcaVR8zXBwATyIXa5Wh
	 bODwT5POFoaeQ7iJfr58+uZm9FY83zzqNUUfEkC8CnZeoRALZNAfxQd+m6c6BUwA0xs4i
	 Y0VEBquVC0Ua5pyAQeZ+V+nZ+yo0eU+ZWH4IaVUUq+r9AwJKjEutRJeqYdQdjWrVvmRLo
	 RuqpENur3MxjbsYHlWC7aw3ZqRKuXfDxdPb2SVj3iuWwE0nectC4vYOiCRFp7zrGxUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnxwtbJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A46606A330;
	Wed, 18 Nov 2026 15:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnxwtbJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5F31F000C5;
	Wed, 18 Nov 2026 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015364;
	bh=yiEHHEaItvsf1oTeIpD1UKMOq1mR1ub+GqKkwfuDsTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnxwtbJyIjLxxJe2zeuW39XciIwS/UHD7F40rpdRavTE/ymWfIXZw8PUgTCyKYfBW
	 moTLsIXiXgegG54rmjWt5mbJVejB7W4FLSzNjLFWJfqyCzl6BM4cOFk2fXtGTazwnA
	 vYx/GLE4FgrSAYioqyichnC6WeFMGxWyduXCbzUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0146/2651] microblaze: prevent ptrace writes to MSR and pt_mode
Date: Wed, 18 Nov 2026 15:23:06 +0100
Message-ID: <20261118150253.108322203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 8518fd17ccef4a7d77877ccb0403b722106ad1a4 ]

arch_ptrace() accepts PTRACE_POKEUSR for every aligned offset below
PT_SIZE. This includes the saved machine status register and pt_mode,
which are kernel-owned execution state rather than general registers.

On return from an exception, rtbd copies MSR_UMS to the live MSR_UM bit.
An unprivileged same-UID tracer can therefore clear MSR_UMS in its
tracee's saved register frame and make the tracee resume in supervisor
mode. pt_mode also controls whether later entry paths classify the frame
as kernel or user state.

Reject PTRACE_POKEUSR writes to both fields while retaining read access.

Fixes: 2b4384542691 ("microblaze_v8: ptrace support")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/20260821103026.3627292-2-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/ptrace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index 236264e932d64..ac1f0503216b4 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -101,6 +101,9 @@ long arch_ptrace(struct task_struct *child, long request,
 			} else {
 				rval = -EIO;
 			}
+		} else if (request == PTRACE_POKEUSR &&
+			   (addr == PT_MSR || addr == PT_MODE)) {
+			rval = -EIO;
 		} else if (addr < PT_SIZE && (addr & 0x3) == 0) {
 			microblaze_reg_t *reg_addr = reg_save_addr(addr, child);
 			if (request == PTRACE_PEEKUSR)
-- 
2.53.0



