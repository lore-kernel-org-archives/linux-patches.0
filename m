Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948DD79F0;
	Mon,  8 Apr 2024 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583972; cv=none; b=MG4PlQl2jD7fvNhUs2q68GvN375VXZ/2Dg0RgKUJLe4KpQHBDrFP8RcwPqvS6pWxV2t+T4IxGg0sOVrqqvgdbSzrumQNGKigsdXnbCG9iLg5CFh6QnlFV8undFJgIM+L71XwXW8m6PL+Oi9wtVYK0Jx7oCbSAPFn43gLF3byTV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583972; c=relaxed/simple;
	bh=WGSp13Ge5nqR6Kja8I4XOoqp8BOJrSg88Gp1BocK4ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWTXA4v0OPwGrcrfShHYVLiUsFpGLKQX+Uw3k6V47kmS1bBtmOdparKbz2INiPL1vUUolV7/5dWLXpOgmI2f7B7qB653S55d98W5Df+X2B7XtfmNvwCO0Dqlag+DaDU/RcVbxL5+VUYLBAjVgUtRtmvqvA82Ctj2m1aiNYydoow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5l/VNNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5l/VNNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D39CC433F1;
	Mon,  8 Apr 2024 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583972;
	bh=WGSp13Ge5nqR6Kja8I4XOoqp8BOJrSg88Gp1BocK4ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5l/VNNdaCluKNChiFxROE07CLzBj8r8N2VINyewx0+VlN4nSPYim4097rqhgD6fc
	 GYYCYdADfr7X/4zZDopQuaAbSXel1KVDA3/rPI6UT1GzXw0oysJDKK8p7ewqYpl0So
	 YTN8fbxPsOuBveYox0Jk0883UFj64bJwGm2YASUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ulrich Weigand <ulrich.weigand@de.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.8 240/273] s390/entry: align system call table on 8 bytes
Date: Mon,  8 Apr 2024 14:58:35 +0200
Message-ID: <20240408125316.887670991@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


