Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EA519D8AC;
	Sat, 30 May 2026 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163286; cv=none; b=OKxX9Jjj+I/MsMRYaHHK3st4GWOwsR7WInExx4vn4amc4ATB9g50Tcdzorx8miwyxwoK0D4JLf/i8eocWO0GEdtRQmo8ay6B1jusjfg2DGcuCBpU5kIq9/byroJEiF9cycPSUp2MXnDT3aJxTdeMuogvS/IC+YB4QbwIgsiQBXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163286; c=relaxed/simple;
	bh=pja0hum/2Qre2hWoecf+is3mxoS+n4YUSeCH+UqStK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lt9NvCe74D9nEe9K/0jW1oE84TYj/lZtHmUuNQdnIDQh8TbAUr2BuZTbVFS6uYJIYBNtDaBEfLmnqhNOo+0UeqRKUnrajvhqh4YRYJhAVdWhO7r8B8XRwqIJCzYiOnaoWn18cnZLcBwMnLpQrEfw7xBM9f3AwJrNXZruAk7O/AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aK9lwPgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aK9lwPgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40D51F00893;
	Sat, 30 May 2026 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163285;
	bh=P6uT3ohdiXHAzNpNxHFxSzxzKDH2/2xk26L5jylqha8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aK9lwPgy4Dc/x9UjGJ2mS5OaawRYUUdRJQc3U8U/GCSz7Bofw1wL7zPJ1suoV60xi
	 W35m/PTysZ+pkvmccgTcojhv+1h3Qahf6+DdQyzui4PpK76dLctiFEmjeue1MtaV6s
	 TG1gOSId015183ErSrfascmsdVwOXKi6FlOGcYcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 213/776] parisc: _llseek syscall is only available for 32-bit userspace
Date: Sat, 30 May 2026 17:58:47 +0200
Message-ID: <20260530160246.020649614@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


