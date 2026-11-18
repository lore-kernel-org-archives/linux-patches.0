Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054717;
	b=Og3js3Q1GS8sdTdOmf+cjYsHtJuHoiIkR7lx1JI+NvSQmf93fxG2iBa/690AglALwEOq
	 kOsRnHGd8Ov78hKI5nTmjElg2nfgFHDogw6oP91vOm3v3BscGrViYny6lqYD2iNmBiYvx
	 m02RrfH8vocMYawfj4qxWe1NPzf2AHrGGPhxLU2c0RjTMKpA/C1NwByyILZhipaezzU5U
	 5YhFNMm2TiaXr6NnA7bZEQjkNYAh2nCnwz6+tMdNizA9hDNfwVdo+2Q5LivEpzHgb3gec
	 12vpDh6Fuqqvfr51QtEHiAD87QOBYo78uLs08TYrUZFbzW9VdZiHL6cJt4LM+cKXVlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fUINW4mPtbvSquwo2et42s2F+b4hKZWUfEca2v5a60Y=;
	b=BY09tvjpwKxOWsbS/tufNwJGm0u8dVFNVIGYLP3lpR+Id5eD0P5EBurDviMaiKaZCwY8
	 H1iETX8ZVhgUqgz6ESQI6AXcagnriU1jEii46MHluk7gd57fsOknfat4cl+NUah8hsQh8
	 eMR8EJMnKo9hU0pTrB+dw258MZX4PAHwdML4cBvmdi5E3eaHQYcZRNIJjkC30O5RYOD2B
	 0OizsQPTOUEM0jGtuAst2vVtAtb79tD5jyq9NDYZKOR9y43KHuzTnqczy55l/3uJjpx+G
	 rR1EUSkFuIhL9P2dr2tga2X1mYS7rQgNXbHk76V6XkLUgZ+h4iYQtjXm0OeAEvF5Y3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJb6H+ug;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF87A606A31C;
	Thu, 19 Nov 2026 02:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJb6H+ug
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350C11F000C4;
	Thu, 19 Nov 2026 02:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054717;
	bh=fUINW4mPtbvSquwo2et42s2F+b4hKZWUfEca2v5a60Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJb6H+ugQbgHO/A51dcJBlddL7G0FHtmHD1WM3YUqasbjbq6sdF2p9InQEXP3S5ZO
	 pnXpC+D/DEoy5vrRxetB2LQ8oc9OBc3bkSnPDPNspMxXuCIariXkW9q280Txm4ZhD9
	 4j2GeRMoKsSqioazWIqOAm/YAJxL8Cid5Mg35+Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1372/2214] microblaze: prevent ptrace writes to MSR and pt_mode
Date: Wed, 18 Nov 2026 15:50:48 +0100
Message-ID: <20261118150106.299868532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



