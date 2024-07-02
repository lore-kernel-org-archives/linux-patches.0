Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BAC3D978;
	Tue,  2 Jul 2024 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940817; cv=none; b=M7oL7vrHMdmSoAuO3ejHTiLIqye5q+aKcVRyMeZZzm/XPc3BSakGAeEN/8f8pky8JdNbYzmRJqlhp3Jha8sfsOaKHEsHHa9913K4Rtu2gg+ax2bqMu0PGkAe4DwdA3LW/0b54j+3JjufNk6E5XZsIcIhg3IFou7XtNaN7yMSUoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940817; c=relaxed/simple;
	bh=Da5KviLU0wPc6tLuTsrNEQfQoR3wHI80j8PZ1ew94NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mt1wxY6rnqFIYCHXBN2eWYKXFivLSH5CwPLTqI4bQjOfNWjk5dJCNaDdqPs4zKdF3ek7WuiTOXVQOAwPQQZDg8ojyOiVHsVVKjH+k1xuZgKjDVn2rx+KmFR8j1zne2bZJAAVp4369mp005eYHvMp7X/GzO8ZkPMoLaXbhWIMwxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhD/giu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhD/giu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B36C116B1;
	Tue,  2 Jul 2024 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940816;
	bh=Da5KviLU0wPc6tLuTsrNEQfQoR3wHI80j8PZ1ew94NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhD/giu5gErelRo2VAWCByxlVlHzNeRrQZJjIyjO09vDTX5zpSufnoHTAf5AX9Qm5
	 mKJmsOF38y+qDUPgHRlsE8YREklrvGKGvUdKKYF9o78My3h7SY0Kjcav94Ty6o8G85
	 n5OhRHb+otvo6onA7JTLG2oLChWFP9qxvJGRYrt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/163] powerpc: restore some missing spu syscalls
Date: Tue,  2 Jul 2024 19:02:39 +0200
Message-ID: <20240702170234.768490251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b1e31c134a8ab2e8f5fd62323b6b45a950ac704d ]

A couple of system calls were inadventently removed from the table during
a bugfix for 32-bit powerpc entry. Restore the original behavior.

Fixes: e23750623835 ("powerpc/32: fix syscall wrappers with 64-bit arguments of unaligned register-pairs")
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/syscalls/syscall.tbl | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 20e50586e8a26..b012579247ee8 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -230,8 +230,10 @@
 178	nospu 	rt_sigsuspend			sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 179	32	pread64				sys_ppc_pread64			compat_sys_ppc_pread64
 179	64	pread64				sys_pread64
+179	spu	pread64				sys_pread64
 180	32	pwrite64			sys_ppc_pwrite64		compat_sys_ppc_pwrite64
 180	64	pwrite64			sys_pwrite64
+180	spu	pwrite64			sys_pwrite64
 181	common	chown				sys_chown
 182	common	getcwd				sys_getcwd
 183	common	capget				sys_capget
@@ -246,6 +248,7 @@
 190	common	ugetrlimit			sys_getrlimit			compat_sys_getrlimit
 191	32	readahead			sys_ppc_readahead		compat_sys_ppc_readahead
 191	64	readahead			sys_readahead
+191	spu	readahead			sys_readahead
 192	32	mmap2				sys_mmap2			compat_sys_mmap2
 193	32	truncate64			sys_ppc_truncate64		compat_sys_ppc_truncate64
 194	32	ftruncate64			sys_ppc_ftruncate64		compat_sys_ppc_ftruncate64
@@ -293,6 +296,7 @@
 232	nospu	set_tid_address			sys_set_tid_address
 233	32	fadvise64			sys_ppc32_fadvise64		compat_sys_ppc32_fadvise64
 233	64	fadvise64			sys_fadvise64
+233	spu	fadvise64			sys_fadvise64
 234	nospu	exit_group			sys_exit_group
 235	nospu	lookup_dcookie			sys_lookup_dcookie		compat_sys_lookup_dcookie
 236	common	epoll_create			sys_epoll_create
-- 
2.43.0



