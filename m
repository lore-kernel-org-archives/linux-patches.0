Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590742;
	b=sNOqbaNA9gSlxCDHw6kC6uiEbL8yHFTSr/4TBw1ZW2yDkoCkiLuBwZTI7sW8qZjuNsBq
	 PZwtRL2fYWcuLu7t/IM6cUjoSAzHUUZUpHe97e3XgotzkJx4sTi1VZQdeNmxpPTo+Vs8c
	 qBvhpfAXxMPJfbwPDKraCw30eZpGezTf/PNGGFLl3EIlHh4l/2NijvoJf/lJVrW0GYxmM
	 to3D0PibYLlefM7Pl4RVZ7Y9aOcTFVGDBtGqp/A9jC+dQWJ14FeC5gAnjjYXhryqUelw2
	 EWIJzBdoKJmt899jridYn5Q23Ye53U4Sgfkb4z2Kh6KUvBDYFOHyB6UWogPyyYMV+UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CRnEI0JvMNKmzoMBSGHLPWku9dIL5axSbFnuGAb0T6g=;
	b=RsVExFeeOiBqiXz6ZN7j0tsHN4ZMWPoEV8pb3br4e0XrryoMX56b95vaT614I+gCyMFh
	 rOeJNANzlL9jYsntK0/cvSa2NRQho2CL5E+x7ZvyY0uVz5RVrKEX3d3uSuAYk7zX8XGeY
	 MrisoB5YQ47h1pTJfjsH1FMUmHJ4C4dyzrCZnmEegvOWPvbCAS9SBQwCbqUIT6Mn8Dqxd
	 S6NgY31K1YctqqVy93oHPNsIEKQd9+yLg2ubOl78cU5rXzaZ6ifXsOGWEMWrm5y63/I81
	 DkkHV13I57kvm0R0oxyVhFwS0J6gFLQqrOmukUmUbF8TGvp+cTjCzCz24LnuHpMgSfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzbQfTcP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0823607B5A3;
	Fri, 13 Nov 2026 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzbQfTcP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8321F000CB;
	Fri, 13 Nov 2026 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590742;
	bh=CRnEI0JvMNKmzoMBSGHLPWku9dIL5axSbFnuGAb0T6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzbQfTcPtlCwrWuKpvOaKviYnvSGUCtSi0COzaWxNUe4bBtwtIwkvSZYx21M7Mt8f
	 i8B3Be4AqauX9UZiC/n5T5s8TWEk7JbdoFXqLUojt1EZnV4OlqtD5XnL6wHCk14SUQ
	 BFrrLA88mx1ygAeOVcJ/45QBpORSa1Nrtu5sdF2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 643/686] arm64/gcs: release GCS on failed fork
Date: Fri, 13 Nov 2026 10:52:56 -0500
Message-ID: <20261113153843.577088251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

[ Upstream commit 078e122f3bf000dd45965997b66deac10ee580fa ]

copy_thread() can map a CLONE_VM GCS and still return 0. A later
copy_process() failure calls exit_thread(), but arm64 did not
implement it, so the VMA stayed in the parent's mm. Wire
HAVE_EXIT_THREAD to gcs_free().

Kernel threads created with CLONE_VM (io_uring and vhost workers)
inherit the parent's gcs_base/gcs_size from arch_dup_task_struct()
without allocating their own GCS. When such a thread exits,
exit_mm() -> mm_release() -> deactivate_mm() -> gcs_free() unmaps the
parent's GCS. With the new exit_thread(), a failed copy_process() for
one of these threads would do the same. Clear these fields in
copy_thread().

Fixes: 506496bcbb42 ("arm64/gcs: Ensure that new threads have a GCS")
Cc: stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Assisted-by: LLM
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ sashal: Placed exit_thread() before the existing erratum helper conditional block. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig          |  1 +
 arch/arm64/kernel/process.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2e567a7d89c9b..66b7284ce751d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -222,6 +222,7 @@ config ARM64
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI
 	select HAVE_BUILDTIME_MCOUNT_SORT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_EXIT_THREAD
 	select HAVE_GUP_FAST
 	select HAVE_FTRACE_GRAPH_FUNC
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 4c328b7c79ba3..b3cde5f60b00f 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -319,9 +319,18 @@ static int copy_thread_gcs(struct task_struct *p,
 	return 0;
 }
 
+static void gcs_reset_thread(struct task_struct *task)
+{
+	task->thread.gcs_base = 0;
+	task->thread.gcs_size = 0;
+	task->thread.gcspr_el0 = 0;
+}
+
 #else
 
 static void flush_gcs(void) { }
+static void gcs_reset_thread(struct task_struct *task) { }
+
 static int copy_thread_gcs(struct task_struct *p,
 			   const struct kernel_clone_args *args)
 {
@@ -340,6 +349,12 @@ void flush_thread(void)
 	flush_gcs();
 }
 
+void exit_thread(struct task_struct *tsk)
+{
+	/* Failed fork after copy_thread(); deactivate_mm() does not run. */
+	gcs_free(tsk);
+}
+
 #ifdef CONFIG_ARM64_ERRATUM_4193714
 
 static void arch_dup_tlbbatch_mask(struct task_struct *dst)
@@ -537,6 +552,8 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 		p->thread.cpu_context.x19 = (unsigned long)args->fn;
 		p->thread.cpu_context.x20 = (unsigned long)args->fn_arg;
+		/* Kernel threads sharing the parent's mm must not free its GCS. */
+		gcs_reset_thread(p);
 
 		if (system_supports_poe())
 			p->thread.por_el0 = POR_EL0_INIT;
-- 
2.53.0



