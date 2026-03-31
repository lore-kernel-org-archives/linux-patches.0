Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB8433120E;
	Tue, 31 Mar 2026 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975624; cv=none; b=OIcJfP8w7a/lL9fUQtcUoOrWfomxtZ0Eli1E0vK6MH+Z5ZOLcQovFHL9PvoVmc5M78ouTY0lKcnP7OSJlFQUfq5L30Hu0lAxm01fy9vJ9U/N/yfhJ7AGmdlt9y6HLPwovmONW3qlT6JgnLtrvyiD/VN8EnJpWs2QZytLH8UdEoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975624; c=relaxed/simple;
	bh=cRwEPmJwBgQQcDfXaKRZ/EpXJpd/cU1LdB1Cjm9AIJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MWvVI6HqjHC2ev1UMcrlwY2omM6LGAICWZj/tTjRu/bP/M/pOqFt+dPCDAxeT3kPoubRQ5NGJCvHWvFdcupIa0+Kb3w3HVFnpZcv6zNUa5CPFa+wk0lgR7hBh3j1ZKJRWiAAZrCTctZ4hjICEhrOpvPPBEDpJ2daM9DbFxvavVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urG5JWEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urG5JWEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90407C19423;
	Tue, 31 Mar 2026 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975624;
	bh=cRwEPmJwBgQQcDfXaKRZ/EpXJpd/cU1LdB1Cjm9AIJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urG5JWEgX6jN7ZlmVmite+KFImyWX2UZhY7eDH94JSl+teK94MvnyZaa8pReqqbGE
	 bY0BmB+f86dUGsGCQ6UCOjc5Jquf5LR4a2GkpYX5mF0nzMVk/Wg2xaqg4d3bwBQx6y
	 A40T2fAftl8F+KIyDqBhG9dQOLBennVyJE2q4CDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/244] kbuild: install-extmod-build: Package resolve_btfids if necessary
Date: Tue, 31 Mar 2026 18:19:33 +0200
Message-ID: <20260331161742.560590867@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index 7ec1f061a519c..3edca72599812 100755
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



