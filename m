Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3513A7F4C;
	Mon,  4 May 2026 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903832; cv=none; b=KS67nKsk2Vnni4R/T0WJ8QseBO884D6l68qXupHZOUPtOqVQF9h0zY0Q2UIgR+Y0mpU8Wzj40y9BK6A3fC3D68yYRqGv6LTA6gjwukCNqmOY6lJswhB74EmLpk25mW67kGJCYumgSMpTN7lkxRWYwagWkRX8ON2xTdUxxOx+A88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903832; c=relaxed/simple;
	bh=6vO54scbzeKoWGGYpgOu+q/TlT3K1StWxKSBVwjpuvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baN5AGZkmX5BaobfU/BOF4IL2T+pfgJqMEv8a4ZY/uFIJIoES61HmWx9z8miXG/DuvY6zYAIqBzV/d7C3yBIvwh6wzwoZNdNEUm5Yde3M79PIkrCmRxRYcSxxORe0ff7Kz8ZgcLGnVweO9rKqtlhDzvEgAqM/dXMRFtYa74eFJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfMEWDiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfMEWDiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E58C2BCB8;
	Mon,  4 May 2026 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903832;
	bh=6vO54scbzeKoWGGYpgOu+q/TlT3K1StWxKSBVwjpuvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfMEWDiF5sQP/ReftsZhXqyHVgmjuG6dGi0CU3tRR1k4yg9CzNloioPWCWGA1SXtT
	 7E1vkLG8cpXISokWX2kVO/cnJbGGlDV8019fMZ+9YKpzWZjEa7KIaerrEjxlgADn8H
	 DU8+GxM34KrY3xInpt051lwow888zbuXZPu+uX3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 079/275] parisc: _llseek syscall is only available for 32-bit userspace
Date: Mon,  4 May 2026 15:50:19 +0200
Message-ID: <20260504135145.859114408@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


