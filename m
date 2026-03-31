Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070AA413225;
	Tue, 31 Mar 2026 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976285; cv=none; b=XSTRMakR7d3aUBXTCDvpX3maTTtKe1VKZfsNQBCM5ZzXCV2H1NRUl/EEKuyE+wgVnYnOK9nKu0H+BWwa2WENcik5xL47ZnXNvqTtSRRxaSdMC2XA1+/Uf4e51orTFty8IVP2iybfrQ3uiIFb2BDpodyrLAUa/MpN2HASVV2ZRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976285; c=relaxed/simple;
	bh=QIxdfXIe4PXWJB6HLSGLX7lWBaMKAzTSVW30Tdi+iiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IivTgy6EnovXh9rLHyo+BvGZalDBEDlRETBucn4Z6tFgsHuDQOkapd3Z6SWZB5F+Wu1vGDNDgA90YYWq2d45SxIojRUZ+bxwUY0u4AOhpmEZ58NlZJt1XHpZd35cFyb32e73Y+Ry49dXJEgkuD4CVzcVe9oShMN/7IFJwNz+GLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPGfFI26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPGfFI26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DCDC19423;
	Tue, 31 Mar 2026 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976284;
	bh=QIxdfXIe4PXWJB6HLSGLX7lWBaMKAzTSVW30Tdi+iiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPGfFI26dZHDEB9LHNEP85w6XzTKf8bYP0x1pRQCHqDluiRZrUjVsdWlnjh756tyd
	 X5jfDb9eOZzby5BzknLF/VF1z+fQ/N0/lIffd0tuEqxeK/RHnsbr45rADNYBns4cqy
	 k20rLC2JmUoGuKoNzFxa0D99kmsudPr+CN4WwvL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/309] kbuild: install-extmod-build: Package resolve_btfids if necessary
Date: Tue, 31 Mar 2026 18:18:57 +0200
Message-ID: <20260331161754.737777131@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

[ Upstream commit 459cb3c054c2352bb321648744b620259a716b60 ]

When CONFIG_DEBUG_INFO_BTF_MODULES is enabled and vmlinux is available,
Makefile.modfinal and gen-btf.sh will try to use resolve_btfids on the
module .ko. install-extmod-build currently does not package
resolve_btfids, so that step fails.

Package resolve_btfids if it may be used.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260226-kbuild-resolve_btfids-v1-1-2bf38b93dfe7@linutronix.de
[nathan: Small commit message tweaks]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/install-extmod-build | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/package/install-extmod-build b/scripts/package/install-extmod-build
index 2576cf7902dbb..f12e1ffe409eb 100755
--- a/scripts/package/install-extmod-build
+++ b/scripts/package/install-extmod-build
@@ -32,6 +32,10 @@ mkdir -p "${destdir}"
 		echo tools/objtool/objtool
 	fi
 
+	if is_enabled CONFIG_DEBUG_INFO_BTF_MODULES; then
+		echo tools/bpf/resolve_btfids/resolve_btfids
+	fi
+
 	echo Module.symvers
 	echo "arch/${SRCARCH}/include/generated"
 	echo include/config/auto.conf
-- 
2.51.0



