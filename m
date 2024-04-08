Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0697C6C8;
	Mon,  8 Apr 2024 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583687; cv=none; b=NLvmPGNz1iR0VAbU8ysoU4IQi6TeiCiHSiduuk2BuED/9etgjDOFspOUGaKZU4rt2btcfNV5HnTdvdRjTr5YURsLpLG+Bb60cvJtYlh1Epb1os5LySscg5eId8JIU6XRix2cm+Jz6kO7EyZKxr86+HVkoxW1PvYZbAg6CnfxAPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583687; c=relaxed/simple;
	bh=RJbLnAjkY9wfo4zMMmTlq6PwfB57rGJ97KyRdBX12pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0c6Vhvsxd3yxwMzraBj4NVB+SXBJijuqACq5d4B7GP/K3QyLRKyuFcnWyXpbw1ZfvUMeaAn27tEcOmj6Jm3kRY8AqTz3HPbtAQo/Vt0Y2E0sibakgEYix1IKVzGGJafxPWTxrmnqm2Cap9Ay1CmrDrVmSSw1b09JtS3vtQGbJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWmURXBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWmURXBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60D8C433F1;
	Mon,  8 Apr 2024 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583687;
	bh=RJbLnAjkY9wfo4zMMmTlq6PwfB57rGJ97KyRdBX12pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWmURXBTqxdhFew91u2CmT1r3o7bx8bTkq2wDo3xSr2faM0IOp9cAE83hq3bwtRlg
	 I5U3OBz3fGx63qMq0PIVl4ujoSoXm4Uni1CEgB94AkakevH8SFGAELK+rKgcNp8S3A
	 xcSmRJMz+CmSf6sM498JB7jngENxArlOw7ZUIMTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ulrich Weigand <ulrich.weigand@de.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 223/252] s390/entry: align system call table on 8 bytes
Date: Mon,  8 Apr 2024 14:58:42 +0200
Message-ID: <20240408125313.578682732@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -653,6 +653,7 @@ SYM_DATA_START_LOCAL(daton_psw)
 SYM_DATA_END(daton_psw)
 
 	.section .rodata, "a"
+	.balign	8
 #define SYSCALL(esame,emu)	.quad __s390x_ ## esame
 SYM_DATA_START(sys_call_table)
 #include "asm/syscall_table.h"


