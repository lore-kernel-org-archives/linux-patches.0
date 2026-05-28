Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECAB339866;
	Thu, 28 May 2026 20:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000428; cv=none; b=Boq/2Se0DxeJCoLJE6rMsJh2uLjyG/vMkLH7emLEruK2LqLFNoqJtMc/R/0oTW67ZdvtxB6mUYOPwpa0jZxsufPTvIDw4Awzt5tuZERD9XcgZoXE52feNWe2ll5yoBZKB1owUgF+vAHC5gpNPmyuHAI1ZJhB7vbPkqF+0ushJ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000428; c=relaxed/simple;
	bh=8K4pFX2p34R4wCJO3R1mUxPm1vK0fhDfqIp8qFjEJeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsm3LbVy7AqYSgWX1qlcvLF9e2CY1Sn+Sux/inidLPWFVJQ97wWKVWSFvmLm9sZ8IJLXZrg9VvFiLoJjjNqQ4wLPHpvk7pzHLqWxX6guFvfpXxVJmwwCcfjp+1HQncJV8EF+eCkhrkIAJC9/ff0mDJ2NYdMKyKpmA5mBi7AG6Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zf30GRUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zf30GRUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A2C1F000E9;
	Thu, 28 May 2026 20:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000427;
	bh=CZLsRlvEgNjbwp1Lz0UwK5WtWAwpnT8ityF/PWcQU7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zf30GRUh3MoTH2/StikCNR4WtqZhQZ1Ix3YajHtCQQplWEiV8wRurg8XWwFlox9B/
	 ToB59v8q7rUqjQ2uyT/xwSf/A6ELYtylVB053QhmkwdKjsQzzWQGRCnNUvZ2uTDXxh
	 L40V0sTUhVHuzF2ioDeFAJ6Oycayovy+THuURc0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	Will Deacon <will@kernel.org>,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/272] arm64: Kconfig: Remove selecting replaced HAVE_FUNCTION_GRAPH_RETVAL
Date: Thu, 28 May 2026 21:46:54 +0200
Message-ID: <20260528194630.504986961@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

commit f458b2165d7ac0f2401fff48f19c8f864e7e1e38 upstream.

Commit a3ed4157b7d8 ("fgraph: Replace fgraph_ret_regs with ftrace_regs")
replaces the config HAVE_FUNCTION_GRAPH_RETVAL with the config
HAVE_FUNCTION_GRAPH_FREGS, and it replaces all the select commands in the
various architecture Kconfig files. In the arm64 architecture, the commit
adds the 'select HAVE_FUNCTION_GRAPH_FREGS', but misses to remove the
'select HAVE_FUNCTION_GRAPH_RETVAL', i.e., the select on the replaced
config.

Remove selecting the replaced config. No functional change, just cleanup.

Fixes: a3ed4157b7d8 ("fgraph: Replace fgraph_ret_regs with ftrace_regs")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Link: https://lore.kernel.org/r/20250117125522.99071-1-lukas.bulwahn@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f487c5e21e2f1..d4ebdc16cdb4f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -219,7 +219,6 @@ config ARM64
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_FUNCTION_GRAPH_FREGS
 	select HAVE_FUNCTION_GRAPH_TRACER
-	select HAVE_FUNCTION_GRAPH_RETVAL
 	select HAVE_GCC_PLUGINS
 	select HAVE_HARDLOCKUP_DETECTOR_PERF if PERF_EVENTS && \
 		HW_PERF_EVENTS && HAVE_PERF_EVENTS_NMI
-- 
2.53.0



