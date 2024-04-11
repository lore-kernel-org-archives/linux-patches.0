Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85D32EAE5;
	Thu, 11 Apr 2024 10:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832118; cv=none; b=Ktemdu/Gwgh5Kn8mBm6bqGT5Iq6DdmE6ZPsB8MiYXAq+Nd/oL5QOkMVdurC5UE1KEviaHqp0eadMbJH1iLZYxFdaNAkejdA8HqnQHQT8fBSTim+QMGBC/DeonQ3Zxmy+npGER8c8pAfsiYphV3vhHmoIEzcitzaFqcfIBCqpIik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832118; c=relaxed/simple;
	bh=vdhQePiDnXUdfrdU8pv1bc3McTnNwhsf36bP6JEyyq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtHVTF9DZHG7mTgbdegKJIoQWdDZN1KShvYdQOaN1Sd4bxEPp9Zg79lCiV110qt8U3TPONQQKkgA9UwvjGqyUw+4YcT6WnZarAvQahXH6OLErJsFX2/QytpzRPTsQtKnzBi6yJuxwzOXY9vB9d10HRF0/0FNSab20g8ySnBqctI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvUNKQ2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvUNKQ2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3046BC433C7;
	Thu, 11 Apr 2024 10:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832118;
	bh=vdhQePiDnXUdfrdU8pv1bc3McTnNwhsf36bP6JEyyq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvUNKQ2Ux7HPlGK678ixDRpzQsxvnLjzMlJqTHK29ePQVlmbZ3v9KaMvKq73TWnaQ
	 MD7kt5SDKOza+iCrXx1cSesXTCwFC2G2rCQ2Fb/qfxpb/lMByahesAbpu7rCl+QG3i
	 LnT8e3CUcUqy/9Cjn4b939lUfFoPssyBwHqoN9Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ulrich Weigand <ulrich.weigand@de.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 236/294] s390/entry: align system call table on 8 bytes
Date: Thu, 11 Apr 2024 11:56:39 +0200
Message-ID: <20240411095442.683561724@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1298,6 +1298,7 @@ ENDPROC(stack_overflow)
 
 #endif
 	.section .rodata, "a"
+	.balign	8
 #define SYSCALL(esame,emu)	.quad __s390x_ ## esame
 	.globl	sys_call_table
 sys_call_table:


