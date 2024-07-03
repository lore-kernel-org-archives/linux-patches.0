Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74686E5ED;
	Wed,  3 Jul 2024 11:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006057; cv=none; b=CkE/ukTxqyldX+bcy2F/4lHsy3mfphRXGlhUTwAftBvklqwVwVHf6cBKqiyNYjGbbnrQYEKBiJ377yn4VDTf8i1RN2K0/TAzDTPZZ+m+4pGScW5QCCa85XkvTCfB/JXj/Gn7nmiodXV9+9tzlea7HCvRKZoD/xM5K81Zf/TaI9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006057; c=relaxed/simple;
	bh=VZ4oiTOL/R9TP5stN+rw8Mc2PtIeGVkWN3rOTAzOGa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhrhXUG5A3cFFCR2fx3LjyWa6+kMOfn00ZclDwS7L9ilEaHM+bDrKqLMFa9+6s9FGFCqA2wVK5m26f6i9AMjHivpoKSl0pgH3zFMIuv8Dr/oMkoDSZF0FhsdT5C0WohmaPOUTpUfII9Z1/2JGQV0hO9ZzTYi8EH+4h4hqF8k+dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW09y0hL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW09y0hL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F89CC2BD10;
	Wed,  3 Jul 2024 11:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006057;
	bh=VZ4oiTOL/R9TP5stN+rw8Mc2PtIeGVkWN3rOTAzOGa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW09y0hLH2V3t4onPN8RB0auHm1k3YgFEIOlCQ19VW1dYPEyQIFf8sCpGAbmhzWm0
	 DIpk/rTRudJIC59lKk/RT0f084hN7zHNmvw90ll7tcFGHznoEu0lIf4Y/2kWZ3+SyR
	 Qnx/Pc1LHshSqb5McuYTWhcOQdV+g35OQzqbGljY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/356] parisc: use correct compat recv/recvfrom syscalls
Date: Wed,  3 Jul 2024 12:40:15 +0200
Message-ID: <20240703102923.668038024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index 50c759f11c25d..3e7ded09e00a5 100644
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



