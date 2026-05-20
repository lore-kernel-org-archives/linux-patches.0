Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E47933F59D;
	Wed, 20 May 2026 17:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297578; cv=none; b=eRev9g0t/Q77jcuczLhqRDlCK5aU3APg537C8slhd8MQ4JFt+sN++/cLFV0nLODG/9zUhHmo7FvUQJoo0QhsSbNIklYbb0zgGzDSJ2nrTBGFrAyklIfgNKxp6/tSob5KAPl4blAS+RJirjsk9aNIBXJkiHudiivE0Bv31+dzONg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297578; c=relaxed/simple;
	bh=DaNKw0U2txq5oLpo2vjOZZ48dzJln7MVAXdjws3FPp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ad3Jo0DNk0881SlGF6KblaFwJKiVXCICJEhD1JN9XaS9DwxSG/+543OOZv2UqTR3i2KiBTR73o4RRQOO376X/zxYZsJVpECtHHsX/LXfqeZBiBH9vob4F0woa+g2gbHLrmPH2VWvt1Qw/EBQbumgnJsafGfYygrB4MDiMClIpDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6xYjFuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6xYjFuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5561F000E9;
	Wed, 20 May 2026 17:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297577;
	bh=YYX9EtD2sXZG1qVTfDRyxGfzZPIy6mYYwwBy6Kmcpv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6xYjFuOYVtdEbsWI7mHu2POypdh2uIVqt5bsOfz2SfuXD4AuDCAbKZwHBpqgZTX1
	 c0xdkPLlcPJvcTHUoH8UYWKcZATtDyGJIpLYYp7N/ptTkQFUWzgU3bMrgX0hUzeyY/
	 //f9+Y/GSd83VrRwP6O5LB8MT+f3TtsyvZw6DR2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/957] sparc64: vdso: Link with -z noexecstack
Date: Wed, 20 May 2026 18:08:45 +0200
Message-ID: <20260520162135.472036995@linuxfoundation.org>
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



