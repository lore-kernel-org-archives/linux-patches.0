Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044754;
	b=tT4GyJdxnLJ+7+lAHrpL4XKRF2xhEb6Q5Qdttyu4FLLKIQFDwuNq+Iwa9anGAPGaoWfX
	 Qc0LncZS5LI46tKTmBEkAVazynPs66NhoLR2QY7s+JYY2236BANAmkOGMErxnFNHexyVG
	 i8ZVpVMi5bLOHNYdIX9hXkNXJrwquWs6/ROK7NDi/rf17wJB+jK97aYSfo7MO7PHRGeoT
	 NliOtr9DMC5sG98npj8/2aT6LPEQeaXfyIohdkoMkGC/mkx0mJmOjBt7nMC2vZZtMA0dw
	 hcjoYX+1miTGc6gWEmh0mH82VyaK5pBwZVqgsTei7rL3GcU/dfIN60QHBltIxpUTdjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eYXUGuV/1xwt1yAM5kemfo/ehK7kykSH+lt5RjssGnc=;
	b=wkvMasHejOoknF01uB+0IHeVQKn4Pgl1n0zOku9Yitfz5liXvWCntKcE7VzOPWrGsuOv
	 jgDej4kRnrT7tqXzcvvsHa8kFnQsllYjDz2FzaF1ykcVg8eVgf2e8QsE08zmOziniSFR1
	 OB5Cf8ojuvmidI3urMPWEF4baLJrQsMPWfXs3TO98f3zkXy+cw1yeHeFBFAzYRHTflAJZ
	 IqxSiMs95nxNeEMFPinFdxVfCm7Ue8dInP1wm08S0Urz2IhZHb8zw44LRf4e9hko1UU6a
	 a713LN9pn4n0a1p4zMRzp+2nr9qmUSdUuDDe8NgdqbM4IZzel0ryqPn2eIJG44kvn+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWZF0XLi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95003606A32C;
	Wed, 18 Nov 2026 23:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWZF0XLi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ADA1F000C4;
	Wed, 18 Nov 2026 23:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044754;
	bh=eYXUGuV/1xwt1yAM5kemfo/ehK7kykSH+lt5RjssGnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWZF0XLiv3fKOZfWeMbLxs/FSRZwvYry/GhJd2yRQim1oLituMoGJ87LVoZKWVHHR
	 v9t3lVj9FLP/HIwLANWbDnkEWTjrjC/mAAo5o+MbvEm1XbKVeGOTf8rIXTFsa2j2vY
	 /VFi8CRR5lFlr0u5bnN3y1G25XuuqNL4IryFcAfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 0629/2857] KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form
Date: Wed, 18 Nov 2026 15:27:43 +0100
Message-ID: <20261118150224.148192315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


