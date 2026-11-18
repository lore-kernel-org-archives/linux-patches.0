Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035479;
	b=dSNPgkvpuqLPPBU2QFNqmsT+NdVnjDFUKzDM9e062VXMJo/2DRyQRansXrroGev4szZK
	 lB+UuXvNL8NYS5gPw3KTmFPs+87YmQdPZaPsTJYIolPRbCC3svYeHhyC4xJjBxAKgFTci
	 0BIOuyESsqyyGcccl8vDRLHJFZis9SosUArhNW6lxARZQyMnInl8H7gHPTYvY+wRr5CKi
	 AZdNZo70uIJYG62Ou5EpPvzEcfqwnwEjEhWQNmUMco3qN8RmcS5DtZ1dpmBK4YUur2DU8
	 8AIEbOCF5WycWHZNLmTvtFPsbB1uzuh/RYn7ZD/KHOM0E2WHgA5lVG+FDGbDXa3lHhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rCpY6BmGC3Cjhl9T/wDkxGt75M2+ENfPB+zwQGChUGs=;
	b=g/QDJyj0Txs1KkiZhU6NGAFBKvIRmaEO+i+TL10ps76vLpnRYU1+hTiZ3756vBWtAzjX
	 d3MUt/kMESUpCTY9WgZAn8fIin/rn/L+l/HZxIG8f6CcOCanxsg8gbbKbePnY8pj7h7Oq
	 v0gcZGzmv/7wbbIVnzAPdvBASMjoLLZntkUcLMF5bRtUr3sSjLGNGgo6UZ/7gBsAMb39B
	 o136n0VrY0Qv10926wRTH8O0yPtauRfP5Nf8Ok1yJfr6RFTUEwQlElS6u3oDYrPR6WHrI
	 UCTzNMaDN7r8jS3jdUDatsMDitWDttcfrUSYybGwdAJlTeaS2hijxc4ixK3NtQSGc+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cdvw3/58";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2E606A31C;
	Wed, 18 Nov 2026 20:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cdvw3/58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132C01F000C5;
	Wed, 18 Nov 2026 20:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035479;
	bh=rCpY6BmGC3Cjhl9T/wDkxGt75M2+ENfPB+zwQGChUGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cdvw3/584rrjuEwPJrlkOXnCden9oDC2fWb7SZcbiyB2ba4xBJuv3RAyD4Judn1U4
	 aWtzcaq9sNbfVb8dZOdZbuZrbvp8YcSPEf5fcSqOszHtK/CRVSMKGsqbQd457h7nHb
	 Y0vZlF3WwZ/OL6Io4m2fnszCltCguFJqCBqEWB24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 0719/3318] KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak
Date: Wed, 18 Nov 2026 15:22:21 +0100
Message-ID: <20261118150340.046902392@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 2616f497506a772db53e7bb1024cde50b4c165e0 upstream.

Ensure all reserved flags are zeroed when setting the msg_pending flag as
part of SynIC message delivery, as setting only msg_pending can leak seven
bits of kernel stack data to the guest.  E.g. gcc typically uses a
bitwise-OR to set the msg_pending flag, without initializing the on-stack
variable.

Precisely zero the flags, e.g. as opposed to zeroing the entire structure,
to make it somewhat more obvious that the flags *need* to be zeroed.  E.g.
it would be quite easy to misread the initial read of guest memory and
think that zeroing the entire structure is completely superfluous.

Fixes: 3a0e7731724f ("x86: kvm: hyperv: simplify SynIC message delivery")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://patch.msgid.link/20260826184449.814130-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -794,7 +794,9 @@ static int synic_deliver_msg(struct kvm_
 		if (no_retry)
 			return 0;
 
+		hv_hdr.message_flags.asu8 = 0;
 		hv_hdr.message_flags.msg_pending = 1;
+
 		r = kvm_vcpu_write_guest_page(vcpu, msg_page_gfn,
 					      &hv_hdr.message_flags,
 					      msg_off +


