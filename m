Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70ED242D65;
	Sat, 12 Sep 2026 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227039; cv=none; b=oPZD3jIdOrnPLwNQnGtenEcweuLqOlvH3KA/M5oiNP0y3Z9gZ5mu3aIfzbP7lVQnGWus5fkUS/xjzZ1IHto3F6/nSTv0+MvbGUhC3pE2foP2JxmzBEEfBAtcTj1XhEOWv5lOBD7y8YPWn4dpokuUF5I4sdkG6YbMMkbPSHdsOos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227039; c=relaxed/simple;
	bh=HcLcsbUjbHj0Q+fuWIFcwwqPl9mlzewhZy/xMudvRZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kbh9aTjbJSYIf7dWnyGJEfvWomREotxsdVYb6GMfqsH8vB3je9NT7ZF6ZGpQtOJRdtWmdsFa3CW++2Ju+MJRPnhrArNz0O1LaN9iOM5ahEV3ddCM4P7/fzHYRsvfP3I6zlNS7WrvpPchvzvjnOdJzxwACDd7bYBonR40Hc9/p78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNFcDqui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNFcDqui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BFF1F000FF;
	Sat, 12 Sep 2026 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227038;
	bh=GRq3gVpbEAu89rh/6OB52g82SNTNDUjfxDVc4xwHGYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNFcDquiaI/y8zodY8eKiobw5QRYH6iXtzMTU6g6U7+uiPYb0JAlnU6cZnhc+mLfK
	 cKp6KUI0Qdzknz3s0193r7tk4/bpqJt+7zS7ZxRL024fn8C23vg4Bt1NL+FSJj1ad6
	 TyQJ0PUKu7toAswoy7bs+qS87ChhhT7HxUQ4XNoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.1 0097/1191] ARM: 9477/1: Disable broken eBPF JIT on the Risc PC
Date: Sat, 12 Sep 2026 08:47:05 +0200
Message-ID: <20260912065550.357745611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit 7e8ee82e69fde9d589272ec5e6f702358903be1f upstream.

The eBPF JIT unconditionally generates ldrh/strh instructions, which do
not function correctly on the Risc PC because its bus is unable to
signal half-word accesses. Work around this issue by disabling the eBPF
JIT when building for ARMv3 (the Risc PC is the only currently
supported machine whose kernel is built for ARMv3).

Comments from Ethan Nelson-Moore:

 From LKML: https://lore.kernel.org/all/CAD++jL=0qYGoygUwGEXQL7C_ROnC7kfpRv8RA+H5tNWwYu+pQA@mail.gmail.com/

 The commit message has been updated slightly relative to the version on LKML to clarify that the Risc PC is not actually ARMv3.

Fixes: 39c13c204bb1 ("arm: eBPF JIT compiler")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -84,7 +84,7 @@ config ARM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
 	select HAVE_ARM_SMCCC if CPU_V7
-	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
+	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32 && !CPU_32v3
 	select HAVE_CONTEXT_TRACKING_USER
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_BUILDTIME_MCOUNT_SORT


