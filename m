Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4128C74C09;
	Mon,  8 Apr 2024 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582641; cv=none; b=pOMpHbu4ahkRbgTJqQw7PUBJgtS3XV+51z/te7KBGmRUFpL0+A45ok30hPNrH4/p6oI8nE8V6nDzKcVDlMj73K5aEQdv6jlKzfaUts5oO8Mx/9YfUgCJvnGjBz/gmyht8v+WsXDKSBgepodQpYSgXXpb6lcDBXiHz+OqFqVHVsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582641; c=relaxed/simple;
	bh=otaJPD8qbJto1yPyArSgbxgld7Xhg2zTkMOVPrZz0JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCBbiZcBEsKzF7+0FVtsE4mIKSEQBn5FqEb5ur/4KLf2ncWGzQz1fT3KNegtPcmAiTcCi1sTy8tMA6o9WC1L/3jIopyuvbVHNdu1dzxxYwm+PZIXZ/A4mvfDyB0CnS1k31WCc+6AZFNrmQOacktuyY8bOGynBHG0LD+yulY2ZcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X51xz6IW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X51xz6IW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9C2C433F1;
	Mon,  8 Apr 2024 13:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582641;
	bh=otaJPD8qbJto1yPyArSgbxgld7Xhg2zTkMOVPrZz0JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X51xz6IWBAZ6TT9Pusx2uHTYsGuEh4xIiwxIVvTE7X5NbSFpAkXtjdX73OiV30jMG
	 tONVQJLmXgetVJ1NVazy+BEp0Ix6OUOuGrMvMneg/l0nRnvXUpic+8i/x/R0JTiIGt
	 jL9eqcvSzbv9tHvICvBI+zpahxR8bKlk2DI3xXeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ulrich Weigand <ulrich.weigand@de.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.1 122/138] s390/entry: align system call table on 8 bytes
Date: Mon,  8 Apr 2024 14:58:56 +0200
Message-ID: <20240408125300.027541393@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit 378ca2d2ad410a1cd5690d06b46c5e2297f4c8c0 upstream.

Align system call table on 8 bytes. With sys_call_table entry size
of 8 bytes that eliminates the possibility of a system call pointer
crossing cache line boundary.

Cc: stable@kernel.org
Suggested-by: Ulrich Weigand <ulrich.weigand@de.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/entry.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -699,6 +699,7 @@ ENDPROC(stack_overflow)
 .Lthis_cpu:	.short	0
 .Lstosm_tmp:	.byte	0
 	.section .rodata, "a"
+	.balign	8
 #define SYSCALL(esame,emu)	.quad __s390x_ ## esame
 	.globl	sys_call_table
 sys_call_table:


