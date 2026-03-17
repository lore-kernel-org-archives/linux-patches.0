Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91FA280A21
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 17:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770382; cv=none; b=R9Hqb3sskDlYhLJbvK/Q6eICCu8PQkVnhRlSOLqPI/AByUV88lE265YsznfslC2opuBRUYistM4rsj1qARnCRmP9aWfd1BpZzydh7XkY7Nd5K6byonIBcHzHBAJQ/1qir4hu3+R4/PGCjdmnFIHL8ke/0roqYBK3w0XqFKHjsbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770382; c=relaxed/simple;
	bh=qEp2sShqi1KgMVodMBiFhJfJPmr3G501i0+Nsr1r/70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m2wDIJaqhWkQseqv9Rzj4YHuILKzU69xR0bqq4XcOX0SXZDx3Yuvwq1gQPG4Cd5+xsTCHkPaoJs3G+pcDI2iVVRmF1irVd7pgeXg69I/Jr6A0rqihtTvtG4Ogmp0I10+KJFl82pc84rQ28lzVq20KZ1VFyR1ss4a8TFBZfAbt+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=qLMklQN4; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="qLMklQN4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1773770352;
	bh=dwHf63CrmgAOF+9cH5aTI2NFbzmXoNuZgytYJc9T92s=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=qLMklQN4ttGaVptIbhTIx66s/6/6HY6NQVt7HZFCq1O5scxI3RAFxoXSaaaQ+iPA4
	 nfyDgeOZ8aZjLHJuZNhQSJkmpq8axN6RAIKFEeSjKpPyLBo9Dp0XLIArjUwmUQEoh2
	 EMpgV38b9rm2ixAzsiu/WKHnOfrrOVIE1gukGm0k=
X-QQ-mid: zesmtpip4t1773770344tea1b4c30
X-QQ-Originating-IP: K5ac4WI8bp9cfw5clapaXR+RIF/6/c4o9JrjhC6KjGA=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Mar 2026 01:59:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10242624894791450285
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: brauner@kernel.org,
	broonie@kernel.org,
	davidgow@google.com,
	gtucker@gtucker.io,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: kthread: consolidate kthread exit paths to prevent use-after-free
Date: Wed, 18 Mar 2026 01:58:12 +0800
Message-Id: <20260317175812.707723-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260317163006.067634764@linuxfoundation.org>
References: <20260317163006.067634764@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Mxh1r6NAWu99nW/jZC3dpUcMpD7RfQTxqIU+QF4jTo+jlUdm9ePbplyR
	BYL6VUQPFwJvKj9GXRDAIstUyy1+Qto+e4BRrriYhJKRn/EWJlmOiWk3B/R4FcHOUcikjO9
	qpmDH9JaBNvUQoNujS0ULDc8xgSOJ+91PzbA4ZcIG+CdQ7c8PKe+ExUlqHFZTRyRY2ghB8z
	hFyKOZvI3LTeml04c9Y0astnfq+9I4y9UU+NKsFwuS1QYtxicD1jaA8hG+H0gcaGJWBxLgC
	4hfEVYDyI3RxSyjZgQrq//khLXkX/cv4iOdlxmrEsooyuxPnQt1asim4EJZCL3A2XJkunbU
	V7ymVZt4EIYBGiTHZDiSWXTzIOZthgXFxnKSrveix0kfGvrRZZhDqPVQIyamyT5ON94OCfm
	5jkQXG5epBWc6ILN9XgvQW45jx0sLyM0dV4R9uW5nktVquSvvZW9TUjeAzbXmQ8Nd0SM3l5
	BxRshISt8qtYIkMGmnYlJDeqGJ3BTMfvr4SXa0oPW+z7cN1AFaaxHHHqZgzHzcEPntHuLPk
	SZ4Z5Ak/Xc/2nsHXjF5OT8mxGUwz3/dK/ZiNspSBkuW9Sny2oDI8utvSyDoy5X9dWc7w2Gl
	3sYBSGRzph20y3697pj6ox0Yc3Eh9LYHGxB1SeSHOV0ZceMfJ1MEZBvo5w/WC0isDqqhvn9
	4ESWQeIwVIDDpWfjFoufQyZo/IiL7vEHEtZyOJZyTqi6MB6PJGIKz1t8ViJhYBNi70WdjIp
	EughS6OGgljbNjuOhjx3q3aL5hNXp6rvUBzAyhZTeqpDns77hzhJtW6G36LIA/DVD+8m5Ca
	4UZO6A9kQXbUqFtySCF9WM8CjcWSVdKaMDpvWrwgU4kCA/XHxIIwjWrMpmp3T34U+N4/N4c
	3p8kxhWRQW9xcDl8ysLuOsN1G/rJ4v4rB3JErrsqy43XF61uKQ2ZI05A0/28n4ap6S5m0WI
	WppVFxHK9J7zR8yCzR2jq3PXFPz9GY1ezWFaFOVM/9EWPaOCUdmz4BuvgodBYLEkQ5ACkV9
	G5WCK/0jNEsZ5EpEMl
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Hello,

I want you know that need backport ("bpf: drop kthread_exit from noreturn_deny"),
which commit 7fe44c4388146bdbb3c5932d81a26d9fa0fd3ec9 upstream,
or will met "WARN: resolve_btfids: unresolved symbol kthread_exit" to cause build fail,
I test v6.18.19-rc1 with the patch build ok for me.

BRs
Wentao Guan

Log:
 AR      drivers/gpu/built-in.a
  AR      drivers/built-in.a
  AR      built-in.a
  AR      vmlinux.a
  LD      vmlinux.o
  GEN     .vmlinux.objs
  MODPOST Module.symvers
  CC      .vmlinux.export.o
  UPD     include/generated/utsversion.h
  CC      init/version-timestamp.o
  KSYMS   .tmp_vmlinux0.kallsyms.S
  AS      .tmp_vmlinux0.kallsyms.o
  LD      .tmp_vmlinux1
  BTF     .tmp_vmlinux1.btf.o
  NM      .tmp_vmlinux1.syms
  KSYMS   .tmp_vmlinux1.kallsyms.S
  AS      .tmp_vmlinux1.kallsyms.o
  LD      .tmp_vmlinux2
  NM      .tmp_vmlinux2.syms
  KSYMS   .tmp_vmlinux2.kallsyms.S
  AS      .tmp_vmlinux2.kallsyms.o
  LD      vmlinux.unstripped
  BTFIDS  vmlinux.unstripped
WARN: resolve_btfids: unresolved symbol kthread_exit
