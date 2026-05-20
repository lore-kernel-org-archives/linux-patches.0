Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71B2367B76;
	Wed, 20 May 2026 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294484; cv=none; b=NaqTkMwe6/Tt+cVgf+nJvR96fQaQpyMR5xnSiYgn1mvaXidxKdHkItr/3s0Wtbb+kDtaHfyEF4xzF8rHPzHdf9pLFpVC2R1NLEYseAkpd1ogC2n4+kXY8Zo44DisDOgVa4JPZbCU7KmFDX51P15c+LEm7p/5zSdfZOAC9MN5bjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294484; c=relaxed/simple;
	bh=/g7A0zA3FFvkrMQm/Mw1hs3kIPnjiDC3Bvto+NDMSpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RvsfYN2NBZxuApASu2LXJVOIvXZplyMCauqa97xhGIqCDPZptdu08e1yHBRBdLk/BQ5tRBOz6y9vgPYIv5mTOmU6TJVhaR/ADM2FtTGLVZJXr9axzelDdLSo+OtCxoJHyoW/RHOy4K+k1cXLU+CjH5KQ40JL4KMjtKnybIty/rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdgcVXBo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdgcVXBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC19B1F000E9;
	Wed, 20 May 2026 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294482;
	bh=YHcKJQ3M/EcvrppDM7HljBXHq1ig0qxVlX8zLxr7GOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdgcVXBoxhvH0hePg1vxhZgC7XgGBOl3o0ZNKyTXnW00lCKVYbM8YJoqgOGuo7hqp
	 IDlCC0gowuf1Kg5MXDKWYJ3+CssAl8tnYBbuvdnJVfBEZT17ZZHYvJhuP32cibI6V3
	 1OoUjq6cnezRn0YvWaDpMZr+OSGlbGcGgh+XJjBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0056/1146] sparc64: vdso: Link with -z noexecstack
Date: Wed, 20 May 2026 18:05:06 +0200
Message-ID: <20260520162149.638501162@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit acc4f131d5d57c2aa89db914aeb6f7bb0ab4eb4a ]

The vDSO stack does not need to be executable. Prevent the linker from
creating executable. For more background see commit ffcf9c5700e4 ("x86:
link vdso and boot with -z noexecstack --no-warn-rwx-segments").

Also prevent the following warning from the linker:
sparc64-linux-ld: warning: arch/sparc/vdso/vdso-note.o: missing .note.GNU-stack section implies executable stack
sparc64-linux-ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

Fixes: 9a08862a5d2e ("vDSO for sparc")
Suggested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Andreas Larsson <andreas@gaisler.com>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/lkml/20250707144726.4008707-1-arnd@kernel.org/
Link: https://patch.msgid.link/20260304-vdso-sparc64-generic-2-v6-4-d8eb3b0e1410@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/vdso/Makefile b/arch/sparc/vdso/Makefile
index 683b2d4082244..400529acd1c10 100644
--- a/arch/sparc/vdso/Makefile
+++ b/arch/sparc/vdso/Makefile
@@ -104,4 +104,4 @@ quiet_cmd_vdso = VDSO    $@
 		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
 		       -T $(filter %.lds,$^) $(filter %.o,$^)
 
-VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 -Bsymbolic --no-undefined
+VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 -Bsymbolic --no-undefined -z noexecstack
-- 
2.53.0



