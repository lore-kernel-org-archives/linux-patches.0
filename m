Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052028;
	b=WZ3eX24mTfKy69DS0MklSt3iTj7w+5Ii6gd1qzmWLddys6+GwXApGRuDGAn67gkDhgkL
	 0pvJd2XABU2RZj5pNQJPsK4QY6P0vyyOVg3vfULIKZFjneHneJvE6wsGs/rDvFF2Y16Od
	 PTXq2MXK6JZFqxaBLxEuitUvUfpmbuf3X3EoI3GSqU/UPc8qAk2xCH2rmITc6sj+oVtmM
	 5WABZIczBc+NxBo15Xy/0U102iBejlkMd2FcAKdwnzbpEPXuva5gG2/FVLtgFFo29EwW2
	 51c618Sq/eOFexMV+OmDyH4LBQUZZxIt9oeoAz3XUaWD2hSTIlt1Aj4ZqdpybFTq/eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ftfj3fVBsGNAh0N5s8X1YEWlqalVf733MABtbTLsdNY=;
	b=lBS8rGpAkxMSbOd4F/RdBfiZs5ZiKH06VmsQdc+zLNmy6NBAqJP57vvmqa7UjqKsLJG6
	 3LnLniSA1BFI+VfzuhHq8t8/H/gqVza8B5oJmguUnq0T+ON94dVZWSH1ixtFO/xZsEiCP
	 MV632VzKron+GYZZBdqvqzVAPPNWbxPiPK9QXmwZni07ZBsrYq+fs/5u0nswxnFgpFcmj
	 VXj5tJ5EOWvdfzfmgGGj4uHpv/hliomAMN5X/Gvqd4eph2UNF+TnpqqbJ3lBdIj07FxEn
	 hmIEqjOzwDyX7J8EdWkC0cDOZWs3/abXURAcXWL/PFrNeSC9mGZYUdyK3xv5GMYjRGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TncVwQIo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29405606A32A;
	Thu, 19 Nov 2026 01:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TncVwQIo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF291F000C4;
	Thu, 19 Nov 2026 01:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052027;
	bh=ftfj3fVBsGNAh0N5s8X1YEWlqalVf733MABtbTLsdNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TncVwQIoaO208r1YmhihcFZ54PwaKie6b2rxtqoEYtJJbanexZ7uRoDPVpmoebLP2
	 /aa94aL/njdrMotRx7B/b0upgEju6+lcxXwHvl0iUOAQZiukeedzy9Q9ES4/HFgznf
	 h5DotwOEaDE2jR9YQ2haDDKQb8Md7Z8XJBTXWWjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.15 0368/2214] KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form
Date: Wed, 18 Nov 2026 15:34:04 +0100
Message-ID: <20261118150025.423312156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


