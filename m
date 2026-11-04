Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829188;
	b=zihiB8G2sOTrcMY+9n1RREbJi1AwSSLTW7FDF4KJU1STVq3NM5mv8Qkju1mSdMXJ0Zqy
	 NIBq+UKWVoCqe3R6qbW/IjAktZ5M16/E5rj4pLR4FeLoCBpxFvfqe8cDDuE6LvjQl85XU
	 j1QkVhnlzbcqvQ94UVMENJj92s4EUsvwMYwubZJ6Spf4cZvMBUe9Tsok8YAssn606/dFz
	 4fk6p4pNdogTpXqH09FRMNh+5RB2MP1Yc9ymU3SlSdgo7QCdPBc1ghKX8tDVeqedVFB4n
	 l116G2hbeQuX09dnEkQLUwE0kwIlXQmUn+QZdJdY+BrcIYbMNefzDpogpBdc6STAYBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Fu0SNZ4yXvJ58xR3jg+i5J22Om85FhJ+fM5dZUB4KQ=;
	b=3iBcd1Id0h6mk+3yx0XsCKGtxoxaPag+5IzvUFE7phYyF0BKlxnRdirDnPRYFW1eSzSU
	 DkkqqZCEnDxW2MI2CsxPIgqeo3hgKElozya/0Ob7j7jQiyQUQXltzE4bfzgIlGx5IXejG
	 amRW2USL5ZHSpzXyNhTp1XMRqD8g6+6UsCtpl6n2aPLue4YMVXx79NsQSpVN9GMpQyicm
	 u4yLuKtHcWj8ZDZGmkIXsamMptHtFtj6FcrXJGrz9mRJMUTDCndjr7MwsUuhR7sO6JaTQ
	 MnXTEKzgaeGFfRYtgDPd2nWT0euFCZ7QXRh9GHDig4UODyJqQ3T+2i6l0SvSEEJaEgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BY/Xr6Th";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72609606D806;
	Wed,  4 Nov 2026 21:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BY/Xr6Th
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF651F0093A;
	Wed,  4 Nov 2026 21:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829188;
	bh=/Fu0SNZ4yXvJ58xR3jg+i5J22Om85FhJ+fM5dZUB4KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BY/Xr6ThfvnblGvMkxt0AIhhk2qfUtsKzsc8VKEbuyGldLQZ9ypQxKPEVRcwf3TQh
	 EiZyB9uC+e93+XoYJLtsTHnN6qu+pYVDl5F94J74TE6uNn7MnWaBMJxDthfBkdO4ge
	 6zL5UhphL84Hdi9cMMst4cxlNJRf/TqkEtwy6wlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 475/547] KVM: TDX: Stuff exit_reason with UNDEFINED on wait_for_sept_zap return
Date: Wed,  4 Nov 2026 16:10:59 -0500
Message-ID: <20261104211051.857923252@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit e5f1d62c59aea4f270773de1bf6e8867f5b1124c upstream.

Forcefully update the exit_reason to KVM's "standard" EXIT_REASON_UNDEFINED
if tdx_vcpu_run() bails without trying to run the vCPU because KVM needs to
wait for an in-progress S-EPT zap to complete.  This avoids handling the
previous exit multiple times due to a stale exit_reason.

Fixes: 4b2abc49712b ("KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-6-xiaoyao.li@intel.com
[sean: use EXIT_REASON_UNDEFINED, drop comment about bits 31:16]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1081,8 +1081,16 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu
 	 * allowing vCPU entry to avoid contention with tdh_vp_enter() and
 	 * TDCALLs.
 	 */
-	if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
+	if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap))) {
+		/*
+		 * The vCPU never entered the guest, but this looks like a
+		 * handled exit to the caller.  Synthesize an invalid exit
+		 * reason so the previous exit's stale value isn't consumed
+		 * a second time.
+		 */
+		vt->exit_reason.full = EXIT_REASON_UNDEFINED;
 		return EXIT_FASTPATH_EXIT_HANDLED;
+	}
 
 	trace_kvm_entry(vcpu, run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT);
 


