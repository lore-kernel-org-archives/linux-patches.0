Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60D186E22;
	Wed,  3 Jul 2024 10:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004175; cv=none; b=JnKiYN8NqXXIEHF+DqQdgV5PLdVAIERy7ZysTxokd9W6rA8CE7Yp6BiXU1hUWXZXYClDAkEXQ0wxkZzZU7S6yYvh305e1E1YcaSJEAAmyABn7854bU8lDfdlwh+Kp1xV+eiLpDxdJkZAad4cnrR3/7gKjHAUuEA0n7LVr17sZ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004175; c=relaxed/simple;
	bh=5D3yNb16yv4oMnb5w9byOgmjWDFrtYapzjVzIhWTRME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrEDrKzoKDKPc4Kz6D4Z5jQ9TPmRimiYkfEhSndnwsjmf2veQYH2D19AG6JcfLu7TVHHvXqtQ5D3hp9epnLYKzSsSfyQfUc2dTpYKpfFsSVWGMMkst7+bpS2jq7UcwPG7BAOgoRO9sHdIKmSlZmOKtHQYgQ3bJuA7V81CrpqDxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmSwwVn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmSwwVn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB92C32781;
	Wed,  3 Jul 2024 10:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004175;
	bh=5D3yNb16yv4oMnb5w9byOgmjWDFrtYapzjVzIhWTRME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmSwwVn2+Co38qbPbNJoIGnadYbW15uQtSIkL/9+nHKHBOB7dnn7BepNZSFiO/BDn
	 TlBWLy41D6o9Cv+MQ+XjbQ2+TfnqKGPjwFkHJP3cQ/L4XyNOtOuGqaIYBkxfFzxM8l
	 NqISUj7Ngpq6GHL8WEk2An8ww/nuQ/f1lFyKwRss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/189] parisc: use correct compat recv/recvfrom syscalls
Date: Wed,  3 Jul 2024 12:40:06 +0200
Message-ID: <20240703102846.950429826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 20a50787349fadf66ac5c48f62e58d753878d2bb ]

Johannes missed parisc back when he introduced the compat version
of these syscalls, so receiving cmsg messages that require a compat
conversion is still broken.

Use the correct calls like the other architectures do.

Fixes: 1dacc76d0014 ("net/compat/wext: send different messages to compat tasks")
Acked-by: Helge Deller <deller@gmx.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/syscalls/syscall.tbl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index e016bf6fae1e6..eb84763062ee1 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -108,7 +108,7 @@
 95	common	fchown			sys_fchown
 96	common	getpriority		sys_getpriority
 97	common	setpriority		sys_setpriority
-98	common	recv			sys_recv
+98	common	recv			sys_recv			compat_sys_recv
 99	common	statfs			sys_statfs			compat_sys_statfs
 100	common	fstatfs			sys_fstatfs			compat_sys_fstatfs
 101	common	stat64			sys_stat64
@@ -135,7 +135,7 @@
 120	common	clone			sys_clone_wrapper
 121	common	setdomainname		sys_setdomainname
 122	common	sendfile		sys_sendfile			compat_sys_sendfile
-123	common	recvfrom		sys_recvfrom
+123	common	recvfrom		sys_recvfrom			compat_sys_recvfrom
 124	32	adjtimex		sys_adjtimex_time32
 124	64	adjtimex		sys_adjtimex
 125	common	mprotect		sys_mprotect
-- 
2.43.0



