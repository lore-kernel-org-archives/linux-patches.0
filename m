Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EADC36A376;
	Wed, 20 May 2026 17:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297485; cv=none; b=PauDWFUIF7f/fewKxcfhb9XwSWpKSzzxmQ2HXooABpCP6rtesJ5i7uBNT9QH0ZHZQAua2AIlHF/VOzyIiJkawuv44vznizCZ5veDKjG3iTDwcRhjEMMY+Oh7mpedf3PHwAqDDFMcyy6ttQTYe5EcyiiBecWO2U+NBfvSqY5zsJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297485; c=relaxed/simple;
	bh=/JwOkqPz4/pNru3Bx3EOJbaIscCq7iRma0VIrE4w2Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A5lGZOdSzVERcNpzgkGOUAkc1aI/8zSTCC80CNz2QqUJ/iQ9aQN5TF3R9/5bNuFqCiF78Uahj4rfc3ncX7UUHmtLpdF7IGo/ZusCR69JsigiPgokgb8u+M7iz18+hMGqmN9/dkiT+oVNX4un/WksmSWdn04l+Xq/5YaJjSgBo0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/KSFjis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/KSFjis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911121F000E9;
	Wed, 20 May 2026 17:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297484;
	bh=1d6nuZAG4mInZGnoBHmdlKsBQdMobxpbxnEZ9Fs/SwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/KSFjiszYd+ZYLCF18uURY+2AwAULlFs2f4WGiS4ZNPSf0GF2W5oumY9G/srsUlO
	 ZSQUkuFQlQQ/nEXoE9ASaUJJWhzMo42C7UuEWE+zfs37LJeiy3VbNcwLKdJxozlzYn
	 CSC6w5v+fs64HuAALCjTybYRrt0SDBui7npooUzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/957] x86/vdso: Clean up remnants of VDSO32_NOTE_MASK
Date: Wed, 20 May 2026 18:08:53 +0200
Message-ID: <20260520162135.644162696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 6517f293b2c6774d21b6e7e26a55fae60c6ec4cf ]

VDSO32_NOTE_MASK is not used or provided anymore, remove it.

Fixes: a13f2ef168cb ("x86/xen: remove 32-bit Xen PV guest support")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260330-vdso-x86-vdso32_note_mask-v1-1-2f5c473327bf@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/vdso2c.c | 1 -
 arch/x86/include/asm/vdso.h  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso2c.c b/arch/x86/entry/vdso/vdso2c.c
index f84e8f8fa5fe6..b8a555763f437 100644
--- a/arch/x86/entry/vdso/vdso2c.c
+++ b/arch/x86/entry/vdso/vdso2c.c
@@ -75,7 +75,6 @@ struct vdso_sym {
 };
 
 struct vdso_sym required_syms[] = {
-	{"VDSO32_NOTE_MASK", true},
 	{"__kernel_vsyscall", true},
 	{"__kernel_sigreturn", true},
 	{"__kernel_rt_sigreturn", true},
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index b7253ef3205a6..7bc290ae99334 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -18,7 +18,6 @@ struct vdso_image {
 	unsigned long extable_base, extable_len;
 	const void *extable;
 
-	long sym_VDSO32_NOTE_MASK;
 	long sym___kernel_sigreturn;
 	long sym___kernel_rt_sigreturn;
 	long sym___kernel_vsyscall;
-- 
2.53.0



