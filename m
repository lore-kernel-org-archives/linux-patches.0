Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831215;
	b=MPACvGpAkg2C/5LDgAHE1bTg6564vvYnrUkXIPMJklYRRNu8CF68P7tbcyWjY6ElN+vm
	 t5Rs0lvRDhGgo9HON8qw2yb3GqN/uYnGrmur9MbVgELR2Kv759CfFa/6lx+9+7bz1DYkC
	 JWksKebWHLDnAYONt4+QGBjR0nuphUftwej8XSAThds4wUsQx6w87CrLR/NNQdJMdARcy
	 W+vbQVfTYEuMehZcbk3MLTtD2BnqL2JQmLbsqGCqwfpAi8Q9LFiFQPTzxgg1aCIJIzE65
	 ZJJ93i67jrlvL9vKXvoeON6G76wjrCkKDImfokR2YropPUEM582DOOAlWYWZIV7U+3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8GxoiBhQHMT0Ukcv/SU1iUnse+E+mldC7X5gYF6A6Mw=;
	b=lnoTx8/N2Ku1OiVTqWgE2RJSHfyucyyeupc+00DgDmP8JX7Z6c4QzZcosCIKhHDC1OYT
	 oCmRsF9bi98S2+TfCelrrlRsXNwV1HUYhUCbnOoNK+K7nL+j7gLZ5HusOXKG1hNrNZSpD
	 NKjiGbl/JcrB22kCJ4JJE4Tk/ZuuF+FtlAZUAuESrWDfn7VvLwCYorUsH3GBnr5hvJAN5
	 x3iwH8E+wkwxYT1eNyj/mHoXIo+w+LrKE5DdxLt225VtEsgJKKQ/1YxTFNtBMLqt5fvlh
	 0nXRPV6mI1qbiw1V7lQSKE5MqCrHXBzbTI4DvIsyHuanLtHuU80aVU2I9tSrR1rDVdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDhkWRw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3F2606A876;
	Wed,  4 Nov 2026 22:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDhkWRw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7F81F000C1;
	Wed,  4 Nov 2026 22:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831214;
	bh=8GxoiBhQHMT0Ukcv/SU1iUnse+E+mldC7X5gYF6A6Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDhkWRw70wGzyjuZen2DlWvQjOudppJkgE/Qefv9oo8dGLBCLmItzNZ2HAKj5l5hy
	 33m7jPIajuzG2EHqftbUV6P4mWjLS8IJpLgbNbHTEoIQ93H9kBQuNB2iQw9GbL5ilD
	 PjoiCVburKKqUZX7WS5qaFofUCA+Mh5IH22JUi+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0569/1005] LoongArch: KVM: Fix resource leak in kvm_loongarch_env_init() error path
Date: Wed,  4 Nov 2026 16:05:02 -0500
Message-ID: <20261104211059.814154874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit 910132bc7d72f26a8b288c2a38c32445a48d5be0 ]

kvm_loongarch_env_init() allocates the per-CPU kvm_context (vmcs) and
kvm_loongarch_ops, registers the perf callbacks, and then registers
the IPI/EIOINTC/PCH-PIC/DMSINTC KVM devices. If any of those device
registrations fails, the function returned the error directly, leaving
everything acquired so far in place: vmcs and kvm_loongarch_ops are
never freed, the perf callbacks stay registered, and all previously
registered KVM device operations remain registered. kvm_loongarch_init()
propagates the errors without calling kvm_loongarch_env_exit(), so
nothing else cleans up either.

Unwind the error path in reverse order of registration, so that each
failure only undoes what had actually been set up. Use the same helpers
in kvm_loongarch_env_exit() to remove the device registrations during
normal teardown as well.

Cc: stable@vger.kernel.org
Fixes: c532de5a67a7 ("LoongArch: KVM: Add IPI device support")
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
[ sashal: Dropped the DMSINTC registration, its error label and its exit-time unregister call, since this tree has no DMSINTC device, so the unwind covers only IPI, EIOINTC and PCH-PIC. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/main.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 5af8fb2bad1e2..91d4827d7f648 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -376,21 +376,40 @@ static int kvm_loongarch_env_init(void)
 	/* Register LoongArch IPI interrupt controller interface. */
 	ret = kvm_loongarch_register_ipi_device();
 	if (ret)
-		return ret;
+		goto err_env;
 
 	/* Register LoongArch EIOINTC interrupt controller interface. */
 	ret = kvm_loongarch_register_eiointc_device();
 	if (ret)
-		return ret;
+		goto err_ipi;
 
 	/* Register LoongArch PCH-PIC interrupt controller interface. */
 	ret = kvm_loongarch_register_pch_pic_device();
+	if (ret)
+		goto err_eiointc;
+
+	return 0;
+
+err_eiointc:
+	kvm_loongarch_unregister_eiointc_device();
+err_ipi:
+	kvm_loongarch_unregister_ipi_device();
+err_env:
+	kvm_unregister_perf_callbacks();
+	kfree(kvm_loongarch_ops);
+	kvm_loongarch_ops = NULL;
+	free_percpu(vmcs);
+	vmcs = NULL;
 
 	return ret;
 }
 
 static void kvm_loongarch_env_exit(void)
 {
+	kvm_loongarch_unregister_pch_pic_device();
+	kvm_loongarch_unregister_eiointc_device();
+	kvm_loongarch_unregister_ipi_device();
+
 	if (vmcs)
 		free_percpu(vmcs);
 
-- 
2.53.0



