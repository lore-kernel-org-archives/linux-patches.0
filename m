Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D6180BF3;
	Mon,  8 Apr 2024 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585186; cv=none; b=tMdgALQ6dJfmJ6yYtWV6wK+CxKYeuwqJsfxEC8iv6rmVw+BcLTxH3FzyJ99avY8gjMAMQUHDmqE2+GbfpDpa02SVBbixOtptbK7dJ9rhLxLZaVJKtazp1uTEpR3W/S01rLuSDZd5W69gbAh66SufWXsB4PyDWtqjiZr7vqYYX2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585186; c=relaxed/simple;
	bh=nvN5SQ+jjbjMmizusGpgRHSKSkS0l+3MhGVwklqrq/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCnnso2N+yE3cIIqnhYfVJkmDzQFsu4lquCnY8ClGVSRRFrVRj4e5gAJTHqDvd4Pgt7N3ZNN9u7SMZ/1NDHTb1n0hm8xKeIG5v9DR0OvDRQKp4VZQXfz4NR4AJSs+xRBaaF/mFxjmgZw7RWx1Ny8wLPmnNu9uanzl275K2Udy50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOmzklwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOmzklwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805ADC433C7;
	Mon,  8 Apr 2024 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585185;
	bh=nvN5SQ+jjbjMmizusGpgRHSKSkS0l+3MhGVwklqrq/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOmzklwnyuYLLsf68/ky5oLP4pA+4bbVJKAwo3vcwGmWy82QDnTL4ha3Up02TLArI
	 QmUdNw3SwNPI9gdWgmbNbg+s+JjyP/Idi+AqPcgwNB4wIA0mEAzHJoe1HbDamrS4nh
	 2+aoSVxyd3Qi5Jf94LH/4BoBCblEbEcXraHjxigU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ulrich Weigand <ulrich.weigand@de.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 682/690] s390/entry: align system call table on 8 bytes
Date: Mon,  8 Apr 2024 14:59:08 +0200
Message-ID: <20240408125424.432126203@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -685,6 +685,7 @@ ENDPROC(stack_overflow)
 .Lthis_cpu:	.short	0
 .Lstosm_tmp:	.byte	0
 	.section .rodata, "a"
+	.balign	8
 #define SYSCALL(esame,emu)	.quad __s390x_ ## esame
 	.globl	sys_call_table
 sys_call_table:


