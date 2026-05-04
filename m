Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803913A63EC;
	Mon,  4 May 2026 13:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903061; cv=none; b=pB+HxwbWA1afD1y4FuViXP7u+AVJVbb2pBUkf+UlfeDpBAlGF61oQYXmL7Gi6mQbqBHBgEtJwfaM/Np9tN+CxuMrjBIsoJfuWzyf4T2Q+bNGStRF0n5eTW59g4Ye+k9sfXmExFcnI3VIo9cOcvfobTLsjl943ew2tUjx2L3a0IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903061; c=relaxed/simple;
	bh=21+rQBueSG9ZfK+RBmjUD+ynX7vmXS/mHxAy4M35ZDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubmMOm7Mn6TdxWVgII6AOtCSqBxYXKwVdr3MvcFJwHdeCK9scFpo7mCCkHmBAzGtk/yVTGdXfW9Sdz9k7tMXh5gBWP91Ik6DdBBjcRHcDXZ3Db67A9yxQVCfqbksOYHyXG3xCgyDG53u442J3KVmHrihUDGidceVBjzqYyRgm3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmhBDV+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmhBDV+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E43C2BCC4;
	Mon,  4 May 2026 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903061;
	bh=21+rQBueSG9ZfK+RBmjUD+ynX7vmXS/mHxAy4M35ZDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmhBDV+w9h/7lc/q7zB0Lag5lRpf/HMMamDtxww2GSaFzcYDJ7aYhHeaQnrVrYm64
	 WD5SPyUz+nDObcq/qDqp+2Nj+zA6Wk3d4vRqMvsWVgxTy5YLEjkJVh7w9NIDS7SHbp
	 +zSf/m5CCiIeFtDYrfFghriZJc3NAC2IbvnWRhZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.0 088/307] parisc: _llseek syscall is only available for 32-bit userspace
Date: Mon,  4 May 2026 15:49:33 +0200
Message-ID: <20260504135146.126110133@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit da3680f564bd787ce974f9931e6e924d908b3b2a upstream.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/syscalls/syscall.tbl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -154,7 +154,7 @@
 # 137 was afs_syscall
 138	common	setfsuid		sys_setfsuid
 139	common	setfsgid		sys_setfsgid
-140	common	_llseek			sys_llseek
+140	32	_llseek			sys_llseek
 141	common	getdents		sys_getdents			compat_sys_getdents
 142	common	_newselect		sys_select			compat_sys_select
 143	common	flock			sys_flock


