Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD25054903;
	Tue, 14 May 2024 11:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684589; cv=none; b=kBano+Rp3VkNJwJqSK3lzjhJXqij+ArJlJhcId+F3NXmxkQyK5pp6YTZV6NDnTgYCEbAEdjlIRZS8Jm7uE1lJt4HsMp+ANSWMF0P08pSR/mxKjLYzBLWI7G8Bp7/dmmDOX8xU115/FiXGFkkYs5qjhs9VzdfTcGOO5tYi0S7gPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684589; c=relaxed/simple;
	bh=yw88Ws9uKRj4wpE889Xrk5bR0IgDJnTCC+4JiKdlWmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz/Q3h2WpcpxVfdFLvV/JlNXMAtRuMlKlCIyR72likmqBm2CL3Kg544ta+X0dfDoPz9c9WEbG9o4GAqNC72Px8bFIpF0g6ycgiUvMANgUVnE9SqsrAWOKIvLAiNbRRblY7JhTfpauXalxCC6nnw2WMxAUDgdRL/5Qi0m5HS6qTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkmphVAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkmphVAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04AAC2BD10;
	Tue, 14 May 2024 11:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684588;
	bh=yw88Ws9uKRj4wpE889Xrk5bR0IgDJnTCC+4JiKdlWmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkmphVAgeDg0xQmW2ADX9dKVhLxhYLEAbdPRFmvnlY8dabax8nfXyJAx5ogNIDMnB
	 nzZhyLhxiyu6MS6zzWWMk4qjLYXErqN6cUqMXfrrUQ26GgN3vmcuGPL6w9IfkfmtsJ
	 AFLggHnef4+ZxTNXzIr3dTRociHjm+zxQjfewoTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/301] bpf, kconfig: Fix DEBUG_INFO_BTF_MODULES Kconfig definition
Date: Tue, 14 May 2024 12:14:59 +0200
Message-ID: <20240514101033.308555632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 229087f6f1dc2d0c38feba805770f28529980ec0 ]

Turns out that due to CONFIG_DEBUG_INFO_BTF_MODULES not having an
explicitly specified "menu item name" in Kconfig, it's basically
impossible to turn it off (see [0]).

This patch fixes the issue by defining menu name for
CONFIG_DEBUG_INFO_BTF_MODULES, which makes it actually adjustable
and independent of CONFIG_DEBUG_INFO_BTF, in the sense that one can
have DEBUG_INFO_BTF=y and DEBUG_INFO_BTF_MODULES=n.

We still keep it as defaulting to Y, of course.

Fixes: 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole supports it")
Reported-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/CAK3+h2xiFfzQ9UXf56nrRRP=p1+iUxGoEP5B+aq9MDT5jLXDSg@mail.gmail.com [0]
Link: https://lore.kernel.org/bpf/20240404220344.3879270-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d2f73bb4121b0..da5513cfc1258 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -373,7 +373,7 @@ config DEBUG_INFO_SPLIT
 	  Incompatible with older versions of ccache.
 
 config DEBUG_INFO_BTF
-	bool "Generate BTF typeinfo"
+	bool "Generate BTF type information"
 	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
 	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	depends on BPF_SYSCALL
@@ -404,7 +404,8 @@ config PAHOLE_HAS_LANG_EXCLUDE
 	  using DEBUG_INFO_BTF_MODULES.
 
 config DEBUG_INFO_BTF_MODULES
-	def_bool y
+	bool "Generate BTF type information for kernel modules"
+	default y
 	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
 	help
 	  Generate compact split BTF type information for kernel modules.
-- 
2.43.0



