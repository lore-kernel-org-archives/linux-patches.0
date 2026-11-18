Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060432;
	b=2mnMI7jRat1Tic5r7Pn36aX5+EObVVjk+Zq/2mSy5gfBGjpSi+6sJFujiAhV9esGlxtu
	 ls/Fh5DzD2ONPDgOaBRZNlmxIsfAV6G0QK/ELBbwUVD27IJqLeAaHNhHnfvAenF04ke6F
	 ZNO0pLTWDDaqo6zR4Kmh+lkeUEomK8ob41RSnBr3hDLU6wX5/PbQaHJrgsT5WugE1gx8+
	 Fqu7qaMnVWh4QBRFqz6Hw//P3fBZV/FXhC1RUlq/49yE+urxqi2/9n5aSRwUDzPk8iXXV
	 DIDePDPW4PCsBzdzrNuvVmwjznwuUjSkxFzh6C7pefXiziH63x0jb/DrKIpfjrm5LEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/C5jhnC6ZHlQNtGQP2sxNzr71cPyoS6iMpe1OW5enJs=;
	b=cWLWnyxu0u5HuyN4RESBWw2gYRc78K6KTVHxIQwdp3n0+//ok9Y/VcqQHd9vdkczpyvY
	 LByauDTRP9PbqJ6mwB6nG6mlCaO+cOqkJXTHa3W4CIQLEzVyi0mPBEmEHUFbqJMNRFEVp
	 eov4cld/VJrdXtfklj+uLv8J0cjbr1ynDWItTOq/GfoFj1wBpQP6SQnjVazViiobOZd+D
	 +LIvX9MfGLJMW1TDvwftMSY51MGzaWg+rH+qAbl/ThCvD8GCzh0t2IffE2Z1YPGuq2DCB
	 kA7s6hVdyni4MJ2GNACjtpLbapKA2nqRqUnEvFt1Q7SlSeP9EOmP1t7lDDpQ5OOcBUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2wzuVVX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2CA606A32A;
	Thu, 19 Nov 2026 03:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2wzuVVX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDCB1F000C4;
	Thu, 19 Nov 2026 03:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060432;
	bh=/C5jhnC6ZHlQNtGQP2sxNzr71cPyoS6iMpe1OW5enJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2wzuVVXDJTI5hY01E4dMh9bQPG3GMHL36wXkM9ySCbVdMdL9oFkaI1pOYw97Wdii
	 BmhcXLG76TvmV13cc88dVoTL4f4DKTjpsbr6Gvfd7c4fNZol8U/pchKuoRT/CWl6fh
	 0PFoqtiwHdFKwq0fJlxurJVxCp6XBdDeOM2ui1fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1156/1848] microblaze: prevent ptrace writes to MSR and pt_mode
Date: Wed, 18 Nov 2026 15:53:14 +0100
Message-ID: <20261118150008.119914576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index badd286882ae6..e6b6b1983e2d5 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -102,6 +102,9 @@ long arch_ptrace(struct task_struct *child, long request,
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



