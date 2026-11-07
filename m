Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061772;
	b=mGqRsD5uXObea8u1CO1FyKlKhlanJFCFNK7OGUwntv+qbvKUz2nG/FvdQ4rftt6EOs2R
	 3ckix+xv0vfnh8teYhG0L6p2shzVvheRMBpG7C3uzIHxE1W2mStILXxN8s9qeNs+eoyr0
	 +Zcvi6zv02ZWA8E4ldqcwyH7+hdNXA+mw6iLAK6o/ZLIo7jsCz+MkNY4ySJJsyLTnM+lB
	 W7pb85Fo/6zjWsna/WANIeC1DMGpt1HhO+E35DAqDMZ/Rn1r0Hd7NJjZuvVMLneSTebLQ
	 M1KXNqcbfQmIhwTkSf+cJ1fJOe7ApPQlvCjbYCySwRIoqaBO2R4QeNNhxSjRvqC4SCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wsNhwjKZpyPo6aDFRc5CZv/6K7uCH1PEUgwJIHd2uEA=;
	b=RhP0zu8UI/uHG08Eu2CwPkKIm2JbWN2sGLOffuQKz70tPMwxsETT5QUNCa/fvmjxZ/lq
	 pw15aK5Y4OctglkgJkVnNSqKkhTELJBArahZ/L+XB5C0ehknV0Z0f1y/1ViZGyWb9IaSt
	 ClWPkDm7TjUq02e5NRdIQfzjS/6z8G8bScqtyjMjYEBcZNsof9spFXeXA15JDq23728kd
	 g56vxT/BSRBTCDw8K2W729AO6R5wSBLYNwT+flnlCz79a/5ybbpOrFpY92vvwy7y+YnKG
	 VgzyJCvO8gps2M79HYEdYQxDy9cbbBo58Ir25zSs/s3JoQnGgNJVMtCO/ibIkMHDhAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCSbHJE4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3684606A32D;
	Sat,  7 Nov 2026 14:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCSbHJE4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF611F0089F;
	Sat,  7 Nov 2026 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061771;
	bh=wsNhwjKZpyPo6aDFRc5CZv/6K7uCH1PEUgwJIHd2uEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCSbHJE4oX9gZrrNgLPUstlcqWwRWf248vmc0zMezo6Zv7V2B4icv5XrckBvk00Cp
	 BtdzfCWBhRbojkMbfGoNsq8r9TrctW5A2MIWFqygUdOcZp+92eoG57vw7CrZgnfbUs
	 EBbFMp6yZEBKVsRl+6NiTYSe0Yr6A03c7jB3Iqro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 0805/1536] KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form
Date: Sat,  7 Nov 2026 08:47:01 -0500
Message-ID: <20261107135020.156390356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


