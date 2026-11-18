Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043782;
	b=Tzu2R6qYXyEwwF6imYHj4THRtUzvJH/58UL4ywaPxNe7eNmzMjOZQYsl8IrI3UUMI/UR
	 L9XTsb3t4yyHFdDiDFNQfKJBvRTSqeZM/9jHkYRqbbp0ame0aX+52Q9Vvjga/YXxQH4FP
	 wDBFuZ4JJP9Pi7x+6ZaAg5FXA7s1Dgk6S+8zwmL9+twTLIoVyoG/RwpPrgBnzJb4vwfV+
	 TdUYcdBq54MX4A4EmhB/C2Ow5VYFFQrqjHLTf7FMCsr8aPcaakuk/D/sKGu7JCwe8bfRn
	 TfSH9R2K9CGlMqZc3B18kR7CTwoYasLr+TYokWXBtPrlnj/DDD/0nO394HNdsvbGDzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5AXHG6bnF7zUeT6G6urbv/kEkWHXiVkFIRdFW6EbHB4=;
	b=ywRckMCt0QFs716/2SXqyRFT++4Tlpl7Y8jarly/8jPgMHX15tZ6ajLmaoXeVVisBDMY
	 HzUKE4wUno7k7FZxUbZuFsitywwBP3fiDdtuJPmj0aMttqSe9aSvD9JrVgyGCiTVxEKts
	 J2OYPR/xJ3r2VHGDsdLsTh+mNIHOVQP5iDMU4ONwxNSpqfCFaAzHbynSlgN7OoKE4NSU+
	 DtI76eX1f/koQ1vNiLDUWU36fisNuoPfaxKxWVwPSyzXugQUDaUBZlLhbNizx142eWi6C
	 HHQzRuEPUuvHQZGHHjWH2kX+mc87BAPzx2RRNTyXX55FtS7E85AgKoLu9+3R0njVKgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yt65zCm1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E52606A325;
	Wed, 18 Nov 2026 23:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yt65zCm1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFF51F000C4;
	Wed, 18 Nov 2026 23:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043782;
	bh=5AXHG6bnF7zUeT6G6urbv/kEkWHXiVkFIRdFW6EbHB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yt65zCm1jUK/4LOvdc4nexb5u9XeglGqM9xPVngdQ65TKMBMxSGRpT7jgXnXq0ol7
	 6uGD4uTS9/igd2pehFjCnRtz63pvXUQSJWyXbnZff5Jo8D3rvwFwjGS5IZAvtH0ZDD
	 OIf6G4dzZTvNyoZUX72VE73O0XaT3iZdeRAFmIZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0334/2857] KVM: x86: Always initialize EFER reserved bits on vendor initialization
Date: Wed, 18 Nov 2026 15:22:48 +0100
Message-ID: <20261118150213.463686444@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit a4b8acd428ba3f03952ef309d7f438dbc357557b ]

EFER reserved bits are statically initialized, and do not reset if a
vendor module is re-loaded. For example, loading kvm_amd with nested=1
removes EFER.SVME (and potentially EFER.LMSLE) from the reserved bits.
Reloading kvm_amd with nested=0 does not add them back, allowing
userspace to set EFER.SVME with nested=0.

Re-initializing EFER reserved bits before configuring them on vendor
initialization.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713181020.2735367-4-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Reset efer_reserved_bits inline in kvm_arch_hardware_setup() in x86.c, since msrs.c and kvm_init_efer_bits() don't exist here, keeping the static initializer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index daa52c04630ac..0eab09da329f6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12443,6 +12443,12 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	kvm_init_pmu_capability();
 
+#ifdef CONFIG_X86_64
+	efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
+#else
+	efer_reserved_bits = ~((u64)EFER_SCE);
+#endif
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		return r;
-- 
2.53.0



