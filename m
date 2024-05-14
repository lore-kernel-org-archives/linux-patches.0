Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77431433BE;
	Tue, 14 May 2024 10:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682185; cv=none; b=Q0QkIiZFYCcCWDKTq0vOOTuIEHFzIUpns1PSQyEINxWBU8GYtyvAdM+SyzrmiyVayez/fxrhUZfV84StR3Wmx0kGXqSdsnY3UvXC6XCp1CyUsrFhErNJsqSEoo9t4O6h9kH7ibzjh1IgYynmsqrpjhoU4hUO7tT4Tvg8dgnMdQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682185; c=relaxed/simple;
	bh=sVu2m8TyWS6UgrapaGe1r82uXUbCyjKtGJ+L6cYh44U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOEHrMZ7LvtWZWfNZDh3CJjbSnV8kmkYqJ+O/+kvzTD1G1yDcARBnwaf+0G8qvepz+eUqN21wW+rkf+AUUPyUBarjCAJ2V54C+ukkTpksNJ8VP6Iqhfo+adSTFXb3Ay7/H4m8THFUb/QJ9V5b9SZR72sFs63do+D0ZKceNU3LGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAg+blv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAg+blv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAB3C2BD10;
	Tue, 14 May 2024 10:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682185;
	bh=sVu2m8TyWS6UgrapaGe1r82uXUbCyjKtGJ+L6cYh44U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAg+blv+RMbFdMi2PlttRpLErMjJfM4lzwYIK/t3N7XSrBr5Hnuxd5YvOGkzoIFvs
	 QADHAEQgHd3xxz8qf19D+pa8uxA65n1mjuW40SfewnEyw2P5hz+wn8xwKnFCkYZ/c3
	 ZrtONriVVVKPm61yjooZmn9Q/A5x4bmNydeI14hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 025/336] bpf, kconfig: Fix DEBUG_INFO_BTF_MODULES Kconfig definition
Date: Tue, 14 May 2024 12:13:49 +0200
Message-ID: <20240514101039.555696386@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index ef36b829ae1f5..6352d59c57461 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -375,7 +375,7 @@ config DEBUG_INFO_SPLIT
 	  Incompatible with older versions of ccache.
 
 config DEBUG_INFO_BTF
-	bool "Generate BTF typeinfo"
+	bool "Generate BTF type information"
 	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
 	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	depends on BPF_SYSCALL
@@ -408,7 +408,8 @@ config PAHOLE_HAS_LANG_EXCLUDE
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



