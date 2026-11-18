Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035485;
	b=2UB7q5Qr8+jcZWi9uA9rbGAg8HHwSHqAJKLYayvTjQiGljGH+JzjPuVZH4tzJ5SSNwRy
	 6xZSUkNj3OXOQetojnvCwLPnz4hpfRfgL2UP+vOlxMkTueClCjkTQPWd8XnQ9E/ZzjC5Z
	 zxpMF6mre0YO/+7MEHjkKylI6yEnEIDB2zi99m0c27CYOwuM/gtj99tK97zcdeKSa5uOg
	 eqQH19QKmD5fvZufEbY5CFGV0ggoLdNCXUsfFSPaE9bmKrkN37EqYB/jfVjR3jJye6jw4
	 W6JTvtaQP0EAk0SLbDp+GmL1ygjmALorzRkXk9ZnIQLH4EDTNCPN7M7p5MA2NfwiDDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4XvU0XTjEtG1pcMgWqiocbNPHu+iqliVnVyl1Ng8JMI=;
	b=S21z6sIE+SHDIh2g+qAeJmO6xXeQoVEuaR/mOSRYZmfqSFXeFBm8jqaLmOASEf+H9M+l
	 hRAEvO+64QUFqB2d5qlZGrhaDSRplfJM4il6ecQ0LQbmz5rr58XNW2RlQ8gNJ5kUlh8as
	 RVmZqbYiwBFrxfuJYTP1aTBs7ZPZcTUbcjN8Q2Hiv+2Z3Ci5fdGE25rGa4l8r8uyvq1s6
	 JeYHRHAyEbsAS9lkjrUcuR7DAjKe3w83ZQ4dJcEQi7x772mw0MEkP4Zm5M0EkUroQH+fi
	 r1Sqr2VVo2r9cRfNW/alIAio+yAoir+SrIU/WGXUJtDIwZGz8bQZTTFMGgJSeeo5IlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KR0bGaqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3881E606A31C;
	Wed, 18 Nov 2026 20:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KR0bGaqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB931F000C4;
	Wed, 18 Nov 2026 20:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035485;
	bh=4XvU0XTjEtG1pcMgWqiocbNPHu+iqliVnVyl1Ng8JMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KR0bGaqGlmAFJ50mfwG6gVEGvYULN8brgxSqd2/7/EYo23HmJQRUZ4d2+XmCnh4YX
	 oozfgOVz6I774L4pGW2nhmlpGF17Frcx+edm8czXnBFrGKqU4VHBT8euinFk8E5u8L
	 Ot9I2hruE0KPl/D2S5/hdwIDV862YviOSRPl5fF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 0721/3318] KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form
Date: Wed, 18 Nov 2026 15:22:23 +0100
Message-ID: <20261118150340.122571446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


