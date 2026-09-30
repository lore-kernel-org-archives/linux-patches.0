Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FA2E7386;
	Wed, 30 Sep 2026 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794485; cv=none; b=c9g90uSyBLmnrQVrw5Tv1Zh8aIV38HvS21FgYB/UWwQeAM6F6DALgUGWL2xhMmyp7gEYUF1/d5xuw4RuS97ByeBgwTzHuGVCij/qnxY7jPEUEJmov5unPKMAIG0EkQBfMov8z9LgTrbu0MFs0lD+SByWKlu8NWau6Ce+Hz70McY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794485; c=relaxed/simple;
	bh=cA6sE3LKk/ILK7ZOIezS/+3ksHJWcqkudNa9QNGEd0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFHQ6jy++giltvPSgpU/7xNmux83XErloPsGBDRJRO+31rMfm5hpoWdLX+9dSAGWc0LpJerFdhjjY3nYwsvv2BtKRuzu3eKHKN17sMMSCTRjBh6XMcWCL6kTwc5gYkVKQzK/B84GxsEVXrC4m0VfFtkSDSDJMTcBYou6OKh7vb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gr8jHB4W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gr8jHB4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C54A1F000FF;
	Wed, 30 Sep 2026 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794483;
	bh=tvC8mVBNSa2s+jhzsQi0uwfARhBO+bSo2cSlSXyhfv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gr8jHB4WkFSuVTMC+8F4jfE24HpBrzVrsHBAqG8uy/X5d5sQXnVDSoaiSfECDnPV2
	 Pq1aq7Tq5kJk1UbXxs4gBAD4yOkqzgLWcyw8xNw7381I4fgT+YnhZBm/dDrdRMPm4p
	 q+Lebq1mZSU5gMW4EamaUFsw2jQLnw4fjrTYRSDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0226/1193] sparc: Disable compat support with LLD
Date: Wed, 30 Sep 2026 17:15:10 +0200
Message-ID: <20260930152439.217962226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 852fed2e8bfe195351fb0078ba7245d41154e7a5 ]

An LLVM=1 sparc64 allmodconfig enables COMPAT and then tries to
build the 32-bit vDSO. That path cannot be linked with ld.lld:

  ld.lld: error: unknown emulation: elf32_sparc

ld.lld does not support the 32-bit SPARC ELF emulation used for
the compat vDSO, so keep COMPAT disabled when LLD is the linker.
This avoids selecting an unsupported build path while leaving the
existing GNU ld configuration unchanged.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20260508000834.834824-1-rosenp@gmail.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 49849790e66dc..9e8253295b3f2 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -487,6 +487,7 @@ endmenu
 config COMPAT
 	bool
 	depends on SPARC64
+	depends on !LD_IS_LLD
 	default y
 	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
-- 
2.53.0



