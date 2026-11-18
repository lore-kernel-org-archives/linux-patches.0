Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060634;
	b=IY/Ehj1Yo541hkaH23QCz/i9Q+nu6dTPwooaNGvW8lQZN3Ir8WlAboJGR9pCYnvDaMfg
	 soqQG4Jkuqt/wNgfzXvyhZjcBUnuiZJCdp1/urni9eA/buKAbh3VOPspP1oAYAmGBoZCi
	 mPVJ0+1C0ImpaF3LWGb508K2AMCrGF/W7XQpf5RJj/M6TzS4ZeNPbctF3qAZc0AvlmZlX
	 tmMOPkj91v1eHAmah4QA2R+yc3P0M1ajnaQY1fXVze9Yf16BtIEMqR75PUs2om98vxkdC
	 KmIFjyBKMQgAjN9ObcWJW790ryFLz2Ukdd5s+8kqtL/4sFpIVWBYxSnRWEh4sTEsVlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OrAdEIlyEVz6RZsSOZwIeeamqdSfI67SINKgQHs7Um4=;
	b=qJJrlRwNk3SIlFPj6UmgZnrhcIfbrNBjkkv6CPYDB1KQa9adwGLJGTu5kXfhp3cCXllK
	 diFN/GooH8XDyGE199dvtWjBQD/kPNz6ToX7EP7TLO7J1sdTOTGJc8mqMj6IPGvQgnYbT
	 zWL3hlgghxzkfAAi/PSrLJdsjefCvM2rIBxoyXACA3Ua2qPwVKy7WwrT6f93+hTAp79g+
	 7fbKDWbQ/cCHDHHicDHvYuDgdZkp/84A0d7dRZ84fgm6a1svgJuVh1eBJspvvu5jTAqGO
	 cYVkaByEXY2ttPNZtHSTpVly77TrG7u1iytZ+PDVhQSqnMTAYMrYhujMvW3Pgkhc0GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncASa3df;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E225D606A338;
	Thu, 19 Nov 2026 03:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncASa3df
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC101F000C4;
	Thu, 19 Nov 2026 03:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060633;
	bh=OrAdEIlyEVz6RZsSOZwIeeamqdSfI67SINKgQHs7Um4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncASa3dfJaiTwDESmoMaAt1xP6pMqyXZlbHu2z1MA51YxyF1UxbeTBqIqEqCTtu7e
	 s0DLgHFq6W+6xICBkw2cUalb8SU28uDW8rD5aOk5o1RszeKPTpB/SynH2ndrag7LnF
	 /7UPnrW7n8Cxsk/TOCv4qfgfdg9NNM4SbQnxLiDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1242/1848] x86/svm: Avoid sign extension of SVM_EVTINJ_VALID in 64-bit expressions
Date: Wed, 18 Nov 2026 15:54:40 +0100
Message-ID: <20261118150011.828921354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit c5991239b148d40d4981901968b3a6a838ff517b ]

SVM_EVTINJ_VALID is defined as (1 << 31), i.e. as an int with the sign
bit set. Whenever it is used in a 64-bit expression the int is sign
extended, so bits 63:32 end up set as well. Two 64-bit users are
affected.

verify_exception_info() uses the macro as a mask against a 64-bit value
when it sanity checks hypervisor supplied exception information:

	u64 info = ghcb->save.sw_exit_info_2;
	...
	if ((info & SVM_EVTINJ_VALID) &&

The mask is 0xffffffff80000000, so the check also passes when any bit of
the error code in 63:32 is set while the valid bit itself is clear.

svm_vmgexit_inject_exception() builds the value that KVM hands to an
SEV-ES guest in GHCB SW_EXITINFO2:

	u64 data = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT | vector;

For vector == X86_TRAP_GP this yields 0xffffffff8000030d instead of
0x000000008000030d. The field uses the EVENTINJ format, which holds the
error code in bits 63:32, so KVM asks the guest to inject #GP with an
error code of 0xffffffff. Linux guests only consume the error code when
SVM_EVTINJ_VALID_ERR is set, which it is not here, so they are not
affected in practice, but the value KVM writes is not the one it intends.

Use BIT() instead, as is already done for most single bit definitions in
this header. Every other user applies the macro to a u32, where the
resulting bits are unchanged.

Opportunistically give SVM_EVTINJ_VALID_ERR the same treatment, there's
zero reason to open code BIT().

Fixes: 597cfe48212a ("x86/boot/compressed/64: Setup a GHCB-based VC Exception handler")
Fixes: c3392d0ab714 ("KVM: SVM: Provide helpers to set the error code")
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Link: https://patch.msgid.link/20260908053722.3917934-1-nagachaithanya9911@gmail.com
[sean: use BIT() for SVM_EVTINJ_VALID_ERR as well]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/svm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f8fad50502ad6..b6e48bfff0bb0 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -347,8 +347,8 @@ struct vmcb {
 #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
 
-#define SVM_EVTINJ_VALID (1 << 31)
-#define SVM_EVTINJ_VALID_ERR (1 << 11)
+#define SVM_EVTINJ_VALID	BIT(31)
+#define SVM_EVTINJ_VALID_ERR	BIT(11)
 
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
-- 
2.53.0



