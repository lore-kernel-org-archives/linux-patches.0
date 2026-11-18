Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023082;
	b=N1HQRIY9Y5FRRc/i46LkR7qmS/d6L3tmUMR05cnXnkxn2YO/AVJWlh5cVkwnnFX6UusA
	 rYrgeHA94NyiPu3Y5glAv0iQvX7wNLFISzrq2syH1nSoA5CWVcEEbEGn0TNpYugmBLYPX
	 +yr+4gm6YW5KCpqydROSxqZk0ZXjpFRSTmbEXlWjQ1fwhLw3Xd7vkuhK/mNd/sJOpmQeY
	 0r5o7qY1FK4QwxciG5q7NuYvSkJR0cKqH7UpR96oVtkjwjnchUtkDmuMzvz7yUoFRMTR8
	 vTnENAMI/s1L4FMK26M3NiVgn57giQ6LeKo1UmKu0Ufg8gr+uGqzz18F4eX6XW1qw6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TggVuf1tlo+pSySVxAv9q5RnLZYiYwoycm9PT1oQ3bI=;
	b=zZWIbMVuqGUsfj9z70ZqlnNa9erAEyyj4lyZf4/NmfKWoKfPKQdCcbcoaG0d3xwlAP1o
	 A/OAxO9p/mLHaDuX+fatp8hygqXSwKYUsjpLcoqafdrkgjBo89rcAyvtFx7hK8zMBqUUf
	 W1fzv8JRcAOp8O0TpTKU47aNltHYWljsWTawxDsSJmLKuube4OdF2JneF6o2rffCJi1iy
	 OP8KL+PWiWL7+FevRbJ3B2g+E13k7ue0zzqsyhU1H/ZXnAWDdcxtgvoqsrihZ1KzRMJzf
	 MTVntPdtvGCHWC/p/dLueLOqiFSPgBr/UNtuFxhoJSGbkdz53nBNSQh4bVI8iEj/TMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6Zv2jqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E4F606A32A;
	Wed, 18 Nov 2026 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6Zv2jqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D67C1F000C4;
	Wed, 18 Nov 2026 17:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023081;
	bh=TggVuf1tlo+pSySVxAv9q5RnLZYiYwoycm9PT1oQ3bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6Zv2jqTDOQ2j/9dIbGTROVsKrzp/kWtZwp4vxQ3IBxu8yxhoXwA9B6t/kTUWXOtL
	 4ORVNwmypp9yqNcPhRdMM4YzziX1J+snhWvT6MWvgkyAPfTJEQrQzmo0dcc3PPvId4
	 9AAr1vyRiOdCFHOItLHspeXDxBklPWwY+t7BcWsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0191/2151] microblaze: prevent ptrace writes to MSR and pt_mode
Date: Wed, 18 Nov 2026 15:32:06 +0100
Message-ID: <20261118150128.740244020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



