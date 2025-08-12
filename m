Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CA6223DFF;
	Tue, 12 Aug 2025 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026038; cv=none; b=c6xG+nHMA9FUJJr3SFdcl+t+BT4xO33zO2dmyCSG5U/TGPwe2dFhU48Z++wElx+Bv46GhkF8uf0jnohmfnwsjUvZquV1M7A4C+WbbQr8REOI75tPCAjqlVBkwshLlUa09Mxp+idGlAabCBFJMhqpDi58GVi/mqGVkLxAK7fTG0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026038; c=relaxed/simple;
	bh=Xm9tqV2JBuHRN1hXdjrlhEsuu8WIKeWSlUYC04aSdFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aARdr5JYWd8d/N7X2E+3snVB46M3+/Q6e3V7nkdlOLoiZs3b4vl1ZrWgcWH//G7id7rPb9EVL0ws44R9qZ1romB2Df/RuALPNn6Xps340hvQ2z7kGUinqIRwJCjXPbZqdOF4XbGUMPpulhp6SI9uqgPHhOrCN9dENnOM/M4iCfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYmxrFM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYmxrFM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED843C4CEF0;
	Tue, 12 Aug 2025 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026038;
	bh=Xm9tqV2JBuHRN1hXdjrlhEsuu8WIKeWSlUYC04aSdFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYmxrFM//i8v1fi4mZA7tN2vXTOMxmCvURpULV8Yb7zGdRZ4To7Mq3WdK69M4gLzU
	 t8gREckhc//uBRuF9r48a7MVXGvIxsviMlNoEquPW1iVeFZbonmP4KWJhwFbm+FD5A
	 fdehckwDZkTZ3gIwKOqrfCHbFDR9qkzqh7RTYc2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 217/480] bpf/preload: Dont select USERMODE_DRIVER
Date: Tue, 12 Aug 2025 19:47:05 +0200
Message-ID: <20250812174406.405435171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 2b03164eee20eac7ce0fe3aa4fbda7efc1e5427a ]

The usermode driver framework is not used anymore by the BPF
preload code.

Fixes: cb80ddc67152 ("bpf: Convert bpf_preload.ko to use light skeleton.")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/bpf/20250721-remove-usermode-driver-v1-1-0d0083334382@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/preload/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/preload/Kconfig b/kernel/bpf/preload/Kconfig
index c9d45c9d6918..f9b11d01c3b5 100644
--- a/kernel/bpf/preload/Kconfig
+++ b/kernel/bpf/preload/Kconfig
@@ -10,7 +10,6 @@ menuconfig BPF_PRELOAD
 	# The dependency on !COMPILE_TEST prevents it from being enabled
 	# in allmodconfig or allyesconfig configurations
 	depends on !COMPILE_TEST
-	select USERMODE_DRIVER
 	help
 	  This builds kernel module with several embedded BPF programs that are
 	  pinned into BPF FS mount point as human readable files that are
-- 
2.39.5



