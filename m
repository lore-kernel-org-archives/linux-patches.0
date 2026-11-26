Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704886;
	b=AgtN+H313j2wEOpepKWFJcjATzd3RmGe9Wa0p+J7bM7xMIlskAdnLvzhmxgb/EMBlrdg
	 oYgrw4DhrJgCUbDjoYVoYJdO8y+Lp3Yy3+RWRJPvAHpxF1kNO7XLsIbSids8l92HDBsM8
	 7DlTBpjme3Ao5firSDbyd30+2ggLpoBCZ/jTel4NxfgpI4VKaOkSfFi9irGvcn7z864y7
	 jP1+ZSeIRg3BIzqdc3yEOKfmT2ZIzHg7dezenRAexiFhjlTkRk1Fdz4uduso5c1+yK9iD
	 05m2MGFxCLharr222NNvll6aLVi2j27Td5PQqfgV9nhvIdRZ/SRHM/jc3AzdngI1rOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RHiA0cmv2YOkpCVVGb51ZnfJyTwaAiCCyFSrIKtkc18=;
	b=C9EAdM07yNSQTLHZdsawOSJKfZoLqBdiFQnjHexkbbjwx0tlg/ygW3tWapmG0AAaBacG
	 dgxoHrzKLfNVOrRlhO2bNrb/xrRNSqFamTqGXP9mtdWctbIQZlXtsw35ZhpCFWrUGzEJZ
	 wYPgrvYucuJlt6+NDvGlP0PwMbkvg+sp8h6Yl1woAfm3OQZkMWtsVsCOjP9n9l9MCXRsu
	 q1jdjfwswq+3udCX93ApS5afU42KrFOt4Dk9tjj7T5HIZpPFolX/RUnLj4cieMaiomVZD
	 abuv57xMJ24Tx79JZc6VUa/VPKPWkNnlHajtqrqT0EOb3meloFFQbXxWr/i5VOahJcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGBOBUd9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBF5606A332;
	Thu, 26 Nov 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aGBOBUd9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47EF1F000E0;
	Thu, 26 Nov 2026 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704886;
	bh=RHiA0cmv2YOkpCVVGb51ZnfJyTwaAiCCyFSrIKtkc18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGBOBUd9onsypGaOVpd2ID5+6XTTavPbW5ZGZZxPUVZluL0Bt3KBmYGIspe0OEW6A
	 H3l89539HRn6Lpgc6LrvtwzwkON4snFfWo6UtTb6CvPvKrImQxKd89pZ5EfiH9hio4
	 tl147c/MBIiqLQ/mDtxx54sbYdo0DPtlOItDO26o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BoBppy <inkxiao12@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/319] bpf: Drop inet_conn_established from lsm sleepable hooks
Date: Thu, 26 Nov 2026 15:36:18 +0100
Message-ID: <20261126144006.973354664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

The backport of commit beaf0e96b1da ("bpf: Drop task_to_inode and
inet_conn_established from lsm sleepable hooks") to this tree removed
only bpf_lsm_task_to_inode from sleepable_lsm_hooks.
bpf_lsm_inet_conn_established is still listed there, although the hook
is called from softirq context and cannot be used by sleepable LSM
programs.

Remove it too, which completes the backport.

Fixes: 452a927cddcd ("bpf: Drop task_to_inode and inet_conn_established from lsm sleepable hooks")
Reported-by: BoBppy <inkxiao12@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 07be0ecfd020d..ba14e8f76eb70 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -148,10 +148,6 @@ BTF_ID(func, bpf_lsm_file_lock)
 BTF_ID(func, bpf_lsm_file_open)
 BTF_ID(func, bpf_lsm_file_receive)
 
-#ifdef CONFIG_SECURITY_NETWORK
-BTF_ID(func, bpf_lsm_inet_conn_established)
-#endif /* CONFIG_SECURITY_NETWORK */
-
 BTF_ID(func, bpf_lsm_inode_create)
 BTF_ID(func, bpf_lsm_inode_free_security)
 BTF_ID(func, bpf_lsm_inode_getattr)
-- 
2.53.0



