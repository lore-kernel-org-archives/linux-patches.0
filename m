Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44F815218A;
	Tue,  2 Jul 2024 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940207; cv=none; b=VCcyEGYqF5fmtkxE1qJTSvxgFqvM84D1Y4gkTB409yiBDhSS9WIbGygQ8kbEwkE6qQgRAD8qF4LIUPv8QC5WgEN1kwMIejShLkrYblnV3cCJDdvcXLyovkVwRXXNII+x6+lJg9HG9vIcRWrUgpM/RNrtw5MOWD7KgHlUadAz1c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940207; c=relaxed/simple;
	bh=U/DZ6pNgDhiAIQS1skJTpBY5j0FIZf389fA7kfZOiJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJMU8gst5P0rrNnw/xMPqPC8TYWsbZWchrN1gGzwUQ2uRD3NIBeDfutdM/QWa3OHVRuSJ9AoF6+Fu3slHDErLHx/TGyBJw/9WUNHlyPcnLFFSYbY96B9fN0YOihb6Q13SmU1j2KemwfHsLblJ1ui8qD2T6l9SOehs5tomddSO/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srfd+y+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srfd+y+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EB1C116B1;
	Tue,  2 Jul 2024 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940207;
	bh=U/DZ6pNgDhiAIQS1skJTpBY5j0FIZf389fA7kfZOiJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srfd+y+qwoLaonrkP6kVlxRMRxVe92CBNeVohv+YmQ6UzsVioU0nFx5LS+qEx55UP
	 U6LlCBFahwZ+dTXtWq2s/ufDN/T+3yqBnhyN84YGo21aqLlt2+KZrKcdrDS4uz+dsj
	 m1/IfdYeB0VkQxDGsnibQk1iCZvwBIw1OiEPEq6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 053/222] parisc: use correct compat recv/recvfrom syscalls
Date: Tue,  2 Jul 2024 19:01:31 +0200
Message-ID: <20240702170246.003158351@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index b236a84c4e127..58ecf687d98da 100644
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



