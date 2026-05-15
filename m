Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114343FF1CD;
	Fri, 15 May 2026 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860715; cv=none; b=N16LdCBz99G2wXI9lc7wpRh3zUk2CRG67w7GFoxOukZ6994XiFSUJsewxHEhxdIDhs5VPSXKQwEzbpK1tBIfUsJZMQ26iPGLUt3lelxd5Qlr5Mir7JCofLe58hPiae1gkGL9aaxmtOgT1YSpl2Vb4S77X3DYSLdpUFg7QpMaRdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860715; c=relaxed/simple;
	bh=0WLNA7pebt8UeExbjfjOZsVnRnRkw3IKuPeh4lG4kRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5+2q406kf57JSyidTkpKJ+I5eBz8PBfdERXIxbPx7nd87sfT4CQeZF/wisCjjvb1CvXQR95TBTqwHY2Ih8GTEcN+z0Gv6lu8MThBLsGybnNTrM/O6lqlQXjEMAU3abEpT4IcWLcSxexEBgZ0hdvlKo2i4xjOnGI+WBcUBGMsCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjjUtyug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjjUtyug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C56FC2BCB0;
	Fri, 15 May 2026 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860715;
	bh=0WLNA7pebt8UeExbjfjOZsVnRnRkw3IKuPeh4lG4kRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjjUtyugWmr1+BC5EnKuzCIyhA6/GIohqSJA1JzgiNcgzIg4HJzceXDQbCBDR31K7
	 dUHiwkCWnz9SfCgiFqmuhX/QPJULy0GD20OfXrWBe/sCfKmiRxW5bkw57c+TqPEBWF
	 b1CF4uLoPnR8PNN5HCiaj/dcNkzcHvbcNlmqC6gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 050/474] parisc: _llseek syscall is only available for 32-bit userspace
Date: Fri, 15 May 2026 17:42:39 +0200
Message-ID: <20260515154716.129036980@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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


