Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C615E1CAA4;
	Tue, 14 May 2024 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686156; cv=none; b=nM60AhwiTuTin2Gg4cZdT5dQ2rsRusa9glQhB0wbEv9SoZiB9T/3Bkn2D0EGxDwtxDxg3+VA0k+sy6Y7tgHJdicmatnjEwyaJV59ncMpZrngk+ElnV0ie6SCvaGdkSsDNmcoqdxT3tT76EDbLa6EWK977YZu4QbtcqfJk4Yt6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686156; c=relaxed/simple;
	bh=nQIhzQaKTkH2MP48qDWDZUb4NkdpUc3hX8S+JArKNOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RS0zLopeFEqo1fmKeeJid+ha24tVuYogMF/x5HDv01LrxWaLWKYjsogBXrGmf3fKYNj1JRB6w1YfNVKOLOidOtqtUkZ3Mw64kCw260/4eJDK+WA75qmcf5PLHXGT1oHwjo1BNkt76+aIhpB+6jELLSvRhqF4Sfo9I5SUgRM9iPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AeDiH88M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AeDiH88M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCAFC2BD10;
	Tue, 14 May 2024 11:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686156;
	bh=nQIhzQaKTkH2MP48qDWDZUb4NkdpUc3hX8S+JArKNOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AeDiH88M5IUjlecBJxjEhBPEdhZocpvv0MpALvtaXHVigGZRP1LE0F8+VBV609saA
	 fGym6klMhpY+TTkDT+aZXft+jwev9CA/SFVNYHjzF/dFWxFLiaiIi81KtK7ZhQara0
	 JgKvRkVnsos8/Tgy6zMITJ7jR0CeXZq3d26taIDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/236] bpf, kconfig: Fix DEBUG_INFO_BTF_MODULES Kconfig definition
Date: Tue, 14 May 2024 12:16:42 +0200
Message-ID: <20240514101021.864646108@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 95541b99aa8ea..b2dff19358938 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -343,7 +343,7 @@ config DEBUG_INFO_SPLIT
 	  Incompatible with older versions of ccache.
 
 config DEBUG_INFO_BTF
-	bool "Generate BTF typeinfo"
+	bool "Generate BTF type information"
 	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
 	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	depends on BPF_SYSCALL
@@ -374,7 +374,8 @@ config PAHOLE_HAS_LANG_EXCLUDE
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



