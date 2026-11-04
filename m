Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829157;
	b=39OlLzfNgGyWLGcZv/53u4iRUla7/7COW7spathjhKmNUTUY/EnxUCHYfNt5fmeHYrdF
	 ojXtGX/83i6vTSs/BBo/Ont+5Ikcm8q53dxLouA7vhqRD9LfaW+9QDvzMGqYY3B2zJgev
	 FUw8N+2tz3QUpcvnl5xTrOLsWa6hmao39Evj25KwKeOoyyDAToh8UTXENNcCbah4M480r
	 I7wJ7qdRGNlrO0f3WZpJ2pPQSB04wqh64q1m6vYpnkZhBr1R9he+231uoXUoQtRsw+3D+
	 xLq24ZV2mGPJ/aabdUkqHEDdAops2J/Gbz+qMnJUSxSxQk0QMgBEgY8SMsouo87WlPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ywVuNhK/giA2zsgttEVVwt31FE1L1UE1K897op5cavk=;
	b=W/05ZqA8dDO0OPPsMHmG8cLnTWkUKlKup/TxqNmlOMCfjuJ8wNKrA/pG7Uh89U5ZZzS5
	 2dUW/H3+Y0/xvwtTLBkNd0uD4C7BPK8gx8BqlCwwyEe90jcBGXrnlumhGPZAbld86rewD
	 PjEwio8l2hZjp3W8npLL9gxaI5OJFPUMCiM0WX3wULl5J65yjhuXhb+CwyPn4O5kgkxR8
	 4wMlFGE4Y7QTwXrZxAcThbKxypcDwU1IcktTZ/qjOgMI9SHZG0tYNBvnbL+gQjsCZG/JS
	 rMGIyf+bzlWxFY4fl1TuqSX+MnkJD0yyv1qOkznc2sKr5Cux3gC3VYAQe8rEPmQgGNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJ1TxRRU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD98607031A;
	Wed,  4 Nov 2026 21:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJ1TxRRU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CC61F000C1;
	Wed,  4 Nov 2026 21:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829157;
	bh=ywVuNhK/giA2zsgttEVVwt31FE1L1UE1K897op5cavk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJ1TxRRUQuVY/LfKXg3HlEhsVxiiiY+I2SZWwJ5tDt7ey+oQuLJ7q71uKIJRBhJXg
	 n9XVmCGmmu9WVQEtp2XpRxtVMM0JiaNtr4TwmWiU4i4aseMOYOyqJfVfJu2xfelsLj
	 6o0PctwumXMWEtN4Apy+GCGvkukaIjg1hRWDjYRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.3 482/547] KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form
Date: Wed,  4 Nov 2026 16:11:06 -0500
Message-ID: <20261104211052.070639203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Machhiwal <amachhiw@linux.ibm.com>

commit 31895b0ff96778b524c74b43a108090581271603 upstream.

get_d_signext() has two compounding bugs since its introduction in 2010:

1. The extraction mask 0x8FF silently drops bits 8-10 of the 12-bit D
   field (PPC ISA bits 21-23), corrupting any displacement that has any
   of those bits set.

2. The sign-magnitude idiom "-(d & 0x7ff)" is wrong for two's-complement:
   for D=0xFFC (encoding of -4) it returns -252 instead of -4.

Together these errors produce a wrong effective address for psq_l, psq_lu,
psq_st, and psq_stu whenever the displacement is negative or is a positive
value >= 0x100 with bits 8-10 set — essentially any real-world paired-
single stack-relative access.

The D field occupies the bottom 12 bits of the instruction word (confirmed
by the adjacent W and I extractions via inst_get_field(inst,16,16) and
inst_get_field(inst,17,19)). Replace the open-coded logic with the standard
sign_extend32(inst & 0xfff, 11), which correctly performs two's-complement
sign extension from 12 bits to 32 bits.

Fixes: 831317b605e7 ("KVM: PPC: Implement Paired Single emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260928122837.8782-4-amachhiw@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_paired_singles.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/powerpc/kvm/book3s_paired_singles.c
+++ b/arch/powerpc/kvm/book3s_paired_singles.c
@@ -479,12 +479,7 @@ static bool kvmppc_inst_is_paired_single
 
 static int get_d_signext(u32 inst)
 {
-	int d = inst & 0x8ff;
-
-	if (d & 0x800)
-		return -(d & 0x7ff);
-
-	return (d & 0x7ff);
+	return sign_extend32(inst & 0xfff, 11);
 }
 
 static int kvmppc_ps_three_in(struct kvm_vcpu *vcpu, bool rc,


