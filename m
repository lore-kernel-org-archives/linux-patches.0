Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039250;
	b=ZRWs6InYjsE7iJxKw8blrvuwpfiU3PQMS8Ii0YApYpmAoV6ZOVp2vt6OWK+ujpZJ+0Ul
	 C14x04zVf+Vd5uV2Qo2S+lw5yZP4a8lzAjgSBEDbVXQxVRj8D+oGnoOg7yjgo37+Znnzb
	 rLhDbUPRleg7Jn6lJ30ZDgEk6NDfOkIgv9xvnshmupgRZvSZud3dRV4JRU30VKKQF4PzD
	 k06++LRJyeHAy2gNySMORvYyeODgwM8LGza6EBf8QFMhj3sCHYR6QbXtkEE9ue3ahD9Ey
	 fakp6ntopPBa1xGEheujOWMhs3f2RQOb7SQ/HCHc1kJhNqp6TDGlM2Vhb3Ss9xbu59w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LD0MmDqeB/UyvLQga0k/Ou5CSxgyQrGspaoGbFCQX7Y=;
	b=ioIZULLVe0sDW/7ZEv2OCnk5xwI5RNn/06ENAgKkS6cyqTnAgAPV7yqpflCboh1hwpG1
	 h4N118TGkSjXgo6DLzIJb/DRL+we3oEBeW1BTJGxxHimFWz3qZs0+BPlKFgrodklqHOw0
	 4QAFhhYZKdQtJl3IQGQYtpsj8xy5oRALDVcAk3Ss8WbZy+FUWMyCN68UVna9xSoT7HCUp
	 37+dXdQwCblmdxy3oLgj2WM8tWsBQFinDQPIeew6oqal7EiTHVxjCUH7CQHBOuD5KBRuc
	 Tddt9RS9qdPVeCxoattzEkH+HyC3BXi9/rzRuQDOY7iCtYeDS3Qk3sWJhvMpgciCVVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h23nga2X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F21C606A325;
	Wed, 18 Nov 2026 22:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h23nga2X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB5D1F000C4;
	Wed, 18 Nov 2026 22:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039250;
	bh=LD0MmDqeB/UyvLQga0k/Ou5CSxgyQrGspaoGbFCQX7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h23nga2XaTh2c5TJdu8FxeV6KWeYTFZYst1UoSQH8A7URU83Msa96Vgrja6pwsglD
	 caHVrpzHtGMf8tUasipo/KaL04rZ4tbGCmL8M6S9NUezRmQVwBz7jbkSsOqXM5BZo8
	 /4lYvuwQPAZkojOpXB6j6LeQGzunwKjwSXrsZUCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2033/3318] microblaze: prevent ptrace writes to MSR and pt_mode
Date: Wed, 18 Nov 2026 15:44:15 +0100
Message-ID: <20261118150423.032198370@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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



