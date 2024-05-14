Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A81CFB2;
	Tue, 14 May 2024 11:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687552; cv=none; b=aD8g3vZVDNChEkodJvQL89un9tAxslpw3NS0jkEZlAy6+nN/YdtLP4eUZZDvxz4DCUfFtkhii7RIhtZYpvwKqyVyUYaKXIiUClcHb4HPCUR2AFfFonwSvVBmaD3bmWiIjuuOLosgZ1hEjNZaj8GDXbaO6lZsnKWBIljU9a6GINY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687552; c=relaxed/simple;
	bh=ylIsmzbzM9t7YqO3HEnPQ+CZEwdA+eIyAO8nPAcyV8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3yBik950LAJgeCqi2jWNMYdPSCfpkXzB0pY+Tjj1UTCROvXRNw6kEa7Cax/GnBdRnbg2ukR03y1RtUkbC3FRhMngqB2wrZVtMjydhwdX9Gh1Ag/onaxIeyvpRPj2Pg8JSIQDmpw0bR4VpnoOtHrNvWgMVOLndnxyhIDfs93ETg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9ZbFOT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9ZbFOT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D6DC2BD10;
	Tue, 14 May 2024 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687552;
	bh=ylIsmzbzM9t7YqO3HEnPQ+CZEwdA+eIyAO8nPAcyV8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9ZbFOT+UB8e353oCTSQrLs4YgM8rtwd0HZ/ZaG3ch4WwHMAM9Q2ojeUKb820+tbX
	 ZbARBpcnDWV/mO4atFOsvw5aH+50VrWkV5JctdpYGmfAntICkRpPxFm4kNDiLsF3/g
	 pOaMBUcKXj5ycz+EQfPfyamRPx25UFBHhPSyz/Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/168] bpf, kconfig: Fix DEBUG_INFO_BTF_MODULES Kconfig definition
Date: Tue, 14 May 2024 12:18:42 +0200
Message-ID: <20240514101007.600335544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 28faea9b5da62..2025b624fbb67 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -319,7 +319,7 @@ config DEBUG_INFO_DWARF5
 endchoice # "DWARF version"
 
 config DEBUG_INFO_BTF
-	bool "Generate BTF typeinfo"
+	bool "Generate BTF type information"
 	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
 	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	help
@@ -331,7 +331,8 @@ config PAHOLE_HAS_SPLIT_BTF
 	def_bool PAHOLE_VERSION >= 119
 
 config DEBUG_INFO_BTF_MODULES
-	def_bool y
+	bool "Generate BTF type information for kernel modules"
+	default y
 	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
 	help
 	  Generate compact split BTF type information for kernel modules.
-- 
2.43.0



