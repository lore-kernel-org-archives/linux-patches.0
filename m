Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B2241A795;
	Sat, 12 Sep 2026 13:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219445; cv=none; b=Mh9UvLVJj07ZupLH7Oqq4s3G+RBTB9fHa6+cVtzoEdrt7hXOAs/hxMs5RjLVAE3Wi78iS937avsJYoMEgpuO5LvlDxAZGR9UcWTGmau2TfXpGZPLN0mdZtcyg/5nHuL5mMdMwDUZUbuVcyeTmLM5NtRn4/hbqsblwNp9yia0iRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219445; c=relaxed/simple;
	bh=zqoxM2xuyACHVxKtr1RN1O7tw+Xha61O9OdjafRBQes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jvpgZmcg6JUpLS3MjrrI8dgNKTBgSFOD0/pBRpZxyRTg+KnGGubvG2NUpto+53tjri9OIP9eWI6DmgsVcxJoSZGOZQeCGVYCigeSWtcKupcXrNaUFBh3pL9Byq/Lcz+Cpd5V+mUuXHENQxSJ81SfgIOhGG+tE2LWCFea4PrmV0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abGMW2bX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abGMW2bX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD9C1F000FF;
	Sat, 12 Sep 2026 13:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219444;
	bh=K2c9G4GsBrFfOtXpfK8jiSI7QOL/yhvI3B14NG7BkB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abGMW2bXtViEcHHO7/W0+0965/S3DmRKZuaXpzehstylx7K5R26G59KJWPbpWrT0G
	 xrQhUNx3b+New7jYzgALTzktf0bpq5BfFnJ/MCFgSWGJGrgLkfJxJhHB3DrOqCul8O
	 l3RmKZ+uXZMhryXKYpnezVblBAHZ4sZQCxt1s75s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1353/1376] powerpc/vdso: Remove unused clockmode asm offsets
Date: Sat, 12 Sep 2026 09:02:59 +0200
Message-ID: <20260912065637.688834048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit d7a82238cb8c77d4ed8cc97cd556c5f3e64bc749 ]

These offsets are not used anymore, delete them.

Fixes: c39b1dcf055d ("powerpc/vdso: Add a page for non-time data")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241113-vdso-powerpc-asm-offsets-v1-1-3f7e589f090d@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/asm-offsets.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index cbeeda45c00a2..757ba2a3d4c88 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -348,8 +348,6 @@ int main(void)
 #else
 	OFFSET(CFG_SYSCALL_MAP32, vdso_arch_data, syscall_map);
 #endif
-	OFFSET(VDSO_CLOCKMODE_OFFSET, vdso_arch_data, data[0].clock_mode);
-	DEFINE(VDSO_CLOCKMODE_TIMENS, VDSO_CLOCKMODE_TIMENS);
 
 #ifdef CONFIG_BUG
 	DEFINE(BUG_ENTRY_SIZE, sizeof(struct bug_entry));
-- 
2.53.0



