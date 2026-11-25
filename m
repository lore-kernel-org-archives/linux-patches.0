Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619494;
	b=F7zklo0caqcf4jkcUM0BGw4cely7C6SwsCQ5GyvdFsQ+ZJthUrXnl5dj3ZSD0aNBAHyc
	 97369i8AZlfzhrAW7HiJTfqAxRvn/UwIz62xPli7ik7/3J9Hevxvf04UwvoCsJYt+VFIM
	 K3BlyK+FhVB9PdrmdUDkUCPqgL6h39wgHo7Gk60Gt+pxdo8DOu2Jj7EUwCO25nV+4wPsh
	 iGSq0vlyO6dIBXfVEjGTnxhMR7M7g3bu5y8YaYMZafgscpuXBkoBmhluunPxauzm8nrC6
	 z7q5Z08+baOUucWkNvbLDqh31FU2VlmD2x7luC3T6oVX/8MDBaOpCBq+Qh1N8i2OIUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yz3Opfs3Y2qi9jOM07e10tc7hmAmCZFYe4r90mjsDlc=;
	b=2SADXz4Eeg6ceQ6RcG7wSFO7c3SzQVvSHQmECYV4e6teNvgQ6rsWFY+YmSQQxHVnUj8V
	 goPBqN3AEtTftqlH+/y2XYhMqjOkMV05GywoYmbneg6bbUhb8O3lDZLi+TPTn8K3i+H8L
	 Ot0jOgms8S/zYK6AUSTvOI2SV1WRUd5vNO107zdmmwvbqoHLM1YKSX3G8iT3y2v3pcb7z
	 jkShJRj+zFtE9oPD1ty+Ezheko8Gv/A/2hI4B0OjyYeaBI/P9YWOA8K8Og24IragORuEf
	 LILlY5AVstA8vS+curXHv4SFvuiy3KGj5c/nDehUWIB+WMRZnu49VYrFllzd13Lw1rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Khpj2uVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C239D606A31E;
	Wed, 25 Nov 2026 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Khpj2uVx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDC31F000C0;
	Wed, 25 Nov 2026 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619494;
	bh=yz3Opfs3Y2qi9jOM07e10tc7hmAmCZFYe4r90mjsDlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Khpj2uVxv4a7/ll1lCKylNMMAdsWl1QhBWe17ebGf8LeJZ3WEQ9pchzVasGZzT6CF
	 6JERiWGEy45Wpqk4xllo5fv5GN+LW/RUuASmGvoL0YvFDJ3NIOl5rexnYZ7CWIAV99
	 yWcoY0S+jO01b4too1R1BGNJSfOG8eNm9hYdjfJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Bezdeka <florian.bezdeka@siemens.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.3 0615/1005] entry: Complete syscall_enter_from_user_mode_work() to bool migration
Date: Wed, 25 Nov 2026 15:32:33 +0100
Message-ID: <20261125143836.152853439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Bezdeka <florian.bezdeka@siemens.com>

commit efe191f1605a149b06eb0fe1ff975e7d3137c9bb upstream.

The return type of syscall_enter_from_user_mode_work() was changed to
bool in the commit referenced below.

While doing so, one caller in syscall_enter_from_user_mode_randomize_stack()
was overlooked and stayed at the previous type: long.

Update this caller accordingly.

Fixes: 05c033db7e9a ("entry, treewide: Make syscall_enter_from_user_mode[_work]() indicate syscall execution")
Signed-off-by: Florian Bezdeka <florian.bezdeka@siemens.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261030-wip-flo-fixup-entry-code-v1-2-7724c29e800b@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/entry-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index a8b2430eadc5..15278416f886 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -202,7 +202,7 @@ do {									\
 									\
 	instrumentation_begin();					\
 	local_irq_enable();						\
-	long _ret = syscall_enter_from_user_mode_work(regs, syscall);	\
+	bool _ret = syscall_enter_from_user_mode_work(regs, syscall);	\
 	instrumentation_end();						\
 									\
 	_ret;								\
-- 
2.56.1



