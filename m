Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029005;
	b=0oEzgeTKS2MS5ZvdPQQtC4ZGGVhLGtWgpbYE7bLCQCBqDISFBLM0MDKxb9a5ga2j5yzf
	 FyzM7G7vWTsjAW3PCpYfk9nyKX8GgXOh9jMBYEmGWaG4IsO8BTqH6On/DtEbmcg9oVCvX
	 BaSLFimvYkoFe3E5TClpnloMdofxMpACdGlaDOvEogMz3eyx3TfCs2BCMYiU8qnuaIfJW
	 eZzaF3HZVuPNLVKdg/Ae8VcRLeavqAeDBmYF95nBRKhSnZN/Le8VhZPPpHvuQ+XXG4DyP
	 RDFY5Kd9xGoMD879EMt/a4/lHqXGsW1UZgY9kqrhFPRHB4ZfEqYyKiILmsdyeKayqGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8FQwAIq7tmPFQFZw88VmyKFO03Czdds/zely0+2siEY=;
	b=Xo9vIOmP3/2EiFXWC1uToJ2JVe0IOy5q8/iQC54H7fpdJP427apVPmvEUkNBdhTZJG3F
	 RYXLUvSTbXjUYP6mJ51WB+nWBqV28kNEfJESzeepF9ECRsoqvDBQSYYqKIfGJHvsNIjz9
	 aEbXQELpJk0u7gxKNlTeGFHdzrH3T4/dxh8Uoh73+loN1xQIXYypDakYBOE8itH+sVjuX
	 XZG5wdjYxngu6k/UMQKsnOgasNCXcc++YdocRwiAAu8B/6pJ58ptogCYnKsldXXj7B/xG
	 wOoWAhx0ay2MNkKdJZ7sBAYPl2BYIlSlh3f5DO/NTjEnZq7vUfAjDmXq2P4cCs4bW8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAgjzbIt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40018606A32A;
	Wed, 18 Nov 2026 19:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAgjzbIt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BF91F000C4;
	Wed, 18 Nov 2026 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029004;
	bh=8FQwAIq7tmPFQFZw88VmyKFO03Czdds/zely0+2siEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAgjzbItHyWu+DrrptThc51gAuKZCRVfdebY0EuD2MThs8ZqZdHsu3fVtlzHQM3Oc
	 vXogcgg96EZAmSzYCfRibKytZvLZOSAaJs+En3G6X4GEHvZDRuUjoo2g+L2y5Fagli
	 DtgH81uJhaVyZ+B8iW6OkQZ03fukfoHFi+X/tRM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0195/1756] microblaze: prevent ptrace writes to MSR and pt_mode
Date: Wed, 18 Nov 2026 15:38:42 +0100
Message-ID: <20261118150016.158604033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5234d0c1dcaad..04700b08842e2 100644
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



