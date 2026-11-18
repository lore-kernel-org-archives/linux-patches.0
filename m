Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047934;
	b=LKfPE6YilUoChsz2QwlNvRSJFR6lQZGouQ7UHe2I17qTOQsF4kWYvUL/Vs2wEGMLqPLG
	 fvUtcLhFTEYB3meYuVq3mICLhIBD6tmw9Sil8wuexZOQ/2fGVUNtG2zB2J8bWp9BQLRqY
	 vh1G/lP7ni3U188NU4a1Yn0lfOsa8AifhTyGpso6F/KwPZ9vfx3KcJmpIF0BAKQihPzq/
	 gXx7YsCpGg+Yqtc3H9hTle38J+5VLHhL0qQj7RCLiM9yfRRpPZ1F6e4s5og+zp8n9dlmO
	 l3ziJE/Lfu/jnFf7QiJYvgDRIYfOCCE+Yjrs31Fp6WvfF1K29oDxFPa/J33FHABeUig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2FYYPTLoOHmtsueskK1ida99FV3OMQVpyJVuWqzcJOg=;
	b=O/bnJG/qgrnN1hdKOj6sbt57Y7YXpuxKT5cczwn6Ya7poaYtKbUO7AKOlk4W6CcXp0ap
	 BWAfCLrg9FCUwqeHyAWLmz6VwSKwedAqvX+A5m5NHOkLa3/at2osxmSCIU7XUAUxjt2b8
	 09RByYRTQCWP+kO1K2SC+qDJZzwD8O1cyoWUbYjaLJfA4QZyrdH9nv/KXR3oQvAJuD1/S
	 OMoDJUAJqNzemwQxBx/VDD/HfwXme9IgXvdHax10WVLCRUMRQx8QDPow89YJxbuAw5up9
	 vjCBj8bOeLb0xppjdp34ZRKmRjmbCl3dcMezNn1Do0r76IosQ7L40N2o1UhgBDx45zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hq/UpONf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF2F606A320;
	Thu, 19 Nov 2026 00:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hq/UpONf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C51B1F000CD;
	Thu, 19 Nov 2026 00:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047934;
	bh=2FYYPTLoOHmtsueskK1ida99FV3OMQVpyJVuWqzcJOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hq/UpONfBj+YfCJzg9fBE3hgr36+ILvp5nd9/SbIvyl0upI+psZwVxia3Bz+JhCmE
	 KySWk7NCPyPQQ2kHi254C6rEqZM7k920VT4HjcTB3fRk1RwVEhHmx2g4DNG8puzLnZ
	 ye9tNoN9RgDuiFKHvtKTZwpiotU3F610cQWymvZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1774/2857] microblaze: prevent ptrace writes to MSR and pt_mode
Date: Wed, 18 Nov 2026 15:46:48 +0100
Message-ID: <20261118150305.151465760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



