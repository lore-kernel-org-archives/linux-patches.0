Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D6A33A9DA;
	Sat, 30 May 2026 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159937; cv=none; b=Uv2on7oDq/YVTduGfZvm256MqmXhiVKImwzdGTqz1IX2DWYU+jfU3VrzhGje+jCP47WNoQ3h0ZRx2lw9WeAJH65y9y2heRIJeFF3R1ZbYgJssOTQ0G+nf4arOsap1V9dOWdv6Z8DeGcfGhZ9oRF5Pe27vWYjjojoBZBzrK7nO3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159937; c=relaxed/simple;
	bh=NV1mt1AOAj6e7PDRI2Wq25y/C9kMqDQ/oL30IKJ9BMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lClQ6WKbULKaguZQgxDEgmcl+eyKbimGmilincacoO0NzM8wDa2gRJsxTn5MzItGU2InY6n/8Nrz7AlKlFwvYWjv4hYvDbJByuZvrDg39Py2bavG7zZwz7ooBsJiH3cnNHRZe4v2ITGTnqMPQE4TSGeAMVYWN6QJttS4M3wzT8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMkOB3V0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMkOB3V0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6136F1F00893;
	Sat, 30 May 2026 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159936;
	bh=pEpufSUKz3kFsQcVKynR3vsoKxHJRTzFP4gaSnpJsQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMkOB3V0Yv2wVl9ryVsufnxaK7JBzKbaQUHlQRwjaRJL3KTAVf3fgLqH9Xkn3+CzV
	 RhZQu0bn69lrx1dztzREwu6LUL1PAt09kwjTEfJZlrCy2SZqfdCJgsKaRELQCZqK6V
	 QAlZnZRn7AStqzKy8U9sVb+i7x3FE3LFGEkAq0Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 201/969] parisc: _llseek syscall is only available for 32-bit userspace
Date: Sat, 30 May 2026 17:55:25 +0200
Message-ID: <20260530160306.028793359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


